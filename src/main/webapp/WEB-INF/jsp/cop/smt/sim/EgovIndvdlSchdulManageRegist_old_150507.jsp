<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
  Class Name : EgovIndvdlSchdulManageRegist.jsp
  Description : 일정관리 등록 페이지
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
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import ="egovframework.com.cmm.LoginVO" %>
<%@ page import="java.util.Map"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="egovframework.rte.psl.dataaccess.util.EgovMap"%>

<c:set var="ImgUrl" value="/images/egovframework/let/cop/smt/sim/"/>
<c:set var="CssUrl" value="/css/egovframework/let/cop/smt/sim/"/>

<%
  /* Image Path 설정 */
  String imagePath_icon   = "/images/egovframework/sym/mpm/icon/";
  String imagePath_button = "/images/egovframework/sym/mpm/button/";
%>

<html lang="ko">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<meta http-equiv="content-language" content="ko">
<link type="text/css" rel="stylesheet" href="<c:url value='/css/com.css' />" >
<link href="<c:url value='/'/>css/common.css" rel="stylesheet" type="text/css" >
<link type="text/css" rel="stylesheet" href="<c:url value='/css/button.css'/>">
<script type="text/javascript" src="<c:url value='/js/common.js'/>" ></script>
<script type="text/javascript" src="<c:url value='/js/EgovCalPopup.js'/>" ></script>
<script type="text/javascript" src="<c:url value='/js/EgovMultiFile.js'/>" ></script>
<title>일정관리</title>

<style type="text/css">
    h1 {font-size:12px;}
    caption {visibility:hidden; font-size:0; height:0; margin:0; padding:0; line-height:0;}
</style>
    

<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="indvdlSchdulManageVO" staticJavascript="false" xhtml="true" cdata="false"/>

<script type="text/javaScript" language="javascript">


/* ********************************************************
 * 초기화
 ******************************************************** */
function fn_egov_init_IndvdlSchdulManage(){

       var maxFileNum = document.getElementById('posblAtchFileNumber').value;

       if(maxFileNum==null || maxFileNum==""){
            maxFileNum = 3;
        }

       var multi_selector = new MultiSelector( document.getElementById( 'egovComFileList' ), maxFileNum );

       multi_selector.addElement( document.getElementById( 'egovComFileUploader' ) );


       document.getElementsByName('reptitSeCode')[0].checked = true;


       if("${indvdlSchdulManageVO.schdulBgnde}".length > 0){
           var schdulBgnde = "${indvdlSchdulManageVO.schdulBgnde}";
           document.getElementById("schdulBgndeYYYMMDD").value = schdulBgnde.substring(0,4) + "-" + schdulBgnde.substring(4,6) + "-" + schdulBgnde.substring(6,8);
       }

       if("${indvdlSchdulManageVO.schdulEndde}".length > 0){
           var schdulEndde = "${indvdlSchdulManageVO.schdulEndde}";
           document.getElementById("schdulEnddeYYYMMDD").value = schdulEndde.substring(0,4) + "-" + schdulEndde.substring(4,6) + "-" + schdulEndde.substring(6,8);
       }
}
/* ********************************************************
 * 목록 으로 가기
 ******************************************************** */
function fn_egov_list_IndvdlSchdulManage(){
    /* location.href = "<c:url value='/cop/smt/sim/EgovIndvdlSchdulManageList.do' />"; */
    location.href = "<c:url value='/cop/smt/sim/EgovIndvdlSchdulManageMonthList.do' />";    
}
/* ********************************************************
 * 저장처리화면
 ******************************************************** */
