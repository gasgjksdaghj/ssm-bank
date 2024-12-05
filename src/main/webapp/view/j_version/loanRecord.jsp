<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>贷款记录管理</title>
    <script src="vue2_resource/vue@2.6.14.js"></script>
    <link rel="stylesheet" href="vue2_resource/index.css">
    <script src="vue2_resource/elementui.js"></script>
    <script src="vue2_resource/axios.min.js"></script>
    <script src="vue2_resource/axiosWrapper.js"></script>

    <style>
        body {
            background-color: #f0f2f5;
            padding: 20px;
            font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
        }

        .el-card {
            margin-bottom: 20px;
        }

        .filter-section {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 15px;
        }

        .el-table {
            width: 100%;
            overflow-x: auto;
        }

        .el-table .cell {
            white-space: nowrap;
        }
    </style>
</head>
<body>
<div id="app">
    <el-card>
        <div class="filter-section">
            <el-button type="success" icon="el-icon-plus" @click="openAddLoanRecordDialog" size="small">添加贷款记录</el-button>
            <el-button type="danger" icon="el-icon-delete" @click="handleBatchDelete" size="small"
                       :disabled="selectedLoanRecords.length === 0">批量删除
            </el-button>
        </div>
    </el-card>

    <el-card>
        <el-table :data="loanRecords" style="width: 100%;" @selection-change="handleSelectionChange">
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="id" label="ID" width="80"></el-table-column>
            <el-table-column prop="userId" label="用户ID" width="100"></el-table-column>
            <el-table-column prop="loanAmount" label="贷款金额" width="120"></el-table-column>
            <el-table-column prop="interestRate" label="日利率" width="100"></el-table-column>
            <el-table-column prop="loanTime" label="贷款时间" width="160"></el-table-column>
            <el-table-column prop="repaymentTime" label="还款时间" width="160"></el-table-column>
            <el-table-column prop="status" label="状态" width="100">
                <template slot-scope="scope">
                    <el-switch
                            v-model="scope.row.status"
                            :active-value="1"
                            :inactive-value="0"
                            @change="handleStatusChange(scope.row)">
                    </el-switch>
                </template>
            </el-table-column>
            <el-table-column prop="remark" label="备注" width="150"></el-table-column>
            <el-table-column prop="bankName" label="银行名称" width="150"></el-table-column>
            <el-table-column label="操作"  fixed="right">
                <template slot-scope="scope">
                    <el-button size="mini" type="success" icon="el-icon-money" @click="repayLoan(scope.row)" v-if="scope.row.status == '0'">还款
                    </el-button>
                </template>
            </el-table-column>
        </el-table>

        <div style="margin-top: 20px;">
            <el-pagination
                    @size-change="handleSizeChange"
                    @current-change="handleCurrentChange"
                    :current-page="currentPage"
                    :page-sizes="[10, 20, 50, 100]"
                    :page-size="pageSize"
                    layout="total, sizes, prev, pager, next, jumper"
                    :total="totalLoanRecords">
            </el-pagination>
        </div>
    </el-card>

    <el-dialog :title="dialogTitle" :visible.sync="dialogVisible">
        <el-form :model="currentLoanRecord" label-width="100px">
            <el-form-item label="用户ID">
                <el-input v-model="currentLoanRecord.userId" :disabled="true"></el-input>
            </el-form-item>
            <el-form-item label="银行名称">
                <el-select v-model="currentLoanRecord.bankName" placeholder="请选择银行名称" @change="updateBankName">
                    <el-option
                            v-for="(bank, index) in bankNames"
                            :key="index"
                            :label="bank.name"
                            :value="bank.name">
                    </el-option>
                </el-select>
            </el-form-item>

            <el-form-item label="日利率">
                <el-select disabled v-model="currentLoanRecord.interestRate" placeholder="请选择日利率" @change="updateInterestRate">
                    <el-option
                            v-for="(rate, index) in interestRates"
                            :key="index"
                            :label="rate"
                            :value="rate">
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="贷款金额">
                <el-input v-model="currentLoanRecord.loanAmount"></el-input>
            </el-form-item>
            <el-form-item label="贷款时间">
                <el-date-picker v-model="currentLoanRecord.loanTime" type="datetime" value-format="yyyy-MM-ddTHH:mm:ss"
                                placeholder="选择日期时间"></el-date-picker>
            </el-form-item>
            <el-form-item label="备注">
                <el-input v-model="currentLoanRecord.remark"></el-input>
            </el-form-item>
         
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button @click="dialogVisible = false" size="small" icon="el-icon-close">取 消</el-button>
            <el-button type="primary" @click="saveLoanRecord" size="small" icon="el-icon-check">确 定</el-button>
        </div>
    </el-dialog>
