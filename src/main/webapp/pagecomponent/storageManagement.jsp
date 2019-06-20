<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	var search_type_storage = "none";
	var search_keyWord = "";
	var search_repository = "";
	var select_goodsID;
	var select_repositoryID;

	$(function() {
		optionAction();
		searchAction();
		storageListInit();
		bootstrapValidatorInit();
		repositoryOptionInit();

		addStorageAction();
		editStorageAction();
		deleteStorageAction();
		importStorageAction();
		exportStorageAction()
	})


	function optionAction() {
		$(".dropOption").click(function() {
			var type = $(this).text();
			$("#search_input").val("");
			if (type == "Все") {
				$("#search_input_type").attr("readOnly", "true");
				search_type_storage = "searchAll";
			} else if (type == "ID Товара") {
				$("#search_input_type").removeAttr("readOnly");
				search_type_storage = "searchByGoodsID";
			} else if (type == "Наименование товара") {
				$("#search_input_type").removeAttr("readOnly");
				search_type_storage = "searchByGoodsName";
			} else if(type = "Тип товара"){
				$("#search_input_type").removeAttr("readOnly");
				search_type_storage = "searchByGoodsType";
			}else {
				$("#search_input_type").removeAttr("readOnly");
			}

			$("#search_type").text(type);
			$("#search_input_type").attr("placeholder", type);
		})
	}

	function repositoryOptionInit(){
		$.ajax({
			type : 'GET',
			url : 'repositoryManage/getRepositoryList',
			dataType : 'json',
			contentType : 'application/json',
			data:{
				searchType : "searchAll",
				keyWord : "",
				offset : -1,
				limit : -1
			},
			success : function(response){
				$.each(response.rows,function(index,elem){
					$('#search_input_repository').append("<option value='" + elem.id + "'>" + elem.id +"Номер склада</option>");
				})
			},
			error : function(response){
			}
		});
		$('#search_input_repository').append("<option value='all'>Пожалуйста, выберите склад</option>");
	}

	function searchAction() {
		$('#search_button').click(function() {
			search_keyWord = $('#search_input_type').val();
			search_repository = $('#search_input_repository').val();
			tableRefresh();
		})
	}

	function queryParams(params) {
		var temp = {
			limit : params.limit,
			offset : params.offset,
			searchType : search_type_storage,
			repositoryBelong : search_repository,
			keyword : search_keyWord
		}
		return temp;
	}

	function storageListInit() {
		$('#storageList')
				.bootstrapTable(
						{
							columns : [
									{
										field : 'goodsID',
										title : 'ID Товара'
									//sortable: true
									},
									{
										field : 'goodsName',
										title : 'Наименование товара'
									},
									{
										field : 'goodsType',
										title : 'Тип товара'
									},
									{
										field : 'goodsSize',
										title : 'Размер груза',
										visible : false
									},
									{
										field : 'goodsValue',
										title : 'Стоймость товара',
										visible : false
									},
									{
										field : 'repositoryID',
										title : 'ID Скада'
									},
									{
										field : 'number',
										title : 'Количество на складе'
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
											//rowEditOperation(row)
											'click .edit' : function(e, value,
													row, index) {
												//selectID = row.id;
												rowEditOperation(row);
											},
											'click .delete' : function(e,
													value, row, index) {
												select_goodsID = row.goodsID;
												select_repositoryID = row.repositoryID
												$('#deleteWarning_modal').modal(
														'show');
											}
										}
									} ],
							url : 'storageManage/getStorageListWithRepository',
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
		$('#storageList').bootstrapTable('refresh', {
			query : {}
		});
	}

	function rowEditOperation(row) {
		$('#edit_modal').modal("show");

		// load info
		$('#storage_form_edit').bootstrapValidator("resetForm", true);
		$('#storage_goodsID_edit').text(row.goodsID);
		$('#storage_repositoryID_edit').text(row.repositoryID);
		$('#storage_number_edit').val(row.number);
	}

	function bootstrapValidatorInit() {
		$("#storage_form").bootstrapValidator({
			message : 'This is not valid',
			feedbackIcons : {
				valid : 'glyphicon glyphicon-ok',
				invalid : 'glyphicon glyphicon-remove',
				validating : 'glyphicon glyphicon-refresh'
			},
			excluded : [ ':disabled' ],
			fields : {
				storage_goodsID : {
					validators : {
						notEmpty : {
							message : 'ID Товара не может быть пустым'
						}
					}
				},
				storage_repositoryID : {
					validators : {
						notEmpty : {
							message : 'ID Склада не может быть пустым'
						}
					}
				},
				storage_number : {
					validators : {
						notEmpty : {
							message : 'Количество не может быть пустым'
						}
					}
				}
			}
		})
	}

	function editStorageAction() {
		$('#edit_modal_submit').click(
				function() {
					$('#storage_form_edit').data('bootstrapValidator')
							.validate();
					if (!$('#storage_form_edit').data('bootstrapValidator')
							.isValid()) {
						return;
					}

					var data = {
						goodsID : $('#storage_goodsID_edit').text(),
						repositoryID : $('#storage_repositoryID_edit').text(),
						number : $('#storage_number_edit').val(),
					}

					// ajax
					$.ajax({
						type : "POST",
						url : 'storageManage/updateStorageRecord',
						dataType : "json",
						contentType : "application/json",
						data : JSON.stringify(data),
						success : function(response) {
							$('#edit_modal').modal("hide");
							var type;
							var msg;
							if (response.result == "success") {
								type = "success";
								msg = "Информация усепшно обновлена";
							} else if (resposne == "error") {
								type = "error";
								msg = "Не удалось обновить информацию"
							}
							infoModal(type, msg);
							tableRefresh();
						},
						error : function(response) {
						}
					});
				});
	}

	function deleteStorageAction(){
		$('#delete_confirm').click(function(){
			var data = {
				"goodsID" : select_goodsID,
				"repositoryID" : select_repositoryID
			}
			
			// ajax
			$.ajax({
				type : "GET",
				url : "storageManage/deleteStorageRecord",
				dataType : "json",
				contentType : "application/json",
				data : data,
				success : function(response){
					$('#deleteWarning_modal').modal("hide");
					var type;
					var msg;
					if(response.result == "success"){
						type = "success";
						msg = "Информация удалена успешно";
					}else{
						type = "error";
						msg = "Ошибка удаления информации";
					}
					infoModal(type, msg);
					tableRefresh();
				},error : function(response){
				}
			})
			
			$('#deleteWarning_modal').modal('hide');
		})
	}

	function addStorageAction() {
		$('#add_storage').click(function() {
			$('#add_modal').modal("show");
		});

		$('#add_modal_submit').click(function() {
			var data = {
				goodsID : $('#storage_goodsID').val(),
				repositoryID : $('#storage_repositoryID').val(),
				number : $('#storage_number').val()
			}
			// ajax
			$.ajax({
				type : "POST",
				url : "storageManage/addStorageRecord",
				dataType : "json",
				contentType : "application/json",
				data : JSON.stringify(data),
				success : function(response) {
					$('#add_modal').modal("hide");
					var msg;
					var type;
					if (response.result == "success") {
						type = "success";
						msg = "Информация добавлена успешно";
					} else if (response.result == "error") {
						type = "error";
						msg = "Ошибка добавления информации";
					}
					infoModal(type, msg);
					tableRefresh();

					// reset
					$('#storage_goodsID').val("");
					$('#storage_repositoryID').val("");
					$('#storage_number').val("");
					$('#storage_form').bootstrapValidator("resetForm", true);
				},
				error : function(response) {
				}
			})
		})
	}

	var import_step = 1;
	var import_start = 1;
	var import_end = 3;

	function importStorageAction() {
		$('#import_storage').click(function() {
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
				url : "storageManage/importStorageRecord",
				secureuri: false,
				dataType: 'json',
				fileElementId:"file",
				success : function(data, status){
					var total = 0;
					var available = 0;
					var msg1 = "Информация успешно импортирована";
					var msg2 = "Не удалось импортировать информацию";
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
					info = info + ",Общее количество：" + total + ",Номер:" + available;
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


	function exportStorageAction() {
		$('#export_storage').click(function() {
			$('#export_modal').modal("show");
		})

		$('#export_storage_download').click(function(){
			var data = {
				searchType : search_type_storage,
				repositoryBelong : search_repository,
				keyword : search_keyWord
			}
			var url = "storageManage/exportStorageRecord?" + $.param(data)
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
		<li>Управление</li>
	</ol>
	<div class="panel-body">
		<div class="row">
			<div class="col-md-1  col-sm-2">
				<div class="btn-group">
					<button class="btn btn-default dropdown-toggle"
						data-toggle="dropdown">
						<span id="search_type">Метод поиска</span> <span class="caret"></span>
					</button>
					<ul class="dropdown-menu" role="menu">
						<li><a href="javascript:void(0)" class="dropOption">ID Товара</a></li>
						<li><a href="javascript:void(0)" class="dropOption">Наименование товара</a></li>
						<li><a href="javascript:void(0)" class="dropOption">Тип товара</a></li>
						<li><a href="javascript:void(0)" class="dropOption">Все</a></li>
					</ul>
				</div>
			</div>
			<div class="col-md-9 col-sm-9">
				<div>
					<div class="col-md-3 col-sm-3">
						<input id="search_input_type" type="text" class="form-control"
							placeholder="ID Товара">
					</div>

					<div class="col-md-3 col-sm-4">
						<select class="form-control" id="search_input_repository">
						</select>
					</div>
					<div class="col-md-2 col-sm-2">
						<button id="search_button" class="btn btn-success">
							<span class="glyphicon glyphicon-search"></span> <span>Искать</span>
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="row" style="margin-top: 25px">
			<div class="col-md-5">
				<button class="btn btn-sm btn-default" id="add_storage">
					<span class="glyphicon glyphicon-plus"></span> <span>Добавить информацию об инвентаризации</span>
				</button>
				<button class="btn btn-sm btn-default" id="import_storage">
					<span class="glyphicon glyphicon-import"></span> <span>Импорт</span>
				</button>
				<button class="btn btn-sm btn-default" id="export_storage">
					<span class="glyphicon glyphicon-export"></span> <span>Экспорт</span>
				</button>
			</div>
			<div class="col-md-5"></div>
		</div>

		<div class="row" style="margin-top: 15px">
			<div class="col-md-12">
				<table id="storageList" class="table table-striped"></table>
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
				<h4 class="modal-title" id="myModalLabel">Добавить учетную запись</h4>
			</div>
			<div class="modal-body">

				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-8 col-sm-8">
						<form class="form-horizontal" role="form" id="storage_form"
							style="margin-top: 25px">
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>ID Товара：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="storage_goodsID"
										name="storage_goodsID" placeholder="ID Товара">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>ID Склада：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="storage_repositoryID"
										name="storage_repositoryID" placeholder="ID Склада">
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Количетво：</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="storage_number"
										name="storage_number" placeholder="Количество">
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
					<span>Предстваить</span>
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
				<h4 class="modal-title" id="myModalLabel">Импорт инвентарной информации</h4>
			</div>
			<div class="modal-body">
				<div id="step1">
					<div class="row" style="margin-top: 15px">
						<div class="col-md-1 col-sm-1"></div>
						<div class="col-md-10 col-sm-10">
							<div>
								<h4>Нажмите кнопку загрузки ниже, чтобы загрузить таблицу данных инвентаризации</h4>
							</div>
							<div style="margin-top: 30px; margin-buttom: 15px">
								<a class="btn btn-info"
									href="commons/fileSource/download/storageRecord.xlsx"
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
								<h4>Пожалуйста, заполните одну или несколько инвентарных данных, которые будут добавлены в формате, указанном в электронной таблице инвентарной информации.</h4>
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
									<h4>Нажмите кнопку «Загрузить файл» ниже, чтобы загрузить заполненную таблицу данных инвентаризации.</h4>
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
					<span>&nbsp;&nbsp;&nbsp;представить&nbsp;&nbsp;&nbsp;</span>
				</button>
				<button class="btn btn-success hide disabled" type="button"
					id="confirm" data-dismiss="modal">
					<span>&nbsp;&nbsp;&nbsp;подтвердить&nbsp;&nbsp;&nbsp;</span>
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
				<h4 class="modal-title" id="myModalLabel">Экспорт инвентарной информации</h4>
			</div>
			<div class="modal-body">
				<div class="row">
					<div class="col-md-3 col-sm-3" style="text-align: center;">
						<img src="media/icons/warning-icon.png" alt=""
							style="width: 70px; height: 70px; margin-top: 20px;">
					</div>
					<div class="col-md-8 col-sm-8">
						<h3>Подтвердите экспорт инвентарной информации</h3>
						<p>( Примечание: Пожалуйста, определите информацию инвентаризации, которая будет экспортирована, экспортированный контент - текущий список результатов поиска.)</p>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Отмена</span>
				</button>
				<button class="btn btn-success" type="button" id="export_storage_download">
					<span>Подтвердите загрузку</span>
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
					<span>&nbsp;&nbsp;&nbsp;Ок&nbsp;&nbsp;&nbsp;</span>
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
						<h3>Вы уверенны что хотите удалить данные о инвентаризации?</h3>
						<p>(Примечание: После удаления данных инвентаризации они не будут восстановлены.)</p>
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
				<h4 class="modal-title" id="myModalLabel">Изменить информацию о грузе</h4>
			</div>
			<div class="modal-body">

				<div class="row">
					<div class="col-md-1 col-sm-1"></div>
					<div class="col-md-8 col-sm-8">
						<form class="form-horizontal" role="form" id="storage_form_edit"
							style="margin-top: 25px">
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>ID Товара：</span>
								</label>
								<div class="col-md-4 col-sm-4">
									<p id="storage_goodsID_edit" class="form-control-static"></p>
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>ID Склада：</span>
								</label>
								<div class="col-md-4 col-sm-4">
									<p id="storage_repositoryID_edit" class="form-control-static"></p>
								</div>
							</div>
							<div class="form-group">
								<label for="" class="control-label col-md-4 col-sm-4"> <span>Количество</span>
								</label>
								<div class="col-md-8 col-sm-8">
									<input type="text" class="form-control" id="storage_number_edit"
										name="storage_number" placeholder="Количетсво на складе">
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
					<span>Подтвердите изменение</span>
				</button>
			</div>
		</div>
	</div>
</div>