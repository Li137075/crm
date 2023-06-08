<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath=request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+request.getContextPath()+"/";
%>
<html>
<head>
	<base href="<%=basePath%>">
<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination-master/css/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination-master/js/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination-master/localization/en.js"></script>

<script type="text/javascript">

	$(function(){
		$("#createActivityBtn").click(function (){
			//	清空表单数据
			$("#createActivityForm").get(0).reset();
		//弹出创建市场活动的模态窗口
			$("#createActivityModal").modal("show");

		});

	//	给保存按钮添加单击事件
		$("#saveCreateActivityBtn").click(function (){
		//	收集参数
			var owner=$("#create-marketActivityOwner").val();
			var nianling=$("#create-marketActivityName").val();
			var liuyanqingkuang=$("#create-cost").val();
			var tunyanqingkuang=$("#0").val();
			var zhilisunhai=$("#1").val();
			var siweizhangai=$("#2").val();
			var yiyuchengdu=$("#3").val();
			var yanyubiaodaqingkuang=$("#4").val();
			var mianbubiaodaqingkuang=$("#5").val();
		//	表单验证
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(nianling==""){
				alert("名称不能为空");
				return;
			}

		//	发送请求
			$.ajax({
				url:"workbench/activity/saveCreateActivity.do",
				data:{
					name:owner,
					age:nianling,
					liuyanqingkuang:liuyanqingkuang,
					tunyanqingkuang:tunyanqingkuang,
					zhilisunhai:zhilisunhai,
					siweizhangai:siweizhangai,
					yiyuchengdu:yiyuchengdu,
					yanyubiaodaqingkuang:yanyubiaodaqingkuang,
					mianbubiaoqingqingkuang:mianbubiaodaqingkuang
				},
				type:'post',
				dataType:'json',
				success:function (){
					if(data.code==1){
					//	关闭模态窗口
						$("#createActivityModal").modal("hide");
					//	刷新市场页面
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));

					}else{
						alert(data.message);
					//	模态窗口不关闭
						$("#createActivityModal").modal("show");
					}
				}
			});
		});
		// 当容器加载完成之后，对容器调用工具函数
		$(".mydate").datetimepicker({
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
			clearBtn:true
		});
		queryActivityByConditionForPage(1,10);
	//	给查询按钮添加单击事件
		$("#queryActivityBtn").click(function(){
		//	查询符合条件数据的第一页以及所有符合条件数据的总条数
			queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption','rowsPerPage'));
		});
	//	给全选按钮添加单击事件
		$("#checkAll").click(function(){
			if(this.checked==true){
				//这里的‘ ’是父子选择器，而且是父标签下的所有子选择器都可以选择
				$("#tbody input[type='checkbox']").prop("checked",true);
			}else{
				$("#tbody input[type='checkbox']").prop("checked",false);
			}
		});
		// $("#tbody input[type='checkbox']").click(function(){
		// 	if($("#tbody input[type='checkbox']").size()==$("#tbody input[type='checkbox']:checked").size()){
		// 		$("#checkAll").prop("checked",true);
		// 	}else{
		// 		$("#checkAll").prop("checked",false);
		// 	}
		// });
		//注意，这里是用了jQuery的on函数，因为这个元素不是固有元素，所以这里只能用jQuery的on函数
		$("#tbody").on("click","input[type='checkbox']",function (){
			if($("#tbody input[type='checkbox']").size()==$("#tbody input[type='checkbox']:checked").size()){
				$("#checkAll").prop("checked",true);
			}else{
				$("#checkAll").prop("checked",false);
			}
		});
	//	给“删除”按钮添加单机事件
		$("#deleteActivitybtn").click(function(){
			//这里是jquery对象
			var checkedIds=$("#tbody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要删除的市场活动");
				return;
			}
			if(window.confirm("确定删除嘛？")) {
				var ids = "";
				//这里通过循环，取出了jquery对象中的DOM对象
				$.each(checkedIds, function () {
					ids += "id=" + this.value + "&";
				});
				ids = ids.substr(0, ids.length - 1);
				$.ajax({
					url: 'workbench/activity/deleteActivityIds.do',
					//以前的时候data{xx：xx}这是用来拼接json字符串的，现在已经拼接好了，就不用{}了
					data: ids,
					type: 'post',
					dataType: 'json',
					success: function (data) {
						if (data.code == '1') {
							queryActivityByConditionForPage(1, $("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
						} else {
							alert(data.message);
						}
					}
				});
			}
		});

		$("#editActivityBtn").click(function () {
		//收集参数
		//获取列表中被选中的checkbox
			var checkedIds=$("#tbody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要修改的市场活动");
				return;
			}
			if(checkedIds.size()>1){
				alert("每次只能修改一次市场活动");
				return;
			}
			//这里是把jQuery对象转化为dom对象，然后用value()获取属性值
			var id=checkedIds[0].value;

			$.ajax({
				url:'workbench/activity/queryActivityById.do',
				data:{
					id:id,
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					//将后台查询到的数据显示到模态窗口里
					//将id值填入模态窗口的隐藏域中
					$("#edit-id").val(data.id);
					//下拉列表中的某一个选项，根据后端传来的id值，默认选中
					$("#create-marketActivityOwner").val(data.owner);
					$("#edit-marketActivityName").val(data.name);
					$("#edit-startTime").val(data.startDate);
					$("#edit-endTime").val(data.endDate);
					$("#edit-cost").val(data.cost);
					$("#edit-describe").val(data.description);
				//	弹出模态窗口
					$("#editActivityModal").modal("show");
				}
			});
		});
	//给修改市场活动的模态窗口中的更新按钮添加单击事件
		$("#saveEditActivityBtn").click(function (){
			var id=$("#edit-id").val();
			//下拉列表中的某一个选项，根据后端传来的id值，默认选中
			var owner=$("#create-marketActivityOwner").val();
			var name=$.trim($("#edit-marketActivityName").val());
			var startDate=$("#edit-startTime").val();
			var endDate=$("#edit-endTime").val();
			var cost=$.trim($("#edit-cost").val());
			var description=$.trim($("#edit-describe").val());
			//表单验证
			if(owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==""){
				alert("名称不能为空");
				return;
			}
			if(startDate!=""&&endDate!=""){
				//	使用字符串的大小代替日期的大小
				if(endDate<startDate){
					alert("结束日期不能比开始日期小");
					return;
				}
			}
			var regExp=/^(([1-9]\d*)|0)$/;
			if(!regExp.test(cost)){
				alert("成本只能是非负整数")
				return;
			}
			$.ajax({
				url:'workbench/activity/saveEditActivity.do',
				data:{
					id:id,
					owner:owner,
					name:name,
					startDate:startDate,
					endDate:endDate,
					cost:cost,
					description:description,
				},
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=='1'){
					//	关闭模态窗口
						$("#editActivityModal").modal("hide");
						queryActivityByConditionForPage($("#demo_pag1").bs_pagination('getOption', 'currentPage'),$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						alert(data.message);
						$("#editActivityModal").modal("show");
					}
				}
			});
		});
	//	给批量导出按钮添加一个单击事件，这个是一个同步请求
		$("#exportActivityAllBtn").click(function () {
			window.location.href="workbench/activity/exportAllActivitys.do";
		});
	//给选择导出按钮添加一个单击事件，这是一个同步请求
		$("#exportActivityXzBtn").click(function (){
			var checkedIds=$("#tbody input[type='checkbox']:checked");
			if(checkedIds.size()==0){
				alert("请选择要导出的市场活动");
				return;
			}
			var ids = "";
			//这里通过循环，取出了jquery对象中的DOM对象
			$.each(checkedIds, function () {
				ids += "id=" + this.value + "&";
			});
			ids = ids.substr(0, ids.length - 1);
			alert(ids);
			$.ajax({
				url:"workbench/activity/querySomeActivitys.do",
				data:ids,
				type:"POST",
				dataType:"JSON",
				async:false,
				success:function(){
					console.log(2);
				}
			});
		});



	//给导入按钮添加单机事件，实现为你文件的上传
		$("#importActivityBtn").click(function () {
			alert("123456")
			var activityFileName=$("#activityFile").val();
			var suffix=activityFileName.substr(activityFileName.lastIndexOf(".")+1).toLocaleLowerCase();
			if(suffix!="xls"){
				alert("只支持xls文件");
				return;
			}

		//获取文件
			var activityFile=$("#activityFile")[0].files[0];
			if(activityFile.size>5*1024*1024){
				alert("文件大小不超过5MB");
				return;
			}

		//	FormData是ajax提供的接口，可以模拟键值对向后台提交参数
		//	FormData不但能提交文本数据，还能提交二进制数据
			var formData =new FormData();
			formData.append("activityFile",activityFile);
			formData.append("userName","张三");
			$.ajax({
				url:'workbench/activity/importActivity.do',
				data:formData,
				//设置ajax向后台提交参数之前，是否把参数转换为字符串，默认是TRUE
				processData:false,
				//设置ajax向后台提案参数之前是否把所有的参数同意按照urlencoded编码，默认是true
				contentType:false,
				type:'post',
				dataType:'json',
				success:function (data) {
					if(data.code=='1'){
						alert("成功导入"+data.retData+"条记录");
						$("#importActivityModal").modal("hide");
						queryActivityByConditionForPage(1,$("#demo_pag1").bs_pagination('getOption', 'rowsPerPage'));
					}else{
						//提示信息
						alert(data.message);
						//模态窗口不关闭
						$("#importActivityModal").modal("show");
					}
				}
			});
		});
	});



