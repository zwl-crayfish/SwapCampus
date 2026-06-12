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

import java.time.LocalDateTime;
import java.time.OffsetDateTime;
import java.time.format.DateTimeParseException;
import java.util.Locale;
import java.util.Set;

/**
 * 订单服务
 */
@Service
@RequiredArgsConstructor
public class OrderService {
    private static final Set<String> OFFLINE_TRADE_METHODS = Set.of("FACE", "PICKUP", "LOCKER");

    private final OrderMapper orderMapper;
    private final GoodsMapper goodsMapper;
    private final UserMapper userMapper;

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
        String normalizedTradeMethod = normalizeTradeMethod(tradeMethod);
        if (meetLocation == null || meetLocation.isBlank()) {
            throw new RuntimeException("请填写线下交易地点或校内自提点");
        }

        String uuid = IdUtil.fastSimpleUUID();

        Order order = Order.builder()
                .uuid(uuid)
                .goodsUuid(goodsUuid)
                .buyerId(buyerId)
                .sellerId(goods.getSellerId())
                .amount(goods.getPrice())
                .tradeMethod(normalizedTradeMethod)
                .meetLocation(meetLocation)
                .meetTime(parseMeetTime(meetTime))
                .buyerConfirm(0)
                .sellerConfirm(0)
                .status(0)  // 待确认
                .build();

        orderMapper.insert(order);

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
        ensureConfirmable(order);

        order.setBuyerConfirm(1);
        if (order.getSellerConfirm() == 1) {
            completeOrder(order);
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
        ensureConfirmable(order);

        order.setSellerConfirm(1);
        if (order.getBuyerConfirm() == 1) {
            completeOrder(order);
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
        if (order.getStatus() == 2) {
            throw new RuntimeException("已完成订单不能取消");
        }
        if (order.getStatus() == -1) {
            return;
        }

        order.setStatus(-1);
        orderMapper.updateById(order);

        // 恢复商品为上架状态
        Goods goods = goodsMapper.findByUuid(order.getGoodsUuid());
        if (goods != null) {
            goods.setStatus(1);
            goodsMapper.updateById(goods);
        }
    }

    /**
     * 评价订单
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

    private void ensureConfirmable(Order order) {
        if (order.getStatus() == -1) {
            throw new RuntimeException("订单已取消");
        }
        if (order.getStatus() == 2) {
            throw new RuntimeException("订单已完成");
        }
    }

    private void completeOrder(Order order) {
        order.setStatus(2);
        order.setCompletedAt(LocalDateTime.now());
        addCreditScore(order.getBuyerId(), 2);
        addCreditScore(order.getSellerId(), 2);
    }

    private String normalizeTradeMethod(String tradeMethod) {
        String method = tradeMethod == null ? "FACE" : tradeMethod.toUpperCase(Locale.ROOT);
        if ("BOTH".equals(method)) {
            method = "FACE";
        }
        if (!OFFLINE_TRADE_METHODS.contains(method)) {
            throw new RuntimeException("本项目仅支持线下面交或校内自提点交易");
        }
        return method;
    }

    private LocalDateTime parseMeetTime(String meetTime) {
        if (meetTime == null || meetTime.isBlank()) {
            return null;
        }
        try {
            return OffsetDateTime.parse(meetTime).toLocalDateTime();
        } catch (DateTimeParseException ignored) {
            try {
                return LocalDateTime.parse(meetTime);
            } catch (DateTimeParseException e) {
                throw new RuntimeException("交易时间格式不正确");
            }
        }
    }
}
