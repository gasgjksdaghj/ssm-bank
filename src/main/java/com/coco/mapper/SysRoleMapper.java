package com.coco.mapper;

import com.coco.pojo.SysRole;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysRoleMapper {
    // 插入新角色
    int insert(SysRole role);

    // 更新角色信息
    int update(SysRole role);

    // 根据ID删除角色
    int deleteById(Integer id);

    // 根据ID查询角色
    SysRole selectById(Integer id);

    // 查询所有角色
    List<SysRole> selectAll();

    List<SysRole> selectBySearch(@Param("search") String search);
}