//	封装函数，注意：封装函数要在入口函数的外面
	function queryActivityByConditionForPage(pageNO,pageSize){
		//收集参数
		var name=$("#query-name").val();
		var owner=$("#query-owner").val();
		var startDate=$("#query-startDate").val();
		var endDate=$("#query-endDate").val();
		// var pageNO=1;
		// var pageSize=10;
		$.ajax({
			url:'workbench/activity/queryActivityByConditionForPage.do',
			data:{
				name:name,
				owner:owner,
				startDate:startDate,
				endDate:endDate,
				pageNO:pageNO,
				pageSize:pageSize
			},
			type:'post',
			dataType:'json',
			success:function (data){
				//显示总条数
				// $("#totalRowsB").text(data.totalRows);
				//	遍历activityList，拼接所有行数据
				var htmlStr="";
				$.each(data.activitylist,function (index,obj){
					htmlStr+="<tr class=\"active\">";
					htmlStr+="<td><input type=\"checkbox\" value=\""+obj.id+"\"/></td>";
					htmlStr+="<td><a style=\"text-decoration: none; cursor: pointer;\" onclick=\"window.location.href='workbench/activity/detailActivity.do?id="+obj.id+"'\">"+obj.name+"</a></td>";
					htmlStr+="<td>"+obj.owner+"</td>";
					htmlStr+="<td>"+obj.startDate+"</td>";
					htmlStr+="<td>"+obj.endDate+"</td>";
					htmlStr+="</tr>";
				});
				$("#tbody").html(htmlStr);
			//	拼完列表后，取消全选按钮
				$("#checkAll").prop("checked",false);
			//	计算总页数
				var totalPages=1;
				if(data.totalRows%pageSize==0){
					totalPages=data.totalRows/pageSize;
				}else{
					totalPages=parseInt(data.totalRows/pageSize)+1;
				}
			//	调用bs_pagination工具函数，显示翻页信息
				$("#demo_pag1").bs_pagination({
					//当前页号，相当于以前的pageNO
					currentPage:pageNO,
					//每页显示条数
					rowsPerPage:pageSize,
					//总条数
					totalRows:data.totalRows,
					//总页数，必填参数
					totalPages: totalPages,
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
						// alert(pageObj.currentPage);
						// alert(pageObj.rowsPerPage);
						queryActivityByConditionForPage(pageObj.currentPage,pageObj.rowsPerPage);
					},
				});
			}
		});
	}
