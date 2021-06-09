<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
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
</style>
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();
});

function setInitial() {
    $("#searchLotNo").focus();

    var errcode = "${searchVO.errcode}";
    if (errcode == "Y") {
        setTimeout(function () {
            extAlert("이미 외주공정 입고등록이 완료되었거나, 존재하지 않는 LOT입니다.");
        }, 1300);
    }
}

function fn_onchange() {
    var lotno = $('#searchLotNo').val();
    var emptyValue = "";

    var url = "<c:url value='/pda/searchOutTransBarcodeCheck.do' />";
    var params = {
        LOTNO: lotno,
    };

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: params,
        success: function (data) {
            var dataList = data.data[0];
            var lotnochk = dataList.LOTNOCHK;
            if (lotnochk == "N") {
                extAlert("이미 입고등록이 완료된 LOT 입니다.");
                $('#searchLotNo').val(emptyValue);
                return false;
            } else {
                go_url('<c:url value="/pda/PdaOutTransRegist.do?NO="/>' + lotno);
            }
        },
        error: ajaxError
    });
}

function fn_back() {
    go_url('<c:url value="/pda/PDAMain.do" />');
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
		<h3 class="shadow" style="height: 50px; font-size: 20px; background-color: rgb(149, 179, 215); font-weight: bold; margin-top: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">외주 입고등록 [1/2]</h3>
		<table style="width: 100%; margin: 0px; height: 80%">
				<colgroup>
						<col style="width: 100%;">
				</colgroup>
				<tr>
						<td style="height: 30%; font-size: 200%; text-align: center; vertical-align: middle;">
						    LOT바코드를<br/>스캔하십시오.
						</td>
				</tr>
				<tr>
						<td style="height: 10%;">
						    <h3 class="shadow" style="height: 100%; font-size: 100%; background-color: rgb(149, 179, 215); font-weight: bold; margin-top: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">LOT클릭위치</h3>
						</td>
				</tr>
				<tr>
						<td style="height: 10%;">
						    <input type="text" id="searchLotNo" name="searchLotNo" class="imetype input_center" oncontextmenu="return false" style="width: 100%; height: 100%; font-size: 200%; font-weight: bold;" oninput="fn_onchange();" />
						</td>
				</tr>
				<tr>
						<td style="height: 50%;"></td>
				</tr>
		</table>
<!-- 		<button type="button" id="btnBack" name="btnBack" class="blue2 h r shadow" onclick="fn_back();" style="width: 100%; height: 10%; font-size: 20px; font-weight: bold; color: #fff; margin: 0px;">이전화면</button> -->
    <button type="button" id="btnBack" name="btnBack" class="blue2 h r shadow" onclick="fn_logout();" style="width: 100%; height: 10%; font-size: 20px; font-weight: bold; color: #fff; margin: 0px;">종 료<br/>( L O G O U T )</button>

</body>
</html>