<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Вход</title>
	<link rel="stylesheet" type="text/css"
		  href="${pageContext.request.contextPath}/css/bootstrap.min.css">
	<link rel="stylesheet" type="text/css"
		  href="${pageContext.request.contextPath}/css/model/login/login.css">
</head>
<body>

<div class="container">
	<div class="row">
		<div class="col-md-4 col-sm-3"></div>


		<div class="col-md-4 col-sm-6">
			<div class="panel panel-default">


				<div class="panel-title" style="text-align: center">
					<h2>Войти</h2>
				</div>


				<div class="panel-body">


					<form id="login_form" class="form-horizontal" style="">

						<div class="form-group">
							<label class="control-label col-md-4 col-sm-4">ID пользователя：</label>
							<div class="col-md-7 col-sm-7">
								<input type="text" id="userID" class="form-control"
									   placeholder="ID пользователя" name="userID" />
							</div>
						</div>

						<div class="form-group">
							<label class="control-label col-md-4 col-sm-4"> <!-- <span class="glyphicon glyphicon-lock"></span> -->
								Пароль:
							</label>
							<div class="col-md-7 col-sm-7">
								<input type="password" id="password" class="form-control"
									   placeholder="Пароль" name="password">
							</div>
						</div>

						<div class="form-group">
							<label class="control-label col-md-4 col-sm-4"> <!-- <span class="glyphicon glyphicon-lock"></span> -->
								Код подтверждения:
							</label>
							<div class="col-md-5 col-sm-4">
								<input type="text" id="checkCode" class="form-control"
									   placeholder="Код подтверждения" name="checkCode">
							</div>
							<div>
								<img id="checkCodeImg" alt="checkCodeImg"
									 src="account/checkCode/1">
							</div>
						</div>

						<div>
							<div class="col-md-4 col-sm-4"></div>
							<div class="col-md-4 col-sm-4">
								<button id="submit" type="submit" class="btn btn-primary">
									&nbsp;&nbsp;&nbsp;&nbsp;Вход&nbsp;&nbsp;&nbsp;&nbsp;</button>
							</div>
							<div class="col-md-4 col-sm-4"></div>
						</div>
					</form>
				</div>
			</div>
		</div>

		<div class="col-md-4 col-sm-3"></div>
	</div>
</div>

<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/jquery-2.2.3.min.js"></script>
<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/bootstrapValidator.min.js"></script>
<script type="text/javascript"
		src="${pageContext.request.contextPath}/js/jquery.md5.js"></script>

<script>
	$(function() {
		validatorInit();
		refreshCheckCode();
	});


	function refreshCheckCode() {
		$('#checkCodeImg').click(function() {
			var timestamp = new Date().getTime();
			//AccountHandler
			$(this).attr("src", "account/checkCode/" + timestamp)
		})
	}

	// обновление капчи
	function infoEncrypt(userID, password, checkCode) {
		var str1 = $.md5(password);
		var str2 = $.md5(str1 + userID);
		var str3 = $.md5(str2 + checkCode.toUpperCase());
		return str3;
	}
	//bootstrapValidator инкапсулирует форму, без добавления действия(не нужно добовлять)
	function validatorInit() {
		$('#login_form').bootstrapValidator({
			message : 'This value is not valid',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			fields : {
				userID : {
					validators : {
						notEmpty : {
							message : 'Поле не может быть пустым'
						},regexp: {
							regexp: '[0-9]+',
							message: 'Только цифры'
						},
						callback : {}
					}
				},
				password : {
					validators : {
						notEmpty : {
							message : 'Поле не может быть пустым'
						},
						callback : {}
					}
				},
				checkCode : {
					validators : {
						notEmpty : {
							message : 'Поле не может быть пустым'
						}
					}
				}
			}
		})
				.on('success.form.bv', function(e) {

					e.preventDefault();

					// form
					var $form = $(e.target);
					// bootstrapValidator
					var bv = $form.data('bootstrapValidator');


					var userID = $('#userID').val();
					var password = $('#password').val();
					var checkCode = $('#checkCode').val();


					password = infoEncrypt(userID, password, checkCode)

					var data = {
						"id" : userID,
						"password" : password,
					}
					//JSON.stringify(data)
					$.ajax({
						type:"POST",
						url:"account/login",
						dataType:"json",
						contentType:"application/json",
						data:JSON.stringify(data),
						success:function(response){


							// JSON
							if(response.result == 'error'){
								var errorMessage;
								var field;
								if(response.msg == "unknownAccount"){
									errorMessage = "Пользователь не найден";
									field = "userID";
								}
								else if(response.msg == "incorrectCredentials"){
									errorMessage = "Ошибка пароля";
									field = "password";
									$('#password').val("");
								}else{
									errorMessage = "Ошибка сервера";
									field = "password";
									$('#password').val("");
								}


								bv.updateMessage(field,'callback',errorMessage);
								bv.updateStatus(field,'INVALID','callback');
								bv.updateStatus("checkCode",'INVALID','callback');

								$('#checkCodeImg').attr("src","account/checkCode/" + new Date().getTime());
								$('#checkCode').val("");
							}else{

								window.location.href = "/mainPage";
							}
						},
						error:function(data){
						}
					});
				});
	}
</script>
</body>
</html>