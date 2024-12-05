<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>修改密码</title>
    <script src="vue2_resource/vue@2.6.14.js"></script>
    <link rel="stylesheet" href="vue2_resource/index.css">
    <script src="vue2_resource/elementui.js"></script>
    <script src="vue2_resource/axios.min.js"></script>
<script src="vue2_resource/axiosWrapper.js"></script>
    <style>
        body {
            background-color: #f0f2f5;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: "Helvetica Neue", Helvetica, "PingFang SC", "Hiragino Sans GB", "Microsoft YaHei", "微软雅黑", Arial, sans-serif;
        }
        .password-modify-container {
            width: 400px;
            padding: 40px;
            background-color: #fff;
            border-radius: 4px;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
        }
        .title {
            font-size: 24px;
            color: #303133;
            margin-bottom: 40px;
            text-align: center;
        }
    </style>
</head>
<body>
<div id="app">
    <div class="password-modify-container">
        <h2 class="title">修改密码</h2>
        <el-form :model="passwordForm" :rules="rules" ref="passwordForm" label-width="100px">
            <el-form-item label="当前密码" prop="currentPassword">
                <el-input type="password" v-model="passwordForm.currentPassword" autocomplete="off"></el-input>
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
                <el-input type="password" v-model="passwordForm.newPassword" autocomplete="off"></el-input>
            </el-form-item>
            <el-form-item label="确认新密码" prop="confirmPassword">
                <el-input type="password" v-model="passwordForm.confirmPassword" autocomplete="off"></el-input>
            </el-form-item>
            <el-form-item>
                <el-button type="primary" @click="submitForm('passwordForm')">提交</el-button>
                <el-button @click="resetForm('passwordForm')">重置</el-button>
            </el-form-item>
        </el-form>
    </div>
</div>

<script>
    new Vue({
        el: '#app',
        data() {
            return {
                passwordForm: {
                    currentPassword: '',
                    newPassword: '',
                    confirmPassword: ''
                },
                rules: {
                    currentPassword: [
                        { required: true, message: '请输入当前密码', trigger: 'blur' }
                    ],
                    newPassword: [
                        { required: true, message: '请输入新密码', trigger: 'blur' }
                    ],
                    confirmPassword: [
                        { required: true, message: '请确认新密码', trigger: 'blur' }
                    ]
                }
            };
        },
        methods: {
            submitForm(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        this.changePassword();
                    } else {
                        console.log('error submit!!');
                        return false;
                    }
                });
            },
            resetForm(formName) {
                this.$refs[formName].resetFields();
            },
            changePassword() {
                const userInfo = JSON.parse(localStorage.getItem('userInfo'));
                if (!userInfo || !userInfo.id) {
                    this.$message.error('用户信息不存在，请重新登录');
                    return;
                }

                axiosWrapper.post(`/user/${userInfo.id}/change-password`, null, {
                    params: {
                        oldPassword: this.passwordForm.currentPassword,
                        newPassword: this.passwordForm.newPassword
                    }
                }).then(response => {
                    if (response.code === 200) {
                        this.$message.success('密码修改成功，请重新登录');
                        this.logout();
                    } else {
                        this.$message.error(response.msg || '密码修改失败');
                    }
                }).catch(error => {
                    console.error('修改密码错误:', error);
                    this.$message.error('修改密码失败，请稍后重试');
                });
            },
            logout() {
                localStorage.removeItem('userInfo');
                // 假设登录页面是 login.jsp
                setTimeout(() => {
                    window.parent.location.href = 'login.jsp';
                }, 1500);
            }
        }
    })
</script>
</body>
</html>