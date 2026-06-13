package com.swapcampus.dto;

import lombok.Data;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

/**
 * 用户注册请求
 */
@Data
public class RegisterRequest {
    @NotBlank(message = "学号不能为空")
    private String studentId;

    @NotBlank(message = "用户名不能为空")
    @Size(min = 3, max = 20)
    private String username;

    @NotBlank(message = "密码不能为空")
    @Size(min = 6, max = 30)
    private String password;

    @NotBlank(message = "真实姓名不能为空")
    private String realName;

    private String phone;
    private String email;
}
