<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@page import="org.apache.ibatis.annotations.Param"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="user-scalable=yes, maximum-scale=1.0, width=1024" />
<title>돌 석상훈</title>
<link rel="icon" href='<c:url value="/images/favicon.png"></c:url>' sizes="128x128">
<link href='https://fonts.googleapis.com/css?family=Oswald:300' rel='stylesheet' type='text/css'>
<link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:200' rel='stylesheet' type='text/css'>
<link href="<c:url value='/resource/css/login.css' />" rel="stylesheet" type="text/css">
<script src="<c:url value='/resource/js/jquery-1.8.3.min.js' />"></script>
<script src="<c:url value='/resource/js/ui.js' />"></script>
<%
  LoginVO loginVO = (LoginVO) session.getAttribute("LoginVO");
  String temp = "";

  try {
    String id = loginVO.getId();
    if (id != "") {
      temp = id;
    }
  } catch (Exception e) {
    e.printStackTrace();
  }
%>
<script type="text/javascript">
$(document).ready(function () {

    var id = $('#id').val();
    var pass = $('#password').val();
//     if (id != "" && pass != "") {
//         actionLogin();
//     } else {
//         var local_id = localStorage["id"];
//         var local_pass = localStorage["password"];
//         if ( (local_id != "" && local_id != undefined) && (local_pass != "" && local_pass != undefined) ) {

//             $('#id').val(local_id);
//             $('#password').val(local_pass);

//             actionLogin();
//         }
//     }

    $("#password").focus(function () {
        loginform_clearbg('pass');
    });
});

function actionLogin() {
    if (document.login.id.value == "") {
        alert("아이디를 입력하세요");
        document.login.id.focus();
        return false;
    } else if (document.login.password.value == "") {
        alert("비밀번호를 입력하세요");
        document.login.password.focus();
        return false;
    } else {
        var id = document.login.id.value;
        var pass = document.login.password.value;
        sessionStorage["id"] = id;
        sessionStorage["password"] = pass;

        localStorage["id"] = id;
        localStorage["password"] = pass;

        document.login.action = "<c:url value='/uat/uia/actionSecurityLogin.do'/>";
        document.login.submit();
    }
}


function loginform_clearbg(type) {
    if (type == "id") {
        document.login.id.style.backgroundImage = '';
    } else if (type == "pass") {
        document.login.password.style.backgroundImage = '';
    }

    if (type == "id2") {
        document.login2.id2.style.backgroundImage = '';
    } else if (type == "pass2") {
        document.login2.password2.style.backgroundImage = '';
    }
}

function MM_swapImgRestore() { //v3.0
    var i, x, a = document.MM_sr;
    for (i = 0; a && i < a.length && (x = a[i]) && x.oSrc; i++)
        x.src = x.oSrc;
}

function MM_preloadImages() { //v3.0
    var d = document;
    if (d.images) {
        if (!d.MM_p)
            d.MM_p = new Array();
        var i, j = d.MM_p.length, a = MM_preloadImages.arguments;
        for (i = 0; i < a.length; i++)
            if (a[i].indexOf("#") != 0) {
                d.MM_p[j] = new Image;
                d.MM_p[j++].src = a[i];
            }
    }
}

function MM_findObj(n, d) { //v4.01
    var p, i, x;
    if (!d)
        d = document;
    if ((p = n.indexOf("?")) > 0 && parent.frames.length) {
        d = parent.frames[n.substring(p + 1)].document;
        n = n.substring(0, p);
    }
    if (!(x = d[n]) && d.all)
        x = d.all[n];
    for (i = 0; !x && i < d.forms.length; i++)
        x = d.forms[i][n];
    for (i = 0; !x && d.layers && i < d.layers.length; i++)
        x = MM_findObj(n, d.layers[i].document);
    if (!x && d.getElementById)
        x = d.getElementById(n);
    return x;
}

function MM_swapImage() { //v3.0
    var i, j = 0, x, a = MM_swapImage.arguments;
    document.MM_sr = new Array;
    for (i = 0; i < (a.length - 2); i += 3)
        if ((x = MM_findObj(a[i])) != null) {
            document.MM_sr[j++] = x;
            if (!x.oSrc)
                x.oSrc = x.src;
            x.src = a[i + 2];
        }
}
</script>
</head>
<body onLoad="MM_preloadImages('/FNC/resource/img/btn_login_on.png')" oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="background-color: white;">
  <div id="main_wrap" >
    <header id="header" style="margin-top: 300px; float: left; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
        <div style=" position:absolute; width: 760px; height: auto;"><img src="<c:url value='/images/favicon.png'/>" style="width: 700px; height: 300px;"></div>
    </header>
