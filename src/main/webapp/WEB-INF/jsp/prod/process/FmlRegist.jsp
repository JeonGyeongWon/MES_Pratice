<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@page import="org.apache.ibatis.annotations.Param"%>
<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ page import="egovframework.com.cmm.LoginVO"%>
<%
  LoginVO loginVO = (LoginVO)session.getAttribute("LoginVO");
  String authCode = loginVO.getAuthCode();
  
  /* Image Path 설정 */
  String imagePath_icon   = "/images/egovframework/sym/mpm/icon/";
  String imagePath_button = "/images/egovframework/sym/mpm/button/";
%>
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
<html>
<head>
<title>${EQUIPMENTNAME} - ${pageSubTitle1}</title>

<link rel="stylesheet" href="<c:url value='/css/custom_work.css'/>">
<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload.css'/>">
<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload-ui.css'/>">

<!-- jQuery-File-Upload-9.9.3 -->
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/load-image.all.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-process.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-image.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/app.js'/>"></script>

<style>
.x-column-header-inner {
	font-size: 18px;
	font-weight: bold;
	background-color: #5B9BD5;
	color: white;
	padding-left: 0px;
	padding-right: 0px;
}

.x-column-header-text {
	padding-top: 5px;
	padding-bottom: 5px;
}

.specialcheckname  .x-column-header-inner {
	color: red;
}

.ERPQTY  .x-column-header-text {
	margin-right: 0px;
}

.FML .x-grid-cell-inner {
	padding-left: 0px;
	padding-right: 0px;
}

#gridArea .x-grid-cell {
	position: relative;
	text-overflow: ellipsis;
	padding-top: 0px;
	padding-left: 0px;
	padding-bottom: 0px;
}

#gridArea .x-grid-cell-inner {
	position: relative;
	text-overflow: ellipsis;
	padding-top: 15px;
	/* padding-left : 10px; */
	padding-left: 8px !important;
	padding-bottom: 0px !important;
	height: 60px;
	font-size: 18px !important;
	font-weight: bold;
}

#gridArea .x-form-field {
	font-size: 18px;
	font-weight: bold;
}

#gridPopup1Area .x-grid-cell-inner {
	position: relative;
	text-overflow: ellipsis;
	padding-top: 15px;
	padding-left: 10px;
	height: 60px;
	font-size: 22px !important;
	font-weight: bold;
}

#gridPopup2Area .x-grid-cell-inner {
	position: relative;
	text-overflow: ellipsis;
	padding-top: 15px;
	padding-left: 10px;
	height: 60px;
	font-size: 22px !important;
	font-weight: bold;
}

#gridPopup1Area .x-form-field {
	font-size: 20px;
	font-weight: bold;
}

#gridPopup2Area .x-form-field {
	font-size: 28px;
	font-weight: bold;
}
</style>
  
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
  background-color: #003399;
  color: white;
}

.blue2:HOVER {
  background-color: highlight;
}

.blue2 {
  background-color: #5B9BD5;
  color: white;
}

.blue3:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #003399;
}

.blue3 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #003399 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.gray:HOVER {
  background-color: #EAEAEA;
}

.gray {
  background-color: #BDBDBD;
  color: black;
}

.white:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white2:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white2 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 16px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #5B9BD5 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  border-bottom: 4px solid #5B9BD5;
  margin-top: 0px;
  margin-bottom: 0px;
}

.yellow:hover {
  background-color: #FFFFFF;
  color: yellow !important;
  text-shadow: 2px 2px 5px rgb(34, 34, 34);
  border-bottom: 4px solid yellow;
}

.yellow {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.yellow_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid yellow;
}

.yellow_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: yellow !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  text-shadow: 2px 2px 5px rgb(34, 34, 34);
  cursor: pointer;
  border-bottom: 4px solid yellow;
  cursor: pointer;
}

.red:HOVER {
	background-color: #FFD8D8;
}

.red {
	background-color: #FFA7A7;
	color: black;
}

.gray:HOVER {
	background-color: #d8d8d8;
}

.gray {
	background-color: #e1e1e1;
	color: black;
}

.green:HOVER {
	background-color: #CEFBC9;
}

.green {
	background-color: #B7F0B1;
	color: black;
}

.r {
	border-radius: 4px 4px 4px 4px;
	-moz-border-radius: 4px 4px 4px 4px;
	-webkit-border-radius: 4px 4px 4px 4px;
	border: 0px solid #000000;
}

.ui-autocomplete {
	font-size: 33px;
	font-weight: bold;
	max-height: 400px;
	overflow-y: auto;
	/* prevent horizontal scrollbar */
	overflow-x: hidden;
}

* html .ui-autocomplete {
	/* IE 6.0 */
	height: 400px;
	font-size: 33px;
	font-weight: bold;
}

.ui-menu  .ui-menu-item {
  height: 85px;
  line-height: 40px;
  margin-top: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
  display: flex;
  flex-direction: column;
  align-items: left;
  justify-content: center;
}

.ResultTable th {
  font-size: 22px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  border-bottom: 1px solid white;
}

.ResultTable td {
  font-size: 22px;
  color: black;
  text-align: center;
}
</style>
<script type="text/javaScript">
var imgCnt = 0;
var selectedItemCode = "", selectedroutingid = "", selectedCheckBig = "F";
var filetype = "check", gubun = "Image1";
var groupid = "${searchVO.groupId}";
var gridnms = {};
var fields = {};
var items = {};
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  $("#gridPopup1Area").hide("blind", {
    direction: "up"
  }, "fast");

  $("#gridPopup2Area").hide("blind", {
    direction: "up"
  }, "fast");

  setTimeout(function () {
    fn_tab("1");
  }, 300);

  setReadOnly();

  setLovList();
});

function setInitial() {
  gridnms["app"] = "prod";

  $('#CheckResultNg').bind("mousedown", function (e) {
    fn_valid_calc();
  });
  $('#CheckResultNg').bind("keydown", function (e) {
    if (e.keyCode != 13) {
      fn_valid_calc();
    }
  });

  $('#LotNoVisual').bind("mousedown", function (e) {
    fn_lotno_input();
  });
  $('#LotNoVisual').bind("keydown", function (e) {
    if (e.keyCode != 13) {
      fn_lotno_input();
    }
  });
}

function setValues() {
  setValues_popup1();
  setValues_popup2();
  setValues_fml();
}

var comboboxEmpty1 = '<div style="height: auto; overflow: auto; display:block;">'
   + '<ul>'
   + '<li style="height: 30px; font-size: 16px; font-weight: bold; padding-top: 10px; padding-left: 5px;">'
   + '데이터가 없습니다.'
   + '</li><li style="height: 30px; font-size: 16px; font-weight: bold; padding-top: 5px; padding-left: 5px;">'
   + '관리자에게 문의하십시오.'
   + '</li>' + '</ul>' + '</div>';
var comboboxOption1 = '<div>'
   + '<table>'
   + '<tr>'
   + '<td style="height: 40px; font-size: 25px; font-weight: bold;">{LABEL}</td>'
   + '</tr>' + '</table>' + '</div>';
var comboboxEmpty2 = '<div style="height: auto; overflow: auto; display:block;">'
   + '<ul>'
   + '<li style="height: 40px; font-size: 18px; font-weight: bold; padding-top: 13px; padding-left: 5px;">'
   + '값을 입력해주세요.' + '</li>' + '</ul>' + '</div>';
var comboboxOption2 = '<div style="height: auto; overflow: auto; display:block;">'
  //            + '<table>'
  //            + '<tr>'
  //            + '<td style="height: 45px; font-size: 28px; font-weight: bold;">{LABEL}</td>'
  //            + '</tr>'
  //            + '</table>'
   + '<ul>'
   + '<li style="height: 40px; font-size: 25px; font-weight: bold; padding-top: 13px;">'
   + '{LABEL}' + '</li>' + '</ul>' + '</div>';
