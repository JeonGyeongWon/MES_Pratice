<%--
  Class Name : EgovUserSelectUpdt.jsp
  Description : 사용자상세조회, 수정 JSP
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2009.03.03   JJY              최초 생성
     2011.08.31   JJY       경량환경 버전 생성
 
    author   : 공통서비스 개발팀 JJY
    since    : 2009.03.03
--%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>

<meta http-equiv="Content-Language" content="ko" >
<%-- <link href="<c:url value='/'/>css/common.css" rel="stylesheet" type="text/css" > --%>
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />

<title>사용자 상세 및 수정</title>
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="userManageVO" staticJavascript="false" xhtml="true" cdata="false"/>
<script type="text/javascript" src="<c:url value='/js/EgovZipPopup.js' />" ></script>
<script type="text/javaScript" language="javascript" defer="defer">
<!--
function fnListPage(){
    document.userManageVO.action = "<c:url value='/uss/umt/user/EgovUserManage.do'/>";
    document.userManageVO.submit();
}
function fnDeleteUser(checkedIds) {
    if(confirm("<spring:message code="common.delete.msg" />")){
        document.userManageVO.checkedIdForDel.value=checkedIds;
        document.userManageVO.action = "<c:url value='/uss/umt/user/EgovUserDelete.do'/>";
        document.userManageVO.submit(); 
    }
}
function fnPasswordMove(){
    document.userManageVO.action = "<c:url value='/uss/umt/user/EgovUserPasswordUpdtView.do'/>";
    document.userManageVO.submit();
}
function fnUpdate(){
    if(validateUserManageVO(document.userManageVO)){
        document.userManageVO.submit();
    }
}
function fn_egov_inqire_cert() {
    var url = '/uat/uia/EgovGpkiRegist.do';
    var popupwidth = '500';
    var popupheight = '400';
    var title = '인증서';

    Top = (window.screen.height - popupheight) / 3;
    Left = (window.screen.width - popupwidth) / 2;
    if (Top < 0) Top = 0;
    if (Left < 0) Left = 0;
    Future = "fullscreen=no,toolbar=no,location=no,directories=no,status=no,menubar=no, scrollbars=no,resizable=no,left=" + Left + ",top=" + Top + ",width=" + popupwidth + ",height=" + popupheight;
    PopUpWindow = window.open(url, title, Future)
    PopUpWindow.focus();
}

function fn_egov_dn_info_setting(dn) {
    var frm = document.userManageVO;
    
    frm.subDn.value = dn;
}
//-->
</script>

