package com.coco.controller;

import com.coco.mapper.LoanRecordMapper;
import com.coco.pojo.LoanRecord;
import com.coco.utils.ApiResponse;
import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * 贷款记录管理控制器
 */
//标记该类为RESTful控制器，表示该类中的每个方法都返回JSON格式的数据。
@RestController
//定义了基础URL路径为 /api/loanRecords，所有以此为基础的请求都会以此路径开头
@RequestMapping("/api/loanRecords")
public class LoanRecordController {
//@Autowired：用于自动注入LoanRecordMapper，使得控制器可以调用其方法来执行与贷款记录相关的数据库操作。
    @Autowired
    private LoanRecordMapper loanRecordMapper;

    /**
     * 保存或更新贷款记录信息
     * @param loanRecord 贷款记录对象
     * @return API响应
     */
//    保存或更新贷款记录。如果传入的LoanRecord对象的ID为null，则执行插入操作；否则执行更新操作。
    @RequestMapping("/saveOrUpdate")
    public ApiResponse<Void> saveOrUpdate(@RequestBody LoanRecord loanRecord) {
        if (loanRecord.getId() == null) {
            loanRecordMapper.insert(loanRecord);
        } else {
            loanRecordMapper.updateById(loanRecord);
        }
        return ApiResponse.success("操作成功", null);
    }

    /**
     * 删除指定ID的贷款记录
     * @param id 贷款记录ID
     * @return API响应
     */
//    批量删除贷款记录，接收一个ID列表并逐个删除。
    @DeleteMapping("/{id}")
    public ApiResponse<Void> delete(@PathVariable Integer id) {
        loanRecordMapper.deleteById(id);
        return ApiResponse.success("删除成功", null);
    }

    /**
     * 批量删除贷款记录
     * @param ids 贷款记录ID列表
     * @return API响应
     */
    @DeleteMapping("/batch")
    public ApiResponse<Void> deleteBatch(@RequestBody List<Integer> ids) {
        for (Integer id : ids) {
            loanRecordMapper.deleteById(id);
        }
        return ApiResponse.success("批量删除成功", null);
    }

    /**
     * 查询所有贷款记录信息
     * @return API响应
     */
    @GetMapping
    public ApiResponse<List<LoanRecord>> findAll() {
        List<LoanRecord> loanRecords = loanRecordMapper.selectAll();
        return ApiResponse.success(loanRecords);
    }

    /**
     * 查询指定ID的贷款记录信息
     * @param id 贷款记录ID
     * @return API响应
     */
    @GetMapping("/{id}")
    public ApiResponse<LoanRecord> findOne(@PathVariable Integer id) {
        LoanRecord loanRecord = loanRecordMapper.selectById(id);
        return ApiResponse.success(loanRecord);
    }

    /**
     * 分页查询贷款记录信息
     * @param pageNum 页码
     * @param pageSize 每页大小
     * @param loanRecord 查询条件
     * @return API响应
     */
    @PostMapping("/page")
    public ApiResponse<PageInfo<LoanRecord>> findPage(@RequestParam(defaultValue = "1") Integer pageNum,
                                                      @RequestParam(defaultValue = "10") Integer pageSize,
                                                      @RequestBody(required = false) LoanRecord loanRecord) {
        PageHelper.startPage(pageNum, pageSize);
        List<LoanRecord> loanRecords = loanRecordMapper.selectByEntity(loanRecord);
        PageInfo<LoanRecord> pageInfo = new PageInfo<>(loanRecords);
        return ApiResponse.success(pageInfo);
    }

    /**
     * 更新贷款记录状态
     * @param id 贷款记录ID
     * @param status 新状态
     * @return API响应
     */
    @PutMapping("/{id}/status")
    public ApiResponse<Void> updateStatus(@PathVariable Integer id, @RequestParam Integer status) {
        loanRecordMapper.updateStatus(id, status);
        return ApiResponse.success("状态更新成功", null);
    }
}