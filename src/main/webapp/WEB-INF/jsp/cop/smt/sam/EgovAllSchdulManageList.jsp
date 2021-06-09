<%--
  Class Name : EgovAllSchdulManageListPopup.jsp
  Description : 전체일정관리 목록  팝업
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.09

--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import ="egovframework.com.cmm.LoginVO" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="egovframework.rte.psl.dataaccess.util.EgovMap"%>

<c:set var="ImgUrl" value="/images/egovframework/let/cop/smt/sam/"/>
<c:set var="CssUrl" value="/css/egovframework/let/cop/smt/sam/"/>

<%
  /* Image Path 설정 */
  String imagePath_icon   = "/images/egovframework/sym/mpm/icon/";
  String imagePath_button = "/images/egovframework/sym/mpm/button/";
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html lang="ko">
<head>
<title>전체일정 목록</title>

<style type="text/css">
    h1 {font-size:12px;}
    caption {visibility:hidden; font-size:0; height:0; margin:0; padding:0; line-height:0;}

</style>

<meta http-equiv="content-type" content="text/html; charset=utf-8">
<meta http-equiv="content-language" content="ko">   
<link type="text/css" rel="stylesheet" href="<c:url value='/css/com.css'/>" >
<link type="text/css" rel="stylesheet" href="<c:url value='/css/button.css'/>" >
<link href="<c:url value='/'/>css/common.css" rel="stylesheet" type="text/css" >
<script type="text/javascript" src="<c:url value='/js/common.js'/>" ></script>
<script type="text/javascript" src="<c:url value='/js/EgovCalPopup.js'/>" ></script>
<script type="text/javascript" src="<c:url value='/js/EgovMultiFile.js'/>" ></script>
<script type="text/javaScript" language="javascript">
/* ********************************************************
 * 페이징 처리 함수
 ******************************************************** */
function linkPage(pageNo){
    document.listForm.pageIndex.value = pageNo;
    document.listForm.action = "<c:url value='/cop/smt/sam/EgovAllSchdulManageList.do'/>";
    document.listForm.submit();
}
/* ********************************************************
 * 등록 처리 함수
 ******************************************************** */
function fn_egov_regist_AllSchdulManage(){
    location.href = "<c:url value='/cop/smt/sam/EgovAllSchdulManageRegist.do' />";
}
/* ********************************************************
 * 수정 처리 함수
 ******************************************************** */
function fn_egov_modify_AllSchdulManage(){
    location.href = "<c:url value='/cop/smt/sam/EgovAllSchdulManageModify.do' />";
}
/* ********************************************************
 * 상세회면 처리 함수
 ******************************************************** */
function fn_egov_detail_AllSchdulManage(schdulKindCode, schdulId){
    var vFrom = document.subForm;
    vFrom.schdulId.value = schdulId;

    if(schdulKindCode == "1"){
        vFrom.action = "<c:url value='/cop/smt/sdm/EgovDeptSchdulManageDetail.do' />";
    }else{
        vFrom.action = "<c:url value='/cop/smt/sim/EgovIndvdlSchdulManageDetail.do' />";
    }
    vFrom.submit();






}

/* ********************************************************
 * 검색 함수
 ******************************************************** */
function fn_egov_search_AllSchdulManage(){
    var vFrom = document.listForm;


    vFrom.action = "<c:url value='/cop/smt/sam/EgovAllSchdulManageList.do' />";
    vFrom.submit();

}

