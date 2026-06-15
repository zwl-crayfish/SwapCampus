package com.swapcampus.service;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.PageQuery;
import com.swapcampus.entity.Goods;
import com.swapcampus.entity.Order;
import com.swapcampus.entity.User;
import com.swapcampus.repository.GoodsMapper;
import com.swapcampus.repository.OrderMapper;
import com.swapcampus.repository.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

/**
 * 订单服务
 */
@Service
@RequiredArgsConstructor
public class OrderService {

    private final OrderMapper orderMapper;
    private final GoodsMapper goodsMapper;
    private final UserMapper userMapper;
    private final MessageService messageService;

    /**
     * 创建订单
     */
    @Transactional
    public Order createOrder(Long buyerId, String goodsUuid, String tradeMethod,
                              String meetLocation, String meetTime) {
        Goods goods = goodsMapper.findByUuid(goodsUuid);
        if (goods == null) {
            throw new RuntimeException("商品不存在");
        }
        if (goods.getStatus() != 1) {
            throw new RuntimeException("商品已下架或已售出");
        }
        if (goods.getSellerId().equals(buyerId)) {
            throw new RuntimeException("不能购买自己的商品");
        }

        String uuid = IdUtil.fastSimpleUUID();

        Order order = Order.builder()
                .uuid(uuid)
                .goodsUuid(goodsUuid)
                .buyerId(buyerId)
                .sellerId(goods.getSellerId())
                .amount(goods.getPrice())
                .tradeMethod(tradeMethod)
                .meetLocation(meetLocation)
                .buyerConfirm(0)
                .sellerConfirm(0)
                .status(0)  // 待确认
                .build();

        orderMapper.insert(order);

        // 通知卖家：有新订单
        messageService.sendMessage(0L, goods.getSellerId(),
                String.format("【新订单通知】买家已下单购买您的商品《%s》，金额 ¥%s，请及时确认处理。", goods.getTitle(), goods.getPrice().toString()),
                "SYSTEM", goodsUuid);

        // 更新商品状态为已售出
        goods.setStatus(2);
        goodsMapper.updateById(goods);

        return order;
    }

    /**
     * 买家确认收货
     */
    @Transactional
    public Order buyerConfirm(String orderUuid, Long userId) {
        Order order = orderMapper.findByUuid(orderUuid);
        if (order == null || !order.getBuyerId().equals(userId)) {
            throw new RuntimeException("订单不存在或无权限");
        }

        order.setBuyerConfirm(1);
        if (order.getSellerConfirm() == 1) {
            order.setStatus(2);  // 双方确认，交易完成
            addCreditScore(userId, 2);
            addCreditScore(order.getSellerId(), 2);
            messageService.sendMessage(0L, order.getSellerId(),
                    "【交易完成】买家已确认收货，双方确认完毕，交易成功完成！感谢使用 SwapCampus。", "SYSTEM", order.getGoodsUuid());
        } else {
            messageService.sendMessage(0L, order.getSellerId(),
                    "【订单更新】买家已确认收货，请您也确认发货状态以完成交易。", "SYSTEM", order.getGoodsUuid());
        }
        orderMapper.updateById(order);
        return order;
    }

    /**
     * 卖家确认
     */
    @Transactional
    public Order sellerConfirm(String orderUuid, Long userId) {
        Order order = orderMapper.findByUuid(orderUuid);
        if (order == null || !order.getSellerId().equals(userId)) {
            throw new RuntimeException("订单不存在或无权限");
        }

        order.setSellerConfirm(1);
        if (order.getBuyerConfirm() == 1) {
            order.setStatus(2);  // 交易完成
            addCreditScore(userId, 2);
            addCreditScore(order.getBuyerId(), 2);
            messageService.sendMessage(0L, order.getBuyerId(),
                    "【交易完成】卖家已确认发货，双方确认完毕，交易成功完成！感谢使用 SwapCampus。", "SYSTEM", order.getGoodsUuid());
        } else {
            messageService.sendMessage(0L, order.getBuyerId(),
                    "【订单更新】卖家已确认发货/交付，请您确认收货以完成交易。", "SYSTEM", order.getGoodsUuid());
        }
        orderMapper.updateById(order);
        return order;
    }

