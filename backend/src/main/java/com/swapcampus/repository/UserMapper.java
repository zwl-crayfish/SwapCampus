package com.swapcampus.repository;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import com.swapcampus.entity.User;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

/**
 * 用户 Mapper
 */
@Mapper
public interface UserMapper extends BaseMapper<User> {
    @Select("SELECT * FROM users WHERE username = #{username}")
    User findByUsername(String username);

    @Select("SELECT * FROM users WHERE student_id = #{studentId}")
    User findByStudentId(String studentId);
}
