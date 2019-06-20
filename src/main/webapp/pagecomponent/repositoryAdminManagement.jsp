<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	var search_type_repositoryAdmin = "none";
	var search_keyWord = "";
	var selectID;

	$(function() {
		optionAction();
		searchAction();
		repositoryAdminListInit();
		bootstrapValidatorInit();
		datePickerInit();

		addRepositoryAdminAction();
		editRepositoryAdminAction();
		deleteRepositoryAdminAction();
		importRepositoryAdminAction();
		exportRepositoryAdminAction()
	})

	// Список
	function optionAction() {
		$(".dropOption").click(function() {
			var type = $(this).text();
			$("#search_input").val("");
			if (type == "Все") {
				$("#search_input").attr("readOnly", "true");
				search_type_repositoryAdmin = "searchAll";
			} else if (type == "ID Администратора") {
				$("#search_input").removeAttr("readOnly");
				search_type_repositoryAdmin = "searchByID";
			} else if (type == "Имя администратора склада") {
				$("#search_input").removeAttr("readOnly");
				search_type_repositoryAdmin = "searchByName";
			}else if(type == "ID склада"){
				$("#search_input").removeAttr("readOnly");
				search_type_repositoryAdmin = "searchByRepositoryID";
			} else {
				$("#search_input").removeAttr("readOnly");
			}

			$("#search_type").text(type);
			$("#search_input").attr("placeholder", type);
		})
	}

	// Поиск действий
	function searchAction() {
		$('#search_button').click(function() {
			search_keyWord = $('#search_input').val();
			tableRefresh();
		})
	}

	// Параметр запроса
	function queryParams(params) {
		var temp = {
			limit : params.limit,
			offset : params.offset,
			searchType : search_type_repositoryAdmin,
			keyWord : search_keyWord
		}
		return temp;
	}

	// Инициализация таблицы
	function repositoryAdminListInit() {
		$('#repositoryAdminList')
				.bootstrapTable(
						{
							columns : [
									{
										field : 'id',
										title : 'ID администратора'
									//sortable: true
									},
									{
										field : 'name',
										title : 'Имя администратора склада'
									},
									{
										field : 'sex',
										title : 'Пол'
									},
									{
										field : 'tel',
										title : 'Контактный номер',
											visible : false
									},
									{
										field : 'address',
										title : 'Адрес',
										visible : false
									},
									{
										field : 'birth',
										title : 'Дата рождения',
										visible : false
									},
									{
										field : "repositoryBelongID",
										title : "ID склада"
									},
									{
										field : 'operation',
										title : 'операция',
										formatter : function(value, row, index) {
											var s = '<button class="btn btn-info btn-sm edit"><span>Редактировать</span></button>';
											var d = '<button class="btn btn-danger btn-sm delete"><span>Удалить</span></button>';
											var fun = '';
											return s + ' ' + d;
										},
										events : {
											// Кнопка
											'click .edit' : function(e, value,
													row, index) {
												selectID = row.id;
												rowEditOperation(row);
											},
											'click .delete' : function(e,
													value, row, index) {
												selectID = row.id;
												$('#deleteWarning_modal').modal(
														'show');
											}
										}
									} ],
							url : 'repositoryAdminManage/getRepositoryAdminList',
							method : 'GET',
							queryParams : queryParams,
							sidePagination : "server",
							dataType : 'json',
							pagination : true,
							pageNumber : 1,
							pageSize : 5,
							pageList : [ 5, 10, 25, 50, 100 ],
							clickToSelect : true
						});
	}

	// реФРЭЭЭШ
	function tableRefresh() {
		$('#repositoryAdminList').bootstrapTable('refresh', {
			query : {}
		});
	}

	// Редактирование
	var unassignRepoCache;
	function rowEditOperation(row) {
		$('#edit_modal').modal("show");

		// load info
		$('#repositoryAdmin_form_edit').bootstrapValidator("resetForm", true);
		$('#repositoryAdmin_name_edit').val(row.name);
		$('#repositoryAdmin_sex_edit').val(row.sex);
		$('#repositoryAdmin_tel_edit').val(row.tel);
		$('#repositoryAdmin_address_edit').val(row.address);
		$('#repositoryAdmin_birth_edit').val(row.birth);
		$('#repositoryAdmin_repoID_edit').text("");
		
		// Загрузка
		if(row.repositoryBelongID != null){
			$('#repositoryAdmin_repoID_edit').append("<option value='" + row.repositoryBelongID + "'>" + row.repositoryBelongID + "</option>");
		}
			$('#repositoryAdmin_repoID_edit').append("<option value=''>Не назначен</option>");
		
		$('#repositoryInfo').removeClass('hide').addClass('hide');
		$.ajax({
			type : 'GET',
			url : 'repositoryManage/getUnassignRepository',
			dataType : 'json',
			contentTypr : 'application/json',
			success : function(response){
				data = response.data;
				unassignRepoCache = data;
				$.each(data,function(index,element){
					$('#repositoryAdmin_repoID_edit').append("<option value='" + element.id + "'>" + element.id + "</option>");
				})
			}
		});
	}

	// Инициализация даты
	function datePickerInit(){
		$('.form_date').datetimepicker({
			format:'yyyy-mm-dd',
			language : 'zh-CN',
			endDate : new Date(),
			weekStart : 1,
			todayBtn : 1,
			autoClose : 1,
			todayHighlight : 1,
			startView : 2,
			forceParse : 0,
			minView:2
		});
	}

	// Проверка данных
	function bootstrapValidatorInit() {
		$("#repositoryAdmin_form,#repositoryAdmin_form_edit").bootstrapValidator({
			message : 'This is not valid',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			excluded : [ ':disabled' ],
			fields : {
				repositoryAdmin_name : {
					validators : {
						notEmpty : {
							message : 'Имя администратора не может быть пустым'
						}
					}
				},
				repositoryAdmin_tel : {
					validators : {
						notEmpty : {
							message : 'Контактный номер администратора не может быть пустым'
						}
					}
				},
				repositoryAdmin_address : {
					validators : {
						notEmpty : {
							message : 'Контактный адрес администратора не может быть пустым'
						}
					}
				},
				repositoryAdmin_birth : {
					validators : {
						notEmpty : {
							message : 'ДР администратора склада не может быть пустым'
						}
					}
				}
				
			}
		})
	}

	//Изменить информацию
	function editRepositoryAdminAction() {
		$('#edit_modal_submit').click(
				function() {
					$('#repositoryAdmin_form_edit').data('bootstrapValidator')
							.validate();
					if (!$('#repositoryAdmin_form_edit').data('bootstrapValidator')
							.isValid()) {
						return;
					}

					var data = {
						id : selectID,
						name : $('#repositoryAdmin_name_edit').val(),
						sex : $('#repositoryAdmin_sex_edit').val(),
						tel : $('#repositoryAdmin_tel_edit').val(),
						address : $('#repositoryAdmin_address_edit').val(),
						birth : $('#repositoryAdmin_birth_edit').val(),
						repositoryBelongID : $('#repositoryAdmin_repoID_edit').val()
					}

					// ajax
					$.ajax({
						type : "POST",
						url : 'repositoryAdminManage/updateRepositoryAdmin',
						dataType : "json",
						contentType : "application/json",
						data : JSON.stringify(data),
						success : function(response) {
							$('#edit_modal').modal("hide");
							var type;
							var msg;
							if (response.result == "success") {
								type = "success";
								msg = "Информация успешно обновлена!";
							} else if (resposne == "error") {
								type = "error";
								msg = "Ошибка!"
							}
							infoModal(type, msg);
							tableRefresh();
						},
						error : function(response) {
						}
					});
				});

		$('#repositoryAdmin_repoID_edit').change(function(){
			var repositoryID = $(this).val();
			$('#repositoryInfo').removeClass('hide').addClass('hide');
			$.each(unassignRepoCache,function(index,element){
				if(element.id == repositoryID){
					$('#repository_address').text(element.address);
					$('#repository_area').text(element.area);
					$('#repository_status').text(element.status);
					$('#repositoryInfo').removeClass('hide');
				}
			})
			
		})
	}

	// Удалить информацию
	function deleteRepositoryAdminAction(){
		$('#delete_confirm').click(function(){
			var data = {
				"repositoryAdminID" : selectID
			}
			
			// ajax
			$.ajax({
				type : "GET",
				url : "repositoryAdminManage/deleteRepositoryAdmin",
				dataType : "json",
				contentType : "application/json",
				data : data,
				success : function(response){
					$('#deleteWarning_modal').modal("hide");
					var type;
					var msg;
					if(response.result == "success"){
						type = "success";
						msg = "Информация успешно удалена";
					}else{
						type = "error";
						msg = "Ошибка!";
					}
					infoModal(type, msg);
					tableRefresh();
				},error : function(response){
				}
			})
			
			$('#deleteWarning_modal').modal('hide');
		})
	}

	// Добавить  администратора
	function addRepositoryAdminAction() {
		$('#add_repositoryAdmin').click(function() {
			$('#add_modal').modal("show");
		});

		$('#add_modal_submit').click(function() {
			var data = {
				name : $('#repositoryAdmin_name').val(),
				tel : $('#repositoryAdmin_tel').val(),
				sex : $('#repositoryAdmin_sex').val(),
				address : $('#repositoryAdmin_address').val(),
				birth : $('#repositoryAdmin_birth').val()
			}
			// ajax
			$.ajax({
				type : "POST",
				url : "repositoryAdminManage/addRepositoryAdmin",
				dataType : "json",
				contentType : "application/json",
				data : JSON.stringify(data),
				success : function(response) {
					$('#add_modal').modal("hide");
					var msg;
					var type;
					if (response.result == "success") {
						type = "success";
						msg = "Администратор склада успешно добавлен<br><p>(Примечание: начальный пароль администратора склада - это его ID)</p>";
					} else if (response.result == "error") {
						type = "error";
						msg = "Ошибка!";
					}
					infoModal(type, msg);
					tableRefresh();

					// reset
					$('#repositoryAdmin_name').val("");
					$('#repositoryAdmin_sex').val("муж.");
					$('#repositoryAdmin_tel').val("");
					$('#repositoryAdmin_address').val("");
					$('#repositoryAdmin_birth').val("");
					$('#repositoryAdmin_form').bootstrapValidator("resetForm", true);
				},
				error : function(response) {
				}
			})
		})
	}

	var import_step = 1;
	var import_start = 1;
	var import_end = 3;
	// Импорт информации
	function importRepositoryAdminAction() {
		$('#import_repositoryAdmin').click(function() {
			$('#import_modal').modal("show");
		});

		$('#previous').click(function() {
			if (import_step > import_start) {
				var preID = "step" + (import_step - 1)
				var nowID = "step" + import_step;

				$('#' + nowID).addClass("hide");
				$('#' + preID).removeClass("hide");
				import_step--;
			}
		})

		$('#next').click(function() {
			if (import_step < import_end) {
				var nowID = "step" + import_step;
				var nextID = "step" + (import_step + 1);

				$('#' + nowID).addClass("hide");
				$('#' + nextID).removeClass("hide");
				import_step++;
			}
		})

		$('#file').on("change", function() {
			$('#previous').addClass("hide");
			$('#next').addClass("hide");
			$('#submit').removeClass("hide");
		})

		$('#submit').click(function() {
			var nowID = "step" + import_end;
			$('#' + nowID).addClass("hide");
			$('#uploading').removeClass("hide");

			// next
			$('#confirm').removeClass("hide");
			$('#submit').addClass("hide");

			// ajax
			$.ajaxFileUpload({
				url : "repositoryAdminManage/importRepositoryAdmin",
				secureuri: false,
				dataType: 'json',
				fileElementId:"file",
				success : function(data, status){
					var total = 0;
					var available = 0;
					var msg1 = "Информация администратора склада была успешно импортирована";
					var msg2 = "Не удалось импортировать информацию администратора склада";
					var info;

					$('#import_progress_bar').addClass("hide");
					if(data.result == "success"){
						total = data.total;
						available = data.available;
						info = msg1;
						$('#import_success').removeClass('hide');
					}else{
						info = msg2
						$('#import_error').removeClass('hide');
					}
					info = info + ",Общее количество статей：" + total + ",Действительный номер:" + available;
					$('#import_result').removeClass('hide');
					$('#import_info').text(info);
					$('#confirm').removeClass('disabled');
				},error : function(data, status){
				}
			})
		})

		$('#confirm').click(function() {
			// modal dissmiss
			importModalReset();
		})
	}

	//Экспорт информации
	function exportRepositoryAdminAction() {
		$('#export_repositoryAdmin').click(function() {
			$('#export_modal').modal("show");
		})

		$('#export_repositoryAdmin_download').click(function(){
			var data = {
				searchType : search_type_repositoryAdmin,
				keyWord : search_keyWord
			}
			var url = "repositoryAdminManage/exportRepositoryAdmin?" + $.param(data)
			window.open(url, '_blank');
			$('#export_modal').modal("hide");
		})
	}

	// Сброс
	function importModalReset(){
		var i;
		for(i = import_start; i <= import_end; i++){
			var step = "step" + i;
			$('#' + step).removeClass("hide")
		}
		for(i = import_start; i <= import_end; i++){
			var step = "step" + i;
			$('#' + step).addClass("hide")
		}
		$('#step' + import_start).removeClass("hide");

		$('#import_progress_bar').removeClass("hide");
		$('#import_result').removeClass("hide");
		$('#import_success').removeClass('hide');
		$('#import_error').removeClass('hide');
		$('#import_progress_bar').addClass("hide");
		$('#import_result').addClass("hide");
		$('#import_success').addClass('hide');
		$('#import_error').addClass('hide');
		$('#import_info').text("");
		$('#file').val("");

		$('#previous').removeClass("hide");
		$('#next').removeClass("hide");
		$('#submit').removeClass("hide");
		$('#confirm').removeClass("hide");
		$('#submit').addClass("hide");
		$('#confirm').addClass("hide");

		//$('#file').wrap('<form>').closest('form').get(0).reset();
		//$('#file').unwrap();
		//var control = $('#file');
		//control.replaceWith( control = control.clone( true ) );
		$('#file').on("change", function() {
			$('#previous').addClass("hide");
			$('#next').addClass("hide");
			$('#submit').removeClass("hide");
		})
		
		import_step = 1;
	}
	
	// окно подсказки
	function infoModal(type, msg) {
		$('#info_success').removeClass("hide");
		$('#info_error').removeClass("hide");
		if (type == "success") {
			$('#info_error').addClass("hide");
		} else if (type == "error") {
			$('#info_success').addClass("hide");
		}
		$('#info_content').html(msg);
		$('#info_modal').modal("show");
	}