    /**
     * 取消订单
     */
    @Transactional
    public void cancelOrder(String orderUuid, Long userId) {
        Order order = orderMapper.findByUuid(orderUuid);
        if (order == null) {
            throw new RuntimeException("订单不存在");
        }
        if (!order.getBuyerId().equals(userId) && !order.getSellerId().equals(userId)) {
            throw new RuntimeException("无权限操作");
        }

        order.setStatus(-1);
        orderMapper.updateById(order);

        // 通知对方订单已取消
        Long otherParty = order.getBuyerId().equals(userId) ? order.getSellerId() : order.getBuyerId();
        String role = order.getBuyerId().equals(userId) ? "买家" : "卖家";
        messageService.sendMessage(0L, otherParty,
                "【订单取消】" + role + "已取消该订单，商品已恢复上架。如有疑问请联系对方。", "SYSTEM", order.getGoodsUuid());

        // 恢复商品为上架状态
        Goods goods = goodsMapper.findByUuid(order.getGoodsUuid());
        if (goods != null) {
            goods.setStatus(1);
            goodsMapper.updateById(goods);
        }
    }

    /**
     * 买家评价
     */
    @Transactional
    public void reviewOrder(String orderUuid, Long buyerId, Integer rating, String review) {
        Order order = orderMapper.findByUuid(orderUuid);
        if (order == null || !order.getBuyerId().equals(buyerId)) {
            throw new RuntimeException("订单不存在或无权限");
        }
        if (order.getStatus() != 2) {
            throw new RuntimeException("订单未完成，无法评价");
        }

        order.setBuyerRating(rating);
        order.setBuyerReview(review);
        orderMapper.updateById(order);

        // 通知卖家：买家评价了
        String stars = "★".repeat(Math.max(0, Math.min(rating, 5)));
        messageService.sendMessage(0L, order.getSellerId(),
                "【买家评价】买家对您的商品给出了 " + rating + " 星评价（" + stars + "）" + (review != null && !review.isEmpty() ? "，评价内容：" + review : "") + "，您也可以对买家进行评价。", "SYSTEM", order.getGoodsUuid());
    }

    /**
     * 卖家评价买家
     */
    @Transactional
    public void sellerReviewOrder(String orderUuid, Long sellerId, Integer rating, String review) {
        Order order = orderMapper.findByUuid(orderUuid);
        if (order == null || !order.getSellerId().equals(sellerId)) {
            throw new RuntimeException("订单不存在或无权限");
        }
        if (order.getStatus() != 2) {
            throw new RuntimeException("订单未完成，无法评价");
        }

        order.setSellerRating(rating);
        order.setSellerReview(review);
        orderMapper.updateById(order);

        // 通知买家：卖家评价了
        String stars = "★".repeat(Math.max(0, Math.min(rating, 5)));
        messageService.sendMessage(0L, order.getBuyerId(),
                "【卖家评价】卖家对您给出了 " + rating + " 星评价（" + stars + "）" + (review != null && !review.isEmpty() ? "，评价内容：" + review : "") + "。", "SYSTEM", order.getGoodsUuid());
    }

    /**
     * 获取买家订单列表
     */
    public Page<Order> getBuyerOrders(Long buyerId, PageQuery query) {
        Page<Order> page = new Page<>(query.getPage(), query.getSize());
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<Order>()
                .eq(Order::getBuyerId, buyerId)
                .orderByDesc(Order::getCreatedAt);
        return orderMapper.selectPage(page, wrapper);
    }

    /**
     * 获取卖家订单列表
     */
    public Page<Order> getSellerOrders(Long sellerId, PageQuery query) {
        Page<Order> page = new Page<>(query.getPage(), query.getSize());
        LambdaQueryWrapper<Order> wrapper = new LambdaQueryWrapper<Order>()
                .eq(Order::getSellerId, sellerId)
                .orderByDesc(Order::getCreatedAt);
        return orderMapper.selectPage(page, wrapper);
    }

    /**
     * 获取订单详情
     */
    public Order getByUuid(String uuid) {
        return orderMapper.findByUuid(uuid);
    }

    private void addCreditScore(Long userId, int points) {
        User user = userMapper.selectById(userId);
        if (user != null) {
            user.setCreditScore(Math.min(100, user.getCreditScore() + points));
            userMapper.updateById(user);
        }
    }
}