</head>
<body>
<noscript>자바스크립트를 지원하지 않는 브라우저에서는 일부 기능을 사용하실 수 없습니다.</noscript>    
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
            <div id="content">
                <div id="cur_loc">
                    <div id="cur_loc_align">
                        <ul>
                            <li>HOME</li>
                            <li>&gt;</li>
                            <li>내부시스템관리</li>
                            <li>&gt;</li>
                            <li><strong>사용자관리</strong></li>
                        </ul>
                    </div>
                </div>
                <!-- 검색 필드 박스 시작 -->
                <div id="search_field">
                    <div id="search_field_loc"><h2><strong>사용자 상세조회(수정)</strong></h2></div>
                </div>
		        <form:form commandName="userManageVO" action="${pageContext.request.contextPath}/uss/umt/user/EgovUserSelectUpdt.do" name="userManageVO" method="post" >
		        
			        <!-- 상세정보 사용자 삭제시 prameter 전달용 input -->
			        <input name="checkedIdForDel" type="hidden" />
			        <!-- 검색조건 유지 -->
			        <input type="hidden" name="searchCondition" value="<c:out value='${userSearchVO.searchCondition}'/>"/>
			        <input type="hidden" name="searchKeyword" value="<c:out value='${userSearchVO.searchKeyword}'/>"/>
			        <input type="hidden" name="sbscrbSttus" value="<c:out value='${userSearchVO.sbscrbSttus}'/>"/>
			        <input type="hidden" name="pageIndex" value="<c:out value='${userSearchVO.pageIndex}'/>"/>
			        <!-- 우편번호검색 -->
			        <input type="hidden" name="zip_url" value="<c:url value='/sym/cmm/EgovCcmZipSearchPopup.do'/>" />
			        <!-- 사용자유형정보 : password 수정화면으로 이동시 타겟 유형정보 확인용, 만약검색조건으로 유형이 포함될경우 혼란을 피하기위해 userTy명칭을 쓰지 않음-->
			        <input type="hidden" name="userTyForPassword" value="<c:out value='${userManageVO.userTy}'/>" />

                    <div class="modify_user" >
                        <table>
                            <tr> 
								<th width="20%" height="23" class="required_text">그룹아이디
                                    <img src="<c:url value='/'/>images/required.gif" width="15" height="15" alt="필수" />
                                </th>
				                <td width="30%" >
									<c:forEach var="result" items="${groupId_result}" varStatus="status">
										${result.code == userManageVO.groupId ?  result.codeNm : ""}									
									</c:forEach>
				                    
				                </td>

				                <th width="20%" height="23">사용자아이디</th>
				                <td width="30%" >
								 ${userManageVO.emplyrId}
				                    <form:hidden path="uniqId" />
									<form:hidden path="emplyrId" />
				                </td>
                            </tr>
                            <tr> 
                                <th width="20%" height="23" class="required_text">이름(거래처명)</th>
				                <td width="30%" >${userManageVO.emplyrNm}</td>
								<th width="20%" height="23" class="required_text">거래처코드</th>
				                <td width="30%" >${userManageVO.vendorId=='-1' ? '' : userManageVO.vendorId}</td>
                            </tr>
							 <tr> 
                                <th width="20%" height="23" class="required_text">지점명</th>
				                <td width="30%" >${userManageVO.vendorSiteName}</td>
								<th width="20%" height="23" class="required_text">지점코드</th>
				                <td width="30%" >${userManageVO.vendorSiteId=='-1' ? '' : userManageVO.vendorSiteId}</td>
                            </tr>

							<tr> 
                                <th width="20%" height="23" class="required_text">사업자등록번호</th>
				                <td width="30%" >${userManageVO.registNum}</td>
								<th width="20%" height="23" class="required_text">대표자명</th>
				                <td width="30%" >${userManageVO.leader}</td>								
                            </tr>

							<tr> 
								<th width="20%" height="23" class="required_text">전화번호</th>
				                <td width="30%" >${userManageVO.offmTelno}</td>
                                
								<th width="20%" height="23" class="required_text">FAX</th>
				                <td width="30%" >${userManageVO.fax}</td>
                            </tr>
                            <tr>
                                <th width="20%" height="23" class="required_text" >이메일주소</th>
				                <td width="30%" colspan="3">${userManageVO.email}</td>
                            </tr>
                            <tr>
                                <th width="20%" height="23" class="required_text"  >주소
                                </th>
				                <td colspan="3">${userManageVO.addr1} ${userManageVO.addr2} ${userManageVO.zip}</td>
                            </tr>
                        </table>
                    </div>

                    <!-- 버튼 시작(상세지정 style로 div에 지정) -->
                    <div class="buttons" style="padding-top:10px;padding-bottom:10px;">

                       <!-- 목록/저장버튼  -->
                       <table border="0" cellspacing="0" cellpadding="0" align="center">
                        <tr> 
                          <!--td>
                            <a href="#LINK" onclick="JavaScript:fnUpdate(); return false;"><spring:message code="button.save" /></a>
                          </td>
                          <td width="10"></td-->
                          <td>
                            <a class="btn_delete" href="<c:url value='/uss/umt/user/EgovUserDelete.do'/>" onclick="fnDeleteUser('<c:out value='${userManageVO.userTy}'/>:<c:out value='${userManageVO.uniqId}'/>'); return false;"><spring:message code="button.delete" /></a> 
                          </td>
<!--                           <td width="10"></td> -->
                          <td>
                            <a class="btn_list" href="<c:url value='/uss/umt/user/EgovUserManage.do'/>" onclick="fnListPage(); return false;"><spring:message code="button.list" /></a>
                          </td>      
<!--                           <td width="10"></td> -->
                          <td>
                            <a class="btn_unlock" href="<c:url value='/uss/umt/user/EgovUserPasswordUpdtView.do'/>" onclick="fnPasswordMove(); return false;"><spring:message code="button.passwordUpdate" /></a>
                          </td>      
<!--                           <td width="10"></td> -->
                          <td>
                            <a class="btn_cancel" href="#LINK" onclick="javascript:document.userManageVO.reset();"><spring:message code="button.reset" /></a>
                          </td>      

                        </tr>
                       </table>
                    </div>
                    <!-- 버튼 끝 -->    
                    <form:hidden path="password" />                       
                </form:form>

            </div>  
            <!-- //content 끝 -->    
    </div>  
    <!-- //container 끝 -->
    <!-- footer 시작 -->
    <div id="footer"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" /></div>
    <!-- //footer 끝 -->
</div>
<!-- //전체 레이어 끝 -->
</body>
</html>

