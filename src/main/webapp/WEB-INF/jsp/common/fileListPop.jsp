
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
<title>첨부파일</title>
<script type="text/javaScript" language="JavaScript">
<!--
function downFile(custSampleId){
	location.href="<c:url value='/common/FileDown.do?entityName=${entityName}&fileid='/>"+custSampleId;
}

//-->
</script>
</head>

<body onLoad="javascript:init()">
<!-- 자바스크립트 경고 태그  -->
<table style="width:550px" cellpadding="8" class="table-search" border="0">
 <tr>
  <td style="width:35%" class="title_left">
		<img src="<c:url value='/images/tit_icon.gif'/>" width="16" height="16" hspace="3" align="middle"/>파일목록
  </td> 
  <th style="width:5%">
   <table border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td><img src="<c:url value='/images/bu2_left.gif'/>" width="8" height="20" /></td>
      <td class="btnBackground" nowrap="nowrap"><input type="submit" value="닫기" onclick="javascript:self.close();" class="btnNew" style="height:20px;width:26px;padding:0px 0px 0px 0px;" ></td>
      <td><img src="<c:url value='/images/bu2_right.gif'/>" width="8" height="20" /></td>
      <td width="10"></td>
    </tr>
   </table>
   
  </th>  
 </tr>
</table>

<table style="width:550px" cellpadding="0" class="table-line" border="0">
<thead>
<tr>  
	<th class="title" style="width:100%" scope="col" nowrap="nowrap">파일명</th>
</tr>
</thead>
	<input type="hidden" name="vendorId" value="" />
			<input type="hidden" name="vendorSiteId" value="" />
			<input type="hidden" name="vendorName" value="" />
			<input type="hidden" name="vendorSiteName" value="" />
<tbody>
<c:forEach var="result" items="${resultList}" varStatus="status">
<tr>
	<td class="lt_text" nowrap="nowrap" height="20"><a href="<c:url value='/common/FileDown.do?fileId=${result.file_id}&entityName=${entityName}'/>">${result.file_name}</a></td>
</tr>   
</c:forEach>
    	
</tbody>  
</table>

<table style="width:550px" cellspacing="0" cellpadding="0" border="0">
<tr>
	<td height="3px"></td>
</tr>
</table>



</body>
</html>