</script>
<div class="panel panel-default">
	<ol class="breadcrumb">
		<li>Управление информацией администраторов склада</li>
	</ol>
	<div class="panel-body">
		<div class="row">
			<div class="col-md-8 col-sm-8">
				<div class="row">
					<div class="col-md-2 col-sm-3">
						<div class="btn-group">
							<button class="btn btn-default dropdown-toggle"
								data-toggle="dropdown">
								<span id="search_type">Метод поиска</span> <span class="caret"></span>
							</button>
							<ul class="dropdown-menu" role="menu">
								<li><a href="javascript:void(0)" class="dropOption">ID администратора</a></li>
								<li><a href="javascript:void(0)" class="dropOption">Имя администратора склада</a></li>
								<li><a href="javascript:void(0)" class="dropOption">ID склада</a></li>
								<li><a href="javascript:void(0)" class="dropOption">все</a></li>
							</ul>
						</div>
					</div>
					<div class="col-md-9 col-sm-9">
						<div>
							<div class="col-md-5 col-sm-7">
								<input id="search_input" type="text" class="form-control"
									placeholder="Запрос информации администратора склада">
							</div>
							<div class="col-md-2 col-sm-5">
								<button id="search_button" class="btn btn-success">
									<span class="glyphicon glyphicon-search"></span> <span>Поиск</span>
								</button>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 
			<div class="col-md-2">
				<div class="btn-group">
					<button class="btn btn-default dropdown-toggle"
						data-toggle="dropdown">
						<span id="search_type">Метод поиска</span> <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li><a href="javascript:void(0)" class="dropOption">ID администратора</a></li>
						<li><a href="javascript:void(0)" class="dropOption">Имя администратора склада</a></li>
						<li><a href="javascript:void(0)" class="dropOption">ID склада</a></li>
						<li><a href="javascript:void(0)" class="dropOption">все</a></li>
					</ul>
				</div>
			</div>
			<div class="col-md-9">
				<div>
					<div class="col-md-3">
						<input id="search_input" type="text" class="form-control"
							placeholder="Запрос информации администратора склада">
					</div>
					<div class="col-md-2">
						<button id="search_button" class="btn btn-success">
							<span class="glyphicon glyphicon-search"></span> <span>Поиск</span>
						</button>
					</div>
				</div>
			</div>
			 -->
		</div>

		<div class="row" style="margin-top: 25px">
			<div class="col-md-5">
				<button class="btn btn-sm btn-default" id="add_repositoryAdmin">
					<span class="glyphicon glyphicon-plus"></span> <span>Добавить администратора склада</span>
				</button>
				<button class="btn btn-sm btn-default" id="import_repositoryAdmin">
					<span class="glyphicon glyphicon-import"></span> <span>Импорт</span>
				</button>
				<button class="btn btn-sm btn-default" id="export_repositoryAdmin">
					<span class="glyphicon glyphicon-export"></span> <span>Экспорт</span>
				</button>
			</div>
			<div class="col-md-5"></div>
		</div>

		<div class="row" style="margin-top: 15px">
			<div class="col-md-12">
				<table id="repositoryAdminList" class="table table-striped"></table>
			</div>
		</div>
	</div>
