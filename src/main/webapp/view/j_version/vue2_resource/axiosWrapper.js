(function (window) {
    const BASE_URL = 'http://localhost:8080'; // 替换为你的 API 基础 URL
    const LOGIN_PAGE = '/view/j_version/login.jsp'; // 替换为你的登录页面 URL

    const axiosInstance = axios.create({
        baseURL: BASE_URL,
        timeout: 10000, // 请求超时时间
        headers: {
            'Content-Type': 'application/json;charset=UTF-8'
        }
    });

    // 请求拦截器
    axiosInstance.interceptors.request.use(
        (config) => {
            const userInfo = JSON.parse(localStorage.getItem('userInfo') || '{}');
            if (userInfo.token) {
                config.headers['Authorization'] = 'Bearer ' + userInfo.token;
            }
            return config;
        }
    );

    // 响应拦截器
    axiosInstance.interceptors.response.use(
        (response) => {
            // 检查响应体中的 code
            if (response.data && response.data.code === 401) {
                console.log('未授权，处理中...');
                handleUnauthorized();
                return response.data;
            }
            return response.data;
        },
    );

    function handleUnauthorized() {
        // 清除本地存储的用户信息
        localStorage.removeItem('userInfo');

        // 检查当前页面是否已经是登录页面
        if (!isLoginPage()) {
            // 如果不是登录页面，则跳转到登录页面
            setTimeout(() => {
                window.parent.location.href = LOGIN_PAGE;
            }, 1500);
        }
    }

    function isLoginPage() {
        return window.location.pathname.endsWith(LOGIN_PAGE);
    }

    // 将封装后的 axios 实例暴露到全局
    window.axiosWrapper = axiosInstance;

})(window);