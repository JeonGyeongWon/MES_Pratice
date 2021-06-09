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

.green:HOVER {
    background-color: #CEFBC9;
}
.green {
    background-color: #00CC99;
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

.red2:HOVER {
    background-color: #FFD8D8;
}

.red2 {
    background-color: #FDDAFF;
    color: black;
}

.brown:HOVER {
    background-color: #E0844F;
}

.brown {
    background-color: #AA4E19;
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

function fn_goPrevPage () {
    go_url('<c:url value="/prod/process/selectWorkDeptList.do?type="/>' + "${searchVO.type}" );
}

function fn_goHome () {
    <%--작업시작 처음 화면으로 넘어감. --%>
    go_url('<c:url value="/prod/process/ProcessStart.do" />');
}

function fn_goNextPage( value ) {
    go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + "${searchVO.type}" + "&gubun=" + "${searchVO.gubun}" + "&code=" + value );
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
                      <a href="#" onclick="fn_goHome();">${pageSubTitle}</a> &gt; ${pageTitle}
                    </span>
<!--                     <span style="font-size: 28px; font-weight: bold; color: blue; float: right; margin-top: 0px; margin-right : 35px;"> -->
<%--                       접속자 : <c:out value="<%= loginVO.getName()%>"/> 님 --%>
<!--                     </span> -->
                    <center>
                        <button type="button" class="gray r shadow" onclick="fn_goHome();" style="width: 40%; height: 100px; font-size: 40px; font-weight: bold; margin-left: 0px; margin-top: 10px; margin-bottom: 5px; ">HOME</button>
                        <button type="button" class="red r shadow" onclick="fn_goPrevPage();" style="width: 40%; height: 100px; font-size: 40px; font-weight: bold; margin-left: 15px; margin-top: 10px; margin-bottom: 5px;">이전화면&nbsp;( BACK )</button>
<!--                         <button type="button" class="red r shadow" onclick="fn_goPrevPage();" style="width:80%; height:100px; font-size:40px; font-weight: bold; margin-left:0px; margin-top: 10px; margin-bottom: 5px;">이전화면</button> -->
                        <h3 class="shadow" style="height:70px; font-size: 35px; background-color: orange; font-weight: bold;  margin-top: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
                            해당 설비를 선택하십시오.
                        </h3>
                    </center>
                    <br/>
                    <div id="search_field" style="margin-bottom: 15px;">
                         <fieldset>
                            <legend>설비 선택 영역</legend>
                            <div align="center">
                                <br>
                                <c:forEach items="${selectEquipment}" var="selectEquipment">
                                  <c:choose>
                                    <c:when test="${selectEquipment.MODRN == 1}">
                                            <button type="button" class="blue2 h r shadow" onclick="fn_goNextPage('<c:out value="${selectEquipment.VALUE}"/>');" style="width: 16%; height: 100px; font-size: 35px; font-weight: bold; color: #fff; margin-left: 20px; margin-bottom: 20px;">
                                                <%-- <p style="color: gray;"><c:out value="${selectEquipment.COMPANYNAME}" /></p><br/> --%><c:out value="${selectEquipment.LABEL}" />
                                            </button>
                                    </c:when>
                                    <c:when test="${selectEquipment.MODRN == 0}">
                                            <button type="button" class="blue2 h r shadow" onclick="fn_goNextPage('<c:out value="${selectEquipment.VALUE}"/>');" style="width: 16%; height: 100px; font-size: 35px; font-weight: bold; color: #fff; margin-left: 20px; margin-bottom: 20px;">
                                                <%-- <p style="color: gray;"><c:out value="${selectEquipment.COMPANYNAME}" /></p><br/> --%><c:out value="${selectEquipment.LABEL}" />
                                            </button>
                                    </c:when>
                                    <c:otherwise>
                                            <button type="button" class="blue2 h r shadow" onclick="fn_goNextPage('<c:out value="${selectEquipment.VALUE}"/>');" style="width: 16%; height: 100px; font-size: 35px; font-weight: bold; color: #fff; margin-left: 20px; margin-bottom: 20px;">
                                                <%-- <p style="color: gray;"><c:out value="${selectEquipment.COMPANYNAME}" /></p><br/> --%><c:out value="${selectEquipment.LABEL}" />
                                            </button>
                                    </c:otherwise>
                                  </c:choose>
                              </c:forEach>
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