</div>

<!-- Добавить информацию -->
<div id="add_modal" class="modal fade" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Добавить информацию администратора склада</h4>
			</div>
			<div class="modal-body">
				<!-- Содержимое коробки -->
				<div class="row">
					<div class="col-md-1 col-sm-2"></div>
					<div class="col-md-8 col-sm-8">
						<form class="form-horizontal" role="form" id="repositoryAdmin_form"
							style="margin-top: 25px">
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>Имя администратора склада：</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<input type="text" class="form-control" id="repositoryAdmin_name"
										name="repositoryAdmin_name" placeholder="Имя администратора склада">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>Пол менеджера склада:</span>
								</label>
								<div class="col-md-5 col-sm-5">
									<select name="" class="form-control" id="repositoryAdmin_sex">
										<option value="мужчина">мужчина</option>
										<option value="женщина">женщина</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>Контактный номер：</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<input type="text" class="form-control" id="repositoryAdmin_tel"
										name="repositoryAdmin_tel" placeholder="Контактный номер">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>Контактный адрес：</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<input type="text" class="form-control" id="repositoryAdmin_address"
										name="repositoryAdmin_address" placeholder="Контактный адрес">
								</div>
							</div>
							<div class="form-group">
								<label for="BirthDate" class="control-label col-md-5 col-sm-5"> 
									<span>Дата рождения:</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<input class="form_date form-control" value="" id="repositoryAdmin_birth" name="repositoryAdmin_birth" placeholder="Дата рождения">
								</div>
							</div>
						</form>
					</div>
					<div class="col-md-1 col-sm-1"></div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-success" type="button" id="add_modal_submit">
					<span>Двапить</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- Коробка информации -->
