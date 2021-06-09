<%--
  Class Name : EgovIncFooter.jsp
  Description : 화면하단 Footer(include)
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2011.08.31   JJY       경량환경 버전 생성
     2019.02.08   YMHA   제이렘 버전 수정
 
    author   : 실행환경개발팀 JJY
    since    : 2011.08.31 
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<div style="height: 31px;">
   <div id="left_logo" style="height: 100%; margin-left: 5px; float: left;">
       <img src="<c:url value='/'/>images/footer/Footer_left.png" style="height: 100%; " />
   </div>
   <div id="right_logo" style="height: 100%; margin-right: 0px; float: right;">
       <img src="<c:url value='/'/>images/footer/Footer_right.png" style="height: 100%; " />
   </div>
</div>