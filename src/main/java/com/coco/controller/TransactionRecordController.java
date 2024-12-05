package com.coco.controller;

import com.coco.mapper.TransactionRecordMapper;
import com.coco.pojo.TransactionRecord;
import com.coco.utils.ApiResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;

import java.util.List;

/**
 * 交易记录管理控制器
 */
@RestController
@RequestMapping("/api/transactions")
public class TransactionRecordController {

    @Autowired
    private TransactionRecordMapper transactionRecordMapper;

    /**
     * 保存或更新交易记录信息
     * @param record 交易记录对象
     * @return API响应
     */
    @PostMapping("/saveOrUpdate")
    public ApiResponse<Void> saveOrUpdate(@RequestBody TransactionRecord record) {
        if (record.getId() == null) {
            transactionRecordMapper.insert(record);
        } else {
            transactionRecordMapper.updateById(record);
        }
        return ApiResponse.success("操作成功", null);
    }

    /**
     * 删除指定ID的交易记录
     * @param id 交易记录ID
     * @return API响应
     */
    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Integer id) {
        transactionRecordMapper.deleteById(id);
        return ApiResponse.success("删除成功", null);
    }

    /**
     * 查询所有交易记录信息
     * @return API响应
     */
    @GetMapping
    public ApiResponse<List<TransactionRecord>> findAll() {
        List<TransactionRecord> records = transactionRecordMapper.selectAll();
        return ApiResponse.success(records);
    }

    /**
     * 查询指定ID的交易记录信息
     * @param id 交易记录ID
     * @return API响应
     */
    @GetMapping("/{id}")
    public ApiResponse<TransactionRecord> findOne(@PathVariable Integer id) {
        TransactionRecord record = transactionRecordMapper.selectById(id);
        return ApiResponse.success(record);
    }

    /**
     * 分页查询交易记录信息
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @param userId 用户ID
     * @param targetUserId 目标用户ID
     * @return API响应
     */
    @GetMapping("/page")
    public ApiResponse<PageInfo<TransactionRecord>> findPage(@RequestParam(defaultValue = "1") Integer pageNum,
                                                             @RequestParam(defaultValue = "10") Integer pageSize,
                                                             @RequestParam(required = false) Integer userId,
                                                             @RequestParam(required = false) Integer targetUserId) {
        PageHelper.startPage(pageNum, pageSize);
        List<TransactionRecord> records;
        if (userId != null) {
            records = transactionRecordMapper.selectByUserId(userId);
        } else if (targetUserId != null) {
            records = transactionRecordMapper.selectByTargetUserId(targetUserId);
        } else {
            records = transactionRecordMapper.selectAll();
        }
        PageInfo<TransactionRecord> pageInfo = new PageInfo<>(records);
        return ApiResponse.success(pageInfo);
    }
}