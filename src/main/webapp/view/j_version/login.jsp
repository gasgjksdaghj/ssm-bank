<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录/注册页面</title>
    <script src="vue2_resource/vue@2.6.14.js"></script>
    <link rel="stylesheet" href="vue2_resource/index.css">
    <script src="vue2_resource/elementui.js"></script>
    <script src="vue2_resource/axios.min.js"></script>
<script src="vue2_resource/axiosWrapper.js"></script>
    <style>
        body {
            margin: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: linear-gradient(135deg, #bec7ea 0%, #cbbdd8 100%);
        }
        .login-container {
            display: flex;
            width: 800px;
            background-color: white;
            border-radius: 4px;
            overflow: hidden;
            box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
        }
        .login-image {
            flex: 1;
            background-color: #409EFF;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .login-form {
            flex: 1;
            padding: 40px;
        }
        .login-title {
            font-size: 24px;
            margin-bottom: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .other-login {
            margin-top: 20px;
            text-align: center;
            font-size: 12px;
            color: #606266;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .other-login::before,
        .other-login::after {
            content: "";
            flex: 1;
            border-top: 1px solid #DCDFE6;
            margin: 0 10px;
        }
        .copyright {
            position: fixed;
            bottom: 20px;
            left: 0;
            right: 0;
            text-align: center;
            font-size: 12px;
            color: white;
        }
        .captcha {
            background-color: #f0f2f5;
            height: 40px;
            line-height: 40px;
            text-align: center;
            cursor: pointer;
            user-select: none;
        }
        .captcha-item {
            display: inline-block;
            margin: 0 5px;
            font-size: 18px;
            font-weight: bold;
            vertical-align: middle;
            transform-origin: center;
        }
        .captcha-item.number { color: #409EFF; }
        .captcha-item.symbol { color: #F56C6C; }
        .other-login-icons {
            text-align: center;
            margin-top: 10px;
        }
        .other-login-icons i {
            font-size: 24px;
            margin: 0 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .other-login-icons i:hover {
            color: #409EFF;
            transform: scale(1.2);
        }
    </style>
</head>
<body>
<div id="app">
    <div class="login-container">
        <div class="login-image">
            <img src="images/1.svg" alt="登录插图" style="max-width: 80%; max-height: 80%;">
        </div>
        <div class="login-form">
            <div class="login-title">
                <span>{{ isLogin ? '登录' : '注册' }}</span>
                <el-button type="text" @click="toggleLoginRegister">
                    {{ isLogin ? '注册账号' : '使用已有账号登录' }}
                </el-button>
            </div>
            <el-form :model="form" :rules="rules" ref="form">
                <el-form-item prop="username">
                    <el-input v-model="form.username" prefix-icon="el-icon-user"
                              :placeholder="isLogin ? '用户名' : '设置用户名'"></el-input>
                </el-form-item>
                <el-form-item prop="password">
                    <el-input v-model="form.password" prefix-icon="el-icon-lock" type="password"
                              :placeholder="isLogin ? '密码' : '设置密码'" show-password></el-input>
                </el-form-item>
                <el-form-item v-if="!isLogin" prop="confirmPassword">
                    <el-input v-model="form.confirmPassword" prefix-icon="el-icon-lock" type="password"
                              placeholder="确认密码" show-password></el-input>
                </el-form-item>
                <el-form-item v-if="!isLogin" prop="role">
                    <el-select v-model="form.role" placeholder="请选择注册角色">
                        <el-option
                                v-for="role in roleOptions"
                                :key="role.id"
                                :label="role.name"
                                :value="role.flag">
                        </el-option>
                    </el-select>
                </el-form-item>
                <el-form-item prop="captcha">
                    <el-row :gutter="10">
                        <el-col :span="14">
                            <el-input v-model="form.captcha" placeholder="验证码"></el-input>
                        </el-col>
                        <el-col :span="10">
                            <div @click="refreshCaptcha" class="captcha">
                                <span v-for="(item, index) in captchaItems" :key="index"
                                      :class="['captcha-item', item.type]"
                                      :style="{ transform: `rotate(${item.rotation}deg)` }">
                                    {{ item.value }}
                                </span>
                            </div>
                        </el-col>
                    </el-row>
                </el-form-item>
                <el-form-item v-if="isLogin">
                    <el-checkbox v-model="form.remember">记住我</el-checkbox>
                    <el-button type="text" style="float: right;">忘记密码</el-button>
                </el-form-item>
                <el-form-item>
                    <el-button type="primary" @click="submitForm('form')" style="width: 100%;" :loading="loading">
                        {{ isLogin ? '登录' : '注册' }}
                    </el-button>
                </el-form-item>
            </el-form>
            <div v-if="isLogin" class="other-login">
                <span>其他登录方式</span>
            </div>
            <div v-if="isLogin" class="other-login-icons">
                <i class="el-icon-chat-dot-round" @click="notifyDevelopment"></i>
                <i class="el-icon-bell" @click="notifyDevelopment"></i>
                <i class="el-icon-s-promotion" @click="notifyDevelopment"></i>
                <i class="el-icon-user" @click="notifyDevelopment"></i>
            </div>
        </div>
    </div>
    <div class="copyright">
        Copyright © 2021 - 2024 youlai.tech All Rights Reserved. 粤ICP备2000649号-2
    </div>
</div>

<script>
    new Vue({
        el: '#app',
        data() {
            const validatePass = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请输入密码'));
                } else {
                    if (this.form.confirmPassword !== '') {
                        this.$refs.form.validateField('confirmPassword');
                    }
                    callback();
                }
            };
            const validatePass2 = (rule, value, callback) => {
                if (value === '') {
                    callback(new Error('请再次输入密码'));
                } else if (value !== this.form.password) {
                    callback(new Error('两次输入密码不一致!'));
                } else {
                    callback();
                }
            };
            return {
                isLogin: true,
                loading: false,
                form: {
                    username: '',
                    password: '',
                    confirmPassword: '',
                    captcha: '',
                    remember: false,
                    role: ''
                },
                rules: {
                    username: [{required: true, message: '请输入用户名', trigger: 'blur'}],
                    password: [{validator: validatePass, trigger: 'blur'}],
                    confirmPassword: [{validator: validatePass2, trigger: 'blur'}],
                    captcha: [
                        {required: true, message: '请输入验证码', trigger: 'blur'},
                        {validator: this.validateCaptcha, trigger: 'blur'}
                    ],
                    role: [{required: true, message: '请选择注册角色', trigger: 'change'}]
                },
                captchaItems: [],
                captchaResult: 0,
                roleOptions: []
            }
        },
        methods: {
            toggleLoginRegister() {
                this.isLogin = !this.isLogin;
                this.resetForm();
                if (!this.isLogin && this.roleOptions.length === 0) {
                    this.fetchRoles();
                }
            },
            resetForm() {
                this.$refs.form.resetFields();
                this.refreshCaptcha();
            },
            submitForm(formName) {
                this.$refs[formName].validate((valid) => {
                    if (valid) {
                        if (this.isLogin) {
                            this.loginUser();
                        } else {
                            this.registerUser();
                        }
                    } else {
                        console.log('提交错误!!');
                        return false;
                    }
                });
            },
            loginUser() {
                this.loading = true;
                axiosWrapper.post('/user/login', null, {
                    params: {
                        username: this.form.username,
                        password: this.form.password
                    }
                }).then(response => {
                    if (response.code === 200) {
                        localStorage.setItem('userInfo', JSON.stringify(response.data));
                        this.$message({
                            message: '登录成功',
                            type: 'success'
                        });
                        setTimeout(() => {
                            location.href = "index.jsp";
                        }, 1500);
                    } else {
                        this.$message.error(response.msg || '登录失败');
                        this.refreshCaptcha();
                    }
                })
                    .catch(error => {
                        console.error('登录错误:', error);
                        this.$message.error('登录失败，请稍后重试');
                        this.refreshCaptcha();
                    })
                    .finally(() => {
                        this.loading = false;
                    });
            },
            registerUser() {
                this.loading = true;
                const registerData = {
                    username: this.form.username,
                    password: this.form.password,
                    role: this.form.role
                };

                axiosWrapper.post('/user/register', registerData)
                    .then(response => {
                        if (response.code === 200) {
                            this.$message({
                                message: '注册成功',
                                type: 'success'
                            });
                            this.isLogin = true;
                            this.resetForm();
                        } else {
                            this.$message.error(response.msg || '注册失败');
                            this.refreshCaptcha();
                        }
                    })
                    .catch(error => {
                        console.error('注册错误:', error);
                        this.$message.error('注册失败，请稍后重试');
                        this.refreshCaptcha();
                    })
                    .finally(() => {
                        this.loading = false;
                    });
            },
            refreshCaptcha() {
                const operations = ['+', '-', '*'];
                const num1 = Math.floor(Math.random() * 10);
                const num2 = Math.floor(Math.random() * 10);
                const operation = operations[Math.floor(Math.random() * operations.length)];
                this.captchaItems = [
                    {value: num1, type: 'number', rotation: this.getRandomRotation()},
                    {value: operation, type: 'symbol', rotation: this.getRandomRotation()},
                    {value: num2, type: 'number', rotation: this.getRandomRotation()},
                    {value: '=', type: 'symbol', rotation: this.getRandomRotation()}
                ];
                switch (operation) {
                    case '+':
                        this.captchaResult = num1 + num2;
                        break;
                    case '-':
                        this.captchaResult = num1 - num2;
                        break;
                    case '*':
                        this.captchaResult = num1 * num2;
                        break;
                }
                this.form.captcha = ''; // 清空验证码输入框
            },
            validateCaptcha(rule, value, callback) {
                if (parseInt(value) !== this.captchaResult) {
                    callback(new Error('验证码错误'));
                } else {
                    callback();
                }
            },
            getRandomRotation() {
                return Math.floor(Math.random() * 51) - 25;
            },
            notifyDevelopment() {
                this.$message({
                    message: '该功能正在开发中',
                    type: 'info'
                });
            },
            fetchRoles() {
                axiosWrapper.get('/role/all')
                    .then(response => {
                        if (response.code === 200) {
                            this.roleOptions = response.data;
                        } else {
                            this.$message.error('获取角色列表失败');
                        }
                    })
                    .catch(error => {
                        console.error('获取角色列表错误:', error);
                        this.$message.error('获取角色列表失败，请稍后重试');
                    });
            }
        },
        mounted() {
            this.refreshCaptcha();
        }
    })
</script>
</body>
</html>