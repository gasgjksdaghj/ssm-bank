package com.coco.controller;

import com.coco.pojo.SysRole;
import com.coco.mapper.SysRoleMapper;
import com.coco.utils.ApiResponse;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/role")
public class SysRoleController {

    @Autowired
    private SysRoleMapper sysRoleMapper;

    @PostMapping
    public ApiResponse<String> addRole(@RequestBody SysRole role) {
        sysRoleMapper.insert(role);
        return ApiResponse.success("添加角色成功");
    }

    @PutMapping("/update")
    public ApiResponse<String> updateRole(@RequestBody SysRole role) {
        sysRoleMapper.update(role);
        return ApiResponse.success("更新角色成功");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<String> deleteRole(@PathVariable Integer id) {
        sysRoleMapper.deleteById(id);
        return ApiResponse.success("删除角色成功");
    }

    @GetMapping("/{id}")
    public ApiResponse<SysRole> getRoleById(@PathVariable Integer id) {
        SysRole role = sysRoleMapper.selectById(id);
        return ApiResponse.success(role);
    }

    @GetMapping("/all")
    public ApiResponse<List<SysRole>> getAllRoles() {
        List<SysRole> roles = sysRoleMapper.selectAll();
        return ApiResponse.success(roles);
    }

    @GetMapping("/page")
    public ApiResponse<PageInfo<SysRole>> getRolesByPage(
            @RequestParam(defaultValue = "1") int pageNum,
            @RequestParam(defaultValue = "10") int pageSize,
            @RequestParam(required = false, defaultValue = "") String search) {
        PageHelper.startPage(pageNum, pageSize);
        List<SysRole> roles = sysRoleMapper.selectBySearch(search);
        PageInfo<SysRole> pageInfo = new PageInfo<>(roles);
        return ApiResponse.success(pageInfo);
    }
}