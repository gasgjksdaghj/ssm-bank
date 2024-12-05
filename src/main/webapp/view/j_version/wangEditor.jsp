<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="true" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>富文本编辑器</title>
    <script src="vue2_resource/vue@2.6.14.js"></script>
    <link rel="stylesheet" href="vue2_resource/index.css">
    <script src="vue2_resource/elementui.js"></script>
    <script src="vue2_resource/wangEditor.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f0f2f5;
        }
        #app {
            max-width: 1000px;
            margin: 0 auto;
        }
        #editor {
            width: 100%;
            height: 400px;
            margin-bottom: 20px;
        }
        .control-panel {
            margin-top: 20px;
            margin-bottom: 20px;
        }
        .output-console {
            margin-top: 20px;
            width: 100%;
            height: 200px;
            border: 1px solid #ccc;
            padding: 10px;
            overflow-y: auto;
            background-color: #fff;
        }
    </style>
</head>
<body>
<div id="app" v-cloak>
    <h1 >富文本编辑器</h1>
    <div id="editor"></div>
  <br>
  <br>
  <br>
  <br>
  <br>
  <br>
    <div class="control-panel">
        <el-button type="primary" @click="getEditorContent">输出到控制台</el-button>
        <el-button type="success" @click="setEditorContent">回显内容</el-button>
    </div>
    <div v-if="consoleOutput" class="output-console">
        <h3>输出控制台：</h3>
        <pre>{{ consoleOutput }}</pre>
    </div>
</div>

<script>
    // 确保在 DOM 完全加载后初始化 Vue
    document.addEventListener('DOMContentLoaded', function() {
        new Vue({
            el: '#app',
            data: {
                editor: null,
                consoleOutput: ''
            },
            mounted() {
                this.$nextTick(() => {
                    this.initEditor();
                });
            },
            methods: {
                initEditor() {
                    const editor = new wangEditor('#editor');
                    editor.config.height = 400;
                    editor.create();
                    this.editor = editor;
                },
                getEditorContent() {
                    const content = this.editor.txt.jsp();
                    this.consoleOutput = content;
                    console.log(content);
                },
                setEditorContent() {
                    const content = '<h2>这是回显的内容</h2><p>您可以在这里编辑文本。</p>';
                    this.editor.txt.jsp(content);
                    this.consoleOutput = '内容已成功回显到编辑器中。';
                }
            }
        });
    });
</script>
</body>
</html>