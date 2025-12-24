package com.coco.controller;
//主RESTful API控制器，负责用户管理功能，包括用户的注册、登录、更新、删除和查询等操作
import com.coco.pojo.SysUser;
import com.coco.service.SysUserService;
import com.coco.utils.ApiResponse;
import com.coco.utils.JwtTokenUtils;
import com.coco.dto.UserDTO;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private SysUserService sysUserService;

    @PostMapping("/register")
    public ApiResponse<String> register(@RequestBody SysUser user) {
        user.setEmail("0");
        sysUserService.register(user);
        return ApiResponse.success("注册成功");
    }

    @PostMapping("/login")
    public ApiResponse<Object> login(@RequestParam String username, @RequestParam String password) {
        try {
            SysUser user = sysUserService.login(username, password);

            // 检查用户状态是否被禁用
            if (user.getStatus() != null && user.getStatus() == 0) {
                return ApiResponse.error("该账户已被禁用，请联系管理员");
            }

            UserDTO userDTO = new UserDTO();
            BeanUtils.copyProperties(user, userDTO);
            String token = JwtTokenUtils.generateToken(userDTO);
            userDTO.setToken(token);
            return ApiResponse.success("登录成功", userDTO);
        } catch (Exception e) {
            // 这里可以根据具体的异常类型返回不同的错误信息
            return ApiResponse.error("登录失败：" + e.getMessage());
        }
    }

    @PutMapping("/update")
    public ApiResponse<String> updateUser(@RequestBody SysUser user) {
        sysUserService.updateUser(user);
        return ApiResponse.success("更新成功");
    }

    @DeleteMapping("/{id}")
    public ApiResponse<String> deleteUser(@PathVariable Integer id) {
        sysUserService.deleteUser(id);
        return ApiResponse.success("删除成功");
    }

    @GetMapping("/{id}")
    public ApiResponse<SysUser> getUserById(@PathVariable Integer id) {
        SysUser user = sysUserService.getUserById(id);
        return ApiResponse.success(user);
    }

    @GetMapping("/all")
    public ApiResponse<List<SysUser>> getAllUsers() {
        List<SysUser> users = sysUserService.getAllUsers();
        return ApiResponse.success(users);
    }

    @GetMapping("/range")
    public ApiResponse<PageInfo<SysUser>> getUsersByCreateTimeRange(@RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime startTime, @RequestParam(required = false) @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss") LocalDateTime endTime, @RequestParam(required = false) String nickname, @RequestParam(defaultValue = "1") int pageNum, @RequestParam(defaultValue = "10") int pageSize) {
        if (endTime != null && startTime != null && endTime.isBefore(startTime)) {
            return ApiResponse.error("结束时间不能早于开始时间");
        }
        PageHelper.startPage(pageNum, pageSize);
        List<SysUser> users = sysUserService.getUsersByCreateTimeRange(startTime, endTime, nickname);
//        调用服务层的方法 getUsersByCreateTimeRange，传入开始时间、结束时间和昵称，以获取符合条件的用户列表。
        PageInfo<SysUser> pageInfo = new PageInfo<>(users);
        return ApiResponse.success(pageInfo);
    }

    @PostMapping("/{id}/change-password")
    public ApiResponse<String> changePassword(@PathVariable Integer id, @RequestParam String oldPassword, @RequestParam String newPassword) {
        sysUserService.changePassword(id, oldPassword, newPassword);
        return ApiResponse.success("密码修改成功");
    }

    @PostMapping("/{id}/reset-password")
    public ApiResponse<String> resetPassword(@PathVariable Integer id) {
        sysUserService.resetPassword(id);
        return ApiResponse.success("密码重置成功");
    }
}