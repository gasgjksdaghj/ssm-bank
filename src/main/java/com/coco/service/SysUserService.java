package com.coco.service;

import com.coco.pojo.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

public interface SysUserService {
    // 注册新用户
    void register(SysUser user);

    // 更新用户信息
    void updateUser(SysUser user);

    // 删除用户
    void deleteUser(Integer id);

    // 根据ID获取用户
    SysUser getUserById(Integer id);

    // 获取所有用户
    List<SysUser> getAllUsers();

    // 用户登录
    SysUser login(String username, String password);

    // 检查用户名是否已存在
    boolean isUsernameExist(String username);

    // 根据创建时间范围查询用户
    List<SysUser> getUsersByCreateTimeRange(LocalDateTime startTime, LocalDateTime endTime, String nickname);

    // 修改密码
    void changePassword(Integer userId, String oldPassword, String newPassword);

    // 重置密码
    void resetPassword(Integer userId);
}