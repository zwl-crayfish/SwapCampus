package com.swapcampus.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.PageQuery;
import com.swapcampus.dto.ReportRequest;
import com.swapcampus.entity.Goods;
import com.swapcampus.entity.Report;
import com.swapcampus.entity.User;
import com.swapcampus.repository.GoodsMapper;
import com.swapcampus.repository.ReportMapper;
import com.swapcampus.repository.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * 举报处理服务
 */
@Service
@RequiredArgsConstructor
public class ReportService {

    private final ReportMapper reportMapper;
    private final GoodsMapper goodsMapper;
    private final UserMapper userMapper;

    @Transactional
    public Report createReport(Long reporterId, ReportRequest request) {
        if (request.getGoodsUuid() == null && request.getReportedUserId() == null) {
            throw new RuntimeException("被举报商品或用户至少填写一项");
        }
        if (request.getGoodsUuid() != null && goodsMapper.findByUuid(request.getGoodsUuid()) == null) {
            throw new RuntimeException("被举报商品不存在");
        }
        if (request.getReportedUserId() != null && userMapper.selectById(request.getReportedUserId()) == null) {
            throw new RuntimeException("被举报用户不存在");
        }

        Report report = new Report();
        report.setReporterId(reporterId);
        report.setGoodsUuid(request.getGoodsUuid());
        report.setReportedUserId(request.getReportedUserId());
        report.setReason(request.getReason());
        report.setDescription(request.getDescription());
        report.setStatus(0);
        reportMapper.insert(report);
        return report;
    }

    public Page<Report> getReports(PageQuery query) {
        Page<Report> page = new Page<>(query.getPage(), query.getSize());
        LambdaQueryWrapper<Report> wrapper = new LambdaQueryWrapper<Report>()
                .orderByDesc(Report::getCreatedAt);
        if (query.getStatus() != null) {
            wrapper.eq(Report::getStatus, query.getStatus());
        }
        return reportMapper.selectPage(page, wrapper);
    }

    @Transactional
    public void handleReport(Long id, Integer status, String remark, Long handlerId) {
        Report report = reportMapper.selectById(id);
        if (report == null) {
            throw new RuntimeException("举报不存在");
        }
        if (report.getStatus() != 0) {
            throw new RuntimeException("该举报已处理");
        }
        if (status == null || (status != 1 && status != 2)) {
            throw new RuntimeException("举报处理状态不合法");
        }

        report.setStatus(status);
        report.setHandlerId(handlerId);
        report.setHandleRemark(remark);
        report.setHandledAt(LocalDateTime.now());
        reportMapper.updateById(report);

        if (status == 1) {
            applyReportPenalty(report);
        }
    }

    private void applyReportPenalty(Report report) {
        if (report.getGoodsUuid() != null) {
            Goods goods = goodsMapper.findByUuid(report.getGoodsUuid());
            if (goods != null && goods.getStatus() != -1) {
                goods.setStatus(0);
                goodsMapper.updateById(goods);
            }
        }
        if (report.getReportedUserId() != null) {
            User user = userMapper.selectById(report.getReportedUserId());
            if (user != null) {
                int current = user.getCreditScore() == null ? 80 : user.getCreditScore();
                user.setCreditScore(Math.max(0, current - 10));
                userMapper.updateById(user);
            }
        }
    }
}
