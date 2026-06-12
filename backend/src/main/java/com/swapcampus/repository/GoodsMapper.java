package com.swapcampus.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.entity.Goods;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

/**
 * 商品 Mapper
 */
@Mapper
public interface GoodsMapper extends BaseMapper<Goods> {

    @Select("SELECT * FROM goods WHERE uuid = #{uuid}")
    Goods findByUuid(@Param("uuid") String uuid);

    @Select("<script>" +
            "SELECT * FROM goods WHERE status = 1 " +
            "<if test='keyword != null and keyword != \"\"'>" +
            "AND MATCH(title, description) AGAINST(#{keyword} IN BOOLEAN MODE) " +
            "</if>" +
            "<if test='categoryId != null'>AND category_id = #{categoryId}</if>" +
            "ORDER BY " +
            "<choose>" +
            "<when test='sortBy == \"price\"'>price </when>" +
            "<otherwise>created_at </otherwise>" +
            "</choose>" +
            "<choose>" +
            "<when test='sortOrder == \"asc\"'>ASC</when>" +
            "<otherwise>DESC</otherwise>" +
            "</choose>" +
            "</script>")
    Page<Goods> searchGoods(Page<Goods> page,
                            @Param("keyword") String keyword,
                            @Param("categoryId") Long categoryId,
                            @Param("sortBy") String sortBy,
                            @Param("sortOrder") String sortOrder);

    @Select("SELECT * FROM goods WHERE seller_id = #{sellerId} AND status != -1 ORDER BY created_at DESC")
    Page<Goods> findBySellerId(Page<Goods> page, @Param("sellerId") Long sellerId);

    @Select("SELECT g.* FROM goods g " +
            "INNER JOIN favorite f ON f.goods_uuid = g.uuid " +
            "WHERE f.user_id = #{userId} AND g.status != -1 " +
            "ORDER BY f.created_at DESC")
    Page<Goods> findFavoritesByUserId(Page<Goods> page, @Param("userId") Long userId);
}