</script>
</head>
<body>

	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">帕金森外在症状信息搜集</h4>
				</div>
				<div class="modal-body">
				
					<form id="createActivityForm" class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="create-marketActivityOwner" class="col-sm-2 control-label">姓名</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-marketActivityOwner">
							</div>
                            <label for="create-marketActivityName" class="col-sm-2 control-label">年龄</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-marketActivityName">
                            </div>
						</div>

                        <div class="form-group">
                            <label for="create-cost" class="col-sm-2 control-label">流涎情况</label>
                            <div class="col-sm-10" style="width: 50%;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">吞咽情况</label>
							<div class="col-sm-10" style="width: 50%;">
								<textarea class="form-control" rows="3" id="0"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">智力损害</label>
							<div class="col-sm-10" style="width: 50%;">
								<textarea class="form-control" rows="3" id="1"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">思维障碍</label>
							<div class="col-sm-10" style="width: 50%;">
								<textarea class="form-control" rows="3" id="2"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">抑郁程度</label>
							<div class="col-sm-10" style="width: 50%;">
								<textarea class="form-control" rows="3" id="3"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">言语表达情况</label>
							<div class="col-sm-10" style="width: 50%;">
								<textarea class="form-control" rows="3" id="4"></textarea>
							</div>
						</div>
						<div class="form-group">
							<label for="create-describe" class="col-sm-2 control-label">面部表情情况</label>
							<div class="col-sm-10" style="width: 50%;">
								<textarea class="form-control" rows="3" id="5"></textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="saveCreateActivityBtn">提交到后台处理</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">
				
					<form class="form-horizontal" role="form">
