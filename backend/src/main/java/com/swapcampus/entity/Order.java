package com.swapcampus.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 订单实体
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("orders")
public class Order {
    @TableId(type = IdType.AUTO)
    private Long id;

    private String uuid;
    private String goodsUuid;
    private Long buyerId;
    private Long sellerId;
    private BigDecimal amount;
    private String tradeMethod;
    private String meetLocation;
    private LocalDateTime meetTime;
    private Integer buyerConfirm;
    private Integer sellerConfirm;

    /** -1已取消, 0待确认, 1进行中, 2已完成, 3退货中 */
    private Integer status;

    private Integer buyerRating;
    private String buyerReview;
    private Integer sellerRating;
    private String sellerReview;
    private LocalDateTime completedAt;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