<div class="modal fade" id="import_modal" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Импорт информации администратора склада</h4>
			</div>
			<div class="modal-body">
				<div id="step1">
					<div class="row" style="margin-top: 15px">
						<div class="col-md-1 col-sm-1"></div>
						<div class="col-md-10 col-sm-10">
							<div>
								<h4>Нажмите кнопку загрузки ниже, чтобы загрузить информационную таблицу менеджера склада</h4>
							</div>
							<div style="margin-top: 30px; margin-buttom: 15px">
								<a class="btn btn-info"
									href="commons/fileSource/download/repositoryAdminInfo.xlsx"
									target="_blank"> <span class="glyphicon glyphicon-download"></span>
									<span>Скачать</span>
								</a>
							</div>
						</div>
					</div>
				</div>
				<div id="step2" class="hide">
					<div class="row" style="margin-top: 15px">
						<div class="col-md-1 col-sm-1"></div>
						<div class="col-md-10 col-sm-10">
							<div>
								<h4>Заполните одну или несколько сведений об администраторе склада для добавления в формате, указанном в электронной таблице информации об администраторе склада.</h4>
							</div>
							<div class="alert alert-info"
								style="margin-top: 10px; margin-buttom: 30px">
								<p>Примечание: каждый столбец в таблице не может быть пустым. Если есть незаполненные элементы, информация не будет успешно импортирована.</p>
							</div>
						</div>
					</div>
				</div>
				<div id="step3" class="hide">
					<div class="row" style="margin-top: 15px">
						<div class="col-md-1 col-sm-1"></div>
						<div class="col-md-8 col-sm-10">
							<div>
								<div>
									<h4>Нажмите кнопку «Загрузить файл» ниже, чтобы загрузить заполненную информационную таблицу </h4>
								</div>
								<div style="margin-top: 30px; margin-buttom: 15px">
									<span class="btn btn-info btn-file"> <span> <span
											class="glyphicon glyphicon-upload"></span> <span>Загрузить файл</span>
									</span> 
									<form id="import_file_upload"><input type="file" id="file" name="file"></form>
									</span>
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="hide" id="uploading">
					<div class="row" style="margin-top: 15px" id="import_progress_bar">
						<div class="col-md-1 col-sm-1"></div>
						<div class="col-md-10 col-sm-10"
							style="margin-top: 30px; margin-bottom: 30px">
							<div class="progress progress-striped active">
								<div class="progress-bar progress-bar-success"
									role="progreessbar" aria-valuenow="60" aria-valuemin="0"
									aria-valuemax="100" style="width: 100%;">
									<span class="sr-only">Пожалуйста подождите...</span>
								</div>
							</div>
							<!-- 
							<div style="text-align: center">
								<h4 id="import_info"></h4>
							</div>
							 -->
						</div>
						<div class="col-md-1 col-sm-1"></div>
					</div>
					<div class="row">
						<div class="col-md-4 col-sm-4"></div>
						<div class="col-md-4 col-sm-4">
							<div id="import_result" class="hide">
								<div id="import_success" class="hide" style="text-align: center;">
									<img src="media/icons/success-icon.png" alt=""
										style="width: 100px; height: 100px;">
								</div>
								<div id="import_error" class="hide" style="text-align: center;">
									<img src="media/icons/error-icon.png" alt=""
										style="width: 100px; height: 100px;">
								</div>
							</div>
						</div>
						<div class="col-md-4 col-sm-4"></div>
					</div>
					<div class="row" style="margin-top: 10px">
						<div class="col-md-3 col-sm-3"></div>
						<div class="col-md-6 col-sm-6" style="text-align: center;">
							<h4 id="import_info"></h4>
						</div>
						<div class="col-md-3 col-sm-3"></div>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn ben-default" type="button" id="previous">
					<span>Предыдущий шаг</span>
				</button>
				<button class="btn btn-success" type="button" id="next">
					<span>Следующий шаг</span>
				</button>
				<button class="btn btn-success hide" type="button" id="submit">
					<span>&nbsp;&nbsp;&nbsp;Пваить&nbsp;&nbsp;&nbsp;</span>
				</button>
				<button class="btn btn-success hide disabled" type="button"
					id="confirm" data-dismiss="modal">
					<span>&nbsp;&nbsp;&nbsp;Подтвердить&nbsp;&nbsp;&nbsp;</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- ящик экспорта -->