<%--						下面是设置一个市场活动的模态窗口，用来显示市场活动的id 用户看不到--%>
						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-marketActivityOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-marketActivityOwner">
									<c:forEach items="${userList}" var="u">
										<option value="${u.id}">${u.name}</option>
									</c:forEach>
								</select>
							</div>
                            <label for="edit-marketActivityName" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-marketActivityName" value="发传单">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startTime" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-startTime" value="2020-10-10">
							</div>
							<label for="edit-endTime" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-endTime" value="2020-10-20">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost" value="5,000">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-describe">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>
						
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveEditActivityBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 导入市场活动的模态窗口 -->
    <div class="modal fade" id="importActivityModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">导入市场活动</h4>
                </div>
                <div class="modal-body" style="height: 350px;">
                    <div style="position: relative;top: 20px; left: 50px;">
                        请选择要上传的文件：<small style="color: gray;">[仅支持.xls]</small>
                    </div>
                    <div style="position: relative;top: 40px; left: 50px;">
                        <input type="file" id="activityFile">
                    </div>
                    <div style="position: relative; width: 400px; height: 320px; left: 45% ; top: -40px;" >
                        <h3>重要提示</h3>
                        <ul>
                            <li>操作仅针对Excel，仅支持后缀名为XLS的文件。</li>
                            <li>给定文件的第一行将视为字段名。</li>
                            <li>请确认您的文件大小不超过5MB。</li>
                            <li>日期值以文本形式保存，必须符合yyyy-MM-dd格式。</li>
                            <li>日期时间以文本形式保存，必须符合yyyy-MM-dd HH:mm:ss的格式。</li>
                            <li>默认情况下，字符编码是UTF-8 (统一码)，请确保您导入的文件使用的是正确的字符编码方式。</li>
                            <li>建议您在导入真实数据之前用测试文件测试文件导入功能。</li>
                        </ul>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="importActivityBtn" type="button" class="btn btn-primary">导入</button>
                </div>
            </div>
        </div>
    </div>
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="query-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="query-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="query-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="query-endDate">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryActivityBtn">查询</button>
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="createActivityBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editActivityBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteActivitybtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				<div class="btn-group" style="position: relative; top: 18%;">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#importActivityModal" ><span class="glyphicon glyphicon-import"></span> 上传列表数据（导入）</button>
                    <button id="exportActivityAllBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（批量导出）</button>
                    <button id="exportActivityXzBtn" type="button" class="btn btn-default"><span class="glyphicon glyphicon-export"></span> 下载列表数据（选择导出）</button>
                </div>
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="checkAll" /></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="tbody">
<%--						<tr class="active">--%>
<%--							<td><input type="checkbox" /></td>--%>
<%--							<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--							<td>2020-10-10</td>--%>
<%--							<td>2020-10-20</td>--%>
<%--						</tr>--%>
<%--                        <tr class="active">--%>
<%--                            <td><input type="checkbox" /></td>--%>
<%--                            <td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href='detail.jsp';">发传单</a></td>--%>
<%--                            <td>zhangsan</td>--%>
<%--                            <td>2020-10-10</td>--%>
<%--                            <td>2020-10-20</td>--%>
<%--                        </tr>--%>
					</tbody>
				</table>
				<div id="demo_pag1"></div>
			</div>
			
<%--			<div style="height: 50px; position: relative;top: 30px;">--%>
<%--				<div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">共<b id="totalRowsB">50</b>条记录</button>--%>
<%--				</div>--%>
<%--				<div class="btn-group" style="position: relative;top: -34px; left: 110px;">--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">显示</button>--%>
<%--					<div class="btn-group">--%>
<%--						<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown">--%>
<%--							10--%>
<%--							<span class="caret"></span>--%>
<%--						</button>--%>
<%--						<ul class="dropdown-menu" role="menu">--%>
<%--							<li><a href="#">20</a></li>--%>
<%--							<li><a href="#">30</a></li>--%>
<%--						</ul>--%>
<%--					</div>--%>
<%--					<button type="button" class="btn btn-default" style="cursor: default;">条/页</button>--%>
<%--				</div>--%>
<%--				<div style="position: relative;top: -88px; left: 285px;">--%>
<%--					<nav>--%>
<%--						<ul class="pagination">--%>
<%--							<li class="disabled"><a href="#">首页</a></li>--%>
<%--							<li class="disabled"><a href="#">上一页</a></li>--%>
<%--							<li class="active"><a href="#">1</a></li>--%>
<%--							<li><a href="#">2</a></li>--%>
<%--							<li><a href="#">3</a></li>--%>
<%--							<li><a href="#">4</a></li>--%>
<%--							<li><a href="#">5</a></li>--%>
<%--							<li><a href="#">下一页</a></li>--%>
<%--							<li class="disabled"><a href="#">末页</a></li>--%>
<%--						</ul>--%>
<%--					</nav>--%>
<%--				</div>--%>

<%--			</div>--%>
			
		</div>
		
	</div>
</body>
</html>