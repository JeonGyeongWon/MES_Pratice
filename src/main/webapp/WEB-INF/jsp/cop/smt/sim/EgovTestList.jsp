<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%--
  Class Name : EgovIndvdlSchdulManageList.jsp
  Description : 일정관리 월별/주간별/일별 조회
  Modification Information

      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2008.03.09    장동한          최초 생성

    author   : 공통서비스 개발팀 장동한
    since    : 2009.03.09

--%>
<%@ page contentType="text/html; charset=utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<c:set var="ImgUrl" value="/images/egovframework/com/cmm/"/>
<c:set var="CssUrl" value="/css/egovframework/com/cmm/"/>

<html lang="ko">
<head>
<title>일정관리</title>

<style type="text/css">
	h1 {font-size:12px;}
	caption {visibility:hidden; font-size:0; height:0; margin:0; padding:0; line-height:0;}
</style>


<meta http-equiv="content-type" content="text/html; charset=utf-8">
<link type="text/css" rel="stylesheet" href="<c:url value='${CssUrl}com.css'/>">
<script type="text/javaScript" language="javascript">

/* ********************************************************
 * 등록 처리 함수
 ******************************************************** */
function fnTabMenuSelect(objArr){


	var FLength = document.getElementsByName("tabMenu").length;


	for(var i=0; i < FLength; i++){
		if( i ==  objArr){
			document.getElementsByName("tabMenu")[i].bgColor = '#BBBBBB';
		}else{
			document.getElementsByName("tabMenu")[i].bgColor = '#DDDDDD';
		}
	}

	//경로 이동
	if(objArr == 0)
		document.getElementById('SchdulView').src="<c:url value='/cop/smt/sim/EgovIndvdlSchdulManageMonthList.do' />";

	if(objArr == 1)
		document.getElementById('SchdulView').src="<c:url value='/cop/smt/sim/EgovIndvdlSchdulManageWeekList.do' />";

	if(objArr == 2)
		document.getElementById('SchdulView').src="<c:url value='/cop/smt/sim/EgovIndvdlSchdulManageDailyList.do' />";


}

/* ********************************************************
* 등록 처리 함수
******************************************************** */
function fnInit(){
	fnTabMenuSelect(0);
}


/* ********************************************************
* IFRAME AUTO HEIGHT
******************************************************** */
function do_resize() {
 resizeFrame("iframe_main",1);
}

function resizeFrame(ifr_id,re){
//가로길이는 유동적인 경우가 드물기 때문에 주석처리!
 var ifr= document.getElementById(ifr_id) ;
 var innerBody = ifr.contentWindow.document.body;
 var innerHeight = innerBody.scrollHeight + (innerBody.offsetHeight - innerBody.clientHeight);
 //var innerWidth = document.body.scrollWidth + (document.body.offsetWidth - document.body.clientWidth);

 if (ifr.style.height != innerHeight) //주석제거시 다음 구문으로 교체 -> if (ifr.style.height != innerHeight || ifr.style.width != innerWidth)
 {
  ifr.style.height = innerHeight;
  //ifr.style.width = innerWidth;
 }

 if(!re) {
  try{
   	innerBody.attachEvent('onclick',parent.do_resize);
   	innerBody.attachEvent('onkeyup',parent.do_resize);
   //글작성 상황에서 클릭없이 타이핑하면서 창이 늘어나는 상황이면 윗줄 주석제거
  } catch(e) {
   innerBody.addEventListener("click", parent.do_resize, false);
   innerBody.addEventListener("keyup", parent.do_resize, false);
   //글작성 상황에서 클릭없이 타이핑하면서 창이 늘어나는 상황이면 윗줄 주석제거
  }
 }
}

</script>
</head>
<body onLoad="fnInit()">

<!-- 전체 레이어 시작 -->
<!-- <div id="wrap"> -->
<!-- header 시작 -->
<%-- <div id="header"><c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" /></div>
<div id="topnavi"><c:import url="/sym/mms/EgovMainMenuHead.do" /></div> --%>
<!-- //header 끝 -->
<!-- container 시작 -->
<!-- <div id="container"> -->
<!-- 좌측메뉴 시작 -->
<%-- <div id="leftmenu"><c:import url="/sym/mms/EgovMainMenuLeft.do" /></div> --%>
<!-- //좌측메뉴 끝 -->
<frameset frameborder="0" framespacing="0" rows="6%, 89%, 5%">
    <frame name="_top" src="<c:url value='/sym/mms/EgovMainMenuHead.do'/>" scrolling="no" title="헤더">
        <frameset frameborder="0" framespacing="0" cols="20%, 80%">
            <frame name="_left" src="<c:url value='/sym/mms/EgovMainMenuLeft.do'/>" scrolling="yes" title="메뉴페이지">
            <frame name="_content" src="<c:url value='/cop/smt/sim/EgovIndvdlSchdulManageRegist.do'/>" title="메인페이지">
        </frameset>
    <frame name="_bottom" src="<c:url value='/EgovPageLink.do?link=main/inc/EgovIncFooter'/>" scrolling="no" title="푸터">
</frameset>
</body>
</html>

