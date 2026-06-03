package com.swapcampus.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 商品图片
 */
@Data
@TableName("goods_image")
public class GoodsImage {
    @TableId(type = IdType.AUTO)
    private Long id;
    private String goodsUuid;
    private String url;
    private Integer sortOrder;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
