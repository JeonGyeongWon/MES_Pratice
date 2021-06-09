<!DOCTYPE html>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html lang="ko">
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<!-- <meta name="viewport" content="user-scalable=yes, maximum-scale=1.0, width=1024" /> -->
<title>돌 석상훈</title>
<link rel="icon" href='<c:url value="/images/favicon.png"></c:url>' sizes="128x128">
<link href='https://fonts.googleapis.com/css?family=Oswald:300' rel='stylesheet' type='text/css'>
<link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:200' rel='stylesheet' type='text/css'>
<link href="/FNC/resource/css/login.css" rel="stylesheet" type="text/css">
<script src="/FNC/resource/js/jquery-1.8.3.min.js"></script>
<script src="/FNC/resource/js/ui.js"></script>

<style>
.shadow {
    -webkit-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
    -moz-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
    box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
}

.h:HOVER {
    background-color: highlight;
}

.blue {
/*     background-color: #5B9BD5; */
    background-color: rgb(0, 116, 233);
    color: white;
}

.r {
    border-radius: 4px 4px 4px 4px;
    -moz-border-radius: 4px 4px 4px 4px;
    -webkit-border-radius: 4px 4px 4px 4px;
    border: 0px solid #000000;
}

.ui-autocomplete {
    max-height: 420px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
}

* html .ui-autocomplete {
    /* IE 6.0 */
    height: 420px;
}

.ERPQTY  .x-column-header-text {
    margin-right: 0px;
}
</style>
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
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
				<form:form name="login" method="post">
								<table style="width: 100%; height: calc(100% - 30px); ">
												<colgroup>
																<col style="width: 5%;">
																<col>
																<col style="width: 5%;">
												</colgroup>
                        <tr style="height: 10px;">
                                <td></td>
                                <td></td>
                                <td></td>
                        </tr>
                        <tr style="height: 80px;">
                                <td></td>
                                <td><center><img src="<c:url value='/images/footer/Footer_left.png'/>" alt="" style="width: 300px; min-width: 250px; height: 80px;" /></center></td>
                                <td></td>
                        </tr>
                        <tr style="height: 10px;">
                                <td></td>
                                <td></td>
                                <td></td>
                        </tr>
                        <tr style="height: 60px;">
																<td></td>
																<td><input id="id" name="id" type="text" class="input_left" style="width: 100%; font-size: 30px; height: 60px;" placeholder="아이디" value="${searchVO.param1}"></td>
																<td></td>
												</tr>
												<tr style="height: 10px;">
																<td></td>
																<td></td>
																<td></td>
												</tr>
												<tr style="height: 60px;">
																<td></td>
																<td><input id="password" name="password" type="password" onkeydown="javascript:if (event.keyCode == 13) { actionLogin(); }" class="input_left" style="width: 100%; font-size: 30px; height: 60px;" placeholder="비밀번호" value="${searchVO.param2}"></td>
																<td></td>
												</tr>
                        <tr style="height: 70px;">
                                <td></td>
                                <td></td>
                                <td></td>
                        </tr>
												<tr style="height: 60px;">
																<td></td>
																<td>
																				<button type="button" class="blue h r shadow" onclick="javascript:actionLogin();" style="width: 100%; height: 60px; font-size: 23px; font-weight: bold; color: #fff; margin: 0px;">로그인</button>
																</td>
																<td></td>
												</tr>
								        <tr>
								            <td></td>
								            <td style="height: calc((100% - 410px) * 0.5); "></td>
								            <td></td>
								        </tr>
								</table>
								<input type="hidden" name="message" value="${message}" />
								<input name="j_username" type="hidden" />
				</form:form>
		    <div style="width: 100%; height: 30px; position: fixed; top: calc(100% - 30px); left: 0px;">
						<h3 class="shadow" style="height: 100%; font-size: 13px; font-weight: bold; margin-top: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; ">Copyright ⓒ SBIT MES. All Rights Reserved.</h3>
				</div>
</body>
</html>