function fn_egov_save_IndvdlSchdulManage(form){
    //form.submit();return;
    /* alert('00 form.schdulBgnde.value : ');
    alert('03 form.schdulBgnde.value : '+form);
    alert('02 form.schdulBgndeHH.value : '+document.getElementById("schdulBgndeHH").value); */
    var schdulBgndeYYYMMDD = document.indvdlSchdulManageVO.schdulBgndeYYYMMDD.value;
    var schdulEnddeYYYMMDD = document.indvdlSchdulManageVO.schdulEnddeYYYMMDD.value;
    var schdulBgndeHH = document.indvdlSchdulManageVO.schdulBgndeHH.value;
    var schdulBgndeMM = document.indvdlSchdulManageVO.schdulBgndeMM.value;
    var schdulEnddeHH = document.indvdlSchdulManageVO.schdulEnddeHH.value;
    var schdulEnddeMM = document.indvdlSchdulManageVO.schdulEnddeMM.value;
    
    /* alert('00 schdulBgndeHH : '+schdulBgndeHH.value); */
     if(confirm("<spring:message code="common.save.msg" />")){
    	 var schdulBgnde = document.indvdlSchdulManageVO.schdulBgnde;
    	 var schdulEndde = document.indvdlSchdulManageVO.schdulEndde;

         schdulBgnde.value = schdulBgndeYYYMMDD.replaceAll('-','') + schdulBgndeHH +  schdulBgndeMM;
         schdulEndde.value = schdulEnddeYYYMMDD.replaceAll('-','') + schdulEnddeHH +  schdulEnddeMM;

         /* alert('03 schdulBgnde.value : '+ schdulBgnde.value); */
    	   /* alert('04 form.schdulBgnde.value : '+form); */
        if(!validateIndvdlSchdulManageVO(form)){
        	/* alert('01 form.schdulBgnde.value : '+ document.getElementById('schdulBgndeYYYMMDD').value); */
            return;
        }else{
        	/* alert('02 form.schdulBgnde.value : '); */
            /* var schdulBgndeYYYMMDD = document.getElementById('schdulBgndeYYYMMDD').value;
            var schdulEnddeYYYMMDD = document.getElementById('schdulEnddeYYYMMDD').value; */

            /* alert('04 form.schdulBgnde.value : '+schdulEnddeYYYMMDD); */
            /* schdulBgnde.value = schdulBgndeYYYMMDD.replaceAll('-','') + schdulBgndeHH +  schdulBgndeMM;
            schdulEndde.value = schdulEnddeYYYMMDD.replaceAll('-','') + schdulEnddeHH +  schdulEnddeMM; */
            
            /* alert('03 schdulBgnde.value : '+ schdulBgnde.value); */
            
            /* alert('03 form.schdulBgnde.value : '+ form.schdulBgnde.value);
            alert('04 form.schdulEndde.value : '+ form.schdulEndde.value); */
            
            form.submit();
        }
    }
}

/* ********************************************************
* 주관 부서 팝업창열기
******************************************************** */
function fn_egov_schdulDept_DeptSchdulManage(){

    var arrParam = new Array(1);
    arrParam[0] = self;
    arrParam[1] = "typeDeptSchdule";

    window.showModalDialog("<c:url value='/uss/olp/mgt/EgovMeetingManageLisAuthorGroupPopup.do' />", arrParam ,"dialogWidth=800px;dialogHeight=500px;resizable=yes;center=yes");
}

/* ********************************************************
* 아이디  팝업창열기
******************************************************** */
function fn_egov_schdulCharger_DeptSchdulManagee(){
    var arrParam = new Array(1);
    arrParam[0] = window;
    arrParam[1] = "typeDeptSchdule";

    window.showModalDialog("<c:url value='/uss/olp/mgt/EgovMeetingManageLisEmpLyrPopup.do' />", arrParam,"dialogWidth=800px;dialogHeight=500px;resizable=yes;center=yes");
}

/* ********************************************************
* RADIO BOX VALUE FUNCTION
******************************************************** */
function fn_egov_RadioBoxValue(sbName)
{
    var FLength = document.getElementsByName(sbName).length;
    var FValue = "";
    for(var i=0; i < FLength; i++)
    {
        if(document.getElementsByName(sbName)[i].checked == true){
            FValue = document.getElementsByName(sbName)[i].value;
        }
    }
    return FValue;
}
/* ********************************************************
* SELECT BOX VALUE FUNCTION
******************************************************** */
function fn_egov_SelectBoxValue(sbName)
{
    var FValue = "";
    for(var i=0; i < document.getElementById(sbName).length; i++)
    {
        if(document.getElementById(sbName).options[i].selected == true){

            FValue=document.getElementById(sbName).options[i].value;
        }
    }

    return  FValue;
}
/* ********************************************************
* PROTOTYPE JS FUNCTION
******************************************************** */
String.prototype.trim = function(){
    return this.replace(/^\s+|\s+$/g, "");
}

