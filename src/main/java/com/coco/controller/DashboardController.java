package com.coco.controller;

import com.coco.mapper.DashboardMapper;
import com.coco.utils.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/dashboard")
public class DashboardController {

    @Autowired
    private DashboardMapper dashboardMapper;

    @GetMapping("/role-statistics")
    public ApiResponse<List<Map<String, Object>>> getRoleStatistics() {
        List<Map<String, Object>> statistics = dashboardMapper.getRoleStatistics();
        return ApiResponse.success(statistics);
    }
}