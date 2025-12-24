const menuItems = [
    {
        id: 'dashboard',
        title: '仪表盘',
        icon: 'el-icon-data-line',
        url: 'dashboard.jsp',
        roles: ['admin', 'user']
    },
    {
        id: 'user',
        title: '用户管理',
        icon: 'el-icon-user',
        roles: ['admin'],
        submenu: [
            {
                id: 'userList',
                title: '用户列表',
                url: 'userList.jsp',
                roles: ['admin', 'manager','cnm']
            },
            {
                id: 'roleManagement',
                title: '角色管理',
                url: 'roleManagement.jsp',
                roles: ['admin']
            }
        ]
    },
    {
        "id": "transaction-management",
        "title": "交易记录管理",
        "icon": "el-icon-document",
        "url": "transaction-management.jsp",
        "roles": ["admin", "user"]
    },
    {
        "id": "loanRecord",
        "title": "贷款记录管理",
        "icon": "el-icon-document",
        "url": "loanRecord.jsp",
        "roles": ["admin", "user"]
    }
];

// 导出 menuItems
export default menuItems;