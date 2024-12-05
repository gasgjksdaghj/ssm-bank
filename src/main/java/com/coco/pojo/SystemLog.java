package com.coco.pojo;

import lombok.Data;
import java.time.LocalDateTime;
import java.util.Map;

@Data
public class SystemLog {
    private String requestUrl;
    private String requestMethod;
    private String requestParameters;
    private String requestBody;
    private String requestIpAddress;
    private LocalDateTime requestTime;
    private Map<String, String> requestHeaders;
    private String responseBody;
    private long elapsedTime;
}