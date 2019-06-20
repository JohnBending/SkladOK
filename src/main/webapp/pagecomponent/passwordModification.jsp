<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<script>
	$(function() {
		bootstrapValidatorInit();
	});

	function bootstrapValidatorInit(){
		$('#form').bootstrapValidator({
			message:'This value is not valid',
			feedbackIcons:{
				valid:'glyphicon glyphicon-ok',
				invalid:'glyphicon glyphicon-remove',
				validating:'glyphicon glyphicon-refresh'
			},
			excluded: [':disabled'],
			fields:{// проверка
				oldPassword:{// Оригинальный пароль
					validators:{
						notEmpty:{
							message:'Не может быть пустым'
						},
						callback:{}
					}
				},
				newPassword:{// Новый пароль
					validators:{
						notEmpty:{
							message:'Не может быть пустым'
						},
						stringLength:{
							min:6,
							max:16,
							message:'Длина пароля составляет 6 ~ 16 цифр'
						},
						callback:{}
					}
				},
				newPassword_re:{//Повторите новый пароль
					validators:{
						notEmpty:{
							message:'Не может быть пустым'
						},
						identical:{
							field:'newPassword',
							message:'Пароли не совпадают'
						}
					}
				}
			}
		})
		.on('success.form.bv',function(e){
			//Отключить отправку формы по умолчанию
			e.preventDefault();
			
			// Получить экземпляр формы
			var $form = $(e.target);
			// Получить экземпляр bootstrapValidator
			var bv = $form.data('bootstrapValidator');

			var userID = $('#userID').html();
			var oldPassword = $('#oldPassword').val();
			var newPassword = $('#newPassword').val();
			var rePassword = $('#newPassword_re').val();

			oldPassword = passwordEncrying(userID, oldPassword);
			newPassword = passwordEncrying(userID, newPassword);
			rePassword = passwordEncrying(userID, rePassword);
			var data = {
					"oldPassword" : oldPassword,
					"newPassword" : newPassword,
					"rePassword" : rePassword
				}

			// Отправить данные
			$.ajax({
				type: "POST",
				url:"account/passwordModify",
				dataType:"json",
				contentType:"application/json",
				data:JSON.stringify(data),
				success:function(response){
					//ответ от сервера
					if(response.result == "error"){
						var errorMessage;
						if(response.errorMsg == "passwordError"){
							errorMessage = "Неверный пароль";
							field = "oldPassword"
						}else if(response.errorMsg == "passwordUnmatched"){
							errorMessage = "Несоответствующий пароль";
							field = "newPassword"
						}

						$("#oldPassword").val("");
						$("#newPassword").val("");
						$("#newPassword_re").val("");
						bv.updateMessage(field,'callback',errorMessage);
						bv.updateStatus(field,'INVALID','callback');
					}else{
						//В противном случае обновление выполнено успешно, появляется модальное окно и форма очищается.
						$('#passwordEditSuccess').modal('show');
						$('#reset').trigger("click");
						$('#form').bootstrapValidator("resetForm",true); 
					}
					
				},
				error:function(response){
					//window.location.href = "./";
					location.reload();
				}
			});
		})
	}

	//Модуль шифрования пароля
	function passwordEncrying(userID,password){
		var str1 = $.md5(password);
		//var str2 = $.md5(str1 + userID);
		return str1;
	}

</script>
<!-- Панель смены пароля -->
<div class="panel panel-default">

	<ol class="breadcrumb">
		<li>Панель смены пароля</li>
	</ol>

	<div class="panel-body">

		<div class="row">
			<div class="col-md-4 col-sm-2"></div>
			<div class="col-md-4 col-sm-8">

				<form action="" class="form-horizontal" style=""
					role="form" id="form">
					<div class="form-group">
						<label for="" class="control-label col-md-4 col-sm-4"> ID пользователя: </label>
						<div class="col-md-8 col-sm-8">
							<span class="hidden" id="userID">${sessionScope.userID }</span>
							<p class="form-control-static">${sessionScope.userID }</p>
						</div>
					</div>

					<div class="form-group">
						<label for="" class="control-label col-md-4 col-sm-4"> старый пароль: </label>
						<div class="col-md-8 col-sm-8">
							<input type="password" class="form-control" id="oldPassword"
								name="oldPassword">
						</div>
					</div>

					<div class="form-group">
						<label for="" class="control-label col-md-4 col-sm-4"> новый пароль: </label>
						<div class="col-md-8 col-sm-8">
							<input type="password" class="form-control" id="newPassword"
								name="newPassword">
						</div>
					</div>

					<div class="form-group">
						<label for="" class="control-label col-md-4 col-sm-4"> Подтвердите новый пароль: </label>
						<div class="col-md-8 col-sm-8 has-feedback">
							<input type="password" class="form-control" id="newPassword_re"
								name="newPassword_re">
						</div>
					</div>

					<div>
						<div class="col-md-4 col-sm-4"></div>
						<div class="col-md-4 col-sm-4">
							<button type="submit" class="btn btn-success">
								&nbsp;&nbsp;&nbsp;&nbsp;Подтвердите изменение&nbsp;&nbsp;&nbsp;&nbsp;</button>
						</div>
						<div class="col-md-4 col-sm-4"></div>
					</div>
					<input id="reset" type="reset" style="display:none">
				</form>

			</div>
			<div class="col-md-4 col-sm-2"></div>
		</div>

		<div class="row">
			<div class="col-md-3 col-sm-1"></div>
			<div class="col-md-6 col-sm-10">
				<div class="alert alert-info" style="margin-top: 50px">
					<p>Описание правила изменения пароля для входа：</p>
					<p>1.Длина пароля должна быть 6 ~ 16 цифр，должна быть цифра、буква、2 спец. символа，разный регистр</p>
					<p>2. Пароль не может совпадать с номером учетной записи</p>
				</div>
			</div>
			<div class="col-md-3 col-sm-1"></div>
		</div>
	</div>
</div>

<div class="modal fade" id="passwordEditSuccess"
	tabindex="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close"
					data-dismiss="modal" aria-hidden="true">
					&times;
				</button>
				<h4 class="modal-title" id="myModalLabel">
					подсказка
				</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-4"></div>
					<div class="col-md-4">
						<div style="text-align: center;">
							<img src="media/icons/success-icon.png" alt=""
								style="width: 100px; height: 100px;">
						</div>
					</div>
					<div class="col-md-4"></div>
				</div>
				<div class="row" style="margin-top: 10px">
					<div class="col-md-4"></div>
					<div class="col-md-4" style="text-align:center;"><h4>Пароль был успешно изменен.</h4></div>
					<div class="col-md-4"></div>
				</div>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn btn-default" data-dismiss="modal">
					<span>Ok</span>
				</button>
			</div>
		</div>
	</div>
</div>