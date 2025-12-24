<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户资料</title>
    <script src="vue2_resource/vue@2.6.14.js"></script>
    <link rel="stylesheet" href="vue2_resource/index.css">
    <script src="vue2_resource/elementui.js"></script>
    <script src="vue2_resource/axios.min.js"></script>
    <script src="vue2_resource/axiosWrapper.js"></script>
    <style>
        body {
            background-color: #f0f2f5;
            font-family: Arial, sans-serif;
        }

        .profile-container {
            max-width: 800px;
            margin: 40px auto;
            display: flex;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            overflow: hidden;
        }

        .sidebar {
            width: 30%;
            background-color: #3a8ee6;
            color: white;
            padding: 30px;
            text-align: center;
        }

        .main-content {
            width: 70%;
            background-color: white;
            padding: 30px;
        }

        .avatar-container {
            margin-bottom: 20px;
        }

        .avatar-container .el-avatar {
            border: 4px solid white;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
        }

        .user-name {
            font-size: 24px;
            margin: 10px 0;
        }

        .user-role {
            font-size: 16px;
            opacity: 0.8;
        }

        .el-form-item {
            margin-bottom: 22px;
        }

        .form-actions {
            text-align: right;
            margin-top: 20px;
        }
    </style>
</head>
<body>
<div id="app">
    <div class="profile-container">
        <div class="sidebar">
            <div class="avatar-container">
                <el-avatar :size="120" :src="user.avatarUrl"></el-avatar>
            </div>
            <h2 class="user-name">{{ user.nickname }}</h2>
            <p class="user-role">{{ user.role }}</p>
            <el-upload
                    class="avatar-uploader"
                    action="/file/upload"
                    :show-file-list="false"
                    :on-success="handleAvatarSuccess"
                    :before-upload="beforeAvatarUpload">
                <el-button size="small" type="text" style="color: white;">更换头像</el-button>
            </el-upload>
        </div>
        <div class="main-content">
            <h1>个人资料</h1>
            <el-form :model="user" label-width="80px" :disabled="!isEditing">
                <el-form-item label="用户名">
                    <el-input disabled v-model="user.username"></el-input>
                </el-form-item>
                <el-form-item label="昵称">
                    <el-input v-model="user.nickname"></el-input>
                </el-form-item>
                <el-form-item label="余额">
                    <el-input disabled v-model.number="user.email" type="number" :min="0"></el-input>
                </el-form-item>
                <el-form-item label="电话">
                    <el-input v-model="user.phone"></el-input>
                </el-form-item>
                <el-form-item label="地址">
                    <el-input v-model="user.address"></el-input>
                </el-form-item>
                <el-form-item label="角色">
                    <el-input v-model="user.role" disabled></el-input>
                </el-form-item>

            </el-form>
            <div class="form-actions">
                <el-button type="primary" @click="toggleEdit">{{ isEditing ? '保存' : '编辑' }}</el-button>
                <el-button @click="cancelEdit" v-if="isEditing">取消</el-button>
                <el-button type="success" @click="showDepositDialog">存款</el-button>
                <el-button type="danger" @click="showWithdrawDialog" v-if="user.email > 0">取款</el-button>
                <el-button type="warning" @click="showTransferDialog">转账</el-button>
                <el-button type="info" @click="refreshUserInfo">刷新</el-button>
            </div>
        </div>
    </div>

    <!-- 存款弹框 -->
    <el-dialog title="存款" :visible.sync="depositDialogVisible">
        <el-input v-model.number="depositAmount" type="number" :min="0"></el-input>
        <div slot="footer" class="dialog-footer">
            <el-button @click="depositDialogVisible = false">取 消</el-button>
            <el-button type="primary" @click="deposit">确 定</el-button>
        </div>
    </el-dialog>

    <!-- 取款弹框 -->
    <el-dialog title="取款" :visible.sync="withdrawDialogVisible">
        <el-input v-model.number="withdrawAmount" type="number" :min="0" :max="user.email"></el-input>
        <div slot="footer" class="dialog-footer">
            <el-button @click="withdrawDialogVisible = false">取 消</el-button>
            <el-button type="primary" @click="withdraw">确 定</el-button>
        </div>
    </el-dialog>

    <!-- 转账弹框 -->
    <el-dialog title="转账" :visible.sync="transferDialogVisible">
        <el-form :model="transferForm" label-width="80px">
            <el-form-item label="转账对象">
                <el-select v-model="transferForm.targetUserId" placeholder="请选择转账对象">
                    <el-option
                            v-for="user2 in allUsers"
                            :key="user2.id"
                            :label="user2.nickname"
                            :value="user2.id"
                            :disabled="user2.id == user.id"> <!-- 禁用自己 -->
                        <div style="display: flex; align-items: center;">
                            <el-avatar :size="30" :src="user2.avatarUrl" style="margin-right: 10px;"></el-avatar>
                            {{ user2.nickname }}
                        </div>
                    </el-option>
                </el-select>
            </el-form-item>
            <el-form-item label="转账金额">
                <el-input v-model.number="transferForm.amount" type="number" :min="0" :max="user.email"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button @click="transferDialogVisible = false">取 消</el-button>
            <el-button type="primary" @click="transfer">确 定</el-button>
        </div>
    </el-dialog>
