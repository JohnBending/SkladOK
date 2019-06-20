<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<script>
var stockout_repository = null;
var stockout_customer = null;
var stockout_goods = null;
var stockout_number = null;

var customerCache = new Array();
var goodsCache = new Array();

$(function(){
	dataValidateInit();
	repositorySelectorInit();
	detilInfoToggle();
	stockoutOperation();

	fetchStorage();
	goodsAutocomplete();
	customerAutocomplete();
})

function dataValidateInit(){
	$('#stockout_form').bootstrapValidator({
		message : 'This is not valid',
		
		fields : {
			stockout_input : {
				validators : {
					notEmpty : {
						message : 'Количество складских помещений не может быть пустым'
					},
					greaterThan: {
                        value: 0,
                        message: 'Количество складских помещений не может быть меньше 0'
                    }
				}
			}
		}
	});
}

//Автоматическое сопоставление
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
			stockout_goods = ui.item.value;
			goodsInfoSet(stockout_goods);
			loadStorageInfo();
			return false;
		}
	})
}

function customerAutocomplete(){
	$('#customer_input').autocomplete({
		minLength : 0,
		delay : 500,
		source : function(request, response){
			$.ajax({
				type : 'GET',
				url : 'customerManage/getCustomerList',
				dataType : 'json',
				contentType : 'application/json',
				data : {
					offset : -1,
					limit : -1,
					keyWord : request.term,
					searchType : 'searchByName'
				},
				success : function(data){
					var autoCompleteInfo = Array();
					$.each(data.rows,function(index,elem){
						customerCache.push(elem);
						autoCompleteInfo.push({label:elem.name,value:elem.id});
					});
					response(autoCompleteInfo);
				}
			});
		},
		focus : function(event,ui){
			$('#customer_input').val(ui.item.label);
			return false;
		},
		select : function(event,ui){
			$('#customer_input').val(ui.item.label);
			stockout_customer = ui.item.value;
			customerInfoSet(stockout_customer);
			loadStorageInfo();
			return false;
		}
	})
}

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

function customerInfoSet(customerID){
	var detailInfo;
	$.each(customerCache,function(index,elem){
		if(elem.id == customerID){
			detailInfo = elem;

			if(detailInfo.id == null)
				$('#info_customer_ID').text('-');
			else
				$('#info_customer_ID').text(detailInfo.id);
			
			if(detailInfo.name == null)
				$('#info_customer_name').text('-');
			else
				$('#info_customer_name').text(detailInfo.name);
			
			if(detailInfo.tel == null)
				$('#info_customer_tel').text('-');
			else
				$('#info_customer_tel').text(detailInfo.tel);
			
			if(detailInfo.address == null)
				$('#info_customer_address').text('-');
			else
				$('#info_customer_address').text(detailInfo.address);
			
			if(detailInfo.email == null)
				$('#info_customer_email').text('-');
			else
				$('#info_customer_email').text(detailInfo.email);
			
			if(detailInfo.personInCharge == null)
				$('#info_customer_person').text('-');
			else
				$('#info_customer_person').text(detailInfo.personInCharge);
				
		}
	})
}

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

//Инициализация выпадающего списка
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
				$('#repository_selector').append("<option value='" + elem.id + "'>" + elem.id +"Номер склада</option>");
			});
		},
		error : function(response){
			$('#repository_selector').append("<option value='-1'>Загрузка не удалась</option>");
		}
		
	})
}

function fetchStorage(){
	$('#repository_selector').change(function(){
		stockout_repository = $(this).val();
		loadStorageInfo();
	});
}

