package com.coco.pojo;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 贷款记录实体类
 * 对应数据库表 sys_loan_record
 */
@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonIgnoreProperties(ignoreUnknown = true)
public class LoanRecord implements Serializable {

    private static final long serialVersionUID = 1L;

    /**
     * 主键，贷款记录ID
     */
    private Integer id;

    /**
     * 用户ID
     */
    private Integer userId;

    /**
     * 贷款金额
     */
    private BigDecimal loanAmount;

    /**
     * 利率
     */
    private BigDecimal interestRate;

    /**
     * 贷款时间
     */
    private LocalDateTime loanTime;

    /**
     * 还款时间
     */
    private LocalDateTime repaymentTime;

    /**
     * 贷款状态：0未还，1已还
     */
    private Integer status;

    /**
     * 备注
     */
    private String remark;

    /**
     * 银行名称
     */
    private String bankName;
}