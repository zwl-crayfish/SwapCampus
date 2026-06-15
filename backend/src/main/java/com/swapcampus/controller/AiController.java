package com.swapcampus.controller;

import com.swapcampus.dto.ApiResponse;
import com.swapcampus.dto.AiSuggestRequest;
import com.swapcampus.dto.AiSuggestResult;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.List;
import java.util.Map;

/**
 * AI 智能助手接口
 * 对接智谱 GLM-4-Flash 大模型，提供商品分类建议和智能定价
 */
@RestController
@RequestMapping("/api/ai")
public class AiController {

    private static final Logger log = LoggerFactory.getLogger(AiController.class);

    @Value("${ai.api-key:}")
    private String apiKey;

    @Value("${ai.api-url:https://open.bigmodel.cn/api/paas/v4/chat/completions}")
    private String apiUrl;

    @Value("${ai.model:glm-4-flash}")
    private String model;

    @Value("${ai.timeout:10}")
    private int timeoutSeconds;

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 系统提示词 — 约束 LLM 输出结构化 JSON
     */
    private static final String SYSTEM_PROMPT = """
            你是SwapCampus校园闲置物品交易平台的AI定价助手。
            根据用户输入的商品信息，给出合理的分类建议和价格区间。

            必须严格按以下JSON格式返回，不要输出任何其他内容（不要markdown代码块包裹）：
            {"suggestedCategories":["推荐分类1","推荐分类2"],"priceRange":{"min":最低价,"max":最高价,"suggested":建议价},"reasoning":"简要说明理由"}

            定价规则（严格遵守）：
            - 成色1(废品): 建议售价为原价的10%-20%
            - 成色2(较差): 原价的25%-35%
            - 成色3(可用): 原价的40%-50%
            - 成色4(一般): 原价的50%-60%
            - 成色5(良好): 原前的60%-70%
            - 成色6(不错): 原价的70%-78%
            - 成色7(较新): 原价的80%-88%
            - 成色8(很新): 原价的88%-95%
            - 成色9(近全新): 原价的93%-100%
            - 成色10(全新): 原价的98%-110%

            如果没有原价参考，根据该类物品常见二手市场价估算：
            - 书籍教材: 5~200元
            - 数码产品: 50~5000元
            - 服饰鞋包: 10~800元
            - 运动器材: 20~1500元
            - 家居日用: 15~600元
            - 美妆护肤: 10~500元

            价格必须是合理的整数（单位：人民币元），min < suggested < max。
            不要给出离谱的价格。reasoning 用一句话说明即可。
            """;