function setValues_fml() {

  gridnms["models.list"] = [];
  gridnms["stores.list"] = [];
  gridnms["views.list"] = [];
  gridnms["controllers.list"] = [];

  gridnms["grid.1"] = "FmlRegist";
  gridnms["grid.2"] = "okngLov";
  gridnms["grid.3"] = "checkynLov";
  gridnms["grid.4"] = "workerLov";
  gridnms["grid.5"] = "okngmanageLov";
  gridnms["grid.6"] = "managerLov";

  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
  gridnms["views.list"].push(gridnms["panel.1"]);

  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
  gridnms["controllers.list"].push(gridnms["controller.1"]);

  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];
  gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];
  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];

  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];
  gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];
  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];

  gridnms["models.list"].push(gridnms["model.1"]);
  gridnms["models.list"].push(gridnms["model.2"]);
  gridnms["models.list"].push(gridnms["model.3"]);
  gridnms["models.list"].push(gridnms["model.4"]);
  gridnms["models.list"].push(gridnms["model.5"]);
  gridnms["models.list"].push(gridnms["model.6"]);

  gridnms["stores.list"].push(gridnms["store.1"]);
  gridnms["stores.list"].push(gridnms["store.2"]);
  gridnms["stores.list"].push(gridnms["store.3"]);
  gridnms["stores.list"].push(gridnms["store.4"]);
  gridnms["stores.list"].push(gridnms["store.5"]);
  gridnms["stores.list"].push(gridnms["store.6"]);

  fields["model.1"] = [{
      type: 'number',
      name: 'RN',
    }, {
      type: 'string',
      name: 'ORGID',
    }, {
      type: 'string',
      name: 'COMPANYID',
    }, {
      type: 'string',
      name: 'WORKORDERID',
    }, {
      type: 'number',
      name: 'WORKORDERSEQ',
    }, {
      type: 'string',
      name: 'FMLID',
    }, {
      type: 'number',
      name: 'ORDERNO',
    }, {
      type: 'number',
      name: 'CHECKLISTID',
    }, {
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'FMLTYPE',
    }, {
      type: 'string',
      name: 'FMLTYPENAME',
    }, {
      type: 'string',
      name: 'CHECKCYCLE',
    }, {
      type: 'string',
      name: 'CHECKCYCLENAME',
    }, {
      type: 'string',
      name: 'CHECKMIDDLE',
    }, {
      type: 'string',
      name: 'CHECKSMALL',
    }, {
      type: 'string',
      name: 'CHECKSMALLNAME',
    }, {
      type: 'string',
      name: 'SPECIALCHECK',
    }, {
      type: 'string',
      name: 'SPECIALCHECKNAME',
    }, {
      type: 'string',
      name: 'STANDARDVALUE',
    }, {
      type: 'number',
      name: 'MAXVALUE',
    }, {
      type: 'number',
      name: 'MINVALUE',
    }, {
      type: 'number',
      name: 'CHECKINTERVAL',
    }, {
      type: 'number',
      name: 'INTERVALCNT',
    }, {
      type: 'number',
      name: 'CHECKQTY',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPE',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPENAME',
    }, {
      type: 'string',
      name: 'CHECKRESULT1',
    }, {
      type: 'string',
      name: 'CHECKRESULT2',
    }, {
      type: 'string',
      name: 'CHECKRESULT3',
    }, {
      type: 'string',
      name: 'CHECKRESULT4',
    }, {
      type: 'string',
      name: 'CHECKRESULT5',
    }, {
      type: 'string',
      name: 'CHECKRESULT6',
    }, {
      type: 'string',
      name: 'CHECKRESULT7',
    }, {
      type: 'string',
      name: 'CHECKRESULT8',
    }, {
      type: 'string',
      name: 'CHECKRESULT9',
    }, {
      type: 'string',
      name: 'CHECKRESULT10',
    }, {
      type: 'string',
      name: 'CHECKRESULT11',
    }, {
      type: 'string',
      name: 'CHECKRESULT12',
    }, {
      type: 'string',
      name: 'CHECKRESULT13',
    }, {
      type: 'string',
      name: 'CHECKRESULT14',
    }, {
      type: 'string',
      name: 'CHECKRESULT15',
    }, {
      type: 'string',
      name: 'CHECKRESULT16',
    }, {
      type: 'string',
      name: 'CHECKRESULT17',
    }, {
      type: 'string',
      name: 'CHECKRESULT18',
    }, {
      type: 'string',
      name: 'CHECKRESULT19',
    }, {
      type: 'string',
      name: 'CHECKRESULT20',
    }, {
      type: 'string',
      name: 'CHECKRESULT21',
    }, {
      type: 'string',
      name: 'CHECKRESULT22',
    }, {
      type: 'string',
      name: 'CHECKRESULT23',
    }, {
      type: 'string',
      name: 'CHECKRESULT24',
    }, {
      type: 'string',
      name: 'CHECKRESULT25',
    }, {
      type: 'string',
      name: 'CHECKRESULT26',
    }, {
      type: 'string',
      name: 'CHECKRESULT27',
    }, {
      type: 'string',
      name: 'CHECKRESULT28',
    }, {
      type: 'string',
      name: 'CHECKRESULT29',
    }, {
      type: 'string',
      name: 'CHECKRESULT30',
    }, {
      type: 'string',
      name: 'CHECKRESULT31',
    }, {
      type: 'string',
      name: 'CHECKRESULT32',
    }, {
      type: 'string',
      name: 'CHECKRESULT33',
    }, {
      type: 'string',
      name: 'CHECKRESULT34',
    }, {
      type: 'string',
      name: 'CHECKRESULT35',
    }, {
      type: 'string',
      name: 'CHECKRESULT36',
    }, {
      type: 'string',
      name: 'CHECKRESULT37',
    }, {
      type: 'string',
      name: 'CHECKRESULT38',
    }, {
      type: 'string',
      name: 'CHECKRESULT39',
    }, {
      type: 'string',
      name: 'CHECKRESULT40',
    }, {
      type: 'string',
      name: 'CHECKRESULT41',
    }, {
      type: 'string',
      name: 'CHECKRESULT42',
    }, {
      type: 'string',
      name: 'CHECKRESULT43',
    }, {
      type: 'string',
      name: 'CHECKRESULT44',
    }, {
      type: 'string',
      name: 'CHECKRESULT45',
    }, {
      type: 'string',
      name: 'CHECKRESULT46',
    }, {
      type: 'string',
      name: 'CHECKRESULT47',
    }, {
      type: 'string',
      name: 'CHECKRESULT48',
    }, {
      type: 'string',
      name: 'CHECKRESULT49',
    }, {
      type: 'string',
      name: 'CHECKRESULT50',
    }, {
      type: 'date',
      name: 'CHECKTIME1',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME2',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME3',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME4',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME5',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME6',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME7',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME8',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME9',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME10',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME11',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME12',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME13',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME14',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME15',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME16',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME17',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME18',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME19',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME20',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME21',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME22',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME23',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME24',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME25',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME26',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME27',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME28',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME29',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME30',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME31',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME32',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME33',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME34',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME35',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME36',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME37',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME38',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME39',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME40',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME41',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME42',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME43',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME44',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME45',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME46',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME47',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME48',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME49',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'date',
      name: 'CHECKTIME50',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG1',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG2',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG3',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG4',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG5',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG6',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG7',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG8',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG9',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG10',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG11',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG12',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG13',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG14',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG15',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG16',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG17',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG18',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG19',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG20',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG21',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG22',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG23',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG24',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG25',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG26',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG27',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG28',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG29',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG30',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG31',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG32',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG33',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG34',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG35',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG36',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG37',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG38',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG39',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG40',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG41',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG42',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG43',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG44',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG45',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG46',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG47',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG48',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG49',
    }, {
      type: 'string',
      name: 'CHECKRESULTNG50',
    }, {
      type: 'string',
      name: 'CHECKYN',
    }, {
      type: 'string',
      name: 'CHECKYNNAME',
    }, {
      type: 'string',
      name: 'PERSONID',
    }, {
      type: 'string',
      name: 'KRNAME',
    }, {
      type: 'string',
      name: 'CHECKRESULTM',
    }, {
      type: 'string',
      name: 'MANAGEEMPLOYEE',
    }, {
      type: 'string',
      name: 'MANAGEKRNAME',
    }, {
      type: 'string',
      name: 'STARTTIME',
    }, {
      type: 'string',
      name: 'BPYN',
    }, {
      type: 'string',
      name: 'LOTNOVISUALOLD',
    }, {
      type: 'string',
      name: 'LOTNOVISUAL',
    }, ];

  fields["model.2"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.3"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.4"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.5"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["model.6"] = [{
      type: 'string',
      name: 'VALUE',
    }, {
      type: 'string',
      name: 'LABEL',
    }, ];

  fields["columns.1"] = [{
      dataIndex: 'RN',
      text: '순<br/><br/>번',
      xtype: 'gridcolumn',
      width: 45,
      hidden: false,
      sortable: false,
      resizable: false,
      locked: true,
      lockable: true,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234)";
        return value;
      },
      //     }, {
      //       dataIndex: 'FMLTYPENAME',
      //       text: '초중종<br/><br/>구분',
      //       xtype: 'gridcolumn',
      //       width: 105,
      //       hidden: false,
      //       sortable: false,
      //       resizable: false,
      //       locked: true,
      //       menuDisabled: true,
      //       align: "center",
      //       renderer: function (value, meta, record) {
      //         var fmltype = record.data.FMLTYPE;

      //         if (fmltype == "F") {
      //           meta.style = "color:rgb(71, 200, 62);";
      //         } else if (fmltype == "M") {
      //           meta.style = "color:rgb(204, 166, 61);";
      //         } else if (fmltype == "L") {
      //           meta.style = "color:rgb(217, 65, 140);";
      //         }

      //         meta.style += "background-color:rgb(234, 234, 234)";
      //         return value;
      //       },
    }, {
      dataIndex: 'CHECKSMALLNAME',
      text: '검사<br/><br/>항목',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      locked: true,
      lockable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style += "background-color:rgb(234, 234, 234)";
        return value;
      },
    }, {
      dataIndex: 'SPECIALCHECKNAME',
      text: '특별<br/><br/>특성',
      xtype: 'gridcolumn',
      width: 60,
      hidden: false,
      sortable: false,
      resizable: false,
      //       locked: true,
      //       lockable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      cls: 'specialcheckname',
      renderer: function (value, meta, record) {
        var check = record.data.SPECIALCHECKNAME;

        if (check == "S") {
          meta.style = "color:rgb(255, 0, 0);";
        }

        meta.style += "background-color:rgb(234, 234, 234)";
        return value;
      },
    }, {
      dataIndex: 'CHECKSTANDARD',
      text: '검사내용',
      xtype: 'gridcolumn',
      width: 310,
      hidden: false,
      sortable: false,
      resizable: false,
      locked: true,
      lockable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
      renderer: function (value, meta, record) {
        meta.style += "background-color:rgb(234, 234, 234)";
        return value;
      },
      //     }, {
      //       dataIndex: 'CHECKQTY',
      //       text: '시료<br/><br/>수',
      //       xtype: 'gridcolumn',
      //       width: 70,
      //       hidden: false,
      //       sortable: false,
      //       resizable: false,
      //       locked: true,
      //       menuDisabled: true,
      //       style: 'text-align:center',
      //       align: "center",
      //       renderer: function (value, meta, record) {
      //         meta.style += "background-color:rgb(234, 234, 234)";
      //         return value;
      //       },
    }, {
      dataIndex: 'CHECKMETHODTYPENAME',
      text: '검사방법',
      xtype: 'gridcolumn',
      width: 130,
      hidden: false,
      sortable: false,
      resizable: false,
      locked: true,
      lockable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style += "background-color:rgb(234, 234, 234)";
        return value;
      },
    }, {
      dataIndex: 'CHECKCYCLENAME',
      text: '검사주기',
      xtype: 'gridcolumn',
      width: 110,
      hidden: false,
      sortable: false,
      resizable: false,
      locked: true,
      lockable: true,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style += "background-color:rgb(234, 234, 234)";
        return value;
      },
    }, {
      dataIndex: 'CHECKYNNAME',
      text: '판정',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: false,
      //       locked: true,
      //       lockable: true,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.3"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        typeAhead: true,
        transform: 'stateSelect',
        forceSelection: true,
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        hideTrigger: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            model.set("CHECKYN", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty1,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption1;
          }
        },
      },
      //     }, {
      //       dataIndex: 'KRNAME',
      //       text: '검사자',
      //       xtype: 'gridcolumn',
      //       width: 100,
      //       hidden: false,
      //       sortable: false,
      //       resizable: false,
      //       locked: true,
      //       lockable: true,
      //       menuDisabled: true,
      //       align: "center",
      //       editor: {
      //         xtype: 'combobox',
      //         store: gridnms["store.4"],
      //         valueField: "LABEL",
      //         displayField: "LABEL",
      //         matchFieldWidth: false,
      //         editable: false,
      //         queryParam: 'keyword',
      //         queryMode: 'remote',
      //         allowBlank: true,
      //         typeAhead: true,
      //         transform: 'stateSelect',
      //         forceSelection: true,
      //         height: 60,
      //         triggerCls: 'trigger-combobox-custom',
      //         listeners: {
      //           select: function (value, record, eOpts) {
      //             var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

      //             model.set("PERSONID", record.data.VALUE);

      //             var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

      //             if (selectedRow === 0) {
      //               name = value.getValue();
      //               code = model.data.PERSONID;
      //             }

      //             var count1 = Ext.getStore(gridnms["store.1"]).count();
      //             if (count1 > 1) {
      //               for (var i = 1; i < count1; i++) {
      //                 Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
      //                 var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

      //                 model1.set("PERSONID", code);
      //                 model1.set("KRNAME", name);
      //               }
      //             }
      //           },
      //         },
      //         listConfig: {
      //           loadingText: '검색 중...',
      //           emptyText: comboboxEmpty1,
      //           width: 200,
      //           getInnerTpl: function () {
      //             return comboboxOption1;
      //           }
      //         },
      //       },
    }, {
      dataIndex: 'CHECKRESULT1',
      text: 'X1',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      //       enableFocusableContainer: true,
      tdCls: 'x1',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        //         typeAhead: true,
        transform: 'stateSelect',
        //         forceSelection: true,
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '1');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '1');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1; // 시료수
        var qty_check = false;

        // 1. 시료수 범위 체크
        if (checkqty > 0 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x1');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x1');
              return value;
            } else {
              if (num > max) {
                setcolor('x1');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT2',
      text: 'X2',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x2',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '2');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '2');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 1 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x2');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x2');
              return value;
            } else {
              if (num > max) {
                setcolor('x2');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT3',
      text: 'X3',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x3',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '3');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '3');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 2 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x3');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x3');
              return value;
            } else {
              if (num > max) {
                setcolor('x3');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT4',
      text: 'X4',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x4',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '4');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '4');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 3 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x4');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x4');
              return value;
            } else {
              if (num > max) {
                setcolor('x4');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT5',
      text: 'X5',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x5',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '5');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '5');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 4 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x5');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x5');
              return value;
            } else {
              if (num > max) {
                setcolor('x5');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT6',
      text: 'X6',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x6',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '6');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '6');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 5 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x6');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x6');
              return value;
            } else {
              if (num > max) {
                setcolor('x6');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT7',
      text: 'X7',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x7',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '7');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '7');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 6 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x7');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x7');
              return value;
            } else {
              if (num > max) {
                setcolor('x7');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT8',
      text: 'X8',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x8',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '8');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '8');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 7 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x8');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x8');
              return value;
            } else {
              if (num > max) {
                setcolor('x8');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT9',
      text: 'X9',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x9',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '9');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '9');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 8 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x9');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x9');
              return value;
            } else {
              if (num > max) {
                setcolor('x9');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT10',
      text: 'X10',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x10',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '10');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '10');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1; // 시료수
        var qty_check = false;

        if (checkqty > 9 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x10');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x10');
              return value;
            } else {
              if (num > max) {
                setcolor('x10');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT11',
      text: 'X11',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x11',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '11');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '11');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 10 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x11');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x11');
              return value;
            } else {
              if (num > max) {
                setcolor('x11');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT12',
      text: 'X12',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x12',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '12');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '12');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 11 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x12');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x12');
              return value;
            } else {
              if (num > max) {
                setcolor('x12');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT13',
      text: 'X13',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x13',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '13');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '13');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 12 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x13');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x13');
              return value;
            } else {
              if (num > max) {
                setcolor('x13');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT14',
      text: 'X14',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x14',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '14');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '14');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 13 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x14');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x14');
              return value;
            } else {
              if (num > max) {
                setcolor('x14');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT15',
      text: 'X15',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x15',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '15');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '15');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 14 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x15');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x15');
              return value;
            } else {
              if (num > max) {
                setcolor('x15');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT16',
      text: 'X16',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x16',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '16');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '16');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 15 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x16');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x16');
              return value;
            } else {
              if (num > max) {
                setcolor('x16');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT17',
      text: 'X17',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x17',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '17');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '17');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 16 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x17');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x17');
              return value;
            } else {
              if (num > max) {
                setcolor('x17');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT18',
      text: 'X18',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x18',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '18');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '18');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 17 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x18');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x18');
              return value;
            } else {
              if (num > max) {
                setcolor('x18');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT19',
      text: 'X19',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x19',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '19');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '19');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 18 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x19');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x19');
              return value;
            } else {
              if (num > max) {
                setcolor('x19');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT20',
      text: 'X20',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x20',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '20');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '20');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 19 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x20');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x20');
              return value;
            } else {
              if (num > max) {
                setcolor('x20');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT21',
      text: 'X21',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x21',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '21');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '21');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 20 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x21');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x21');
              return value;
            } else {
              if (num > max) {
                setcolor('x21');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT22',
      text: 'X22',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x22',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '22');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '22');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 21 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x22');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x22');
              return value;
            } else {
              if (num > max) {
                setcolor('x22');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT23',
      text: 'X23',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x23',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '23');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '23');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 22 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x23');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x23');
              return value;
            } else {
              if (num > max) {
                setcolor('x23');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT24',
      text: 'X24',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x24',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '24');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '24');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 23 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x24');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x24');
              return value;
            } else {
              if (num > max) {
                setcolor('x24');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT25',
      text: 'X25',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x25',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '25');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '25');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 24 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x25');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x25');
              return value;
            } else {
              if (num > max) {
                setcolor('x25');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT26',
      text: 'X26',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x26',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '26');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '26');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 25 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x26');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x26');
              return value;
            } else {
              if (num > max) {
                setcolor('x26');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT27',
      text: 'X27',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x27',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '27');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '27');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 26 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x27');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x27');
              return value;
            } else {
              if (num > max) {
                setcolor('x27');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT28',
      text: 'X28',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x28',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '28');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '28');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 27 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x28');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x28');
              return value;
            } else {
              if (num > max) {
                setcolor('x28');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT29',
      text: 'X29',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x29',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '29');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '29');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200, // 330,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 28 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x29');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x29');
              return value;
            } else {
              if (num > max) {
                setcolor('x29');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT30',
      text: 'X30',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x30',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '30');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '30');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 29 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x30');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x30');
              return value;
            } else {
              if (num > max) {
                setcolor('x30');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT31',
      text: 'X31',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x31',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '31');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '31');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 30 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x31');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x31');
              return value;
            } else {
              if (num > max) {
                setcolor('x31');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT32',
      text: 'X32',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x32',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '32');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '32');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 31 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x32');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x32');
              return value;
            } else {
              if (num > max) {
                setcolor('x32');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT33',
      text: 'X33',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x33',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '33');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '33');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 32 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x33');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x33');
              return value;
            } else {
              if (num > max) {
                setcolor('x33');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT34',
      text: 'X34',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x34',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '34');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '34');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 33 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x34');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x34');
              return value;
            } else {
              if (num > max) {
                setcolor('x34');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT35',
      text: 'X35',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x35',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '35');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '35');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 34 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x35');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x35');
              return value;
            } else {
              if (num > max) {
                setcolor('x35');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT36',
      text: 'X36',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x36',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '36');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '36');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 35 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x36');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x36');
              return value;
            } else {
              if (num > max) {
                setcolor('x36');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT37',
      text: 'X37',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x37',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '37');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '37');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 36 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x37');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x37');
              return value;
            } else {
              if (num > max) {
                setcolor('x37');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT38',
      text: 'X38',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x38',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '38');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '38');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 37 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x38');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x38');
              return value;
            } else {
              if (num > max) {
                setcolor('x38');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT39',
      text: 'X39',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x39',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '39');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '39');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 38 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x39');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x39');
              return value;
            } else {
              if (num > max) {
                setcolor('x39');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT40',
      text: 'X40',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x40',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '40');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '40');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 39 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x40');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x40');
              return value;
            } else {
              if (num > max) {
                setcolor('x40');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT41',
      text: 'X41',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x41',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '41');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '41');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 40 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x41');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x41');
              return value;
            } else {
              if (num > max) {
                setcolor('x41');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT42',
      text: 'X42',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x42',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '42');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '42');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 41 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x42');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x42');
              return value;
            } else {
              if (num > max) {
                setcolor('x42');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT43',
      text: 'X43',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x43',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '43');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '43');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 42 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x43');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x43');
              return value;
            } else {
              if (num > max) {
                setcolor('x43');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT44',
      text: 'X44',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x44',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '44');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '44');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 43 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x44');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x44');
              return value;
            } else {
              if (num > max) {
                setcolor('x44');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT45',
      text: 'X45',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x45',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '45');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '45');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(250, 227, 125);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 44 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x45');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x45');
              return value;
            } else {
              if (num > max) {
                setcolor('x45');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT46',
      text: 'X46',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x46',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '46');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '46');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 45 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x46');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x46');
              return value;
            } else {
              if (num > max) {
                setcolor('x46');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT47',
      text: 'X47',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x47',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '47');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '47');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 46 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x47');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x47');
              return value;
            } else {
              if (num > max) {
                setcolor('x47');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT48',
      text: 'X48',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x48',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '48');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '48');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 47 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x48');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x48');
              return value;
            } else {
              if (num > max) {
                setcolor('x48');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT49',
      text: 'X49',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x49',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '49');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '49');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 48 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x49');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x49');
              return value;
            } else {
              if (num > max) {
                setcolor('x49');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    }, {
      dataIndex: 'CHECKRESULT50',
      text: 'X50',
      xtype: 'gridcolumn',
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      width: 130,
      tdCls: 'x50',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 60,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (field, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            var value = field.getValue();

            fn_ext_check_column(model.data, selectedRow, value, '50');
          },
          specialkey: function (field, e) {
            if (e.keyCode === 13 || e.keyCode === 9) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

              var value = field.getValue();

              fn_ext_check_column(model.data, selectedRow, value, '50');
            }
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: comboboxEmpty2,
          width: 200,
          getInnerTpl: function () {
            return comboboxOption2;
          }
        },
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-left-style: solid;";
        meta.style += " border-left-width: 1px;";
        var max = record.data.MAXVALUE;
        var min = record.data.MINVALUE;
        var checkqty = record.data.CHECKQTY * 1;
        var qty_check = false;

        if (checkqty > 49 && checkqty <= 50) {
          qty_check = true;
        } else {
          qty_check = false;
        }

        if (qty_check == false) {
          meta.style = "background-color:rgb(234,234,234);";
          meta.style += " border-color: #5B9BD5;";
          meta.style += " border-left-style: solid;";
          meta.style += " border-left-width: 1px;";
        } else {
          if (value == "NG" || value == "OK") {
            if (value == "NG") {
              setcolor('x50');
              return value;
            } else {
              setcolor(clearInterval());
              meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
              meta.style += " border-color: #5B9BD5;";
              meta.style += " border-left-style: solid;";
              meta.style += " border-left-width: 1px;";
              return value;
            }
          } else {
            var num = value * 1;

            if (min > num) {
              setcolor('x50');
              return value;
            } else {
              if (num > max) {
                setcolor('x50');
                return value;
              } else {
                setcolor(clearInterval());
                meta.style = "color:rgb(0, 0, 255); background-color:rgb(253, 218, 255); ";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                return value;
              }
            }
          }
        }
      },
    },
    // Hidden Columns
    {
      dataIndex: 'ORGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
      dataIndex: 'FMLID',
      xtype: 'hidden',
    }, {
      dataIndex: 'ORDERNO',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKLISTID',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKORDERID',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKORDERSEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKBIG',
      xtype: 'hidden',
    }, {
      dataIndex: 'FMLTYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'FMLTYPENAME',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKMIDDLE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKSMALL',
      xtype: 'hidden',
    }, {
      dataIndex: 'SPECIALCHECK',
      xtype: 'hidden',
    }, {
      dataIndex: 'STANDARDVALUE',
      xtype: 'hidden',
    }, {
      dataIndex: 'MAXVALUE',
      xtype: 'hidden',
    }, {
      dataIndex: 'MINVALUE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKQTY',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKINTERVAL',
      xtype: 'hidden',
    }, {
      dataIndex: 'INTERVALCNT',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKMETHODTYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKYN',
      xtype: 'hidden',
    }, {
      dataIndex: 'PERSONID',
      xtype: 'hidden',
    }, {
      dataIndex: 'KRNAME',
      xtype: 'hidden',
    }, {
      dataIndex: 'MANAGEEMPLOYEE',
      xtype: 'hidden',
    }, {
      dataIndex: 'STARTTIME',
      xtype: 'hidden',
    }, {
      dataIndex: 'BPYN',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTM',
      xtype: 'hidden',
    }, {
      dataIndex: 'MANAGEKRNAME',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME1',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME2',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME3',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME4',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME5',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME6',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME7',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME8',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME9',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME10',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME11',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME12',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME13',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME14',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME15',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME16',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME17',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME18',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME19',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME20',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME21',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME22',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME23',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME24',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME25',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME26',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME27',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME28',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME29',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME30',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME31',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME32',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME33',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME34',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME35',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME36',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME37',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME38',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME39',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME40',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME41',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME42',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME43',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME44',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME45',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME46',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME47',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME48',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME49',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKTIME50',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG1',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG2',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG3',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG4',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG5',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG6',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG7',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG8',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG9',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG10',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG11',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG12',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG13',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG14',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG15',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG16',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG17',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG18',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG19',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG20',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG21',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG22',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG23',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG24',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG25',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG26',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG27',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG28',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG29',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG30',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG31',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG32',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG33',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG34',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG35',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG36',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG37',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG38',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG39',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG40',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG41',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG42',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG43',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG44',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG45',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG46',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG47',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG48',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG49',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKRESULTNG50',
      xtype: 'hidden',
    }, {
      dataIndex: 'LOTNOVISUALOLD',
      xtype: 'hidden',
    }, {
      dataIndex: 'LOTNOVISUAL',
      xtype: 'hidden',
    }, {
      dataIndex: 'CHECKCYCLE',
      xtype: 'hidden',
    }, ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/prod/process/FmlRegist.do' />"
  });
  $.extend(items["api.1"], {
    update: "<c:url value='/update/prod/process/FmlRegist.do' />"
  });

  items["btns.1"] = [];

  items["btns.ctr.1"] = {};
  $.extend(items["btns.ctr.1"], {
    "#FmlSelect": {
      itemclick: 'FmlSelectClick'
    }
  });

  // 페이징
  items["dock.paging.1"] = {
    xtype: 'pagingtoolbar',
    dock: 'bottom',
    displayInfo: true,
    store: gridnms["store.1"],
  };

  // 버튼 컨트롤
  items["dock.btn.1"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.1"],
    items: items["btns.1"],
  };

  items["docked.1"] = [];
}

