<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Склад v.0.12</title>
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/css/bootstrap.min.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/css/bootstrap-table.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/css/bootstrap-datetimepicker.min.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/css/jquery-ui.css">
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/css/mainPage.css">
</head>
<body>

<!-- Панель навигации -->
<div id="navBar">
    <nav class="navbar navbar-default navbar-fixed-top" role="navigation">
        <div class="container-fluid">
            <div class="navbar-header">
                <a href="javascript:void(0)" class="navbar-brand home">СкладОК v.0.12</a>
            </div>

            <div>
                <ul class="nav navbar-nav navbar-right">
                    <li class="dropdown">
                        <a href="#" class="dropdown-toggle"
                           data-toggle="dropdown"> <span class="glyphicon glyphicon-user"></span>
                            <span id="nav_userName">Имя пользователя:${sessionScope.userName}</span>
                            <span class="caret"></span>
                        </a>
                        <ul class="dropdown-menu">
                            <shiro:hasRole name="commonsAdmin">
                                <li>
                                    <a href="#" id="editInfo"> <span
                                            class="glyphicon glyphicon-pencil"></span> &nbsp;&nbsp;Изменить личную информацию</a></li>
                            </shiro:hasRole>
                            <li>
                                <a href="javascript:void(0)" id="signOut"> <span
                                        class="glyphicon glyphicon-off"></span> &nbsp;&nbsp;Выход
                                </a>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </div>
    </nav>
</div>

