package com.swapcampus.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

/**
 * 即时通讯消息实体
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("message")
public class Message {
    @TableId(type = IdType.AUTO)
    private Long id;

    private String uuid;
    private Long senderId;
    private Long receiverId;
    private String goodsUuid;
    private String content;

    /** TEXT, IMAGE, SYSTEM */
    private String msgType;

    private Integer isRead;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;
}
