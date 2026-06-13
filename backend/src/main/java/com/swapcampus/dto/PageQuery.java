package com.swapcampus.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 分页查询参数
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PageQuery {
    private Integer page = 1;
    private Integer size = 10;
    private String keyword;
    private Long categoryId;
    private String sortBy = "created_at";
    private String sortOrder = "desc";
    private Integer status;
}
