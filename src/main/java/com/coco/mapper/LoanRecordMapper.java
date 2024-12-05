package com.coco.mapper;

import com.coco.pojo.LoanRecord;
import org.apache.ibatis.annotations.*;
import org.apache.ibatis.type.JdbcType;

import java.util.List;

/**
 * 贷款记录Mapper接口
 */
@Mapper
public interface LoanRecordMapper {

    /**
     * 插入新的贷款记录
     * @param loanRecord 贷款记录对象
     * @return 受影响的行数
     */
    @Insert("INSERT INTO sys_loan_record(user_id, loan_amount, interest_rate, loan_time, repayment_time, status, remark, bank_name) " +
            "VALUES(#{userId}, #{loanAmount}, #{interestRate}, #{loanTime}, #{repaymentTime}, #{status}, #{remark}, #{bankName})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(LoanRecord loanRecord);

    /**
     * 根据ID更新贷款记录信息
     * @param loanRecord 贷款记录对象
     * @return 受影响的行数
     */
    @Update("UPDATE sys_loan_record SET user_id=#{userId}, loan_amount=#{loanAmount}, interest_rate=#{interestRate}, " +
            "loan_time=#{loanTime}, repayment_time=#{repaymentTime}, status=#{status}, remark=#{remark}, bank_name=#{bankName} " +
            "WHERE id=#{id}")
    int updateById(LoanRecord loanRecord);

    /**
     * 根据ID删除贷款记录
     * @param id 贷款记录ID
     * @return 受影响的行数
     */
    @Delete("DELETE FROM sys_loan_record WHERE id=#{id}")
    int deleteById(Integer id);

    /**
     * 根据ID查询贷款记录信息
     * @param id 贷款记录ID
     * @return 贷款记录对象
     */
    @Select("SELECT * FROM sys_loan_record WHERE id=#{id}")
    @Results(id = "loanRecordMap", value = {
            @Result(column = "id", property = "id", jdbcType = JdbcType.INTEGER, id = true),
            @Result(column = "user_id", property = "userId", jdbcType = JdbcType.INTEGER),
            @Result(column = "loan_amount", property = "loanAmount", jdbcType = JdbcType.DECIMAL),
            @Result(column = "interest_rate", property = "interestRate", jdbcType = JdbcType.DECIMAL),
            @Result(column = "loan_time", property = "loanTime", jdbcType = JdbcType.TIMESTAMP),
            @Result(column = "repayment_time", property = "repaymentTime", jdbcType = JdbcType.TIMESTAMP),
            @Result(column = "status", property = "status", jdbcType = JdbcType.TINYINT),
            @Result(column = "remark", property = "remark", jdbcType = JdbcType.VARCHAR),
            @Result(column = "bank_name", property = "bankName", jdbcType = JdbcType.VARCHAR)
    })
    LoanRecord selectById(Integer id);

    /**
     * 查询所有贷款记录信息
     * @return 贷款记录对象列表
     */
    @Select("SELECT * FROM sys_loan_record")
    @ResultMap("loanRecordMap")
    List<LoanRecord> selectAll();

    /**
     * 根据条件查询贷款记录信息
     * @param loanRecord 查询条件
     * @return 贷款记录对象列表
     */
    @Select("<script>" +
            "SELECT * FROM sys_loan_record" +
            "<where>" +
            "    <if test='userId != null'>" +
            "        AND user_id = #{userId}" +
            "    </if>" +
            "    <if test='status != null'>" +
            "        AND status = #{status}" +
            "    </if>" +
            "    <if test='bankName != null and bankName != \"\"'>" +
            "        AND bank_name LIKE CONCAT('%', #{bankName}, '%')" +
            "    </if>" +
            "</where>" +
            "</script>")
    @ResultMap("loanRecordMap")
    List<LoanRecord> selectByEntity(LoanRecord loanRecord);

    /**
     * 更新贷款记录状态
     * @param id 贷款记录ID
     * @param status 新状态
     * @return 受影响的行数
     */
    @Update("UPDATE sys_loan_record SET status = #{status} WHERE id = #{id}")
    int updateStatus(@Param("id") Integer id, @Param("status") Integer status);
}