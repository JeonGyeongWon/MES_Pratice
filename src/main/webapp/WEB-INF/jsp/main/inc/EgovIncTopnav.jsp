<%--
  Class Name : EgovIncTopnav.jsp
  Description : 상단메뉴화면(include)
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2011.08.31   JJY       경량환경 버전 생성
 
    author   : 실행환경개발팀 JJY
    since    : 2011.08.31 
--%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import ="egovframework.com.cmm.LoginVO" %> 
<!-- topmenu start -->
<script type="text/javascript">
<!--
    function getLastLink(baseMenuNo){
    	var tNode = new Array;
        for (var i = 0; i < document.menuListForm.tmp_menuNm.length; i++) {
            tNode[i] = document.menuListForm.tmp_menuNm[i].value;
            var nValue = tNode[i].split("|");
            //선택된 메뉴(baseMenuNo)의 하위 메뉴중 첫번재 메뉴의 링크정보를 리턴한다.
            if (nValue[1]==baseMenuNo) {
                if(nValue[5]!="dir" && nValue[5]!="" && nValue[5]!="/"){
                    //링크정보가 있으면 링크정보를 리턴한다.
                    return nValue[5];
                }else{
                    //링크정보가 없으면 하위 메뉴중 첫번째 메뉴의 링크정보를 리턴한다.
                    return getLastLink(nValue[0]);
                }
            }
        }
    }
    function goMenuPage(baseMenuNo){
    	document.getElementById("baseMenuNo").value=baseMenuNo;
    	document.getElementById("link").value="forward:"+getLastLink(baseMenuNo);
        //document.menuListForm.chkURL.value=url;
        document.menuListForm.action = "<c:url value='/EgovPageLink.do'/>";
        document.menuListForm.submit();
    }
    function Logout() {
        localStorage.clear();
        go_url('<c:url value="/uat/uia/actionLogout.do" />');
    }
//-->
</script>

<ul>
    <li></li>
	<c:forEach var="result" items="${list_headmenu}" varStatus="status">
    <li><a href="#LINK" onclick="javascript:goMenuPage('<c:out value="${result.menuNo}"/>')"><c:out value="${result.menuNm}"/></a></li>  
    </c:forEach>
	    <%
           LoginVO loginVO = (LoginVO)session.getAttribute("LoginVO"); 
           if (loginVO == null) { 
        %>		
		   <li>|</li>        
           <li><a href="<c:url value='/uat/uia/egovLoginUsr.do'/>">로그인</a></li>
        
        <% } else { %>
			<li>
			<!--유니크아이디 <%=loginVO.getUniqId()%>--><c:out value="<%= loginVO.getName()%>"/> 님
			</li>         
        <% } %> 
	<div style="float: right">
    <a href="javascript:popPassword()">비밀번호</a>&nbsp;&nbsp;&nbsp;
    <a href="javascript:Logout()">로그오프</a>
    &nbsp;&nbsp;&nbsp;
  </div>

	</ul>
<!-- //topmenu end -->
<!-- menu list -->
    <form name="menuListForm" action ="/sym/mnu/mpm/EgovMenuListSelect.do" method="post">
        <input type="hidden" id="baseMenuNo" name="baseMenuNo" value="<%=session.getAttribute("baseMenuNo")%>" />
        <input type="hidden" id="link" name="link" value="" />
        <c:forEach var="result" items="${list_menulist}" varStatus="status" > 
            <input type="hidden" name="tmp_menuNm" value="${result.menuNo}|${result.upperMenuId}|${result.menuNm}|${result.relateImagePath}|${result.relateImageNm}|${result.chkURL}|" />
        </c:forEach>
    </form>
