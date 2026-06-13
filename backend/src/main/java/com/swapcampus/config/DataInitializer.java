package com.swapcampus.config;

import com.swapcampus.entity.Category;
import com.swapcampus.entity.User;
import com.swapcampus.entity.Wallet;
import com.swapcampus.entity.Goods;
import com.swapcampus.repository.CategoryMapper;
import com.swapcampus.repository.UserMapper;
import com.swapcampus.repository.WalletMapper;
import com.swapcampus.repository.GoodsMapper;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Arrays;

/**
 * 数据初始化配置 - H2内存数据库启动时自动初始化数据
 */
@Configuration
public class DataInitializer {

    @Bean
    public CommandLineRunner initData(UserMapper userMapper, 
                                      CategoryMapper categoryMapper,
                                      WalletMapper walletMapper,
                                      GoodsMapper goodsMapper,
                                      PasswordEncoder passwordEncoder) {
        return args -> {
            // 初始化商品分类
            if (categoryMapper.selectCount(null) == 0) {
                Category[] categories = {
                    new Category(null, "教材教辅", "book", 1, 1, null),
                    new Category(null, "电子数码", "device", 2, 1, null),
                    new Category(null, "生活用品", "daily", 3, 1, null),
                    new Category(null, "运动户外", "sport", 4, 1, null),
                    new Category(null, "服饰美妆", "fashion", 5, 1, null),
                    new Category(null, "图书音像", "music", 6, 1, null),
                    new Category(null, "其他闲置", "other", 7, 1, null)
                };
                Arrays.stream(categories).forEach(categoryMapper::insert);
            }

            // 初始化用户
            if (userMapper.selectCount(null) == 0) {
                String encodedPassword = passwordEncoder.encode("123456");
                
                // 管理员
                User admin = new User();
                admin.setStudentId("admin001");
                admin.setUsername("admin");
                admin.setPassword(encodedPassword);
                admin.setRealName("系统管理员");
                admin.setRole(1);
                admin.setStatus(1);
                userMapper.insert(admin);

                // 测试用户1
                User zhangsan = new User();
                zhangsan.setStudentId("2021001001");
                zhangsan.setUsername("zhangsan");
                zhangsan.setPassword(encodedPassword);
                zhangsan.setRealName("张三");
                zhangsan.setPhone("13800001001");
                zhangsan.setEmail("zhangsan@bjfu.edu.cn");
                zhangsan.setRole(0);
                zhangsan.setCreditScore(85);
                zhangsan.setStatus(1);
                userMapper.insert(zhangsan);

                // 测试用户2
                User lisi = new User();
                lisi.setStudentId("2021001002");
                lisi.setUsername("lisi");
                lisi.setPassword(encodedPassword);
                lisi.setRealName("李四");
                lisi.setPhone("13800001002");
                lisi.setEmail("lisi@bjfu.edu.cn");
                lisi.setRole(0);
                lisi.setCreditScore(90);
                lisi.setStatus(1);
                userMapper.insert(lisi);

                // 测试用户3
                User wangwu = new User();
                wangwu.setStudentId("2021001003");
                wangwu.setUsername("wangwu");
                wangwu.setPassword(encodedPassword);
                wangwu.setRealName("王五");
                wangwu.setPhone("13800001003");
                wangwu.setEmail("wangwu@bjfu.edu.cn");
                wangwu.setRole(0);
                wangwu.setCreditScore(75);
                wangwu.setStatus(1);
                userMapper.insert(wangwu);
            }

            // 初始化钱包
            if (walletMapper.selectCount(null) == 0) {
                // 获取用户ID并创建钱包
                userMapper.selectList(null).forEach(user -> {
                    Wallet wallet = new Wallet();
                    wallet.setUserId(user.getId());
                    wallet.setBalance(BigDecimal.ZERO);
                    wallet.setPoints(100);
                    walletMapper.insert(wallet);
                });
            }

            // 修复已有商品的发布时间为空的问题
            goodsMapper.selectList(null).forEach(goods -> {
                if (goods.getCreatedAt() == null) {
                    goods.setCreatedAt(LocalDateTime.now());
                    goods.setUpdatedAt(LocalDateTime.now());
                    goodsMapper.updateById(goods);
                }
            });
        };
    }
}
