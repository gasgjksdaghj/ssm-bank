package com.coco.filter;

import com.coco.wrapper.RepeatedlyReadRequestWrapper;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@Component
@WebFilter("/*")
public class ReadBodyHttpServletFilter extends OncePerRequestFilter {

    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {
        if (request.getRequestURI().contains("file")||request.getRequestURI().contains("import")||request.getRequestURI().contains("export")) {
            // 对于 /file/* 路径，直接放行，不包装请求
            filterChain.doFilter(request, response);
        } else {
            // 对于其他路径，使用 RepeatedlyReadRequestWrapper 包装请求
            RepeatedlyReadRequestWrapper wrappedRequest = new RepeatedlyReadRequestWrapper(request);
            filterChain.doFilter(wrappedRequest, response);
        }
    }

    @Override
    protected boolean shouldNotFilter(HttpServletRequest request) {
        // 移除这个方法，让所有请求都经过 doFilterInternal
        return false;
    }
}