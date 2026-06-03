package com.swapcampus.controller;

import com.swapcampus.dto.ApiResponse;
import com.swapcampus.entity.User;
import com.swapcampus.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

/**
 * 用户控制器
 */
@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    /**
     * 获取当前用户信息
     */
    @GetMapping("/me")
    public ApiResponse<User> me(Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        User user = userService.getUserById(userId);
        return ApiResponse.success(user);
    }

    /**
     * 获取用户信息（公开）
     */
    @GetMapping("/{id}")
    public ApiResponse<User> profile(@PathVariable Long id) {
        User user = userService.getUserById(id);
        if (user == null) {
            return ApiResponse.error(404, "用户不存在");
        }
        return ApiResponse.success(user);
    }

    /**
     * 更新个人信息
     */
    @PutMapping("/me")
    public ApiResponse<User> updateProfile(@RequestBody Map<String, String> body,
                                            Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        User user = userService.updateProfile(userId,
                body.get("phone"),
                body.get("email"),
                body.get("avatarUrl"));
        return ApiResponse.success("更新成功", user);
    }
}
