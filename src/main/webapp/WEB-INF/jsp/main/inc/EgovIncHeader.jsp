<%--
  Class Name : EgovIncHeader.jsp
  Description : 화면상단 Header (include)
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2011.08.31   JJY       경량환경 버전 생성
     2019.03.06   YMHA   이메일 등록 팝업 추가
 
    author   : 실행환경개발팀 JJY
    since    : 2011.08.31 
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%
	LoginVO loginVO = (LoginVO) session.getAttribute("LoginVO");
%>
<script>
function popPassword() {
  //var aa = window.open("<c:url value='/uss/umt/user/EgovUserPasswordUpdtView.do'/>", "password", "scrollbars = yes, top=100px, left=100px, height=700px, width=850px");
  var width = 450;
  var height = 250;
  var left = (($(window).width() / 2) + (width / 2)) * -1;
  var top = (($(window).height() / 2) - (height / 2)) * 1;
  var aa = window.open("about:blank", "pwdPop", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top + ", scrollbars=no, menubar=no, status=no, toolbar=no, resizable=no, fullscreen=no, channelmode=no");
  aa.focus();
  document.passwdForm.submit();
}

function popEmail() {
  var width = 450;
  var height = 250;
  var left = (($(window).width() / 2) + (width / 2)) * -1;
  var top = (($(window).height() / 2) - (height / 2)) * 1;
  var bb = window.open("about:blank", "emailPop", "width=" + width + ", height=" + height + ", left=" + left + ", top=" + top + ", scrollbars=no, menubar=no, status=no, toolbar=no, resizable=no, fullscreen=no, channelmode=no");
  bb.focus();
  document.emailForm.submit();
}

function Logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}
</script>
<div style="width:100%; padding-bottom: 0px;">
	<div id="skipNav" class="invisible">
		<dl>
			<dt>콘텐츠 바로가기</dt>
			<dd>
				<a href="#content">컨텐츠 바로가기</a>
			</dd>
			<dd>
				<a href="#topnavi">메인메뉴 바로가기</a>
			</dd>
			<dd>
				<a href="#leftmenu">좌메뉴 바로가기</a>
			</dd>
		</dl>
	</div>
	<div id="project_title">
	   <span class="maintitle"> </span><strong></strong>
	</div>
	<%-- <div style="float: right">
		<a href="javascript:popPassword()"><img border="0" src="<c:url value='/'/>images/header/top_bt_pass.gif" width="62" height="62"></a>
		<a href="javascript:Logout()"><img border="0" src="<c:url value='/'/>images/header/top_bt_logoff.gif" width="62" height="62"></a>
	</div> --%>
</div>

<form name="passwdForm" action="<c:url value='/uss/umt/user/EgovUserPasswordUpdtView.do'/>" method="post" target="pwdPop">
    <input name="emplyrId" id="emplyrId" title="사용자아이디" type="hidden" size="20" value="<%=loginVO.getId()%>" maxlength="20" readonly />
    <input name="uniqId" id="uniqId" title="uniqId" type="hidden" size="20" value="<%=loginVO.getUniqId()%>" />
    <input name="userTy" id="userTy" title="userTy" type="hidden" size="20" value="USR03" />
    <input name="searchCondition" id="searchCondition" title="searchCondition" type="hidden" size="20" value="pop" />
</form>

<form name="emailForm" action="<c:url value='/uss/umt/user/EgovUserEmailUpdtView.do'/>" method="post" target="emailPop">
    <input name="emplyrId" id="emplyrId" title="사용자아이디" type="hidden" size="20" value="<%=loginVO.getId()%>" maxlength="20" readonly />
    <input name="uniqId" id="uniqId" title="uniqId" type="hidden" size="20" value="<%=loginVO.getUniqId()%>" />
    <input name="userTy" id="userTy" title="userTy" type="hidden" size="20" value="USR03" />
    <input name="searchCondition" id="searchCondition" title="searchCondition" type="hidden" size="20" value="pop" />
</form>
<%-- //행정안전부 로고 및 타이틀 끝 --%>