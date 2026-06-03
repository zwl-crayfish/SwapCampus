package com.swapcampus.dto;

import lombok.Builder;
import lombok.Data;

/**
 * JWT Token 响应
 */
@Data
@Builder
public class TokenResponse {
    private String accessToken;
    private String tokenType;
    private Long expiresIn;
    private Long userId;
    private String username;
    private String realName;
    private String avatarUrl;
    private Integer role;
}
