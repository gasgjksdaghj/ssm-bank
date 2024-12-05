package com.coco.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class UserDTO implements Serializable {
    private Integer id;
    private String username;
    private String nickname;
    private String email;
    private String phone;
    private String address;
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
    private String avatarUrl;
    private String role;
    private Integer status;
    private String token;
}