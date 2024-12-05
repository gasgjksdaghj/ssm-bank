package com.coco.utils;

import cn.hutool.core.date.DateField;
import cn.hutool.core.date.DateTime;
import cn.hutool.json.JSONObject;
import cn.hutool.jwt.JWT;
import cn.hutool.jwt.JWTPayload;
import cn.hutool.jwt.JWTUtil;
import com.coco.dto.UserDTO;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

public class JwtTokenUtils {

    private static final String SECRET_KEY = "cnmsb";  // 这里替换为你的密钥
    private static final long EXPIRATION = 60 * 60;  // token有效期，单位为秒
    private static final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

    public static String generateToken(UserDTO userDTO) {
        DateTime now = DateTime.now();
        DateTime expTime = now.offsetNew(DateField.SECOND, (int) EXPIRATION);

        Map<String, Object> payload = new HashMap<>();
        payload.put(JWTPayload.ISSUED_AT, now);
        payload.put(JWTPayload.EXPIRES_AT, expTime);
        payload.put("id", userDTO.getId());
        payload.put("username", userDTO.getUsername());
        payload.put("nickname", userDTO.getNickname());
        payload.put("email", userDTO.getEmail());
        payload.put("phone", userDTO.getPhone());
        payload.put("address", userDTO.getAddress());
        payload.put("role", userDTO.getRole());
        payload.put("status", userDTO.getStatus());

        JSONObject logInfo = new JSONObject();
        logInfo.put("tokenGenerationTime", dateFormat.format(now));
        logInfo.put("tokenExpirationTime", dateFormat.format(expTime));
        logInfo.put("tokenValidityPeriod", EXPIRATION + " seconds");
        System.out.println(logInfo.toString());

        return JWTUtil.createToken(payload, SECRET_KEY.getBytes());
    }

    public static boolean validateToken(String token) {
        try {
            JWT jwt = JWTUtil.parseToken(token);
            boolean verifySuccess = jwt.setKey(SECRET_KEY.getBytes()).verify();
            boolean notExpired = !isTokenExpired(jwt);

            Date expiresAt = jwt.getPayload().getClaimsJson().getDate(JWTPayload.EXPIRES_AT);
            Date now = new Date();
            long remainingTime = (expiresAt.getTime() - now.getTime()) / 1000; // 剩余时间（秒）

            JSONObject logInfo = new JSONObject();
            logInfo.put("tokenValidationResult", verifySuccess ? "Signature correct" : "Signature incorrect");
            logInfo.put("tokenExpired", !notExpired);
            logInfo.put("tokenExpirationTime", dateFormat.format(expiresAt));
            logInfo.put("tokenRemainingTime", remainingTime > 0 ? remainingTime + " seconds" : "Expired");
            logInfo.put("currentTime", dateFormat.format(now));
            System.out.println("------------------token验签信息-----------------------");
            System.out.println(logInfo.toString());
            System.out.println("-----------------------------------------------------");
            return verifySuccess && notExpired;
        } catch (Exception e) {
            JSONObject logInfo = new JSONObject();
            logInfo.put("tokenValidationError", e.getMessage());
            logInfo.put("errorTime", dateFormat.format(new Date()));
            System.out.println(logInfo.toString());
            return false;
        }
    }

    private static boolean isTokenExpired(JWT jwt) {
        Date expiresAt = jwt.getPayload().getClaimsJson().getDate(JWTPayload.EXPIRES_AT);
        return expiresAt == null || expiresAt.before(new Date());
    }

    public static UserDTO getUserFromToken(String token) {
        try {
            JWT jwt = JWTUtil.parseToken(token);
            UserDTO userDTO = new UserDTO();
            userDTO.setId(jwt.getPayload("id") == null ? null : Integer.valueOf(jwt.getPayload("id").toString()));
            userDTO.setUsername((String) jwt.getPayload("username"));
            userDTO.setNickname((String) jwt.getPayload("nickname"));
            userDTO.setEmail((String) jwt.getPayload("email"));
            userDTO.setPhone((String) jwt.getPayload("phone"));
            userDTO.setAddress((String) jwt.getPayload("address"));
            userDTO.setRole((String) jwt.getPayload("role"));
            userDTO.setStatus(jwt.getPayload("status") == null ? null : Integer.valueOf(jwt.getPayload("status").toString()));
            return userDTO;
        } catch (Exception e) {
            JSONObject logInfo = new JSONObject();
            logInfo.put("getUserFromTokenError", e.getMessage());
            logInfo.put("errorTime", dateFormat.format(new Date()));
            System.out.println(logInfo.toString());
            return null;
        }
    }

    public static void main(String[] args) {
        // 创建一个示例 UserDTO 对象
        UserDTO userDTO = new UserDTO();
        userDTO.setId(1);
        userDTO.setUsername("testuser");
        userDTO.setNickname("测试用户");
        userDTO.setEmail("testuser@example.com");
        userDTO.setPhone("1234567890");
        userDTO.setAddress("测试街道123号");
        userDTO.setRole("USER");
        userDTO.setStatus(1);

        // 生成 token
        String token = generateToken(userDTO);
        System.out.println("生成的 Token: " + token);
        System.out.println("--------------------------------------------------");
        // 验证 token
        System.out.println("\n验证 Token:");
        boolean isValid = validateToken(token);
        System.out.println("Token 是否有效: " + (isValid ? "是" : "否"));

        // 从 token 中获取用户信息
        UserDTO retrievedUser = getUserFromToken(token);
        if (retrievedUser != null) {
            System.out.println("\n从 Token 中成功获取用户信息: " + retrievedUser);
        } else {
            System.out.println("\n无法从 Token 中获取用户信息");
        }
    }
}