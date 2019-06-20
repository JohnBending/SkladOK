<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
var stockin_repository = null;//Номер входящего склада
var stockin_supplier = null;//Номер входящего поставщика
var stockin_goods = null;//Номер входящего товара
var stockin_number = null;//Количество складских помещений

var supplierCache = new Array();// Кэш информации о поставщике
var goodsCache = new Array();//Кэш информации о грузе

$(function(){
	repositorySelectorInit();
	dataValidateInit();
	detilInfoToggle();

	stockInOption();
	fetchStorage();
	supplierAutocomplete();
	goodsAutocomplete();
})

// Проверка данных
function dataValidateInit(){
	$('#stockin_form').bootstrapValidator({
		message : 'This is not valid',
		
		fields : {
			stockin_input : {
				validators : {
					notEmpty : {
						message :'Количество складских помещений не может быть пустым'
					},
					greaterThan: {
                        value: 0,
                        message: 'Количество складских помещений не может быть меньше 0'
                    }
				}
			}
		}
	})
}

//Автоматическое сопоставление информации о грузе
function goodsAutocomplete(){
	$('#goods_input').autocomplete({
		minLength : 0,
		delay : 500,
		source : function(request, response){
			$.ajax({
				type : 'GET',
				url : 'goodsManage/getGoodsList',
				dataType : 'json',
				contentType : 'application/json',
				data : {
					offset : -1,
					limit : -1,
					keyWord : request.term,
					searchType : 'searchByName'
				},
				success : function(data){
					var autoCompleteInfo = new Array();
					$.each(data.rows, function(index,elem){
						goodsCache.push(elem);
						autoCompleteInfo.push({label:elem.name,value:elem.id});
					});
					response(autoCompleteInfo);
				}
			});
		},
		focus : function(event, ui){
			$('#goods_input').val(ui.item.label);
			return false;
		},
		select : function(event, ui){
			$('#goods_input').val(ui.item.label);
			stockin_goods = ui.item.value;
			goodsInfoSet(stockin_goods);
			loadStorageInfo();
			return false;
		}
	})
}

//Информация о поставщике автоматически сопоставляется
function supplierAutocomplete(){
	$('#supplier_input').autocomplete({
		minLength : 0,
		delay:500,
		source : function(request, response){
			$.ajax({
				type : "GET",
				url : 'supplierManage/getSupplierList',
				dataType : 'json',
				contentType : 'application/json',
				data : {
					offset : -1,
					limit : -1,
					searchType : 'searchByName',
					keyWord : request.term
				},
				success : function(data){
					var autoCompleteInfo = new Array();
					$.each(data.rows,function(index, elem){
						supplierCache.push(elem);
						autoCompleteInfo.push({label:elem.name,value:elem.id});
					});
					response(autoCompleteInfo);
				}
			});
		},
		focus : function(event, ui){
			$('#supplier_input').val(ui.item.label);
			return false;
		},
		select : function(event, ui){
			$('#supplier_input').val(ui.item.label);
			stockin_supplier = ui.item.value;
			supplierInfoSet(stockin_supplier);
			return false;
		}
	})
}

// Заполните данные о продавце
function supplierInfoSet(supplierID){
	var detailInfo;
	$.each(supplierCache,function(index,elem){
		if(elem.id == supplierID){
			detailInfo = elem;

			if(detailInfo.id==null)
				$('#info_supplier_ID').text('-');
			else
				$('#info_supplier_ID').text(detailInfo.id);
			
			if(detailInfo.name==null)
				$('#info_supplier_name').text('-');
			else
				$('#info_supplier_name').text(detailInfo.name);
			
			if(detailInfo.tel==null)
				$('#info_supplier_tel').text('-');
			else
				$('#info_supplier_tel').text(detailInfo.tel);
			
			if(detailInfo.personInCharge==null)
				$('#info_supplier_person').text('-');
			else
				$('#info_supplier_person').text(detailInfo.personInCharge);
			
			if(detailInfo.email==null)
				$('#info_supplier_email').text('-');
			else
				$('#info_supplier_email').text(detailInfo.email);
			
			
			if(detailInfo.adress==null)
				$('#info_supplier_address').text('-');
			else
				$('#info_supplier_address').text(detailInfo.address);
		}
	})

}

