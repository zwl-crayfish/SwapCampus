package com.swapcampus.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.swapcampus.entity.Wallet;
import org.apache.ibatis.annotations.Mapper;

/**
 * 钱包 Mapper
 */
@Mapper
public interface WalletMapper extends BaseMapper<Wallet> {
}
