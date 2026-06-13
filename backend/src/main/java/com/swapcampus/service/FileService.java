package com.swapcampus.service;

import cn.hutool.core.util.IdUtil;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * 文件存储服务 (本地存储)
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class FileService {

    @Value("${app.upload.local-storage-path:./uploads}")
    private String localStoragePath;

    @Value("${server.port:8080}")
    private String serverPort;

    /**
     * 上传图片
     */
    public String uploadImage(MultipartFile file, String goodsUuid) {
        try {
            // 确保上传目录存在
            Path uploadPath = Paths.get(localStoragePath, "goods", goodsUuid);
            if (!Files.exists(uploadPath)) {
                Files.createDirectories(uploadPath);
            }

            String originalFilename = file.getOriginalFilename();
            String ext = "";
            if (originalFilename != null && originalFilename.contains(".")) {
                ext = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            String fileName = IdUtil.fastSimpleUUID() + ext;
            Path filePath = uploadPath.resolve(fileName);

            // 保存文件
            Files.copy(file.getInputStream(), filePath);

            // 返回访问URL（使用相对路径，前端通过代理访问）
            return "/uploads/goods/" + goodsUuid + "/" + fileName;
        } catch (IOException e) {
            log.error("上传图片失败: {}", e.getMessage());
            throw new RuntimeException("图片上传失败");
        }
    }
}