package com.coco.exception;

public class BaseException extends RuntimeException {
    private Integer code;

    public BaseException(String message, Integer code) {
        super(message);
        this.code = code;
    }

    public Integer getCode() {
        return code;
    }
}




