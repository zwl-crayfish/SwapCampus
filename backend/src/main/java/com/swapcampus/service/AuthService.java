package com.swapcampus.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.swapcampus.dto.LoginRequest;
import com.swapcampus.dto.RegisterRequest;
import com.swapcampus.dto.TokenResponse;
import com.swapcampus.entity.User;
import com.swapcampus.entity.Wallet;
import com.swapcampus.repository.UserMapper;
import com.swapcampus.repository.WalletMapper;
import com.swapcampus.security.JwtTokenProvider;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;

/**
 * 认证服务
 */
@Service
@RequiredArgsConstructor
public class AuthService {

    private final UserMapper userMapper;
    private final WalletMapper walletMapper;
    private final PasswordEncoder passwordEncoder;
    private final JwtTokenProvider jwtTokenProvider;

    /**
     * 用户注册
     */
    @Transactional
    public TokenResponse register(RegisterRequest request) {
        if ((request.getPhone() == null || request.getPhone().isBlank())
                && (request.getEmail() == null || request.getEmail().isBlank())) {
            throw new RuntimeException("手机号或邮箱至少填写一项，用于学号实名防冒用核验");
        }

        // 检查学号是否已注册
        User existingStudent = userMapper.findByStudentId(request.getStudentId());
        if (existingStudent != null) {
            throw new RuntimeException("该学号已注册");
        }

        // 检查用户名是否已存在
        User existingUser = userMapper.findByUsername(request.getUsername());
        if (existingUser != null) {
            throw new RuntimeException("该用户名已存在");
        }

        User user = User.builder()
                .studentId(request.getStudentId())
                .username(request.getUsername())
                .password(passwordEncoder.encode(request.getPassword()))
                .realName(request.getRealName())
                .phone(request.getPhone())
                .email(request.getEmail())
                .role(0)
                .creditScore(80)
                .status(1)
                .build();

        userMapper.insert(user);

        Wallet wallet = new Wallet();
        wallet.setUserId(user.getId());
        wallet.setBalance(BigDecimal.ZERO);
        wallet.setPoints(0);
        walletMapper.insert(wallet);

        String token = jwtTokenProvider.generateToken(user.getId(), user.getUsername(), user.getRole());
        return buildTokenResponse(user, token);
    }

    /**
     * 用户登录
     */
    public TokenResponse login(LoginRequest request) {
        User user = userMapper.findByUsername(request.getUsername());
        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }
        if (user.getStatus() == 0) {
            throw new RuntimeException("账号已被禁用，请联系管理员");
        }
        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            throw new RuntimeException("用户名或密码错误");
        }

        String token = jwtTokenProvider.generateToken(user.getId(), user.getUsername(), user.getRole());
        return buildTokenResponse(user, token);
    }

    private TokenResponse buildTokenResponse(User user, String token) {
        return TokenResponse.builder()
                .accessToken(token)
                .tokenType("Bearer")
                .expiresIn(86400000L)
                .userId(user.getId())
                .username(user.getUsername())
                .realName(user.getRealName())
                .avatarUrl(user.getAvatarUrl())
                .role(user.getRole())
                .build();
    }
}
