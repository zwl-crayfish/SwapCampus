package com.swapcampus.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

/**
 * 浏览历史
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("browse_history")
public class BrowseHistory {
    @TableId(type = IdType.AUTO)
    private Long id;
    private Long userId;
    private String goodsUuid;
    private LocalDateTime viewedAt;
}
