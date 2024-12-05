package com.coco.aop;

import com.coco.wrapper.RepeatedlyReadRequestWrapper;
import com.coco.pojo.SystemLog;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.datatype.jsr310.JavaTimeModule;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Collectors;

@Aspect
@Component
public class SystemLogAOP {

    private static final Logger logger = LoggerFactory.getLogger(SystemLogAOP.class);
    private static final ObjectMapper objectMapper = new ObjectMapper();

    static {
        objectMapper.registerModule(new JavaTimeModule());
        objectMapper.disable(SerializationFeature.WRITE_DATES_AS_TIMESTAMPS);
        objectMapper.setDateFormat(new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS"));
    }

    @Pointcut("execution(public * com.coco.controller..*(..))")
    public void controllerPointcut() {}

    @Around("controllerPointcut()")
    public Object doAround(ProceedingJoinPoint pjp) throws Throwable {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            logger.warn("RequestAttributes is null, cannot log request");
            return pjp.proceed();
        }
        HttpServletRequest request = attributes.getRequest();

        // 检查请求路径是否以 /file/ 开头
        if (request.getRequestURI().startsWith("/file/")) {
            return pjp.proceed();
        }

        SystemLog log = new SystemLog();

        try {
            // 收集请求信息
            log.setRequestUrl(request.getRequestURL().toString());
            log.setRequestMethod(request.getMethod());
            log.setRequestParameters(getRequestParameters(request));
            log.setRequestBody(getRequestBody(request));
            log.setRequestIpAddress(request.getRemoteAddr());
            log.setRequestTime(LocalDateTime.now());
            log.setRequestHeaders(getRequestHeaders(request));

            long startTime = System.currentTimeMillis();
            Object result = pjp.proceed();
            long elapsedTime = System.currentTimeMillis() - startTime;

            // 收集响应信息
            log.setResponseBody(result != null ? objectMapper.writeValueAsString(result) : null);
            log.setElapsedTime(elapsedTime);

            // 打印JSON格式的日志
            logger.warn("本次请求日志: {}", objectMapper.writeValueAsString(log));

            return result;
        } catch (Exception e) {
            logger.error("Error in SystemLogAOP", e);
            throw e;
        }
    }

    private String getRequestParameters(HttpServletRequest request) {
        return request.getParameterMap().entrySet().stream()
                .map(entry -> entry.getKey() + "=" + String.join(",", entry.getValue()))
                .collect(Collectors.joining("&"));
    }

    private String getRequestBody(HttpServletRequest request) {
        if (request instanceof RepeatedlyReadRequestWrapper) {
            return ((RepeatedlyReadRequestWrapper) request).getBody();
        }
        try {
            return request.getReader().lines().collect(Collectors.joining(System.lineSeparator()));
        } catch (Exception e) {
            logger.warn("Failed to read request body", e);
            return "";
        }
    }

    private Map<String, String> getRequestHeaders(HttpServletRequest request) {
        Map<String, String> headers = new HashMap<>();
        Collections.list(request.getHeaderNames()).forEach(headerName ->
                headers.put(headerName, request.getHeader(headerName))
        );
        return headers;
    }
}