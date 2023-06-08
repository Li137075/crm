<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
	String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript">
	$(function (){
	//给整个浏览器窗口添加键盘按下事件
		$(window).keydown(function (e){
			if(e.keyCode==1){
				$("#loginbth").click();
			}
		});
	//给登录按钮添加单击事件
		$("#loginbth").click(function (){
		//收集参数
			var loginAct=$.trim($("#loginAct").val());
			var loginPwd=$.trim($("#loginPwd").val());
			var isRemPwd=$("#isRemPwd").prop("checked");
		//表单数据验证
			if(loginAct==""){
				alert("用户名不能为空");
				return;
			}
			if(loginPwd==""){
				alert("密码不能为空");
				return;
			}
		//显示正在验证
			$("#msg").text("正在努力验证....");
		//发送请求
			$.ajax({
				url:"settings/qx/user/login.do",
				data:{
					loginAct:loginAct,
					loginPwd:loginPwd,
					isRemPwd:isRemPwd
				},
				type:'post',
				dataType:'json',
				success:function (data){
					if(data.code=="1"){
					//跳转到业务的主页面
					//直接跳转页面跳转不过去（因为想要访问的页面资源在WEB-INF目录下），需要先访问controller，然后再跳转页面
						window.location.href="workbench/index.do";
					}else{
						$("#msg").html(data.message);
					}
				},
			//	当aiax向后台发送请求之前，会自动执行本函数
			//若该函数返回True会真正向后台发请求，返回false，不向后台发请求
			// 	beforeSend:function (){
			//		$("msg").text("正在努力验证....");
			// 		return True
			// 	}

			});
		});
	});
</script>
</head>
<body>
	<div style="position: absolute; top: 0px; left: 0px; width: 60%;">
		<img src="image/IMG_7114.JPG" style="width: 100%; height: 90%; position: relative; top: 50px;">
	</div>
	<div id="top" style="height: 50px; background-color: #3C3C3C; width: 100%;">
		<div style="position: absolute; top: 5px; left: 0px; font-size: 30px; font-weight: 400; color: white; font-family: 'times new roman'">清华大学 &nbsp;<span style="font-size: 12px;">&copy;&nbsp;基于VR的帕金森健康检测与康复系统</span></div>
	</div>
	
	<div style="position: absolute; top: 120px; right: 100px;width:450px;height:400px;border:1px solid #D5D5D5">
		<div style="position: absolute; top: 0px; right: 60px;">
			<div class="page-header">
				<h1>登录</h1>
			</div>
			<form action="workbench/index.html" class="form-horizontal" role="form">
				<div class="form-group form-group-lg">
					<div style="width: 350px;">
						<input class="form-control" id="loginAct" type="text" value="${cookie.loginAct.value}" placeholder="用户名">
					</div>
					<div style="">
						<input class="form-control" id="loginPwd" type="password" value="${cookie.loginPwd.value}" placeholder="密码">
					</div>
					<div class="checkbox"  style="position: relative;top: 30px; left: 10px;">
						<label>
							<c:if test="${not empty cookie.loginAct and not empty cookie.loginPwd}">
								<input id="isRemPwd" type="checkbox" checked>
							</c:if>
							<c:if test="${empty cookie.loginAct or empty cookie.loginPwd}">
								<input id="isRemPwd" type="checkbox">
							</c:if>
							十天内免登录
						</label>
						&nbsp;&nbsp;
						<span id="msg"></span>
					</div>
<%--submit是一个同步请求 点击之后整个窗口都变了 所以这里的type设置为普通的type="button"--%>
					<button type="button" id="loginbth" class="btn btn-primary btn-lg btn-block"  style="width: 350px; position: relative;top: 45px;">登录</button>
				</div>width: 350px; position: relative;top: 20px;
			</form>
		</div>
	</div>
</body>
</html>