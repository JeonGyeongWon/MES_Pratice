<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@page import="org.apache.ibatis.annotations.Param"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
<%
           Throwable ex = (Throwable)request.getAttribute("exception");
           ex.printStackTrace();
 %>
<html>
<head>
<title>알 수 없는 오류 발생</title>
</head>
<script type="text/javascript">
function fncGoAfterErrorPage(){
    history.back(-2);
}
</script>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: 100%;">
    <div class="warningArea" style="width: 100%; height: calc(100vh - 11px); background: none;">
        <center style="position: absolute; top: 0; bottom: 0; left: 0; right: 0; margin: auto;">
        <div style="width: 100%; transform: translate(0%, 125%);">
            <img src="<c:url value='/images/egovframework/com/cmm/danger.jpg' />" alt="" style="width: 35px; height: 35px; margin-top: 10px; display: block; " />
            <font style="color: gray; font-size: 25px; line-height: 25px; margin-top: 20px; margin-left: auto; margin-right: auto; display: block;">알 수 없는 오류가 발생했습니다.</font>
            <br /><br />
            <i style="color: orange; font-size: 20px; line-height: 20px; margin-top: 20px; margin-left: auto; margin-right: auto; display: block;">관리자에게 문의주세요.</i>
            <br /><br />
            <br /><br />
            <button onClick="fncGoAfterErrorPage();" class="btn btn-danger" style="display: block;">이전 화면으로</button>
        </div>
        </center>
    </div>
</body>
</html>