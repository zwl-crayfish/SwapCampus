package com.swapcampus.dto;

import jakarta.validation.constraints.NotBlank;
import lombok.Data;

/**
 * 用户举报请求
 */
@Data
public class ReportRequest {
    private String goodsUuid;
    private Long reportedUserId;

    @NotBlank(message = "举报原因不能为空")
    private String reason;

    private String description;
}
