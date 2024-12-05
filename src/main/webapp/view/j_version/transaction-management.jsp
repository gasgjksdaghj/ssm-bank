<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>交易记录管理</title>
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
            box-shadow: 0 2px 12px 0 rgba(0,0,0,.1);
        }

        .el-table {
            width: 100% !important;
        }

        .el-table__body-wrapper {
            overflow-x: auto !important;
        }

        .el-pagination {
            margin-top: 20px;
            text-align: right;
        }

        .table-header-cell {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .table-header-cell i {
            margin-right: 5px;
        }
    </style>
</head>
<body>
<div id="app">
    <el-card>
        <el-table
                :data="transactions"
                style="width: 100%;"
                @selection-change="handleSelectionChange"
                :header-cell-style="{background:'#f5f7fa',color:'#606266'}"
        >
            <el-table-column type="selection" width="55"></el-table-column>
            <el-table-column prop="id" label="🔑 ID" width="80"></el-table-column>
            <el-table-column prop="userId" label="👤 用户ID" ></el-table-column>
            <el-table-column prop="transactionType" label="💳 交易类型" ></el-table-column>
            <el-table-column prop="amount" label="💰 交易金额" width="120"></el-table-column>
            <el-table-column prop="transactionTime" label="⏰ 交易时间" ></el-table-column>
            <el-table-column prop="targetUserId" label="🎯 目标用户ID" ></el-table-column>
        </el-table>

        <el-pagination
                @size-change="handleSizeChange"
                @current-change="handleCurrentChange"
                :current-page="currentPage"
                :page-sizes="[10, 20, 50, 100]"
                :page-size="pageSize"
                layout="total, sizes, prev, pager, next, jumper"
                :total="totalTransactions">
        </el-pagination>
    </el-card>
</div>

<script>
    new Vue({
        el: '#app',
        data() {
            return {
                transactions: [],
                currentPage: 1,
                pageSize: 10,
                totalTransactions: 0,
                selectedTransactions: []
            }
        },
        computed: {
            userInfo() {
                return JSON.parse(localStorage.getItem('userInfo'));
            },
            userId() {
                return this.userInfo ? this.userInfo.id : null;
            }
        },
        mounted() {
            this.fetchTransactions();
        },
        methods: {
            fetchTransactions() {
                const params = {
                    pageNum: this.currentPage,
                    pageSize: this.pageSize,
                    userId: this.userId
                };
                axiosWrapper.get('/api/transactions/page', {params})
                    .then(response => {
                        this.transactions = response.data.list;
                        this.totalTransactions = response.data.total;
                    })
                    .catch(error => {
                        console.error('Error fetching transactions:', error);
                        this.$message.error('获取交易记录列表失败');
                    });
            },
            handleSizeChange(val) {
                this.pageSize = val;
                this.currentPage = 1;
                this.fetchTransactions();
            },
            handleCurrentChange(val) {
                this.currentPage = val;
                this.fetchTransactions();
            },
            handleSelectionChange(val) {
                this.selectedTransactions = val;
            }
        }
    });
</script>
</body>
</html>