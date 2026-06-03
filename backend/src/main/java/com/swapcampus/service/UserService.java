package com.swapcampus.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.PageQuery;
import com.swapcampus.entity.User;
import com.swapcampus.repository.UserMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * 用户服务
 */
@Service
@RequiredArgsConstructor
public class UserService {

    private final UserMapper userMapper;

    /**
     * 获取用户信息
     */
    public User getUserById(Long id) {
        User user = userMapper.selectById(id);
        if (user != null) {
            user.setPassword(null);  // 不返回密码
        }
        return user;
    }

    /**
     * 更新用户信息
     */
    public User updateProfile(Long userId, String phone, String email, String avatarUrl) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        if (phone != null) user.setPhone(phone);
        if (email != null) user.setEmail(email);
        if (avatarUrl != null) user.setAvatarUrl(avatarUrl);
        userMapper.updateById(user);
        user.setPassword(null);
        return user;
    }

    /**
     * 管理员：获取用户列表
     */
    public Page<User> getUsers(PageQuery query) {
        Page<User> page = new Page<>(query.getPage(), query.getSize());
        Page<User> result = userMapper.selectPage(page, null);
        result.getRecords().forEach(u -> u.setPassword(null));
        return result;
    }

    /**
     * 管理员：禁用/启用用户
     */
    public void toggleUserStatus(Long userId, Integer status) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        user.setStatus(status);
        userMapper.updateById(user);
    }

    /**
     * 管理员：获取用户详情
     */
    public User getUserDetail(Long userId) {
        User user = userMapper.selectById(userId);
        if (user != null) {
            user.setPassword(null);
        }
        return user;
    }
}