function loadStorageInfo(){
	if(stockout_repository != null && stockout_goods != null){
		$.ajax({
			type : 'GET',
			url : 'storageManage/getStorageListWithRepository',
			dataType : 'json',
			contentType : 'application/json',
			data : {
				offset : -1,
				limit : -1,
				searchType : 'searchByGoodsID',
				repositoryBelong : stockout_repository,
				keyword : stockout_goods
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

//Выполнить операцию
function stockoutOperation(){
	$('#submit').click(function(){
		// data validate
		$('#stockout_form').data('bootstrapValidator').validate();
		if (!$('#stockout_form').data('bootstrapValidator').isValid()) {
			return;
		}

		data = {
			customerID : stockout_customer,
			goodsID : stockout_goods,
			repositoryID : stockout_repository,
			number : $('#stockout_input').val(),
		}

		$.ajax({
			type : 'POST',
			url : 'stockRecordManage/stockOut',
			dataType : 'json',
			content : 'application/json',
			data : data,
			success : function(response){
				var msg;
				var type;
				
				if(response.result == "success"){
					type = 'success';
					msg = 'Успешно!';
					inputReset();
				}else{
					type = 'error';
					msg = 'Ошибка!'
				}
				infoModal(type, msg);
			},
			error : function(response){
				var msg = "Оштбка сервера!";
				var type = "error";
				infoModal(type, msg);
			}
		})
	});
}

function inputReset(){
	$('#customer_input').val('');
	$('#goods_input').val('');
	$('#stockout_input').val('');
	$('#info_customer_ID').text('-');
	$('#info_customer_name').text('-');
	$('#info_customer_tel').text('-');
	$('#info_customer_address').text('-');
	$('#info_customer_email').text('-');
	$('#info_customer_person').text('-');
	$('#info_goods_ID').text('-');
	$('#info_goods_name').text('-');
	$('#info_goods_size').text('-');
	$('#info_goods_type').text('-');
	$('#info_goods_value').text('-');
	$('#info_storage').text('-');
	$('#stockout_form').bootstrapValidator("resetForm",true); 
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
						<li>Товары со склада</li>
					</ol>
					<div class="panel-body">
						<div class="row">
							<div class="col-md-6 col-sm-6">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-10 col-sm-11">
										<form action="" class="form-inline">
											<div class="form-group">
												<label for="" class="form-label">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;клиент：</label>
												<input type="text" class="form-control" id="customer_input" placeholder="Пожалуйста, введите имя клиента">
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
												<label for="" class="form-label">Исходящие товары：</label>
												<input type="text" class="form-control" id="goods_input" placeholder="Пожалуйста, введите название товара">
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
						<div class="row visible-md visible-lg">
							<div class="col-md-12">
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
							<div class="col-md-6  visible-md visible-lg">
								<div class="row">
									<div class="col-md-1"></div>
									<div class="col-md-10">
										<label for="" class="text-info">Информация для клиентов</label>
									</div>
								</div>
								<div class="row">
									<div class="col-md-1"></div>
									<div class="col-md-11">
										<div class="col-md-6">
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">ID Клиента：</span>
												</div>
												<div class="col-md-6">
													<span id="info_customer_ID">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">Ответсвенное лицо：</span>
												</div>
												<div class="col-md-6">
													<span id="info_customer_person">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">电子邮件：</span>
												</div>
												<div class="col-md-6">
													<span id="info_customer_email">-</span>
												</div>
											</div>
										</div>
										<div class="col-md-6">
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">Электронная почта：</span>
												</div>
												<div class="col-md-6">
													<span id="info_customer_name">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">Контактный номер：</span>
												</div>
												<div class="col-md-6">
													<span id="info_customer_tel">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">Контактный адрес：</span>
												</div>
												<div class="col-md-6">
													<span id="info_customer_address">-</span>
												</div>
											</div>

										</div>
									</div>
								</div>
							</div>
							<div class="col-md-6 col-sm-6  visible-md visible-lg">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-11 col-sm-11">
										<label for="" class="text-info">Информация о грузе</label>
									</div>
								</div>
								<div class="row">
									<div class="col-md-1"></div>
									<div class="col-md-11">
										<div class="col-md-6">
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">ID Груза：</span>
												</div>
												<div class="col-md-6">
													<span id="info_goods_ID">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">Тип товара：</span>
												</div>
												<div class="col-md-6">
													<span id="info_goods_type">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">Наименование товара：</span>
												</div>
												<div class="col-md-6">
													<span id="info_goods_name">-</span>
												</div>
											</div>
										</div>
										<div class="col-md-6">
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">Спецификация груза：</span>
												</div>
												<div class="col-md-6">
													<span id="info_goods_size">-</span>
												</div>
											</div>
											<div style="margin-top:5px">
												<div class="col-md-6">
													<span for="" class="pull-right">Стоимость товара：</span>
												</div>
												<div class="col-md-6">
													<span id="info_goods_value">-</span>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
						<div class="row" style="margin-top:10px">
							<div class="col-md-6 col-sm-6">
								<div class="row">
									<div class="col-md-1 col-sm-1"></div>
									<div class="col-md-10 col-sm-11">
										<form action="" class="form-inline">
											<div class="form-group">
												<label for="" class="form-label">Исходящий склад：</label>
												<!--
												<input type="text" class="form-control" placeholder="Номер склада">
											-->
												<select name="" id="repository_selector" class="form-control">
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
										<form action="" class="form-inline" id="stockout_form">
											<div class="form-group">
												<label for="" class="form-label">Количество исходящих：</label>
												<input type="text" class="form-control" placeholder="Пожалуйста, введите количество" id="stockout_input" name="stockout_input">
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
							<button class="btn btn-success" id="submit">Отправить из библиотеки</button>
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