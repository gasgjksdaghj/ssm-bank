<%--使用Vue.js框架和ECharts库来展示用户角色统计--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>角色统计 </title>
    <script src="vue2_resource/vue@2.6.14.js"></script>
    <link rel="stylesheet" href="vue2_resource/index.css">
    <script src="vue2_resource/elementui.js"></script>
    <script src="vue2_resource/echarts.min.js"></script>
    <script src="vue2_resource/axios.min.js"></script>
    <script src="vue2_resource/axiosWrapper.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            display: flex;
            flex-wrap: wrap;
            justify-content: space-around;
            gap: 20px;
        }
        .chart-container {
            width: 600px;
            height: 400px;
            background-color: #ffffff;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            padding: 10px;
        }
    </style>
</head>
<body>
<div id="app">
    <h1>欢迎来到银行</h1>
    <div data-role="admin" class="container">
        <div class="chart-container" ref="roleChart"></div>
    </div>
</div>

<script>
    new Vue({
        //指定Vue实例挂载到DOM元素#app上
        el: '#app',
        data() {
            return {
                roleStatistics: []
            }
        },
        mounted() {
            this.fetchRoleStatistics();
        },
        //使用Axios发送GET请求到后端接口/dashboard/role-statistics中（由DashboardController提供），获取角色统计数据。
        //成功后，将返回的数据存储在roleStatistics中，并调用renderChart()方法渲染图表。
       //如果请求失败，捕获错误并显示错误消息。
        methods: {
            fetchRoleStatistics() {
                axiosWrapper.get('/dashboard/role-statistics')
                    .then(response => {
                        this.roleStatistics = response.data;
                        this.renderChart();
                    })
                    .catch(error => {
                        console.error('Error fetching role statistics:', error);
                        this.$message.error('获取角色统计数据失败');
                    });
            },
            renderChart() {
                const chartDom = this.$refs.roleChart;
                const myChart = echarts.init(chartDom);
                const option = {
                    title: {
                        text: '用户角色分布',
                        left: 'center'
                    },
                    tooltip: {
                        trigger: 'item'
                    },
                    legend: {
                        orient: 'vertical',
                        left: 'left'
                    },
                    series: [
                        {
                            name: '角色分布',
                            type: 'pie',
                            radius: '50%',
                            data: this.roleStatistics.map(item => ({
                                value: item.count,
                                name: item.role
                            })),
                            emphasis: {
                                itemStyle: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }
                    ]
                };
                myChart.setOption(option);
            }
        }
    });
</script>
</body>
</html>