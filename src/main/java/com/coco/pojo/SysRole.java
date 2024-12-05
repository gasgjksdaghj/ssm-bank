package com.coco.pojo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SysRole {
    private Integer id;
    private String name;
    private String description;
    private String flag;
}