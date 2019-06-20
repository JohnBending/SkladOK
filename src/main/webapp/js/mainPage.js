$(function() {
	menuClickAction();
	welcomePageInit();
	signOut();
	getRequestPrefix();
	homePage();
});

function getRequestPrefix(){
	requestPrefix = $('#requestPrefix').text();
}

function welcomePageInit(){
	$('#panel').load('pagecomponent/welcomePage.jsp');
}

function homePage(){
	$('.home').click(function(){
		$('#panel').load('pagecomponent/welcomePage.jsp');
	})
}

function menuClickAction() {
	$(".menu_item").click(function() {
		var url = $(this).attr("name");
		$('#panel').load(url);
	})
}

function signOut() {
	$("#signOut").click(function() {
		$.ajax({
			type : "GET",
			url : "account/logout",
			dataType : "json",
			contentType : "application/json",
			success:function(response){
				window.location.reload(true);
			},error:function(response){
				
			}
		})
	})
}