// Заполните детали груза
function goodsInfoSet(goodsID){
	var detailInfo;
	$.each(goodsCache,function(index,elem){
		if(elem.id == goodsID){
			detailInfo = elem;
			if(detailInfo.id==null)
				$('#info_goods_ID').text('-');
			else
				$('#info_goods_ID').text(detailInfo.id);
			
			if(detailInfo.name==null)
				$('#info_goods_name').text('-');
			else
				$('#info_goods_name').text(detailInfo.name);
			
			if(detailInfo.type==null)
				$('#info_goods_type').text('-');
			else
				$('#info_goods_type').text(detailInfo.type);
			
			if(detailInfo.size==null)
				$('#info_goods_size').text('-');
			else
				$('#info_goods_size').text(detailInfo.size);
			
			if(detailInfo.value==null)
				$('#info_goods_value').text('-');
			else
				$('#info_goods_value').text(detailInfo.value);
		}
	})
}

// Подробное отображение информации и сокрытие
function detilInfoToggle(){
	$('#info-show').click(function(){
		$('#detailInfo').removeClass('hide');
		$(this).addClass('hide');
		$('#info-hidden').removeClass('hide');
	});

	$('#info-hidden').click(function(){
		$('#detailInfo').removeClass('hide').addClass('hide');
		$(this).addClass('hide');
		$('#info-show').removeClass('hide');
	});
}

// Инициализация выпадающего списка склада
function repositorySelectorInit(){
	$.ajax({
		type : 'GET',
		url : 'repositoryManage/getRepositoryList',
		dataType : 'json',
		contentType : 'application/json',
		data : {
			searchType : 'searchAll',
			keyWord : '',
			offset : -1,
			limit : -1
		},
		success : function(response){
			$.each(response.rows,function(index,elem){
				$('#repository_selector').append("<option value='" + elem.id + "'>" + elem.id +"номер склада</option>");
			});
		},
		error : function(response){
			$('#repository_selector').append("<option value='-1'>Ошибка</option>");
		}
		
	})
}

// Получить текущий инвентарь склада
function fetchStorage(){
	$('#repository_selector').change(function(){
		stockin_repository = $(this).val();
		loadStorageInfo();
	});
}

function loadStorageInfo(){
	if(stockin_repository != null && stockin_goods != null){
		$.ajax({
			type : 'GET',
			url : 'storageManage/getStorageListWithRepository',
			dataType : 'json',
			contentType : 'application/json',
			data : {
				offset : -1,
				limit : -1,
				searchType : 'searchByGoodsID',
				repositoryBelong : stockin_repository,
				keyword : stockin_goods
			},
			success : function(response){
				if(response.total > 0){
					data = response.rows[0].number;
					$('#info_storage').text(data);
				}else{
					$('#info_storage').text('0');
				}
			},
			error : function(response){
				
			}
		})
	}
}

//Выполнить грузовые складские операции
function stockInOption(){
	$('#submit').click(function(){
		// data validate
		$('#stockin_form').data('bootstrapValidator').validate();
		if (!$('#stockin_form').data('bootstrapValidator').isValid()) {
			return;
		}

		data = {
			repositoryID : stockin_repository,
			supplierID : stockin_supplier,
			goodsID : stockin_goods,
			number : $('#stockin_input').val(),
		}

		$.ajax({
			type : 'POST',
			url : 'stockRecordManage/stockIn',
			dataType : 'json',
			content : 'application/json',
			data : data,
			success : function(response){
				var msg;
				var type;
				
				if(response.result == "success"){
					type = 'success';
					msg = 'Успешно';
					inputReset();
				}else{
					type = 'error';
					msg = 'Ошибка'
				}
				infoModal(type, msg);
			},
			error : function(response){
				var msg = "Ошибка сервера";
				var type = "error";
				infoModal(type, msg);
			}
		})
	});
}

// резет страницы
function inputReset(){
	$('#supplier_input').val('');
	$('#goods_input').val('');
	$('#stockin_input').val('');
	$('#info_supplier_ID').text('-');
	$('#info_supplier_name').text('-');
	$('#info_supplier_tel').text('-');
	$('#info_supplier_address').text('-');
	$('#info_supplier_email').text('-');
	$('#info_supplier_person').text('-');
	$('#info_goods_ID').text('-');
	$('#info_goods_name').text('-');
	$('#info_goods_size').text('-');
	$('#info_goods_type').text('-');
	$('#info_goods_value').text('-');
	$('#info_storage').text('-');
	$('#stockin_form').bootstrapValidator("resetForm",true); 
}