</div>
<script>
    new Vue({
        el: '#app',
        data() {
            return {
                loanRecords: [],
                currentPage: 1,
                pageSize: 10,
                totalLoanRecords: 0,
                dialogVisible: false,
                dialogTitle: '添加贷款记录',
                currentLoanRecord: {
                    id: null,
                    userId: '',
                    loanAmount: '',
                    interestRate: '',
                    loanTime: '',
                    repaymentTime: '',
                    status: '0',
                    remark: '',
                    bankName: ''
                },
                selectedLoanRecords: [],
                bankNames: [
                    { name: "中国银行", rate: 0.05 },
                    { name: "工商银行", rate: 0.06 },
                    { name: "建设银行", rate: 0.07 },
                    { name: "农业银行", rate: 0.08 },
                    { name: "交通银行", rate: 0.09 }
                ],
                interestRates: [0.05, 0.06, 0.07, 0.08, 0.09]
            }
        },
        mounted() {
            this.fetchLoanRecords();
        },
        methods: {
            fetchLoanRecords() {
                const userInfo = JSON.parse(localStorage.getItem('userInfo'));
                const params = {
                    pageNum: this.currentPage,
                    pageSize: this.pageSize,
                    userId: userInfo.id
                };
                axiosWrapper.post('/api/loanRecords/page', params)
                    .then(response => {
                        this.loanRecords = response.data.list;
                        this.totalLoanRecords = response.data.total;
                    })
                    .catch(error => {
                        console.error('Error fetching loan records:', error);
                        this.$message.error('获取贷款记录列表失败');
                    });
            },
            handleSizeChange(val) {
                this.pageSize = val;
                this.currentPage = 1;
                this.fetchLoanRecords();
            },
            handleCurrentChange(val) {
                this.currentPage = val;
                this.fetchLoanRecords();
            },
            openAddLoanRecordDialog() {
                const userInfo = JSON.parse(localStorage.getItem('userInfo'));
                this.dialogTitle = '添加贷款记录';
                this.currentLoanRecord = {
                    id: null,
                    userId: userInfo.id,
                    loanAmount: '',
                    interestRate: '',
                    loanTime: '',
                    repaymentTime: '',
                    status: '0',
                    remark: '',
                    bankName: ''
                };
                this.dialogVisible = true;
            },
            openEditLoanRecordDialog(loanRecord) {
                this.dialogTitle = '编辑贷款记录';
                this.currentLoanRecord = {...loanRecord};
                this.dialogVisible = true;
            },
            handleDelete(row) {
                this.$confirm('此操作将永久删除该贷款记录, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    axiosWrapper.delete(`/api/loanRecords/${row.id}`)
                        .then(() => {
                            this.$message({
                                type: 'success',
                                message: '删除成功!'
                            });
                            this.fetchLoanRecords();
                        })
                        .catch(error => {
                            console.error('Error deleting loan record:', error);
                            this.$message.error('删除贷款记录失败');
                        });
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            saveLoanRecord() {
                const userInfo = JSON.parse(localStorage.getItem('userInfo'));
                userInfo.email = parseFloat((parseFloat(userInfo.email) + parseFloat(this.currentLoanRecord.loanAmount)).toFixed(2));
                localStorage.setItem('userInfo', JSON.stringify(userInfo));

                axiosWrapper.put('/user/update', userInfo)
                    .then(() => {
                        axiosWrapper.post('/api/loanRecords/saveOrUpdate', this.currentLoanRecord)
                            .then(() => {
                                this.$message({
                                    type: 'success',
                                    message: '贷款记录保存成功!'
                                });
                                this.dialogVisible = false;
                                this.fetchLoanRecords();
                            })
                            .catch(error => {
                                console.error('Error saving loan record:', error);
                                this.$message.error('保存贷款记录失败');
                            });
                    })
                    .catch(error => {
                        console.error('Error updating user balance:', error);
                        this.$message.error('更新用户余额失败');
                    });
            },
            handleSelectionChange(val) {
                this.selectedLoanRecords = val;
            },
            handleBatchDelete() {
                if (this.selectedLoanRecords.length === 0) {
                    this.$message.warning('请选择要删除的贷款记录');
                    return;
                }
                this.$confirm(`此操作将永久删除选中的 ${this.selectedLoanRecords.length} 个贷款记录, 是否继续?`, '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    const ids = this.selectedLoanRecords.map(loanRecord => loanRecord.id);
                    axiosWrapper.delete('/api/loanRecords/batch', {data: ids})
                        .then(() => {
                            this.$message({
                                type: 'success',
                                message: '批量删除成功!'
                            });
                            this.fetchLoanRecords();
                        })
                        .catch(error => {
                            console.error('Error batch deleting loan records:', error);
                            this.$message.error('批量删除贷款记录失败');
                        });
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            handleStatusChange(row) {
                axiosWrapper.put(`/api/loanRecords/${row.id}/status?status=${row.status}`)
                    .then(() => {
                        this.$message({
                            type: 'success',
                            message: '状态更新成功!'
                        });
                    })
                    .catch(error => {
                        console.error('Error updating loan record status:', error);
                        this.$message.error('更新贷款记录状态失败');
                        // 回滚状态
                        row.status = row.status === '1' ? '0' : '1';
                    });
            },
            updateBankName(bankName) {
                const bank = this.bankNames.find(b => b.name === bankName);
                if (bank) {
                    this.currentLoanRecord.interestRate = bank.rate;
                }
            },
            updateInterestRate(interestRate) {
                const bank = this.bankNames.find(b => b.rate === interestRate);
                if (bank) {
                    this.currentLoanRecord.bankName = bank.name;
                }
            },
            repayLoan(loanRecord) {
                const userInfo = JSON.parse(localStorage.getItem('userInfo'));
                const loanAmount = parseFloat(loanRecord.loanAmount);
                const interestRate = parseFloat(loanRecord.interestRate);
                const loanTime = new Date(loanRecord.loanTime);
                const now = new Date();
                const days = (now - loanTime) / (1000 * 60 * 60 * 24);
                const interest = loanAmount * interestRate * days;
                const totalAmount = loanAmount + interest;

                if (userInfo.email < totalAmount) {
                    this.$message.error('余额不足，无法还款');
                    return;
                }

                userInfo.email = parseFloat((parseFloat(userInfo.email) - totalAmount).toFixed(2));
                localStorage.setItem('userInfo', JSON.stringify(userInfo));

                loanRecord.repaymentTime = now.toISOString().slice(0, 19);
                loanRecord.status = '1';

                axiosWrapper.put('/user/update', userInfo)
                    .then(() => {
                        axiosWrapper.put('/api/loanRecords/saveOrUpdate', loanRecord)
                            .then(() => {
                                this.$message({
                                    type: 'success',
                                    message: '还款成功!'
                                });
                                this.fetchLoanRecords();
                            })
                            .catch(error => {
                                console.error('Error updating loan record:', error);
                                this.$message.error('还款失败');
                            });
                    })
                    .catch(error => {
                        console.error('Error updating user balance:', error);
                        this.$message.error('更新用户余额失败');
                    });
            }
        }
    });
</script>
</body>
</html>