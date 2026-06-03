package com.swapcampus.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 商品实体
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("goods")
public class Goods {
    @TableId(type = IdType.AUTO)
    private Long id;

    private String uuid;
    private Long sellerId;
    private Long categoryId;
    private String title;
    private String description;
    private BigDecimal price;
    private BigDecimal originalPrice;

    /** 成色: 1-10 */
    private Integer conditionLevel;

    /** 是否接受议价 */
    private Integer isBargain;

    /** FACE面交, LOCKER邮件柜, BOTH */
    private String tradeMethod;

    private String campusLocation;
    private Integer viewCount;
    private Integer favoriteCount;

    /** -1已删除, 0下架, 1在售, 2已售出, 3审核中 */
    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
