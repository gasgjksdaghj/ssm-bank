<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>角色管理</title>
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

        .action-buttons {
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div id="app">
    <el-card>
        <div class="filter-section">
            <el-input
                    v-model="searchName"
                    placeholder="搜索角色名称"
                    @keyup.enter="handleSearch"
                    style="width: 200px;">
                <el-button slot="append" icon="el-icon-search" @click="handleSearch"></el-button>
            </el-input>
            <el-button @click="resetSearch"  size="small" icon="el-icon-refresh">重置</el-button>
            <el-button type="primary" @click="openAddRoleDialog" icon="el-icon-plus" size="small">添加角色</el-button>
        </div>
    </el-card>

    <el-card>
        <el-table :data="paginatedRoles" style="width: 100%">
            <el-table-column prop="id" label="角色ID" width="80"></el-table-column>
            <el-table-column prop="name" label="角色名称" width="120"></el-table-column>
            <el-table-column prop="flag" label="角色标签" width="120"></el-table-column>
            <el-table-column prop="description" label="角色描述"></el-table-column>
            <el-table-column label="操作" width="200" fixed="right">
                <template slot-scope="scope">
                    <el-button size="mini" type="primary" icon="el-icon-edit" @click="openEditRoleDialog(scope.row)">
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
                    :total="totalRoles">
            </el-pagination>
        </div>
    </el-card>

    <el-dialog :title="isEditMode ? '编辑角色' : '添加角色'" :visible.sync="dialogVisible">
        <el-form :model="currentRole" label-width="80px">
            <el-form-item label="角色名称">
                <el-input v-model="currentRole.name"></el-input>
            </el-form-item>
            <el-form-item label="角色标签">
                <el-input v-model="currentRole.flag"></el-input>
            </el-form-item>
            <el-form-item label="角色描述">
                <el-input type="textarea" v-model="currentRole.description"></el-input>
            </el-form-item>
        </el-form>
        <div slot="footer" class="dialog-footer">
            <el-button @click="dialogVisible = false">取 消</el-button>
            <el-button type="primary" @click="saveRole">确 定</el-button>
        </div>
    </el-dialog>
</div>

<script>
    new Vue({
        el: '#app',
        data() {
            return {
                roles: [],
                currentPage: 1,
                pageSize: 10,
                totalRoles: 0,
                dialogVisible: false,
                currentRole: {id: null, name: '', flag: '', description: ''},
                searchName: '',
                isEditMode: false
            }
        },
        computed: {
            paginatedRoles() {
                return this.roles;
            }
        },
        mounted() {
            this.fetchRoles();
        },
        methods: {
            fetchRoles() {
                const params = {
                    pageNum: this.currentPage,
                    pageSize: this.pageSize,
                    search: this.searchName
                };
                axiosWrapper.get('/role/page', {params})
                    .then(response => {
                        this.roles = response.data.list;
                        this.totalRoles = response.data.total;
                    })
                    .catch(error => {
                        console.error('Error fetching roles:', error);
                        this.$message.error('获取角色列表失败');
                    });
            },
            handleSizeChange(val) {
                this.pageSize = val;
                this.currentPage = 1;
                this.fetchRoles();
            },
            handleCurrentChange(val) {
                this.currentPage = val;
                this.fetchRoles();
            },
            handleSearch() {
                this.currentPage = 1;
                this.fetchRoles();
            },
            resetSearch() {
                this.searchName = '';
                this.currentPage = 1;
                this.fetchRoles();
            },
            openAddRoleDialog() {
                this.isEditMode = false;
                this.currentRole = {id: null, name: '', flag: '', description: ''};
                this.dialogVisible = true;
            },
            openEditRoleDialog(role) {
                this.isEditMode = true;
                this.currentRole = {...role};
                this.dialogVisible = true;
            },
            handleDelete(row) {
                this.$confirm('此操作将永久删除该角色, 是否继续?', '提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning'
                }).then(() => {
                    axiosWrapper.delete(`/role/${row.id}`)
                        .then(() => {
                            this.$message({
                                type: 'success',
                                message: '删除成功!'
                            });
                            this.fetchRoles();
                        })
                        .catch(error => {
                            console.error('Error deleting role:', error);
                            this.$message.error('删除角色失败');
                        });
                }).catch(() => {
                    this.$message({
                        type: 'info',
                        message: '已取消删除'
                    });
                });
            },
            saveRole() {
                const method = this.isEditMode ? 'put' : 'post';
                const url = this.isEditMode ? '/role/update' : '/role';
                axiosWrapper[method](url, this.currentRole)
                    .then(() => {
                        this.$message({
                            type: 'success',
                            message: this.isEditMode ? '角色更新成功!' : '角色添加成功!'
                        });
                        this.dialogVisible = false;
                        this.fetchRoles();
                    })
                    .catch(error => {
                        console.error('Error saving role:', error);
                        this.$message.error(this.isEditMode ? '更新角色失败' : '添加角色失败');
                    });
            }
        }
    });
</script>
</body>
</html>