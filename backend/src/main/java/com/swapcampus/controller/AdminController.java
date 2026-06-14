package com.swapcampus.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.ApiResponse;
import com.swapcampus.dto.PageQuery;
import com.swapcampus.entity.*;
import com.swapcampus.service.GoodsService;
import com.swapcampus.service.UserService;
import com.swapcampus.repository.*;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

/**
 * 管理员控制器
 */
@RestController
@RequestMapping("/api/admin")
@RequiredArgsConstructor
@PreAuthorize("hasRole('ADMIN')")
public class AdminController {

    private final UserService userService;
    private final GoodsService goodsService;
    private final ReportMapper reportMapper;
    private final GoodsMapper goodsMapper;
    private final OrderMapper orderMapper;
    private final UserMapper userMapper;

    /**
     * 仪表盘数据
     */
    @GetMapping("/dashboard")
    public ApiResponse<Map<String, Object>> dashboard() {
        Map<String, Object> data = new HashMap<>();
        data.put("totalUsers", userMapper.selectCount(null));
        data.put("totalGoods", goodsMapper.selectCount(null));
        data.put("totalOrders", orderMapper.selectCount(null));
        data.put("pendingReports", reportMapper.selectCount(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Report>()
                        .eq(Report::getStatus, 0)
        ));
        return ApiResponse.success(data);
    }

    /**
     * 用户管理
     */
    @GetMapping("/users")
    public ApiResponse<Map<String, Object>> getUsers(PageQuery query) {
        Page<User> page = userService.getUsers(query);
        return ApiResponse.success(Map.of(
                "records", page.getRecords(),
                "total", page.getTotal(),
                "page", page.getCurrent(),
                "size", page.getSize()
        ));
    }

    /**
     * 用户状态管理
     */
    @PutMapping("/users/{id}/status")
    public ApiResponse<Void> toggleUserStatus(@PathVariable Long id, @RequestParam Integer status) {
        userService.toggleUserStatus(id, status);
        return ApiResponse.success("操作成功", null);
    }

    /**
     * 用户详情
     */
    @GetMapping("/users/{id}")
    public ApiResponse<User> getUserDetail(@PathVariable Long id) {
        User user = userService.getUserDetail(id);
        if (user == null) {
            return ApiResponse.error(404, "用户不存在");
        }
        return ApiResponse.success(user);
    }

    /**
     * 商品审核
     */
    @PutMapping("/goods/{uuid}/audit")
    public ApiResponse<Void> auditGoods(@PathVariable String uuid, @RequestParam Integer status) {
        Goods goods = goodsMapper.findByUuid(uuid);
        if (goods == null) {
            return ApiResponse.error(404, "商品不存在");
        }
        goods.setStatus(status);
        goodsMapper.updateById(goods);
        return ApiResponse.success("审核完成", null);
    }

    /**
     * 举报管理
     */
    @GetMapping("/reports")
    public ApiResponse<Map<String, Object>> getReports(PageQuery query) {
        Page<Report> page = new Page<>(query.getPage(), query.getSize());
        Page<Report> result = reportMapper.selectPage(page,
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Report>()
                        .orderByDesc(Report::getCreatedAt)
        );
        return ApiResponse.success(Map.of(
                "records", result.getRecords(),
                "total", result.getTotal(),
                "page", result.getCurrent(),
                "size", result.getSize()
        ));
    }

    /**
     * 处理举报
     */
    @PutMapping("/reports/{id}/handle")
    public ApiResponse<Void> handleReport(@PathVariable Long id,
                                           @RequestParam Integer status,
                                           @RequestParam(required = false) String remark,
                                           Authentication auth) {
        Long handlerId = (Long) auth.getPrincipal();
        Report report = reportMapper.selectById(id);
        if (report == null) {
            return ApiResponse.error(404, "举报不存在");
        }
        report.setStatus(status);
        report.setHandlerId(handlerId);
        report.setHandleRemark(remark);
        report.setHandledAt(java.time.LocalDateTime.now());
        reportMapper.updateById(report);
        return ApiResponse.success("处理完成", null);
    }
}
