package com.swapcampus.dto;

/**
 * AI 智能分类与定价建议 - 请求参数
 */
public class AiSuggestRequest {
    private String title;
    private Integer originalPrice;
    private Integer conditionLevel;

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Integer getOriginalPrice() { return originalPrice; }
    public void setOriginalPrice(Integer originalPrice) { this.originalPrice = originalPrice; }

    public Integer getConditionLevel() { return conditionLevel; }
    public void setConditionLevel(Integer conditionLevel) { this.conditionLevel = conditionLevel; }
}