</div>

<script>
    new Vue({
        el: '#app',
        data() {
            return {
                user: {},
                isEditing: false,
                originalUser: {},
                depositDialogVisible: false,
                withdrawDialogVisible: false,
                transferDialogVisible: false,
                depositAmount: 0,
                withdrawAmount: 0,
                allUsers: [],
                transferForm: {
                    targetUserId: null,
                    amount: 0
                }
            }
        },
        methods: {
            loadUserInfo() {
                const userInfo = localStorage.getItem('userInfo');
                if (userInfo) {
                    this.user = JSON.parse(userInfo);
                } else {
                    this.$message.error('未找到用户信息，请重新登录');
                    // 可以在这里添加重定向到登录页面的逻辑
                }
            },
            toggleEdit() {
                if (this.isEditing) {
                    this.saveProfile();
                } else {
                    this.startEdit();
                }
            },
            startEdit() {
                this.isEditing = true;
                this.originalUser = JSON.parse(JSON.stringify(this.user));
            },
            saveProfile() {
                this.isEditing = false;
                axiosWrapper.put('/user/update', this.user)
                    .then(response => {
                        // 检查响应的 code
                        if (response.code == 200) {
                            // 更新成功
                            localStorage.setItem('userInfo', JSON.stringify(this.user));
                            this.$message.success(response.msg || '个人资料已更新');

                            // 延迟1.5秒后刷新父页面
                            setTimeout(() => {
                                window.parent.location.reload();
                            }, 1500);
                        } else {
                            // 服务器返回了错误信息
                            this.$message.error(response.msg)
                        }
                    })
            },
            cancelEdit() {
                this.user = JSON.parse(JSON.stringify(this.originalUser));
                this.isEditing = false;
            },
            handleAvatarSuccess(res, file) {
                console.log(res)
                this.user.avatarUrl = res;
                // 更新 localStorage 中的用户信息
                localStorage.setItem('userInfo', JSON.stringify(this.user));
                // 调用更新用户信息的接口
                this.saveProfile();
            },
            beforeAvatarUpload(file) {
                return true;
            },
            showDepositDialog() {
                this.depositDialogVisible = true;
            },
            showWithdrawDialog() {
                this.withdrawDialogVisible = true;
            },
            deposit() {
                this.user.email = parseFloat(this.user.email) + parseFloat(this.depositAmount);
                this.saveProfile();
                this.recordTransaction('存款', this.depositAmount);
                this.depositDialogVisible = false;
            },
            withdraw() {
                if (this.withdrawAmount > this.user.email) {
                    this.$message.error('取款金额不能大于余额');
                    return;
                }
                this.user.email = parseFloat(this.user.email) - parseFloat(this.withdrawAmount);
                this.saveProfile();
                this.recordTransaction('取款', this.withdrawAmount);
                this.withdrawDialogVisible = false;
            },
            showTransferDialog() {
                this.fetchAllUsers();
                this.transferDialogVisible = true;
            },
            fetchAllUsers() {
                axiosWrapper.get('/user/range', {params: {pageNum: 1, pageSize: 9999}})
                    .then(response => {
                        this.allUsers = response.data.list;
                    })
                    .catch(error => {
                        console.error('Error fetching all users:', error);
                        this.$message.error('获取所有用户失败');
                    });
            },
            transfer() {
                if (!this.transferForm.targetUserId) {
                    this.$message.error('请选择转账对象');
                    return;
                }
                if (this.transferForm.amount <= 0 || this.transferForm.amount > this.user.email) {
                    this.$message.error('转账金额不合法');
                    return;
                }
                const targetUser = this.allUsers.find(user => user.id === this.transferForm.targetUserId);
                if (!targetUser) {
                    this.$message.error('未找到转账对象');
                    return;
                }

                // 检查是否给自己转账
                if (targetUser.id === this.user.id) {
                    this.$message.error('不能给自己转账');
                    return;
                }

                // 先获取目标用户的余额
                axiosWrapper.get(`/user/${targetUser.id}`)
                    .then(response => {
                        const targetUserBalance = parseFloat(response.data.email);
                        if (isNaN(targetUserBalance)) {
                            this.$message.error('目标用户余额获取失败');
                            return;
                        }

                        // 更新目标用户的余额
                        targetUser.email = targetUserBalance + parseFloat(this.transferForm.amount);
                        axiosWrapper.put('/user/update', targetUser)
                            .then(response => {
                                if (response.code == 200) {
                                    // 更新成功后，再更新当前用户的余额
                                    this.user.email = parseFloat(this.user.email) - parseFloat(this.transferForm.amount);
                                    axiosWrapper.put('/user/update', this.user)
                                        .then(response => {
                                            if (response.code == 200) {
                                                // 更新成功
                                                localStorage.setItem('userInfo', JSON.stringify(this.user));
                                                this.$message.success('转账成功');
                                                this.recordTransaction('转账', this.transferForm.amount, targetUser.id);
                                                this.transferDialogVisible = false;
                                                this.refreshUserInfo(); // 刷新用户信息
                                            } else {
                                                // 服务器返回了错误信息
                                                this.$message.error(response.msg);
                                            }
                                        })
                                        .catch(error => {
                                            console.error('Error updating current user:', error);
                                            this.$message.error('更新当前用户失败');
                                        });
                                } else {
                                    // 服务器返回了错误信息
                                    this.$message.error(response.msg);
                                }
                            })
                            .catch(error => {
                                console.error('Error updating target user:', error);
                                this.$message.error('更新目标用户失败');
                            });
                    })
                    .catch(error => {
                        console.error('Error fetching target user balance:', error);
                        this.$message.error('获取目标用户余额失败');
                    });
            },
            refreshUserInfo() {
                axiosWrapper.get(`/user/${this.user.id}`)
                    .then(response => {
                        this.user.email = response.data.email; // 只更新余额
                        localStorage.setItem('userInfo', JSON.stringify(this.user));
                        this.$message.success('余额已刷新');
                    })
                    .catch(error => {
                        console.error('Error refreshing user balance:', error);
                        this.$message.error('刷新余额失败');
                    });
            },
            recordTransaction(type, amount, targetUserId = null) {
                const formatDateTime = (date) => {
                    date.setHours(date.getHours() + 8);
                    return date.toISOString().slice(0, 19);
                };

                const transaction = {
                    userId: this.user.id,
                    transactionType: type,
                    amount: amount,
                    transactionTime: formatDateTime(new Date()),
                    targetUserId: targetUserId
                };

                return axiosWrapper.post('/api/transactions/saveOrUpdate', transaction)
                    .then(response => {
                        this.$message.success('交易记录已保存');
                        return response;
                    })
                    .catch(error => {
                        console.error('Error recording transaction:', error);
                        this.$message.error('保存交易记录失败');
                        throw error;
                    });
            }
        },
        mounted() {
            this.loadUserInfo();
        }
    });
</script>
</body>
</html>