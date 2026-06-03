package com.swapcampus.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.ApiResponse;
import com.swapcampus.dto.PageQuery;
import com.swapcampus.entity.Order;
import com.swapcampus.service.OrderService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 订单控制器
 */
@RestController
@RequestMapping("/api/orders")
@RequiredArgsConstructor
public class OrderController {

    private final OrderService orderService;

    /**
     * 创建订单
     */
    @PostMapping
    public ApiResponse<Order> create(@RequestParam String goodsUuid,
                                      @RequestParam String tradeMethod,
                                      @RequestParam(required = false) String meetLocation,
                                      @RequestParam(required = false) String meetTime,
                                      Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Order order = orderService.createOrder(userId, goodsUuid, tradeMethod, meetLocation, meetTime);
        return ApiResponse.success("下单成功", order);
    }

    /**
     * 获取订单详情
     */
    @GetMapping("/{uuid}")
    public ApiResponse<Order> detail(@PathVariable String uuid) {
        Order order = orderService.getByUuid(uuid);
        if (order == null) {
            return ApiResponse.error(404, "订单不存在");
        }
        return ApiResponse.success(order);
    }

    /**
     * 买家确认收货
     */
    @PutMapping("/{uuid}/buyer-confirm")
    public ApiResponse<Order> buyerConfirm(@PathVariable String uuid, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Order order = orderService.buyerConfirm(uuid, userId);
        return ApiResponse.success("确认成功", order);
    }

    /**
     * 卖家确认
     */
    @PutMapping("/{uuid}/seller-confirm")
    public ApiResponse<Order> sellerConfirm(@PathVariable String uuid, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Order order = orderService.sellerConfirm(uuid, userId);
        return ApiResponse.success("确认成功", order);
    }

    /**
     * 取消订单
     */
    @PutMapping("/{uuid}/cancel")
    public ApiResponse<Void> cancel(@PathVariable String uuid, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        orderService.cancelOrder(uuid, userId);
        return ApiResponse.success("已取消", null);
    }

    /**
     * 评价订单
     */
    @PutMapping("/{uuid}/review")
    public ApiResponse<Void> review(@PathVariable String uuid,
                                     @RequestParam Integer rating,
                                     @RequestParam(required = false) String review,
                                     Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        orderService.reviewOrder(uuid, userId, rating, review);
        return ApiResponse.success("评价成功", null);
    }

    /**
     * 我的购买订单
     */
    @GetMapping("/buyer")
    public ApiResponse<Map<String, Object>> buyerOrders(PageQuery query, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Page<Order> page = orderService.getBuyerOrders(userId, query);
        return ApiResponse.success(Map.of(
                "records", page.getRecords(),
                "total", page.getTotal(),
                "page", page.getCurrent(),
                "size", page.getSize()
        ));
    }

    /**
     * 我的销售订单
     */
    @GetMapping("/seller")
    public ApiResponse<Map<String, Object>> sellerOrders(PageQuery query, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Page<Order> page = orderService.getSellerOrders(userId, query);
        return ApiResponse.success(Map.of(
                "records", page.getRecords(),
                "total", page.getTotal(),
                "page", page.getCurrent(),
                "size", page.getSize()
        ));
    }
}
