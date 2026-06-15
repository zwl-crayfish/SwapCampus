package com.swapcampus.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.ApiResponse;
import com.swapcampus.dto.GoodsRequest;
import com.swapcampus.dto.PageQuery;
import com.swapcampus.entity.Goods;
import com.swapcampus.entity.GoodsImage;
import com.swapcampus.service.GoodsService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 商品控制器
 */
@RestController
@RequestMapping("/api/goods")
@RequiredArgsConstructor
public class GoodsController {

    private final GoodsService goodsService;

    /**
     * 搜索/列表商品（公开）
     */
    @GetMapping("/list")
    public ApiResponse<Map<String, Object>> list(PageQuery query) {
        Page<Goods> page = goodsService.searchGoods(query);
        List<Goods> records = page.getRecords();
        
        // 为每个商品补充封面图URL
        List<Map<String, Object>> enrichedRecords = new ArrayList<>();
        for (Goods g : records) {
            Map<String, Object> item = new HashMap<>();
            item.put("uuid", g.getUuid());
            item.put("sellerId", g.getSellerId());
            item.put("categoryId", g.getCategoryId());
            item.put("title", g.getTitle());
            item.put("description", g.getDescription());
            item.put("price", g.getPrice());
            item.put("originalPrice", g.getOriginalPrice());
            item.put("conditionLevel", g.getConditionLevel());
            item.put("isBargain", g.getIsBargain());
            item.put("tradeMethod", g.getTradeMethod());
            item.put("campusLocation", g.getCampusLocation());
            item.put("viewCount", g.getViewCount());
            item.put("favoriteCount", g.getFavoriteCount());
            item.put("status", g.getStatus());
            item.put("createdAt", g.getCreatedAt());
            
            // 获取第一张图片作为封面
            List<GoodsImage> imgs = goodsService.getImages(g.getUuid());
            if (!imgs.isEmpty()) {
                item.put("coverUrl", imgs.get(0).getUrl());
            }
            enrichedRecords.add(item);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("records", enrichedRecords);
        result.put("total", page.getTotal());
        result.put("page", page.getCurrent());
        result.put("size", page.getSize());
        return ApiResponse.success(result);
    }

    /**
     * 获取商品详情
     */
    @GetMapping("/detail/{uuid}")
    public ApiResponse<Map<String, Object>> detail(@PathVariable String uuid, Authentication auth) {
        Goods goods = goodsService.getByUuid(uuid);
        if (goods == null) {
            return ApiResponse.error(404, "商品不存在");
        }
        List<GoodsImage> images = goodsService.getImages(uuid);

        Map<String, Object> result = new HashMap<>();
        result.put("goods", goods);
        result.put("images", images);

        // 返回是否已收藏
        if (auth != null && auth.isAuthenticated()) {
            Long userId = (Long) auth.getPrincipal();
            result.put("isFavorited", goodsService.isFavorited(userId, uuid));
        }

        return ApiResponse.success(result);
    }

    /**
     * 发布商品
     */
    @PostMapping("/publish")
    public ApiResponse<Goods> publish(@Valid @RequestPart("data") GoodsRequest request,
                                       @RequestPart(value = "images", required = false) MultipartFile[] images,
                                       Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Goods goods = goodsService.publishGoods(request, userId, images);
        return ApiResponse.success("发布成功", goods);
    }

    /**
     * 编辑商品
     */
    @PutMapping("/{uuid}")
    public ApiResponse<Goods> update(@PathVariable String uuid,
                                      @Valid @RequestPart("data") GoodsRequest request,
                                      @RequestPart(value = "images", required = false) MultipartFile[] images,
                                      Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Goods goods = goodsService.updateGoods(uuid, request, userId, images);
        return ApiResponse.success("更新成功", goods);
    }

    /**
     * 下架/删除商品
     */
    @PutMapping("/{uuid}/status")
    public ApiResponse<Void> changeStatus(@PathVariable String uuid,
                                           @RequestParam Integer status,
                                           Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        goodsService.changeStatus(uuid, status, userId);
        return ApiResponse.success("操作成功", null);
    }

    /**
     * 收藏/取消收藏
     */
    @PostMapping("/{uuid}/favorite")
    public ApiResponse<Boolean> toggleFavorite(@PathVariable String uuid, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        boolean favorited = goodsService.toggleFavorite(userId, uuid);
        return ApiResponse.success(favorited ? "已收藏" : "已取消收藏", favorited);
    }

    /**
     * 我发布的商品
     */
    @GetMapping("/my-published")
    public ApiResponse<Map<String, Object>> myPublished(PageQuery query, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Page<Goods> page = goodsService.getSellerGoods(userId, query);

        // 为每个商品补充封面图URL
        List<Map<String, Object>> enrichedRecords = new ArrayList<>();
        for (Goods g : page.getRecords()) {
            Map<String, Object> item = new HashMap<>();
            item.put("id", g.getId());
            item.put("uuid", g.getUuid());
            item.put("sellerId", g.getSellerId());
            item.put("categoryId", g.getCategoryId());
            item.put("title", g.getTitle());
            item.put("description", g.getDescription());
            item.put("price", g.getPrice());
            item.put("originalPrice", g.getOriginalPrice());
            item.put("conditionLevel", g.getConditionLevel());
            item.put("isBargain", g.getIsBargain());
            item.put("tradeMethod", g.getTradeMethod());
            item.put("campusLocation", g.getCampusLocation());
            item.put("viewCount", g.getViewCount());
            item.put("favoriteCount", g.getFavoriteCount());
            item.put("status", g.getStatus());
            item.put("createdAt", g.getCreatedAt());

            List<GoodsImage> imgs = goodsService.getImages(g.getUuid());
            if (!imgs.isEmpty()) {
                item.put("coverUrl", imgs.get(0).getUrl());
            }
            enrichedRecords.add(item);
        }

        Map<String, Object> result = Map.of(
                "records", enrichedRecords,
                "total", page.getTotal(),
                "page", page.getCurrent(),
                "size", page.getSize()
        );
        return ApiResponse.success(result);
    }

    /**
     * 我的收藏
     */
    @GetMapping("/my-favorites")
    public ApiResponse<Map<String, Object>> myFavorites(PageQuery query, Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Page<Goods> page = goodsService.getMyFavorites(userId, query);

        List<Map<String, Object>> enrichedRecords = new ArrayList<>();
        for (Goods g : page.getRecords()) {
            Map<String, Object> item = new HashMap<>();
            item.put("uuid", g.getUuid());
            item.put("title", g.getTitle());
            item.put("description", g.getDescription());
            item.put("price", g.getPrice());
            item.put("originalPrice", g.getOriginalPrice());
            item.put("conditionLevel", g.getConditionLevel());
            item.put("favoriteCount", g.getFavoriteCount());
            item.put("status", g.getStatus());
            item.put("createdAt", g.getCreatedAt());

            List<GoodsImage> imgs = goodsService.getImages(g.getUuid());
            if (!imgs.isEmpty()) {
                item.put("coverUrl", imgs.get(0).getUrl());
            }
            enrichedRecords.add(item);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("records", enrichedRecords);
        result.put("total", page.getTotal());
        result.put("page", page.getCurrent());
        result.put("size", page.getSize());
        return ApiResponse.success(result);
    }

    /**
     * 举报商品
     */
    @PostMapping("/{uuid}/report")
    public ApiResponse<Void> reportGoods(
            @PathVariable String uuid,
            @RequestParam String reason,
            @RequestParam(required = false) String description,
            Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        goodsService.reportGoods(uuid, userId, reason, description);
        return ApiResponse.success("举报成功，我们会尽快处理", null);
    }

    /**
     * 个性化推荐（基于热门商品）
     */
    @GetMapping("/recommendations")
    public ApiResponse<Map<String, Object>> recommendations(PageQuery query) {
        // 使用排序为浏览量降序来获取推荐
        PageQuery recQuery = PageQuery.builder()
                .page(query.getPage()).size(8)
                .sortBy("view_count").sortOrder("desc").build();
        Page<Goods> page = goodsService.searchGoods(recQuery);
        List<Goods> records = page.getRecords();

        List<Map<String, Object>> enrichedRecords = new ArrayList<>();
        for (int i = 0; i < records.size(); i++) {
            Goods g = records.get(i);
            Map<String, Object> item = new HashMap<>();
            item.put("uuid", g.getUuid());
            item.put("title", g.getTitle());
            item.put("price", g.getPrice());
            item.put("coverUrl", "");
            item.put("conditionLevel", g.getConditionLevel());
            item.put("favoriteCount", g.getFavoriteCount());
            item.put("viewCount", g.getViewCount());
            // 模拟匹配度：越靠前匹配度越高
            int matchScore = Math.max(60, 98 - i * 5 + (int)(Math.random() * 6));
            item.put("matchScore", matchScore);

            List<GoodsImage> imgs = goodsService.getImages(g.getUuid());
            if (!imgs.isEmpty()) {
                item.put("coverUrl", imgs.get(0).getUrl());
            }
            enrichedRecords.add(item);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("records", enrichedRecords.subList(0, Math.min(enrichedRecords.size(), 8)));
        result.put("total", Math.min(page.getTotal(), 8));
        return ApiResponse.success(result);
    }
}
