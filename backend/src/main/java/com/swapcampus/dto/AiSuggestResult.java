package com.swapcampus.dto;

import java.util.List;

/**
 * AI 智能分类与定价建议 - 返回结果
 */
public class AiSuggestResult {
    /** 推荐的分类名称列表 */
    private List<String> suggestedCategories;

    /** 价格区间 */
    private PriceRange priceRange;

    /** AI 的推理说明 */
    private String reasoning;

    /** 数据来源：LLM / LOCAL_FALLBACK */
    private String source;

    public List<String> getSuggestedCategories() { return suggestedCategories; }
    public void setSuggestedCategories(List<String> suggestedCategories) { this.suggestedCategories = suggestedCategories; }

    public PriceRange getPriceRange() { return priceRange; }
    public void setPriceRange(PriceRange priceRange) { this.priceRange = priceRange; }

    public String getReasoning() { return reasoning; }
    public void setReasoning(String reasoning) { this.reasoning = reasoning; }

    public String getSource() { return source; }
    public void setSource(String source) { this.source = source; }

    /**
     * 价格区间内部类
     */
    public static class PriceRange {
        private Integer min;
        private Integer max;
        private Integer suggested;

        public Integer getMin() { return min; }
        public void setMin(Integer min) { this.min = min; }

        public Integer getMax() { return max; }
        public void setMax(Integer max) { this.max = max; }

        public Integer getSuggested() { return suggested; }
        public void setSuggested(Integer suggested) { this.suggested = suggested; }
    }
}
