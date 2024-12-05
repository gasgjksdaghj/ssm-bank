package com.coco.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import java.util.List;
import java.util.Map;

@Mapper
public interface DashboardMapper {

    @Select("SELECT role, COUNT(*) as count " +
            "FROM sys_user " +
            "GROUP BY role " +
            "ORDER BY count DESC")
    List<Map<String, Object>> getRoleStatistics();
}