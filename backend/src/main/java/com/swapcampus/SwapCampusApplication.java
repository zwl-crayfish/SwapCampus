package com.swapcampus;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

/**
 * SwapCampus 校园闲置物品交易平台
 * Campus Second-hand Trading Platform
 */
@SpringBootApplication
@MapperScan("com.swapcampus.repository")
@EnableScheduling
public class SwapCampusApplication {
    public static void main(String[] args) {
        SpringApplication.run(SwapCampusApplication.class, args);
    }
}
