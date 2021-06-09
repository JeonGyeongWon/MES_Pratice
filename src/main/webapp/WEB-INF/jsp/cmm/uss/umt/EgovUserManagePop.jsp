
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
<meta http-equiv="content-language" content="ko">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/zip.css'/>" >
<link href="<c:url value='/'/>css/common.css" rel="stylesheet" type="text/css" >
<title>거래처 찾기</title>
<script type="text/javaScript" language="JavaScript">
<!--
/* ********************************************************
 * 페이징 처리 함수
 ******************************************************** */
function fn_egov_pageview(pageNo){
	document.listForm.pageIndex.value = pageNo;
   	document.listForm.submit();
}
/* ********************************************************
 * 조회 처리 
 ******************************************************** */
function fn_egov_search_Zip(){
	document.listForm.pageIndex.value = 1;
   	document.listForm.submit();
}
/* ********************************************************
 * 결과 우편번호,주소 반환 
 ******************************************************** */
function fn_egov_return_Zip(zip,addr){
	var retVal   = new Object();
	var sZip     = zip;
	var vZip     = zip.substring(0,3)+"-"+zip.substring(3,6);
	var sAddr    = addr.replace("/^\s+|\s+$/g","");
	retVal.sZip  = sZip;
	retVal.vZip  = vZip;
	retVal.sAddr = sAddr;
	//parent.window.returnValue = retVal;
	//parent.window.close();
}

String.prototype.replaceAll = function (str1,str2){
 var str    = this;     
 var result   = str.replace(eval("/"+str1+"/gi"),str2);
 return result;
}


function setUserInfo( vendorId, vendorSiteId, vendorName, vendorSiteName, offmTelno, registNum){
	if( "${userSearchVO.flag}" == "POP" ){
	opener.userManageVO.vendorId.value = vendorId;
	opener.userManageVO.vendorSiteId.value = vendorSiteId;
	opener.userManageVO.vendorName.value = vendorName;
	opener.userManageVO.emplyrNm.value = vendorName;
	opener.userManageVO.vendorSiteName.value = vendorSiteName;
	opener.userManageVO.offmTelno.value = offmTelno;
	opener.userManageVO.password.value =  registNum.replaceAll("-","");
	opener.userManageVO.password2.value =  registNum.replaceAll("-","");
	
	opener.userManageVO.emplyrId.value = "자동생성됩니다";
	opener.userManageVO.id_view.value = "자동생성됩니다";
	}else if( "${userSearchVO.flag}" == "POP2" || "${userSearchVO.flag}" == "CARPOP" ){
		opener.listForm.searchVendorSiteId.value = vendorSiteId;
		opener.listForm.searchVendorSiteName.value = vendorName;
	}else if( "${userSearchVO.flag}" == "POP4"){
		opener.frm.searchVendorSiteId.value = vendorSiteId;
		opener.frm.searchVendorSiteName.value = vendorName;
	}else if( "${userSearchVO.flag}" == "POP3" ){
		opener.listForm.searchVendorSiteId.value = vendorSiteId;
		opener.listForm.searchVendorSiteName.value = vendorName;
		opener.getSubInventoryList();
	}
	
	//parent.window.returnValue = retVal;
	parent.window.close();
}

function init(){
	document.listForm.searchKeyword.focus();
}

//-->
</script>
</head>

<body onLoad="javascript:init()">
<!-- 자바스크립트 경고 태그  -->
<noscript class="noScriptTitle">자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다.</noscript>

<form name="listForm" action="<c:url value='/uss/umt/user/EgovUserManage.do?flag=${userSearchVO.flag}'/>" method="post">
	<input name="selectedId" type="hidden" />
	<input name="checkedIdForDel" type="hidden" />
	<input name="pageIndex" type="hidden" value="<c:out value='${userSearchVO.pageIndex}'/>"/>
	

<table style="width:550px" cellpadding="8" class="table-search" border="0">
 <tr>
  <td style="width:35%" class="title_left">
		<img src="<c:url value='/images/tit_icon.gif'/>" width="16" height="16" hspace="3" align="middle" alt="제목"/> 거래처 찾기
  </td>
  <td style="width:60%" class="title_right">
    	거래처명 <input name="searchKeyword" type="text" size="20" value="${userSearchVO.searchKeyword}"  maxlength="20" title="거래처명" style="ime-mode:active;"/> 
  </td>
  <th style="width:5%">
   <table border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td><img src="<c:url value='/images/bu2_left.gif'/>" alt="조회" width="8" height="20" /></td>
      <td class="btnBackground" nowrap="nowrap"><input type="submit" value="조회" onclick="javascript:fn_egov_search_Zip();" class="btnNew" style="height:20px;width:26px;padding:0px 0px 0px 0px;" ></td>
      <td><img src="<c:url value='/images/bu2_right.gif'/>" alt="조회" width="8" height="20" /></td>
      <td width="10"></td>
    </tr>
   </table>
   
  </th>  
 </tr>
</table>

<table style="width:550px" cellpadding="0" class="table-line" border="0" summary="우편번호 건색 결과를 알려주는 테이블입니다.우편번호 및 주소 내용을 담고 있습니다">
<thead>
<tr>  
	<th class="title" style="width:30%" scope="col" nowrap="nowrap">거래처명</th>
	<th class="title" style="width:30%" scope="col" nowrap="nowrap">지점명</th>
	<th class="title" style="width:20%" scope="col" nowrap="nowrap">지점코드</th>
	<th class="title" style="width:20%" scope="col" nowrap="nowrap">전화번호</th>
	<th class="title" style="width:20%" scope="col" nowrap="nowrap">USER ID</th>
</tr>
</thead>
	<input type="hidden" name="vendorId" value="" />
			<input type="hidden" name="vendorSiteId" value="" />
			<input type="hidden" name="vendorName" value="" />
			<input type="hidden" name="vendorSiteName" value="" />
<tbody>
<c:forEach var="result" items="${resultList}" varStatus="status">
<tr style="cursor:pointer;cursor:hand;" onclick="javascript:setUserInfo( '${result.vendorId}', '${result.vendorSiteId}', '${result.vendorName}', '${result.vendorSiteName}', '${result.offmTelno}', '${result.registNum}');">
	<td class="lt_text" nowrap="nowrap" height="20" >${result.vendorName}</td>
	<td class="lt_text" nowrap="nowrap" >${result.vendorSiteName}</td>
	<td class="lt_text" nowrap="nowrap" >${result.vendorSiteId}</td>
	<td class="lt_text" nowrap="nowrap">${result.offmTelno}</td>
	<td class="lt_text" nowrap="nowrap">${result.userId}</td>
</tr>   
</c:forEach>
</tbody>  
</table>

<table style="width:550px" cellspacing="0" cellpadding="0" border="0">
<tr>
	<td height="3px"></td>
</tr>
</table>

<div align="center">
	<div>
	<ul class="paging_align">
		<ui:pagination paginationInfo = "${paginationInfo}"
				type="image"
				jsFunction="fn_egov_pageview"
				/>
	</ul>
	</div>
	
</div>
 


</form>
</body>
</html>


