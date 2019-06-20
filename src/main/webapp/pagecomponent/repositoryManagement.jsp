<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	var search_type_repository = "none";
	var search_keyWord = "";
	var selectID;

	$(function() {
		optionAction();
		searchAction();
		repositoryListInit();
		bootstrapValidatorInit();

		addRepositoryAction();
		editRepositoryAction();
		deleteRepositoryAction();
		importRepositoryAction();
		exportRepositoryAction()
	})

	function optionAction() {
		$(".dropOption").click(function() {
			var type = $(this).text();
			$("#search_input").val("");
			if (type == "Все") {
				$("#search_input").attr("readOnly", "true");
				search_type_repository = "searchAll";
			} else if (type == "ID склада") {
				$("#search_input").removeAttr("readOnly");
				search_type_repository = "searchByID";
			} else if (type == "Адрес склада") {
				$("#search_input").removeAttr("readOnly");
				search_type_repository = "searchByAddress";
			} else {
				$("#search_input").removeAttr("readOnly");
			}

			$("#search_type").text(type);
			$("#search_input").attr("placeholder", type);
		})
	}

	function searchAction() {
		$('#search_button').click(function() {
			search_keyWord = $('#search_input').val();
			tableRefresh();
		})
	}

	function queryParams(params) {
		var temp = {
			limit : params.limit,
			offset : params.offset,
			searchType : search_type_repository,
			keyWord : search_keyWord
		}
		return temp;
	}

	function repositoryListInit() {
		$('#repositoryList')
				.bootstrapTable(
						{
							columns : [
									{
										field : 'id',
										title : 'ID склада'
									//sortable: true
									},
									{
										field : 'address',
										title : 'Адрес склада'
									},
									{
										field : 'adminName',
										title : 'Заведующий складом'
									},
									{
										field : 'status',
										title : 'Состояние'
									},
									{
										field : 'area',
										title : 'Область',
										visible : false
									},
									{
										field : 'desc',
										title : 'Описание',
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

											'click .edit' : function(e, value,
													row, index) {
												selectID = row.id;
												rowEditOperation(row);
											},
											'click .delete' : function(e,
													value, row, index) {
												selectID = row.id;
												$('#deleteWarning_modal')
														.modal('show');
											}
										}
									} ],
							url : 'repositoryManage/getRepositoryList',
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

	function tableRefresh() {
		$('#repositoryList').bootstrapTable('refresh', {
			query : {}
		});
	}

	function rowEditOperation(row) {
		$('#edit_modal').modal("show");

		// load info
		$('#repository_form_edit').bootstrapValidator("resetForm", true);
		$('#repository_address_edit').val(row.address);
		$('#repository_status_edit').val(row.status);
		$('#repository_area_edit').val(row.area);
		$('#repository_desc_edit').val(row.desc);
	}

	function bootstrapValidatorInit() {
		$("#repository_form,#repository_form_edit").bootstrapValidator({
			message : 'This is not valid',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			excluded : [ ':disabled' ],
			fields : {
				repository_address : {
					validators : {
						notEmpty : {
							message : 'Адрес склада не может быть пустым'
						}
					}
				},
				repository_status : {
					validators : {
						notEmpty : {
							message : 'Статус склада не может быть пустым'
						}
					}
				},
				repository_area : {
					validators : {
						notEmpty : {
							message : 'Поле не может быть пустым'
						}
					}
				}
			}
		})
	}

	function editRepositoryAction() {
		$('#edit_modal_submit').click(
				function() {
					$('#repository_form_edit').data('bootstrapValidator')
							.validate();
					if (!$('#repository_form_edit').data('bootstrapValidator')
							.isValid()) {
						return;
					}

					var data = {
						id : selectID,
						address : $('#repository_address_edit').val(),
						status : $('#repository_status_edit').val(),
						area : $('#repository_area_edit').val(),
						desc : $('#repository_desc_edit').val(),
					}

					// ajax
					$.ajax({
						type : "POST",
						url : 'repositoryManage/updateRepository',
						dataType : "json",
						contentType : "application/json",
						data : JSON.stringify(data),
						success : function(response) {
							$('#edit_modal').modal("hide");
							var type;
							var msg;
							if (response.result == "success") {
								type = "success";
								msg = "Информация успешно обновлена";
							} else if (resposne == "error") {
								type = "error";
								msg = "Не удалось обновить информацию о складе"
							}
							infoModal(type, msg);
							tableRefresh();
						},
						error : function(response) {
						}
					});
				});
	}

	function deleteRepositoryAction() {
		$('#delete_confirm').click(function() {
			var data = {
				"repositoryID" : selectID
			}

			// ajax
			$.ajax({
				type : "GET",
				url : "repositoryManage/deleteRepository",
				dataType : "json",
				contentType : "application/json",
				data : data,
				success : function(response) {
					$('#deleteWarning_modal').modal("hide");
					var type;
					var msg;
					if (response.result == "success") {
						type = "success";
						msg = "Информация была успешно удалена.";
					} else {
						type = "error";
						msg = "Не удалось удалить информацию о складе";
					}
					infoModal(type, msg);
					tableRefresh();
				},
				error : function(response) {
				}
			})

			$('#deleteWarning_modal').modal('hide');
		})
	}

	function addRepositoryAction() {
		$('#add_repository').click(function() {
			$('#add_modal').modal("show");
		});

		$('#add_modal_submit').click(function() {
			var data = {
				address : $('#repository_address').val(),
				status : $('#repository_status').val(),
				area : $('#repository_area').val(),
				desc : $('#repository_desc').val(),
			}
			// ajax
			$.ajax({
				type : "POST",
				url : "repositoryManage/addRepository",
				dataType : "json",
				contentType : "application/json",
				data : JSON.stringify(data),
				success : function(response) {
					$('#add_modal').modal("hide");
					var msg;
					var type;
					if (response.result == "success") {
						type = "success";
						msg = "Склад успешно добавлен";
					} else if (response.result == "error") {
						type = "error";
						msg = "Не удалось добавить склад";
					}
					infoModal(type, msg);
					tableRefresh();

					// reset
					$('#repository_address').val("");
					$('#repository_ststus').val("");
					$('#repository_area').val("");
					$('#repository_desc').val("");
					$('#repository_form').bootstrapValidator("resetForm", true);
				},
				error : function(response) {
				}
			})
		})
	}

	var import_step = 1;
	var import_start = 1;
	var import_end = 3;

	function importRepositoryAction() {
		$('#import_repository').click(function() {
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
				url : "repositoryManage/importRepository",
				secureuri : false,
				dataType : 'json',
				fileElementId : "file",
				success : function(data, status) {
					var total = 0;
					var available = 0;
					var msg1 = "Информация о складе была успешно импортирована";
					var msg2 = "Не удалось импортировать информацию";
					var info;

					$('#import_progress_bar').addClass("hide");
					if (data.result == "success") {
						total = data.total;
						available = data.available;
						info = msg1;
						$('#import_success').removeClass('hide');
					} else {
						info = msg2
						$('#import_error').removeClass('hide');
					}
					info = info + ",количество：" + total + ",номер:" + available;
					$('#import_result').removeClass('hide');
					$('#import_info').text(info);
					$('#confirm').removeClass('disabled');
				},
				error : function(data, status) {
				}
			})
		})

		$('#confirm').click(function() {
			// modal dissmiss
			importModalReset();
		})
	}

	function exportRepositoryAction() {
		$('#export_repository').click(function() {
			$('#export_modal').modal("show");
		})

		$('#export_repository_download').click(
				function() {
					var data = {
						searchType : search_type_repository,
						keyWord : search_keyWord
					}
					var url = "repositoryManage/exportRepository?"
							+ $.param(data)
					window.open(url, '_blank');
					$('#export_modal').modal("hide");
				})
	}

	function importModalReset() {
		var i;
		for (i = import_start; i <= import_end; i++) {
			var step = "step" + i;
			$('#' + step).removeClass("hide")
		}
		for (i = import_start; i <= import_end; i++) {
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

		$('#file').on("change", function() {
			$('#previous').addClass("hide");
			$('#next').addClass("hide");
			$('#submit').removeClass("hide");
		})

		import_step = 1;
	}

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
		<li>Управление информацией</li>
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
						<li><a href="javascript:void(0)" class="dropOption">ID склада</a></li>
						<li><a href="javascript:void(0)" class="dropOption">Адрес склада</a></li>
						<li><a href="javascript:void(0)" class="dropOption">Все</a></li>
					</ul>
				</div>
			</div>
			<div class="col-md-9 col-sm-9">
				<div>
					<div class="col-md-3 col-sm-4">
						<input id="search_input" type="text" class="form-control"
							placeholder="Запрос">
					</div>
					<div class="col-md-2 col-sm-2">
						<button id="search_button" class="btn btn-success">
							<span class="glyphicon glyphicon-search"></span> <span>Запрос</span>
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="row" style="margin-top: 25px">
			<div class="col-md-5">
				<button class="btn btn-sm btn-default" id="add_repository">
					<span class="glyphicon glyphicon-plus"></span> <span>Добавить информацию о складе</span>
				</button>
				<button class="btn btn-sm btn-default" id="import_repository">
					<span class="glyphicon glyphicon-import"></span> <span>Импорт</span>
				</button>
				<button class="btn btn-sm btn-default" id="export_repository">
					<span class="glyphicon glyphicon-export"></span> <span>Экспорт</span>
				</button>
			</div>
			<div class="col-md-5"></div>
		</div>

		<div class="row" style="margin-top: 15px">
			<div class="col-md-12">
				<table id="repositoryList" class="table table-striped"></table>
			</div>
		</div>
	</div>
</div>

<div id="add_modal" class="modal fade" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Добавить информацию о складе</h4>
			</div>
			<div class="modal-body">

				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-8 col-sm-8">
						<form class="form-horizontal" role="form" id="repository_form"
							style="margin-top: 25px">
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Адрес склада：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="repository_address"
										name="repository_address" placeholder="Адрес склада">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Складская площадь：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="repository_area"
										name="repository_area" placeholder="Складская площадь">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Состояние склада：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="repository_status"
										name="repository_status" placeholder="Состояние склада">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Описание склада：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<textarea class="form-control" id="repository_desc"
										name="repository_desc" placeholder="Описание склада" style="min-width: 100%"></textarea>
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
				<h4 class="modal-title" id="myModalLabel">Импорт информации</h4>
			</div>
			<div class="modal-body">
				<div id="step1">
					<div class="row" style="margin-top: 15px">
						<div class="col-md-1 col-sm-1"></div>
						<div class="col-md-10 col-sm-10">
							<div>
								<h4>Нажмите кнопку загрузки ниже, чтобы загрузить электронную таблицу информации о складе.</h4>
							</div>
							<div style="margin-top: 30px; margin-buttom: 15px">
								<a class="btn btn-info"
									href="commons/fileSource/download/repositoryInfo.xlsx"
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
								<h4>Пожалуйста, заполните несколько складских данных, которые будут добавлены в формате, указанном в информационной таблице склада.</h4>
							</div>
							<div class="alert alert-info"
								style="margin-top: 10px; margin-buttom: 30px">
								<p>Примечание: если есть незаполненные элементы, информация не будет успешно импортирована.</p>
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
									<h4>
										Нажмите кнопку «Загрузить файл» ниже, чтобы загрузить заполненную электронную таблицу с информацией.</h4>
								</div>
								<div style="margin-top: 30px; margin-buttom: 15px">
									<span class="btn btn-info btn-file"> <span> <span
											class="glyphicon glyphicon-upload"></span> <span>Загрузить файл</span>
									</span>
										<form id="import_file_upload">
											<input type="file" id="file" name="file">
										</form>
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
						</div>
						<div class="col-md-1 col-sm-1"></div>
					</div>
					<div class="row">
						<div class="col-md-4 col-sm-4"></div>
						<div class="col-md-4 col-sm-4">
							<div id="import_result" class="hide">
								<div id="import_success" class="hide"
									style="text-align: center;">
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
					<span>Назад</span>
				</button>
				<button class="btn btn-success" type="button" id="next">
					<span>Далее</span>
				</button>
				<button class="btn btn-success hide" type="button" id="submit">
					<span>&nbsp;&nbsp;&nbsp;Лрвбавить&nbsp;&nbsp;&nbsp;</span>
				</button>
				<button class="btn btn-success hide disabled" type="button"
					id="confirm" data-dismiss="modal">
					<span>&nbsp;&nbsp;&nbsp;Подтвердить&nbsp;&nbsp;&nbsp;</span>
				</button>
			</div>
		</div>
	</div>
</div>

<div class="modal fade" id="export_modal" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Экспорт информации</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-3 col-sm-3" style="text-align: center;">
						<img src="media/icons/warning-icon.png" alt=""
							style="width: 70px; height: 70px; margin-top: 20px;">
					</div>
					<div class="col-md-8 col-sm-8">
						<h3>Экспорт складской информации</h3>
						<p>(Примечание: Пожалуйста, определите информацию хранилища, которая будет экспортирована. Экспортируемое содержимое является текущим списком результатов поиска.)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-success" type="button"
					id="export_repository_download">
					<span>Загрузить</span>
				</button>
			</div>
		</div>
	</div>
</div>

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
						<h3>Вы уверенны что хотите удалить информацию о складе?</h3>
						<p>( Примечание: Если есть входящие или исходящие записи или информация о складе, информация о складе не будет успешно удалена. Если вы хотите удалить информацию о складе, убедитесь, что нет информации связанной со складом.)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-danger" type="button" id="delete_confirm">
					<span>Удалить</span>
				</button>
			</div>
		</div>
	</div>
</div>


<div id="edit_modal" class="modal fade" table-index="-1" role="dialog"
	aria-labelledby="myModalLabel" aria-hidden="true"
	data-backdrop="static">
	<div class="modal-dialog">
		<div class="modal-content">
			<div class="modal-header">
				<button class="close" type="button" data-dismiss="modal"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="myModalLabel">Изменить информацию о складе</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-8 col-sm-8">
						<form class="form-horizontal" role="form" id="repository_form_edit"
							style="margin-top: 25px">
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Адрес склада：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="repository_address_edit"
										name="repository_address" placeholder="Адрес склада">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Складская площадь：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control"
										id="repository_area_edit" name="repository_area"
										placeholder="Складская площадь">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Состояние склада：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control"
										id="repository_status_edit" name="repository_status"
										placeholder="Состояние склада">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Описание склада：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<textarea class="form-control"
										id="repository_desc_edit" name="repository_desc"
										placeholder="Описание склада"></textarea>
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
					<span>Изменить</span>
				</button>
			</div>
		</div>
	</div>
</div>