<div class="modal fade" id="export_modal" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Экспорт информации о администраторах</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-3 col-sm-3" style="text-align: center;">
						<img src="media/icons/warning-icon.png" alt=""
							style="width: 70px; height: 70px; margin-top: 20px;">
					</div>
					<div class="col-md-8 col-sm-8">
						<h3>Подтвердите экспорт информации об администаторах склада</h3>
						<p>(Примечание: Пожалуйста, определите информацию которая будет экспортирована, экспортированный контент является текущим списком результатов поиска)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-success" type="button" id="export_repositoryAdmin_download">
					<span>Подтвердить загрузку</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- окно с подсказкой -->
<div class="modal fade" id="info_modal" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">информация</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-4 col-sm-4"></div>
					<div class="col-md-4 col-sm-4">
						<div id="info_success" class=" hide" style="text-align: center;">
							<img src="media/icons/success-icon.png" alt=""
								style="width: 100px; height: 100px;">
						</div>
						<div id="info_error" style="text-align: center;">
							<img src="media/icons/error-icon.png" alt=""
								style="width: 100px; height: 100px;">
						</div>
					</div>
					<div class="col-md-4 col-sm-4"></div>
				</div>
				<div class="row" style="margin-top: 10px">
					<div class="col-md-4 col-sm-4"></div>
					<div class="col-md-4 col-sm-4" style="text-align: center;">
						<h4 id="info_content"></h4>
					</div>
					<div class="col-md-4 col-sm-4"></div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>&nbsp;&nbsp;&nbsp;Ок!&nbsp;&nbsp;&nbsp;</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- Удалить подсказку -->
