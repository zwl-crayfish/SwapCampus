package com.swapcampus.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.ApiResponse;
import com.swapcampus.dto.PageQuery;
import com.swapcampus.entity.*;
import com.swapcampus.service.GoodsService;
import com.swapcampus.service.MessageService;
import com.swapcampus.service.UserService;
import com.swapcampus.repository.*;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import lombok.RequiredArgsConstructor;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
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
    private final MessageService messageService;
    private final ReportMapper reportMapper;
    private final GoodsMapper goodsMapper;
    private final OrderMapper orderMapper;
    private final UserMapper userMapper;
    private final GoodsImageMapper goodsImageMapper;

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
        data.put("pendingReviews", goodsMapper.selectCount(
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Goods>()
                        .eq(Goods::getStatus, 3)
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
     * 商品审核列表（含卖家信息）
     */
    @GetMapping("/goods/review")
    public ApiResponse<Map<String, Object>> getReviewGoods(PageQuery query) {
        Page<Goods> page = new Page<>(query.getPage(), query.getSize());
        com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Goods> wrapper =
                new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Goods>()
                        .eq(Goods::getStatus, 3)
                        .orderByDesc(Goods::getCreatedAt);
        Page<Goods> result = goodsMapper.selectPage(page, wrapper);

        // 补充卖家用户名和商品图片
        List<Map<String, Object>> records = new ArrayList<>();
        for (Goods g : result.getRecords()) {
            Map<String, Object> item = new HashMap<>();
            item.put("goods", g);
            User seller = userMapper.selectById(g.getSellerId());
            item.put("sellerName", seller != null ? seller.getUsername() : "未知");
            item.put("sellerId", seller != null ? seller.getStudentId() : "-");
            // 查询该商品的图片列表
            List<GoodsImage> images = goodsImageMapper.selectList(
                    new LambdaQueryWrapper<GoodsImage>()
                            .eq(GoodsImage::getGoodsUuid, g.getUuid())
                            .orderByAsc(GoodsImage::getSortOrder)
            );
            item.put("images", images);
            records.add(item);
        }

        return ApiResponse.success(Map.of(
                "records", records,
                "total", result.getTotal(),
                "page", result.getCurrent(),
                "size", result.getSize()
        ));
    }

    /**
     * 审核商品（通过/驳回）
     */
    @PutMapping("/goods/{uuid}/audit")
    public ApiResponse<Void> auditGoods(@PathVariable String uuid,
                                         @RequestParam Integer status,
                                         @RequestParam(required = false) String remark,
                                         Authentication auth) {
        Goods goods = goodsMapper.findByUuid(uuid);
        if (goods == null) {
            return ApiResponse.error(404, "商品不存在");
        }
        if (goods.getStatus() != 3) {
            return ApiResponse.error(400, "该商品不在审核状态");
        }
        Long handlerId = (Long) auth.getPrincipal();
        goods.setStatus(status); // 1=通过上架, 0=驳回下架
        goodsMapper.updateById(goods);

        // 向发布者发送系统通知
        String notificationContent;
        if (status == 1) {
            notificationContent = String.format(
                    "【系统通知】您发布的商品《%s》已通过管理员审核，现已正式上架展示！祝您交易愉快！",
                    goods.getTitle()
            );
        } else {
            notificationContent = String.format(
                    "【系统通知】很抱歉，您发布的商品《%s》未通过管理员审核，已被驳回。原因：%s\n您可以修改后重新提交。",
                    goods.getTitle(),
                    remark != null && !remark.isEmpty() ? remark : "不符合平台规范"
            );
        }
        messageService.sendMessage(0L, goods.getSellerId(), notificationContent, "SYSTEM", uuid);

        return ApiResponse.success(status == 1 ? "已通过审核" : "已驳回", null);
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

        // 获取商品信息用于通知内容
        Goods goods = goodsMapper.findByUuid(report.getGoodsUuid());
        String goodsTitle = goods != null ? goods.getTitle() : "该商品";

        // 举报成立 → 自动下架商品（无论当前状态，只要未删除就强制下架）
        if (status == 1 && goods != null && goods.getStatus() != -1) {
            goods.setStatus(0); // 0 = 下架
            goodsMapper.updateById(goods);
        }

        // 向被举报者（商品发布者）发送系统通知
        if (report.getReportedUserId() != null) {
            String notificationContent;
            if (status == 1) {
                notificationContent = String.format(
                    "【系统通知】您发布的商品《%s》经核实存在违规情况，已被管理员下架。如有疑问请联系客服。%s",
                    goodsTitle,
                    remark != null && !remark.isEmpty() ? "\n处理备注：" + remark : ""
                );
            } else {
                notificationContent = String.format(
                    "【系统通知】关于您发布的商品《%s》的举报已处理完毕，举报未成立，您的商品可正常展示。%s",
                    goodsTitle,
                    remark != null && !remark.isEmpty() ? "\n备注：" + remark : ""
                );
            }
            messageService.sendMessage(0L, report.getReportedUserId(), notificationContent, "SYSTEM", report.getGoodsUuid());
        }

        return ApiResponse.success("处理完成", null);
    }
}
