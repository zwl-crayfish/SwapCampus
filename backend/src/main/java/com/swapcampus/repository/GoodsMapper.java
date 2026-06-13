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
            "AND (title LIKE CONCAT('%', #{keyword}, '%') OR description LIKE CONCAT('%', #{keyword}, '%')) " +
            "</if>" +
            "<if test='categoryId != null'>AND category_id = #{categoryId}</if>" +
            "ORDER BY " +
            "<choose>" +
            "<when test='sortBy == \"price\"'>price ${sortOrder}</when>" +
            "<otherwise>created_at ${sortOrder}</otherwise>" +
            "</choose>" +
            "</script>")
    Page<Goods> searchGoods(Page<Goods> page,
                            @Param("keyword") String keyword,
                            @Param("categoryId") Long categoryId,
                            @Param("sortBy") String sortBy,
                            @Param("sortOrder") String sortOrder);

    @Select("SELECT * FROM goods WHERE seller_id = #{sellerId} AND status != -1 ORDER BY created_at DESC")
    Page<Goods> findBySellerId(Page<Goods> page, @Param("sellerId") Long sellerId);
}
