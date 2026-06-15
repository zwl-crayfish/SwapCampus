package com.swapcampus.service;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.GoodsRequest;
import com.swapcampus.dto.PageQuery;
import com.swapcampus.entity.Goods;
import com.swapcampus.entity.GoodsImage;
import com.swapcampus.entity.Favorite;
import com.swapcampus.entity.Report;
import com.swapcampus.repository.GoodsMapper;
import com.swapcampus.repository.GoodsImageMapper;
import com.swapcampus.repository.FavoriteMapper;
import com.swapcampus.repository.ReportMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.time.LocalDateTime;

/**
 * 商品服务
 */
@Service
@RequiredArgsConstructor
public class GoodsService {

    private final GoodsMapper goodsMapper;
    private final GoodsImageMapper goodsImageMapper;
    private final FavoriteMapper favoriteMapper;
    private final ReportMapper reportMapper;
    private final FileService fileService;

    /**
     * 分页搜索商品
     */
    public Page<Goods> searchGoods(PageQuery query) {
        Page<Goods> page = new Page<>(query.getPage(), query.getSize());
        return goodsMapper.searchGoods(page,
                query.getKeyword(),
                query.getCategoryId(),
                query.getMinPrice(),
                query.getMaxPrice(),
                query.getTimeRange(),
                query.getStatus(),
                query.getViewMin(),
                query.getFavMin(),
                query.getConditionMin(),
                query.getConditionMax(),
                query.getSortBy(),
                query.getSortOrder());
    }

    /**
     * 根据UUID获取商品
     */
    public Goods getByUuid(String uuid) {
        Goods goods = goodsMapper.findByUuid(uuid);
        if (goods != null) {
            // 增加浏览量
            goods.setViewCount(goods.getViewCount() + 1);
            goodsMapper.updateById(goods);
        }
        return goods;
    }

    /**
     * 获取商品图片
     */
    public List<GoodsImage> getImages(String goodsUuid) {
        return goodsImageMapper.selectList(
                new LambdaQueryWrapper<GoodsImage>()
                        .eq(GoodsImage::getGoodsUuid, goodsUuid)
                        .orderByAsc(GoodsImage::getSortOrder)
        );
    }

    /**
     * 发布商品
     */
    @Transactional
    public Goods publishGoods(GoodsRequest request, Long sellerId, MultipartFile[] images) {
        String uuid = IdUtil.fastSimpleUUID();

        Goods goods = Goods.builder()
                .uuid(uuid)
                .sellerId(sellerId)
                .categoryId(request.getCategoryId())
                .title(request.getTitle())
                .description(request.getDescription())
                .price(request.getPrice())
                .originalPrice(request.getOriginalPrice())
                .conditionLevel(request.getConditionLevel())
                .isBargain(request.getIsBargain())
                .tradeMethod(request.getTradeMethod())
                .campusLocation(request.getCampusLocation())
                .viewCount(0)
                .favoriteCount(0)
                .status(3)  // 审核中，需管理员审核后上架
                .createdAt(LocalDateTime.now())  // 显式设置发布时间
                .updatedAt(LocalDateTime.now())
                .build();

        goodsMapper.insert(goods);

        // 上传图片
        if (images != null && images.length > 0) {
            uploadImages(uuid, images);
        }

        return goods;
    }

    /**
     * 编辑商品
     */
    @Transactional
    public Goods updateGoods(String uuid, GoodsRequest request, Long sellerId, MultipartFile[] images) {
        Goods goods = goodsMapper.findByUuid(uuid);
        if (goods == null) {
            throw new RuntimeException("商品不存在");
        }
        if (!goods.getSellerId().equals(sellerId)) {
            throw new RuntimeException("无权限修改此商品");
        }

        goods.setCategoryId(request.getCategoryId());
        goods.setTitle(request.getTitle());
        goods.setDescription(request.getDescription());
        goods.setPrice(request.getPrice());
        goods.setOriginalPrice(request.getOriginalPrice());
        goods.setConditionLevel(request.getConditionLevel());
        goods.setIsBargain(request.getIsBargain());
        goods.setTradeMethod(request.getTradeMethod());
        goods.setCampusLocation(request.getCampusLocation());

        goodsMapper.updateById(goods);

        // 有新的图片上传则重新上传
        if (images != null && images.length > 0) {
            // 删除旧图片
            goodsImageMapper.delete(
                    new LambdaQueryWrapper<GoodsImage>().eq(GoodsImage::getGoodsUuid, uuid)
            );
            uploadImages(uuid, images);
        }

        return goods;
    }

