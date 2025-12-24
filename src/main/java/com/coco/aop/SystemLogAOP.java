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
//记录系统日志
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
//定义了一个切点，匹配 com.coco.controller 包及其子包中所有公共方法。
    @Pointcut("execution(public * com.coco.controller..*(..))")
    public void controllerPointcut() {}

//在匹配的方法执行前后被调用，允许进行预处理（记录请求数据）和后处理（记录响应数据）。
    @Around("controllerPointcut()")
    public Object doAround(ProceedingJoinPoint pjp) throws Throwable {
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            logger.warn("RequestAttributes is null, cannot log request");
            return pjp.proceed();
        }
        HttpServletRequest request = attributes.getRequest();

        // 检查请求路径是否以 /file/ 开头 避免日志中出现文件相关请求的信息。
        if (request.getRequestURI().startsWith("/file/")) {
            return pjp.proceed();
        }
     //日志对象创建
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
//将请求参数收集成查询字符串格式。
    private String getRequestParameters(HttpServletRequest request) {
        return request.getParameterMap().entrySet().stream()
                .map(entry -> entry.getKey() + "=" + String.join(",", entry.getValue()))
                .collect(Collectors.joining("&"));
        //使用 Java 8 的流（Stream）API，遍历这个映射的每一个条目（entry）对于每个条目，将参数名（key）和对应的值（value）拼接成 key=value 的形式。如果一个参数有多个值，则使用逗号连接这些值。
        //最后，使用 Collectors.joining("&") 将所有的 key=value 字符串连接成一个完整的查询字符串，以 & 符号分隔
    }
//读取请求体，处理可能已经读取过体的情况获取详细信息。
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
    //首先检查请求是否是 RepeatedlyReadRequestWrapper 的实例，这是一种可以多次读取请求体的包装器。如果是，则调用其 getBody() 方法获取请求体。
    //如果不是，则使用 request.getReader() 获取请求体的字符输入流，并将其转换为字符串。通过 lines() 方法读取所有行，并使用 Collectors.joining(System.lineSeparator()) 将它们连接成一个完整的字符串。
    //如果在读取过程中发生异常，捕获该异常并记录警告信息，同时返回一个空字符串。

    //从 HTTP 请求中获取所有头部信息，并将其存储在一个映射中。
    private Map<String, String> getRequestHeaders(HttpServletRequest request) {
        Map<String, String> headers = new HashMap<>();
        Collections.list(request.getHeaderNames()).forEach(headerName ->
                headers.put(headerName, request.getHeader(headerName))
        );
        return headers;
    }
}
//创建一个新的 HashMap 用于存储头部信息。
//使用 request.getHeaderNames() 获取所有头部名称，并将其转换为一个列表。
//遍历这个列表，对于每个头部名称，调用 request.getHeader(headerName) 获取对应的头部值，并将名称和值存入映射中。
//最后返回包含所有头部信息的映射。