<%--
  Class Name : EgovIncLeftmenu.jsp
  Description : 좌메뉴화면(include)
  Modification Information
 
      수정일         수정자                   수정내용
    -------    --------    ---------------------------
     2011.08.31   JJY       경량환경 버전 생성
 
    author   : 실행환경개발팀 JJY
    since    : 2011.08.31 
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script type="text/javascript" src="<c:url value="/js/EgovMainMenu.js"/>" /></script>
<script type="text/javascript">
<!--
	/* ********************************************************
	 * 상세내역조회 함수
	 ******************************************************** */
	 function fn_MovePage(nodeNum) {
		  var nodeValues = treeNodes[nodeNum].split("|");
		  // parent.main_right.location.href = nodeValues[5];
		  // document.menuListForm.action = "${pageContext.request.contextPath}" + nodeValues[5];
		  document.menuListForm.action = "${pageContext.request.contextPath}" + "/EgovLeftPageLink.do?cid=" + nodeValues[0] + "&pid=" + nodeValues[1] + "&link=" + nodeValues[5];
		  // alert(document.menuListForm.action);
		  document.menuListForm.submit();
		}
//-->
</script>
<!-- 메뉴 시작 -->
<div id="nav">
	<div class="top"></div>
	<div class="nav_style">
		<script type="text/javascript">
		<!--
		var Tree = new Array;
		if (document.menuListForm.tmp_menuNm != null) {
		  for (var j = 0; j < document.menuListForm.tmp_menuNm.length; j++) {
		    Tree[j] = document.menuListForm.tmp_menuNm[j].value;
		    //if (j == 5) j = document.menuListForm.tmp_menuNm.length;
		  }
		}
//		        var leftStartMenuValue = document.getElementById("menuNo").value;
		var leftStartMenuValue = document.getElementById("baseMenuNo").value;
		if (leftStartMenuValue == null || leftStartMenuValue == "" || leftStartMenuValue == "null")
		  leftStartMenuValue = '1000000';
		createTree(Tree, true, leftStartMenuValue);

		//-->
		</script>
	</div>
	<div class="bottom"></div>
</div>
<!-- //메뉴 끝 -->