<!--    <article id="main_poster1"> -->
<!--      <ul class="photo"> -->
<%--         <li class="clock"><img src="<c:url value='/resource/img/main_visual4.png'/>" alt="" class="visual" style="width: 100%; height : 100%;" /> --%>
<!--      </ul> -->
<!--    </article> -->

    <article class="main_login" style="width : 400px; height: auto; margin-left: -200px; margin-top: 225px; float: left; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
      <table border="0" cellspacing="0" cellpadding="0">
        <tr>
          <td style="padding: 10px 25px 0px 10px; width : 100%; border-radius : 0px 0px 0px 0px; color: #7F7F7F; font-family: Helvetica; font-size: 22px; font-weight: bold; ">
          <center>
            <span style="color: #FF6600; ">M</span>embers
            <span style="color: #FF6600; ">L</span>og-In
          </center>
          </td>
        </tr>
        <tr>
          <!-- top right bottom left  -->
<!--          <td style="padding: 10px 10px 10px 10px; width : 100%; background-color : #FF6600; opacity: 0.8; border-radius : 0px 0px 0px 0px;"> -->
          <td style="padding: 0px 10px 10px 10px; width : 100%; opacity: 0.8; border-radius : 0px 0px 0px 0px;">
          <form:form name="login" method="post">
             <table border="0" cellspacing="0" cellpadding="0" bgcolor="#f5f5f5">
                <colgroup>
                   <col width="238px">
                   <col width="180px">
                </colgroup>
                <tr>
                    <td style="padding: 2px; border : gray 2px solid;">
                       <input id="id" name="id" type="text" tabindex="1" onmousedown="loginform_clearbg('id');" onkeydown="loginform_clearbg('id');" style="background: url(/FNC/resource/img/bg_id_v0.1.png) #333333 no-repeat; border: 0px solid #c5b8a6; height: 47px; width: 238px; color: white; font-size: 20px; font-weight: bold; padding-left: 10px;" title="아이디를 입력해주세요." placeholder="">
                    </td>
                    <td rowspan="3" style="padding: 0px;  border : gray 2px solid;">
                       <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image12','','/FNC/resource/img/btn_login_on_v0.2.png',1)" onclick="javascript:actionLogin()"><img id="Image12" src="/FNC/resource/img/btn_login_v0.2.png" alt="" style="width: 100%; height: 100%;"></a>
                    </td>
                </tr>
                <tr>
                    <td style="padding: 2px;  border : gray 2px solid; border-radius: 4px 4px 4px 4px;">
                       <input id="password" name="password" type="password" tabindex="2" onmousedown="loginform_clearbg('pass');" onkeydown="javascript:if (event.keyCode == 13) { actionLogin(); }" style="background: url(/FNC/resource/img/bg_pass_v0.1.png) #333333 no-repeat; border: 0px solid #c5b8a6; height: 47px; width: 238px; color: white; font-size: 20px; font-weight: bold; padding-left: 10px;" title="비밀번호를 입력해주세요." placeholder="">
                    </td>
                </tr>
                <tr style="height: 35px; ">
                    <td style="padding: 2px;  border : gray 2px solid; ">
                        <span title="아이디 저장">
                           <input id="idchk" name="idchk" type="checkbox" tabindex="3" style="height: 22px; width: 35px; color: white; font-size: 20px; padding-left: 5px;" />
                           <label for=idChk" style="font-family: Helvetica; font-size: 14px; font-weight: bold;">아이디 저장</label>
                       </span>
                    </td>
                </tr>
            </table>
            <input type="hidden" name="message" value="${message}" />
            <input name="j_username" type="hidden" />
          </form:form>
          </td>
        </tr>
      </table>
    </article>
    <footer id="footer" style="text-align: center;">
      <div class="util">
        <div class="credit" style="color: #000000; font-weight: bold;  text-shadow: 10px 3px 3px white; left : 260px; top : 10px; ">Copyright ⓒ SBIT MES. All Rights Reserved.</div>
      </div>
    </footer>
  </div>
  </script>
</body>
</html>