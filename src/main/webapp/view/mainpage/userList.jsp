<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>用户列表</title>
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

        .avatar-uploader .el-upload {
            border: 1px dashed #d9d9d9;
            border-radius: 6px;
            cursor: pointer;
            position: relative;
            overflow: hidden;
        }

        .avatar-uploader .el-upload:hover {
            border-color: #409EFF;
        }

        .avatar-uploader-icon {
            font-size: 28px;
            color: #8c939d;
            width: 178px;
            height: 178px;
            line-height: 178px;
            text-align: center;
        }

        .avatar {
            width: 178px;
            height: 178px;
            display: block;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            border-radius: 50%;
        }
    </style>
</head>
<body>
<div id="app">
    <el-card>
        <div class="filter-section">
            <el-input
                    v-model="searchName"
                    placeholder="搜索昵称"
                    style="width: 200px;">
            </el-input>
            <el-date-picker
                    v-model="dateRange"
                    type="daterange"
                    range-separator="至"
                    start-placeholder="开始日期"
                    value-format="yyyy-MM-dd HH:mm:ss"
                    end-placeholder="结束日期">
            </el-date-picker>
            <el-button type="primary" icon="el-icon-search" @click="handleSearch" size="small">搜索</el-button>
            <el-button type="info" icon="el-icon-refresh" @click="resetSearch" size="small">重置</el-button>
        </div>
    </el-card>

    <el-card>
        <el-table :data="users" style="width: 100%;">
            <el-table-column prop="id" label="ID" width="80"></el-table-column>
            <el-table-column label="头像" width="70">
                <template slot-scope="scope">
                    <el-image
                            style="width: 40px; height: 40px; border-radius: 50%;"
                            :src="scope.row.avatarUrl"
                            :preview-src-list="[scope.row.avatarUrl]">
                    </el-image>
                </template>
            </el-table-column>
            <el-table-column prop="username" label="用户名" width="120"></el-table-column>
            <el-table-column prop="nickname" label="昵称" width="120"></el-table-column>
            <el-table-column prop="email" label="余额" width="180"></el-table-column>
            <el-table-column prop="phone" label="电话" width="140"></el-table-column>
            <el-table-column prop="address" label="地址" width="200"></el-table-column>
            <el-table-column prop="role" label="角色" width="100"></el-table-column>
            <el-table-column prop="createTime" label="创建时间" width="160"></el-table-column>
            <el-table-column prop="updateTime" label="更新时间" width="160"></el-table-column>
            <el-table-column label="状态" width="100" align="center">
                <template slot-scope="scope">
                    <el-switch
                            v-model="scope.row.status"
                            active-color="#13ce66"
                            inactive-color="#ff4949"
                            :active-value="1"
                            :inactive-value="0"
                            @change="handleStatusChange(scope.row)">
                    </el-switch>
                </template>
            </el-table-column>
            <el-table-column label="操作" width="200" fixed="right">
                <template slot-scope="scope">
                    <el-button size="mini" type="primary" icon="el-icon-edit" @click="openEditUserDialog(scope.row)">
                        编辑
                    </el-button>
                    <el-button size="mini" type="danger" icon="el-icon-delete" @click="handleDelete(scope.row)">删除
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
                    :total="totalUsers">
            </el-pagination>
        </div>
    </el-card>

    <el-dialog title="编辑用户" :visible.sync="dialogVisible">
        <el-form :model="currentUser" label-width="80px">
            <el-form-item label="头像">
                <el-upload
                        class="avatar-uploader"
                        action="/file/upload"
                        :show-file-list="false"
                        :on-success="handleAvatarSuccess"
                        :before-upload="beforeAvatarUpload">
                    <img v-if="currentUser.avatarUrl" :src="currentUser.avatarUrl" class="avatar">
                    <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                </el-upload>
            </el-form-item>
            <el-form-item label="用户名">
                <el-input v-model="currentUser.username"></el-input>
            </el-form-item>
            <el-form-item label="昵称">
                <el-input v-model="currentUser.nickname"></el-input>
            </el-form-item>
            <el-form-item label="余额">
                <el-input v-model="currentUser.email" disabled></el-input>
            </el-form-item>
            <el-form-item label="电话">
                <el-input v-model="currentUser.phone"></el-input>
            </el-form-item>
            <el-form-item label="地址">
                <el-input v-model="currentUser.address"></el-input>
            </el-form-item>
            <el-form-item label="角色">
                <el-select v-model="currentUser.role" placeholder="请选择角色">
                    <el-option
                            v-for="role in roles"
                            :key="role.id"
                            :label="role.name"
                            :value="role.flag">
                    </el-option>
                </el-select>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button @click="dialogVisible = false" size="small" icon="el-icon-close">取 消</el-button>
            <el-button type="primary" @click="saveUser" size="small" icon="el-icon-check">确 定</el-button>
        </div>
    </el-dialog>
