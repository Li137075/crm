<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
    <base href="<%=basePath%>">
    <!--  It is a good idea to bundle all CSS in one file. The same with JS -->

    <!--  JQUERY -->
    <script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>

    <!--  BOOTSTRAP -->
    <link rel="stylesheet" type="text/css" href="jquery/bootstrap_3.3.0/css/bootstrap.min.css">
    <script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

    <!--  PAGINATION plugin -->
    <link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
    <script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
    <script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>
    <title>演示bs_pagination插件的使用</title>
    <script type="text/javascript">
        $(function() {
            $("#demo_pag1").bs_pagination({
                //当前页号，相当于以前的pageNO
                currentPage:1,
                //每页显示条数
                rowsPerPage:10,
                //总条数
                totalRows:1000,
                //总页数，必填参数
                totalPages: 100,
                //最多可以显示的卡片数
                visiblePageLinks:5,
                //是否显示“跳转到”部分，默认true--显示
                showGoToPage: true,
                //是否显示“每页显示条数”部分，默认true--显示
                showRowsPerPage: true,
                //是否显示记录的信息，默认true--显示
                showRowsInfo: true,
                //用户每次切换页号，都会触发本函数
                //该函数每次返回切换页号后的pageNO和pageSize
                onChangePage: function(event,pageObj) {
                    alert(pageObj.currentPage);
                    alert(pageObj.rowsPerPage);
                },
            });
        });
    </script>
</head>
<body>
<!--  Just create a div and give it an ID -->
<div id="demo_pag1"></div>
</body>
</html>
