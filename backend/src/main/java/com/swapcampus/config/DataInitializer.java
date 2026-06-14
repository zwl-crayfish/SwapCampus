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
                    new Object[]{"b2c3d4e5f6a4", 3L, 3L, "纯棉浴巾毛巾三件套", "新疆长绒棉材质，吸水性强不掉毛，白色一套含大浴巾+面巾+方巾。", new BigDecimal("28.00"), new BigDecimal("68.00"), 8, 1, "LOCKER", "洗衣房", 1},
                    // 追加商品数据（180条）
                    // 教材教辅类 (categoryId=1)
                    new Object[]{"ac717546e6d2", 2L, 1L, "线性代数（同济第六版）", "经典教材，内页有少量铅笔笔记，重点公式已标记，适合复习使用。", new BigDecimal("18.00"), new BigDecimal("35.00"), 7, 1, "FACE", "图书馆", 1},
                    new Object[]{"d2f94ca0b7c7", 3L, 1L, "C语言程序设计（谭浩强）", "第四版教材，附带课后习题答案，封面略有磨损但内容完整。", new BigDecimal("22.00"), new BigDecimal("42.00"), 6, 1, "LOCKER", "教学楼A座", 1},
                    new Object[]{"94e73d72e7b6", 4L, 1L, "概率论与数理统计", "浙大第四版，考研必备，重要定理有荧光笔标注，省去翻书时间。", new BigDecimal("25.00"), new BigDecimal("48.00"), 7, 1, "FACE", "图书馆自习室", 1},
                    new Object[]{"edbd63758697", 2L, 1L, "Java核心技术 卷I", "原书第11版，基础知识讲解详细，适合Java入门学习，九成新。", new BigDecimal("55.00"), new BigDecimal("119.00"), 9, 0, "FACE", "实验楼B座", 1},
                    new Object[]{"4a5b235368c7", 3L, 1L, "计算机网络（谢希仁）", "第七版经典教材，网络协议讲解清晰，有少量笔记和划线。", new BigDecimal("30.00"), new BigDecimal("55.00"), 7, 1, "BOTH", "图书馆", 1},
                    new Object[]{"6b0b5d9b5f0f", 4L, 1L, "操作系统概念", "第九版影印版，操作系统课程必读，英文原版内容完整无缺页。", new BigDecimal("45.00"), new BigDecimal("89.00"), 8, 0, "FACE", "主楼邮件柜", 1},
                    new Object[]{"37a6c0d3e967", 2L, 1L, "大学物理（马文蔚）", "上下册全套，力学电磁学光学全覆盖，例题丰富适合预习复习。", new BigDecimal("35.00"), new BigDecimal("68.00"), 7, 1, "LOCKER", "学生公寓5栋", 1},
                    new Object[]{"006987877abd", 3L, 1L, "微积分（同济版）", "上册教材，高数入门必备，定义定理推导过程详细，适合大一。", new BigDecimal("20.00"), new BigDecimal("39.00"), 6, 1, "FACE", "图书馆", 1},
                    new Object[]{"1280d63b0e0e", 4L, 1L, "电路原理（邱关源）", "第五版经典教材，电路分析基础理论扎实，有部分习题解答标注。", new BigDecimal("28.00"), new BigDecimal("52.00"), 7, 1, "BOTH", "教学楼C座", 1},
                    new Object[]{"d06914213eae", 2L, 1L, "离散数学（屈婉玲）", "计算机专业核心课教材，集合论图论逻辑全覆盖，重点已标记。", new BigDecimal("32.00"), new BigDecimal("59.00"), 8, 1, "FACE", "图书馆自习室", 1},
                    new Object[]{"7ff6d3ee1236", 3L, 1L, "数字逻辑设计", "第四版教材，数字电路设计入门必备，时序组合电路讲解清晰。", new BigDecimal("26.00"), new BigDecimal("49.00"), 7, 1, "LOCKER", "实验楼A座", 1},
                    new Object[]{"3bf7237e09ca", 4L, 1L, "软件工程（张海藩）", "第六版教材，软件开发全流程介绍，项目管理章节非常实用。", new BigDecimal("38.00"), new BigDecimal("72.00"), 8, 0, "FACE", "图书馆", 1},
                    new Object[]{"e82201e9a4d5", 2L, 1L, "算法导论（CLRS）", "第三版中文版，算法圣经级教材，复杂度分析透彻，九五成新。", new BigDecimal("65.00"), new BigDecimal("128.00"), 9, 0, "FACE", "教学楼B座", 1},
                    new Object[]{"34b64a16936a", 3L, 1L, "计算机组成原理（唐朔飞）", "第二版教材，硬件体系结构讲解深入，CPU存储器IO都有涉及。", new BigDecimal("42.00"), new BigDecimal("79.00"), 8, 1, "BOTH", "实验室", 1},
                    new Object[]{"a4ea8526e3db", 4L, 1L, "人工智能导论", "AI入门经典教材，机器学习深度学习基础概念全覆盖，通俗易懂。", new BigDecimal("48.00"), new BigDecimal("95.00"), 8, 0, "FACE", "图书馆", 1},
                    new Object[]{"6ac2decfd816", 2L, 1L, "机器学习实战", "基于Python的ML实战指南，代码示例丰富可直接运行，附电子资源。", new BigDecimal("52.00"), new BigDecimal("99.00"), 9, 0, "FACE", "实验楼B座", 1},
                    new Object[]{"132e45c07120", 3L, 1L, "数值分析方法", "计算数学专业教材，数值逼近方程求根矩阵计算等内容详尽。", new BigDecimal("35.00"), new BigDecimal("68.00"), 7, 1, "LOCKER", "教学楼A座", 1},
                    new Object[]{"bb91471ffaea", 4L, 1L, "常微分方程（王高雄）", "第三版教材，微分方程求解方法全面，例题多且配有详细解答。", new BigDecimal("28.00"), new BigDecimal("54.00"), 7, 1, "FACE", "图书馆自习室", 1},
                    new Object[]{"1a7529f9209e", 2L, 1L, "复变函数与积分变换", "工程数学系列教材，复变函数积分变换两大部分，工科必修课。", new BigDecimal("24.00"), new BigDecimal("46.00"), 7, 1, "BOTH", "图书馆", 1},
                    new Object[]{"da55f5b80abe", 3L, 1L, "泛函分析讲义", "研究生阶段教材，Banach空间Hilbert空间理论，数学系进阶必读。", new BigDecimal("40.00"), new BigDecimal("78.00"), 8, 0, "FACE", "主楼邮件柜", 1},
                    new Object[]{"7eadd32ea20b", 4L, 1L, "偏微分方程", "数学物理方程教材，热传导波动拉普拉斯方程，物理专业必修。", new BigDecimal("33.00"), new BigDecimal("65.00"), 7, 1, "LOCKER", "教学楼C座", 1},
                    new Object[]{"132473fe101d", 2L, 1L, "运筹学（清华版）", "运筹学经典教材，线性规划动态规划网络优化全覆盖，管理类必读。", new BigDecimal("45.00"), new BigDecimal("88.00"), 8, 1, "FACE", "图书馆", 1},
                    new Object[]{"a1603d95060b", 3L, 1L, "图论算法及其应用", "图论算法详解教材，最短路最小生成树网络流等算法实现清晰。", new BigDecimal("36.00"), new BigDecimal("70.00"), 8, 0, "BOTH", "实验楼A座", 1},
                    new Object[]{"a28fd1ff99fc", 4L, 1L, "密码学原理与实践", "第四版教材，对称非对称加密哈希数字签名，信息安全专业核心课。", new BigDecimal("50.00"), new BigDecimal("98.00"), 9, 0, "FACE", "实验室", 1},
                    new Object[]{"2e09c5cc5416", 2L, 1L, "计算机图形学（孙家广）", "第三版教材，三维建模渲染动画基础，计算机视觉方向推荐阅读。", new BigDecimal("42.00"), new BigDecimal("82.00"), 8, 1, "FACE", "图书馆自习室", 1},
                    new Object[]{"309dc8f51610", 3L, 1L, "深度学习入门：基于Python", "鱼书经典DL入门教程，神经网络CNN RNN手把手教学，代码可运行。", new BigDecimal("55.00"), new BigDecimal("108.00"), 9, 0, "FACE", "实验楼B座", 1},
                    new Object[]{"42590785654f", 4L, 1L, "自然语言处理综述", "NLP领域入门教材，词向量TransformerBERT等前沿技术均有介绍。", new BigDecimal("48.00"), new BigDecimal("92.00"), 8, 0, "BOTH", "图书馆", 1},
                    new Object[]{"a3bf1cfd1bad", 2L, 1L, "编译原理（龙书）", "第二版中文版，编译器设计经典教材，词法语法语义分析全覆盖。", new BigDecimal("58.00"), new BigDecimal("115.00"), 9, 0, "FACE", "教学楼B座", 1},
                    new Object[]{"5b37fd50cf7e", 3L, 1L, "数据库系统概论（王珊）", "第五版教材，SQL关系代数规范化理论，计算机专业数据库课程必用。", new BigDecimal("32.00"), new BigDecimal("62.00"), 7, 1, "LOCKER", "图书馆", 1},
                    new Object[]{"c1c957f32f7a", 4L, 1L, "数据结构C++（严蔚敏）", "经典数据结构教材，链表树图排序算法实现，考研复试必备参考书。", new BigDecimal("28.00"), new BigDecimal("55.00"), 7, 1, "FACE", "教学楼A座", 1},
                    new Object[]{"3fc9a6b38ca6", 2L, 1L, "高等数学同济版下册", "同济第七版下册，多元微积分级数微分方程，与上册配套使用。", new BigDecimal("22.00"), new BigDecimal("42.00"), 6, 1, "BOTH", "图书馆自习室", 1},
                    new Object[]{"3a5808ca9f97", 3L, 1L, "大学化学（大连理工）", "第六版教材，无机有机分析化学基础，理工科通识课必修教材。", new BigDecimal("26.00"), new BigDecimal("50.00"), 7, 1, "LOCKER", "学生公寓10栋", 1},
                    new Object[]{"c4f2d084e683", 4L, 1L, "普通生物学（陈阅增）", "第四版教材，细胞遗传生态进化生物多样性，生命科学通识课用书。", new BigDecimal("38.00"), new BigDecimal("75.00"), 8, 1, "FACE", "图书馆", 1},
                    new Object[]{"fe83dc29a0fe", 2L, 1L, "宏观经济学（曼昆）", "第九版中文版，经济学入门经典，GDP通胀货币政策讲解生动有趣。", new BigDecimal("45.00"), new BigDecimal("88.00"), 8, 0, "BOTH", "教学楼C座", 1},
                    new Object[]{"f21fc27e05ad", 3L, 1L, "微观经济学（平狄克）", "第八版教材，供需弹性市场结构博弈论，经济学专业核心课程教材。", new BigDecimal("48.00"), new BigDecimal("95.00"), 9, 0, "FACE", "图书馆自习室", 1},
                    // 电子数码类 (categoryId=2)
                    new Object[]{"f60da81a53a5", 4L, 2L, "MacBook Pro 14寸 M2芯片", "2023款深空灰，16G+512G，屏幕完美无瑕疵，电池循环仅80次左右。", new BigDecimal("8500.00"), new BigDecimal("14999.00"), 9, 0, "FACE", "实验楼B座", 1},
                    new Object[]{"5a3fbab83c83", 2L, 2L, "戴尔显示器27寸 U2723QE", "4K IPS面板，Type-C 90W供电，做毕设买的现在低价转让。", new BigDecimal("1200.00"), new BigDecimal("2699.00"), 9, 0, "FACE", "实验室", 1},
                    new Object[]{"505068e5340e", 3L, 2L, "罗技MX Master 3S无线鼠标", "人体工学设计，静音点击多设备切换，办公游戏两相宜。", new BigDecimal("380.00"), new BigDecimal("729.00"), 9, 1, "BOTH", "图书馆自习室", 1},
                    new Object[]{"068e27163155", 4L, 2L, "移动硬盘1TB 西部数据Elements", "USB3.0接口传输速度快，存储大量学习资料电影音乐毫无压力。", new BigDecimal("220.00"), new BigDecimal("399.00"), 8, 1, "FACE", "学生公寓5栋", 1},
                    new Object[]{"a82e342830d0", 2L, 2L, "小米手环8 NFC版", "血氧心率睡眠监测全功能，NFC刷门禁公交地铁超方便。", new BigDecimal("120.00"), new BigDecimal("249.00"), 8, 1, "LOCKER", "食堂门口", 1},
                    new Object[]{"5d1fbaa02abd", 3L, 2L, "华为MatePad 11 2024款", "鸿蒙系统生态联动，120Hz高刷屏，配原装键盘和手写笔一起出。", new BigDecimal("1800.00"), new BigDecimal("2799.00"), 9, 0, "FACE", "教学楼A座", 1},
                    new Object[]{"0bb496d3c4cb", 4L, 2L, "USB-C扩展坞 九合一", "HDMI/VGA/网口/USB/SD卡槽一应俱全，笔记本扩展神器。", new BigDecimal("150.00"), new BigDecimal("289.00"), 8, 1, "BOTH", "实验室", 1},
                    new Object[]{"a43ca1f49f47", 2L, 2L, "固态硬盘512G 三星980PRO", "PCIe 4.0高速SSD，读取速度7000MB/s，给电脑升级提速首选。", new BigDecimal("320.00"), new BigDecimal("599.00"), 9, 0, "FACE", "实验楼A座", 1},
                    new Object[]{"8c8248b8e50c", 3L, 2L, "充电头65W快充 氮化镓", "GaN技术小巧便携，同时充笔记本手机平板三不误。", new BigDecimal("85.00"), new BigDecimal("168.00"), 8, 1, "LOCKER", "食堂", 1},
                    new Object[]{"ce09c9e22ef3", 4L, 2L, "Surface Pro 9 i5 8G+256G", "二合一平板电脑，带原装键盘盖和触控笔，商务办公利器。", new BigDecimal("4200.00"), new BigDecimal("7988.00"), 9, 0, "FACE", "教学楼B座", 1},
                    new Object[]{"8f756ffc1740", 2L, 2L, "键盘膜 通用型透明", "防尘防水防油污，贴合度高不影响打字手感，笔记本保护必备。", new BigDecimal("8.00"), new BigDecimal("25.00"), 7, 1, "BOTH", "校门口", 1},
                    new Object[]{"04470d5368eb", 3L, 2L, "内存条16G DDR4 3200", "金士顿品牌兼容性好，给旧电脑升级内存流畅运行不再卡顿。", new BigDecimal("180.00"), new BigDecimal("329.00"), 9, 0, "FACE", "实验室", 1},
                    new Object[]{"cb55f3486572", 4L, 2L, "Type-C数据线 编织款1.5米", "尼龙编织抗折断，支持100W快充和数据传输，耐用性超强。", new BigDecimal("15.00"), new BigDecimal("39.00"), 8, 1, "LOCKER", "学生公寓10栋", 1},
                    new Object[]{"07131a874d92", 2L, 2L, "笔记本散热器 静音风扇", "五风扇强劲散热，多档位调节高度可调，夏天玩游戏必备。", new BigDecimal("65.00"), new BigDecimal("129.00"), 7, 1, "BOTH", "宿舍楼下", 1},
                    new Object[]{"61ede86d5f88", 3L, 2L, "Kindle Paperwhite 5代", "32G版墨水屏护眼阅读器，内置阅读灯调节，读书党必备神器。", new BigDecimal("680.00"), new BigDecimal("1068.00"), 8, 1, "FACE", "图书馆", 1},
                    new Object[]{"fca68134653a", 4L, 2L, "显示器支架增高架", "铝合金材质稳固承重，底部收纳空间大，改善坐姿保护颈椎。", new BigDecimal("78.00"), new BigDecimal("159.00"), 8, 1, "BOTH", "实验楼B座", 1},
                    new Object[]{"e565cb451439", 2L, 2L, "显卡RTX3060 12G版", "华硕TUF系列，矿后卡但测试稳定无暗病，吃鸡3A大作流畅运行。", new BigDecimal("1500.00"), new BigDecimal("2699.00"), 7, 0, "FACE", "实验室", 1},
                    new Object[]{"70692d4f1cca", 3L, 2L, "SSD移动固态硬盘 1TB", "三星T7 Shield三防款，读写速度1050MB/s，户外携带也不怕摔。", new BigDecimal("480.00"), new BigDecimal("899.00"), 9, 0, "LOCKER", "学生公寓5栋", 1},
                    new Object[]{"394933a0a2e9", 4L, 2L, "多口USB充电器 100W", "四口输出同时充多个设备，智能分配功率出差旅行居家都好用。", new BigDecimal("95.00"), new BigDecimal("189.00"), 8, 1, "BOTH", "食堂门口", 1},
                    new Object[]{"80b6546338c9", 2L, 2L, "iPad触控笔 Apple Pencil二代", "磁吸充电即用即连，压感精准绘画写字体验极佳，几乎全新。", new BigDecimal("550.00"), new BigDecimal("999.00"), 9, 0, "FACE", "女生宿舍楼", 1},
                    new Object[]{"450819d1165e", 3L, 2L, "网线转换器 RJ45转Type-C", "有线网络转接器，宿舍WiFi不稳定时插上网线秒变稳定连接。", new BigDecimal("35.00"), new BigDecimal("79.00"), 8, 1, "LOCKER", "学生公寓10栋", 1},
                    new Object[]{"008bc1b1b1e4", 4L, 2L, "三星平板Tab S7 FE 12.4寸", "大屏追剧网课神器，S Pen手写笔支持，配原装保护壳键盘。", new BigDecimal("1600.00"), new BigDecimal("2999.00"), 8, 1, "FACE", "教学楼C座", 1},
                    new Object[]{"14d83d05c7e2", 2L, 2L, "笔记本内胆包 15.6寸加厚", "防震防摔内衬柔软，多层隔袋收纳配件，通勤上课携带方便。", new BigDecimal("45.00"), new BigDecimal("99.00"), 8, 1, "BOTH", "校门口", 1},
                    new Object[]{"06b0ad10efb4", 3L, 2L, "鼠标垫超大号 游戏桌垫", "800x400mm超大尺寸锁边设计，防水耐脏桌面整洁美观。", new BigDecimal("38.00"), new BigDecimal("79.00"), 7, 1, "LOCKER", "宿舍楼下", 1},
                    new Object[]{"e4a5e81b80f0", 4L, 2L, "西部数据机械硬盘 4TB", "蓝盘7200转大容量存储，存照片视频资料足够用十年没问题。", new BigDecimal("350.00"), new BigDecimal("599.00"), 8, 1, "FACE", "实验室", 1},
                    new Object[]{"958b8b4268f6", 2L, 2L, "Bose SoundLink Mini II", "便携蓝牙音箱音质出众，低音浑厚人声清澈，聚会露营好伴侣。", new BigDecimal("580.00"), new BigDecimal("1099.00"), 8, 1, "BOTH", "体育馆", 1},
                    new Object[]{"a0f5092a5ad4", 3L, 2L, "小爱同学智能音箱Pro", "小爱同学语音助手智能家居控制中心，音质比普通版提升明显。", new BigDecimal("168.00"), new BigDecimal("299.00"), 8, 1, "FACE", "学生公寓5栋", 1},
                    new Object[]{"c5fc5d5efeb5", 4L, 2L, "GTX1660 Super显卡 6G", "七彩虹战斧系列，从自用主机拆下来的，吃鸡LOL完全没问题。", new BigDecimal("800.00"), new BigDecimal("1499.00"), 7, 0, "FACE", "实验室", 1},
                    new Object[]{"a68b2dccf297", 2L, 2L, "蓝牙适配器 USB 5.0", "台式机蓝牙接收发射器，连接耳机鼠标键盘延迟低稳定性好。", new BigDecimal("28.00"), new BigDecimal("59.00"), 8, 1, "LOCKER", "实验楼A座", 1},
                    new Object[]{"e9677cc94425", 3L, 2L, "HDMI转接线 2米高清", "支持4K@60Hz传输，连接显示器投影仪电视信号稳定无干扰。", new BigDecimal("22.00"), new BigDecimal("49.00"), 9, 1, "BOTH", "教室多媒体柜", 1},
                    new Object[]{"53f5517d81d6", 4L, 2L, "RTX3050显卡 8G版", "影驰金属大师系列，光追入门卡玩赛博朋克2077中画质流畅。", new BigDecimal("1100.00"), new BigDecimal("1899.00"), 8, 0, "FACE", "实验室", 1},
                    new Object[]{"a48a7ced02eb", 2L, 2L, "VGA转换器 HDMI转VGA", "老式投影仪显示器专用转接头，会议演示汇报必备小工具。", new BigDecimal("18.00"), new BigDecimal("45.00"), 8, 1, "LOCKER", "教学楼A座", 1},
                    new Object[]{"3e3807f0390b", 3L, 2L, "千兆路由器 WiFi6 AX3000", "TP-LINK XDR3010穿墙能力强，宿舍多人同时打游戏不卡顿。", new BigDecimal("180.00"), new BigDecimal("329.00"), 8, 1, "BOTH", "学生公寓10栋", 1},
                    new Object[]{"a563af30b02a", 4L, 2L, "网络交换机5口 千兆以太网", "铁壳材质散热好，宿舍组局域网联机打游戏文件共享必备。", new BigDecimal("65.00"), new BigDecimal("129.00"), 8, 1, "FACE", "宿舍楼下", 1},
                    new Object[]{"2db3fef1c4d9", 2L, 2L, "以太网千兆网卡 USB3.0", "免驱即插即用，台式机笔记本通用，有线连接比WiFi更稳定快速。", new BigDecimal("42.00"), new BigDecimal("89.00"), 9, 1, "LOCKER", "实验楼A座", 1},
                    new Object[]{"690f1e92a61e", 3L, 2L, "Intel Arc A750显卡 8G", "蓝戟品牌，Intel独显新品性价比高，视频剪辑编码加速强。", new BigDecimal("1400.00"), new BigDecimal("2299.00"), 9, 0, "FACE", "实验室", 1},
                    new Object[]{"0bb9e6f0da07", 4L, 2L, "DP转HDMI 4K适配器", "DisplayPort转HDMI转换头，显卡多屏输出扩展显示面积利器。", new BigDecimal("25.00"), new BigDecimal("55.00"), 9, 1, "BOTH", "实验楼B座", 1},
                    new Object[]{"26e6b5b9726d", 2L, 2L, "雷电3扩展坞 12合1", "贝尔金品牌高端扩展坞，双4K输出PD供电全接口覆盖。", new BigDecimal("850.00"), new BigDecimal("1599.00"), 9, 0, "FACE", "实验室", 1},
                    new Object[]{"7bb338ee96b2", 3L, 2L, "iPhone 13 256G 蓝色", "国行全网通在保，电池健康度91%，换新机了所以出掉自用的。", new BigDecimal("3200.00"), new BigDecimal("5999.00"), 8, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"2a444fe193df", 4L, 2L, "Switch游戏卡带 塞尔达王国之泪", "正版卡带通关一次保存档还在，可以继承进度继续冒险。", new BigDecimal("280.00"), new BigDecimal("398.00"), 9, 1, "LOCKER", "宿舍楼下", 1},
                    new Object[]{"adaf7bd9cf97", 2L, 2L, "PS5手柄 DualSense无线", "原装索尼手柄，自适应扳机震动反馈沉浸感强，PC也能用。", new BigDecimal("380.00"), new BigDecimal("549.00"), 9, 0, "BOTH", "体育馆", 1},
                    new Object[]{"affc6b4a9bb5", 3L, 2L, "GoPro Hero 10 Black运动相机", "5.3K高清录制防水防抖，滑雪冲浪骑行记录精彩瞬间。", new BigDecimal("2200.00"), new BigDecimal("3998.00"), 8, 1, "FACE", "体育馆器材室", 1},
                    // 生活用品类 (categoryId=3)
                    new Object[]{"e8980510fb88", 4L, 3L, "落地台灯 护眼LED", "三色温调节无频闪护眼，亮度无极调光，看书学习长时间不累眼。", new BigDecimal("68.00"), new BigDecimal("138.00"), 8, 1, "FACE", "学生公寓5栋", 1},
                    new Object[]{"4e3c89e749bd", 2L, 3L, "飞科剃须刀电动FS339", "全身水洗干湿双剃，续航持久刀头锋利，用了半年依然给力。", new BigDecimal("85.00"), new BigDecimal("179.00"), 8, 1, "BOTH", "男生宿舍楼", 1},
                    new Object[]{"d581c05fc4da", 3L, 3L, "加湿器超声波静音", "5L大容量水箱持续加湿整晚，缺水自动断电安全放心。", new BigDecimal("79.00"), new BigDecimal("159.00"), 7, 1, "LOCKER", "学生公寓10栋", 1},
                    new Object[]{"215adcfbe0ff", 4L, 3L, "暖宝宝贴 自发热20片", "冬季保暖神器贴在身上暖暖的，每片可持续发热8小时以上。", new BigDecimal("15.00"), new BigDecimal("35.00"), 10, 1, "FACE", "校门口超市", 1},
                    new Object[]{"1b2d73716512", 2L, 3L, "收纳箱三件套 带盖", "大中小三个尺寸叠放节省空间，衣服被子杂物分类整理井井有条。", new BigDecimal("55.00"), new BigDecimal("108.00"), 8, 1, "BOTH", "宿舍楼下", 1},
                    new Object[]{"e2b23526fcc5", 3L, 3L, "无线充电板 15W快充", "Qi协议通用兼容iPhone安卓，薄如纸片放包里随身携带。", new BigDecimal("45.00"), new BigDecimal("89.00"), 8, 1, "LOCKER", "食堂门口", 1},
                    new Object[]{"b712e1fd4ccd", 4L, 3L, "毛毯被子 加厚珊瑚绒", "冬季保暖必备柔软亲肤不掉毛，午睡盖在身上超级舒服温暖。", new BigDecimal("68.00"), new BigDecimal("139.00"), 8, 1, "FACE", "女生宿舍3栋", 1},
                    new Object[]{"6db5f55ff2fe", 2L, 3L, "电动指甲刀 自动研磨", "USB充电式安全不伤手，老人小孩都能轻松使用修剪指甲。", new BigDecimal("58.00"), new BigDecimal("118.00"), 7, 1, "BOTH", "校门口", 1},
                    new Object[]{"249d0a6692af", 3L, 3L, "蒸汽眼罩 发热贴10片装", "缓解眼部疲劳助眠安神，熬夜刷题后敷一片眼睛立刻放松下来。", new BigDecimal("18.00"), new BigDecimal("42.00"), 10, 1, "LOCKER", "图书馆", 1},
                    new Object[]{"b112a9c2e58f", 4L, 3L, "U型枕旅行枕 记忆棉", "长途火车飞机必备护颈枕，慢回弹记忆棉支撑力好不易变形。", new BigDecimal("32.00"), new BigDecimal("68.00"), 8, 1, "FACE", "校门口", 1},
                    new Object[]{"d03140ae627b", 2L, 3L, "驱蚊喷雾花露水套装", "夏季驱蚊止痒清凉舒爽，户外活动军训体育课必备防蚊神器。", new BigDecimal("25.00"), new BigDecimal("52.00"), 9, 1, "BOTH", "操场边商店", 1},
                    new Object[]{"233991737d46", 3L, 3L, "泡脚桶塑料加深款", "保温效果好泡到小腿肚，冬天睡前泡泡脚全身暖洋洋睡得香。", new BigDecimal("38.00"), new BigDecimal("79.00"), 7, 1, "FACE", "学生公寓5栋", 1},
                    new Object[]{"2978f9787844", 4L, 3L, "冰丝凉席 三件套1.5m床", "夏季降温神器透气凉爽不粘身，折叠收纳方便搬家带走容易。", new BigDecimal("85.00"), new BigDecimal("168.00"), 8, 1, "LOCKER", "女生宿舍3栋", 1},
                    new Object[]{"ed3771eeaa6c", 2L, 3L, "蒸汽眼罩发热贴 热敷款", "恒温42度热敷促进眼部血液循环，缓解黑眼圈干涩疲劳。", new BigDecimal("20.00"), new BigDecimal("45.00"), 10, 1, "BOTH", "图书馆", 1},
                    new Object[]{"9b2200f4cb1c", 3L, 3L, "瑜伽砖弹力轮套装", "瑜伽普拉提辅助工具开肩美背拉伸筋膜放松运动后恢复用。", new BigDecimal("42.00"), new BigDecimal("85.00"), 8, 1, "FACE", "体育馆", 1},
                    new Object[]{"59a85efdf9fe", 4L, 3L, "乳胶枕记忆枕头", "泰国天然乳胶材质支撑颈椎，回弹性好睡了脖子再也不酸了。", new BigDecimal("120.00"), new BigDecimal("258.00"), 9, 1, "BOTH", "女生宿舍3栋", 1},
                    new Object[]{"072b1123eafa", 2L, 3L, "夏季凉被空调被 薄款", "天丝面料亲肤透气吸汗排湿，夏天开空调盖着刚刚好不会冷。", new BigDecimal("75.00"), new BigDecimal("148.00"), 8, 1, "FACE", "学生公寓5栋", 1},
                    new Object[]{"ddaefb3e0680", 3L, 3L, "竹席藤席双面席 1.8m", "一面竹一面藤两面可用，夏季凉爽冬季也可当床垫铺着睡。", new BigDecimal("95.00"), new BigDecimal("188.00"), 7, 1, "LOCKER", "宿舍楼下", 1},
                    new Object[]{"a89c635c3cd2", 4L, 3L, "纯棉四件套床单被套", "新疆长绒棉贡缎面料柔软舒适，简约纯色百搭宿舍床上用品。", new BigDecimal("158.00"), new BigDecimal("299.00"), 9, 1, "FACE", "女生宿舍3栋", 1},
                    new Object[]{"238c094e2713", 2L, 3L, "珊瑚绒毛毯 加厚冬季", "冬季窝在沙发上看剧盖着超暖和，绒毛细腻不掉毛亲肤舒适。", new BigDecimal("88.00"), new BigDecimal("175.00"), 8, 1, "BOTH", "学生公寓10栋", 1},
                    new Object[]{"2828a835d385", 3L, 3L, "法兰绒睡袍浴袍", "浴后穿衣保暖吸水速干，酒店同款质感在家也能享受SPA体验。", new BigDecimal("68.00"), new BigDecimal("139.00"), 8, 1, "FACE", "女生宿舍3栋", 1},
                    new Object[]{"fe216815dc2f", 4L, 3L, "真丝枕巾一对装", "桑蚕丝面料光滑凉爽保护面部皮肤，美容觉必备提升睡眠品质。", new BigDecimal("78.00"), new BigDecimal("158.00"), 9, 1, "LOCKER", "女生宿舍3栋", 1},
                    new Object[]{"04a4516eff08", 2L, 3L, "莫代尔睡衣套装 长袖", "莫代尔面料柔软透气吸湿排汗，家居服穿着舒适自在随意。", new BigDecimal("65.00"), new BigDecimal("128.00"), 8, 1, "BOTH", "女生宿舍楼", 1},
                    new Object[]{"06fc05d9e304", 3L, 3L, "小米台灯二代 护眼LED", "智能调光调色温APP控制，国A级照度均匀无频闪护眼认证。", new BigDecimal("89.00"), new BigDecimal("169.00"), 9, 1, "FACE", "学生公寓5栋", 1},
                    new Object[]{"745d74260895", 4L, 3L, "智能插座 WiFi远程控制", "手机App开关定时倒计时，出门忘关电器远程一键断电安心。", new BigDecimal("35.00"), new BigDecimal("69.00"), 8, 1, "LOCKER", "学生公寓10栋", 1},
                    new Object[]{"8ff10a246acf", 2L, 3L, "保温杯500ml 不锈钢", "304食品级不锈钢真空保温，早上装的热水下午还烫嘴。", new BigDecimal("28.00"), new BigDecimal("58.00"), 8, 1, "BOTH", "食堂门口", 1},
                    new Object[]{"954ab8c02182", 3L, 3L, "雨伞折叠全自动", "一键开收晴雨两用抗风骨架结实，下雨天上课出行必备品。", new BigDecimal("32.00"), new BigDecimal("65.00"), 7, 1, "FACE", "校门口", 1},
                    new Object[]{"5e1a2ae721e5", 4L, 3L, "除湿剂干燥剂 衣柜用", "梅雨季节衣柜防潮防霉除味，吸满水后更换新的简单方便。", new BigDecimal("12.00"), new BigDecimal("28.00"), 10, 1, "LOCKER", "宿舍楼下", 1},
                    new Object[]{"17773c6c83ab", 2L, 3L, "空气清新剂喷雾", "去除宿舍异味烟味汗味，淡淡清香让房间空气清新宜人。", new BigDecimal("15.00"), new BigDecimal("35.00"), 9, 1, "BOTH", "学生公寓10栋", 1},
                    new Object[]{"7d27149a41ca", 3L, 3L, "纸巾抽纸一箱24包", "原生木浆柔韧湿水不破，一箱够用一个学期超划算囤货价。", new BigDecimal("35.00"), new BigDecimal("68.00"), 10, 1, "FACE", "校门口超市", 1},
                    new Object[]{"93d0157ae8be", 4L, 3L, "洗衣液补充装 2kg", "浓缩配方去污力强留香持久，便宜大碗洗一整个学期没问题。", new BigDecimal("28.00"), new BigDecimal("55.00"), 10, 1, "LOCKER", "洗衣房", 1},
                    new Object[]{"667c24e5ee8e", 2L, 3L, "垃圾袋卷装 加厚黑色", "50只装点断式抽取方便，韧性足不易破宿舍厨房卫生间通用。", new BigDecimal("8.00"), new BigDecimal("19.00"), 10, 1, "BOTH", "校门口超市", 1},
                    new Object[]{"614a236567e0", 3L, 3L, "洗脸盆塑料 大号圆形", "加厚PP材质耐摔耐用，洗脸洗衣服泡脚多功能一盆多用。", new BigDecimal("10.00"), new BigDecimal("25.00"), 8, 1, "FACE", "宿舍楼下", 1},
                    new Object[]{"3b747450594a", 4L, 3L, "衣架20支装 塑料防滑", "晾衣架带凹槽防滑设计晒衣服不滑落，宿舍生活必需品消耗品。", new BigDecimal("12.00"), new BigDecimal("28.00"), 9, 1, "LOCKER", "洗衣房", 1},
                    new Object[]{"886c15cefd63", 2L, 3L, "拖鞋夏季 凉拖防滑", "EVA材质轻便柔软踩屎感十足，浴室洗澡宿舍行走都不错。", new BigDecimal("15.00"), new BigDecimal("35.00"), 8, 1, "BOTH", "宿舍楼下", 1},
                    // 运动户外类 (categoryId=4)
                    new Object[]{"3e17db56c397", 3L, 4L, "Adidas UltraBoost运动鞋", "爆米花中底缓震回弹好，跑步健身日常穿搭都能驾驭。", new BigDecimal("380.00"), new BigDecimal("1299.00"), 8, 1, "FACE", "体育馆", 1},
                    new Object[]{"164c3e007476", 4L, 4L, "斯伯丁篮球 室内外通用", "7号标准篮球PU材质耐磨防滑，手感好投篮准适合日常训练。", new BigDecimal("120.00"), new BigDecimal("239.00"), 7, 1, "BOTH", "体育馆器材室", 1},
                    new Object[]{"2bbf0977c8c2", 2L, 4L, "跳绳轴承钢丝绳", "可调节长度PVC手柄防滑，跳绳燃脂减肥有氧运动入门必备。", new BigDecimal("18.00"), new BigDecimal("45.00"), 8, 1, "LOCKER", "操场边", 1},
                    new Object[]{"81f05ed73021", 3L, 4L, "公路自行车 禧玛诺变速", "21速铝合金车架轻便快捷，校园通勤骑行锻炼身体两不误。", new BigDecimal("650.00"), new BigDecimal("1299.00"), 8, 0, "FACE", "自行车棚", 1},
                    new Object[]{"da4f379af0fa", 4L, 4L, "羽毛球鞋 尤尼克斯防滑", "透气网面轻量化设计，场地抓地力强急停转向不打滑。", new BigDecimal("180.00"), new BigDecimal("399.00"), 7, 1, "BOTH", "体育馆", 1},
                    new Object[]{"4705732a16e3", 2L, 4L, "乒乓球拍 直板双面反胶", "红双喜星级成品拍，正手反手攻守兼备初学者上手就能用。", new BigDecimal("65.00"), new BigDecimal("138.00"), 7, 1, "FACE", "体育馆器材室", 1},
                    new Object[]{"49b6d96fdcbd", 3L, 4L, "足球 5号比赛用球", "FIFA认证PU表皮缝制工艺，踢起来脚感扎实传球精准。", new BigDecimal("88.00"), new BigDecimal("178.00"), 7, 1, "BOTH", "操场足球场", 1},
                    new Object[]{"5994d85d6dbb", 4L, 4L, "网球拍 全碳素一体", "威尔逊入门款轻量易控，新手练球进阶都能满足需求。", new BigDecimal("220.00"), new BigDecimal("459.00"), 8, 1, "FACE", "网球场", 1},
                    new Object[]{"c80cb97d3cea", 2L, 4L, "健身哑铃一对 可调节", "环保包胶防滚落伤地板，重量可调男女适用家庭健身房装备。", new BigDecimal("150.00"), new BigDecimal("299.00"), 8, 1, "BOTH", "体育馆", 1},
                    new Object[]{"e6266b99f1e9", 3L, 4L, "弹力带健身带阻力带", "五档不同阻力力量训练拉伸康复，便携易收纳随时随地练。", new BigDecimal("28.00"), new BigDecimal("65.00"), 8, 1, "LOCKER", "体育馆更衣室", 1},
                    new Object[]{"cb4b478b16b7", 4L, 4L, "瑜伽垫加厚10mm防滑", "NBR材质双纹路防滑，厚度适中跪姿练习膝盖不疼。", new BigDecimal("45.00"), new BigDecimal("98.00"), 7, 1, "FACE", "体育馆", 1},
                    new Object[]{"fbcc3a1ce21d", 2L, 4L, "泡沫轴按摩轴肌肉放松", "EVA实心滚轴缓解肌肉酸痛筋膜放松，运动后恢复必备神器。", new BigDecimal("35.00"), new BigDecimal("79.00"), 8, 1, "BOTH", "体育馆更衣室", 1},
                    new Object[]{"1add6a4e1da6", 3L, 4L, "登山杖一对 碳纤维超轻", "三节可调长度外锁扣固定，徒步登山越野跑减轻膝盖压力。", new BigDecimal("120.00"), new BigDecimal("258.00"), 8, 1, "FACE", "校门口", 1},
                    new Object[]{"84a8749833eb", 4L, 4L, "登山包 40L专业徒步", "防水面料背负系统科学透气，周末爬山郊游装装备容量刚好。", new BigDecimal("180.00"), new BigDecimal("389.00"), 8, 1, "BOTH", "校门口", 1},
                    new Object[]{"4c592aa2faad", 2L, 4L, "滑板 双翘四轮专业", "加拿大枫木板面弹性好，初学刷街代步炫酷动作都能练。", new BigDecimal("250.00"), new BigDecimal("499.00"), 7, 1, "FACE", "操场广场", 1},
                    new Object[]{"8caa2f98c5bf", 3L, 4L, "捷安特山地车 ATX660", "21速碟刹避震前叉，山地骑行穿越林道越野性能出色。", new BigDecimal("1200.00"), new BigDecimal("2398.00"), 8, 0, "FACE", "自行车棚", 1},
                    new Object[]{"529cdeae2a38", 4L, 4L, "跑步鞋 亚瑟士GEL-KAYANO", "顶级稳定系跑鞋GEL缓震胶，长距离跑步保护膝盖不受伤。", new BigDecimal("550.00"), new BigDecimal("1099.00"), 8, 1, "BOTH", "体育馆", 1},
                    new Object[]{"83108789e0d7", 2L, 4L, "泳镜泳帽套装 防雾高清", "大视野防雾泳镜硅胶泳帽不勒头，游泳馆训练比赛都能戴。", new BigDecimal("38.00"), new BigDecimal("79.00"), 8, 1, "FACE", "游泳馆", 1},
                    new Object[]{"6a72b8dbec39", 3L, 4L, "帐篷户外 3-4人双层", "铝杆搭建快速防风防雨，春游露营野外过夜遮风挡雨好帮手。", new BigDecimal("280.00"), new BigDecimal("559.00"), 7, 1, "BOTH", "校门口", 1},
                    new Object[]{"e3f234d2a9f7", 4L, 4L, "登山靴 高帮防水徒步", "Gore-Tex防水透气 Vibram大底抓地，雨天山路行走也不怕湿鞋。", new BigDecimal("350.00"), new BigDecimal("728.00"), 8, 1, "FACE", "校门口", 1},
                    new Object[]{"7fa5c400431b", 2L, 4L, "骑行头盔 公路山地通用", "EPS泡沫缓冲层PC外壳防护，骑车安全第一头盔不能少。", new BigDecimal("88.00"), new BigDecimal("178.00"), 8, 1, "BOTH", "自行车棚", 1},
                    new Object[]{"d4eb20cb75c3", 3L, 4L, "健身手套 护腕防滑半指", "掌心硅胶防滑垫护腕支撑，举铁引体向上防起茧磨手。", new BigDecimal("25.00"), new BigDecimal("55.00"), 7, 1, "LOCKER", "体育馆更衣室", 1},
                    new Object[]{"2f021503f504", 4L, 4L, "引体向上器 门上单杠", "免打孔安装承重200公斤，宿舍门框上就能练背部手臂力量。", new BigDecimal("68.00"), new BigDecimal("138.00"), 8, 1, "FACE", "学生公寓5栋", 1},
                    new Object[]{"bbb9697810d1", 2L, 4L, "瑜伽服套装 运动紧身", "高弹速干面料吸汗排湿，瑜伽普拉提跑步健身一套搞定。", new BigDecimal("98.00"), new BigDecimal("198.00"), 8, 1, "BOTH", "体育馆更衣室", 1},
                    new Object[]{"a62eba949a9e", 3L, 4L, "速干T恤 户外运动短袖", "聚酯纤维速干透气防晒UPF50+，夏天户外运动出汗不黏身。", new BigDecimal("45.00"), new BigDecimal("98.00"), 7, 1, "FACE", "体育馆", 1},
                    // 服饰美妆类 (categoryId=5)
                    new Object[]{"0ac0355ac44e", 4L, 5L, "口红套装 MAC子弹头3支", "热门色号Chili/Marrakesh/Ruby Woo全新未试色，专柜正品。", new BigDecimal("320.00"), new BigDecimal("570.00"), 10, 0, "FACE", "女生宿舍楼", 1},
                    new Object[]{"a09a27ea2acd", 2L, 5L, "护肤品礼盒 兰蔻小黑瓶", "精华肌底液50ml+面霜15ml+眼霜5ml，朋友送的礼物自己不用出掉。", new BigDecimal("450.00"), new BigDecimal("820.00"), 10, 0, "BOTH", "女生宿舍3栋", 1},
                    new Object[]{"120232263cf5", 3L, 5L, "隔离霜防晒 SPF50+", "妆前乳防晒霜二合一提亮肤色隐形毛孔，日常护肤化妆一步到位。", new BigDecimal("85.00"), new BigDecimal("168.00"), 9, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"fca5423123c6", 4L, 5L, "面膜补水保湿 20片装", "玻尿酸深层补水收缩毛孔急救面膜，敷完脸蛋水嫩嫩上妆服帖。", new BigDecimal("48.00"), new BigDecimal("98.00"), 10, 1, "LOCKER", "女生宿舍3栋", 1},
                    new Object[]{"8ee08f5cdb70", 2L, 5L, "针织毛衣 圆领宽松慵懒风", "秋冬必备单品温柔软糯质感好，搭配牛仔裤半身裙都好看。", new BigDecimal("88.00"), new BigDecimal("198.00"), 8, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"e4f36aca2266", 3L, 5L, "格子衬衫 牛津纺长袖", "学院风百搭单品春秋冬三季能穿，内搭外穿叠穿层次感满满。", new BigDecimal("65.00"), new BigDecimal("139.00"), 8, 1, "BOTH", "女生宿舍3栋", 1},
                    new Object[]{"4e5b2d76afc6", 4L, 5L, "风衣外套 中长款卡其色", "经典英伦风衣版型挺括气质佳，春秋季节挡风遮雨时尚又实用。", new BigDecimal("188.00"), new BigDecimal("399.00"), 8, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"4b5ac56faecd", 2L, 5L, "针织开衫 V领温柔系", "软糯亲肤手感好颜色温柔显白，春秋单穿冬季内搭都很合适。", new BigDecimal("78.00"), new BigDecimal("168.00"), 8, 1, "BOTH", "女生宿舍3栋", 1},
                    new Object[]{"cc7076d98903", 3L, 5L, "连帽卫衣 宽松oversize", "美式街头风落肩袖设计显瘦，下衣失踪穿法时髦又减龄。", new BigDecimal("95.00"), new BigDecimal("199.00"), 8, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"a437fa7aea79", 4L, 5L, "针织连衣裙 法式茶歇裙", "收腰显瘦V领优雅女人味十足，约会逛街拍照出片率超高。", new BigDecimal("128.00"), new BigDecimal("268.00"), 9, 1, "LOCKER", "女生宿舍3栋", 1},
                    new Object[]{"9714fac4f13a", 2L, 5L, "牛仔裤修身 小脚铅笔裤", "高腰弹力面料修饰腿型显腿长，四季百搭单品衣橱必备。", new BigDecimal("98.00"), new BigDecimal("219.00"), 8, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"b76fd6f86292", 3L, 5L, "羽绒服短款 白鸭绒轻薄", "90%白鸭绒填充轻盈保暖不臃肿，南方冬天一件就够穿了。", new BigDecimal("280.00"), new BigDecimal("599.00"), 9, 1, "BOTH", "女生宿舍3栋", 1},
                    new Object[]{"3176d8654af8", 4L, 5L, "T恤纯棉 圆领基础款白T", "新疆长绒棉面料透气舒适不起球，打底外穿叠穿万能百搭。", new BigDecimal("35.00"), new BigDecimal("79.00"), 8, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"3616d7445479", 2L, 5L, "短裤运动 速干宽松五分裤", "侧边条纹设计运动风十足，跑步健身休闲居家一条裤子搞定。", new BigDecimal("48.00"), new BigDecimal("108.00"), 7, 1, "BOTH", "体育馆", 1},
                    new Object[]{"a23fad6cab5b", 3L, 5L, "帆布鞋匡威 经典低帮All Star", "黑白配色永不过时百搭之王，搭配裙子裤子都好看青春活力。", new BigDecimal("220.00"), new BigDecimal("439.00"), 8, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"83786561c061", 4L, 5L, "皮鞋商务 正装面试皮鞋", "真皮材质头层牛皮做工精细，求职面试正式场合必备体面。", new BigDecimal("158.00"), new BigDecimal("359.00"), 8, 1, "BOTH", "男生宿舍楼", 1},
                    new Object[]{"6c95e3b922e8", 2L, 5L, "帽子棒球 NY刺绣鸭舌帽", "经典NY logo刺绣精致，遮阳防晒凹造型街头潮人必备单品。", new BigDecimal("45.00"), new BigDecimal("98.00"), 8, 1, "FACE", "校门口", 1},
                    new Object[]{"7c8d9e0f1a2b", 3L, 5L, "围巾冬季 羊毛混纺格纹", "英伦风格纹图案复古文艺，围上瞬间提升整体造型质感温度。", new BigDecimal("68.00"), new BigDecimal("148.00"), 8, 1, "BOTH", "女生宿舍楼", 1},
                    new Object[]{"9d0e1f2a3b4c", 4L, 5L, "手套皮草 兔毛触屏手套", "兔毛拼接皮质触屏可操作手机，冬季保暖又不影响玩手机。", new BigDecimal("55.00"), new BigDecimal("118.00"), 8, 1, "FACE", "校门口", 1},
                    new Object[]{"a1b2c3d4e5f0a", 2L, 5L, "墨镜太阳镜 偏光驾驶眼镜", "UV400防紫外线偏光镜片，开车出行防晒遮阳时尚潮流单品。", new BigDecimal("78.00"), new BigDecimal("168.00"), 9, 1, "BOTH", "校门口", 1},
                    new Object[]{"b2c3d4e5f6a1b", 3L, 5L, "发箍发夹 韩国ins风套装", "珍珠水钻蝴蝶结多种款式，扎头发编发造型点缀精致可爱。", new BigDecimal("25.00"), new BigDecimal("58.00"), 9, 1, "LOCKER", "女生宿舍3栋", 1},
                    new Object[]{"c3d4e5f6a1b2c", 4L, 5L, "胸针配饰 复古徽章胸花", "日系复古风格别针胸针，点缀在大衣毛衣上瞬间提升精致感。", new BigDecimal("18.00"), new BigDecimal("42.00"), 9, 1, "FACE", "女生宿舍楼", 1},
                    new Object[]{"d4e5f6a1b2c3d", 2L, 5L, "腰带皮带 真皮针扣腰带", "头层牛皮材质耐用有质感，西裤牛仔裤休闲裤都能搭配。", new BigDecimal("48.00"), new BigDecimal("108.00"), 8, 1, "BOTH", "男生宿舍楼", 1},
                    new Object[]{"e5f6a1b2c3d4e", 3L, 5L, "袜子棉质 中筒袜5双装", "纯棉材质吸汗透气不臭脚，黑白灰基础色每天换着穿。", new BigDecimal("15.00"), new BigDecimal("35.00"), 10, 1, "LOCKER", "女生宿舍3栋", 1},
                    new Object[]{"f6a1b2c3d4e5f", 4L, 5L, "内衣套装 文胸内裤组合", "无钢圈舒适聚拢调整型文胸配纯棉内裤，贴身衣物要选好的。", new BigDecimal("68.00"), new BigDecimal("148.00"), 9, 1, "FACE", "女生宿舍3栋", 1},
                    // 图书音像类 (categoryId=6)
                    new Object[]{"a1b2c3d4e5f01", 2L, 6L, "雅思词汇书 绿宝书", "雅思考试核心词汇5500词乱序版，词根词缀联想记忆法高效背单词。", new BigDecimal("32.00"), new BigDecimal("68.00"), 8, 1, "FACE", "图书馆", 1},
                    new Object[]{"b2c3d4e5f6a02", 3L, 6L, "托福红宝书 45天突破", "托福考试高频词汇精选，例句丰富语境记忆效果更好。", new BigDecimal("38.00"), new BigDecimal("79.00"), 8, 1, "LOCKER", "图书馆自习室", 1},
                    new Object[]{"c3d4e5f6a1b03", 4L, 6L, "GRE词汇再要你命3000", "GRE考试必备词汇书，难度分级循序渐进攻克GRE词汇难关。", new BigDecimal("45.00"), new BigDecimal("92.00"), 8, 1, "FACE", "图书馆", 1},
                    new Object[]{"d4e5f6a1b2c04", 2L, 6L, "四级词汇乱序版 新东方", "大学英语四级考试核心词汇，乱序编排避免ABCD顺序记忆疲劳。", new BigDecimal("22.00"), new BigDecimal("48.00"), 7, 1, "BOTH", "图书馆", 1},
                    new Object[]{"e5f6a1b2c3d05", 3L, 6L, "GMAT备考资料官方指南", "GMAT考试OG官方指南最新版，真题模拟题解析详细权威。", new BigDecimal("58.00"), new BigDecimal("118.00"), 9, 0, "FACE", "图书馆自习室", 1},
                    new Object[]{"f6a1b2c3d4e06", 4L, 6L, "考研英语阅读理解精读100篇", "张剑黄皮书系列，历年真题阅读逐句精解，考研英语必备资料。", new BigDecimal("42.00"), new BigDecimal("86.00"), 7, 1, "LOCKER", "图书馆", 1},
                    new Object[]{"a1b2c3d4e5f07", 2L, 6L, "英语专四真题试卷", "TEM-4历年真题10套卷含解析，听力阅读写作完形填空全覆盖。", new BigDecimal("28.00"), new BigDecimal("58.00"), 7, 1, "FACE", "图书馆自习室", 1},
                    new Object[]{"b2c3d4e5f6a08", 3L, 6L, "新概念英语3 培养技能", "经典英语教材第三册，提升英语综合能力听说读写全方位进步。", new BigDecimal("35.00"), new BigDecimal("72.00"), 8, 1, "BOTH", "图书馆", 1},
                    new Object[]{"c3d4e5f6a1b09", 4L, 6L, "经济学原理 曼昆宏观分册", "微观经济学姊妹篇，宏观经济政策理论深入浅出通俗易懂。", new BigDecimal("48.00"), new BigDecimal("98.00"), 8, 1, "FACE", "图书馆", 1},
                    new Object[]{"d4e5f6a1b2c0a", 2L, 6L, "心理学与生活 津巴多第19版", "心理学入门经典读物，认知情绪人格发展社会心理全覆盖。", new BigDecimal("55.00"), new BigDecimal("112.00"), 8, 1, "LOCKER", "图书馆自习室", 1},
                    // 其他闲置类 (categoryId=7)
                    new Object[]{"e5f6a1b2c3d0b", 3L, 7L, "机械手表 卡西欧光动能", "太阳能充电无需换电池，不锈钢表带防水100米走时精准。", new BigDecimal("380.00"), new BigDecimal("798.00"), 8, 1, "FACE", "男生宿舍楼", 1},
                    new Object[]{"f6a1b2c3d4e0c", 4L, 7L, "电热毯单人 安全调温", "三档温度调节定时关闭功能，冬季宿舍取暖神器暖身又暖心。", new BigDecimal("65.00"), new BigDecimal("138.00"), 8, 1, "BOTH", "学生公寓5栋", 1},
                    new Object[]{"a1b2c3d4e5f0d", 2L, 7L, "电动理发器 成人儿童通用", "陶瓷刀头不伤头皮低噪音，自己理发省钱方便全家都能用。", new BigDecimal("78.00"), new BigDecimal("159.00"), 8, 1, "FACE", "男生宿舍楼", 1},
                    new Object[]{"b2c3d4e5f6a0e", 3L, 7L, "体脂秤智能称重 蓝牙APP", "测量体重体脂率肌肉量骨量BMI，健康数据同步手机追踪变化。", new BigDecimal("68.00"), new BigDecimal("139.00"), 8, 1, "LOCKER", "学生公寓10栋", 1},
                    new Object[]{"c3d4e5f6a1b0f", 4L, 7L, "旅行洗漱包 防水分装瓶", "大容量收纳洗漱用品牙膏牙刷化妆品，出差旅行必备整理好物。", new BigDecimal("32.00"), new BigDecimal("68.00"), 8, 1, "BOTH", "校门口", 1},
                    new Object[]{"d4e5f6a1b2c10", 2L, 7L, "旅行拉杆箱24寸 万向轮", "PC材质抗压耐摔万向轮顺滑，短期出差旅行容量刚刚好。", new BigDecimal("188.00"), new BigDecimal("389.00"), 8, 1, "FACE", "校门口", 1},
                    new Object[]{"e5f6a1b2c3d11", 3L, 7L, "双肩背包电脑包 15.6寸", "防盗设计多隔层分区收纳，笔记本电脑平板书本雨伞都能装。", new BigDecimal("98.00"), new BigDecimal("208.00"), 8, 1, "BOTH", "学生公寓10栋", 1},
                    new Object[]{"f6a1b2c3d4e12", 4L, 7L, "钱包长款 真皮多卡位", "头层牛皮材质做工精致，卡位充足现金身份证银行卡分类存放。", new BigDecimal("68.00"), new BigDecimal("148.00"), 8, 1, "FACE", "校门口", 1},
                    new Object[]{"a1b2c3d4e5f13", 2L, 7L, "钥匙扣挂件 创意卡通", "可爱卡通造型钥匙挂件找钥匙方便，挂在书包上也很好看装饰。", new BigDecimal("12.00"), new BigDecimal("28.00"), 9, 1, "LOCKER", "校门口", 1},
                    new Object[]{"b2c3d4e5f6a14", 3L, 7L, "耳机绕线器 数据线收纳", "硅胶绕线器整理耳机数据线充电线，告别缠绕打结桌面整洁。", new BigDecimal("8.00"), new BigDecimal("19.00"), 10, 1, "BOTH", "学生公寓10栋", 1}
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