String.prototype.replaceAll = function(src, repl){
     var str = this;
     if(src == repl){return str;}
     while(str.indexOf(src) != -1) {
        str = str.replace(src, repl);
     }
     return str;
}
</script>
</head>
<body onLoad="fn_egov_init_IndvdlSchdulManage()">
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
<!--  상단타이틀 -->
<br>
<form:form commandName="indvdlSchdulManageVO" action="${pageContext.request.contextPath}/cop/smt/sim/EgovIndvdlSchdulManageRegistActor.do" name="indvdlSchdulManageVO" method="post" enctype="multipart/form-data">
<!--  상단 타이틀  영역 -->
<table width="100%" cellpadding="8" class="table-search" border="0">
 <tr>
  <td width="100%"class="title_left">
   <img src="<c:url value='/'/>images/tit_icon.gif" width="16" height="16" hspace="3" align="middle" alt="제목아이콘이미지">&nbsp;일정관리 등록</td>
 </tr>
</table>
<!-- 줄간격조정  -->
<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <td height="3px"></td>
</tr>
</table>
<!-- 등록  폼 영역  -->
<!-- <div id="tablegraph" style="width: 600px; height:automatic+10px;"> -->
<div class="modify_user3">
<!-- <table width="100%" border="0" cellpadding="0" cellspacing="1" class="table-register"> -->
<table width="100%" border="0" cellpadding="0" cellspacing="1">
  <tr>
    <th width="20%" height="23" class="required_text" nowrap >일정구분<img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수입력표시"></th>
    <td width="80%" >
        <form:select path="schdulSe">
            <form:option value="" label="선택"/>
            <form:options items="${schdulSe}" itemValue="code" itemLabel="codeNm"/>
        </form:select>
        <div><form:errors path="schdulSe" cssClass="error"/></div>
    </td>
    </tr>
  <tr>
    <th width="20%" height="23" class="required_text" nowrap >중요도<img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수입력표시"></th>
    <td width="80%" >
        <form:select path="schdulIpcrCode">
            <form:option value="" label="선택"/>
            <form:options items="${schdulIpcrCode}" itemValue="code" itemLabel="codeNm"/>
        </form:select>
        <div><form:errors path="schdulIpcrCode" cssClass="error"/></div>
    </td>
 </tr>
  <tr>
    <th width="20%" height="23" class="required_text" nowrap >부서<img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수입력표시"></th>
<!--         <td width="80%" >
        <table width="100%" cellspacing="0" cellpadding="0" border="0">
        <tr> -->
            <!-- <td width="80%" style="padding:0px 0px 0px 0px;margin:0px 0px 0px 0px;"> -->
            <td width="80%" >
            <form:input path="schdulDeptName" size="73" cssClass="txaIpt" readonly="true" maxlength="1000" />
            <a href="#" onClick="fn_egov_schdulDept_DeptSchdulManage()">
            <img src="<c:url value='/'/>images/search.gif" align="middle" style="border:0px" alt="부서" title="부서">
            </a>
            </td>
            <%-- <td style="padding:0px 0px 0px 2px;margin:0px 0px 0px 0px;">
            <a href="#" onClick="fn_egov_schdulDept_DeptSchdulManage()">
            <img src="<c:url value='/'/>images/search.gif" align="middle" style="border:0px" alt="부서" title="부서">
            </a>
            </td> --%>
