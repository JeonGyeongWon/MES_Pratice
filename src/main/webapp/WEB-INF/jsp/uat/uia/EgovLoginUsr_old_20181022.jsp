<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=Edge">
<meta name="viewport" content="user-scalable=yes, maximum-scale=1.0, width=1024" />
<title>서진테크윈</title>
<link rel="icon" href='<c:url value="/images/favicon.png"></c:url>' sizes="128x128">
<link href='https://fonts.googleapis.com/css?family=Oswald:300' rel='stylesheet' type='text/css'>
<link href='https://fonts.googleapis.com/css?family=Source+Sans+Pro:200' rel='stylesheet' type='text/css'>
<link href="/FNC/resource/css/login.css" rel="stylesheet" type="text/css">
<script src="/FNC/resource/js/jquery-1.8.3.min.js"></script>
<script src="/FNC/resource/js/ui.js"></script>
<script type="text/javascript">
$(document).ready(
	    function () {
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
	        document.login.action = "<c:url value='/uat/uia/actionSecurityLogin.do'/>";
	        document.login.submit();
	    }
	}

	function setCookie(name, value, expires) {
	    document.cookie = name + "=" + escape(value) + "; path=/; expires=" + expires.toGMTString();
	}

	function getCookie(Name) {
	    var search = Name + "="
	        if (document.cookie.length > 0) { // 쿠키가 설정되어 있다면
	            offset = document.cookie.indexOf(search)
	                if (offset != -1) { // 쿠키가 존재하면
	                    offset += search.length
	                    // set index of beginning of value
	                    end = document.cookie.indexOf(";", offset)
	                        // 쿠키 값의 마지막 위치 인덱스 번호 설정
	                        if (end == -1)
	                            end = document.cookie.length
	                                return unescape(document.cookie.substring(offset, end))
	                }
	        }
	        return "";
	}

	function saveid(form) {
	    var expdate = new Date();
	    // 기본적으로 30일동안 기억하게 함. 일수를 조절하려면 * 30에서 숫자를 조절하면 됨
	    if (form.checkId.checked)
	        expdate.setTime(expdate.getTime() + 1000 * 3600 * 24 * 30); // 30일
	    else
	        expdate.setTime(expdate.getTime() - 1); // 쿠키 삭제조건
	    setCookie("saveid", form.id.value, expdate);
	}

	function getid(form) {
	    form.checkId.checked = ((form.id.value = getCookie("saveid")) != "");
	}

	function fnInit() {
	    var message = document.loginForm.message.value;
	    if (message != "") {
	        alert(message);
	    }
	    getid(document.loginForm);
	}
	///////////////////////////////////////////////////////////////////////////////////////////////
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
	        var i,
	        j = d.MM_p.length,
	        a = MM_preloadImages.arguments;
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
<body onLoad="MM_preloadImages('/FNC/resource/img/btn_login_on.png')" oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
	<div id="main_wrap">
		<header id="header">
<!-- 			    <div style=" position:absolute;"><a href="index.html"><img src="/FNC/images/title.png"></a></div> -->
<!-- 			<div style="float: right; font-family: font-family : Verdana, Geneva, sans-serif; font-size: 10px; font-weight: normal; line-height: 15px;"> -->
<!-- 				<span> -->
<!-- 					<a href="#"> -->
<!-- 					   <font style="color: #FFF;">MAIL TO ADMIN</font> -->
<!-- 					</a> -->
<!-- 				</span> -->
<!--                 <span style="padding-left: 37px;"> -->
<!-- 	                <a href="#"> -->
<!-- 	                   <font style="color: #FFF">BOOKMARK HERE</font> -->
<!-- 	                </a> -->
<!--                 </span> -->
<!-- 			</div> -->
		</header>
		<article id="main_poster">
			<ul class="photo">
<!--         <li class="clock"><img src="/FNC/resource/img/main_visual4.jpg" alt="" class="visual" style="width: 100%; height : 100%;" /> -->
        <!-- <li class="clock">
					<h2 >
						<table width="100%" border="0">
							<tr>
								<td style="font-family: 'Oswald', sans-serif; font-size: 28px; font-weight: 300; letter-spacing: 3px; line-height: 42px; color : #000000; text-shadow: 4px 4px 4px gray;">
								    <strong>M</strong>anufacturing&nbsp;<strong>E</strong>xecution&nbsp;<strong>S</strong>ystem<br/>
								</td>
							</tr>
							<tr>
								<td style="font-family: 'Source Sans Pro', sans-serif; font-size: 20px; line-height: 30px; padding-top: 20px; color : #000000; text-shadow: 3px 3px 3px gray;">
								    <span style="font-style: italic;">IN FOLLOWING OUR MOTO</span><br><strong style="font-family: '맑은고딕'; font-size: 22px; font-weight: bold; "> &quot;BETTER FASHION, BETTER LIFE&quot;</strong><br> We are constantly investing<br>in inprovments of our product.
								</td>
							</tr>
						</table>
					</h2>
				</li> -->
			</ul>
		</article>
		<article class="main_login" style="width : 420px; margin-left : 100px;">
			<table border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td style="padding: 10px 25px 0px 10px; width : 100%; background-color : #FFFFFF; opacity: 0.8; border-radius : 0px 10px 0px 0px; text-shadow: 2px 2px 2px gray;">
						<font style="color: #000000; font-family: 'Source Sans Pro', sans-serif; font-size: 18px; font-weight: bold;">
						  Members Log-In
						</font>
					</td>
				</tr>
				<tr>
					<td style="padding: 10px 25px 10px 10px; width : 100%; background-color : #FFFFFF; opacity: 0.8; border-radius : 0px 0px 10px 10px;">
					   <table border="0" cellspacing="0" cellpadding="0" bgcolor="#ffffff">
							<tr>
								<form:form name="login" method="post">
									<td width="138px" style="padding: 2px; border : gray 2px solid;">
									   <input id="id" name="id" type="text" tabindex="1" onmousedown="loginform_clearbg('id');" onkeydown="loginform_clearbg('id');" style="background: url(/FNC/resource/img/bg_id.png) #333333 no-repeat; border: 0px solid #c5b8a6; height: 27px; width: 138px; color: #FFFFFF; padding-left: 10px;">
									</td>
									<td width="138px" style="padding: 2px;  border : gray 2px solid; border-radius: 4px 4px 4px 4px;">
									   <input id="password" name="password" type="password" tabindex="2" onmousedown="loginform_clearbg('pass');" onkeydown="javascript:if (event.keyCode == 13) { actionLogin(); }" style="background: url(/FNC/resource/img/bg_pass.png) #333333 no-repeat; border: 0px solid #c5b8a6; height: 27px; width: 138px; color: #FFFFFF; padding-left: 10px;">
									</td>
									<td width="100px" style="padding: 2px;  border : gray 2px solid; border-radius: 4px 4px 4px 4px;">
									   <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image12','','/FNC/resource/img/btn_login_on.png',1)" onclick="javascript:actionLogin()"><img src="/FNC/resource/img/btn_login.png" alt="" width="80" height="27" id="Image12"></a>
									</td>
									<input type="hidden" name="message" value="${message}" />
									<input name="j_username" type="hidden" />
								</form:form>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</article>
		<footer id="footer" style="text-align: center;">
			<div class="util">
				<div class="credit" style="color: #000000; font-weight: bold;  text-shadow: 10px 3px 3px white;">Copyright ⓒ SBIT MES. All Rights Reserved.</div>
			</div>
		</footer>
	</div>
	</script>
</body>
</html>