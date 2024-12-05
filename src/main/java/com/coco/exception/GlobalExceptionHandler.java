package com.coco.exception;

import com.coco.utils.ApiResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;

@ControllerAdvice
public class GlobalExceptionHandler {

    private static final Logger logger = LoggerFactory.getLogger(GlobalExceptionHandler.class);

    @ExceptionHandler(BaseException.class)
    @ResponseBody
    public ApiResponse handleBaseException(BaseException e) {
        logger.error("发生BaseException:", e);
        return ApiResponse.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(UserNotFoundException.class)
    @ResponseBody
    public ApiResponse handleUserNotFoundException(UserNotFoundException e) {
        logger.error("发生UserNotFoundException:", e);
        return ApiResponse.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(UnauthorizedException.class)
    @ResponseBody
    public ApiResponse handleUnauthorizedException(UnauthorizedException e) {
        logger.error("发生UnauthorizedException:", e);
        return ApiResponse.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(BusinessException.class)
    @ResponseBody
    public ApiResponse handleBusinessException(BusinessException e) {
        logger.error("发生BusinessException:", e);
        return ApiResponse.error(e.getCode(), e.getMessage());
    }

    @ExceptionHandler(Exception.class)
    @ResponseBody
    public ApiResponse handleException(Exception e) {
        logger.error("发生未预期的异常:", e);
        return ApiResponse.error(500, "服务器内部错误：" + e.getMessage());
    }
}