<!--         </tr>
        </table> -->
        <form:hidden path="schdulDeptId" />
        <div><form:errors path="schdulDeptName" cssClass="error"/></div>
 </tr>

  <tr>
    <th width="20%" height="23" class="required_text" nowrap >일정명<img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수입력표시"></th>
    <td width="80%" >
      <form:input path="schdulNm" size="73" cssClass="txaIpt" maxlength="255" />
      <div><form:errors path="schdulNm" cssClass="error"/></div>
    </td>
  </tr>
  <tr>
    <th width="20%" height="23" class="required_text" nowrap >일정 내용<img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수입력표시"></th>
    <td width="80%">
        <form:textarea path="schdulCn" size="73" rows="3" cols="71" cssClass="txaClass"/>
        <div><form:errors path="schdulCn" cssClass="error"/></div>
    </td>
  </tr>

  <tr>
    <th width="20%" height="23" class="required_text" nowrap >반복구분<img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수입력표시"></th>
    <td width="80%">
       <form:radiobutton path="reptitSeCode" value="1" />당일
       <form:radiobutton path="reptitSeCode" value="2"/>반복
       <form:radiobutton path="reptitSeCode" value="3"/>연속
       <div><form:errors path="reptitSeCode" cssClass="error"/></div>
    </td>
  </tr>
  <tr>
    <th width="20%" height="23" class="required_text" nowrap >날짜/시간<img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수입력표시"></th>
    <td width="80%" >
    <form:input path="schdulBgndeYYYMMDD" id="schdulBgndeYYYMMDD" name="schdulBgndeYYYMMDD" size="10" readonly="true" maxlength="10" />
    <a href="javascript:fn_egov_NormalCalendar(document.indvdlSchdulManageVO, document.indvdlSchdulManageVO.schdulBgndeYYYMMDD, document.indvdlSchdulManageVO.schdulBgndeYYYMMDD);">
    <img src="<c:url value='/'/>images/calendar.gif" align="middle" style="border:0px" alt="달력창팝업버튼이미지">    
    </a>            
    <%-- <form:input path="schdulBgndeYYYMMDD" size="10" readonly="true" maxlength="10" />
    <a href="#" onClick="javascript:fn_egov_NormalCalendar(document.forms, document.forms.schdulBgndeYYYMMDD, document.forms.schdulBgndeYYYMMDD);">
    <img src="<c:url value='/'/>images/calendar.gif" align="middle" style="border:0px" alt="달력창팝업버튼이미지">    
    </a> --%>                           
    &nbsp&nbsp~&nbsp&nbsp    
    <%-- <form:input path="schdulEnddeYYYMMDD" size="10" readonly="true" maxlength="10" />
    <a href="#" onClick="javascript:fn_egov_NormalCalendar(document.forms, document.forms.schdulEnddeYYYMMDD, document.forms.schdulEnddeYYYMMDD);">
    <img src="<c:url value='/'/>images/calendar.gif" align="middle" style="border:0px" alt="달력창팝업버튼이미지">    
    </a>&nbsp; --%>
    <form:input path="schdulEnddeYYYMMDD" id="schdulEnddeYYYMMDD" name="schdulEnddeYYYMMDD" size="10" readonly="true" maxlength="10" />
    <a href="javascript:fn_egov_NormalCalendar(document.indvdlSchdulManageVO, document.indvdlSchdulManageVO.schdulEnddeYYYMMDD, document.indvdlSchdulManageVO.schdulEnddeYYYMMDD);">
    <img src="<c:url value='/'/>images/calendar.gif" align="middle" style="border:0px" alt="달력창팝업버튼이미지">    
    </a>&nbsp;
    
        <form:select path="schdulBgndeHH" name="schdulBgndeHH">
            <form:options items="${schdulBgndeHH}" itemValue="code" itemLabel="codeNm"/>
        </form:select>시
        <form:select path="schdulBgndeMM" >
            <form:options items="${schdulBgndeMM}" itemValue="code" itemLabel="codeNm"/>
        </form:select>분
        ~
        <form:select path="schdulEnddeHH">
            <form:options items="${schdulEnddeHH}" itemValue="code" itemLabel="codeNm"/>
        </form:select>시
        <form:select path="schdulEnddeMM">
            <form:options items="${schdulEnddeMM}" itemValue="code" itemLabel="codeNm"/>
        </form:select>분
    </td>
  </tr>
  <tr>
    <th width="20%" height="23" class="required_text" nowrap >담당자<img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수입력표시"></th>
    <!-- <td width="80%" >
        <table cellspacing="0" cellpadding="0" border="0">
        <tr> -->
            <!-- <td width="100px" style="padding:0px 0px 0px 0px;margin:0px 0px 0px 0px;"> -->
            <td width="100px" >
            <form:input path="schdulChargerName" size="73" cssClass="txaIpt" readonly="true" maxlength="10" />
            <a href="#" onClick="fn_egov_schdulCharger_DeptSchdulManagee()">
            <img src="<c:url value='/'/>images/search.gif" align="middle" style="border:0px" alt="담당자" title="담당자">
            </a>
            </td>
            <%-- <td style="padding:0px 0px 0px 2px;margin:0px 0px 0px 0px;">
            <a href="#" onClick="fn_egov_schdulCharger_DeptSchdulManagee()">
            <img src="<c:url value='/'/>images/search.gif" align="middle" style="border:0px" alt="담당자" title="담당자">
            </a>
            </td> --%>
        <!-- </tr>
        </table> -->
        <div><form:errors path="schdulChargerName" cssClass="error"/></div>
       <form:hidden path="schdulChargerId" />

    </td>
  </tr>
