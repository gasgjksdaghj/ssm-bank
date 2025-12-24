//处理与仪表盘（Dashboard）相关的 HTTP 请求
package com.coco.controller;

import com.coco.mapper.DashboardMapper;
import com.coco.utils.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;
//注解表明该类是一个控制器，能够处理HTTP请求，并将返回值直接写入HTTP响应体中。
@RestController
//注解指定了该控制器处理的请求路径前缀为/dashboard。
@RequestMapping("/dashboard")
public class DashboardController {
//注入了一个 DashboardMapper 实例，用于执行与数据库交互的操作。
    @Autowired
    private DashboardMapper dashboardMapper;
//获取角色统计数据，并返回一个包装了这些数据的 ApiResponse 对象，响应给客户端。
    @GetMapping("/role-statistics")
    public ApiResponse<List<Map<String, Object>>> getRoleStatistics() {
        List<Map<String, Object>> statistics = dashboardMapper.getRoleStatistics();
        return ApiResponse.success(statistics);
    }
}