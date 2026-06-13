package com.swapcampus.entity;

import com.baomidou.mybatisplus.annotation.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

/**
 * 用户实体
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@TableName("users")
public class User {
    @TableId(type = IdType.AUTO)
    private Long id;

    private String studentId;
    private String username;
    private String password;
    private String realName;
    private String avatarUrl;
    private String phone;
    private String email;

    /** 角色: 0普通用户, 1管理员 */
    private Integer role;

    /** 信用分 0-100 */
    private Integer creditScore;

    /** 状态: 0禁用, 1正常, 2待审核 */
    private Integer status;

    @TableField(fill = FieldFill.INSERT)
    private LocalDateTime createdAt;

    @TableField(fill = FieldFill.INSERT_UPDATE)
    private LocalDateTime updatedAt;
}
