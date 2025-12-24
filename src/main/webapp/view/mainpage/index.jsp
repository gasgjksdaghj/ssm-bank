<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>主页面</title>
    <link rel="stylesheet" href="vue2_resource/index.css">
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            overflow: hidden;
        }

        #app {
            display: flex;
            height: 100vh;
        }

        .sidebar {
            background-color: #304156;
            color: #bfcbd9;
            transition: width 0.3s;
            overflow-x: hidden;
            overflow-y: auto;
        }

        .sidebar::-webkit-scrollbar {
            width: 0;
            background: transparent;
        }

        .sidebar {
            scrollbar-width: none;
            -ms-overflow-style: none;
        }

        .sidebar-expanded {
            width: 210px;
        }

        .sidebar-collapsed {
            width: 64px;
        }

        .sidebar-header {
            padding: 15px;
            background-color: #2b2f3a;
            height: 50px;
            box-sizing: border-box;
            display: flex;
            justify-content: center;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 1;
        }

        .sidebar-header h2 {
            margin: 0;
            color: #fff;
            font-size: 16px;
            white-space: nowrap;
        }

        .main-content {
            flex-grow: 1;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        .header {
            background-color: #fff;
            padding: 0 15px;
            height: 50px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 1px 4px rgba(0, 21, 41, .08);
        }

        .header-left, .header-right {
            display: flex;
            align-items: center;
        }

        .header-left > *, .header-right > * {
            margin-left: 15px;
        }

        .el-menu {
            border-right: none;
        }

        .el-menu-item, .el-submenu__title {
            height: 50px;
            line-height: 50px;
        }

        .el-menu-item [class^="el-icon-"], .el-submenu__title [class^="el-icon-"] {
            margin-right: 5px;
            font-size: 16px;
        }

        .breadcrumb {
            display: inline-block;
        }

        .el-breadcrumb__item:first-child .el-breadcrumb__inner {
            cursor: pointer;
        }

        .el-breadcrumb__item:first-child .el-breadcrumb__inner:hover {
            color: #409EFF;
        }

        .el-breadcrumb__item:not(:first-child) .el-breadcrumb__inner {
            color: #606266;
            cursor: default;
        }

        .el-breadcrumb__item:not(:first-child) .el-breadcrumb__inner:hover {
            color: #606266;
        }

        .iframe-container {
            flex-grow: 1;
            height: calc(100vh - 50px);
            overflow: hidden;
        }

        iframe {
            width: 100%;
            height: 100%;
            border: none;
        }

        .el-dropdown-menu__item {
            cursor: pointer;
        }

        .theme-button {
            margin-left: 15px;
        }

        .color-option {
            width: 100%;
            height: 40px;
            margin: 10px 0;
            cursor: pointer;
            display: flex;
            align-items: center;
            border-radius: 4px;
            overflow: hidden;
        }

        .color-preview {
            width: 40px;
            height: 40px;
        }

        .color-name {
            padding-left: 10px;
            color: #606266;
        }
    </style>
</head>
<body>
<div id="app">
    <div class="sidebar" :style="currentTheme.sidebar">
        <div class="sidebar-header" :style="currentTheme.sidebarHeader">
            <h2 v-if="!isCollapse"></h2>
            <h2 v-else>V2</h2>
        </div>
<%--        使用Element UI的菜单组件，动态生成菜单项。根据用户角色过滤可见菜单项。--%>
<%--        使用v-if和v-for指令来动态显示菜单。--%>
        <el-menu
                :default-active="activeIndex"
                class="el-menu-vertical-demo"
                :collapse="isCollapse"
                :background-color="currentTheme.menuBackgroundColor"
                :text-color="currentTheme.menuTextColor"
                :active-text-color="currentTheme.menuActiveTextColor">
<%--            使用 v-if 判断是否存在子菜单，并根据结果生成相应的菜单结构。--%>
            <template v-for="menu in filteredMenuItems">
                <el-submenu v-if="menu.submenu" :index="menu.id" :key="menu.id">
                    <template slot="title">
                        <i :class="menu.icon"></i>
                        <span>{{ menu.title }}</span>
                    </template>
                    <el-menu-item v-for="submenu in filteredSubmenuItems(menu.submenu)"
                                  :key="submenu.id"
                                  :index="submenu.id"
                                  @click="loadContent(submenu)">
                        {{ submenu.title }}
                    </el-menu-item>
                </el-submenu>
                <el-menu-item v-else :index="menu.id" :key="menu.id" @click="loadContent(menu)">
                    <i :class="menu.icon"></i>
                    <span slot="title">{{ menu.title }}</span>
                </el-menu-item>
            </template>
        </el-menu>
    </div>
    <div class="main-content">
        <div class="header">
            <div class="header-left">
                <el-breadcrumb separator="/">
                    <el-breadcrumb-item v-for="(item, index) in breadcrumbs" :key="index">
                        <span v-if="index === 0" @click="handleHomeClick">{{ item.title }}</span>
                        <span v-else>{{ item.title }}</span>
                    </el-breadcrumb-item>
                </el-breadcrumb>
            </div>
            <div class="header-right">
                <el-button icon="el-icon-s-operation" @click="drawer = true" size="small" class="theme-button">主题设置</el-button>
                <el-dropdown>
                    <span class="el-dropdown-link">
                        <el-avatar size="small"
                                   :src="userInfo.avatarUrl"></el-avatar>
                        {{ userInfo.nickname }}<i class="el-icon-arrow-down el-icon--right"></i>
                    </span>
                    <el-dropdown-menu slot="dropdown">
                        <el-dropdown-item @click.native="loadHeaderItem('profile')">个人信息</el-dropdown-item>
                        <el-dropdown-item @click.native="loadHeaderItem('passwordModify')">修改密码</el-dropdown-item>
                        <el-dropdown-item @click.native="logout">退出登录</el-dropdown-item>
                    </el-dropdown-menu>
                </el-dropdown>
            </div>
        </div>
        <div class="iframe-container">
            <iframe :src="currentUrl" ref="contentFrame"></iframe>
        </div>
    </div>
<%--    主题设置抽屉--%>
    <el-drawer
            title="主题设置"
            :visible.sync="drawer"
            direction="rtl"
            size="300px">
        <div style="padding: 20px;">
            <h3>侧边栏主题</h3>
            <div v-for="(theme, index) in themes" :key="index"
                 class="color-option"
                 :style="{ backgroundColor: theme.menuBackgroundColor }"
                 @click="changeTheme(theme)">
                <div class="color-preview" :style="{ backgroundColor: theme.menuActiveTextColor }"></div>
                <span class="color-name" :style="{ color: theme.menuTextColor }">{{ theme.name }}</span>
            </div>
        </div>
    </el-drawer>
</div>

<script src="vue2_resource/vue@2.6.14.js"></script>
<script src="vue2_resource/elementui.js"></script>
<script src="vue2_resource/echarts.min.js"></script>
<script type="module">
    import menuItems from './menu-items.js';

    new Vue({
        el: '#app',
        data: {
            drawer: false,
            themes: [
                {
                    name: '清爽青',
                    sidebar: { backgroundColor: '#16a085' },
                    sidebarHeader: { backgroundColor: '#1abc9c' },
                    menuBackgroundColor: '#16a085',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#f1c40f'
                },
                {
                    name: '柔和粉',
                    sidebar: { backgroundColor: '#ec407a' },
                    sidebarHeader: { backgroundColor: '#d81b60' },
                    menuBackgroundColor: '#ec407a',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#ffeb3b'
                },
                {
                    name: '优雅米',
                    sidebar: { backgroundColor: '#bcaaa4' },
                    sidebarHeader: { backgroundColor: '#a1887f' },
                    menuBackgroundColor: '#bcaaa4',
                    menuTextColor: '#3e2723',
                    menuActiveTextColor: '#5d4037'
                }
            ],
            currentTheme: null,
            activeIndex: '1',
            isCollapse: false,
            breadcrumbs: [{title: '首页', url: 'dashboard.jsp'}],
            userInfo: {},
            menuItems: menuItems,
            currentUrl: 'dashboard.jsp',
            headerItems: {
                profile: {title: '个人信息', url: 'profile.jsp'},
                passwordModify: {title: '修改密码', url: 'passwordModify.jsp'}
            }
        },
        // 使用计算属性 filteredMenuItems 来根据当前用户的角色过滤可见的菜单项 该计算属性遍历所有菜单项（menuItems），并检查每个菜单项的 roles 属性是否包含当前用户的角色（this.userInfo.role）。只有符合条件的菜单项才会被返回，从而实现动态显示。
        computed: {
            filteredMenuItems() {
                return this.menuItems.filter(item => item.roles.includes(this.userInfo.role));
            }
        },
        methods: {
            changeTheme(theme) {
                this.currentTheme = theme;
                this.saveTheme();
            },
            saveTheme() {
                localStorage.setItem('currentTheme', JSON.stringify(this.currentTheme));
            },
            loadTheme() {
                const savedTheme = localStorage.getItem('currentTheme');
                if (savedTheme) {
                    this.currentTheme = JSON.parse(savedTheme);
                } else {
                    this.currentTheme = this.themes[0]; // Default theme
                }
            },
            loadContent(menuItem) {
                if (menuItem.url) {
                    this.currentUrl = menuItem.url;
                    this.updateBreadcrumbs(menuItem);
                }
            },
            updateBreadcrumbs(menuItem) {
                this.breadcrumbs = [{title: '首页', url: 'dashboard.jsp'}];
                if (menuItem.title !== '仪表盘') {
                    const parentMenu = this.menuItems.find(item =>
                        item.submenu && item.submenu.some(subItem => subItem.id === menuItem.id)
                    );
                    if (parentMenu) {
                        this.breadcrumbs.push({title: parentMenu.title, url: null});
                    }
                    this.breadcrumbs.push({title: menuItem.title, url: menuItem.url});
                }
            },
            handleHomeClick() {
                this.loadContent(this.menuItems[0]);
            },
            filteredSubmenuItems(submenu) {
                return submenu.filter(item => item.roles.includes(this.userInfo.role));
            },
            logout() {
                localStorage.removeItem('userInfo');
                location.href = "login.jsp";
            },
            loadHeaderItem(itemKey) {
                const item = this.headerItems[itemKey];
                if (item) {
                    this.currentUrl = item.url;
                    this.updateBreadcrumbs(item);
                }
            },
        },
        // 在组件创建时，尝试从本地存储中获取 userInfo。如果获取成功，则将其解析并赋值给 this.userInfo。
        created() {
            this.loadTheme();
            const storedUserInfo = localStorage.getItem('userInfo');
            if (storedUserInfo) {
                try {
                    this.userInfo = JSON.parse(storedUserInfo);
                    this.loadContent(this.menuItems[0]);
                } catch (error) {
                    window.location.href = "login.jsp";
                }
            } else {
                window.location.href = "login.jsp";
            }
        }
    })
</script>
</body>
</html>