package com.swapcampus.dto;

import lombok.Data;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import jakarta.validation.constraints.Min;
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
    @Size(max = 50, message = "标题不能超过50个字")
    private String title;

    private String description;

    @NotNull(message = "价格不能为空")
    @DecimalMin(value = "0.01", message = "价格必须大于0")
    private BigDecimal price;

    private BigDecimal originalPrice;

    @NotNull(message = "成色不能为空")
    @Min(value = 1, message = "成色最低为1")
    @Max(value = 10, message = "成色最高为10")
    private Integer conditionLevel;

    private Integer isBargain = 0;

    @NotBlank(message = "交易方式不能为空")
    private String tradeMethod = "FACE";

    private String campusLocation;

    private List<String> imageUrls;  // 已有图片URL(编辑时)
}
