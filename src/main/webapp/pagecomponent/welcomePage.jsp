<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!--***************************** Страница быстрого доступа********************************-->
<script>
$(function(){
	quickAccessInit();
})

function quickAccessInit(){

	$('.shortcut').click(function(){
		var title = $(this).find('.title').text();
		var url = $('.menu_item:contains('+ title + ')').attr('name');
		$('#panel').load(url);
	})
}
</script>
				<div class="panel panel-default">

					<ol class="breadcrumb">
						<li>Быстрое управление</li>
					</ol>

					<div class="panel-body">
						<div class="row" style="margin-top: 100px; margin-bottom: 100px">
							<div class="col-md-1"></div>
							<div class="col-md-10" style="text-align: center">

								<div class="col-md-4 col-sm-4">
									<a href="javascript:void(0)" class="thumbnail shortcut"> <img
										src="media/icons/stock_search-512.png" alt="Инвентаризация"
										class="img-rounded link" style="width: 150px; height: 150px;">
										<div class="caption">
											<h3 class="title">Инвентаризация</h3>
										</div>
									</a>
								</div>
								<div class="col-md-4 col-sm-4">

									<a href="javascript:void(0)" class="thumbnail shortcut"> <img
										src="media/icons/stock_in-512.png" alt="Поступление"
										class="img-rounded link" style="width: 150px; height: 150px;">
										<div class="caption">
											<h3 class="title">Поступление</h3>
										</div>
									</a>
								</div>
								<div class="col-md-4 col-sm-4">
									<a href="javascript:void(0)" class="thumbnail shortcut"> <img
										src="media/icons/stock_out-512.png" alt="Отгрузка"
										class="img-rounded link" style="width: 150px; height: 150px;">
										<div class="caption">
											<h3 class="title">Отгрузка</h3>
										</div>
									</a>
								</div>
							</div>
							<div class="col-md-1"></div>
						</div>
					</div>
				</div>
