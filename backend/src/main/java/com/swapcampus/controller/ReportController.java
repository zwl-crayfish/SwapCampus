package com.swapcampus.controller;

import com.swapcampus.dto.ApiResponse;
import com.swapcampus.dto.ReportRequest;
import com.swapcampus.entity.Report;
import com.swapcampus.service.ReportService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 用户举报控制器
 */
@RestController
@RequestMapping("/api/reports")
@RequiredArgsConstructor
public class ReportController {

    private final ReportService reportService;

    @PostMapping
    public ApiResponse<Report> create(@Valid @RequestBody ReportRequest request, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Report report = reportService.createReport(userId, request);
        return ApiResponse.success("举报已提交，等待管理员处理", report);
    }
}
