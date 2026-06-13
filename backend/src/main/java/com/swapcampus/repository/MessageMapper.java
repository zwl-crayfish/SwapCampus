package com.swapcampus.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.entity.Message;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

/**
 * 消息 Mapper
 */
@Mapper
public interface MessageMapper extends BaseMapper<Message> {

    @Select("SELECT * FROM message " +
            "WHERE ((sender_id = #{userId1} AND receiver_id = #{userId2}) " +
            "    OR (sender_id = #{userId2} AND receiver_id = #{userId1})) " +
            "ORDER BY created_at ASC")
    Page<Message> findConversation(Page<Message> page,
                                   @Param("userId1") Long userId1,
                                   @Param("userId2") Long userId2);

    @Update("UPDATE message SET is_read = 1 WHERE sender_id = #{senderId} AND receiver_id = #{receiverId} AND is_read = 0")
    void markAsRead(@Param("senderId") Long senderId, @Param("receiverId") Long receiverId);

    @Select("SELECT DISTINCT " +
            "CASE WHEN sender_id = #{userId} THEN receiver_id ELSE sender_id END AS contact_id " +
            "FROM message WHERE sender_id = #{userId} OR receiver_id = #{userId}")
    Page<Long> findContacts(Page<Long> page, @Param("userId") Long userId);
}
