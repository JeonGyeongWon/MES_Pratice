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
</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
$(document).ready(function () {
    setReadOnly();

    setLovList();
    
    setTimeout(function () {
        if ("${errCode}" === "1") {
            var msg = "선택하신 메뉴가 존재하지 않습니다.<br/>다시 확인해주세요!";
            extToastView(msg);
        }
    }, 1000);
});

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

function fn_goBack () {
    <%-- 관리자의 경우 공정관리 > 작업지시투입관리 화면으로 넘어감. --%>
    go_url('<c:url value="/prod/work/WorkOrderStart.do" />');
}

function fn_nextPage ( type ) {
    if (type === 1 || type === 7 || type === 14 ) {
      <%-- 1. 공정시작 화면으로 이동합니다. --%>
      <%-- 7. 공구 변경 등록 화면으로 이동합니다. --%>
      <%-- 14. 생산실적 등록 화면으로 이동합니다. --%>
      switch (groupid) {
      case "ROLE_EQUIPMENT":
        go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + type + "&gubun=" + "${searchVO.WORKDEPT}" + "&code=" + "${searchVO.WORKCENTERCODE}");
        
        break;
      default:
        go_url('<c:url value="/prod/process/selectWorkDeptList.do?type="/>' + type);

        break;
      }
    } else if ( type === 8 ) {
        <%-- 8. 외주입고 화면으로 이동합니다. --%>
//         go_url('<c:url value="/prod/process/WarehousingRegist.do?type="/>' + type );
        go_url('<c:url value="/prod/process/WarehousingRegist.do"/>' );
    } else if ( type === 10 ) {
        <%-- 10. 자주 검사 화면으로 이동합니다. --%>
     go_url('<c:url value="/prod/process/selectWorkOrderNewRegist.do?type="/>' + type );
    } else if ( type === 11 ) {
        <%-- 11. 설비그룹 변경등록 화면으로 이동합니다. --%>
        go_url('<c:url value="/prod/process/WorkgroupChangeRegist.do"/>' );
    } else if ( type === 12 ) {
        <%-- 12. 외주발주 화면으로 이동합니다. --%>
        go_url('<c:url value="/prod/process/WorkOutOrderRegist.do"/>' );
    } else if ( type === 13 ) {
        <%-- 13. 반입반출 화면으로 이동합니다. --%>
        go_url('<c:url value="/prod/process/WorkOrderInOut.do"/>' );
    } else {
    	<%-- 버튼 예외 처리부 --%>
        return;
    }
}

function fn_ready() {
	extToastView("준비중입니다...");
	return ;
}

function setLovList() {
	//
}

function setReadOnly() {
    $("[readonly]").addClass("ui-state-disabled");
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
        <!-- 현재위치 네비게이션 시작 -->
        <div style="margin-top: 20px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
            <div style="width: 100%; padding-left: 0px; ">
                <form id="master" name="master" method="post">
                    <span style="font-size: 20px; font-weight: bold; color: black; margin-top: 0px; margin-left : 5px;">
                      ${pageSubTitle}
                    </span>
<!--                     <span style="font-size: 28px; font-weight: bold; color: blue; float: right; margin-top: 0px; margin-right : 35px;"> -->
<%--                       접속자 : <c:out value="<%= loginVO.getName()%>"/> 님 --%>
<!--                     </span> -->
                    <center>
                        <sec:authorize ifNotGranted="ROLE_WORK, ROLE_EQUIPMENT, ROLE_WORK_CHIEF">
                            <button type="button" class="gray r shadow" onclick="fn_goBack();" style="width:80%; height:100px; font-size:40px; font-weight: bold; margin-left:0px; margin-top: 10px; margin-bottom: 5px;">처음화면&nbsp;( HOME )</button>
                        </sec:authorize>
                        <sec:authorize ifAnyGranted="ROLE_WORK, ROLE_EQUIPMENT, ROLE_WORK_CHIEF">
                            <button type="button" class="yellow r shadow" onclick="fn_logout();" style="width:80%; height:100px; font-size:40px; font-weight: bold; margin-left:0px; margin-top: 10px; margin-bottom: 5px;">나가기&nbsp;( LOGOUT )</button>
                        </sec:authorize>
                        <h3 class="shadow" style="height:70px; font-size: 35px; background-color: orange; font-weight: bold;  margin-top: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
                            메뉴를 선택하십시오.
                        </h3>
                    </center>
                    <div id="search_field" style="margin-bottom: 5px;">
                         <fieldset>
                            <legend>메뉴 선택 영역</legend>
                            <div align="center">
                                <br>
                                <button type="button" class="blue2 h r shadow" onclick="fn_nextPage( 14 );" style="width: 45%; height:150px; font-size:30px; font-weight: bold; color: #fff; margin-left: 0px; margin-bottom: 20px; disabled">
                                   생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="blue2 h r shadow" onclick="fn_nextPage( 1 );" style="width: 45%; height:150px; font-size:30px; font-weight: bold; color: #fff; margin-left: 20px; margin-bottom: 20px; disabled">
                                   래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="blue2 h r shadow" onclick="fn_nextPage( 10 );" style="width: 45%; height:150px; font-size:30px; font-weight: bold; color: #fff; margin-left: 00px; margin-bottom: 20px; disabled">
                                    자주 검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="blue2 h r shadow" onclick="fn_nextPage( 7 );" style="width: 45%; height:150px; font-size:30px; font-weight: bold; color: #fff; margin-left: 20px; margin-bottom: 20px; disabled">
                                    공구변경<br/>( TOOL CHANGE )
                                </button>
                                <button type="button" class="blue2 h r shadow" onclick="fn_nextPage( 12 );" style="width: 45%; height:150px; font-size:30px; font-weight: bold; color: #fff; margin-left: 0px; margin-bottom: 20px; disabled">
                                    외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="blue2 h r shadow" onclick="fn_nextPage( 8 );" style="width: 45%; height:150px; font-size:30px; font-weight: bold; color: #fff; margin-left: 20px; margin-bottom: 20px; disabled">
                                    외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="blue2 h r shadow" onclick="fn_nextPage( 13 );" style="width: 45%; height:150px; font-size:30px; font-weight: bold; color: #fff; margin-left: 0px; margin-bottom: 20px; disabled">
                                    반입반출<br/>( STORED & RELEASED )
                                </button>
                                <button type="button" class="blue2 h r shadow" onclick="fn_nextPage( 11 );" style="width: 45%; height:150px; font-size:30px; font-weight: bold; color: #fff; margin-left: 20px; margin-bottom: 20px; disabled">
                                    설비변경<br/>( FACILITIES )
                                </button>
                            </div>
                        </fieldset>
                    </div>
                </form>
            </div>
        </div>
        <!-- //content 끝 -->
    <!-- //전체 레이어 끝 -->
<div id="loadingBar" style="display: none;">
    <img src='<c:url value="/images/spinner.gif"></c:url>' alt="Loading"/>
</div>
</body>
</html>