/* ********************************************************
* 선택 처리 함수
******************************************************** */
function fn_egov_open_Popup(cnt, schdulId){

    /* var opener = window.dialogArguments */
    var opener;
 
    if (window.dialogArguments) {
        opener = window.dialogArguments; // Support IE
    } else {
        opener = window.opener;    // Support Chrome, Firefox, Safari, Opera
    }

    opener.document.getElementById("schdulId").value = schdulId;
    opener.document.getElementById("schdulCn").value = document.getElementById("iptText_"+ cnt).value;

    window.returnValue=true;
    window.close();
}
</script>

	<style TYPE="text/css">
		body {
		scrollbar-face-color: #F6F6F6;
		scrollbar-highlight-color: #bbbbbb;
		scrollbar-3dlight-color: #FFFFFF;
		scrollbar-shadow-color: #bbbbbb;
		scrollbar-darkshadow-color: #FFFFFF;
		scrollbar-track-color: #FFFFFF;
		scrollbar-arrow-color: #bbbbbb;
		margin-left:"0px"; margin-right:"0px"; margin-top:"0px"; margin-bottom:"0px";
		}

		td {font-family: "돋움"; font-size: 9pt; color:#595959;}
		th {font-family: "돋움"; font-size: 9pt; color:#000000;}
		select {font-family: "돋움"; font-size: 9pt; color:#595959;}


		.divDotText {
		overflow:hidden;
		text-overflow:ellipsis;
		}

		A:link { font-size:10pt; font-family:"돋움";color:#000000; text-decoration:none; }
		A:visited { font-size:10pt; font-family:"돋움";color:#000000; text-decoration:none; }
		A:active { font-size:10pt; font-family:"돋움";color:red; text-decoration:none; }
		A:hover { font-size:10pt; font-family:"돋움";color:red;text-decoration:none;}
	</style>


</head>
<!-- 전체 레이어 시작 -->
<div id="wrap">
<!-- header 시작 -->
<div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
<div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div>
<!-- //header 끝 -->
<!-- container 시작 -->
<div id="container">
<!-- 좌측메뉴 시작 -->
<div id="leftmenu"><c:import url="/sym/mms/EgovMainMenuLeft.do" /></div>
<!-- //좌측메뉴 끝 -->
<!-- 현재위치 네비게이션 시작 -->
<DIV id="content" style="width:712px">
<div id="cur_loc" style="width:712px;">
    <div id="cur_loc_align">
        <ul>
            <li>HOME</li>
            <li>&gt;</li>
            <li>일정관리</li>
            <li>&gt;</li>					            
            <li><strong>일정조회</strong></li>
        </ul>
    </div>
</div>
<div id="search_field">
	<div id="search_field_loc">
		<h2>
			<strong>일정조회</strong>
		</h2>
	</div>
</div>
<form name="listForm" action="<c:url value='/cop/smt/sam/EgovAllSchdulManageList.do'/>" method="post">
<br>
<table width="100%" cellpadding="1" class="table-search" border="0">
 <tr>
  <td class="title_left">
    <h1 style="width: 366px;">
        <%-- <img src="<c:url value='/images/tit_icon.gif'/>" width="16" height="16" hspace="3" align="middle" alt="제목아이콘이미지">&nbsp;전체일정 목록 --%>
    </h1>
  </td>
  <th>
  </th>
  <td width="110px">
    <select name="searchCondition" class="select" style="width:100%"  title="검색조건선택">
           <option value=''>--선택하세요--</option>
           <option value='SCHDUL_NM' <c:if test="${searchCondition == 'SCHDUL_NM'}">selected</c:if>>일정명</option>
           <option value='SCHDUL_CN' <c:if test="${searchCondition == 'SCHDUL_CN'}">selected</c:if>>일정내용</option>
       </select>
    </td>
  <td width="180px">
    <input name="searchKeyword" type="text" size="10" value="${searchKeyword}" maxlength="35" style="width:100%" title="검색어 입력">
  </td>
  <td></td>
  <th width="30px" align="center">
   <table border="0" cellspacing="0" cellpadding="0" align="center">
    <tr>
      <td></td>
      <td><span class="button"><input type="submit" value="<spring:message code="button.inquire" />" onclick="fn_egov_search_AllSchdulManage(); return false;" ></span></td>
    </tr>
   </table>
  </th>
 </tr>
</table>
<input name="schdulId" type="hidden" value="">
<input name="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
<input name="linkType" type="hidden" value="sam">
</form>

<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <td height="3px"></td>
</tr>
</table>
<div class="modify_user3">
<!-- <table width="100%" cellpadding="0" class="table-line" border="0"  summary="순번 ,일정구분,일지명 ,등록자,등록일  목록입니다" > -->
<table width="100%" cellpadding="0" cellspacing="0"  class="table-line" border="0"  summary="순번 ,일정구분,일지명 ,등록자,등록일  목록입니다" >
<thead>
<tr>
    <th scope="col" class="title" width="35px" nowrap>순번</th>
    <th scope="col" class="title" width="100px" nowrap>일정구분</th>
    <th scope="col" class="title" nowrap>일지명</th>

    <th scope="col" class="title" width="80px" nowrap>등록자</th>
    <th scope="col" class="title" width="80px" nowrap>등록일</th>
</tr>
</thead>
<tbody>
<%-- 데이터를 없을때 화면에 메세지를 출력해준다 --%>
<c:if test="${fn:length(resultList) == 0}">
<tr>
<td class="lt_text3" colspan="5">
    <spring:message code="common.nodata.msg" />
</td>
</tr>
</c:if>
<%-- 데이터를 화면에 출력해준다 --%>
<c:forEach items="${resultList}" var="resultInfo" varStatus="status">
  <tr>
        <td class="lt_text3">${(searchVO.pageIndex-1) * searchVO.pageSize + status.count}</td>
        <td class="lt_text3">
         <c:if test="${resultInfo.schdulKindCode == '1'}">부서일정</c:if>
         <c:if test="${resultInfo.schdulKindCode == '2'}">개인일정</c:if>
        </td>
        <td class="lt_text3L">
            <form name="subForm" method="post" <c:if test="${resultInfo.schdulKindCode == '1'}">action="<c:url value='/cop/smt/sdm/EgovDeptSchdulManageDetail.do'/>"</c:if><c:if test="${resultInfo.schdulKindCode == '2'}">action="<c:url value='/cop/smt/sim/EgovIndvdlSchdulManageDetail.do'/>"</c:if> >
                <input name="schdulId" type="hidden" value="<c:out value='${resultInfo.schdulId}'/>">
                <input name="pageIndex" type="hidden" value="<c:out value='${searchVO.pageIndex}'/>"/>
                <span class="link"><input type="submit" style="width:320px;border:solid 0px black;text-align:left;" value="<c:out value="${resultInfo.schdulNm}"/>" onclick="JavaScript:fn_egov_detail_AllSchdulManage('${resultInfo.schdulKindCode}','${resultInfo.schdulId}'); return false;"></span>
            </form>
        </td>
        <td class="lt_text3">${resultInfo.frstRegisterNm}</td>
        <td class="lt_text3">${fn:substring(resultInfo.frstRegisterPnttm, 0, 10)}</td>

  </tr>
</c:forEach>
</tbody>
</table>
</div>

<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <td height="3px"></td>
</tr>
</table>

<div align="center">
    <div>
        <ui:pagination paginationInfo = "${paginationInfo}"
                type="image"
                jsFunction="linkPage"
                />
    </div>
</div>
<%--
<c:set var="today" value="<%=new java.util.Date()%>"/>
<fmt:formatDate value="${today}" type="DATE" pattern="yyyy년 MM월 dd일(E) a KK시 mm분 ss초" />

<fmt:parseDate value="${todayS}" var="today" pattern="yyyymmdd"/>

${parseDate}
 --%>
 </DIV>
 </div>
<!-- //content 끝 -->
</div>
<!-- //container 끝 -->
<div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div>
<!-- //전체 레이어 끝 -->
 </html>

