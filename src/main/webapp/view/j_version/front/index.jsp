<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>综合系统</title>
    <script src="../vue2_resource/vue@2.6.14.js"></script>
    <link rel="stylesheet" href="../vue2_resource/index.css">
    <script src="../vue2_resource/elementui.js"></script>
    <style>
        body {
            background-color: #f0f7ff;
            color: #333333;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            transition: background-color 0.3s, color 0.3s;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        .app-container {
            display: flex;
            flex-direction: column;
            flex: 1;
        }

        .content-wrapper {
            width: 100%;
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            box-sizing: border-box;
        }

        .header {
            background-color: #7B99DB;
            box-shadow: 0 2px 10px rgba(123, 153, 219, 0.3);
            padding: 0;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            height: 60px;
        }

        .left-section {
            display: flex;
            align-items: center;
            height: 100%;
        }

        .logo-title-container {
            display: flex;
            align-items: center;
            height: 100%;
            padding: 0 20px;
        }

        .logo {
            display: flex;
            align-items: center;
            height: 100%;
            margin-right: 15px;
        }

        .logo img {
            height: 40px;
        }

        .site-title {
            font-family: 'Dancing Script', cursive;
            font-size: 28px;
            color: #ffffff;
            margin: 0;
            text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.2);
        }

        .nav-menu {
            height: 60px;
            line-height: 60px;
            border-bottom: none;
            background-color: transparent !important;
        }

        .nav-menu .el-menu-item {
            height: 60px;
            line-height: 60px;
            color: #ffffff;
            font-weight: 600;
        }

        .nav-menu .el-menu-item:hover,
        .nav-menu .el-menu-item:focus {
            background-color: rgba(255, 255, 255, 0.1) !important;
        }

        .nav-menu .el-menu-item.is-active {
            background-color: rgba(255, 255, 255, 0.2) !important;
            color: #ffffff !important;
        }

        .right-section {
            display: flex;
            align-items: center;
            height: 100%;
        }

        .search-input {
            width: 200px;
            margin-right: 20px;
        }

        .search-input .el-input__inner {
            border-color: #ffffff;
            background-color: rgba(255, 255, 255, 0.2);
            color: #ffffff;
        }

        .search-input .el-input__inner::placeholder {
            color: rgba(255, 255, 255, 0.7);
        }

        .user-info {
            background-color: rgba(255, 255, 255, 0.2);
            padding: 5px 10px;
            border-radius: 20px;
        }

        .user-dropdown {
            display: flex;
            align-items: center;
        }

        .el-dropdown-link {
            display: flex;
            align-items: center;
            cursor: pointer;
            color: #ffffff;
        }

        .user-name {
            margin-right: 8px;
            font-size: 14px;
            color: #ffffff;
            font-weight: bold;
        }

        .login-button {
            background-color: rgba(255, 255, 255, 0.2);
            color: #ffffff;
            border: none;
            border-radius: 20px;
            padding: 10px 20px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .login-button:hover {
            background-color: rgba(255, 255, 255, 0.3);
        }

        .footer {
            background-color: #7B99DB;
            color: #ffffff;
            padding: 0;
            margin-top: auto;
            height: 60px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .footer-content {
            text-align: center;
        }

        .main-content {
            flex: 1;
            width: 100%;
            max-width: 1200px;
            margin: 20px auto;
            padding: 20px;
            background-color: #ffffff;
            box-shadow: 0 0 20px rgba(123, 153, 219, 0.1);
            border-radius: 10px;
            box-sizing: border-box;
        }
    </style>
</head>
<body>
<div id="app">
    <div class="app-container">
        <el-header class="header" height="auto">
            <div class="content-wrapper">
                <div class="header-content">
                    <div class="left-section">
                        <div class="logo-title-container">
                            <div class="logo">
                                <img src="../images/1.svg" alt="Logo"/>
                            </div>
                            <h1 class="site-title">综合系统</h1>
                        </div>
                        <el-menu
                                mode="horizontal"
                                :default-active="activeIndex"
                                class="nav-menu"
                                @select="handleSelect"
                                background-color="#7B99DB"
                                text-color="#ffffff"
                                active-text-color="#ffffff">
                            <el-menu-item v-for="item in navItems" :key="item.index" :index="item.index">
                                {{ item.title }}
                            </el-menu-item>
                        </el-menu>
                    </div>
                    <div class="right-section">
                        <el-input
                                placeholder="搜索..."
                                v-model="searchInput"
                                class="search-input"
                                @keydown.enter.native="performSearch">
                            <el-button slot="append" icon="el-icon-search" @click="performSearch"></el-button>
                        </el-input>
                        <div v-if="user" class="user-info">
                            <el-dropdown @command="handleCommand" class="user-dropdown">
                                <span class="el-dropdown-link">
                                    <span class="user-name">{{ user.nickname }}</span>
                                    <el-avatar :size="32" :src="user.avatarUrl"></el-avatar>
                                </span>
                                <el-dropdown-menu slot="dropdown">
                                    <el-dropdown-item command="back">后台</el-dropdown-item>
                                    <el-dropdown-item command="logout">退出登录</el-dropdown-item>
                                </el-dropdown-menu>
                            </el-dropdown>
                        </div>
                        <el-button v-else class="login-button" @click="goToBackend">后台</el-button>
                    </div>
                </div>
            </div>
        </el-header>

        <div class="main-content" ref="mainContent">
            <h2>欢迎来到综合系统</h2>
            <p>这里是主要内容区域。您可以在这里添加更多的组件和内容。</p>
        </div>

        <el-footer class="footer">
            <div class="footer-content">
                <p>&copy; 2024 小牛马. 保留所有权利。</p>
            </div>
        </el-footer>
    </div>
</div>

<script>
    new Vue({
        el: '#app',
        data() {
            return {
                activeIndex: 'home',
                searchInput: '',
                user: null,
                navItems: [
                    {index: 'home', title: '首页', file: 'home.jsp'},
                ]
            }
        },
        methods: {
            performSearch() {
                if (this.searchInput.trim()) {
                    this.loadContent('search.jsp', this.searchInput);
                    this.searchInput = '';
                }
            },
            goToBackend() {
                window.location.href = '../index.jsp';
            },
            handleSelect(key, keyPath) {
                const selectedItem = this.navItems.find(item => item.index === key);
                if (selectedItem) {
                    this.loadContent(selectedItem.file);
                }
            },
            loadContent(fileName, searchQuery = null) {
                fetch(fileName)
                    .then(response => response.text())
                    .then(html => {
                        const parser = new DOMParser();
                        const doc = parser.parseFromString(html, 'text/html');

                        const scripts = doc.getElementsByTagName('script');
                        const scriptContent = Array.from(scripts).map(script => script.innerHTML).join(';');

                        Array.from(scripts).forEach(script => script.remove());

                        this.$refs.mainContent.innerHTML = doc.body.innerHTML;

                        if (scriptContent) {
                            const executeScript = new Function(scriptContent);
                            executeScript();
                        }

                        // 如果是搜索页面并且有搜索查询，触发自定义事件
                        if (fileName === 'search.jsp' && searchQuery) {
                            const event = new CustomEvent('search', {detail: searchQuery});
                            window.dispatchEvent(event);
                        }
                    })
            },
            handleCommand(command) {
                switch (command) {
                    case 'back':
                        window.location.href = '../index.jsp';
                        break;
                    case 'logout':
                        localStorage.removeItem('userInfo');
                        this.user = null;
                        this.$message.success('已退出登录');
                        window.location.href = '../login.jsp';
                        break;
                }
            },
            checkUserInfo() {
                const userInfo = localStorage.getItem('userInfo');
                if (!userInfo) {
                    window.location.href = '../login.jsp';
                } else {
                    this.user = JSON.parse(userInfo);
                    this.loadContent('home.jsp');
                }
            }
        },
        mounted() {
            this.checkUserInfo();
        }
    });
</script>
</body>
</html>