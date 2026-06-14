package com.swapcampus.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.math.BigDecimal;
import java.util.List;

/**
 * 商品发布/编辑请求
 */
@Data
public class GoodsRequest {
    private String uuid;  // 编辑时需要

    @NotNull(message = "分类不能为空")
    private Long categoryId;

    @NotBlank(message = "标题不能为空")
    private String title;

    private String description;

    @NotNull(message = "价格不能为空")
    private BigDecimal price;

    private BigDecimal originalPrice;

    @NotNull(message = "成色不能为空")
    private Integer conditionLevel;

    private Integer isBargain = 0;

    @NotBlank(message = "交易方式不能为空")
    private String tradeMethod = "FACE";

    private String campusLocation;

    private List<String> imageUrls;  // 已有图片URL(编辑时)
}
