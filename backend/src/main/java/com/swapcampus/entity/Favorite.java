package com.swapcampus.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 收藏
 */
@Data
@TableName("favorite")
public class Favorite {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String goodsUuid;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
