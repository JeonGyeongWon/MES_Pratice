<%--
  Class Name : EgovMainView.jsp 
  Description : 메인화면
  Modification Information
 
     수정일     수정자     수정내용
     -------      --------    ---------------------------
   2011.08.31       JJY    경량환경 버전 생성
   2021.04.08   YMHA    모바일 여부 체크 기능 추가
 
    author   : 실행환경개발팀 JJY
    since    : 2011.08.31 
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko">
<title>Main View</title>
<link href="<c:url value='/css/common.css'/>" rel="stylesheet" type="text/css">
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
</head>
<%
	egovframework.com.cmm.LoginVO loginVO = (egovframework.com.cmm.LoginVO) request.getSession().getAttribute("LoginVO");

	String authCode = loginVO.getAuthCode();
%>
<script>
function init() {
    var isCheck = fn_mobile_check();
    if (isCheck) {
        var groupid = $('#groupId').val();
        switch (groupid) {
        case "ROLE_PDA":
            // PDA 사용자
            go_url("<c:url value='/pda/PdaOutTransBarcode.do'/>");
            break;
        default:
            go_url("<c:url value='/eis/mobile/EisMain.do'/>");
            break;
        }
    } else {
        var menuno = "${MenuNo}";
        if (menuno === "") {
            goMenuPage('1000000');
        } else {
            goMenuPage(menuno);
        }
    }
}

$(document).ready(function () {
    page.init();
    $(document).keydown(function (e) {
        if (e.target.nodeName != "INPUT" && e.target.nodeName != "TEXTAREA") {
            if (e.keyCode === 8) {
                return false;
            }
        }
    });
});
</script>
<body onLoad="javascript:init();">
  <noscript>자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다.</noscript>
  <!-- 전체 레이어 시작 -->
  <input type="hidden" id="groupId" name="groupId" value="<%= authCode %>" />
  <div id="wrap" style="display: inline-block; vertical-align: top;">
    <!-- header 시작 -->
    <div id="header" style="margin: 0 auto; clear: left; max-height: 75px; min-height: 75px; overflow: auto; display: inline-block;">
      <c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" />
    </div>
    <div id="topnavi">
      <c:import url="/sym/mms/EgovMainMenuHead.do" />
    </div>
    <!-- //header 끝 -->
  </div>
  <!-- //전체 레이어 끝 -->
</body>
</html>