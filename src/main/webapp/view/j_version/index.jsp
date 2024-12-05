<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>vue2-element-admin</title>
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

        .el-menu--collapse {
            width: 64px;
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
        }   .theme-button {
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
            <h2 v-if="!isCollapse">vue2-element-admin</h2>
            <h2 v-else>V2</h2>
        </div>
        <el-menu
                :default-active="activeIndex"
                class="el-menu-vertical-demo"
                :collapse="isCollapse"
                :background-color="currentTheme.menuBackgroundColor"
                :text-color="currentTheme.menuTextColor"
                :active-text-color="currentTheme.menuActiveTextColor">
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
                <el-button icon="el-icon-s-fold" @click="toggleSidebar" size="small"></el-button>
                <el-breadcrumb separator="/">
                    <el-breadcrumb-item v-for="(item, index) in breadcrumbs" :key="index">
                        <span v-if="index === 0" @click="handleHomeClick">{{ item.title }}</span>
                        <span v-else>{{ item.title }}</span>
                    </el-breadcrumb-item>
                </el-breadcrumb>
            </div>
            <div class="header-right">
                <el-button icon="el-icon-s-operation" @click="drawer = true" size="small" class="theme-button">主题设置</el-button>

                <el-button icon="el-icon-full-screen" @click="toggleFullScreen" size="small"></el-button>
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
        data: { drawer: false,
            themes: [
                {
                    name: '经典蓝',
                    sidebar: { backgroundColor: '#1e3799' },
                    sidebarHeader: { backgroundColor: '#1a237e' },
                    menuBackgroundColor: '#1e3799',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#8ed1fc'
                },
                {
                    name: '清新绿',
                    sidebar: { backgroundColor: '#2ecc71' },
                    sidebarHeader: { backgroundColor: '#27ae60' },
                    menuBackgroundColor: '#2ecc71',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#f1c40f'
                },
                {
                    name: '优雅紫',
                    sidebar: { backgroundColor: '#8e44ad' },
                    sidebarHeader: { backgroundColor: '#6c3483' },
                    menuBackgroundColor: '#8e44ad',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#f39c12'
                },
                {
                    name: '沉稳灰',
                    sidebar: { backgroundColor: '#34495e' },
                    sidebarHeader: { backgroundColor: '#2c3e50' },
                    menuBackgroundColor: '#34495e',
                    menuTextColor: '#ecf0f1',
                    menuActiveTextColor: '#3498db'
                },
                {
                    name: '暖阳橙',
                    sidebar: { backgroundColor: '#e67e22' },
                    sidebarHeader: { backgroundColor: '#d35400' },
                    menuBackgroundColor: '#e67e22',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#3498db'
                },
                {
                    name: '清爽青',
                    sidebar: { backgroundColor: '#16a085' },
                    sidebarHeader: { backgroundColor: '#1abc9c' },
                    menuBackgroundColor: '#16a085',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#f1c40f'
                },
                {
                    name: '典雅棕',
                    sidebar: { backgroundColor: '#795548' },
                    sidebarHeader: { backgroundColor: '#5d4037' },
                    menuBackgroundColor: '#795548',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#ffc107'
                },
                {
                    name: '沉静蓝灰',
                    sidebar: { backgroundColor: '#607d8b' },
                    sidebarHeader: { backgroundColor: '#455a64' },
                    menuBackgroundColor: '#607d8b',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#ff9800'
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
                    name: '清新薄荷',
                    sidebar: { backgroundColor: '#26a69a' },
                    sidebarHeader: { backgroundColor: '#00897b' },
                    menuBackgroundColor: '#26a69a',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#ffd54f'
                },
                {
                    name: '深邃蓝',
                    sidebar: { backgroundColor: '#283593' },
                    sidebarHeader: { backgroundColor: '#1a237e' },
                    menuBackgroundColor: '#283593',
                    menuTextColor: '#ffffff',
                    menuActiveTextColor: '#4fc3f7'
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
            toggleSidebar() {
                this.isCollapse = !this.isCollapse;
            },
            toggleFullScreen() {
                if (!document.fullscreenElement) {
                    document.documentElement.requestFullscreen();
                } else {
                    if (document.exitFullscreen) {
                        document.exitFullscreen();
                    }
                }
            },
            loadContent(menuItem) {
                if (menuItem.url) {
                    this.currentUrl = menuItem.url;
                    this.updateBreadcrumbs(menuItem);
                    this.$nextTick(() => {
                        this.applyPermissions();
                    });
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
            findMenuItemById(id) {
                for (const item of this.menuItems) {
                    if (item.id === id) return item;
                    if (item.submenu) {
                        const subItem = item.submenu.find(sub => sub.id === id);
                        if (subItem) return subItem;
                    }
                }
                return null;
            },
            filteredSubmenuItems(submenu) {
                return submenu.filter(item => item.roles.includes(this.userInfo.role));
            },
            logout() {
                localStorage.removeItem('userInfo');
                location.href = "login.jsp"
            },
            loadHeaderItem(itemKey) {
                if (itemKey == "front") {
                    location.href = "front/index.jsp";
                }
                const item = this.headerItems[itemKey];
                if (item) {
                    this.currentUrl = item.url;
                    this.updateBreadcrumbs(item);
                }
            },
            applyPermissions() {
                const iframe = this.$refs.contentFrame;

                // 获取 iframe 内容
                fetch(this.currentUrl)
                    .then(response => response.text())
                    .then(htmlContent => {
                        // 创建一个临时 DOM 元素来解析 HTML
                        const tempDiv = document.createElement('div');
                        tempDiv.innerHTML = htmlContent;

                        // 根据页面类型应用不同的权限处理
                        if (this.currentUrl.includes('dashboard.jsp')) {
                            this.handleDashboardPermissions(tempDiv);
                        } else {
                            this.removeUnauthorizedElements(tempDiv);
                        }

                        // 获取 iframe 文档
                        const doc = iframe.contentDocument || iframe.contentWindow.document;
                        doc.open();

                        // 写入必要的 CSS 以确保样式应用正确
                        doc.write(`
<style>
    /* 重置 body 的 margin 和 padding */
    body {
        margin: 0;
        padding: 0;
        font-family: Helvetica Neue, Helvetica, PingFang SC, Hiragino Sans GB, Microsoft YaHei, Arial, sans-serif;
        font-size: 14px;
        font-weight: normal;
        -webkit-font-smoothing: antialiased;
    }
    /* 确保所有 Element UI 组件使用默认字体大小和粗细 */
    .el-table {
        font-size: 14px;
        color: #606266;
    }
    .el-table th {
        background-color: #f5f7fa;
        color: #909399;
        font-weight: 500;
        font-size: 14px;
    }
    .el-table td {
        padding: 12px 0;
        color: #606266;
        font-size: 14px;
        font-weight: normal;
    }
    .el-table .el-table__row:hover {
        background-color: #f5f7fa;
    }
    /* 重置所有文本元素的字体粗细 */
    p, span, div, td, th, li, a {
        font-weight: normal;
    }
    /* 仅为标题设置粗体 */
    h1, h2, h3, h4, h5, h6 {
        font-weight: 500;
    }
    /* 对于 dashboard 中被隐藏的元素 */
    [data-role].hidden {
        display: none !important;
        visibility: hidden !important;
        width: 0 !important;
        height: 0 !important;
        overflow: hidden !important;
        margin: 0 !important;
        padding: 0 !important;
        border: 0 !important;
    }
</style>
            `);
                        doc.write(`
<script>
    var userInfo = ${JSON.stringify(this.userInfo).replace(/</g, '\\u003c')};
<\/script>
            `);
                        doc.write(tempDiv.innerHTML);
                        doc.close();
                    })
                    .catch(error => {
                        console.error('加载 iframe 内容时出错:', error);
                    });
            },

            handleDashboardPermissions(element) {
                const elements = element.querySelectorAll('[data-role]');
                elements.forEach(el => {
                    const requiredRoles = el.getAttribute('data-role').split(',');
                    if (!requiredRoles.includes(this.userInfo.role)) {
                        el.classList.add('hidden');
                    }
                });
            },

            removeUnauthorizedElements(element) {
                if (!element) return;

                const childNodes = Array.from(element.childNodes);

                for (let i = childNodes.length - 1; i >= 0; i--) {
                    const node = childNodes[i];

                    if (node.nodeType === Node.ELEMENT_NODE) {
                        if (node.hasAttribute('data-role')) {
                            const requiredRoles = node.getAttribute('data-role').split(',');
                            if (!requiredRoles.includes(this.userInfo.role)) {
                                console.log(`Removing element:`, node);
                                node.remove();
                            }
                        } else {
                            this.removeUnauthorizedElements(node);
                        }
                    } else if (node.nodeType === Node.TEXT_NODE) {
                        if (!node.textContent.trim()) {
                            node.remove();
                        }
                    }
                }
            }

        },
        created() {  this.loadTheme();
            const storedUserInfo = localStorage.getItem('userInfo');
            if (storedUserInfo) {
                try {
                    this.userInfo = JSON.parse(storedUserInfo);
                    console.log("User logged in:", this.userInfo);
                    this.loadContent(this.menuItems[0]);
                } catch (error) {
                    console.error("Error parsing user info:", error);
                    window.location.href = "login.jsp";
                }
            } else {
                console.log("No user info, redirecting to login page");
                window.location.href = "login.jsp";
            }
        }
    })
</script>
</body>
</html>
