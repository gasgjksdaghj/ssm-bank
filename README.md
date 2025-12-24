# SSM银行管理系统

基于SSM框架（Spring + SpringMVC + MyBatis）的银行管理系统，实现了用户管理、角色管理、贷款记录、交易管理等核心功能。

## 项目简介

这是一个企业级的银行管理系统，采用经典的SSM框架开发，前端使用Vue2 + Element UI，后端使用Spring + SpringMVC + MyBatis，实现了完整的银行业务管理功能。

## 技术栈

### 后端技术
- **Spring 5.2.12** - IoC容器和依赖注入
- **SpringMVC 5.2.12** - MVC框架
- **MyBatis 3.5.2** - 持久层框架
- **MySQL 8.0.27** - 数据库
- **Druid 1.2.1** - 数据库连接池
- **JWT (JJWT 0.9.1)** - 身份认证
- **AspectJ 1.9.7** - AOP切面编程
- **PageHelper 1.3.1** - MyBatis分页插件
- **Hutool 5.8.18** - Java工具类库
- **Apache POI 5.2.3** - Excel文件处理
- **Lombok 1.18.30** - 简化Java代码

### 前端技术
- **Vue 2.6.14** - 前端框架
- **Element UI** - UI组件库
- **Axios** - HTTP客户端
- **ECharts** - 数据可视化
- **Vue Router** - 路由管理

## 主要功能

### 1. 用户管理
- 用户注册与登录
- 用户信息管理
- 用户列表查询
- 密码修改

### 2. 角色管理
- 角色创建与编辑
- 权限分配
- 角色列表管理

### 3. 贷款管理
- 贷款申请
- 贷款记录查询
- 贷款审批

### 4. 交易管理
- 交易记录查询
- 交易统计分析
- 交易数据导出

### 5. 数据可视化
- Dashboard仪表盘
- 数据统计图表
- 业务数据分析

### 6. 系统功能
- 文件上传下载
- 日志记录（AOP）
- 数据分页
- Excel导入导出

## 项目结构

```
ssm-bank/
├── src/
│   ├── main/
│   │   ├── java/
│   │   │   └── com/coco/
│   │   │       ├── aop/              # AOP切面
│   │   │       ├── controller/       # 控制器层
│   │   │       ├── mapper/           # MyBatis映射接口
│   │   │       ├── pojo/             # 实体类
│   │   │       ├── service/          # 服务层
│   │   │       ├── utils/            # 工具类
│   │   │       └── wrapper/          # 包装类
│   │   ├── resources/
│   │   │   ├── mapper/               # MyBatis XML映射文件
│   │   │   └── ssm/                  # Spring配置文件
│   │   └── webapp/
│   │       ├── files/                # 上传文件目录
│   │       └── view/
│   │           └── mainpage/         # 前端页面
│   └── test/                         # 测试代码
├── pom.xml                           # Maven配置文件
└── README.md                         # 项目说明文档
```

## 环境要求

- JDK 1.8+
- Maven 3.6+
- MySQL 8.0+
- Tomcat 8.5+ 或其他Servlet容器

## 快速开始

### 1. 克隆项目
```bash
git clone https://github.com/gasgjksdaghj/ssm-bank.git
cd ssm-bank
```

### 2. 配置数据库
- 创建数据库
- 导入SQL脚本（如有）
- 修改数据库配置文件中的连接信息

### 3. 修改配置
编辑 `src/main/resources/ssm/spring-mybatis-config.xml`，配置数据库连接信息：
```xml
<property name="url" value="jdbc:mysql://localhost:3306/your_database?useSSL=false&amp;serverTimezone=UTC"/>
<property name="username" value="your_username"/>
<property name="password" value="your_password"/>
```

### 4. 构建项目
```bash
mvn clean install
```

### 5. 部署运行
将生成的 `ssm-bank.war` 文件部署到Tomcat服务器，启动Tomcat即可访问。

默认访问地址：`http://localhost:8080/ssm-bank`

## 核心特性

### 安全认证
- 基于JWT的Token认证机制
- 密码加密存储
- 请求拦截与权限验证

### AOP日志
- 系统操作日志自动记录
- 异常日志捕获
- 性能监控

### 数据处理
- MyBatis分页插件支持
- Excel数据导入导出
- 文件上传下载管理

### 前端交互
- Vue组件化开发
- Element UI美观界面
- ECharts数据可视化
- Axios异步请求

## 开发说明

### 代码规范
- 使用Lombok简化实体类代码
- 统一的异常处理机制
- RESTful API设计风格
- 分层架构设计

### 配置说明
- Spring配置：`spring-mybatis-config.xml`
- SpringMVC配置：`springmvc-config.xml`
- MyBatis映射文件：`src/main/resources/mapper/`

## 许可证

本项目仅供学习交流使用。

## 联系方式

如有问题或建议，欢迎提Issue或Pull Request。