</div>

<script>
    new Vue({
        el: '#app',
        data() {
            return {
                users: [],
                roles: [],
                currentPage: 1,
                pageSize: 10,
                totalUsers: 0,
                dialogVisible: false,
                currentUser: {
                    id: null,
                    username: '',
                    password: '',
                    nickname: '',
                    email: '',
                    phone: '',
                    address: '',
                    createTime: null,
                    updateTime: null,
                    avatarUrl: '',
                    role: '',
                    status: 1
                },
                searchName: '',
                dateRange: [],
            }
        },
        mounted() {
            this.fetchUsers();
            this.fetchRoles();
        },
        methods: {
            fetchUsers() {
                const params = {
                    pageNum: this.currentPage,
                    pageSize: this.pageSize,
                    nickname: this.searchName,
                    startTime: this.dateRange[0],
                    endTime: this.dateRange[1]
                };
                axiosWrapper.get('/user/range', { params })
                    .then(response => {
                        this.users = response.data.list;
                        this.totalUsers = response.data.total;
                    })
                    .catch(error => {
                        console.error('Error fetching users:', error);
                        this.$message.error('获取用户列表失败');
                    });
            },
            fetchRoles() {
                axiosWrapper.get('/role/all')
                    .then(response => {
                        this.roles = response.data;
                    })
                    .catch(error => {
                        console.error('Error fetching roles:', error);
                        this.$message.error('获取角色列表失败');
                    });
            },
            handleSizeChange(val) {
                this.pageSize = val;
                this.currentPage = 1;
                this.fetchUsers();
            },
            handleCurrentChange(val) {
                this.currentPage = val;
                this.fetchUsers();
            },
            handleSearch() {
                this.currentPage = 1;
                this.fetchUsers();
            },
            resetSearch() {
                this.searchName = '';
                this.dateRange = [];
                this.currentPage = 1;
                this.fetchUsers();
            },
            openEditUserDialog(user) {
                this.currentUser = {...user};
                this.dialogVisible = true;
            },
            handleDelete(row) {
                this.$confirm('此操作将永久删除该用户, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    axiosWrapper.delete(`/user/${row.id}`)
                        .then(() => {
                            this.$message({
                                type: 'success',
                                message: '删除成功!'
                            });
                            this.fetchUsers();
                        })
                        .catch(error => {
                            console.error('Error deleting user:', error);
                            this.$message.error('删除用户失败');
                        });
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            handleStatusChange(row) {
                axiosWrapper.put(`/user/update`, row)
                    .then(() => {
                        this.$message({
                            type: 'success',
                            message: row.status === 1 ? '用户已启用' : '用户已禁用'
                        });
                    })
                    .catch(error => {
                        console.error('Error updating user status:', error);
                        this.$message.error('更新用户状态失败');
                        row.status = row.status === 1 ? 0 : 1;
                    });
            },
            saveUser() {
                axiosWrapper.put('/user/update', this.currentUser)
                    .then(() => {
                        this.$message({
                            type: 'success',
                            message: '用户更新成功!'
                        });
                        this.dialogVisible = false;
                        this.fetchUsers();
                    })
                    .catch(error => {
                        console.error('Error saving user:', error);
                        this.$message.error('更新用户失败');
                    });
            },
            handleAvatarSuccess(res) {
                console.log(res);
                this.currentUser.avatarUrl = res;
            },
            beforeAvatarUpload(file) {
                // 移除了文件类型和大小限制
                return true;
            }
        }
    });
</script>
</body>
</html>