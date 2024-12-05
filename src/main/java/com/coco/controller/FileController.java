package com.coco.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.UUID;

@Controller
@RequestMapping("/file")
public class FileController {

    @Autowired
    private org.springframework.core.env.Environment env;

    /**
     * 文件上传接口
     *
     * @param file 前端传递过来的文件
     * @param request HTTP请求对象
     * @return 文件访问URL
     * @throws IOException
     */
    @PostMapping("/upload")
    @ResponseBody
    public String upload(@RequestParam MultipartFile file, HttpServletRequest request) throws IOException {
        if (file.isEmpty()) {
            return "文件为空";
        }

        String originalFilename = file.getOriginalFilename();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String fileUUID = UUID.randomUUID().toString().replace("-", "");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
        String datePath = sdf.format(new Date());
        String finalFileName = fileUUID + fileExtension;

        // 获取上传根路径
        String uploadRootPath = getUploadPath(request);

        // 创建日期子目录
        String finalUploadPath = uploadRootPath + File.separator + datePath;
        File uploadDir = new File(finalUploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdirs();
        }

        // 完整的文件保存路径
        File destFile = new File(uploadDir, finalFileName);

        // 保存文件
        file.transferTo(destFile);

        // 构建文件访问URL
        String scheme = request.getScheme();
        String serverName = request.getServerName();
        int serverPort = request.getServerPort();
        String contextPath = request.getContextPath();

        StringBuilder urlBuilder = new StringBuilder();
        urlBuilder.append(scheme).append("://").append(serverName);

        if (("http".equals(scheme) && serverPort != 80) ||
                ("https".equals(scheme) && serverPort != 443)) {
            urlBuilder.append(":").append(serverPort);
        }

        urlBuilder.append(contextPath)
                .append("/files/")
                .append(datePath)
                .append("/")
                .append(finalFileName);

        return urlBuilder.toString();
    }

    /**
     * 获取上传路径，区分开发环境和生产环境
     */
    private String getUploadPath(HttpServletRequest request) {
        // 判断是否是开发环境
        String classPath = this.getClass().getClassLoader().getResource("").getPath();
//        只有idea中有target  ，直接部署到tomcat是没有target的
        boolean isDev = classPath.contains("target");

        if (isDev) {
            // 开发环境，使用项目根路径
            String projectRoot = classPath.substring(1, classPath.indexOf("/target"));
            return projectRoot + "/src/main/webapp/files";
        } else {
            // 生产环境，使用webapp实际路径
            return request.getServletContext().getRealPath("/files");
        }
    }
}