<div class="modal fade" id="deleteWarning_modal" table-index="-1"
	role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Предупреждение</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-3 col-sm-3" style="text-align: center;">
						<img src="media/icons/warning-icon.png" alt=""
							style="width: 70px; height: 70px; margin-top: 20px;">
					</div>
					<div class="col-md-8 col-sm-8">
						<h3>Подтвердить удаление информации</h3>
						<p>(Примечание. Если администратор склада назначил управляемый склад, информация об администраторе склада не будет успешно удалена. Чтобы удалить информацию о клиенте, сначала отмените назначение администратора склада.)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-danger" type="button" id="delete_confirm">
					<span>Подтвердить удаление</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- Редактировать информацию -->
<div id="edit_modal" class="modal fade" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Изменить информацию менеджера склада</h4>
			</div>
			<div class="modal-body">

				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-8 col-sm-8">
						<form class="form-horizontal" role="form" id="repositoryAdmin_form_edit"
							style="margin-top: 25px">
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>Имя менеджера склада：</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<input type="text" class="form-control" id="repositoryAdmin_name_edit"
										name="repositoryAdmin_name" placeholder="Имя администратора склада">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>Пол менеджера склада:</span>
								</label>
								<div class="col-md-5 col-sm-5">
									<select name="" class="form-control" id="repositoryAdmin_sex_edit">
										<option value="мужской">мужской</option>
										<option value="женский">женский</option>
									</select>
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>Контактный номер：</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<input type="text" class="form-control" id="repositoryAdmin_tel_edit"
										name="repositoryAdmin_tel" placeholder="Контактный номер">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>Контактный адрес：</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<input type="text" class="form-control" id="repositoryAdmin_address_edit"
										name="repositoryAdmin_address" placeholder="Контактный адрес">
								</div>
							</div>
							<div class="form-group">
								<label for="BirthDate" class="control-label col-md-5 col-sm-5"> 
									<span>Дата рождени:</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<input class="form_date form-control" value="" id="repositoryAdmin_birth_edit" name="repositoryAdmin_birth" placeholder="Дата рождени">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-5 col-sm-5"> <span>ID склада：</span>
								</label>
								<div class="col-md-7 col-sm-7">
									<select name="" class="form-control" id="repositoryAdmin_repoID_edit">
										<option value=""></option>
									</select>
								</div>
							</div>
							<div class="form-group hide" id="repositoryInfo">
								<div class="col-md-2"></div>
								<div class="col-md-10 alert alert-info">
									<div><label>Адрес склада：</label><span id="repository_address"></span></div>
									<div><label>Складская площадь：</label><span id="repository_area"></span></div>
									<div><label>Состояние склада:</label><span id="repository_status"></span></div>
								</div>
							</div>
						</form>
					</div>
					<div class="col-md-1"></div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-success" type="button" id="edit_modal_submit">
					<span>Подтвердите изменение</span>
				</button>
			</div>
		</div>
	</div>
</div>