<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	var search_type_supplier = "none";
	var search_keyWord = "";
	var selectID;

	$(function() {
		optionAction();
		searchAction();
		supplierListInit();
		bootstrapValidatorInit();

		addSupplierAction();
		editSupplierAction();
		deleteSupplierAction();
		importSupplierAction();
		exportSupplierAction()
	})

	// Действие выбора выпадающего списка
	function optionAction() {
		$(".dropOption").click(function() {
			var type = $(this).text();
			$("#search_input").val("");
			if (type == "Все") {
				$("#search_input").attr("readOnly", "true");
				search_type_supplier = "searchAll";
			} else if (type == "ID Поставщика") {
				$("#search_input").removeAttr("readOnly");
				search_type_supplier = "searchByID";
			} else if (type == "Название поставщика") {
				$("#search_input").removeAttr("readOnly");
				search_type_supplier = "searchByName";
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
			searchType : search_type_supplier,
			keyWord : search_keyWord
		}
		return temp;
	}

	// Инициализация таблицы
	function supplierListInit() {
		$('#supplierList')
				.bootstrapTable(
						{
							columns : [
									{
										field : 'id',
										title : 'ID поставщика'
									//sortable: true
									},
									{
										field : 'name',
										title : 'Название поставщика'
									},
									{
										field : 'personInCharge',
										title : 'Ответственное лицо'
									},
									{
										field : 'tel',
										title : 'Контактный телефон'
									},
									{
										field : 'address',
										title : 'Контактный адрес',
										visible : false
									},
									{
										field : 'email',
										title : 'Электронная почта',
										visible : false
									},
									{
										field : 'operation',
										title : 'Операция',
										formatter : function(value, row, index) {
											var s = '<button class="btn btn-info btn-sm edit"><span>Редактировать</span></button>';
											var d = '<button class="btn btn-danger btn-sm delete"><span>Удалить</span></button>';
											var fun = '';
											return s + ' ' + d;
										},
										events : {
											//Кнопка действия в столбце
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
							url : 'supplierManage/getSupplierList',
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

	//Обновление таблицы
	function tableRefresh() {
		$('#supplierList').bootstrapTable('refresh', {
			query : {}
		});
	}

	//редактирование строки
	function rowEditOperation(row) {
		$('#edit_modal').modal("show");

		// load info
		$('#supplier_form_edit').bootstrapValidator("resetForm", true);
		$('#supplier_name_edit').val(row.name);
		$('#supplier_person_edit').val(row.personInCharge);
		$('#supplier_tel_edit').val(row.tel);
		$('#supplier_email_edit').val(row.email);
		$('#supplier_address_edit').val(row.address);
	}

	// Проверка данных
	function bootstrapValidatorInit() {
		$("#supplier_form,#supplier_form_edit").bootstrapValidator({
			message : 'This is not valid',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			excluded : [ ':disabled' ],
			fields : {
				supplier_name : {
					validators : {
						notEmpty : {
							message : 'Имя не может быть пустым'
						}
					}
				},
				supplier_tel : {
					validators : {
						notEmpty : {
							message : 'Телефон не может быть пустым'
						}
					}
				},
				supplier_email : {
					validators : {
						notEmpty : {
							message : 'E-mail не может быть пустым'
						},
						regexp : {
							regexp : '^[^@\\s]+@([^@\\s]+\\.)+[^@\\s]+$',
							message : 'Неверный формат почты'
						}
					}
				},
				supplier_address : {
					validators : {
						notEmpty : {
							message : 'Адрес не может быть пустым'
						}
					}
				},
				supplier_person : {
					validators : {
						notEmpty : {
							message : 'Лидер поставщика не может быть пустым'
						}
					}
				}
			}
		})
	}

	//Изменить информацию о поставщике
	function editSupplierAction() {
		$('#edit_modal_submit').click(
				function() {
					$('#supplier_form_edit').data('bootstrapValidator')
							.validate();
					if (!$('#supplier_form_edit').data('bootstrapValidator')
							.isValid()) {
						return;
					}

					var data = {
						id : selectID,
						name : $('#supplier_name_edit').val(),
						personInCharge : $('#supplier_person_edit').val(),
						tel : $('#supplier_tel_edit').val(),
						email : $('#supplier_email_edit').val(),
						address : $('#supplier_address_edit').val()
					}

					// ajax
					$.ajax({
						type : "POST",
						url : 'supplierManage/updateSupplier',
						dataType : "json",
						contentType : "application/json",
						data : JSON.stringify(data),
						success : function(response) {
							$('#edit_modal').modal("hide");
							var type;
							var msg;
							if (response.result == "success") {
								type = "success";
								msg = "Успешно!";
							} else if (response.result == "error") {
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
	}

	//Удалить информацию о поставщике
	function deleteSupplierAction(){
		$('#delete_confirm').click(function(){
			var data = {
				"supplierID" : selectID
			}
			
			// ajax
			$.ajax({
				type : "GET",
				url : "supplierManage/deleteSupplier",
				dataType : "json",
				contentType : "application/json",
				data : data,
				success : function(response){
					$('#deleteWarning_modal').modal("hide");
					var type;
					var msg;
					if(response.result == "success"){
						type = "success";
						msg = "Успешно!";
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

	// Добавить информацию о поставщике
	function addSupplierAction() {
		$('#add_supplier').click(function() {
			$('#add_modal').modal("show");
		});

		$('#add_modal_submit').click(function() {
			var data = {
				name : $('#supplier_name').val(),
				personInCharge : $('#supplier_person').val(),
				tel : $('#supplier_tel').val(),
				email : $('#supplier_email').val(),
				address : $('#supplier_address').val()
			}
			// ajax
			$.ajax({
				type : "POST",
				url : "supplierManage/addSupplier",
				dataType : "json",
				contentType : "application/json",
				data : JSON.stringify(data),
				success : function(response) {
					$('#add_modal').modal("hide");
					var msg;
					var type;
					if (response.result == "success") {
						type = "success";
						msg = "Поставщик успешно добавлен";
					} else if (response.result == "error") {
						type = "error";
						msg = "Не удалось добавить поставщика";
					}
					infoModal(type, msg);
					tableRefresh();

					// reset
					$('#supplier_name').val("");
					$('#supplier_person').val("");
					$('#supplier_tel').val("");
					$('#supplier_email').val("");
					$('#supplier_address').val("");
					$('#supplier_form').bootstrapValidator("resetForm", true);
				},
				error : function(response) {
				}
			})
		})
	}

	var import_step = 1;
	var import_start = 1;
	var import_end = 3;
	// Импорт информации о поставщике
	function importSupplierAction() {
		$('#import_supplier').click(function() {
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
				url : "supplierManage/importSupplier",
				secureuri: false,
				dataType: 'json',
				fileElementId:"file",
				success : function(data, status){
					var total = 0;
					var available = 0;
					var msg1 = "Информация о поставщике была успешно импортирована";
					var msg2 = "Не удалось импортировать информацию о поставщике";
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
					info = info + ",Общие количество：" + total + ", номер:" + available;
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

	//Экспорт информации о поставщике
	function exportSupplierAction() {
		$('#export_supplier').click(function() {
			$('#export_modal').modal("show");
		})

		$('#export_supplier_download').click(function(){
			var data = {
				searchType : search_type_supplier,
				keyWord : search_keyWord
			}
			var url = "supplierManage/exportSupplier?" + $.param(data)
			window.open(url, '_blank');
			$('#export_modal').modal("hide");
		})
	}


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
	
	// Окно подсказки
	function infoModal(type, msg) {
		$('#info_success').removeClass("hide");
		$('#info_error').removeClass("hide");
		if (type == "success") {
			$('#info_error').addClass("hide");
		} else if (type == "error") {
			$('#info_success').addClass("hide");
		}
		$('#info_content').text(msg);
		$('#info_modal').modal("show");
	}
</script>
<div class="panel panel-default">
	<ol class="breadcrumb">
		<li>Управление информацией о поставщиках</li>
	</ol>
	<div class="panel-body">
		<div class="row">
			<div class="col-md-1 col-sm-2">
				<div class="btn-group">
					<button class="btn btn-default dropdown-toggle"
						data-toggle="dropdown">
						<span id="search_type">Метод поиска</span> <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li><a href="javascript:void(0)" class="dropOption">ID поставщика</a></li>
						<li><a href="javascript:void(0)" class="dropOption">Название поставщика</a></li>
						<li><a href="javascript:void(0)" class="dropOption">Все</a></li>
					</ul>
				</div>
			</div>
			<div class="col-md-9 col-sm-9">
				<div>
					<div class="col-md-3 col-sm-4">
						<input id="search_input" type="text" class="form-control"
							placeholder="ID поставщика">
					</div>
					<div class="col-md-2 col-sm-3">
						<button id="search_button" class="btn btn-success">
							<span class="glyphicon glyphicon-search"></span> <span>Поиск</span>
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="row" style="margin-top: 25px">
			<div class="col-md-5">
				<button class="btn btn-sm btn-default" id="add_supplier">
					<span class="glyphicon glyphicon-plus"></span> <span>Добавить поставщика</span>
				</button>
				<button class="btn btn-sm btn-default" id="import_supplier">
					<span class="glyphicon glyphicon-import"></span> <span>Импорт</span>
				</button>
				<button class="btn btn-sm btn-default" id="export_supplier">
					<span class="glyphicon glyphicon-export"></span> <span>Экспорт</span>
				</button>
			</div>
			<div class="col-md-5"></div>
		</div>

		<div class="row" style="margin-top: 15px">
			<div class="col-md-12">
				<table id="supplierList" class="table table-striped"></table>
			</div>
		</div>
	</div>
</div>

<!-- Добавить информацию о поставщике -->
<div id="add_modal" class="modal fade" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Добавить информацию о поставщике</h4>
			</div>
			<div class="modal-body">
				<!-- Содержимое -->
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-8 col-sm-8">
						<form class="form-horizontal" role="form" id="supplier_form"
							style="margin-top: 25px">
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Название поставщика：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="supplier_name"
										name="supplier_name" placeholder="Название поставщика">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Имя ответственного лица：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="supplier_person"
										name="supplier_person" placeholder="Имя ответственного лица">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Контактный телефон：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="supplier_tel"
										name="supplier_tel" placeholder="Контактный телефон:">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Электронная почта：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="supplier_email"
										name="supplier_email" placeholder="Электронная почта">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Контактный адрес：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="supplier_address"
										name="supplier_address" placeholder="Контактный адрес">
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
					<span>Добавить</span>
				</button>
			</div>
		</div>
	</div>
</div>


<div class="modal fade" id="import_modal" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Импорт информации о поставщике</h4>
			</div>
			<div class="modal-body">
				<div id="step1">
					<div class="row" style="margin-top: 15px">
						<div class="col-md-1 col-sm-1"></div>
						<div class="col-md-10 col-sm-10">
							<div>
								<h4>Нажмите кнопку загрузки ниже, чтобы загрузить таблицу с информацией о поставщике.</h4>
							</div>
							<div style="margin-top: 30px; margin-buttom: 15px">
								<a class="btn btn-info"
									href="commons/fileSource/download/supplierInfo.xlsx"
									target="_blank"> <span class="glyphicon glyphicon-download"></span>
									<span>Загрузить</span>
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
								<h4>Пожалуйста, заполните информацию об одном или нескольких поставщиках в формате, указанном в информационной таблице</h4>
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
									<h4>Нажмите кнопку «Загрузить файл» ниже, чтобы загрузить заполненную электронную таблицу с информацией о поставщике.</h4>
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
						<div class="col-md-1"></div>
					</div>
					<div class="row">
						<div class="col-md-4"></div>
						<div class="col-md-4">
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
						<div class="col-md-4"></div>
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
					<span>Назад</span>
				</button>
				<button class="btn btn-success" type="button" id="next">
					<span>Далее</span>
				</button>
				<button class="btn btn-success hide" type="button" id="submit">
					<span>&nbsp;&nbsp;&nbsp;Првмвить&nbsp;&nbsp;&nbsp;</span>
				</button>
				<button class="btn btn-success hide disabled" type="button"
					id="confirm" data-dismiss="modal">
					<span>&nbsp;&nbsp;&nbsp;Подтвердить&nbsp;&nbsp;&nbsp;</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- Экспорт информации -->
<div class="modal fade" id="export_modal" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Экспорт информации о поставщике</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-3 col-sm-3" style="text-align: center;">
						<img src="media/icons/warning-icon.png" alt=""
							style="width: 70px; height: 70px; margin-top: 20px;">
					</div>
					<div class="col-md-8 col-sm-8">
						<h3>Подтвердите экспорт информации о поставщиках</h3>
						<p>( Примечание: Пожалуйста, определите информацию о поставщике, которая будет экспортирована, а экспортированный контент - это текущий список результатов поиска.)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-success" type="button" id="export_supplier_download">
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
				<h4 class="modal-title" id="myModalLabel">Информация</h4>
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

<!-- Удаление -->
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
						<h3>Подтвердить удаление информации о поставщике?</h3>
						<p>(Примечание. Если поставщик уже имеет входящую запись склада, информация о поставщике не будет успешно удалена. Чтобы удалить информацию о поставщике, сначала удалите входящую запись поставщика.)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-danger" type="button" id="delete_confirm")>
					<span>Подтвердить удаление</span>
				</button>
			</div>
		</div>
	</div>
</div>

<!-- Редактировать окно с информацией о поставщике -->
<div id="edit_modal" class="modal fade" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Изменить информацию о поставщике</h4>
			</div>
			<div class="modal-body">
				<!-- Содержимое коробки -->
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-8 col-sm-8">
						<form class="form-horizontal" role="form" id="supplier_form_edit"
							style="margin-top: 25px">
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Название поставщика：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="supplier_name_edit"
										name="supplier_name" placeholder="Название поставщика">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Имя ответственного лица：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control"
										id="supplier_person_edit" name="supplier_person"
										placeholder="Имя ответственного лица">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Контактный телефон：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="supplier_tel_edit"
										name="supplier_tel" placeholder="Контактный телефон">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Электронная почта：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control"
										id="supplier_email_edit" name="supplier_email"
										placeholder="Электронная почта">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Контактный адрес：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control"
										id="supplier_address_edit" name="supplier_address"
										placeholder="Контактный адрес">
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
				<button class="btn btn-success" type="button" id="edit_modal_submit">
					<span>Подтвердить редактирование</span>
				</button>
			</div>
		</div>
	</div>
</div>