function FmlSelectClick(dataview, record, item, index, e, eOpts) {

  colIdx = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().column; // dataview.eventPosition.colIdx;
  rowIdx = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row; // dataview.eventPosition.rowIdx;

  var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
  var standardvalue = model.data.STANDARDVALUE;
  var sparams = {};

  if (standardvalue === "") {
    // 검사기준값이 없으면 OK / NG 표시 될 수 있도록 변경
    sparams = {
      BIGCD: "APP" + "",
      MIDDLECD: "유해한 결함 없을 것" + "",
      MINVALUE: "",
      MAXVALUE: "",
      CHECKINTERVAL: "",
      INTERVALCNT: "",
    };
  } else {
    sparams = {
      BIGCD: "APP" + "",
      MIDDLECD: "!@#$%" + "", // OK / NG 표시되지 않는 항목은 쓰레기 값을 넣어 조회가 되지 않도록한다.
      MINVALUE: model.data.MINVALUE,
      MAXVALUE: model.data.MAXVALUE,
      CHECKINTERVAL: model.data.CHECKINTERVAL,
      INTERVALCNT: model.data.INTERVALCNT,
    };
  }

  extGridSearch(sparams, gridnms["store.2"]);
  //   Ext.getStore(gridnms["store.2"]).loadCount = 1;
  //   Ext.getStore(gridnms["store.2"]).reload();

  var orderno = record.data.ORDERNO;
  $('#orderno').val(orderno);
  var checklistid = record.data.CHECKLISTID;
  $('#checklistid').val(checklistid);

  var lotno = record.data.LOTNOVISUAL;
  $('#LotNoVisual').val(lotno);

  var personid = record.data.PERSONID;
  $('#PersonId').val(personid);
  var krname = record.data.KRNAME;
  $('#KrName').val(krname);
  var columnChk = dataview.config.selectionModel.selection;
  if (columnChk != undefined) {
    //    var columnName = dataview.config.selectionModel.selection.column.dataIndex;
    var colnum = (colIdx * 1) - 1;
    if (colnum < 1) {
      colnum = 1;
    }

    var rownum = (rowIdx * 1) + 1;
  }
};

function setValues_popup1() {
  gridnms["models.popup1"] = [];
  gridnms["stores.popup1"] = [];
  gridnms["views.popup1"] = [];
  gridnms["controllers.popup1"] = [];

  gridnms["grid.14"] = "CheckResultListPopup";

  gridnms["panel.14"] = gridnms["app"] + ".view." + gridnms["grid.14"];
  gridnms["views.popup1"].push(gridnms["panel.14"]);

  gridnms["controller.14"] = gridnms["app"] + ".controller." + gridnms["grid.14"];
  gridnms["controllers.popup1"].push(gridnms["controller.14"]);

  gridnms["model.14"] = gridnms["app"] + ".model." + gridnms["grid.14"];

  gridnms["store.14"] = gridnms["app"] + ".store." + gridnms["grid.14"];

  gridnms["models.popup1"].push(gridnms["model.14"]);

  gridnms["stores.popup1"].push(gridnms["store.14"]);

  fields["model.14"] = [{
      type: 'string',
      name: 'RN',
    }, {
      type: 'string',
      name: 'ORGID',
    }, {
      type: 'string',
      name: 'COMPANYID',
    }, {
      type: 'string',
      name: 'WORKORDERID',
    }, {
      type: 'number',
      name: 'WORKORDERSEQ',
    }, {
      type: 'string',
      name: 'FMLID',
    }, {
      type: 'number',
      name: 'ORDERNO',
    }, {
      type: 'number',
      name: 'CHECKLISTID',
    }, {
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'FMLTYPE',
    }, {
      type: 'string',
      name: 'FMLTYPENAME',
    }, {
      type: 'string',
      name: 'CHECKMIDDLE',
    }, {
      type: 'string',
      name: 'CHECKSMALL',
    }, {
      type: 'string',
      name: 'CHECKSMALLNAME',
    }, {
      type: 'string',
      name: 'SPECIALCHECK',
    }, {
      type: 'string',
      name: 'SPECIALCHECKNAME',
    }, {
      type: 'string',
      name: 'STANDARDVALUE',
    }, {
      type: 'number',
      name: 'MAXVALUE',
    }, {
      type: 'number',
      name: 'MINVALUE',
    }, {
      type: 'string',
      name: 'CHECKCYCLE',
    }, {
      type: 'string',
      name: 'CHECKCYCLENAME',
    }, {
      type: 'number',
      name: 'CHECKINTERVAL',
    }, {
      type: 'number',
      name: 'INTERVALCNT',
    }, {
      type: 'number',
      name: 'CHECKQTY',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPE',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPENAME',
    }, {
      type: 'number',
      name: 'MANAGEAREA',
    }, {
      type: 'string',
      name: 'CHECKRESULT1',
    }, {
      type: 'string',
      name: 'CHECKRESULT2',
    }, {
      type: 'string',
      name: 'CHECKRESULT3',
    }, {
      type: 'string',
      name: 'CHECKRESULT4',
    }, {
      type: 'string',
      name: 'CHECKRESULT5',
    }, {
      type: 'string',
      name: 'CHECKRESULT6',
    }, {
      type: 'string',
      name: 'CHECKRESULT7',
    }, {
      type: 'string',
      name: 'CHECKRESULT8',
    }, {
      type: 'string',
      name: 'CHECKRESULT9',
    }, {
      type: 'string',
      name: 'CHECKRESULT10',
    }, {
      type: 'string',
      name: 'CHECKRESULT11',
    }, {
      type: 'string',
      name: 'CHECKRESULT12',
    }, {
      type: 'string',
      name: 'CHECKRESULT13',
    }, {
      type: 'string',
      name: 'CHECKRESULT14',
    }, {
      type: 'string',
      name: 'CHECKRESULT15',
    }, {
      type: 'string',
      name: 'CHECKRESULT16',
    }, {
      type: 'string',
      name: 'CHECKRESULT17',
    }, {
      type: 'string',
      name: 'CHECKRESULT18',
    }, {
      type: 'string',
      name: 'CHECKRESULT19',
    }, {
      type: 'string',
      name: 'CHECKRESULT20',
    }, {
      type: 'string',
      name: 'CHECKRESULT21',
    }, {
      type: 'string',
      name: 'CHECKRESULT22',
    }, {
      type: 'string',
      name: 'CHECKRESULT23',
    }, {
      type: 'string',
      name: 'CHECKRESULT24',
    }, {
      type: 'string',
      name: 'CHECKRESULT25',
    }, {
      type: 'string',
      name: 'CHECKRESULT26',
    }, {
      type: 'string',
      name: 'CHECKRESULT27',
    }, {
      type: 'string',
      name: 'CHECKRESULT28',
    }, {
      type: 'string',
      name: 'CHECKRESULT29',
    }, {
      type: 'string',
      name: 'CHECKRESULT30',
    }, {
      type: 'string',
      name: 'CHECKRESULT31',
    }, {
      type: 'string',
      name: 'CHECKRESULT32',
    }, {
      type: 'string',
      name: 'CHECKRESULT33',
    }, {
      type: 'string',
      name: 'CHECKRESULT34',
    }, {
      type: 'string',
      name: 'CHECKRESULT35',
    }, {
      type: 'string',
      name: 'CHECKRESULT36',
    }, {
      type: 'string',
      name: 'CHECKRESULT37',
    }, {
      type: 'string',
      name: 'CHECKRESULT38',
    }, {
      type: 'string',
      name: 'CHECKRESULT39',
    }, {
      type: 'string',
      name: 'CHECKRESULT40',
    }, {
      type: 'string',
      name: 'CHECKRESULT41',
    }, {
      type: 'string',
      name: 'CHECKRESULT42',
    }, {
      type: 'string',
      name: 'CHECKRESULT43',
    }, {
      type: 'string',
      name: 'CHECKRESULT44',
    }, {
      type: 'string',
      name: 'CHECKRESULT45',
    }, {
      type: 'string',
      name: 'CHECKRESULT46',
    }, {
      type: 'string',
      name: 'CHECKRESULT47',
    }, {
      type: 'string',
      name: 'CHECKRESULT48',
    }, {
      type: 'string',
      name: 'CHECKRESULT49',
    }, {
      type: 'string',
      name: 'CHECKRESULT50',
    }, {
      type: 'string',
      name: 'CHK1',
    }, {
      type: 'string',
      name: 'CHK2',
    }, {
      type: 'string',
      name: 'CHK3',
    }, {
      type: 'string',
      name: 'CHK4',
    }, {
      type: 'string',
      name: 'CHK5',
    }, {
      type: 'string',
      name: 'CHK6',
    }, {
      type: 'string',
      name: 'CHK7',
    }, {
      type: 'string',
      name: 'CHK8',
    }, {
      type: 'string',
      name: 'CHK9',
    }, {
      type: 'string',
      name: 'CHK10',
    }, {
      type: 'string',
      name: 'CHK11',
    }, {
      type: 'string',
      name: 'CHK12',
    }, {
      type: 'string',
      name: 'CHK13',
    }, {
      type: 'string',
      name: 'CHK14',
    }, {
      type: 'string',
      name: 'CHK15',
    }, {
      type: 'string',
      name: 'CHK16',
    }, {
      type: 'string',
      name: 'CHK17',
    }, {
      type: 'string',
      name: 'CHK18',
    }, {
      type: 'string',
      name: 'CHK19',
    }, {
      type: 'string',
      name: 'CHK20',
    }, {
      type: 'string',
      name: 'CHK21',
    }, {
      type: 'string',
      name: 'CHK22',
    }, {
      type: 'string',
      name: 'CHK23',
    }, {
      type: 'string',
      name: 'CHK24',
    }, {
      type: 'string',
      name: 'CHK25',
    }, {
      type: 'string',
      name: 'CHK26',
    }, {
      type: 'string',
      name: 'CHK27',
    }, {
      type: 'string',
      name: 'CHK28',
    }, {
      type: 'string',
      name: 'CHK29',
    }, {
      type: 'string',
      name: 'CHK30',
    }, {
      type: 'string',
      name: 'CHK31',
    }, {
      type: 'string',
      name: 'CHK32',
    }, {
      type: 'string',
      name: 'CHK33',
    }, {
      type: 'string',
      name: 'CHK34',
    }, {
      type: 'string',
      name: 'CHK35',
    }, {
      type: 'string',
      name: 'CHK36',
    }, {
      type: 'string',
      name: 'CHK37',
    }, {
      type: 'string',
      name: 'CHK38',
    }, {
      type: 'string',
      name: 'CHK39',
    }, {
      type: 'string',
      name: 'CHK40',
    }, {
      type: 'string',
      name: 'CHK41',
    }, {
      type: 'string',
      name: 'CHK42',
    }, {
      type: 'string',
      name: 'CHK43',
    }, {
      type: 'string',
      name: 'CHK44',
    }, {
      type: 'string',
      name: 'CHK45',
    }, {
      type: 'string',
      name: 'CHK46',
    }, {
      type: 'string',
      name: 'CHK47',
    }, {
      type: 'string',
      name: 'CHK48',
    }, {
      type: 'string',
      name: 'CHK49',
    }, {
      type: 'string',
      name: 'CHK50',
    }, {
      type: 'string',
      name: 'CHECKYN',
    }, {
      type: 'string',
      name: 'CHECKYNNAME',
    }, {
      type: 'string',
      name: 'PERSONID',
    }, {
      type: 'string',
      name: 'KRNAME',
    }, {
      type: 'string',
      name: 'CHECKRESULTM',
    }, {
      type: 'string',
      name: 'MANAGEEMPLOYEE',
    }, {
      type: 'string',
      name: 'MANAGEKRNAME',
    }, {
      type: 'string',
      name: 'STARTTIME',
    }, {
      type: 'string',
      name: 'BPYN',
    }, {
      type: 'string',
      name: 'LASTYN',
    }, ];

  fields["columns.14"] = [
    // Display Columns
    {
      dataIndex: 'RN',
      text: '순<br/><br/>번',
      xtype: 'gridcolumn',
      width: 50,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        var lastyn = record.data.LASTYN;
        if (lastyn == "Y") {
          meta.style += " border-bottom-style: solid;";
          meta.style += " border-bottom-width: 1px;";
        } else {
          meta.style += " border-bottom-color: rgb(234, 234, 234);";
          meta.style += " border-bottom-style: solid;";
          meta.style += " border-bottom-width: 1px;";
        }
        return value;
      },
    }, {
      dataIndex: 'CHECKSMALLNAME',
      text: '항목',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        var lastyn = record.data.LASTYN;
        if (lastyn == "Y") {
          meta.style += " border-bottom-style: solid;";
          meta.style += " border-bottom-width: 1px;";
        } else {
          meta.style += " border-bottom-color: rgb(234, 234, 234);";
          meta.style += " border-bottom-style: solid;";
          meta.style += " border-bottom-width: 1px;";
        }
        return value;
      },
    }, {
      dataIndex: 'CHECKCYCLENAME',
      text: '주기',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        var lastyn = record.data.LASTYN;
        if (lastyn == "Y") {
          meta.style += " border-bottom-style: solid;";
          meta.style += " border-bottom-width: 1px;";
        } else {
          meta.style += " border-bottom-color: rgb(234, 234, 234);";
          meta.style += " border-bottom-style: solid;";
          meta.style += " border-bottom-width: 1px;";
        }
        return value;
      },
    }, {
      dataIndex: 'MANAGEAREA',
      text: '관리<br/><br/>영역',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //           var lastyn = record.data.LASTYN;
        //           if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //           }
        return Ext.util.Format.number(value, '0,000.00');
      },
    }, {
      dataIndex: 'CHK1',
      text: '1',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //           var lastyn = record.data.LASTYN;
        //           if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //           }
        return value;
      },
    }, {
      dataIndex: 'CHK2',
      text: '2',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //           var lastyn = record.data.LASTYN;
        //           if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //           }
        return value;
      },
    }, {
      dataIndex: 'CHK3',
      text: '3',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //           var lastyn = record.data.LASTYN;
        //           if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //           }
        return value;
      },
    }, {
      dataIndex: 'CHK4',
      text: '4',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //           var lastyn = record.data.LASTYN;
        //           if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //           }
        return value;
      },
    }, {
      dataIndex: 'CHK5',
      text: '5',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //           var lastyn = record.data.LASTYN;
        //           if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //           }
        return value;
      },
    }, {
      dataIndex: 'CHK6',
      text: '6',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //           var lastyn = record.data.LASTYN;
        //           if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //           }
        return value;
      },
    }, {
      dataIndex: 'CHK7',
      text: '7',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK8',
      text: '8',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK9',
      text: '9',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK10',
      text: '10',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK11',
      text: '11',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK12',
      text: '12',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK13',
      text: '13',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK14',
      text: '14',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK15',
      text: '15',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK16',
      text: '16',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK17',
      text: '17',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK18',
      text: '18',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK19',
      text: '19',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK20',
      text: '20',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK21',
      text: '21',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK22',
      text: '22',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK23',
      text: '23',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK24',
      text: '24',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK25',
      text: '25',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //        var lastyn = record.data.LASTYN;
        //        if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //        }
        return value;
      },
    }, {
      dataIndex: 'CHK26',
      text: '26',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK27',
      text: '27',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK28',
      text: '28',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK29',
      text: '29',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK30',
      text: '30',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK31',
      text: '31',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK32',
      text: '32',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK33',
      text: '33',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK34',
      text: '34',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK35',
      text: '35',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK36',
      text: '36',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK37',
      text: '37',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK38',
      text: '38',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK39',
      text: '39',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK40',
      text: '40',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK41',
      text: '41',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK42',
      text: '42',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK43',
      text: '43',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK44',
      text: '44',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK45',
      text: '45',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK46',
      text: '46',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK47',
      text: '47',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK48',
      text: '48',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK49',
      text: '49',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    }, {
      dataIndex: 'CHK50',
      text: '50',
      xtype: 'gridcolumn',
      width: 30,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        //          var lastyn = record.data.LASTYN;
        //          if ( lastyn == "Y" ) {
        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        //          }
        return value;
      },
    },
    // Hidden Columns
    {
      dataIndex: 'ORGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
      dataIndex: 'WAREHOUSINGNO',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'MODEL',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKORDERSEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'WAREHOUSINGDATE',
      xtype: 'hidden',
    }, {
      dataIndex: 'REMARKS',
      xtype: 'hidden',
    }, {
      dataIndex: 'LASTYN',
      xtype: 'hidden',
    }, ];

  items["api.14"] = {};
  $.extend(items["api.14"], {
    read: "<c:url value='/searchCheckResultPopupList.do' />"
  });

  items["btns.14"] = [];

  items["btns.ctr.14"] = {};

  items["dock.paging.14"] = {
    xtype: 'pagingtoolbar',
    dock: 'bottom',
    displayInfo: true,
    store: gridnms["store.14"],
  };

  items["dock.btn.14"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.14"],
    items: items["btns.14"],
  };

  items["docked.14"] = [];
}

