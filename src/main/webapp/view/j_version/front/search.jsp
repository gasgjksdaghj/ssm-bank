<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <title>搜索结果</title>
    <script src="../vue2_resource/vue@2.6.14.js"></script>
    <link rel="stylesheet" href="../vue2_resource/index.css">
    <script src="../vue2_resource/elementui.js"></script>
</head>
<body>
<div id="searchApp">
    <div id="queryResult">
        <p>您搜索的关键词是：{{ query }}</p>
    </div>
</div>

<script>
    new Vue({
        el: '#searchApp',
        data: {
            query: '',
        },
        methods: {
            performSearch(searchQuery) {
                this.query = searchQuery;
            }
        },
        mounted() {
            // 监听自定义搜索事件
            window.addEventListener('search', (event) => {
                this.performSearch(event.detail);
            });
        },
        beforeDestroy() {
            // 清理事件监听器
            window.removeEventListener('search', this.performSearch);
        }
    });
</script>
</body>
</html>