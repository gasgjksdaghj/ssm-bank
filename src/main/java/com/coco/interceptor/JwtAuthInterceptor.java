package com.coco.interceptor;

import com.coco.utils.JwtTokenUtils;
import com.coco.dto.UserDTO;
import com.coco.exception.UnauthorizedException;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class JwtAuthInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        String token = extractToken(request);

        // 如果没有token，抛出UnauthorizedException
        if (token == null) {
            throw new UnauthorizedException("未提供授权令牌");
        }

        // 如果token无效，抛出UnauthorizedException
        if (!JwtTokenUtils.validateToken(token)) {
            throw new UnauthorizedException("无效的授权令牌");
        }

        // token有效，设置用户信息并允许请求通过
        UserDTO userDTO = JwtTokenUtils.getUserFromToken(token);
        request.setAttribute("currentUser", userDTO);
        return true;
    }

    private String extractToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        return null;
    }
}