function setValues_popup2() {
  gridnms["models.popup2"] = [];
  gridnms["stores.popup2"] = [];
  gridnms["views.popup2"] = [];
  gridnms["controllers.popup2"] = [];

  gridnms["grid.15"] = "CheckResultListPopup2";

  gridnms["panel.15"] = gridnms["app"] + ".view." + gridnms["grid.15"];
  gridnms["views.popup2"].push(gridnms["panel.15"]);

  gridnms["controller.15"] = gridnms["app"] + ".controller." + gridnms["grid.15"];
  gridnms["controllers.popup2"].push(gridnms["controller.15"]);

  gridnms["model.15"] = gridnms["app"] + ".model." + gridnms["grid.15"];

  gridnms["store.15"] = gridnms["app"] + ".store." + gridnms["grid.15"];

  gridnms["models.popup2"].push(gridnms["model.15"]);

  gridnms["stores.popup2"].push(gridnms["store.15"]);

  fields["model.15"] = [{
      type: 'string',
      name: 'RN',
    }, {
      type: 'string',
      name: 'ORGID',
    }, {
      type: 'string',
      name: 'COMPANYID',
    }, {
      type: 'string',
      name: 'WORKORDERID',
    }, {
      type: 'number',
      name: 'WORKORDERSEQ',
    }, {
      type: 'string',
      name: 'FMLID',
    }, {
      type: 'number',
      name: 'ORDERNO',
    }, {
      type: 'number',
      name: 'CHECKLISTID',
    }, {
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'FMLTYPE',
    }, {
      type: 'string',
      name: 'FMLTYPENAME',
    }, {
      type: 'string',
      name: 'CHECKMIDDLE',
    }, {
      type: 'string',
      name: 'CHECKSMALL',
    }, {
      type: 'string',
      name: 'CHECKSMALLNAME',
    }, {
      type: 'string',
      name: 'SPECIALCHECK',
    }, {
      type: 'string',
      name: 'SPECIALCHECKNAME',
    }, {
      type: 'string',
      name: 'STANDARDVALUE',
    }, {
      type: 'number',
      name: 'MAXVALUE',
    }, {
      type: 'number',
      name: 'MINVALUE',
    }, {
      type: 'string',
      name: 'CHECKCYCLE',
    }, {
      type: 'string',
      name: 'CHECKCYCLENAME',
    }, {
      type: 'number',
      name: 'CHECKINTERVAL',
    }, {
      type: 'number',
      name: 'INTERVALCNT',
    }, {
      type: 'number',
      name: 'CHECKQTY',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPE',
    }, {
      type: 'string',
      name: 'CHECKMETHODTYPENAME',
    }, {
      type: 'number',
      name: 'MANAGEAREA',
    }, {
      type: 'string',
      name: 'CHECKRESULT1',
    }, {
      type: 'string',
      name: 'CHECKRESULT2',
    }, {
      type: 'string',
      name: 'CHECKRESULT3',
    }, {
      type: 'string',
      name: 'CHK1',
    }, {
      type: 'string',
      name: 'CHK2',
    }, {
      type: 'string',
      name: 'CHK3',
    }, {
      type: 'string',
      name: 'CHECKYN',
    }, {
      type: 'string',
      name: 'CHECKYNNAME',
    }, {
      type: 'string',
      name: 'PERSONID',
    }, {
      type: 'string',
      name: 'KRNAME',
    }, {
      type: 'string',
      name: 'CHECKRESULTM',
    }, {
      type: 'string',
      name: 'MANAGEEMPLOYEE',
    }, {
      type: 'string',
      name: 'MANAGEKRNAME',
    }, {
      type: 'string',
      name: 'STARTTIME',
    }, {
      type: 'string',
      name: 'BPYN',
    }, {
      type: 'string',
      name: 'LASTYN',
    }, ];

  fields["columns.15"] = [
    // Display Columns
    {
      dataIndex: 'RN',
      text: '순<br/><br/>번',
      xtype: 'gridcolumn',
      width: 50,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        return value;
      },
    }, {
      dataIndex: 'CHECKSMALLNAME',
      text: '검사<br/><br/>항목',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        return value;
      },
    }, {
      dataIndex: 'SPECIALCHECKNAME',
      text: '특별<br/><br/>특성',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";

        var check = record.data.SPECIALCHECKNAME;

        if (check == "S") {
          meta.style += " color:rgb(255, 0, 0);";
        }

        return value;
      },
    }, {
      dataIndex: 'CHECKSTANDARD',
      text: '검사내용',
      xtype: 'gridcolumn',
      width: 320,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        return value;
      },
    }, {
      dataIndex: 'CHECKMETHODTYPENAME',
      text: '검사방법',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";
        return value;
      },
      //     }, {
      //       dataIndex: 'CHECKCYCLENAME',
      //       text: '주기',
      //       xtype: 'gridcolumn',
      //       width: 120,
      //       hidden: false,
      //       sortable: false,
      //       resizable: false,
      //       menuDisabled: true,
      //       style: 'text-align:center',
      //       align: "center",
      //       renderer: function (value, meta, record) {
      //         meta.style = "background-color:rgb(234, 234, 234);";
      //         meta.style += " border-color: #5B9BD5;";
      //         meta.style += " border-right-style: solid;";
      //         meta.style += " border-right-width: 1px;";

      //         meta.style += " border-bottom-style: solid;";
      //         meta.style += " border-bottom-width: 1px;";

      //         return value;
      //       },
    }, {
      dataIndex: 'CHECKRESULT1',
      text: '1',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " font-weight: bold;";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";

        return value;
      },
    }, {
      dataIndex: 'CHECKRESULT2',
      text: '2',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " font-weight: bold;";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";

        return value;
      },
    }, {
      dataIndex: 'CHECKRESULT3',
      text: '3',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234);";
        meta.style += " font-weight: bold;";
        meta.style += " border-color: #5B9BD5;";
        meta.style += " border-right-style: solid;";
        meta.style += " border-right-width: 1px;";

        meta.style += " border-bottom-style: solid;";
        meta.style += " border-bottom-width: 1px;";

        return value;
      },
    },
    // Hidden Columns
    {
      dataIndex: 'ORGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
      dataIndex: 'WAREHOUSINGNO',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'MODEL',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKORDERSEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'WAREHOUSINGDATE',
      xtype: 'hidden',
    }, {
      dataIndex: 'REMARKS',
      xtype: 'hidden',
    }, {
      dataIndex: 'LASTYN',
      xtype: 'hidden',
    }, ];

  items["api.15"] = {};
  $.extend(items["api.15"], {
    read: "<c:url value='/searchCheckResultPopupList2.do' />"
  });

  items["btns.15"] = [];

  items["btns.ctr.15"] = {};

  items["dock.paging.15"] = {
    xtype: 'pagingtoolbar',
    dock: 'bottom',
    displayInfo: true,
    store: gridnms["store.15"],
  };

  items["dock.btn.15"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.15"],
    items: items["btns.15"],
  };

  items["docked.15"] = [];
}

var gridarea1, gridarea14, gridarea15;
function setExtGrid() {
  setExtGrid_popup1();
  setExtGrid_popup2();
  setExtGrid_fml();

  Ext.EventManager.onWindowResize(function (w, h) {
    gridarea1.updateLayout();
  });
}

