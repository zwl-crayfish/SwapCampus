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
            "SELECT * FROM goods WHERE status IN(1,2,0) " +
            "<if test='keyword != null and keyword != \"\"'>" +
            "AND (title LIKE CONCAT('%', #{keyword}, '%') OR description LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "<if test='categoryId != null'>AND category_id = #{categoryId}</if>" +
            "<if test='minPrice != null'>AND price &gt;= #{minPrice}</if>" +
            "<if test='maxPrice != null'>AND price &lt;= #{maxPrice}</if>" +
            "<if test='timeRange == \"today\"'>AND created_at &gt; CURRENT_DATE</if>" +
            "<if test='timeRange == \"week\"'>AND created_at &gt; DATEADD(DAY, -7, NOW())</if>" +
            "<if test='timeRange == \"month\"'>AND created_at &gt; DATEADD(DAY, -30, NOW())</if>" +
            "<if test='timeRange == \"quarter\"'>AND created_at &gt; DATEADD(DAY, -90, NOW())</if>" +
            "<if test='timeRange == \"threeMonth\"'>AND created_at &gt; DATEADD(DAY, -90, NOW())</if>" +
            "<if test='status != null and status == \"ON_SALE\"'>AND status = 1</if>" +
            "<if test='status != null and status == \"OFF_SHELF\"'>AND status = 0</if>" +
            "<if test='status != null and status == \"SOLD_OUT\"'>AND status = 2</if>" +
            "<if test='viewMin != null'>AND view_count &gt;= #{viewMin}</if>" +
            "<if test='favMin != null'>AND favorite_count &gt;= #{favMin}</if>" +
            "<if test='conditionMin != null'>AND condition_level &gt;= #{conditionMin}</if>" +
            "<if test='conditionMax != null'>AND condition_level &lt;= #{conditionMax}</if>" +
            "ORDER BY " +
            "<choose>" +
            "  <when test='sortBy != null and sortBy == \"price\"'>price <if test='sortOrder != null and sortOrder == \"asc\"'>ASC</if><if test='sortOrder == null or sortOrder != \"asc\"'>DESC</if></when>" +
            "  <when test='sortBy != null and sortBy == \"view_count\"'>view_count <if test='sortOrder != null and sortOrder == \"asc\"'>ASC</if><if test='sortOrder == null or sortOrder != \"asc\"'>DESC</if></when>" +
            "  <when test='sortBy != null and sortBy == \"favorite_count\"'>favorite_count <if test='sortOrder != null and sortOrder == \"asc\"'>ASC</if><if test='sortOrder == null or sortOrder != \"asc\"'>DESC</if></when>" +
            "  <otherwise>created_at <if test='sortOrder != null and sortOrder == \"asc\"'>ASC</if><if test='sortOrder == null or sortOrder != \"asc\"'>DESC</if></otherwise>" +
            "</choose>" +
            "</script>")
    Page<Goods> searchGoods(Page<Goods> page,
                            @Param("keyword") String keyword,
                            @Param("categoryId") Long categoryId,
                            @Param("minPrice") Double minPrice,
                            @Param("maxPrice") Double maxPrice,
                            @Param("timeRange") String timeRange,
                            @Param("status") String status,
                            @Param("viewMin") Integer viewMin,
                            @Param("favMin") Integer favMin,
                            @Param("conditionMin") Integer conditionMin,
                            @Param("conditionMax") Integer conditionMax,
                            @Param("sortBy") String sortBy,
                            @Param("sortOrder") String sortOrder);

    @Select("SELECT * FROM goods WHERE seller_id = #{sellerId} AND status != -1 ORDER BY created_at DESC")
    Page<Goods> findBySellerId(Page<Goods> page, @Param("sellerId") Long sellerId);
}
