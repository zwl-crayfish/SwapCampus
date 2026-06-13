package com.swapcampus.controller;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.swapcampus.dto.ApiResponse;
import com.swapcampus.entity.Message;
import com.swapcampus.service.MessageService;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.security.Principal;
import java.util.Map;

/**
 * 聊天控制器 (WebSocket STOMP + REST API)
 */
@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatController {

    private final MessageService messageService;
    private final SimpMessagingTemplate messagingTemplate;

    /**
     * WebSocket 发送消息
     * 客户端发送到 /app/chat/send
     */
    @MessageMapping("/chat/send")
    public void sendMessage(@Payload Map<String, Object> payload, Principal principal) {
        Long senderId = Long.valueOf(principal.getName());
        Long receiverId = Long.valueOf(payload.get("receiverId").toString());
        String content = payload.get("content").toString();
        String msgType = payload.getOrDefault("msgType", "TEXT").toString();
        String goodsUuid = (String) payload.getOrDefault("goodsUuid", null);

        Message message = messageService.sendMessage(senderId, receiverId, content, msgType, goodsUuid);

        // 推送给接收者
        messagingTemplate.convertAndSendToUser(
                String.valueOf(receiverId),
                "/queue/chat",
                message
        );
    }

    /**
     * REST: 获取对话记录
     */
    @GetMapping("/conversation/{contactId}")
    public ApiResponse<Map<String, Object>> getConversation(@PathVariable Long contactId,
                                                             @RequestParam(defaultValue = "1") Integer page,
                                                             @RequestParam(defaultValue = "20") Integer size,
                                                             Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Page<Message> messages = messageService.getConversation(userId, contactId, page, size);

        // 标记已读
        messageService.markAsRead(contactId, userId);

        return ApiResponse.success(Map.of(
                "records", messages.getRecords(),
                "total", messages.getTotal(),
                "page", messages.getCurrent(),
                "size", messages.getSize()
        ));
    }

    /**
     * REST: 获取联系人列表
     */
    @GetMapping("/contacts")
    public ApiResponse<Map<String, Object>> getContacts(@RequestParam(defaultValue = "1") Integer page,
                                                         @RequestParam(defaultValue = "50") Integer size,
                                                         Authentication auth) {
        Long userId = (Long) auth.getPrincipal();
        Page<Long> contacts = messageService.getContacts(userId, page, size);
        return ApiResponse.success(Map.of(
                "records", contacts.getRecords(),
                "total", contacts.getTotal()
        ));
    }

    /**
     * REST: 发送消息（HTTP 降级方案，WebSocket 不可用时使用）
     */
    @PostMapping("/send")
    public ApiResponse<Message> sendMessageRest(@RequestBody Map<String, Object> payload,
                                                Authentication auth) {
        Long senderId = (Long) auth.getPrincipal();
        Long receiverId = Long.valueOf(payload.get("receiverId").toString());
        String content = payload.get("content").toString();
        String msgType = payload.getOrDefault("msgType", "TEXT").toString();

        Message message = messageService.sendMessage(senderId, receiverId, content, msgType, null);

        // 推送给接收者
        messagingTemplate.convertAndSendToUser(
                String.valueOf(receiverId),
                "/queue/chat",
                message
        );

        return ApiResponse.success("发送成功", message);
    }
}
