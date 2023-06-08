<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <%--首先引入jquery--%>
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<%--  首先需要引入bootstrap框架  --%>
    <link rel="stylesheet" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
    <%--然后引入框架中的日历的前端代码--%>
    <link rel="stylesheet" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
    <script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
    <title>演示日历插件</title>

    <script type="text/javascript">
        /*$(function ())这个表示的是页面加载完成之后 在页面加载完成之后调用函数对标签进行处理*/
        $(function (){
            $("#myDate").datetimepicker({

                language:'zh-CN',
                //日期的格式
                format:'yyyy-mm-dd',
                //可以选择的最小视图
                minView:'month',
                //初始化显示的日期
                initData:new Date(),
                //设置选择完成日期或者时间后，是否自动关闭日历
                autoclose:true,
            //    设置是否显示今天按钮 默认是false
                todayBtn:true,
            //   设置是否显示清空按钮，默认是false
                clearBtn:true,
            });
        });
    </script>
</head>
<body>
<%-- readonly是只能读不能改，可以提交  disable是只能读不能改，而且不能提交 --%>
<input type="text" id="myDate" readonly>
</body>
</html>
