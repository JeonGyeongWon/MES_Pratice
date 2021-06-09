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

.blue3:HOVER {
    background-color: highlight;
}
.blue3 {
    background-color: #003399;
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

.gray:HOVER {
    background-color: #d8d8d8;
}

.gray {
    background-color: #e1e1e1;
    color: black;
}

.green:HOVER {
    background-color: #CEFBC9;
}

.green {
    background-color: #B7F0B1;
    color: black;
}

.r {
    border-radius: 4px 4px 4px 4px;
    -moz-border-radius: 4px 4px 4px 4px;
    -webkit-border-radius: 4px 4px 4px 4px;
    border: 0px solid #000000;
}

.ui-autocomplete {
    font-size: 33px;
    font-weight: bold;
    max-height: 400px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
}
* html .ui-autocomplete {
  /* IE 6.0 */
  height: 400px;
  font-size: 33px;
  font-weight: bold;
}

.ui-menu  .ui-menu-item {
  height: 85px;
  line-height: 40px;
  margin-top: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
  display: flex;
  flex-direction: column;
  align-items: left;
  justify-content: center;
}

.ResultTable th {
  font-size: 40px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  border-color: 3px solid #5B9BD5;
}

.ResultTable td {
  font-size: 30px;
  color: black;
  font-weight: bold;
  text-align: center;
  border-color: 3px solid #5B9BD5;
}
</style>
<script type="text/javaScript">
var gridnms = {};
var fields = {};
var items = {};
$(document).ready(function () {
  setInitial();

  setReadOnly();
});

function setInitial() {
  fn_search();
}

function fn_search() {
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var searchdate = $('#today').val();

  var sparams = {
    ORGID: orgid,
    COMPANYID: companyid,
    SEARCHDATE: searchdate,
  };

  var url = '<c:url value="/select/prod/monitor/ProdMonitorPage1.do" />';

  $.ajax({
    url: url,
    type: "post",
    dataType: "json",
    data: sparams,
    success: function (data) {
      var result = data.data[0];

      var salesqty = result.SALESQTY;
      var shipqty = result.SHIPQTY;
      var salesrate = result.SALESRATE;
      var salescolor = result.SALESCOLOR;
      var planqty = result.PLANQTY;
      var resultqty = result.RESULTQTY;
      var prodrate = result.PRODRATE;
      var prodcolor = result.PRODCOLOR;
      var targetqty = result.TARGETQTY;
      var ncrqty = result.NCRQTY;
      var qualityrate = result.QUALITYRATE;
      var qulitycolor = result.QULITYCOLOR;

      $('#SALESQTY span').text(numeral(salesqty).format('0,0'));
      $('#SHIPQTY span').text(numeral(shipqty).format('0,0'));
      $('#SALESRATE span').text(salesrate);
      $('#SALESRATETD').css("background-color", salescolor);
      $('#PLANQTY span').text(numeral(planqty).format('0,0'));
      $('#RESULTQTY span').text(numeral(resultqty).format('0,0'));
      $('#PRODRATE span').text(prodrate);
      $('#PRODRATETD').css("background-color", prodcolor);
      $('#TARGETQTY span').text(numeral(targetqty).format('0,0'));
      $('#NCRQTY span').text(numeral(ncrqty).format('0,0'));
      $('#QUALITYRATE span').text(qualityrate);
      $('#QUALITYRATETD').css("background-color", qulitycolor);
    },
    error: ajaxError
  });
}

function setReadOnly() {
  $("[readonly]").addClass("ui-state-disabled");
}

function DisplayTime() {
  var date = new Date();
  var Year = date.getFullYear() + "",
  Month = date.getMonth(),
  Day = date.getDate(),
  Hour = date.getHours(),
  Minute = date.getMinutes(),
  Second = date.getSeconds();
  var AmPm;
  var Week = new Array('일', '월', '화', '수', '목', '금', '토');

  Year = Year.substr(2, 2);

  if (Month < 9) {
    Month = "0" + ((Month * 1) + 1);
  } else {
    Month = ((Month * 1) + 1);
  }
  if (Day < 10) {
    Day = "0" + (Day);
  }

  if (Hour == 0) {
    AmPm = "오후";
  } else if (Hour < 13) {
    AmPm = "오전";
  } else {
    Hour -= 12;
    AmPm = "오후";
  }

  Hour = (Hour == 0) ? 12 : Hour;
  if (Hour < 10) {
    Hour = '0' + (Hour);
  }
  if (Minute < 10) {
    Minute = '0' + (Minute);
  }

  var hippen = null;
  if (Second % 2 == 0) {
    hippen = ":";
  } else {
    hippen = " ";
  }

  $('#DateTimeArea span').text(Year + "-" + Month + "-" + Day + " " + AmPm + " " + Hour + hippen + Minute);
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

setInterval(function () {
  DisplayTime();
}, 1000);

// 20초 간격으로 새로고침
setInterval(function () {
  go_url('<c:url value="/prod/monitor/ProdMonitorPage2.do" />');
//   fn_search();
}, 10 * 2 * 1000);
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;">
		<!-- 전체 레이어 시작 -->
    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
    <input type="hidden" id="today" value="${searchVO.DATESYS}" />
		<sec:authorize ifNotGranted="ROLE_MONITOR">
				<div id="wrap">
						<!-- header 시작 -->
						<div id="header">
								<c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" />
						</div>
						<div id="topnavi">
								<c:import url="/sym/mms/EgovMainMenuHead.do" />
						</div>
						<!-- //header 끝 -->
						<!-- container 시작 -->
						<div id="container">
								<!-- 좌측메뉴 시작 -->
								<div id="leftmenu">
										<c:import url="/sym/mms/EgovMainMenuLeft.do" />
								</div>
								<!-- //좌측메뉴 끝 -->
								<!-- 현재위치 네비게이션 시작 -->
								<div id="content" style="padding-right: 0px;">
										<!-- 검색 필드 박스 시작 -->
                    <div id="search_field" style="width: 300px; float: left; padding-left: 0px; padding-bottom: 0px; margin-top: 23px;">
                        <div id="search_field_loc" style="padding-bottom: 0px;">
                            <h2>
                                <strong>${pageTitle}</strong>
                            </h2>
                        </div>
                    </div>
				            <div style="float: left; width: 100%; margin-bottom: 0px; padding-left: 15px; padding-top: 10px;">
		                    <table style="width: 100%;" border="0">
		                            <colgroup>
		                                    <col width="35%">
		                                    <col width="30%">
		                                    <col width="35%">
		                            </colgroup>
		                            <tr>
		                                    <td>
		                                        <strong style="font-size: 35px; font-weight: bold; padding-left: 10px;">${pageSubTitle}</strong>
		                                    </td>
		                                    <td>
		                                        <label id="DateTimeArea" name="DateTimeArea" style="width: 100%; height: 80px; font-size: 35px; font-weight: bold; text-align: center; padding-top: 20px;">
		                                            <span></span>
		                                        </label>
		                                    </td>
		
		                                    <td style="float: right;">
<!-- 		                                            <button class="blue2 h r shadow" type="button" onclick="fn_logout();" style="width: 180px; height: 60px; font-size: 30px; font-weight: bold; color: white; margin-top: 15px; margin-right: 15px;">나가기</button> -->
		                                    </td>
		                            </tr>
		                    </table>
				            </div>
										<!-- //검색 필드 박스 끝 -->

										<div class="subContent2" style="width: 100%;">
				                <table class="ResultTable" border="3" style="width: 100%; margin-top: 0px; margin-bottom: 0px; padding-bottom: 0px; float: left; border-color: #5B9BD5;">
				                    <colgroup>
				                        <col>
				                        <col>
				                        <col>
				                        <col>
				                        <col>
				                        <col>
				                        <col>
				                        <col>
				                        <col>
				                    </colgroup>
				                    <tbody>
				                        <tr style="height: 100px;">
				                            <th colspan="3" style="border-right: 3px solid gray; border-bottom: 3px solid gray;">영&nbsp;&nbsp;업</th>
				                            <th colspan="3" style="background-color: rgb(0, 176, 80); border-right: 3px solid gray; border-bottom: 3px solid gray;">생&nbsp;&nbsp;산</th>
				                            <th colspan="3" style="border-bottom: 3px solid gray;">품&nbsp;&nbsp;질</th>
				                        </tr>
				                        <tr style="height: 100px;">
				                            <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">수주</th>
				                            <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">출하</th>
				                            <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">달성율</th>
				                            <th style="border-right: 3px solid gray; border-bottom: 3px solid gray;">생산<br/>계획</th>
				                            <th style="border-right: 3px solid gray; border-bottom: 3px solid gray;">생산<br/>실적</th>
				                            <th style="border-right: 3px solid gray; border-bottom: 3px solid gray;">달성율</th>
				                            <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">목표<br/>(PPM)</th>
				                            <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">불량<br/>현황</th>
				                            <th style="background-color: rgb(255, 192, 0); border-bottom: 3px solid gray;">목표<br/>대비율</th>
				                        </tr>
				                        <tr style="height: 492px;">
				                            <td id="SALESQTYTD" style="border-right: 3px solid gray;">
				                                <label id="SALESQTY" name="SALESQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0</span>
				                                </label>
				                            </td>
				                            <td id="SHIPQTYTD" style="border-right: 3px solid gray;">
				                                <label id="SHIPQTY" name="SHIPQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0</span>
				                                </label>
				                            </td>
				                            <td id="SALESRATETD" style="border-right: 3px solid gray;">
				                                <label id="SALESRATE" name="SALESRATE" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0%</span>
				                                </label>
				                            </td>
				                            <td id="PLANQTYTD" style="border-right: 3px solid gray;">
				                                <label id="PLANQTY" name="PLANQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0</span>
				                                </label>
				                            </td>
				                            <td id="RESULTQTYTD" style="border-right: 3px solid gray;">
				                                <label id="RESULTQTY" name="RESULTQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0</span>
				                                </label>
				                            </td>
				                            <td id="PRODRATETD" style="border-right: 3px solid gray;">
				                                <label id="PRODRATE" name="PRODRATE" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0%</span>
				                                </label>
				                            </td>
				                            <td id="TARGETQTYTD" style="border-right: 3px solid gray;">
				                                <label id="TARGETQTY" name="TARGETQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0</span>
				                                </label>
				                            </td>
				                            <td id="NCRQTYTD" style="border-right: 3px solid gray;">
				                                <label id="NCRQTY" name="NCRQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0</span>
				                                </label>
				                            </td>
				                            <td id="QUALITYRATETD" style="border-right: 3px solid gray;">
				                                <label id="QUALITYRATE" name="QUALITYRATE" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
				                                    <span>0%</span>
				                                </label>
				                            </td>
				                        </tr>
				                    </tbody>
				                </table>
										</div>
								</div>
								<!-- //content 끝 -->
						</div>
						<!-- //container 끝 -->
						<!-- footer 시작 -->
						<div id="footer">
										<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
						</div>
						<!-- //footer 끝 -->
				</div>
		</sec:authorize>

		<sec:authorize ifAllGranted="ROLE_MONITOR">
				<!-- 현재위치 네비게이션 시작 -->
				<!-- 검색 필드 박스 시작 -->
    <div style="float: left; width: 100%;">

            <table style="width: 100%;" border="0">
                    <colgroup>
                            <col width="35%">
                            <col width="30%">
                            <col width="35%">
                    </colgroup>
                    <tr>
                            <td>
                                <strong style="font-size: 35px; font-weight: bold; padding-left: 10px;">${pageSubTitle}</strong>
                            </td>
                            <td>
                                    <label id="DateTimeArea" name="DateTimeArea" style="width: 100%; height: 80px; font-size: 35px; font-weight: bold; text-align: center; padding-top: 20px;">
                                        <span></span>
                                    </label>
                            </td>

                            <td style="float: right;">
                                    <button class="blue2 h r shadow" type="button" onclick="fn_logout();" style="width: 180px; height: 60px; font-size: 30px; font-weight: bold; color: white; margin-top: 15px; margin-right: 15px;">나가기</button>
                            </td>
                    </tr>
            </table>
    </div>
				<!-- //검색 필드 박스 끝 -->

				<div class="subContent2" style="width: 100%;">
        <table class="ResultTable" border="3" style="width: 100%; margin-top: 30px; margin-bottom: 0px; padding-bottom: 0px; float: left; border-color: #5B9BD5;">
            <colgroup>
                <col>
                <col>
                <col>
                <col>
                <col>
                <col>
                <col>
                <col>
                <col>
            </colgroup>
            <tbody>
                <tr style="height: 100px;">
                    <th colspan="3" style="font-size: 45px; border-right: 3px solid gray; border-bottom: 3px solid gray;">영&nbsp;&nbsp;업</th>
                    <th colspan="3" style="font-size: 45px; background-color: rgb(0, 176, 80); border-right: 3px solid gray; border-bottom: 3px solid gray;">생&nbsp;&nbsp;산</th>
                    <th colspan="3" style="font-size: 45px; border-bottom: 3px solid gray;">품&nbsp;&nbsp;질</th>
                </tr>
                <tr style="height: 100px;">
                    <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">수주</th>
                    <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">출하</th>
                    <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">달성율</th>
                    <th style="border-right: 3px solid gray; border-bottom: 3px solid gray;">생산<br/>계획</th>
                    <th style="border-right: 3px solid gray; border-bottom: 3px solid gray;">생산<br/>실적</th>
                    <th style="border-right: 3px solid gray; border-bottom: 3px solid gray;">달성율</th>
                    <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">목표<br/>(PPM)</th>
                    <th style="background-color: rgb(255, 192, 0); border-right: 3px solid gray; border-bottom: 3px solid gray;">불량<br/>현황</th>
                    <th style="background-color: rgb(255, 192, 0); border-bottom: 3px solid gray;">목표<br/>대비율</th>
                </tr>
                <tr style="height: 280px;">
                    <td id="SALESQTYTD" style="border-right: 3px solid gray;">
                        <label id="SALESQTY" name="SALESQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0</span>
                        </label>
                    </td>
                    <td id="SHIPQTYTD" style="border-right: 3px solid gray;">
                        <label id="SHIPQTY" name="SHIPQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0</span>
                        </label>
                    </td>
                    <td id="SALESRATETD" style="border-right: 3px solid gray;">
                        <label id="SALESRATE" name="SALESRATE" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0%</span>
                        </label>
                    </td>
                    <td id="PLANQTYTD" style="border-right: 3px solid gray;">
                        <label id="PLANQTY" name="PLANQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0</span>
                        </label>
                    </td>
                    <td id="RESULTQTYTD" style="border-right: 3px solid gray;">
                        <label id="RESULTQTY" name="RESULTQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0</span>
                        </label>
                    </td>
                    <td id="PRODRATETD" style="border-right: 3px solid gray;">
                        <label id="PRODRATE" name="PRODRATE" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0%</span>
                        </label>
                    </td>
                    <td id="TARGETQTYTD" style="border-right: 3px solid gray;">
                        <label id="TARGETQTY" name="TARGETQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0</span>
                        </label>
                    </td>
                    <td id="NCRQTYTD" style="border-right: 3px solid gray;">
                        <label id="NCRQTY" name="NCRQTY" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0</span>
                        </label>
                    </td>
                    <td id="QUALITYRATETD" style="border-right: 3px solid gray;">
                        <label id="QUALITYRATE" name="QUALITYRATE" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                            <span>0%</span>
                        </label>
                    </td>
                </tr>
            </tbody>
        </table>
				</div>
				<!-- //content 끝 -->
		</sec:authorize>
		<!-- //전체 레이어 끝 -->
</body>
</html>