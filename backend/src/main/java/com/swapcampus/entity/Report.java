package com.swapcampus.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.Data;
import java.time.LocalDateTime;

/**
 * 举报实体
 */
@Data
@TableName("report")
public class Report {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long reporterId;
    private String goodsUuid;
    private Long reportedUserId;
    private String reason;
    private String description;

    /** 0待处理, 1已处理, 2已驳回 */
    private Integer status;

    private Long handlerId;
    private String handleRemark;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    private LocalDateTime handledAt;
}
