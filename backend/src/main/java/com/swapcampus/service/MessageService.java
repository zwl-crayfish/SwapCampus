package com.swapcampus.service;

import cn.hutool.core.util.IdUtil;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.entity.Message;
import com.swapcampus.repository.MessageMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * 消息服务
 */
@Service
@RequiredArgsConstructor
public class MessageService {

    private final MessageMapper messageMapper;

    /**
     * 发送消息
     */
    @Transactional
    public Message sendMessage(Long senderId, Long receiverId, String content,
                                String msgType, String goodsUuid) {
        Message message = Message.builder()
                .uuid(IdUtil.fastSimpleUUID())
                .senderId(senderId)
                .receiverId(receiverId)
                .content(content)
                .msgType(msgType != null ? msgType : "TEXT")
                .goodsUuid(goodsUuid)
                .isRead(0)
                .build();

        messageMapper.insert(message);
        return message;
    }

    /**
     * 获取对话记录
     */
    public Page<Message> getConversation(Long userId1, Long userId2, Integer page, Integer size) {
        Page<Message> pageParam = new Page<>(page != null ? page : 1, size != null ? size : 20);
        return messageMapper.findConversation(pageParam, userId1, userId2);
    }

    /**
     * 标记消息已读
     */
    public void markAsRead(Long senderId, Long receiverId) {
        messageMapper.markAsRead(senderId, receiverId);
    }

    /**
     * 获取联系人列表
     */
    public Page<Long> getContacts(Long userId, Integer page, Integer size) {
        Page<Long> pageParam = new Page<>(page != null ? page : 1, size != null ? size : 50);
        return messageMapper.findContacts(pageParam, userId);
    }
}
