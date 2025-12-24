package com.coco.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import java.util.List;
import java.util.Map;

@Mapper
public interface DashboardMapper {
//定义了一个 MyBatis 映射器接口，其中的 getRoleStatistics() 方法通过 SQL 查询从数据库获取角色统计数据
    //查询sys_user表中的角色及其数量。
    @Select("SELECT role, COUNT(*) as count " +
            "FROM sys_user " +
            "GROUP BY role " +
            "ORDER BY count DESC")
    List<Map<String, Object>> getRoleStatistics();
}