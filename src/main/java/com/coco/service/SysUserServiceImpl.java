package com.coco.service;

import com.coco.mapper.SysUserMapper;
import com.coco.pojo.SysUser;
import com.coco.exception.UserNotFoundException;
import com.coco.exception.UnauthorizedException;
import com.coco.exception.BusinessException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import cn.hutool.crypto.digest.BCrypt;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class SysUserServiceImpl implements SysUserService {

    @Autowired
    private SysUserMapper sysUserMapper;

    @Override
    @Transactional
    public void register(SysUser user) {
        if (isUsernameExist(user.getUsername())) {
            throw new BusinessException("用户名已存在");
        }
        user.setPassword(encryptPassword(user.getPassword()));
        int result = sysUserMapper.insert(user);
        if (result <= 0) {
            throw new BusinessException("注册失败");
        }
    }

    @Override
    @Transactional
    public void updateUser(SysUser user) {
        int result = sysUserMapper.update(user);
        if (result <= 0) {
            throw new BusinessException("更新失败");
        }
    }

    @Override
    public SysUser login(String username, String password) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null || !BCrypt.checkpw(password, user.getPassword())) {
            throw new UnauthorizedException("用户名或密码错误");
        }
        return user;
    }

    @Override
    @Transactional
    public void deleteUser(Integer id) {
        int result = sysUserMapper.deleteById(id);
        if (result <= 0) {
            throw new UserNotFoundException("用户不存在或删除失败");
        }
    }

    @Override
    public SysUser getUserById(Integer id) {
        SysUser user = sysUserMapper.selectById(id);
        if (user == null) {
            throw new UserNotFoundException("用户不存在");
        }
        return user;
    }

    @Override
    public List<SysUser> getAllUsers() {
        return sysUserMapper.selectAll();
    }

    @Override
    public boolean isUsernameExist(String username) {
        return sysUserMapper.checkUsernameExist(username) > 0;
    }

    @Override
    public List<SysUser> getUsersByCreateTimeRange(LocalDateTime startTime, LocalDateTime endTime,String nickname) {
        return sysUserMapper.selectByCreateTimeRange(startTime, endTime,nickname);
    }

    private String encryptPassword(String password) {
        return BCrypt.hashpw(password);
    }

    @Override
    @Transactional
    public void changePassword(Integer userId, String oldPassword, String newPassword) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new UserNotFoundException("用户不存在");
        }
        if (!BCrypt.checkpw(oldPassword, user.getPassword())) {
            throw new BusinessException("旧密码错误");
        }
        String encryptedNewPassword = encryptPassword(newPassword);
        int result = sysUserMapper.updatePassword(userId, encryptedNewPassword);
        if (result <= 0) {
            throw new BusinessException("密码修改失败");
        }
    }

    @Override
    @Transactional
    public void resetPassword(Integer userId) {
        String defaultPassword = "000000"; // 可以根据需求修改默认密码
        String encryptedDefaultPassword = encryptPassword(defaultPassword);
        int result = sysUserMapper.resetPassword(userId, encryptedDefaultPassword);
        if (result <= 0) {
            throw new UserNotFoundException("用户不存在或密码重置失败");
        }
    }
}