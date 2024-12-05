package com.coco.utils;

import cn.hutool.crypto.digest.BCrypt;

public class PasswordUtils {

    /**
     * 加密密码
     * @param password 原始密码
     * @return 加密后的密码
     */
    public static String encryptPassword(String password) {
        return BCrypt.hashpw(password);
    }


    public static void main(String[] args) {
        System.out.println(encryptPassword("admin"));
    }
}