<!--  첨부파일 테이블 레이아웃 설정 Start..-->
  <tr>
    <th rowspan="2" height="23" class="required_text" nowrap>파일첨부<img src="<c:url value='/images/egovframework/com/cmm/icon/no_required.gif'/>" width="15" height="15" alt="선택입력표시"></th>
    <!-- <td> -->
        <!-- <table width="580px" cellspacing="0" cellpadding="0" border="0" align="center" class="UseTable"> -->
            <!-- <tr> -->
                <td><input name="file_1" id="egovComFileUploader" type="file" title="첨부파일명 입력"/></td>
            </tr>
            <tr>
                <td>
                    <div id="egovComFileList"></div>
                </td>
            </tr>
        <!-- </table> -->
     <!-- </td> -->
  <!-- </tr> -->
<!-- 첨부파일 테이블 레이아웃 End.-->
</table>
</div>
<!-- </div> -->
<!--  줄간격조정  -->
<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
    <td height="3px"></td>
</tr>
</table>
<center>
<!-- 목록/저장버튼  -->
<table border="0" cellspacing="0" cellpadding="0" align="center">
<tr>
<!-- 
  <td><img src="<c:url value='/images/egovframework/com/cmm/button/bu2_left.gif'/>" width="8" height="20" alt="버튼이미지"></td>
  <td background="<c:url value='/images/egovframework/com/cmm/button/bu2_bg.gif' />" class="text_left" nowrap><a href="JavaScript:fn_egov_list_IndvdlSchdulManage();"><spring:message code="button.list" /></a>
  </td>
  <td><img src="<c:url value='/images/egovframework/com/cmm/button/bu2_right.gif' />" width="8" height="20" alt="버튼이미지"></td>
  <td>&nbsp;</td>
  <td><img src="<c:url value='/images/egovframework/com/cmm/button/bu2_left.gif' />" width="8" height="20" alt="버튼이미지"></td>
  <td background="<c:url value='/images/egovframework/com/cmm/button/bu2_bg.gif' />" class="text_left" nowrap><a href="JavaScript:fn_egov_save_IndvdlSchdulManage(document.forms[0]);"><spring:message code="button.save" /></a>
  </td>
  <td><img src="<c:url value='/images/egovframework/com/cmm/button/bu2_right.gif' />" width="8" height="20" alt="버튼이미지"></td>
 -->
  <td><span class="button"><input type="submit" value="<spring:message code="button.list" />" title="<spring:message code="button.list" />" onclick="javascript:fn_egov_list_IndvdlSchdulManage();return false;"></span></td>
  <td>&nbsp;</td>
  <td><span class="button"><input type="submit" value="<spring:message code="button.save" />" title="<spring:message code="button.save" />" onclick="javascript:fn_egov_save_IndvdlSchdulManage(document.forms[0]);return false;"></span></td>
</tr>
</table>
</center>
<input name="cmd" id="cmd"type="hidden" value="<c:out value='save'/>"/>
<input type="hidden" name="schdulKindCode" id="schdulKindCode" value="2" />
<input type="hidden" name="cal_url" id="cal_url" value="<c:url value='/sym/cmm/EgovNormalCalPopup.do'/>" />
<input type="hidden" name="schdulBgnde" id="schdulBgnde" value="" />
<input type="hidden" name="schdulEndde" id="schdulEndde" value="" />
<!-- 첨부파일 갯수를 위한 hidden -->
<input type="hidden" name="posblAtchFileNumber" id="posblAtchFileNumber" value="3" />
</form:form>
</DIV>
</div>
<!-- //content 끝 -->
</div>
<!-- //container 끝 -->
<div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div>
<!-- //전체 레이어 끝 -->
</body>
</html>