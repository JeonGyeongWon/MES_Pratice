<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="validator" uri="http://www.springmodules.org/tags/commons-validator"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Language" content="ko">
<%-- <link href="<c:url value='/'/>css/common.css" rel="stylesheet" type="text/css"> --%>
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
<title>${pageTitle}</title>
<script type="text/javascript" src="<c:url value="/validator.do"/>"></script>
<validator:javascript formName="passwordChgVO" staticJavascript="false" xhtml="true" cdata="false" />
<script type="text/javaScript" language="javascript" defer="defer">
<!--
var bCancel = false;
function validatePasswordChgVO_new(form) {
  if (bCancel)
    return true;
  else
    return validateRequired(form) && validatePassword2(form);
}

function fnUpdate() {
  if (validatePasswordChgVO_new(document.passwordChgVO)) {
    if (document.passwordChgVO.newPassword.value != document.passwordChgVO.newPassword2.value) {
      alert("<spring:message code="fail.user.passwordUpdate2" />");
      return;
    }
    document.passwordChgVO.submit();
  }
}

<c:if test="${!empty resultMsg}">
		alert("<spring:message code="${resultMsg}" />");
		if ("${resultMsg}" == "success.common.update") {
		  self.close();
		}
</c:if>
 
function init() {
  document.passwordChgVO.oldPassword.focus();
}
//-->
</script>
</head>
<%
  String user_id = ((LoginVO) session.getAttribute("LoginVO")).getId();
%>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" leftmargin="10px" onLoad="javascript:init()">
		<div id="container" style="margin-left: 10px;">
				<table border="0" cellspacing="2" cellpadding="0" width="350">
						<tr>
								<td colspan="2">
										<div id="search_field" style="margin-bottom: 0px;">
												<div id="search_field_loc">
														<h2>
																<strong>${pageTitle}</strong>
														</h2>
												</div>
										</div>
								</td>
						</tr>
						<tr>
		        <table class="tbl_type_view" border="0" style="width: 430px;">
				        <colgroup>
				                <col width="120px">
				                <col>
				        </colgroup>
		            <tr style="height: 34px;">
				            <td colspan="2">
				                <!-- 버튼 시작(상세지정 style로 div에 지정) -->
				                <div class="buttons"  style="float: right; margin-top: 3px;">
				                    <a href="#" class="btn_save" onclick="JavaScript:fnUpdate(); return false;"> <spring:message code="button.save" /></a>
				                    <a href="#" class="btn_cancel" onclick="javascript:self.close();"> <spring:message code="button.close" /></a>
				                    <%-- <a href="#" class="btn_cancel" onclick="javascript:document.passwordChgVO.reset();"> <spring:message code="button.reset" /></a> --%>
				                </div>
				            </td>
		            </tr>
		            <form name="passwordChgVO" method="post" action="${pageContext.request.contextPath}/uss/umt/user/EgovUserPasswordUpdt.do">
				            <input type="submit" id="invisible" class="invisible" />
				                <%--      <input type="hidden" name="searchCondition" value="<c:out value='${userSearchVO.searchCondition}'/>" /> --%>
				                <input type="hidden" name="searchCondition" value="pop" />
				                <tr style="height: 34px;">
				                    <th height="23">사용자 아이디</th>
				                    <td>
                                <input type="text" id="emplyrId" name="emplyrId" class="input_center" title="사용자아이디" size="20" value="<c:out value='${userManageVO.emplyrId}'/>" maxlength="20" readonly />
                                <input type="hidden" id="uniqId" name="uniqId" value="<c:out value='${userManageVO.uniqId}'/>" />
                                <input type="hidden" id="userTy" name="userTy" value="<c:out value='${userManageVO.userTy}'/>" />
				                    </td>
				                </tr>
				                <tr style="height: 34px;">
				                    <th height="23" class="required_text" nowrap>현재 비밀번호</th>
				                    <td nowrap="nowrap"><input class="input_center" id="oldPassword" name="oldPassword" title="기존 비밀번호" type="password" size="20" value="" maxlength="30" /></td>
				                </tr>
				                <tr style="height: 34px;">
				                    <th height="23" class="required_text" nowrap>비밀번호 변경</th>
				                    <td nowrap="nowrap"><input class="input_center" id="newPassword" name="newPassword" title="비밀번호" type="password" size="20" value="" maxlength="30" /></td>
				                </tr>
				                <tr style="height: 34px;">
				                    <th height="23" class="required_text" nowrap>비밀번호 확인</th>
				                    <td nowrap="nowrap"><input class="input_center" id="newPassword2" name="newPassword2" title="비밀번호확인" type="password" size="20" value="" maxlength="30" /></td>
				                </tr>
				            </table>
		            </form>
						</tr>
            <tr>
                <td height="15" colspan="2"></td>
            </tr>
				</table>
		</div>

</body>
</html>