    /**
     * 下架/删除商品
     */
    public void changeStatus(String uuid, Integer status, Long userId) {
        Goods goods = goodsMapper.findByUuid(uuid);
        if (goods == null) {
            throw new RuntimeException("商品不存在");
        }
        if (!goods.getSellerId().equals(userId)) {
            throw new RuntimeException("无权限操作");
        }
        // 状态值白名单校验：-1删除, 0下架, 1在售, 2已售出
        if (status == null || !Set.of(-1, 0, 1, 2).contains(status)) {
            throw new RuntimeException("无效的状态值");
        }
        goods.setStatus(status);
        goodsMapper.updateById(goods);
    }

    /**
     * 获取卖家发布的商品
     */
    public Page<Goods> getSellerGoods(Long sellerId, PageQuery query) {
        Page<Goods> page = new Page<>(query.getPage(), query.getSize());
        return goodsMapper.findBySellerId(page, sellerId);
    }

    /**
     * 收藏/取消收藏
     */
    public boolean toggleFavorite(Long userId, String goodsUuid) {
        LambdaQueryWrapper<Favorite> wrapper = new LambdaQueryWrapper<Favorite>()
                .eq(Favorite::getUserId, userId)
                .eq(Favorite::getGoodsUuid, goodsUuid);
        Favorite existing = favoriteMapper.selectOne(wrapper);

        Goods goods = goodsMapper.findByUuid(goodsUuid);
        if (existing != null) {
            favoriteMapper.deleteById(existing.getId());
            if (goods != null) {
                goods.setFavoriteCount(Math.max(0, goods.getFavoriteCount() - 1));
                goodsMapper.updateById(goods);
            }
            return false;
        } else {
            Favorite favorite = new Favorite();
            favorite.setUserId(userId);
            favorite.setGoodsUuid(goodsUuid);
            favoriteMapper.insert(favorite);
            if (goods != null) {
                goods.setFavoriteCount(goods.getFavoriteCount() + 1);
                goodsMapper.updateById(goods);
            }
            return true;
        }
    }

    /**
     * 检查是否已收藏
     */
    public boolean isFavorited(Long userId, String goodsUuid) {
        return favoriteMapper.selectCount(
                new LambdaQueryWrapper<Favorite>()
                        .eq(Favorite::getUserId, userId)
                        .eq(Favorite::getGoodsUuid, goodsUuid)
        ) > 0;
    }

    /**
     * 获取用户收藏的商品列表（分页）
     */
    public Page<Goods> getMyFavorites(Long userId, PageQuery query) {
        // 查出用户所有收藏的 goodsUuid
        List<Favorite> favorites = favoriteMapper.selectList(
                new LambdaQueryWrapper<Favorite>().eq(Favorite::getUserId, userId)
        );
        if (favorites.isEmpty()) {
            return new Page<>(query.getPage(), query.getSize());
        }
        Set<String> uuids = favorites.stream().map(Favorite::getGoodsUuid).collect(java.util.stream.Collectors.toSet());
        // 分页查询这些商品
        Page<Goods> page = new Page<>(query.getPage(), query.getSize());
        LambdaQueryWrapper<Goods> wrapper = new LambdaQueryWrapper<Goods>()
                .in(Goods::getUuid, uuids)
                .ne(Goods::getStatus, -1)
                .orderByDesc(Goods::getCreatedAt);
        return goodsMapper.selectPage(page, wrapper);
    }

    /**
     * 用户举报商品
     */
    public void reportGoods(String goodsUuid, Long reporterId, String reason, String description) {
        Goods goods = goodsMapper.findByUuid(goodsUuid);
        if (goods == null) {
            throw new RuntimeException("商品不存在");
        }

        // 检查是否已举报过（同一用户对同一商品只能举报一次）
        long existingCount = reportMapper.selectCount(
                new LambdaQueryWrapper<Report>()
                        .eq(Report::getReporterId, reporterId)
                        .eq(Report::getGoodsUuid, goodsUuid)
        );
        if (existingCount > 0) {
            throw new RuntimeException("您已举报过该商品");
        }

        Report report = new Report();
        report.setReporterId(reporterId);
        report.setGoodsUuid(goodsUuid);
        report.setReportedUserId(goods.getSellerId());
        report.setReason(reason);
        report.setDescription(description != null ? description : "");
        report.setStatus(0); // 待处理
        report.setCreatedAt(LocalDateTime.now());
        reportMapper.insert(report);
    }

    private void uploadImages(String uuid, MultipartFile[] images) {
        for (int i = 0; i < images.length; i++) {
            String url = fileService.uploadImage(images[i], uuid);
            GoodsImage img = new GoodsImage();
            img.setGoodsUuid(uuid);
            img.setUrl(url);
            img.setSortOrder(i);
            goodsImageMapper.insert(img);
        }
    }
}
