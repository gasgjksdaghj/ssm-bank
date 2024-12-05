package com.coco.mapper;

import com.coco.pojo.TransactionRecord;
import org.apache.ibatis.annotations.*;
import org.apache.ibatis.type.JdbcType;

import java.util.List;

/**
 * 交易记录Mapper接口
 */
@Mapper
public interface TransactionRecordMapper {

    /**
     * 插入新的交易记录
     *
     * @param record 交易记录对象
     * @return 受影响的行数
     */
    @Insert("INSERT INTO sys_transaction_record(user_id, transaction_type, amount, transaction_time, remark, target_user_id) " +
            "VALUES(#{userId}, #{transactionType}, #{amount}, #{transactionTime}, #{remark}, #{targetUserId})")
    @Options(useGeneratedKeys = true, keyProperty = "id")
    int insert(TransactionRecord record);

    /**
     * 根据ID更新交易记录信息
     *
     * @param record 交易记录对象
     * @return 受影响的行数
     */
    @Update("UPDATE sys_transaction_record SET user_id=#{userId}, transaction_type=#{transactionType}, amount=#{amount}, " +
            "transaction_time=#{transactionTime}, remark=#{remark}, target_user_id=#{targetUserId} WHERE id=#{id}")
    int updateById(TransactionRecord record);

    /**
     * 根据ID删除交易记录
     *
     * @param id 交易记录ID
     * @return 受影响的行数
     */
    @Delete("DELETE FROM sys_transaction_record WHERE id=#{id}")
    int deleteById(Integer id);

    /**
     * 根据ID查询交易记录信息
     *
     * @param id 交易记录ID
     * @return 交易记录对象
     */
    @Select("SELECT * FROM sys_transaction_record WHERE id=#{id}")
    @Results(id = "transactionRecordMap", value = {
            @Result(column = "id", property = "id", jdbcType = JdbcType.INTEGER, id = true),
            @Result(column = "user_id", property = "userId", jdbcType = JdbcType.INTEGER),
            @Result(column = "transaction_type", property = "transactionType", jdbcType = JdbcType.VARCHAR),
            @Result(column = "amount", property = "amount", jdbcType = JdbcType.DECIMAL),
            @Result(column = "transaction_time", property = "transactionTime", jdbcType = JdbcType.TIMESTAMP),
            @Result(column = "remark", property = "remark", jdbcType = JdbcType.VARCHAR),
            @Result(column = "target_user_id", property = "targetUserId", jdbcType = JdbcType.INTEGER)
    })
    TransactionRecord selectById(Integer id);

    /**
     * 查询所有交易记录信息
     *
     * @return 交易记录对象列表
     */
    @Select("SELECT * FROM sys_transaction_record")
    @ResultMap("transactionRecordMap")
    List<TransactionRecord> selectAll();

    /**
     * 根据用户ID查询交易记录信息
     *
     * @param userId 用户ID
     * @return 交易记录对象列表
     */
    @Select("SELECT * FROM sys_transaction_record WHERE user_id=#{userId} or target_user_id=#{userId}")
    @ResultMap("transactionRecordMap")
    List<TransactionRecord> selectByUserId(Integer userId);

    /**
     * 根据目标用户ID查询交易记录信息
     *
     * @param targetUserId 目标用户ID
     * @return 交易记录对象列表
     */
    @Select("SELECT * FROM sys_transaction_record WHERE target_user_id=#{targetUserId}")
    @ResultMap("transactionRecordMap")
    List<TransactionRecord> selectByTargetUserId(Integer targetUserId);
}