<div class="container-fluid" style="padding-left: 0px;">
    <div class="row">
        <!-- Левая панель навигации -->
        <div id="sideBar" class="col-md-2 col-sm-3">

            <div class="panel-group" id="accordion">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <!--<a> Ссылка на div, класс которого является collapse1, т.е. управление запасами и управление входящими и исходящими -->
                            <a href="#collapse1" data-toggle="collapse" data-parent="#accordion"
                               class="parentMenuTitle collapseHead">Управление остатками</a>
                            <div class="pull-right">
                                <span class="caret"></span>
                            </div>
                        </h4>
                    </div>
                    <div id="collapse1" class="panel-collapse collapse collapseBody">
                        <div class="panel-body">
                            <ul class="list-group">
                                <!--Если это обычный админ-->
                                <shiro:hasRole name="commonsAdmin">
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/storageManagementCommon.jsp">Инвентаризация</a>
                                    </li>
                                </shiro:hasRole>
                                <!--Если это супер админ-->
                                <shiro:hasRole name="systemAdmin">
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/storageManagement.jsp">Инвентаризация</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id=""
                                           class="menu_item"
                                           name="pagecomponent/stockRecordManagement.html">Входящие и исходящие записи</a>
                                    </li>
                                </shiro:hasRole>
                            </ul>
                        </div>
                    </div>
                </div>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a href="#collapse2" data-toggle="collapse" data-parent="#accordion"
                               class="parentMenuTitle collapseHead">Входящее и исходящее управление</a>
                            <div class="pull-right">
                                <span class="caret"></span>
                            </div>
                        </h4>
                    </div>
                    <div id="collapse2" class="panel-collapse collapse collapseBody in">
                        <div class="panel-body">
                            <shiro:hasRole name="systemAdmin">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/stock-inManagement.jsp">Поступление</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/stock-outManagement.jsp">Отгрузка</a>
                                    </li>
                                </ul>
                            </shiro:hasRole>
                            <shiro:hasRole name="commonsAdmin">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="#">Поступление</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="#">Отгрузка</a>
                                    </li>
                                </ul>
                            </shiro:hasRole>
                        </div>
                    </div>
                </div>
                <shiro:hasRole name="systemAdmin">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a href="#collapse3" data-toggle="collapse" data-parent="#accordion"
                                   class="parentMenuTitle collapseHead">Управление персоналом</a>
                                <div class="pull-right	">
                                    <span class="caret"></span>
                                </div>
                            </h4>
                        </div>
                        <div id="collapse3" class="panel-collapse collapse collapseBody">
                            <div class="panel-body">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/repositoryAdminManagement.jsp">Управление администраторами склада</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </shiro:hasRole>
                <shiro:hasRole name="systemAdmin">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">
                                <a href="#collapse4" data-toggle="collapse" data-parent="#accordion"
                                   class="parentMenuTitle collapseHead">Основные данные</a>
                                <div class="pull-right	">
                                    <span class="caret"></span>
                                </div>
                            </h4>
                        </div>
                        <div id="collapse4" class="panel-collapse collapse collapseBody">
                            <div class="panel-body">
                                <ul class="list-group">
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/supplierManagement.jsp">Управление информацией о поставщиках</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/customerManagement.jsp">Управление информацией о клиентах</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/goodsManagement.jsp">Управление грузовой информацией</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id="" class="menu_item"
                                           name="pagecomponent/repositoryManagement.jsp">Управление складской информацией</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </shiro:hasRole>
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">
                            <a href="#collapse5" data-toggle="collapse" data-parent="#accordion"
                               class="parentMenuTitle collapseHead">Обслуживание системы</a>
                            <div class="pull-right	"><span class="caret"></span></div>
                        </h4>
                    </div>
                    <div id="collapse5" class="panel-collapse collapse collapseBody">
                        <div class="panel-body">
                            <ul class="list-group">
                                <li class="list-group-item">
                                    <a href="javascript:void(0)" id="" class="menu_item"
                                       name="pagecomponent/passwordModification.jsp">Сменить пароль</a>
                                </li>
                                <shiro:hasRole name="systemAdmin">
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id=""
                                           class="menu_item" name="pagecomponent/userOperationRecorderManagement.html">Системный журнал</a>
                                    </li>
                                    <li class="list-group-item">
                                        <a href="javascript:void(0)" id=""
                                           class="menu_item" name="pagecomponent/accessRecordManagement.html">Вход в систему</a>
                                    </li>
                                </shiro:hasRole>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div id="panel" class="col-md-10 col-sm-9">


            <%--<div class="panel-body">--%>
            <%--<div class="row" style="margin-top: 100px; margin-bottom: 100px">--%>
            <%--<div class="col-md-1"></div>--%>
            <%--<div class="col-md-10" style="text-align: center">--%>
            <%--<div class="col-md-4 col-sm-4">--%>
            <%--<a href="javascript:void(0)" class="thumbnail shortcut"> <img--%>
            <%--src="media/icons/stock_search-512.png" alt="Инвентаризация"--%>
            <%--class="img-rounded link" style="width: 150px; height: 150px;">--%>
            <%--<div class="caption">--%>
            <%--<h3 class="title">Инвентаризация</h3>--%>
            <%--</div>--%>
            <%--</a>--%>
            <%--</div>--%>
            <%--<div class="col-md-4 col-sm-4">--%>
            <%--<a href="javascript:void(0)" class="thumbnail shortcut"> <img--%>
            <%--src="media/icons/stock_in-512.png" alt="Хранение товаров"--%>
            <%--class="img-rounded link" style="width: 150px; height: 150px;">--%>
            <%--<div class="caption">--%>
            <%--<h3 class="title">Хранение товаров</h3>--%>
            <%--</div>--%>
            <%--</a>--%>
            <%--</div>--%>
            <%--<div class="col-md-4 col-sm-4">--%>
            <%--<a href="javascript:void(0)" class="thumbnail shortcut"> <img--%>
            <%--src="media/icons/stock_out-512.png" alt="Товары со склада"--%>
            <%--class="img-rounded link" style="width: 150px; height: 150px;">--%>
            <%--<div class="caption">--%>
            <%--<h3 class="title">Товары со склада</h3>--%>
            <%--</div>--%>
            <%--</a>--%>
            <%--</div>--%>
            <%--</div>--%>
            <%--<div class="col-md-1"></div>--%>
            <%--</div>--%>
            <%--</div>--%>
            <%--</div>--%>

            <!-- end -->
        </div>
    </div>
</div>

<span id="requestPrefix" class="hide">${sessionScope.requestPrefix}</span>

<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/jquery-2.2.3.min.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/jquery-ui.min.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/bootstrapValidator.min.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/bootstrap-table.min.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/bootstrap-table-ru-RU.min.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/jquery.md5.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/mainPage.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/ajaxfileupload.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/bootstrap-datetimepicker.min.js"></script>
<script type="text/javascript"
        src="${pageContext.request.contextPath}/js/bootstrap-datetimepicker.ru-RU.js"></script>
</body>
</html>