function setExtGrid_fml() {

  Ext.define(gridnms["model.1"], {
    extend: Ext.data.Model,
    fields: fields["model.1"],
  });

  Ext.define(gridnms["model.2"], {
    extend: Ext.data.Model,
    fields: fields["model.2"],
  });

  Ext.define(gridnms["model.3"], {
    extend: Ext.data.Model,
    fields: fields["model.3"],
  });

  Ext.define(gridnms["model.4"], {
    extend: Ext.data.Model,
    fields: fields["model.4"],
  });

  Ext.define(gridnms["model.5"], {
    extend: Ext.data.Model,
    fields: fields["model.5"],
  });

  Ext.define(gridnms["model.6"], {
    extend: Ext.data.Model,
    fields: fields["model.6"],
  });

  Ext.define(gridnms["store.1"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.1"],
            model: gridnms["model.1"],
            autoLoad: true,
            pageSize: gridVals.pageSize, // 20,
            proxy: {
              type: 'ajax',
              api: items["api.1"],
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                WORKORDERID: '${searchVO.WORKORDERID}',
                WORKORDERSEQ: '${searchVO.WORKORDERSEQ}',
                FMLTYPE: '${FMLTYPE}',
                TYPE: $('#type').val(),
                FMLID: '${searchVO.FMLID}',
              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.2"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.2"],
            model: gridnms["model.2"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchDummyOKNGLov.do' />",
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.3"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.3"],
            model: gridnms["model.3"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchDummyOKNGLov.do' />",
              extraParams: {
                BIGCD: "APP" + "",
                MIDDLECD: "유해한 결함 없을 것" + "",
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.4"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.4"],
            model: gridnms["model.4"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchWorkerLov.do' />",
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                INSPECTORTYPE: '20',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.5"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.5"],
            model: gridnms["model.5"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchDummyOKNGLov.do' />",
              extraParams: {
                BIGCD: "APP" + "",
                MIDDLECD: "유해한 결함 없을 것" + "",
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.6"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.6"],
            model: gridnms["model.6"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: "ajax",
              url: "<c:url value='/searchWorkerLov.do' />",
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                INSPECTORTYPE: '20',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.1"], {
    extend: Ext.app.Controller,
    refs: {
      FmlSelect: '#FmlSelect',
    },
    stores: [gridnms["store.1"]],
    control: items["btns.ctr.1"],

    FmlSelectClick: FmlSelectClick,
  });

  Ext.define(
    gridnms["panel.1"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.1"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'cellmodel',
        itemId: gridnms["panel.1"],
        id: gridnms["panel.1"],
        store: gridnms["store.1"],
        height: 693, // 455,
        border: 2,
        scrollable: true,
        enableLocking: true,
        //         columnLines: false,
        //         rowLines : false,
        columns: fields["columns.1"],
        defaults: gridVals.defaultField,
        lockedGridConfig: {
          emptyText: '',
          collapsible: false,
          trackOver: false, // true,
          loadMask: false,
          striptRows: false,
          forceFit: false,
        },
        viewConfig: {
          itemId: 'FmlSelect',
          trackOver: false, // true,
          loadMask: true,
          striptRows: false, // true,
          preserveScrollOnReload: true,
          forceFit: true,
          //           listeners: {
          //             refresh: function (dataView) {
          //               Ext.each(dataView.panel.columns, function (column) {
          //                 if (column.dataIndex.indexOf('CHECKSMALLNAME') >= 0 || column.dataIndex.indexOf('CHECKMETHODTYPENAME') >= 0) {
          //                   column.autoSize();
          //                   column.width += 5;
          //                   if (column.width < 60) {
          //                     column.width = 60;
          //                   }
          //                 }
          //                 if (column.dataIndex.indexOf('CHECKSTANDARD') >= 0) {
          //                   column.autoSize();
          //                   column.width += 5;
          //                   if (column.width < 150) {
          //                     column.width = 150;
          //                   }
          //                 }
          //               });
          //             }
          //           },
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
            listeners: {
              "beforeedit": function (editor, ctx, eOpts) {
                var data = ctx.record;

                var params = {};
                var editDisableCols = [];

                var workstatus = data.data.WORKSTATUS;
                var checkqty = data.data.CHECKQTY * 1;

                // 작업상태에 따라 입력 항목 비활성화
                switch (workstatus) {
                case "COMPLETE":
                  editDisableCols.push("CHECKRESULT1");
                  editDisableCols.push("CHECKRESULT2");
                  editDisableCols.push("CHECKRESULT3");
                  editDisableCols.push("CHECKRESULT4");
                  editDisableCols.push("CHECKRESULT5");
                  editDisableCols.push("CHECKRESULT6");
                  editDisableCols.push("CHECKRESULT7");
                  editDisableCols.push("CHECKRESULT8");
                  editDisableCols.push("CHECKRESULT9");
                  editDisableCols.push("CHECKRESULT10");
                  editDisableCols.push("CHECKRESULT11");
                  editDisableCols.push("CHECKRESULT12");
                  editDisableCols.push("CHECKRESULT13");
                  editDisableCols.push("CHECKRESULT14");
                  editDisableCols.push("CHECKRESULT15");
                  editDisableCols.push("CHECKRESULT16");
                  editDisableCols.push("CHECKRESULT17");
                  editDisableCols.push("CHECKRESULT18");
                  editDisableCols.push("CHECKRESULT19");
                  editDisableCols.push("CHECKRESULT20");
                  editDisableCols.push("CHECKRESULT21");
                  editDisableCols.push("CHECKRESULT22");
                  editDisableCols.push("CHECKRESULT23");
                  editDisableCols.push("CHECKRESULT24");
                  editDisableCols.push("CHECKRESULT25");
                  editDisableCols.push("CHECKRESULT26");
                  editDisableCols.push("CHECKRESULT27");
                  editDisableCols.push("CHECKRESULT28");
                  editDisableCols.push("CHECKRESULT29");
                  editDisableCols.push("CHECKRESULT30");
                  editDisableCols.push("CHECKRESULT31");
                  editDisableCols.push("CHECKRESULT32");
                  editDisableCols.push("CHECKRESULT33");
                  editDisableCols.push("CHECKRESULT34");
                  editDisableCols.push("CHECKRESULT35");
                  editDisableCols.push("CHECKRESULT36");
                  editDisableCols.push("CHECKRESULT37");
                  editDisableCols.push("CHECKRESULT38");
                  editDisableCols.push("CHECKRESULT39");
                  editDisableCols.push("CHECKRESULT40");
                  editDisableCols.push("CHECKRESULT41");
                  editDisableCols.push("CHECKRESULT42");
                  editDisableCols.push("CHECKRESULT43");
                  editDisableCols.push("CHECKRESULT44");
                  editDisableCols.push("CHECKRESULT45");
                  editDisableCols.push("CHECKRESULT46");
                  editDisableCols.push("CHECKRESULT47");
                  editDisableCols.push("CHECKRESULT48");
                  editDisableCols.push("CHECKRESULT49");
                  editDisableCols.push("CHECKRESULT50");
                  editDisableCols.push("CHECKYNNAME");
                  editDisableCols.push("KRNAME");
                  break;
                default:
                  switch (checkqty) {
                  case 1:
                    editDisableCols.push("CHECKRESULT2");
                    editDisableCols.push("CHECKRESULT3");
                    editDisableCols.push("CHECKRESULT4");
                    editDisableCols.push("CHECKRESULT5");
                    editDisableCols.push("CHECKRESULT6");
                    editDisableCols.push("CHECKRESULT7");
                    editDisableCols.push("CHECKRESULT8");
                    editDisableCols.push("CHECKRESULT9");
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 2:
                    editDisableCols.push("CHECKRESULT3");
                    editDisableCols.push("CHECKRESULT4");
                    editDisableCols.push("CHECKRESULT5");
                    editDisableCols.push("CHECKRESULT6");
                    editDisableCols.push("CHECKRESULT7");
                    editDisableCols.push("CHECKRESULT8");
                    editDisableCols.push("CHECKRESULT9");
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 3:
                    editDisableCols.push("CHECKRESULT4");
                    editDisableCols.push("CHECKRESULT5");
                    editDisableCols.push("CHECKRESULT6");
                    editDisableCols.push("CHECKRESULT7");
                    editDisableCols.push("CHECKRESULT8");
                    editDisableCols.push("CHECKRESULT9");
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 4:
                    editDisableCols.push("CHECKRESULT5");
                    editDisableCols.push("CHECKRESULT6");
                    editDisableCols.push("CHECKRESULT7");
                    editDisableCols.push("CHECKRESULT8");
                    editDisableCols.push("CHECKRESULT9");
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 5:
                    editDisableCols.push("CHECKRESULT6");
                    editDisableCols.push("CHECKRESULT7");
                    editDisableCols.push("CHECKRESULT8");
                    editDisableCols.push("CHECKRESULT9");
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 6:
                    editDisableCols.push("CHECKRESULT7");
                    editDisableCols.push("CHECKRESULT8");
                    editDisableCols.push("CHECKRESULT9");
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 7:
                    editDisableCols.push("CHECKRESULT8");
                    editDisableCols.push("CHECKRESULT9");
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 8:
                    editDisableCols.push("CHECKRESULT9");
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 9:
                    editDisableCols.push("CHECKRESULT10");
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 10:
                    editDisableCols.push("CHECKRESULT11");
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 11:
                    editDisableCols.push("CHECKRESULT12");
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 12:
                    editDisableCols.push("CHECKRESULT13");
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 13:
                    editDisableCols.push("CHECKRESULT14");
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 14:
                    editDisableCols.push("CHECKRESULT15");
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 15:
                    editDisableCols.push("CHECKRESULT16");
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 16:
                    editDisableCols.push("CHECKRESULT17");
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 17:
                    editDisableCols.push("CHECKRESULT18");
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 18:
                    editDisableCols.push("CHECKRESULT19");
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 19:
                    editDisableCols.push("CHECKRESULT20");
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 20:
                    editDisableCols.push("CHECKRESULT21");
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 21:
                    editDisableCols.push("CHECKRESULT22");
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 22:
                    editDisableCols.push("CHECKRESULT23");
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 23:
                    editDisableCols.push("CHECKRESULT24");
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 24:
                    editDisableCols.push("CHECKRESULT25");
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 25:
                    editDisableCols.push("CHECKRESULT26");
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 26:
                    editDisableCols.push("CHECKRESULT27");
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 27:
                    editDisableCols.push("CHECKRESULT28");
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 28:
                    editDisableCols.push("CHECKRESULT29");
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 29:
                    editDisableCols.push("CHECKRESULT30");
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 30:
                    editDisableCols.push("CHECKRESULT31");
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 31:
                    editDisableCols.push("CHECKRESULT32");
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 32:
                    editDisableCols.push("CHECKRESULT33");
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 33:
                    editDisableCols.push("CHECKRESULT34");
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 34:
                    editDisableCols.push("CHECKRESULT35");
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 35:
                    editDisableCols.push("CHECKRESULT36");
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 36:
                    editDisableCols.push("CHECKRESULT37");
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 37:
                    editDisableCols.push("CHECKRESULT38");
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 38:
                    editDisableCols.push("CHECKRESULT39");
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 39:
                    editDisableCols.push("CHECKRESULT40");
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 40:
                    editDisableCols.push("CHECKRESULT41");
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 41:
                    editDisableCols.push("CHECKRESULT42");
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 42:
                    editDisableCols.push("CHECKRESULT43");
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 43:
                    editDisableCols.push("CHECKRESULT44");
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 44:
                    editDisableCols.push("CHECKRESULT45");
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 45:
                    editDisableCols.push("CHECKRESULT46");
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 46:
                    editDisableCols.push("CHECKRESULT47");
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 47:
                    editDisableCols.push("CHECKRESULT48");
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 48:
                    editDisableCols.push("CHECKRESULT49");
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  case 49:
                    editDisableCols.push("CHECKRESULT50");
                    break;
                  default:
                    break;
                  }
                  break;
                }

                var isNew = ctx.record.phantom || false;
                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                  return false;
                else {
                  return true;
                }
              },
              afterrender: function (panel) {
                setTimeout(function () {
                  panel.doLayout();
                }, 5);
              },
              beforerender: function (c) {
                var formFields = [];
                c.cascade(function (field) {
                  var xtypeChains = field.xtypesChain;

                  var isField = Ext.Array.findBy(xtypeChains, function (item) {

                      if (item == 'displayfield') {
                        return false;
                      }

                      if (item == 'field') {
                        return true;
                      }
                    });
                  if (isField) {
                    field.enableKeyEvents = true;
                    field.isShiftKeyPressed = false;
                    formFields.push(field);
                  }
                });

                for (var i = 0; i < formFields.length - 1; i++) {
                  var beforeField = (i == 0) ? null : formFields[i - 1];
                  var field = formFields[i];
                  var nextField = formFields[i + 1];

                  field.addListener('keyup', function (thisField, e) {
                    if (e.getKey() == e.SHIFT) {
                      thisField.isShiftKeyPressed = false;
                      return;
                    }
                  });

                  field.addListener('keydown', function (
                      thisField, e) {
                    if (e.getKey() == e.SHIFT) {
                      thisField.isShiftKeyPressed = true;
                      return;
                    }

                    if (thisField.isShiftKeyPressed == false && (e.getKey() == e.ENTER || e.getKey() == e.TAB)) { // tab 이나 enter 누름 다음 field 포커싱하도록함.
                      this.nextField.focus();
                      e.stopEvent();

                    } else if (thisField.isShiftKeyPressed == true && e.getKey() == e.TAB) {
                      if (this.beforeField != null) {
                        this.beforeField.focus();
                        e.stopEvent();
                      }
                    }
                  }, {
                    nextField: nextField,
                    beforeField: beforeField
                  });
                }
              }
            },
          }
        ],
        dockedItems: items["docked.1"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.list"],
    stores: gridnms["stores.list"],
    views: gridnms["views.list"],
    controllers: gridnms["controller.1"],

    launch: function () {
      gridarea1 = Ext.create(gridnms["views.list"], {
          renderTo: 'gridArea'
        });
    },
  });
}

function setExtGrid_popup1() {
  Ext.define(gridnms["model.14"], {
    extend: Ext.data.Model,
    fields: fields["model.14"],
  });

  Ext.define(gridnms["store.14"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.14"],
            model: gridnms["model.14"],
            autoLoad: true,
            pageSize: 999999,
            proxy: {
              type: 'ajax',
              api: items["api.14"],
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.14"], {
    extend: Ext.app.Controller,
    refs: {
      CheckResultListPopup: '#CheckResultListPopup',
    },
    stores: [gridnms["store.14"]],
  });

  Ext.define(gridnms["panel.14"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.14"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'cellmodel',
        itemId: gridnms["panel.14"],
        id: gridnms["panel.14"],
        store: gridnms["store.14"],
        height: 805,
        border: 2,
        scrollable: true,
        plugins: [{
            ptype: 'bufferedrenderer',
            trailingBufferZone: 20, // #1
            leadingBufferZone: 20, // #2
            synchronousRender: false,
            numFromEdge: 19,
          }
        ],
        columns: fields["columns.14"],
        viewConfig: {
          itemId: 'CheckResultListPopup',
          trackOver: true,
          loadMask: true,
        },
        dockedItems: items["docked.14"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.popup1"],
    stores: gridnms["stores.popup1"],
    views: gridnms["views.popup1"],
    controllers: gridnms["controller.14"],

    launch: function () {
      gridarea14 = Ext.create(gridnms["views.popup1"], {
          renderTo: 'gridPopup1Area'
        });
    },
  });
}

function setExtGrid_popup2() {
  Ext.define(gridnms["model.15"], {
    extend: Ext.data.Model,
    fields: fields["model.15"],
  });

  Ext.define(gridnms["store.15"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.15"],
            model: gridnms["model.15"],
            autoLoad: true,
            pageSize: 999999,
            proxy: {
              type: 'ajax',
              api: items["api.15"],
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.15"], {
    extend: Ext.app.Controller,
    refs: {
      CheckResultListPopup2: '#CheckResultListPopup2',
    },
    stores: [gridnms["store.15"]],
  });

  Ext.define(gridnms["panel.15"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.15"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'cellmodel',
        itemId: gridnms["panel.15"],
        id: gridnms["panel.15"],
        store: gridnms["store.15"],
        height: 305,
        border: 2,
        scrollable: true,
        plugins: [{
            ptype: 'bufferedrenderer',
            trailingBufferZone: 20, // #1
            leadingBufferZone: 20, // #2
            synchronousRender: false,
            numFromEdge: 19,
          }
        ],
        columns: fields["columns.15"],
        viewConfig: {
          itemId: 'CheckResultListPopup2',
          trackOver: true,
          loadMask: true,
        },
        dockedItems: items["docked.15"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.popup2"],
    stores: gridnms["stores.popup2"],
    views: gridnms["views.popup2"],
    controllers: gridnms["controller.15"],

    launch: function () {
      gridarea15 = Ext.create(gridnms["views.popup2"], {
          renderTo: 'gridPopup2Area'
        });
    },
  });
}

var popcount14 = 0, popupclick14 = 0;
function btnSel14() {
  // 결과조회 불러오기 팝업
  var width = 1873; // 가로
  var height = 840; // 세로
  var title = "결과조회 불러오기 Popup";

  var check = true;
  popupclick14 = 0;

  if (check == true) {
    //     Ext.getStore(gridnms["store.14"]).removeAll();

    win14 = Ext.create('Ext.window.Window', {
        width: width,
        height: height,
        title: title,
        layout: 'fit',
        header: true,
        draggable: true,
        resizable: false,
        maximizable: false,
        closeAction: 'hide',
        modal: true,
        closable: true,
        buttonAlign: 'center',
        items: [{
            xtype: 'gridpanel',
            selType: 'cellmodel',
            itemId: gridnms["panel.14"],
            id: gridnms["panel.14"],
            store: gridnms["store.14"],
            height: '100%',
            border: 2,
            scrollable: true,
            frameHeader: true,
            columns: fields["columns.14"],
            viewConfig: {
              itemId: 'CheckResultListPopup',
              trackOver: true,
              loadMask: true,
            },
            plugins: [{
                ptype: 'bufferedrenderer',
                trailingBufferZone: 20, // #1
                leadingBufferZone: 20, // #2
                synchronousRender: false,
                numFromEdge: 19,
              }
            ],
            dockedItems: items["docked.14"],
          }
        ],
        listeners: {
          render: function (c) {
            c.header.on('click', function () {

              win14.close();

              $("#gridPopup1Area").hide("blind", {
                direction: "up"
              }, "fast");
            });
          },
        },
      });

    win14.show();

    var sparams3 = {
      ORGID: '${searchVO.ORGID}',
      COMPANYID: '${searchVO.COMPANYID}',
      WORKORDERID: '${searchVO.WORKORDERID}',
      WORKORDERSEQ: '${searchVO.WORKORDERSEQ}',
      FMLTYPE: '${FMLTYPE}',
      FMLID: '${searchVO.FMLID}',
      TYPE: $('#type').val(),
    };

    extGridSearch(sparams3, gridnms["store.14"]);
  }
}

var popcount15 = 0, popupclick15 = 0;
function btnSel15() {
  // QC조회 불러오기 팝업
  var width = 1105; // 가로
  var height = 340; // 세로
  var title = "QC조회 불러오기 Popup";

  var check = true;
  popupclick15 = 0;

  if (check == true) {
    //     Ext.getStore(gridnms["store.15"]).removeAll();

    win15 = Ext.create('Ext.window.Window', {
        width: width,
        height: height,
        title: title,
        layout: 'fit',
        header: true,
        draggable: true,
        resizable: false,
        maximizable: false,
        closeAction: 'hide',
        modal: true,
        closable: true,
        buttonAlign: 'center',
        items: [{
            xtype: 'gridpanel',
            selType: 'cellmodel',
            itemId: gridnms["panel.15"],
            id: gridnms["panel.15"],
            store: gridnms["store.15"],
            height: '100%',
            border: 2,
            scrollable: true,
            frameHeader: true,
            columns: fields["columns.15"],
            viewConfig: {
              itemId: 'CheckResultListPopup2',
              trackOver: true,
              loadMask: true,
            },
            plugins: [{
                ptype: 'bufferedrenderer',
                trailingBufferZone: 20, // #1
                leadingBufferZone: 20, // #2
                synchronousRender: false,
                numFromEdge: 19,
              }
            ],
            dockedItems: items["docked.15"],
          }
        ],
        listeners: {
          render: function (c) {
            c.header.on('click', function () {

              win15.close();

              $("#gridPopup2Area").hide("blind", {
                direction: "up"
              }, "fast");
            });
          },
        },
      });

    win15.show();

    var sparams3 = {
      ORGID: '${searchVO.ORGID}',
      COMPANYID: '${searchVO.COMPANYID}',
      WORKORDERID: '${searchVO.WORKORDERID}',
      WORKORDERSEQ: '${searchVO.WORKORDERSEQ}',
      //       FMLTYPE: 'H',
      FMLID: '${searchVO.FMLID}',
      TYPE: $('#type').val(),
    };

    extGridSearch(sparams3, gridnms["store.15"]);
  }
}

function fn_validation16() {
  var result = true;
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var itemcode = $('#itemcode').val();
  var workorderid = $('#workorderid').val();
  var workorderseq = $('#workorderseq').val();
  var fmlid = $('#fmlid').val();
  var orderno = $('#orderno').val();
  var header = [],
  count = 0;

  if (isNaN(orgid)) {
    header.push("사업장");
    count++;
  }

  if (isNaN(companyid)) {
    header.push("공장");
    count++;
  }

  if (itemcode === "") {
    header.push("품번/품명");
    count++;
  }

  if (workorderid === "") {
    header.push("작업지시");
    count++;
  }

  if (workorderseq === "") {
    header.push("작업지시내역");
    count++;
  }

  if (fmlid === "") {
    header.push("자주검사");
    count++;
  }

  if (orderno === "") {
    header.push("자주검사내역");
    count++;
  }

  if (count > 0) {
    extToastView("[검사내역 미선택]<br/>" + header + " 항목을 선택해주세요.");
    result = false;
  }

  return result;
}

var popcount16 = 0, popupclick16 = 0;
function btnSel16(flag) {
  if (!fn_validation16()) {
    return;
  }
  // 검사시간 조회
  var width = 1776;
  var height = 720;
  var title = (flag == "now") ? "작업자 검사시간 조회 Popup" : "이전 작업자 검사시간 조회 Popup";
  var url = '<c:url value="/select/prod/order/WorkHistoryList.do"/>';
  var params = {};
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var itemcode = $('#itemcode').val();
  var workorderid = $('#workorderid').val();
  var workorderseq = $('#workorderseq').val();
  var fmlid = $('#fmlid').val();
  var orderno = $('#orderno').val();
  var checklistid = $('#checklistid').val();

  params = {
    ORGID: orgid,
    COMPANYID: companyid,
    ITEMCODE: itemcode,
    WORKORDERID: workorderid,
    WORKORDERSEQ: workorderseq,
    FMLID: fmlid,
    ORDERNO: orderno,
    CHECKLISTID: checklistid,
    GUBUN: (flag == "now") ? "FMLREGIST" : "PREFMLREGIST",
  };

  $.ajax({
    url: url,
    type: 'post',
    async: false,
    data: params,
    success: function (data) {
      //            비동기화 호출 순서로 인하여 success 펑션 사용안함.(done 펑션으로 대체)
    }
  }).done(function (data) {
    //          호출 성공시
    var totcnt = data.totcnt;

    if (totcnt > 0) {
      var record = data.data[0];
      var checkresult1 = (record.CHECKRESULT1 === null) ? "" : record.CHECKRESULT1;
      var checkresult2 = (record.CHECKRESULT2 === null) ? "" : record.CHECKRESULT2;
      var checkresult3 = (record.CHECKRESULT3 === null) ? "" : record.CHECKRESULT3;
      var checkresult4 = (record.CHECKRESULT4 === null) ? "" : record.CHECKRESULT4;
      var checkresult5 = (record.CHECKRESULT5 === null) ? "" : record.CHECKRESULT5;
      var checkresult6 = (record.CHECKRESULT6 === null) ? "" : record.CHECKRESULT6;
      var checkresult7 = (record.CHECKRESULT7 === null) ? "" : record.CHECKRESULT7;
      var checkresult8 = (record.CHECKRESULT8 === null) ? "" : record.CHECKRESULT8;
      var checkresult9 = (record.CHECKRESULT9 === null) ? "" : record.CHECKRESULT9;
      var checkresult10 = (record.CHECKRESULT10 === null) ? "" : record.CHECKRESULT10;
      var checkresult11 = (record.CHECKRESULT11 === null) ? "" : record.CHECKRESULT11;
      var checkresult12 = (record.CHECKRESULT12 === null) ? "" : record.CHECKRESULT12;
      var checkresult13 = (record.CHECKRESULT13 === null) ? "" : record.CHECKRESULT13;
      var checkresult14 = (record.CHECKRESULT14 === null) ? "" : record.CHECKRESULT14;
      var checkresult15 = (record.CHECKRESULT15 === null) ? "" : record.CHECKRESULT15;
      var checkresult16 = (record.CHECKRESULT16 === null) ? "" : record.CHECKRESULT16;
      var checkresult17 = (record.CHECKRESULT17 === null) ? "" : record.CHECKRESULT17;
      var checkresult18 = (record.CHECKRESULT18 === null) ? "" : record.CHECKRESULT18;
      var checkresult19 = (record.CHECKRESULT19 === null) ? "" : record.CHECKRESULT19;
      var checkresult20 = (record.CHECKRESULT20 === null) ? "" : record.CHECKRESULT20;
      var checkresult21 = (record.CHECKRESULT21 === null) ? "" : record.CHECKRESULT21;
      var checkresult22 = (record.CHECKRESULT22 === null) ? "" : record.CHECKRESULT22;
      var checkresult23 = (record.CHECKRESULT23 === null) ? "" : record.CHECKRESULT23;
      var checkresult24 = (record.CHECKRESULT24 === null) ? "" : record.CHECKRESULT24;
      var checkresult25 = (record.CHECKRESULT25 === null) ? "" : record.CHECKRESULT25;
      var checkresult26 = (record.CHECKRESULT26 === null) ? "" : record.CHECKRESULT26;
      var checkresult27 = (record.CHECKRESULT27 === null) ? "" : record.CHECKRESULT27;
      var checkresult28 = (record.CHECKRESULT28 === null) ? "" : record.CHECKRESULT28;
      var checkresult29 = (record.CHECKRESULT29 === null) ? "" : record.CHECKRESULT29;
      var checkresult30 = (record.CHECKRESULT30 === null) ? "" : record.CHECKRESULT30;
      var checkresult31 = (record.CHECKRESULT31 === null) ? "" : record.CHECKRESULT31;
      var checkresult32 = (record.CHECKRESULT32 === null) ? "" : record.CHECKRESULT32;
      var checkresult33 = (record.CHECKRESULT33 === null) ? "" : record.CHECKRESULT33;
      var checkresult34 = (record.CHECKRESULT34 === null) ? "" : record.CHECKRESULT34;
      var checkresult35 = (record.CHECKRESULT35 === null) ? "" : record.CHECKRESULT35;
      var checkresult36 = (record.CHECKRESULT36 === null) ? "" : record.CHECKRESULT36;
      var checkresult37 = (record.CHECKRESULT37 === null) ? "" : record.CHECKRESULT37;
      var checkresult38 = (record.CHECKRESULT38 === null) ? "" : record.CHECKRESULT38;
      var checkresult39 = (record.CHECKRESULT39 === null) ? "" : record.CHECKRESULT39;
      var checkresult40 = (record.CHECKRESULT40 === null) ? "" : record.CHECKRESULT40;
      var checkresult41 = (record.CHECKRESULT41 === null) ? "" : record.CHECKRESULT41;
      var checkresult42 = (record.CHECKRESULT42 === null) ? "" : record.CHECKRESULT42;
      var checkresult43 = (record.CHECKRESULT43 === null) ? "" : record.CHECKRESULT43;
      var checkresult44 = (record.CHECKRESULT44 === null) ? "" : record.CHECKRESULT44;
      var checkresult45 = (record.CHECKRESULT45 === null) ? "" : record.CHECKRESULT45;
      var checkresult46 = (record.CHECKRESULT46 === null) ? "" : record.CHECKRESULT46;
      var checkresult47 = (record.CHECKRESULT47 === null) ? "" : record.CHECKRESULT47;
      var checkresult48 = (record.CHECKRESULT48 === null) ? "" : record.CHECKRESULT48;
      var checkresult49 = (record.CHECKRESULT49 === null) ? "" : record.CHECKRESULT49;
      var checkresult50 = (record.CHECKRESULT50 === null) ? "" : record.CHECKRESULT50;
      var checkresultng1 = (record.CHECKRESULTNG1 === null) ? "" : " ( " + record.CHECKRESULTNG1 + " )";
      var checkresultng2 = (record.CHECKRESULTNG2 === null) ? "" : " ( " + record.CHECKRESULTNG2 + " )";
      var checkresultng3 = (record.CHECKRESULTNG3 === null) ? "" : " ( " + record.CHECKRESULTNG3 + " )";
      var checkresultng4 = (record.CHECKRESULTNG4 === null) ? "" : " ( " + record.CHECKRESULTNG4 + " )";
      var checkresultng5 = (record.CHECKRESULTNG5 === null) ? "" : " ( " + record.CHECKRESULTNG5 + " )";
      var checkresultng6 = (record.CHECKRESULTNG6 === null) ? "" : " ( " + record.CHECKRESULTNG6 + " )";
      var checkresultng7 = (record.CHECKRESULTNG7 === null) ? "" : " ( " + record.CHECKRESULTNG7 + " )";
      var checkresultng8 = (record.CHECKRESULTNG8 === null) ? "" : " ( " + record.CHECKRESULTNG8 + " )";
      var checkresultng9 = (record.CHECKRESULTNG9 === null) ? "" : " ( " + record.CHECKRESULTNG9 + " )";
      var checkresultng10 = (record.CHECKRESULTNG10 === null) ? "" : " ( " + record.CHECKRESULTNG10 + " )";
      var checkresultng11 = (record.CHECKRESULTNG11 === null) ? "" : " ( " + record.CHECKRESULTNG11 + " )";
      var checkresultng12 = (record.CHECKRESULTNG12 === null) ? "" : " ( " + record.CHECKRESULTNG12 + " )";
      var checkresultng13 = (record.CHECKRESULTNG13 === null) ? "" : " ( " + record.CHECKRESULTNG13 + " )";
      var checkresultng14 = (record.CHECKRESULTNG14 === null) ? "" : " ( " + record.CHECKRESULTNG14 + " )";
      var checkresultng15 = (record.CHECKRESULTNG15 === null) ? "" : " ( " + record.CHECKRESULTNG15 + " )";
      var checkresultng16 = (record.CHECKRESULTNG16 === null) ? "" : " ( " + record.CHECKRESULTNG16 + " )";
      var checkresultng17 = (record.CHECKRESULTNG17 === null) ? "" : " ( " + record.CHECKRESULTNG17 + " )";
      var checkresultng18 = (record.CHECKRESULTNG18 === null) ? "" : " ( " + record.CHECKRESULTNG18 + " )";
      var checkresultng19 = (record.CHECKRESULTNG19 === null) ? "" : " ( " + record.CHECKRESULTNG19 + " )";
      var checkresultng20 = (record.CHECKRESULTNG20 === null) ? "" : " ( " + record.CHECKRESULTNG20 + " )";
      var checkresultng21 = (record.CHECKRESULTNG21 === null) ? "" : " ( " + record.CHECKRESULTNG21 + " )";
      var checkresultng22 = (record.CHECKRESULTNG22 === null) ? "" : " ( " + record.CHECKRESULTNG22 + " )";
      var checkresultng23 = (record.CHECKRESULTNG23 === null) ? "" : " ( " + record.CHECKRESULTNG23 + " )";
      var checkresultng24 = (record.CHECKRESULTNG24 === null) ? "" : " ( " + record.CHECKRESULTNG24 + " )";
      var checkresultng25 = (record.CHECKRESULTNG25 === null) ? "" : " ( " + record.CHECKRESULTNG25 + " )";
      var checkresultng26 = (record.CHECKRESULTNG26 === null) ? "" : " ( " + record.CHECKRESULTNG26 + " )";
      var checkresultng27 = (record.CHECKRESULTNG27 === null) ? "" : " ( " + record.CHECKRESULTNG27 + " )";
      var checkresultng28 = (record.CHECKRESULTNG28 === null) ? "" : " ( " + record.CHECKRESULTNG28 + " )";
      var checkresultng29 = (record.CHECKRESULTNG29 === null) ? "" : " ( " + record.CHECKRESULTNG29 + " )";
      var checkresultng30 = (record.CHECKRESULTNG30 === null) ? "" : " ( " + record.CHECKRESULTNG30 + " )";
      var checkresultng31 = (record.CHECKRESULTNG31 === null) ? "" : " ( " + record.CHECKRESULTNG31 + " )";
      var checkresultng32 = (record.CHECKRESULTNG32 === null) ? "" : " ( " + record.CHECKRESULTNG32 + " )";
      var checkresultng33 = (record.CHECKRESULTNG33 === null) ? "" : " ( " + record.CHECKRESULTNG33 + " )";
      var checkresultng34 = (record.CHECKRESULTNG34 === null) ? "" : " ( " + record.CHECKRESULTNG34 + " )";
      var checkresultng35 = (record.CHECKRESULTNG35 === null) ? "" : " ( " + record.CHECKRESULTNG35 + " )";
      var checkresultng36 = (record.CHECKRESULTNG36 === null) ? "" : " ( " + record.CHECKRESULTNG36 + " )";
      var checkresultng37 = (record.CHECKRESULTNG37 === null) ? "" : " ( " + record.CHECKRESULTNG37 + " )";
      var checkresultng38 = (record.CHECKRESULTNG38 === null) ? "" : " ( " + record.CHECKRESULTNG38 + " )";
      var checkresultng39 = (record.CHECKRESULTNG39 === null) ? "" : " ( " + record.CHECKRESULTNG39 + " )";
      var checkresultng40 = (record.CHECKRESULTNG40 === null) ? "" : " ( " + record.CHECKRESULTNG40 + " )";
      var checkresultng41 = (record.CHECKRESULTNG41 === null) ? "" : " ( " + record.CHECKRESULTNG41 + " )";
      var checkresultng42 = (record.CHECKRESULTNG42 === null) ? "" : " ( " + record.CHECKRESULTNG42 + " )";
      var checkresultng43 = (record.CHECKRESULTNG43 === null) ? "" : " ( " + record.CHECKRESULTNG43 + " )";
      var checkresultng44 = (record.CHECKRESULTNG44 === null) ? "" : " ( " + record.CHECKRESULTNG44 + " )";
      var checkresultng45 = (record.CHECKRESULTNG45 === null) ? "" : " ( " + record.CHECKRESULTNG45 + " )";
      var checkresultng46 = (record.CHECKRESULTNG46 === null) ? "" : " ( " + record.CHECKRESULTNG46 + " )";
      var checkresultng47 = (record.CHECKRESULTNG47 === null) ? "" : " ( " + record.CHECKRESULTNG47 + " )";
      var checkresultng48 = (record.CHECKRESULTNG48 === null) ? "" : " ( " + record.CHECKRESULTNG48 + " )";
      var checkresultng49 = (record.CHECKRESULTNG49 === null) ? "" : " ( " + record.CHECKRESULTNG49 + " )";
      var checkresultng50 = (record.CHECKRESULTNG50 === null) ? "" : " ( " + record.CHECKRESULTNG50 + " )";
      var checktime1 = (record.CHECKTIME1 === null) ? "" : record.CHECKTIME1;
      var checktime2 = (record.CHECKTIME2 === null) ? "" : record.CHECKTIME2;
      var checktime3 = (record.CHECKTIME3 === null) ? "" : record.CHECKTIME3;
      var checktime4 = (record.CHECKTIME4 === null) ? "" : record.CHECKTIME4;
      var checktime5 = (record.CHECKTIME5 === null) ? "" : record.CHECKTIME5;
      var checktime6 = (record.CHECKTIME6 === null) ? "" : record.CHECKTIME6;
      var checktime7 = (record.CHECKTIME7 === null) ? "" : record.CHECKTIME7;
      var checktime8 = (record.CHECKTIME8 === null) ? "" : record.CHECKTIME8;
      var checktime9 = (record.CHECKTIME9 === null) ? "" : record.CHECKTIME9;
      var checktime10 = (record.CHECKTIME10 === null) ? "" : record.CHECKTIME10;
      var checktime11 = (record.CHECKTIME11 === null) ? "" : record.CHECKTIME11;
      var checktime12 = (record.CHECKTIME12 === null) ? "" : record.CHECKTIME12;
      var checktime13 = (record.CHECKTIME13 === null) ? "" : record.CHECKTIME13;
      var checktime14 = (record.CHECKTIME14 === null) ? "" : record.CHECKTIME14;
      var checktime15 = (record.CHECKTIME15 === null) ? "" : record.CHECKTIME15;
      var checktime16 = (record.CHECKTIME16 === null) ? "" : record.CHECKTIME16;
      var checktime17 = (record.CHECKTIME17 === null) ? "" : record.CHECKTIME17;
      var checktime18 = (record.CHECKTIME18 === null) ? "" : record.CHECKTIME18;
      var checktime19 = (record.CHECKTIME19 === null) ? "" : record.CHECKTIME19;
      var checktime20 = (record.CHECKTIME20 === null) ? "" : record.CHECKTIME20;
      var checktime21 = (record.CHECKTIME21 === null) ? "" : record.CHECKTIME21;
      var checktime22 = (record.CHECKTIME22 === null) ? "" : record.CHECKTIME22;
      var checktime23 = (record.CHECKTIME23 === null) ? "" : record.CHECKTIME23;
      var checktime24 = (record.CHECKTIME24 === null) ? "" : record.CHECKTIME24;
      var checktime25 = (record.CHECKTIME25 === null) ? "" : record.CHECKTIME25;
      var checktime26 = (record.CHECKTIME26 === null) ? "" : record.CHECKTIME26;
      var checktime27 = (record.CHECKTIME27 === null) ? "" : record.CHECKTIME27;
      var checktime28 = (record.CHECKTIME28 === null) ? "" : record.CHECKTIME28;
      var checktime29 = (record.CHECKTIME29 === null) ? "" : record.CHECKTIME29;
      var checktime30 = (record.CHECKTIME30 === null) ? "" : record.CHECKTIME30;
      var checktime31 = (record.CHECKTIME31 === null) ? "" : record.CHECKTIME31;
      var checktime32 = (record.CHECKTIME32 === null) ? "" : record.CHECKTIME32;
      var checktime33 = (record.CHECKTIME33 === null) ? "" : record.CHECKTIME33;
      var checktime34 = (record.CHECKTIME34 === null) ? "" : record.CHECKTIME34;
      var checktime35 = (record.CHECKTIME35 === null) ? "" : record.CHECKTIME35;
      var checktime36 = (record.CHECKTIME36 === null) ? "" : record.CHECKTIME36;
      var checktime37 = (record.CHECKTIME37 === null) ? "" : record.CHECKTIME37;
      var checktime38 = (record.CHECKTIME38 === null) ? "" : record.CHECKTIME38;
      var checktime39 = (record.CHECKTIME39 === null) ? "" : record.CHECKTIME39;
      var checktime40 = (record.CHECKTIME40 === null) ? "" : record.CHECKTIME40;
      var checktime41 = (record.CHECKTIME41 === null) ? "" : record.CHECKTIME41;
      var checktime42 = (record.CHECKTIME42 === null) ? "" : record.CHECKTIME42;
      var checktime43 = (record.CHECKTIME43 === null) ? "" : record.CHECKTIME43;
      var checktime44 = (record.CHECKTIME44 === null) ? "" : record.CHECKTIME44;
      var checktime45 = (record.CHECKTIME45 === null) ? "" : record.CHECKTIME45;
      var checktime46 = (record.CHECKTIME46 === null) ? "" : record.CHECKTIME46;
      var checktime47 = (record.CHECKTIME47 === null) ? "" : record.CHECKTIME47;
      var checktime48 = (record.CHECKTIME48 === null) ? "" : record.CHECKTIME48;
      var checktime49 = (record.CHECKTIME49 === null) ? "" : record.CHECKTIME49;
      var checktime50 = (record.CHECKTIME50 === null) ? "" : record.CHECKTIME50;

      var check = true;
      popupclick16 = 0;

      if (check == true) {
        win16 = Ext.create('Ext.window.Window', {
            autoShow: true,
            width: width,
            height: height,
            title: title,
            html: '<table class="ResultTable" cellpadding="0" cellspacing="0" border="1" width="100%" style="padding-top:0px;  float: left; ">' +
            '<colgroup>' +
            '<col>' +
            '<col>' +
            '<col>' +
            '<col>' +
            '<col>' +
            '<col>' +
            '<col>' +
            '<col>' +
            '<col>' +
            '<col>' +
            '</colgroup>' +
            '<tbody>' +
            '<tr style="height: 40px;">' +
            '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '품번' +
            '</th>' +
            '<td colspan="2" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '<label id="ordername" name="ordername" style="font-size: 22px; color: black; font-weight: bold;">' +
            '<span>' + record.ORDERNAME + '</span>' +
            '</label>' +
            '</td>' +
            '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '품명' +
            '</th>' +
            '<td colspan="6" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '<label id="itemname" name="itemname" style="font-size: 22px; color: black; font-weight: bold;">' +
            '<span>' + record.ITEMNAME + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px;">' +
            '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '검사구분' +
            '</th>' +
            '<td colspan="2" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '<label id="checkbigname" name="checkbigname" style="font-size: 22px; color: black; font-weight: bold;">' +
            '<span>' + record.CHECKBIGNAME + '</span>' +
            '</label>' +
            '</td>' +
            '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '검사내용' +
            '</th>' +
            '<td colspan="2" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '<label id="checkstandard" name="checkstandard" style="font-size: 22px; color: black; font-weight: bold;">' +
            '<span>' + record.CHECKSTANDARD + '</span>' +
            '</label>' +
            '</td>' +
            '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '검사일자' +
            '</th>' +
            '<td class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '<label id="checkdate" name="checkdate" style="font-size: 22px; color: black; font-weight: bold;">' +
            '<span>' + Ext.util.Format.date(record.CHECKDATE, 'Y-m-d') + '</span>' +
            '</label>' +
            '</td>' +
            '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '검사수량' +
            '</th>' +
            '<td class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            '<label id="totalqty" name="totalqty" style="font-size: 22px; color: black; font-weight: bold;">' +
            '<span>' + Ext.util.Format.number(record.TOTALQTY, '0,000') + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px;">' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X1' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X2' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X3' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X4' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X5' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X6' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X7' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X8' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X9' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X10' +
            '</th>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult1 + checkresultng1 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult2 + checkresultng2 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult3 + checkresultng3 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult4 + checkresultng4 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult5 + checkresultng5 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult6 + checkresultng6 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult7 + checkresultng7 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult8 + checkresultng8 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult9 + checkresultng9 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult10 + checkresultng10 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime1 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime2 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime3 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime4 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime5 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime6 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime7 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime8 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime9 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime10 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px;">' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X11' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X12' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X13' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X14' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X15' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X16' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X17' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X18' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X19' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X20' +
            '</th>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult11 + checkresultng11 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult12 + checkresultng12 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult13 + checkresultng13 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult14 + checkresultng14 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult15 + checkresultng15 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult16 + checkresultng16 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult17 + checkresultng17 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult18 + checkresultng18 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult19 + checkresultng19 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult20 + checkresultng20 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime11 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime12 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime13 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime14 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime15 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime16 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime17 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime18 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime19 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime20 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px;">' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X21' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X22' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X23' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X24' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X25' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X26' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X27' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X28' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X29' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X30' +
            '</th>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult21 + checkresultng21 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult22 + checkresultng22 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult23 + checkresultng23 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult24 + checkresultng24 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult25 + checkresultng25 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult26 + checkresultng26 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult27 + checkresultng27 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult28 + checkresultng28 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult29 + checkresultng29 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult30 + checkresultng30 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime21 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime22 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime23 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime24 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime25 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime26 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime27 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime28 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime29 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime30 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px;">' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X31' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X32' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X33' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X34' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X35' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X36' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X37' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X38' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X39' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X40' +
            '</th>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult31 + checkresultng31 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult32 + checkresultng32 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult33 + checkresultng33 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult34 + checkresultng34 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult35 + checkresultng35 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult36 + checkresultng36 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult37 + checkresultng37 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult38 + checkresultng38 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult39 + checkresultng39 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult40 + checkresultng40 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime31 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime32 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime33 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime34 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime35 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime36 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime37 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime38 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime39 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime40 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px;">' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X41' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X42' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X43' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X44' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X45' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X46' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X47' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X48' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X49' +
            '</th>' +
            '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
            'X50' +
            '</th>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult41 + checkresultng41 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult42 + checkresultng42 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult43 + checkresultng43 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult44 + checkresultng44 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult45 + checkresultng45 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult46 + checkresultng46 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult47 + checkresultng47 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult48 + checkresultng48 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult49 + checkresultng49 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checkresult50 + checkresultng50 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime41 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime42 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime43 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime44 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime45 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime46 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime47 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime48 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime49 + '</span>' +
            '</label>' +
            '</td>' +
            '<td>' +
            '<label style="font-size: 22px; color: black; font-weight: bold; ">' +
            '<span>' + checktime50 + '</span>' +
            '</label>' +
            '</td>' +
            '</tr>' +
            '</tbody>' +
            '</table>',
            draggable: true,
            resizable: false,
            maximizable: false,
            closeAction: 'destroy',
            modal: true,
            listeners: {
              render: function (c) {
                c.header.on('click', function () {

                  win16.close();
                });
              },
            },
          });

        win16.show();
      }
    } else {
      extToastView("[" + title + "]<br/>" + " 데이터가 없습니다.");
    }
  });
}

function fn_push_list(X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12,
  X13, X14, X15, X16, X17, X18, X19, X20, X21, X22, X23, X24, X25,
  X26, X27, X28, X29, X30, X31, X32, X33, X34, X35, X36, X37, X38,
  X39, X40, X41, X42, X43, X44, X45, X46, X47, X48, X49, X50, qty) {
  // 리스트 생성
  var list = [];
  switch (qty) {
  case 1:
    list.push(X1);
    break;
  case 2:
    list.push(X1);
    list.push(X2);
    break;
  case 3:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    break;
  case 4:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    break;
  case 5:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    break;
  case 6:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    break;
  case 7:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    break;
  case 8:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    break;
  case 9:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    break;
  case 10:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    break;
  case 11:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    break;
  case 12:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    break;
  case 13:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    break;
  case 14:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    break;
  case 15:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    break;
  case 16:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    break;
  case 17:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    break;
  case 18:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    break;
  case 19:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    break;
  case 20:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    break;
  case 21:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    break;
  case 22:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    break;
  case 23:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    break;
  case 24:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    break;
  case 25:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    break;
  case 26:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    break;
  case 27:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    break;
  case 28:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    break;
  case 29:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    break;
  case 30:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    break;
  case 31:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    break;
  case 32:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    break;
  case 33:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    break;
  case 34:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    break;
  case 35:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    break;
  case 36:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    break;
  case 37:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    break;
  case 38:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    break;
  case 39:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    break;
  case 40:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    break;
  case 41:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    break;
  case 42:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    break;
  case 43:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    list.push(X43);
    break;
  case 44:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    list.push(X43);
    list.push(X44);
    break;
  case 45:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    list.push(X43);
    list.push(X44);
    list.push(X45);
    break;
  case 46:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    list.push(X43);
    list.push(X44);
    list.push(X45);
    list.push(X46);
    break;
  case 47:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    list.push(X43);
    list.push(X44);
    list.push(X45);
    list.push(X46);
    list.push(X47);
    break;
  case 48:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    list.push(X43);
    list.push(X44);
    list.push(X45);
    list.push(X46);
    list.push(X47);
    list.push(X48);
    break;
  case 49:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    list.push(X43);
    list.push(X44);
    list.push(X45);
    list.push(X46);
    list.push(X47);
    list.push(X48);
    list.push(X49);
    break;
  case 50:
    list.push(X1);
    list.push(X2);
    list.push(X3);
    list.push(X4);
    list.push(X5);
    list.push(X6);
    list.push(X7);
    list.push(X8);
    list.push(X9);
    list.push(X10);
    list.push(X11);
    list.push(X12);
    list.push(X13);
    list.push(X14);
    list.push(X15);
    list.push(X16);
    list.push(X17);
    list.push(X18);
    list.push(X19);
    list.push(X20);
    list.push(X21);
    list.push(X22);
    list.push(X23);
    list.push(X24);
    list.push(X25);
    list.push(X26);
    list.push(X27);
    list.push(X28);
    list.push(X29);
    list.push(X30);
    list.push(X31);
    list.push(X32);
    list.push(X33);
    list.push(X34);
    list.push(X35);
    list.push(X36);
    list.push(X37);
    list.push(X38);
    list.push(X39);
    list.push(X40);
    list.push(X41);
    list.push(X42);
    list.push(X43);
    list.push(X44);
    list.push(X45);
    list.push(X46);
    list.push(X47);
    list.push(X48);
    list.push(X49);
    list.push(X50);
    break;
  default:
    break;
  }
  return list;
}

function fn_defact_check(list, num, max, min, svalue) {
  // 합/불 판정
  var result = true,
  isCheck = false,
  count = 0;
  var max_num = max * 1;
  var min_num = min * 1;
  for (var i = 0; i < num; i++) {
    var value = list[i];
    // 입력된 값이 아니면 패스
    if (value.length > 0) {
      if (svalue == "") {
        if (value == "OK") {
          // 합격
          isCheck = true;
        } else if (value == "NG") {
          // 불합격
          isCheck = false;
        }
      } else {
        var value_num = value * 1;
        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
        if (regexp.test(value)) {
          // 합격
          if (min_num > value_num) {
            isCheck = false;
          } else {
            if (value_num > max_num) {
              isCheck = false;
            } else {
              isCheck = true;
            }
          }
        } else {
          // 불합격
          isCheck = false;
        }
      }

      // 불합격 판정 받았을 경우에만 불합격 처리되도록
      if (isCheck == false) {
        result = false;
      }
      count++;
    } else {
      // 2016.03.14 검사값 입력시 불합격 표시부분 주석 처리
      //             result = true;
    }
  }

  return result;
}

function setcolor(x) {
  // 불합격 판정시 글자 깜빡임 스크립터
  var count = 1;
  if (x == 'x1') {
    setInterval(function () {
      if (count == 1) {
        $('.x1').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x1').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x2') {
    setInterval(function () {
      if (count == 1) {
        $('.x2').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x2').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x3') {
    setInterval(function () {
      if (count == 1) {
        $('.x3').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x3').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x4') {
    setInterval(function () {
      if (count == 1) {
        $('.x4').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x4').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x5') {
    setInterval(function () {
      if (count == 1) {
        $('.x5').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x5').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x6') {
    setInterval(function () {
      if (count == 1) {
        $('.x6').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x6').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x7') {
    setInterval(function () {
      if (count == 1) {
        $('.x7').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x7').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x8') {
    setInterval(function () {
      if (count == 1) {
        $('.x8').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x8').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x9') {
    setInterval(function () {
      if (count == 1) {
        $('.x9').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x9').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x10') {
    setInterval(function () {
      if (count == 1) {
        $('.x10').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x10').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x11') {
    setInterval(function () {
      if (count == 1) {
        $('.x11').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x11').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x12') {
    setInterval(function () {
      if (count == 1) {
        $('.x12').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x12').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x13') {
    setInterval(function () {
      if (count == 1) {
        $('.x13').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x13').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x14') {
    setInterval(function () {
      if (count == 1) {
        $('.x14').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x14').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x15') {
    setInterval(function () {
      if (count == 1) {
        $('.x15').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x15').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x16') {
    setInterval(function () {
      if (count == 1) {
        $('.x16').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x16').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x17') {
    setInterval(function () {
      if (count == 1) {
        $('.x17').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x17').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x18') {
    setInterval(function () {
      if (count == 1) {
        $('.x18').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x18').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x19') {
    setInterval(function () {
      if (count == 1) {
        $('.x19').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x19').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x20') {
    setInterval(function () {
      if (count == 1) {
        $('.x20').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x20').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x21') {
    setInterval(function () {
      if (count == 1) {
        $('.x21').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x21').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x22') {
    setInterval(function () {
      if (count == 1) {
        $('.x22').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x22').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x23') {
    setInterval(function () {
      if (count == 1) {
        $('.x23').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x23').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x24') {
    setInterval(function () {
      if (count == 1) {
        $('.x24').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x24').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x25') {
    setInterval(function () {
      if (count == 1) {
        $('.x25').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x25').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x26') {
    setInterval(function () {
      if (count == 1) {
        $('.x26').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x26').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x27') {
    setInterval(function () {
      if (count == 1) {
        $('.x27').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x27').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x28') {
    setInterval(function () {
      if (count == 1) {
        $('.x28').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x28').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x29') {
    setInterval(function () {
      if (count == 1) {
        $('.x29').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x29').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x30') {
    setInterval(function () {
      if (count == 1) {
        $('.x30').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x30').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x31') {
    setInterval(function () {
      if (count == 1) {
        $('.x31').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x31').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x32') {
    setInterval(function () {
      if (count == 1) {
        $('.x32').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x32').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x33') {
    setInterval(function () {
      if (count == 1) {
        $('.x33').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x33').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x34') {
    setInterval(function () {
      if (count == 1) {
        $('.x34').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x34').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x35') {
    setInterval(function () {
      if (count == 1) {
        $('.x35').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x35').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x36') {
    setInterval(function () {
      if (count == 1) {
        $('.x36').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x36').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x37') {
    setInterval(function () {
      if (count == 1) {
        $('.x37').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x37').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x38') {
    setInterval(function () {
      if (count == 1) {
        $('.x38').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x38').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x39') {
    setInterval(function () {
      if (count == 1) {
        $('.x39').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x39').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x40') {
    setInterval(function () {
      if (count == 1) {
        $('.x40').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x40').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x41') {
    setInterval(function () {
      if (count == 1) {
        $('.x41').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x41').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x42') {
    setInterval(function () {
      if (count == 1) {
        $('.x42').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x42').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x43') {
    setInterval(function () {
      if (count == 1) {
        $('.x43').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x43').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x44') {
    setInterval(function () {
      if (count == 1) {
        $('.x44').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x44').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x45') {
    setInterval(function () {
      if (count == 1) {
        $('.x45').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x45').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x46') {
    setInterval(function () {
      if (count == 1) {
        $('.x46').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x46').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x47') {
    setInterval(function () {
      if (count == 1) {
        $('.x47').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x47').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x48') {
    setInterval(function () {
      if (count == 1) {
        $('.x48').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x48').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x49') {
    setInterval(function () {
      if (count == 1) {
        $('.x49').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x49').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'x50') {
    setInterval(function () {
      if (count == 1) {
        $('.x50').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.x50').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  } else if (x == 'checkynnm') {
    setInterval(function () {
      if (count == 1) {
        $('.checkynnm').css("color", "rgb(255,0,0)");

        count = 2
      } else {
        $('.checkynnm').css("color", "rgb(0,0,255)");
        count = 1
      }
    }, 500);
  }
}

function fn_ext_check_column(record, rowindex, val, col) {
  Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowindex));
  var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

  var max = record.MAXVALUE;
  var min = record.MINVALUE;
  var standardvalue = record.STANDARDVALUE; // 검사기준값
  var checkqty = record.CHECKQTY * 1; // 시료수
  var qty_check = false; // 시료수 체크
  var input_check = false; // 입력 / 미입력 체크
  var msg = "",
  result_check = false;

  // 검사 값
  var X1 = (col == '1') ? val : record.CHECKRESULT1,
  X2 = (col == '2') ? val : record.CHECKRESULT2,
  X3 = (col == '3') ? val : record.CHECKRESULT3,
  X4 = (col == '4') ? val : record.CHECKRESULT4,
  X5 = (col == '5') ? val : record.CHECKRESULT5,
  X6 = (col == '6') ? val : record.CHECKRESULT6,
  X7 = (col == '7') ? val : record.CHECKRESULT7,
  X8 = (col == '8') ? val : record.CHECKRESULT8,
  X9 = (col == '9') ? val : record.CHECKRESULT9,
  X10 = (col == '10') ? val : record.CHECKRESULT10;

  var X11 = (col == '11') ? val : record.CHECKRESULT11,
  X12 = (col == '12') ? val : record.CHECKRESULT12,
  X13 = (col == '13') ? val : record.CHECKRESULT13,
  X14 = (col == '14') ? val : record.CHECKRESULT14,
  X15 = (col == '15') ? val : record.CHECKRESULT15,
  X16 = (col == '16') ? val : record.CHECKRESULT16,
  X17 = (col == '17') ? val : record.CHECKRESULT17,
  X18 = (col == '18') ? val : record.CHECKRESULT18,
  X19 = (col == '19') ? val : record.CHECKRESULT19,
  X20 = (col == '20') ? val : record.CHECKRESULT20;

  var X21 = (col == '21') ? val : record.CHECKRESULT21,
  X22 = (col == '22') ? val : record.CHECKRESULT22,
  X23 = (col == '23') ? val : record.CHECKRESULT23,
  X24 = (col == '24') ? val : record.CHECKRESULT24,
  X25 = (col == '25') ? val : record.CHECKRESULT25,
  X26 = (col == '26') ? val : record.CHECKRESULT26,
  X27 = (col == '27') ? val : record.CHECKRESULT27,
  X28 = (col == '28') ? val : record.CHECKRESULT28,
  X29 = (col == '29') ? val : record.CHECKRESULT29,
  X30 = (col == '30') ? val : record.CHECKRESULT30;

  var X31 = (col == '31') ? val : record.CHECKRESULT31,
  X32 = (col == '32') ? val : record.CHECKRESULT32,
  X33 = (col == '33') ? val : record.CHECKRESULT33,
  X34 = (col == '34') ? val : record.CHECKRESULT34,
  X35 = (col == '35') ? val : record.CHECKRESULT35,
  X36 = (col == '36') ? val : record.CHECKRESULT36,
  X37 = (col == '37') ? val : record.CHECKRESULT37,
  X38 = (col == '38') ? val : record.CHECKRESULT38,
  X39 = (col == '39') ? val : record.CHECKRESULT39,
  X40 = (col == '40') ? val : record.CHECKRESULT40;

  var X41 = (col == '41') ? val : record.CHECKRESULT41,
  X42 = (col == '42') ? val : record.CHECKRESULT42,
  X43 = (col == '43') ? val : record.CHECKRESULT43,
  X44 = (col == '44') ? val : record.CHECKRESULT44,
  X45 = (col == '45') ? val : record.CHECKRESULT45,
  X46 = (col == '46') ? val : record.CHECKRESULT46,
  X47 = (col == '47') ? val : record.CHECKRESULT47,
  X48 = (col == '48') ? val : record.CHECKRESULT48,
  X49 = (col == '49') ? val : record.CHECKRESULT49,
  X50 = (col == '50') ? val : record.CHECKRESULT50;

  // 1. 시료수 범위 체크
  if (checkqty > ((col * 1) - 1) && checkqty <= 50) {
    msg = "입력이 가능합니다.";
    qty_check = true;
  } else {
    msg = "작업지시수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
    qty_check = false;
  }

  // 2. 입력 가능 / 불가 체크
  if (qty_check == true) {
    // 2-1. 입력되어있는지 유무 확인
    // 입력되어있을 경우에만 판정이 변경되도록 변경
    if (val.length > 0) {
      input_check = true;
    } else {
      input_check = false;
    }

    // 입력이 되어있으면
    if (input_check == true) {

      // 리스트 생성 함수 호출
      var xList = fn_push_list(X1, X2, X3, X4, X5, X6, X7, X8, X9,
          X10, X11, X12, X13, X14, X15, X16, X17, X18, X19, X20,
          X21, X22, X23, X24, X25, X26, X27, X28, X29, X30, X31,
          X32, X33, X34, X35, X36, X37, X38, X39, X40, X41, X42,
          X43, X44, X45, X46, X47, X48, X49, X50, checkqty);
      if (standardvalue === "") {
        if (val == "OK" || val == "NG") {}
        else {
          extToastView("OK/NG 중에 하나를 입력해주십시오!");
          model1.set("CHECKRESULT" + col + "", "");
          model1.set("CHECKTIME" + col + "", "");
          model1.set("CHECKRESULTNG" + col + "", "");
          return false;
        }
      } else {
        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
        if (!regexp.test(val)) {
          // 숫자가 아닌 값을 입력시
          extToastView("입력하신 값이 숫자가 아닙니다!");
          model1.set("CHECKRESULT" + col + "", "");
          model1.set("CHECKTIME" + col + "", "");
          model1.set("CHECKRESULTNG" + col + "", "");
          return false;
        }
      }

      // 판정결과
      result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);

      if (result_check == true) {
        model1.set('CHECKYNNAME', 'OK');
        model1.set('CHECKYN', 'OK');
        model1.set("CHECKRESULTNG" + col + "", "");
      } else {
        model1.set('CHECKYNNAME', 'NG');
        model1.set('CHECKYN', 'NG');
      }

      var todate = new Date();
      var today = Ext.util.Format.date(todate, 'Y-m-d H:i');
      model1.set("CHECKTIME" + col + "", today);

      return true;
    } else {
      // 미입력시 메시지 안띄우고 그냥 넘어감
      return true;
    }
  } else {
    // 시료수량 미등록 또는 범위 초과시 메시지 발생
    extToastView(msg);
    model1.set("CHECKRESULT" + col + "", "");
    model1.set("CHECKTIME" + col + "", "");
    model1.set("CHECKRESULTNG" + col + "", "");
    return false;
  }
}

function fn_goHome() {
   <%--작업시작 처음 화면으로 넘어감.--%>
  go_url('<c:url value="/prod/process/ProcessStart.do" />');
}

function fn_goPrePrevPage() {
  switch (groupid) {
  case "ROLE_EQUIPMENT":
    fn_goHome();

    break;
  default:
    go_url('<c:url value="/prod/process/selectQualityList.do?type="/>' + "${searchVO.type}" + "&gubun=" + "${searchVO.gubun}");

    break;
  }
}

function fn_goPrevPage() {
  var type = 10;
  go_url('<c:url value="/prod/process/selectWorkOrderNewRegist.do?type="/>' + type + "&work=" + $('#work').val() + "&gubun=" + $('#gubun').val());
}

var colIdx = 0, rowIdx = 0;
function fn_save(flag) {
  var msg_title = "";
  var count1 = Ext.getStore(gridnms["store.1"]).count();
  if (count1 > 0) {
    for (var i = 0; i < count1; i++) {
      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
      var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

      model1.set("STARTTIME", $('#starttime').val());
      switch (flag) {
      case "1":
        // 저장 버튼 클릭시
        model1.set("BPYN", "N");
        msg_title = "[자주검사]";

        break;
      case "2":
        // BP 버튼 클릭시
        model1.set("BPYN", "Y");
        msg_title = "[BYPASS]";

        break;
      default:
        // 그 외
        model1.set("BPYN", "N");

        break;
      }
    }
  } else {
    extToastView("검사 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
  }

  Ext.getStore(gridnms["store.1"]).sync({
    success: function (batch, options) {
      msg = msg_title + "<br/>" + msgs.noti.save;

      setTimeout(function () {
        //         fn_goPrevPage();
        Ext.getCmp(gridnms["views.list"]).supendLayout = false;
        Ext.getCmp(gridnms["views.list"]).doLayout();
        extToastView(msg);

      }, 1 * 0.5 * 1000);

      Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
        row: rowIdx,
        column: colIdx,
        animate: false
      });
      //       Ext.suspendLayouts();
      //    Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
      //       Ext.resumeLayouts(true);
      //       Ext.getCmp(gridnms["views.list"]).supendLayout = true;

      //       var o = new SomeLargeObject();
      //       someCache.register(o);
      //       //소멸 후 래퍼런스 null처리. someCache는 여전히 래퍼런스 유지
      //       o.destroy();
      //       o = null;
    },
    failure: function (batch, options) {
      extToastView(batch.exceptions[0].error);
    },
    callback: function (batch, options) {},
  });
}

function fn_valid_calc() {
  var checkresult = $('#CheckResultNg').val();
  if (checkresult != "") {
    var count = Ext.getStore(gridnms["store.1"]).count();
    if (count > 0) {

      var rec_col = colIdx;
      var rec_row = rowIdx;
      //  var model =  Ext.getCmp(gridnms["panel.1"]).getSelectionModel().getSelection()[0];

      //             if(model == undefined ) {
      //              extToastView("현재 등록된 이미지가 없습니다.<br/>관리자에게 문의하십시오.");
      //               return;
      //             }
      var record = Ext.getCmp(gridnms["panel.1"]).getSelectionModel().views[1].store.data.items[rec_row];
      var todate = new Date();
      var today = Ext.util.Format.date(todate, 'Y-m-d H:i');

      //       var colnum = (rec_col * 1) + 1;
      var colnum = (rec_col * 1) - 1;
      if (colnum < 1) {
        colnum = 1;
      }

      record.set("CHECKTIME" + colnum + "", today);
      record.set("CHECKRESULTNG" + colnum + "", checkresult);

      var result = record;
    }

  }
}

function fn_lotno_input() {
  var lotno = $('#LotNoVisual').val();
  if (lotno != "") {
    var count = Ext.getStore(gridnms["store.1"]).count();
    if (count > 0) {
      for (var i = 0; i < count; i++) {
        var record = Ext.getCmp(gridnms["panel.1"]).getSelectionModel().views[1].store.data.items[i];
        record.set("LOTNOVISUAL", lotno.toUpperCase());
      }
    }

  }
}

function fn_worker_input() {
  var personid = $('#PersonId').val();
  var krname = $('#KrName').val();
  if (personid != "") {
    var count = Ext.getStore(gridnms["store.1"]).count();
    if (count > 0) {
      for (var i = 0; i < count; i++) {
        var record = Ext.getCmp(gridnms["panel.1"]).getSelectionModel().views[1].store.data.items[i];
        record.set("PERSONID", personid);
        record.set("KRNAME", krname);
      }
    }
  }
}

var win15;
function fn_image_viewer(path, val, width, height) {
  if (path === "" || path == undefined) {
    extToastView("현재 등록된 이미지가 없습니다.<br/>관리자에게 문의하십시오.");
    return;
  }

  var title = "";

  switch (val) {
  case 1:
    title = "작업표준서 이미지";
    break;
  case 2:
    title = "Q포인트 이미지";
    break;
  case 3:
    title = "약도 이미지";
    break;
  case 4:
    title = "도면 이미지";
    break;
  case 5:
    title = "공정도 이미지";
    break;
  case 6:
    title = "공구 이미지";
    break;
  default:
    break;
  }

  win15 = Ext.create('Ext.window.Window', {
      autoShow: true,
      width: width * 2.5,
      height: '90%',
      title: title,
      html: '<img alt="" src=' + path + ' style="width:100%; height:100%;" onclick="fn_image_destroy();" />',
      draggable: true,
      resizable: false,
      maximizable: false,
      closeAction: 'destroy',
      modal: true,
    });
}

function fn_image_destroy() {
  win15.close();
}

function fn_tab(flag) {
  $("#tab1,#tab2,#tab3,#tab4, #tab5, #tab6").removeClass("active");
  selectedItemCode = "${searchVO.ITEMCODE}";
  selectedroutingid = "${searchVO.ROUTINGID}";
  switch (flag) {
  case "1":
    // 작업표준서
    $("#tab1").addClass("active");

    fn_imageHandle('Image1');
    click_gubun = 1;
    break;
  case "2":
    // Q포인트
    $("#tab2").addClass("active");

    fn_imageHandle('Image2');
    click_gubun = 2;
    break;
  case "3":
    // 약도
    $("#tab3").addClass("active");

    fn_imageHandle('Image3');
    click_gubun = 3;
    break;
  case "4":
    // 도면
    $("#tab4").addClass("active");

    fn_imageHandle('Image4');
    click_gubun = 4;
    break;
  case "5":
    // 공정도
    $("#tab5").addClass("active");

    fn_imageHandle('Image5');
    click_gubun = 5;
    break;
  case "6":
    // 공구
    $("#tab6").addClass("active");

    fn_imageHandle('Image6');
    click_gubun = 6;
    break;
  default:
    break;
  }
}

function fn_imageHandle(val) {
  gubun = val;

  getItemFile();
}

var click_gubun;
function getItemFile() {
  $("div[id^=fileBox_]").remove();
  $("#filetable").find(".cancel").click();
  $("#filetable").find("tr").remove();
  $.ajax({
    url: "<c:url value='/itemfile/select.do' />",
    type: "post",
    dataType: "json",
    data: {
      itemcd: selectedItemCode,
      filetype: filetype,
      gubun: gubun,
      routingid: (gubun == "Image1" || gubun == "Image2" || gubun == "Image3" || gubun == "Image5" || gubun == "Image6") ? selectedroutingid : "",
      checkbig: selectedCheckBig,
    },
    success: function (data) {
      var wth = $("#fileBox").width();
      var hgt = $("#fileBox").height();
      $.each(data, function (i, m) {
        var html = '';
        html += '<div id="fileBox_' + m.fileid + '" style="width: 100%; height: 784px;">'; // 360px
        html += '<img alt="" src="' + m.filepathview + m.filenmreal + '" onclick="javascript:fn_image_viewer(\'' + m.filepathview + m.filenmreal + '\', ' + click_gubun + ', 488, 316); return false;" style="width: 100%; height: 784px; " />';
        html += '</div>';
        $("#fileBox").append(html);
      });
      imgCnt = $("div[id^=fileBox_]").length;
      fn_fileBtnBox_display();
    },
    error: ajaxError
  });
}

function fn_fileBtnBox_display() {
  if (imgCnt >= 1) {
    $("#fileBtnBox").hide();
  } else {
    $("#fileBtnBox").show();
  }
}

function fn_goMovePage(flag) {
  var equipmentcode = $('#equipmentcode').val();

  if (equipmentcode == "") {
    extToastView("작업실적 현황이 선택되지 않았습니다.<br/>다시 한번 확인해주십시오.");
    return false;
  }
  if (flag === 8) {
    go_url('<c:url value="/prod/process/WarehousingRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else if (flag === 10) {
    go_url('<c:url value="/prod/process/selectWorkOrderNewRegist.do?type="/>' + flag + "&work=" + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else if (flag === 11) {
    go_url('<c:url value="/prod/process/WorkgroupChangeRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else if (flag === 12) {
    go_url('<c:url value="/prod/process/WorkOutOrderRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else if (flag === 13) {
    go_url('<c:url value="/prod/process/WorkOrderInOut.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
  } else {
    go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + flag + "&gubun=" + $('#gubun').val() + "&code=" + equipmentcode + "&work=" + $('#work').val());
  }
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

function fn_ready() {
  extToastView("준비중입니다...");
  return;
}

function setLovList() {
  // 작업자 Lov
  $("#KrName").bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      $("#PersonId").val("");
      break;
    case $.ui.keyCode.ENTER:
      $(this).autocomplete("search", "%");
      break;

    default:
      break;
    }
  }).focus(
    function (e) {
    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
  }).autocomplete({
    source: function (request, response) {
      $.getJSON("<c:url value='/searchWorkerLov.do' />", {
        keyword: extractLast(request.term),
        ORGID: '${searchVO.ORGID}',
        COMPANYID: '${searchVO.COMPANYID}',
        INSPECTORTYPE: '20',
        INSPECTORTYPE2: '30',
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              label: m.LABEL,
              value: m.VALUE,
            });
          }));
      });
    },
    search: function () {
      if (this.value === "")
        return;
      var term = extractLast(this.value);
      if (term.length < 1) {
        return false;
      }
    },
    focus: function () {
      return false;
    },
    select: function (e, o) {
      $("#PersonId").val(o.item.value);
      $("#KrName").val(o.item.label);

      fn_worker_input();

      return false;
    }
  });
}

function setReadOnly() {
  $("[readonly]").addClass("ui-state-disabled");
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
        <!-- 현재위치 네비게이션 시작 -->
        <div style="margin-top: 0px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
            <div style="width: 100%; padding-left: 0px; ">
                <form id="master" name="master" method="post">
                    <input type="hidden" id="type" name="type" value="${searchVO.type}" />
                    <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
                    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
	                  <input type="hidden" id="workorderid" name="workorderid" value="${searchVO.WORKORDERID}" />
	                  <input type="hidden" id="workorderseq" name="workorderseq" value="${searchVO.WORKORDERSEQ}" />
                    <input type="hidden" id="seqno" name="seqno" />
                    <input type="hidden" id="fmlid" name="fmlid" value="${searchVO.FMLID}" />
                    <input type="hidden" id="orderno" name="orderno" />
                    <input type="hidden" id="checklistid" name="checklistid" />
                    <input type="hidden" id="itemcode" name="itemcode" value="${searchVO.ITEMCODE}" />
                    <input type="hidden" id="fmltype" name="fmltype" value="${FMLTYPE}" />
                    <input type="hidden" id="equipmentcode" name="equipmentcode" value="${EQUIPMENTCODE}"/>
                    <input type="hidden" id="equipmentname" name="equipmentname" value="${EQUIPMENTNAME}" />
                    <input type="hidden" id="starttime" name="starttime" value="${searchVO.STARTTIME}" />
                    <input type="hidden" id="endtime" name="endtime" value="${searchVO.ENDTIME}" />
                    <input type="hidden" id="PersonId" name="PersonId" value="${searchVO.PERSONID}" />
                </form>
                    <c:choose>
                        <c:when test="${searchVO.work == 'Y'}">
                            <div style="width: calc(100% - 200px); height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
<!--                                 <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                         생산실적<br/>( TOUCH ) -->
<!--                                 </button> -->
                                <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                        생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                        래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                        자주검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                        공구변경<br/>( TOOL CHANGE )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                        외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                        반입반출<br/>( STORED & RELEASED )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                        설비변경<br/>( FACILITIES )
                                </button>
                            </div>
                            <div style="width: 200px; height: 65px; margin-top: 0px; margin-right: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: right;">
                                <button type="button" class="yellow " onclick="fn_LogOut();" style="width: 185px; height: 63px; float: right';">
                                        나가기<br/>( LOGOUT )
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="width: 100%; height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
                                <button type="button" class="btn_work_home blue3 h " onclick="fn_goHome( );" style="width: 8%; height: 63px; float: left';">HOME</button>
                                <button type="button" class="btn_work_prev blue3 h " onclick="fn_goPrevPage( );" style="width: 8%; height: 63px; float: left';">
                                        이전화면<br/>( BACK )
                                </button>
<!--                                 <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                         생산실적<br/>( TOUCH ) -->
<!--                                 </button> -->
                                <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                        생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                        래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                        자주검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                        공구변경<br/>( TOOL CHANGE )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                        외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                        반입반출<br/>( STORED & RELEASED )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                        설비변경<br/>( FACILITIES )
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <div id="ImageArea" style="width: 100%; float:left; margin-top: 0px;">
                        <table class="tbl_type_view" border="0" style="width:100%; border: 0px none;">
                            <colgroup>
                                <col width="43%">
                                <col>
                            </colgroup>
                            <tbody>
                                <tr>
                                    <td rowspan="2" style="margin-left: 0px; padding-left: 0px; border-top-width: 1px; border-top-color: #5B9BD5; border-top-style: solid; border-right-width: 1px; border-right-color: #5B9BD5; border-right-style: solid; border-bottom-width: 1px; border-bottom-color: #5B9BD5; border-bottom-style: solid;">
		                                    <div class="tab line" style="margin: 0px; padding: 0px;">
		                                        <ul>
		                                            <li id="tab1"><a href="#" onclick="javascript:fn_tab('1');" select><span style=" font-size: 21px;">작업표준서</span></a></li>
                                                <li id="tab5"><a href="#" onclick="javascript:fn_tab('5');" select><span style=" font-size: 21px;">공정도</span></a></li>
                                                <li id="tab3"><a href="#" onclick="javascript:fn_tab('3');" select><span style=" font-size: 21px;">약도</span></a></li>
		                                            <li id="tab4"><a href="#" onclick="javascript:fn_tab('4');" select><span style=" font-size: 21px;">도면</span></a></li>
                                                <li id="tab2"><a href="#" onclick="javascript:fn_tab('2');" select><span style=" font-size: 21px;">Q포인트</span></a></li>
	                                              <li id="tab6"><a href="#" onclick="javascript:fn_tab('6');" select><span style=" font-size: 21px;">공구</span></a></li>
		                                        </ul>
		                                    </div>
										                    <div id="fileBox" style="width: 100%; height: 784px; float: left; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
						                               <div id="fileBtnBox" style="width: 100%; height: auto;">
						                                    <div class="row" style="margin-top: 0px; text-align: center;">
                                                  <img alt="" src="<c:url value='/'/>images/noimage.png"  style="width: 365px; height: auto;"/>
						                                    </div>
						                                </div>
						                                <table id="filetable" class="table table-striped files ng-cloak" style="width: 100%;">
						                                    <tr data-ng-repeat="file in queue">
						                                        <td data-ng-switch data-on="!!file.thumbnailUrl" width="100px" style="vertical-align: middle;">
						                                            <div class="preview" data-ng-switch-when="true">
						                                                <a data-ng-href="{{file.url}}" title="{{file.name}}" download="{{file.name}}" data-gallery><img data-ng-src="{{file.thumbnailUrl}}" alt=""></a>
						                                            </div>
						                                            <div class="preview" data-ng-switch-default data-file-upload-preview="file"></div>
						                                        </td>
						                                    </tr>
						                                </table>  
		                                    </div>
                                    </td>
                                    <td style="height: 160px; border-top-width: 1px; border-top-color: #5B9BD5; border-top-style: solid; border-bottom-width: 1px; border-bottom-color: #5B9BD5; border-bottom-style: solid; padding-left: 0px;">
                                    
                                        <center style="height: auto;">
				                                    <table style="width: 100%; height: 100%;">
						                                    <colgroup>
										                                <col width="30%">
				                                            <col>
                                                    <col width="30%">
				                                            <col>
										                            </colgroup>
										                            <tbody>
										                                <tr>
                                                    <td style="border-bottom: 0px none;">
                                                        <label class="shadow" style="width: 100%; height: 50px; font-size: 28px; background-color: #5B9BD5; color: white; font-weight: bold; margin-top: 5px; margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;">
                                                            <span>품명</span>
                                                        </label>
                                                        <input type="text" class="shadow" id="CheckResultNg" name="CheckResultNg" value="${searchVO.ITEMNAME}" style="width: 100%; height: 50px; font-size: 35px; background-color:rgb(250, 227, 125); color: red; font-weight: bold;  margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;" readonly />
                                                    </td>
				                                            <td style="border-bottom: 0px none;">
								                                        <label class="shadow" style="width: 100%; height: 50px; font-size: 28px; background-color: #5B9BD5; color: white; font-weight: bold; margin-top: 5px; margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;">
								                                            <span>공정</span>
								                                        </label>
								                                        <input type="text" class="shadow" id="CheckResultNg" name="CheckResultNg" value="${searchVO.ROUTINGNAME}" style="width: 100%; height: 50px; font-size: 35px; background-color:rgb(250, 227, 125); color: red; font-weight: bold;  margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;" readonly />
				                                            </td>
				                                            
				                                            <td style="border-bottom: 0px none;">
								                                        <label id="WorkerTitle" class="shadow" style="width: 100%; height: 50px; font-size: 28px; background-color: #5B9BD5; color: white; font-weight: bold; margin-top: 5px; margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;">
                                                            <span>검사자</span>
                                                        </label>
								                                        <input type="text" class="shadow" id="KrName" name="KrName" value="${searchVO.KRNAME}" style="width: 100%; height: 50px; font-size: 35px; background-color:rgb(250, 227, 125); color: blue; font-weight: bold;  margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;" oncontextmenu="return false" />
				                                            </td>
				                                            <td style="border-bottom: 0px none;">
								                                        <div style="width: calc(100% - 15px); height: auto; float: left;">
								                                                <button type="button" id="btn_tab_sav" class="blue2 r shadow" onclick="fn_save('1');" style="width: 100%; height: 100px; font-size: 40px; font-weight: bold; margin-left: 0px; margin-top: 0px; margin-bottom: 0px; float: left;">저장 (Save)</button>
								                                        </div>
				                                            </td>
										                                </tr>
										                                <tr>
										                                <td style="border-bottom: 0px none;">
                                                        <label class="shadow" style="width: 100%; height: 50px; font-size: 28px; background-color: #5B9BD5; color: white; font-weight: bold; margin-top: 5px; margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;">
                                                            <span>기종</span>
                                                        </label>
                                                        <input type="text" class="shadow" id="CheckResultNg" name="CheckResultNg" value="${searchVO.CARTYPENAME}" style="width: 100%; height: 50px; font-size: 35px; background-color:rgb(250, 227, 125); color: red; font-weight: bold;  margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;" readonly />
                                                    </td>
                                                    <td style="border-bottom: 0px none;">
                                                        <label class="shadow" style="width: 100%; height: 50px; font-size: 28px; background-color: #5B9BD5; color: white; font-weight: bold; margin-top: 5px; margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;">
                                                            <span>타입</span>
                                                        </label>
                                                        <input type="text" class="shadow" id="CheckResultNg" name="CheckResultNg" value="${searchVO.ITEMSTANDARDDETAIL}" style="width: 100%; height: 50px; font-size: 35px; background-color:rgb(250, 227, 125); color: red; font-weight: bold;  margin-right: 0%; margin-bottom: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: left;" readonly />
                                                    </td>
										                                </tr>
								                                </tbody>
				                                    </table>
			                                  </center>
                                    </td>
                                </tr>
                                <tr>
		                                <td style=" padding-left: 0px; padding-bottom: 0px;">
		                                    <div id="gridArea" style="width: 100%; margin-top: 0px; padding-left: 0px; padding-right: 0px; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
		                                </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
            </div>
        </div>
        <!-- //content 끝 -->
        <div id="gridPopup1Area" style="width: 1865px; padding-top: 0px; float: left;"></div>
        <div id="gridPopup2Area" style="width: 1095px; padding-top: 0px; float: left;"></div>
    <!-- //전체 레이어 끝 -->
<div id="loadingBar" style="display: none;">
    <img src='<c:url value="/images/spinner.gif"></c:url>' alt="Loading"/>
</div>
</body>
</html>