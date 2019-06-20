<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<script>
	var search_type_storage = "none";
	var search_keyWord = "";
	var select_goodsID;
	var select_repositoryID;

	$(function() {
		optionAction();
		searchAction();
		storageListInit();

		exportStorageAction()
	})

	//Действие выбора выпадающего списка
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
			} else if(type = "Тип товара"){  //
				$("#search_input_type").removeAttr("readOnly");
				search_type_storage = "searchByGoodsType";
			}else {
				$("#search_input_type").removeAttr("readOnly");
			}

			$("#search_type").text(type);
			$("#search_input_type").attr("placeholder", type);
		})
	}


	function searchAction() {
		$('#search_button').click(function() {
			search_keyWord = $('#search_input_type').val();
			tableRefresh();
		})
	}


	function queryParams(params) {
		var temp = {
			limit : params.limit,
			offset : params.offset,
			searchType : search_type_storage,
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
										title : 'Стоимость товара',
										visible : false
									},
									{
										field : 'repositoryID',
										title : 'ID Склада',
										visible : false
									},
									{
										field : 'number',
										title : 'Количество на складе'
									},
									{
										field : 'operation',
										title : 'Операция',
										formatter : function(value, row, index) {
											var s = '<button class="btn btn-info btn-sm edit"><span>Детализация</span></button>';
											var fun = '';
											return s;
										},
										events : {
											'click .edit' : function(e, value,
													row, index) {
												rowDetailOperation(row);
											}
										}
									} ],
							url : 'storageManage/getStorageList',
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

	function rowDetailOperation(row) {
		$('#detail_modal').modal("show");

		// load info
		$('#storage_goodsID').text(row.goodsID);
		$('#storage_goodsName').text(row.goodsName);
		$('#storage_goodsType').text(row.goodsType);
		$('#storage_goodsSize').text(row.goodsSize);
		$('#storage_goodsValue').text(row.goodsValue);
		$('#storage_repositoryBelong').text(row.repositoryID);
		$('#storage_number').text(row.number);
	}

	function exportStorageAction() {
		$('#export_storage').click(function() {
			$('#export_modal').modal("show");
		})

		$('#export_storage_download').click(function(){
			var data = {
				searchType : search_type_storage,
				keyword : search_keyWord
			}
			var url = "storageManage/exportStorageRecord?" + $.param(data)
			window.open(url, '_blank');
			$('#export_modal').modal("hide");
		})
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
		<li>Управление инвентарем</li>
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
					<div class="col-md-2 col-sm-2">
						<button id="search_button" class="btn btn-success">
							<span class="glyphicon glyphicon-search"></span> <span>Искать</span>
						</button>
					</div>
				</div>
			</div>
		</div>

		<div class="row" style="margin-top: 25px">
			<div class="col-md-5 col-sm-5">
				<button class="btn btn-sm btn-default" id="export_storage">
					<span class="glyphicon glyphicon-export"></span> <span>Экспорт</span>
				</button>
			</div>
			<div class="col-md-5 col-sm-5"></div>
		</div>

		<div class="row" style="margin-top: 15px">
			<div class="col-md-12">
				<table id="storageList" class="table table-striped"></table>
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
						<p>(Примечание: Пожалуйста, определите информацию инвентаризации, которая будет экспортирована, экспортированный контент - текущий список результатов поиска.)</p>
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


<div id="detail_modal" class="modal fade" table-index="-1" role="dialog"
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
					<div class="col-md-12">
						<form class="form-horizontal" role="form" id="storage_detail"
							style="margin-top: 25px">
							<div class="row">
								<div class="col-md-6 col-sm-6">
									<div class="form-group">
										<label for="" class="control-label col-md-6 col-sm-6"> <span>ID Товара：</span>
										</label>
										<div class="col-md-4 col-sm-4">
											<p id="storage_goodsID" class="form-control-static"></p>
										</div>
									</div>
									<div class="form-group">
										<label for="" class="control-label col-md-6 col-sm-6"> <span>Наименование товара：</span>
										</label>
										<div class="col-md-4 col-sm-4">
											<p id="storage_goodsName" class="form-control-static"></p>
										</div>
									</div>
									<div class="form-group">
										<label for="" class="control-label col-md-6 col-sm-6"> <span>Тип товара：</span>
										</label>
										<div class="col-md-4 col-sm-4">
											<p id="storage_goodsType" class="form-control-static"></p>
										</div>
									</div>
									<div class="form-group">
										<label for="" class="control-label col-md-6 col-sm-6"> <span>Спецификация груза：</span>
										</label>
										<div class="col-md-4 col-sm-4">
											<p id="storage_goodsSize" class="form-control-static"></p>
										</div>
									</div>
								</div>
								<div class="col-md-6 col-sm-6">
									<div class="form-group">
										<label for="" class="control-label col-md-6 col-sm-6"> <span>Стоимость товара：</span>
										</label>
										<div class="col-md-4 col-sm-4">
											<p id="storage_goodsValue" class="form-control-static"></p>
										</div>
									</div>
									<div class="form-group">
										<label for="" class="control-label col-md-6 col-sm-6"> <span>скад хранения ID：</span>
										</label>
										<div class="col-md-4 col-sm-4">
											<p id="storage_repositoryBelong" class="form-control-static"></p>
										</div>
									</div>
									<div class="form-group">
										<label for="" class="control-label col-md-6 col-sm-6"> <span>Количество на складе：</span>
										</label>
										<div class="col-md-4 col-sm-4">
											<p id="storage_number" class="form-control-static"></p>
										</div>
									</div>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
			<div class="modal-footer">
				<button class="btn btn-default" type="button" data-dismiss="modal">
					<span>Назад</span>
				</button>
			</div>
		</div>
	</div>
</div>