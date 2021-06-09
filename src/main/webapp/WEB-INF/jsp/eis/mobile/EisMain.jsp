<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@page import="org.apache.ibatis.annotations.Param"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%
	LoginVO loginVO = (LoginVO)session.getAttribute("LoginVO");
  String authCode = loginVO.getAuthCode();
  
  /* Image Path 설정 */
  String imagePath_icon   = "/images/egovframework/sym/mpm/icon/";
  String imagePath_button = "/images/egovframework/sym/mpm/button/";
%>
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/custom_mobile.css'/>" />
<html>
<head>
<title>${pageTitle}</title>

<style>
.shadow {
	-webkit-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
	-moz-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
	box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
}

.h:HOVER {
	background-color: highlight;
}

.blue {
	background-color: #003399;
	color: white;
}

.blue2 {
	background-color: #5B9BD5;
	color: white;
}

.gray:HOVER {
	background-color: #EAEAEA;
}

.gray {
	background-color: #BDBDBD;
	color: black;
}

.white:HOVER {
	background-color: #FFFFFF;
	color: black;
}

.white {
	background-color: #000000;
	color: white;
}

.yellow:HOVER {
	background-color: #FFFF7E;
}

.yellow {
	background-color: yellow;
	color: black;
}

.red:HOVER {
	background-color: #FFD8D8;
}

.red {
	background-color: #FFA7A7;
	color: black;
}

.r {
	border-radius: 4px 4px 4px 4px;
	-moz-border-radius: 4px 4px 4px 4px;
	-webkit-border-radius: 4px 4px 4px 4px;
	border: 0px solid #000000;
}

.ui-autocomplete {
	max-height: 420px;
	overflow-y: auto;
	/* prevent horizontal scrollbar */
	overflow-x: hidden;
}

* html .ui-autocomplete {
	/* IE 6.0 */
	height: 420px;
}

.ERPQTY  .x-column-header-text {
	margin-right: 0px;
}

ul {
	text-align: center;
    align-items: center;
}

ul li {
	display: inline-block;
	line-height: 28px;
	margin: 0;
	height: 280px;
}

body {
	background-color: rgb(153, 204, 255) !important;
}
</style>
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();

    setReadOnly();

    setLovList();

    setLastInitial();

});

function setInitial() {
    var groupid = "${searchVO.groupId}";
    switch (groupid) {
    case "ROLE_ADMIN":
        // 관리자 권한일 때 이전화면 버튼 표기
        $('#btn_back').css("visibility", "visible");
        break;
    default:
        // 관리자 외 권한일 때 이전화면 버튼 숨김
        $('#btn_back').css("visibility", "hidden");
        break;
    }

    fn_menu_search();
}

function setLastInitial() {
    window.addEventListener('resize', function (event) {
        fn_calc_blank_space();
    });
    fn_calc_blank_space();
}

function fn_menu_search() {
    var part = location.pathname.split("/");
    var url = "/" + part[1] + '/searchMobileMenuLov.do';

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        async: false,
        data: "",
        success: function (data) {
            var count = data.totcnt * 1;

            if (count > 0) {
                for (var i = 0; i < count; i++) {
                    var dataList = data.data[i];

                    var menuurl = dataList.MENUURL;
                    var menutype = dataList.MENUTYPE;
                    var menusrc = dataList.MENUSRC;
                    var label = dataList.LABEL;

                    fn_list_create(menuurl, menutype, menusrc, label);
                }
            }
        },
        error: ajaxError
    });
}

function fn_calc_blank_space() {
    var height = window.innerHeight;
    var ul_height = $('#ul_list').height();
    var calc_height = Math.ceil(Math.abs(height - ul_height) * 0.5);
    $('#blank_area1').css("height", calc_height);
    $('#blank_area2').css("height", calc_height);
}

function fn_list_create(url, type, src, label) {
    var list_code = '<li onclick="' + url + '">';
    list_code += '<svg width="200" height="200">';
    list_code += '<defs>';
    list_code += '<linearGradient id="grad' + type + '" x1="0%" y1="50%" x2="100%" y2="100%">';
    list_code += '<stop offset="35%" style="stop-color: rgb(189, 189, 189); stop-opacity: 1; " />';
    list_code += '<stop offset="100%" style="stop-color: rgb(248, 248, 248); stop-opacity: 1; " />';
    list_code += '</linearGradient>';
    list_code += '</defs>';
    list_code += '<circle cx="100" cy="100" r="90" stroke="#F9F9F9" stroke-width="2" fill="url(#grad' + type + ')" />';
    list_code += '<image xlink:href="' + '<c:url value="/' + src + '" />" x="33" y="35" height="130px" width="130px" style="filter: drop-shadow(7px 7px 7px #000)" />';
    list_code += '</svg>';
    list_code += '<br />';
    list_code += '<strong style="font-size: 25px; text-shadow: 1px 1px 1px white;">' + label + '</strong>';
    list_code += '</li>';

    $('#ul_list').append(list_code);
}

function fn_goMovePage(flag) {
    switch (flag) {
    case 1:
    case 2:
    case 3:
    case 4:
        go_url('<c:url value="/eis/mobile/EisDetail.do?num=' + flag + '" />');
        break;
    default:
        fn_ready();
        break;
    }
}

function fn_back() {
    go_url('<c:url value="/eis/EisSynthesisSummary.do?mobileYn=Y" />');
}

function fn_logout() {
//     localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

function fn_ready() {
    extToastView("준비중입니다...");
}

function setLovList() {
    //
}

function setReadOnly() {
    $("[readonly]").addClass("ui-state-disabled");
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
		<div id="blank_area1"></div>
		<ul id="ul_list"></ul>
    <div id="blank_area2"></div>
		<div style="width: 100%; height: 70px; background-color: rgb(153, 204, 255); position: fixed; top: calc(100% - 60px); left: 0px;">
				<button type="button" class="mobile_back" id="btn_back" onclick="fn_back();" style="width: 50px; height: 100%; float: left; display: block; visibility: hidden;"></button>
				<center style="width: calc(100% - 100px); height: 100%; font-size: 35px; line-height: 35px; font-weight: bold; margin-top: 13px; float: left;">메뉴 선택</center>
				<button type="button" class="mobile_logout" id="btn_logout" onclick="fn_logout();" style="width: 50px; height: 100%; float: left;"></button>
		</div>
</body>
</html>