//подсказака результата операции
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
						<li>Хранение товаров</li>
					</ol>
					<div class="panel-body">
						<div class="row">
							<div class="col-md-6 col-sm-6">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-10 col-sm-11">
										<form action="" class="form-inline">
											<div class="form-group">
												<label for="" class="form-label">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Поставщики：</label>
												<input type="text" class="form-control" id="supplier_input" placeholder="Пожалуйста, введите название поставщика">
											</div>
										</form>
									</div>
								</div>
							</div>
							<div class="col-md-6 col-sm-6">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-10 col-sm-11">
										<form action="" class="form-inline">
											<div class="form-group">
												<label for="" class="form-label">Входящие товары：</label>
												<input type="text" class="form-control" id="goods_input" placeholder="Пожалуйста, введите название товара">
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
						<div class="row visible-md visible-lg">
							<div class="col-md-12 col-sm-12">
								<div class='pull-right' style="cursor:pointer" id="info-show">
									<span>Показать детали</span>
									<span class="glyphicon glyphicon-chevron-down"></span>
								</div>
								<div class='pull-right hide' style="cursor:pointer" id="info-hidden">
									<span>Скрыть детали</span>
									<span class="glyphicon glyphicon-chevron-up"></span>
								</div>
							</div>
						</div>
						<div class="row hide" id="detailInfo" style="margin-bottom:30px">
							<div class="col-md-6 col-sm-6  visible-md visible-lg">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-10 col-sm-10">
										<label for="" class="text-info">Информация о поставщике</label>
									</div>
								</div>
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-11 col-sm-11">
										<div class="col-md-6 col-sm-6">
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">ID поставщика：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_supplier_ID">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Ответственное лицо：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_supplier_person">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Электронная почта：</span>
												</div>
												<div class="col-md-6">
													<span id="info_supplier_email">-</span>
												</div>
											</div>
										</div>
										<div class="col-md-6 col-sm-6  visible-md visible-lg">
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Название поставщика：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_supplier_name">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Контактный номер：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_supplier_tel">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Контактный адрес：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_supplier_address">-</span>
												</div>
											</div>

										</div>
									</div>
								</div>
							</div>
							<div class="col-md-6 col-sm-6">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-11 col-sm-11">
										<label for="" class="text-info">Информация о грузе</label>
									</div>
								</div>
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-11 col-sm-11">
										<div class="col-md-6 col-sm-6">
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Идентификатор груза：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_goods_ID">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Тип товара：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_goods_type">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Наименование товара：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_goods_name">-</span>
												</div>
											</div>
										</div>
										<div class="col-md-6 col-sm-6">
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Спецификация груза：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_goods_size">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6 col-sm-6">
													<span for="" class="pull-right">Стоимость товара：</span>
												</div>
												<div class="col-md-6 col-sm-6">
													<span id="info_goods_value">-</span>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row" style="margin-top: 10px">
							<div class="col-md-6 col-sm-6">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-10 col-sm-11">
										<form action="" class="form-inline">
											<div class="form-group">
												<label for="" class="form-label">Входящий склад：</label>
												<select name="" id="repository_selector" class="form-control">
													<option value="">Пожалуйста, выберите склад</option>
												</select>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
						<div class="row" style="margin-top:20px">
							<div class="col-md-6 col-sm-6">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-10 col-sm-11">
										<form action="" class="form-inline" id="stockin_form">
											<div class="form-group">
												<label for="" class="control-label">Количество складских помещений：</label>
												<input type="text" class="form-control" placeholder="Пожалуйста, введите количество" id="stockin_input" name="stockin_input">
												<span>(Текущий запас：</span>
												<span id="info_storage">-</span>
												<span>)</span>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
						<div class="row" style="margin-top:80px"></div>
					</div>
					<div class="panel-footer">
						<div style="text-align:right">
							<button class="btn btn-success" id="submit">Подано на склад</button>
						</div>
					</div>
				</div>
				<!-- подсказка -->
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