    /**
     * AI 智能分类与定价建议
     *
     * POST /api/ai/suggest
     * Body: { "title": "考研英语真题", "originalPrice": 68, "conditionLevel": 7 }
     */
    @PostMapping("/suggest")
    public ApiResponse<AiSuggestResult> suggest(@RequestBody AiSuggestRequest request) {
        // 参数校验
        if (request.getTitle() == null || request.getTitle().isBlank()) {
            return ApiResponse.error(400, "商品标题不能为空");
        }

        // 检查 API Key 是否配置
        if (apiKey == null || apiKey.isBlank()) {
            log.warn("AI API Key 未配置，跳过 LLM 调用");
            return ApiResponse.error(503, "AI 服务未配置，请联系管理员");
        }

        try {
            // 1. 构造用户 Prompt
            String userPrompt = buildUserPrompt(request);

            // 2. 构造请求体
            Map<String, Object> body = Map.of(
                    "model", model,
                    "messages", List.of(
                            Map.of("role", "system", "content", SYSTEM_PROMPT),
                            Map.of("role", "user", "content", userPrompt)
                    ),
                    "temperature", 0.3,       // 低温度让结果更稳定、更可预测
                    "top_p", 0.9,
                    "max_tokens", 400
            );

            // 3. 设置请求头
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey);

            // 4. 调用智谱 API
            log.info("调用 AI 接口: title={}, conditionLevel={}", request.getTitle(), request.getConditionLevel());
            long startTime = System.currentTimeMillis();

            ResponseEntity<Map> response = restTemplate.exchange(
                    apiUrl,
                    HttpMethod.POST,
                    new HttpEntity<>(body, headers),
                    Map.class
            );

            long elapsed = System.currentTimeMillis() - startTime;
            log.info("AI 接口响应耗时: {}ms", elapsed);

            // 5. 解析响应
            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                Map<String, Object> responseBody = response.getBody();
                String content = extractContent(responseBody);
                AiSuggestResult result = parseLlmResponse(content);
                result.setSource("LLM");
                return ApiResponse.success("AI 分析完成", result);
            } else {
                log.error("AI 接口返回异常: status={}", response.getStatusCode());
                return ApiResponse.error(502, "AI 服务返回异常");
            }

        } catch (Exception e) {
            log.error("调用 AI 接口失败", e);
            // 返回特定错误码，前端可根据此码触发本地降级
            return ApiResponse.error(503, "AI 服务暂时不可用: " + e.getMessage());
        }
    }

    /**
     * 构造发送给 LLM 的用户消息
     */
    private String buildUserPrompt(AiSuggestRequest req) {
        StringBuilder sb = new StringBuilder();
        sb.append("请为以下闲置物品提供分类建议和合理售价：\n\n");
        sb.append("- 商品标题：").append(req.getTitle()).append("\n");

        if (req.getOriginalPrice() != null && req.getOriginalPrice() > 0) {
            sb.append("- 原购买价格：").append(req.getOriginalPrice()).append(" 元\n");
        } else {
            sb.append("- 原购买价格：未填写\n");
        }

        int level = req.getConditionLevel() != null ? req.getConditionLevel() : 7;
        sb.append("- 当前成色等级：").append(level).append("/10 （").append(getConditionLabel(level)).append("）\n");

        sb.append("\n请给出你的建议。");
        return sb.toString();
    }

    /**
     * 从智谱 API 响应中提取文本内容
     */
    @SuppressWarnings("unchecked")
    private String extractContent(Map<String, Object> responseBody) {
        try {
            List<Map<String, Object>> choices = (List<Map<String, Object>>) responseBody.get("choices");
            if (choices != null && !choices.isEmpty()) {
                Map<String, Object> message = (Map<String, Object>) choices.get(0).get("message");
                if (message != null) {
                    return (String) message.get("content");
                }
            }
        } catch (Exception e) {
            log.warn("解析 AI 响应 content 失败", e);
        }
        return null;
    }

    /**
     * 使用 Jackson 解析 LLM 返回的 JSON 字符串为结构化对象
     */
    private AiSuggestResult parseLlmResponse(String content) {
        AiSuggestResult result = new AiSuggestResult();

        if (content == null || content.isBlank()) {
            result.setReasoning("AI 未返回有效内容");
            return result;
        }

        try {
            // 清理可能的 markdown 代码块标记
            String jsonStr = content.trim()
                    .replace("```json", "")
                    .replace("```", "")
                    .trim();

            log.info("LLM 原始返回: {}", jsonStr);

            // 用 Jackson 解析为 Map
            Map<String, Object> map = objectMapper.readValue(jsonStr,
                    new TypeReference<Map<String, Object>>() {});

            // 提取 suggestedCategories
            @SuppressWarnings("unchecked")
            List<String> cats = (List<String>) map.get("suggestedCategories");
            if (cats != null) {
                result.setSuggestedCategories(cats);
            }

            // 提取 reasoning
            String reasoning = (String) map.get("reasoning");
            result.setReasoning(reasoning != null ? reasoning : "");

            // 提取 priceRange（嵌套对象）
            @SuppressWarnings("unchecked")
            Map<String, Object> pr = (Map<String, Object>) map.get("priceRange");
            if (pr != null) {
                AiSuggestResult.PriceRange priceRange = new AiSuggestResult.PriceRange();
                Object min = pr.get("min");
                Object max = pr.get("max");
                Object suggested = pr.get("suggested");

                if (min instanceof Number) priceRange.setMin(((Number) min).intValue());
                if (max instanceof Number) priceRange.setMax(((Number) max).intValue());
                if (suggested instanceof Number) priceRange.setSuggested(((Number) suggested).intValue());

                result.setPriceRange(priceRange);
            }

            log.info("解析结果: categories={}, priceRange={}",
                    result.getSuggestedCategories(), result.getPriceRange());

        } catch (Exception e) {
            log.warn("解析 LLM JSON 响应失败, raw={}", content, e);
            result.setReasoning("AI 返回格式异常: " + e.getMessage());
        }

        return result;
    }

    /** 成色等级 → 中文标签 */
    private static String getConditionLabel(int level) {
        return switch (level) {
            case 1 -> "废品";
            case 2 -> "较差";
            case 3 -> "可用";
            case 4 -> "一般";
            case 5 -> "良好";
            case 6 -> "不错";
            case 7 -> "较新";
            case 8 -> "很新";
            case 9 -> "近全新";
            case 10 -> "全新";
            default -> "未知";
        };
    }
}
