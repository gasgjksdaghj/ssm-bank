package com.coco.pojo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.time.LocalDateTime;

/**
 * 交易记录实体类
 * 对应数据库表 sys_transaction_record
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class TransactionRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键，交易记录ID
     */
    private Integer id;

    /**
     * 用户ID
     */
    private Integer userId;

    /**
     * 交易类型：存款、取款、转账
     */
    private String transactionType;

    /**
     * 交易金额
     */
    private Double amount;

    /**
     * 交易时间
     */
    private LocalDateTime transactionTime;

    /**
     * 备注
     */
    private String remark;

    /**
     * 目标用户ID（仅用于转账）
     */
    private Integer targetUserId;
}