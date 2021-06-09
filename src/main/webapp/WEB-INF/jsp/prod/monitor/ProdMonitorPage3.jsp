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
  var currentpage = $('#currentpage').val();

  var sparams = {
    ORGID: orgid,
    COMPANYID: companyid,
    SEARCHPAGE: currentpage,
  };

  var url = '<c:url value="/select/prod/monitor/ProdMonitorPage3ListAgg.do" />';

  $.ajax({
    url: url,
    type: "post",
    dataType: "json",
    data: sparams,
    success: function (data) {
      var result = data.data[0];

      var label1  = result.LABEL1 ;
      var label2  = result.LABEL2 ;
      var label3  = result.LABEL3 ;
      var label4  = result.LABEL4 ;
      var label5  = result.LABEL5 ;
      var label6  = result.LABEL6 ;
      var label7  = result.LABEL7 ;
      var label8  = result.LABEL8 ;
      var label9  = result.LABEL9 ;
      var label10 = result.LABEL10;
      var label11 = result.LABEL11;
      var label12 = result.LABEL12;
      var label13 = result.LABEL13;
      var label14 = result.LABEL14;
      var label15 = result.LABEL15;
      var color1  = result.COLOR1 ;
      var color2  = result.COLOR2 ;
      var color3  = result.COLOR3 ;
      var color4  = result.COLOR4 ;
      var color5  = result.COLOR5 ;
      var color6  = result.COLOR6 ;
      var color7  = result.COLOR7 ;
      var color8  = result.COLOR8 ;
      var color9  = result.COLOR9 ;
      var color10 = result.COLOR10;
      var color11 = result.COLOR11;
      var color12 = result.COLOR12;
      var color13 = result.COLOR13;
      var color14 = result.COLOR14;
      var color15 = result.COLOR15;

      $('#LABEL1 span').text(label1);
      $('#LABEL1TD').css("background-color", color1);
      $('#LABEL2 span').text(label2);
      $('#LABEL2TD').css("background-color", color2);
      $('#LABEL3 span').text(label3);
      $('#LABEL3TD').css("background-color", color3);
      $('#LABEL4 span').text(label4);
      $('#LABEL4TD').css("background-color", color4);
      $('#LABEL5 span').text(label5);
      $('#LABEL5TD').css("background-color", color5);
      $('#LABEL6 span').text(label6);
      $('#LABEL6TD').css("background-color", color6);
      $('#LABEL7 span').text(label7);
      $('#LABEL7TD').css("background-color", color7);
      $('#LABEL8 span').text(label8);
      $('#LABEL8TD').css("background-color", color8);
      $('#LABEL9 span').text(label9);
      $('#LABEL9TD').css("background-color", color9);
      $('#LABEL10 span').text(label10);
      $('#LABEL10TD').css("background-color", color10);
      $('#LABEL11 span').text(label11);
      $('#LABEL11TD').css("background-color", color11);
      $('#LABEL12 span').text(label12);
      $('#LABEL12TD').css("background-color", color12);
      $('#LABEL13 span').text(label13);
      $('#LABEL13TD').css("background-color", color13);
      $('#LABEL14 span').text(label14);
      $('#LABEL14TD').css("background-color", color14);
      $('#LABEL15 span').text(label15);
      $('#LABEL15TD').css("background-color", color15);
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
  var currentpage = $('#currentpage').val() * 1;
  var lastpage = $('#lastpage').val() * 1;
  if (currentpage == lastpage) {
    go_url('<c:url value="/prod/monitor/ProdMonitorPage1.do" />');
  } else {
    currentpage += 1;
    $('#currentpage').val(currentpage);

    fn_search();
  }
}, 10 * 2 * 1000);
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;">
		<!-- 전체 레이어 시작 -->
    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
    <input type="hidden" id="totalcount" value="${searchVO.TOTALCOUNT}" />
    <input type="hidden" id="currentpage" value="${searchVO.FIRSTPAGE}" />
    <input type="hidden" id="lastpage" value="${searchVO.LASTPAGE}" />
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
<!-- 		                                <button class="blue2 h r shadow" type="button" onclick="fn_logout();" style="width: 180px; height: 60px; font-size: 30px; font-weight: bold; color: white; margin-top: 15px; margin-right: 15px;">나가기</button> -->
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
						                </colgroup>
						                <tbody>
						                    <tr style="height: 160px;">
						                        <td id="LABEL1TD" style="border-right: 3px solid gray;">
						                            <label id="LABEL1" name="LABEL1" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL2TD" style="border-right: 3px solid gray;">
						                            <label id="LABEL2" name="LABEL2" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL3TD" style="border-right: 3px solid gray;">
						                            <label id="LABEL3" name="LABEL3" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL4TD" style="border-right: 3px solid gray;">
						                            <label id="LABEL4" name="LABEL4" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL5TD" style="">
						                            <label id="LABEL5" name="LABEL5" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                    </tr>
						                    <tr style="height: 160px;">
						                        <td id="LABEL6TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
						                            <label id="LABEL6" name="LABEL6" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL7TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
						                            <label id="LABEL7" name="LABEL7" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL8TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
						                            <label id="LABEL8" name="LABEL8" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL9TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
						                            <label id="LABEL9" name="LABEL9" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL10TD" style="border-top: 3px solid gray;">
						                            <label id="LABEL10" name="LABEL10" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                    </tr>
						                    <tr style="height: 160px;">
						                        <td id="LABEL11TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
						                            <label id="LABEL11" name="LABEL11" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL12TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
						                            <label id="LABEL12" name="LABEL12" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL13TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
						                            <label id="LABEL13" name="LABEL13" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL14TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
						                            <label id="LABEL14" name="LABEL14" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
						                                <span></span>
						                            </label>
						                        </td>
						                        <td id="LABEL15TD" style="border-top: 3px solid gray;">
						                            <label id="LABEL15" name="LABEL15" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px;">
						                                <span></span>
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
		            </colgroup>
		            <tbody>
		                <tr style="height: 160px;">
		                    <td id="LABEL1TD" style="border-right: 3px solid gray;">
		                        <label id="LABEL1" name="LABEL1" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
		                            <span></span>
		                        </label>
		                    </td>
		                    <td id="LABEL2TD" style="border-right: 3px solid gray;">
		                        <label id="LABEL2" name="LABEL2" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
		                            <span></span>
		                        </label>
		                    </td>
		                    <td id="LABEL3TD" style="border-right: 3px solid gray;">
		                        <label id="LABEL3" name="LABEL3" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
		                            <span></span>
		                        </label>
		                    </td>
		                    <td id="LABEL4TD" style="border-right: 3px solid gray;">
		                        <label id="LABEL4" name="LABEL4" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
		                            <span></span>
		                        </label>
		                    </td>
		                    <td id="LABEL5TD" style="">
		                        <label id="LABEL5" name="LABEL5" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
		                            <span></span>
		                        </label>
		                    </td>
		                </tr>
                    <tr style="height: 160px;">
                        <td id="LABEL6TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
                            <label id="LABEL6" name="LABEL6" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                        <td id="LABEL7TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
                            <label id="LABEL7" name="LABEL7" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                        <td id="LABEL8TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
                            <label id="LABEL8" name="LABEL8" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                        <td id="LABEL9TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
                            <label id="LABEL9" name="LABEL9" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                        <td id="LABEL10TD" style="border-top: 3px solid gray;">
                            <label id="LABEL10" name="LABEL10" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                    </tr>
                    <tr style="height: 160px;">
                        <td id="LABEL11TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
                            <label id="LABEL11" name="LABEL11" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                        <td id="LABEL12TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
                            <label id="LABEL12" name="LABEL12" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                        <td id="LABEL13TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
                            <label id="LABEL13" name="LABEL13" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                        <td id="LABEL14TD" style="border-right: 3px solid gray; border-top: 3px solid gray;">
                            <label id="LABEL14" name="LABEL14" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px; ">
                                <span></span>
                            </label>
                        </td>
                        <td id="LABEL15TD" style="border-top: 3px solid gray;">
                            <label id="LABEL15" name="LABEL15" style="padding-right: 10px; padding-top: 2px; padding-bottom: 0px;">
                                <span></span>
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