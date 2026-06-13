package com.swapcampus.config;

import com.swapcampus.entity.Category;
import com.swapcampus.entity.User;
import com.swapcampus.entity.Wallet;
import com.swapcampus.entity.Goods;
import com.swapcampus.entity.GoodsImage;
import com.swapcampus.repository.CategoryMapper;
import com.swapcampus.repository.UserMapper;
import com.swapcampus.repository.WalletMapper;
import com.swapcampus.repository.GoodsMapper;
import com.swapcampus.repository.GoodsImageMapper;
import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;

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
                                      GoodsImageMapper goodsImageMapper,
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

            // 初始化商品数据（20条）
            if (goodsMapper.selectCount(null) == 0) {
                List<Object[]> goodsData = Arrays.asList(
                    // uuid, sellerId(用户顺序1=admin,2=张三,3=李四,4=王五), categoryId, title, description, price, originalPrice, conditionLevel, isBargain, tradeMethod, campusLocation, status
                    new Object[]{"a1b2c3d4e5f6", 2L, 1L, "高等数学（同济第七版）", "同济大学出版的高等数学教材，上下册全，内有少量笔记，不影响阅读，适合大一新生使用。", new BigDecimal("25.00"), new BigDecimal("45.00"), 7, 1, "FACE", "图书馆", 1},
                    new Object[]{"b2c3d4e5f6a1", 3L, 2L, "iPad Air 5 256G 星光色", "2023年购入，成色很新，无划痕磕碰，带原装充电器和保护壳，电池健康度95%。", new BigDecimal("2800.00"), new BigDecimal("4799.00"), 9, 0, "FACE", "学生公寓10栋", 1},
                    new Object[]{"c3d4e5f6a1b2", 2L, 3L, "小米台灯Pro", "智能护眼台灯，支持App控制，光线柔和，用了一年多，功能完好。", new BigDecimal("65.00"), new BigDecimal("129.00"), 8, 1, "LOCKER", "食堂门口", 1},
                    new Object[]{"d4e5f6a1b2c3", 4L, 4L, "Nike Air Max 270 运动鞋", "黑白配色，42码，穿过几次，鞋底磨损很小，因尺码不合低价出。", new BigDecimal("320.00"), new BigDecimal("899.00"), 8, 1, "FACE", "体育馆", 1},
                    new Object[]{"e5f6a1b2c3d4", 3L, 3L, "飞利浦电动牙刷HX6730", "经典款电动牙刷，配3个刷头，续航正常，清洁力强，毕业清仓甩卖。", new BigDecimal("80.00"), new BigDecimal("299.00"), 7, 1, "BOTH", "教学楼A座", 1},
                    new Object[]{"f6a1b2c3d4e5", 2L, 2L, "Keychron K2 机械键盘", "青轴手感，蓝牙/有线双模，RGB背光，Mac/Windows通用，带原装键帽拔取器。", new BigDecimal("320.00"), new BigDecimal("568.00"), 8, 0, "FACE", "图书馆自习室", 1},
                    new Object[]{"a1b2c3d4e5f7", 4L, 1L, "Python编程从入门到实践", "第二版，书脊有折痕但内页完整干净，附赠代码资源已下载好可传给你。", new BigDecimal("30.00"), new BigDecimal("69.00"), 7, 1, "LOCKER", "主楼邮件柜", 1},
                    new Object[]{"b2c3d4e5f6a2", 3L, 2L, "联想ThinkPad X1 Carbon Gen9", "i7-1165G7/16G/512G，商务本成色极佳，屏幕完美无坏点，带原装电源适配器。", new BigDecimal("4500.00"), new BigDecimal("9999.00"), 9, 0, "FACE", "实验楼B座", 1},
                    new Object[]{"c3d4e5f6a1b3", 2L, 3L, "美的电风扇FS40-18D", "落地扇三档风速调节，静音效果好，用了两个夏天，搬家带不走便宜出了。", new BigDecimal("55.00"), new BigDecimal("159.00"), 7, 1, "BOTH", "学生公寓5栋", 1},
                    new Object[]{"d4e5f6a1b2c4", 4L, 4L, "尤尼克斯羽毛球拍NR-ZSP", "入门进阶款，配一个拍套和3个羽毛球，线有些松建议重新拉线。", new BigDecimal("120.00"), new BigDecimal("380.00"), 6, 1, "FACE", "体育馆器材室", 1},
                    new Object[]{"e5f6a1b2c3d5", 3L, 5L, "兰蔻粉水+小黑瓶套装", "全新未拆封，朋友送的礼物自己肤质不适合，专柜正品，支持验货。", new BigDecimal("380.00"), new BigDecimal("720.00"), 10, 0, "FACE", "女生宿舍楼", 1},
                    new Object[]{"f6a1b2c3d4e6", 2L, 6L, "星火英语六级词汇书", "乱序版，高频词都标注了重点，适合备考六级使用，有几页做了笔记。", new BigDecimal("12.00"), new BigDecimal("38.00"), 7, 1, "LOCKER", "图书馆", 1},
                    new Object[]{"a1b2c3d4e5f8", 4L, 2L, "AirPods Pro 2代", "2024年购入，带MagSafe充电盒，降噪效果一流，因换了华为手机所以出掉。", new BigDecimal("1100.00"), new BigDecimal("1899.00"), 9, 0, "BOTH", "教学楼C座", 1},
                    new Object[]{"b2c3d4e5f6a3", 3L, 3L, "20寸万向轮行李箱", "PC材质耐磨抗摔，密码锁好用，颜色是深蓝色，只用来回过两次家。", new BigDecimal("80.00"), new BigDecimal("199.00"), 8, 1, "FACE", "校门口", 1},
                    new Object[]{"c3d4e5f6a1b4", 2L, 4L, "捷安特ATX860山地车", "27速碟刹，车架M码，保养得很好，链条刚上过油，送一个U型锁和头盔。", new BigDecimal("800.00"), new BigDecimal("1898.00"), 8, 0, "FACE", "自行车棚", 1},
                    new Object[]{"d4e5f6a1b2c5", 4L, 5L, "ZARA碎花连衣裙 S码", "夏季新款，雪纺面料透气舒适，只穿过一次洗过一次，99新如新。", new BigDecimal("89.00"), new BigDecimal("299.00"), 9, 1, "LOCKER", "女生宿舍3栋", 1},
                    new Object[]{"e5f6a1b2c3d6", 3L, 1L, "数据结构(C语言版)严蔚敏", "计算机考研必备教材，重点章节都有荧光笔标注，省去你自己画时间了。", new BigDecimal("20.00"), new BigDecimal("39.00"), 6, 1, "FACE", "图书馆", 1},
                    new Object[]{"f6a1b2c3d4e7", 2L, 2L, "罗马仕20000mAh充电宝", "支持22.5W快充，同时充三个设备，LED电量显示，用了半年多依然耐用。", new BigDecimal("55.00"), new BigDecimal("119.00"), 8, 1, "BOTH", "食堂", 1},
                    new Object[]{"a1b2c3d4e5f9", 4L, 2L, "戴尔U2424H显示器 23.8寸", "IPS面板1080P，Type-C一线连，旋转升降支架，做毕设买的现在用不上了。", new BigDecimal("750.00"), new BigDecimal("1399.00"), 9, 0, "FACE", "实验室", 1},
                    new Object[]{"b2c3d4e5f6a4", 3L, 3L, "纯棉浴巾毛巾三件套", "新疆长绒棉材质，吸水性强不掉毛，白色一套含大浴巾+面巾+方巾。", new BigDecimal("28.00"), new BigDecimal("68.00"), 8, 1, "LOCKER", "洗衣房", 1}
                );

                Random random = new Random();
                for (Object[] data : goodsData) {
                    String uuid = (String) data[0];
                    Long sellerId = (Long) data[1];
                    Long categoryId = (Long) data[2];
                    Goods goods = Goods.builder()
                            .uuid(uuid)
                            .sellerId(sellerId)
                            .categoryId(categoryId)
                            .title((String) data[3])
                            .description((String) data[4])
                            .price((BigDecimal) data[5])
                            .originalPrice((BigDecimal) data[6])
                            .conditionLevel((Integer) data[7])
                            .isBargain((Integer) data[8])
                            .tradeMethod((String) data[9])
                            .campusLocation((String) data[10])
                            .viewCount(random.nextInt(50) + 5)
                            .favoriteCount(random.nextInt(15))
                            .status((Integer) data[11])
                            .createdAt(LocalDateTime.now().minusDays(random.nextInt(30)))
                            .updatedAt(LocalDateTime.now())
                            .build();
                    goodsMapper.insert(goods);

                    // 添加商品图片
                    GoodsImage image = new GoodsImage();
                    image.setGoodsUuid(uuid);
                    image.setUrl("/uploads/goods/" + uuid + "/image.jpg");
                    image.setSortOrder(0);
                    goodsImageMapper.insert(image);
                }
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
