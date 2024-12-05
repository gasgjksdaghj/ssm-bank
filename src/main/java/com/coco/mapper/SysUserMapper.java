package com.coco.mapper;

import com.coco.pojo.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.time.LocalDateTime;
import java.util.List;

@Mapper
public interface SysUserMapper {
    // 插入新用户
    int insert(SysUser user);

    // 根据ID更新用户信息
    int update(SysUser user);

    // 根据ID删除用户
    int deleteById(Integer id);

    // 根据ID查询用户
    SysUser selectById(Integer id);

    // 查询所有用户
    List<SysUser> selectAll();

    // 用户登录
    SysUser selectByUsername(String username);


    // 检查用户名是否已存在
    int checkUsernameExist(String username);

    // 根据创建时间范围查询用户
    List<SysUser> selectByCreateTimeRange(@Param("startTime") LocalDateTime startTime,
                                          @Param("endTime") LocalDateTime endTime, @Param("nickname") String nickname);

    // 修改密码
    int updatePassword(@Param("id") Integer id, @Param("newPassword") String newPassword);

    // 重置密码
    int resetPassword(@Param("id") Integer id, @Param("defaultPassword") String defaultPassword);
}