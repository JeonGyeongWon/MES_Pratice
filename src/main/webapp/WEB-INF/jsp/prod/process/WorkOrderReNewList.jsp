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
<title>${pageTitle}</title>
<link rel="stylesheet" href="<c:url value='/css/custom_work.css'/>">
<style>
.x-column-header-inner {
	font-size: 22px;
	font-weight: bold;
	background-color: #5B9BD5;
	color: white;
	padding-left: 0px;
	padding-right: 0px;
}

.x-column-header-text {
  height: 60px;
  line-height: 30px;
  display: -webkit-flex;
  display: flex;
  -webkit-align-items: center;
  align-items: center;
  -webkit-justify-content: center;
  justify-content: center;
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

.x-grid-cell-inner {
	position: relative;
	text-overflow: ellipsis;
	padding-top: 15px;
	padding-left: 10px;
	height: 60px;
	font-size: 22px !important;
	font-weight: bold;
}

#gridArea .x-form-field {
	font-size: 21px;
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

*::-webkit-input-placeholder {
	color: blue;
}

*:-moz-placeholder {
	/* FF 4-18 */
	color: blue;
}

*::-moz-placeholder {
	/* FF 19+ */
	color: blue;
}

*:-ms-input-placeholder {
	/* IE 10+ */
	color: blue;
}

.F1 a:link {
	color: white;
	text-decoration: none;
}

.F1 a:visited {
	color: black;
	text-decoration: none;
}

.F1 a:hover {
	color: white;
	text-decoration: underline;
}
</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
var gridnms = {};
var fields = {};
var items = {};
var btnCnt = true;
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  setTimeout(function () {
    fn_search();
  }, 1000);

  setReadOnly();

  setLovList();
});

function setInitial() {
  gridnms["app"] = "prod";
}

function fn_search() {
  setTimeout(function () {
    var count = Ext.getStore(gridnms["store.1"]).count();

    var model = Ext.getStore(gridnms["store.1"]).data.items[0];

    if (count > 0) {
      var orgid = model.data.ORGID;
      var companyid = model.data.COMPANYID;
      var equipgubun = model.data.WORKDEPT;
      var equipmentcode = model.data.WORKCENTERCODE;
      var equipmentname = model.data.WORKCENTERNAME;

      $("#orgid").val(orgid);
      $("#companyid").val(companyid);
      $("#equipgubun").val(equipgubun);
      $("#equipmentcode").val(equipmentcode);
      $("#equipmentname").val(equipmentname);
    }
  }, 1500);
}

function setValues() {
  setValues_list();
}

function setValues_list() {

  gridnms["models.list"] = [];
  gridnms["stores.list"] = [];
  gridnms["views.list"] = [];
  gridnms["controllers.list"] = [];

  gridnms["grid.1"] = "WorkOrderList";

  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
  gridnms["views.list"].push(gridnms["panel.1"]);

  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
  gridnms["controllers.list"].push(gridnms["controller.1"]);

  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

  gridnms["models.list"].push(gridnms["model.1"]);

  gridnms["stores.list"].push(gridnms["store.1"]);

  fields["model.1"] = [{
      type: 'number',
      name: 'RN',
    }, {
      type: 'number',
      name: 'ORGID',
    }, {
      type: 'number',
      name: 'COMPANYID',
    }, {
      type: 'string',
      name: 'WORKORDERID',
    }, {
      type: 'number',
      name: 'WORKORDERSEQ',
    }, {
      type: 'date',
      name: 'WORKPLANSTARTDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'WORKLEV',
    }, {
      type: 'string',
      name: 'WORKDEPT',
    }, {
      type: 'string',
      name: 'WORKCENTERCODE',
    }, {
      type: 'string',
      name: 'ORDERNAME',
    }, {
      type: 'string',
      name: 'DRAWINGNO',
    }, {
      type: 'string',
      name: 'ITEMNAME',
    }, {
      type: 'string',
      name: 'MODEL',
    }, {
      type: 'string',
      name: 'MODELNAME',
    }, {
      type: 'string',
      name: 'UOM',
    }, {
      type: 'string',
      name: 'UOMNAME',
    }, {
      type: 'number',
      name: 'ROUTINGID',
    }, {
      type: 'string',
      name: 'ROUTINGCOLOR',
    }, {
      type: 'string',
      name: 'ROUTINGOP',
    }, {
      type: 'string',
      name: 'ROUTINGNAME',
    }, {
      type: 'string',
      name: 'WORKCENTERNAME',
    }, {
      type: 'number',
      name: 'WORKORDERQTY',
    }, {
      type: 'number',
      name: 'PRODUCEDQTY',
    }, {
      type: 'number',
      name: 'WORKERQTY',
    }, {
      type: 'number',
      name: 'FMLID',
    }, {
      type: 'string',
      name: 'FMLTYPE',
    }, {
      type: 'string',
      name: 'CHECKBIG',
    }, {
      type: 'string',
      name: 'CHECKBIGNAME',
    }, {
      type: 'string',
      name: 'WORKEMPLOYEE',
    }, {
      type: 'string',
      name: 'WORKKRNAME',
    }, {
      type: 'date',
      name: 'STARTTIME',
      dateFormat: 'H:i',
    }, {
      type: 'date',
      name: 'ENDTIME',
      dateFormat: 'H:i',
    }, {
      type: 'date',
      name: 'STARTDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'date',
      name: 'ENDDATE',
      dateFormat: 'Y-m-d H:i',
    }, {
      type: 'string',
      name: 'INSPECTIONYN',
    }, {
      type: 'string',
      name: 'INSPECTIONYNNAME',
    }, {
      type: 'string',
      name: 'CHECKYN',
    }, ];

  fields["columns.1"] = [{
      dataIndex: 'RN',
      text: '순<br/>번',
      xtype: 'gridcolumn',
      width: 50,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
    }, {
      dataIndex: 'CHECKYN',
      text: '검사<br/>유무',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        if (value == "Y") {
          meta.style = " color: white; ";
          meta.style += " background-color: rgb(0, 0, 255); ";
        } else {
          meta.style = " color: white; ";
          meta.style += " background-color: rgb(255, 0, 0); ";
        }

        return value;
      },
    }, {
      dataIndex: 'STARTDATE',
      text: '투입일자',
      xtype: 'datecolumn',
      width: 200,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      format: 'Y-m-d H:i',
      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
        var result = '<div><a href="{0}">{1}</a></div>';

        temp = "FmlRegist";
        var url = null;
        url = "<c:url value='/prod/process/'/>" + temp + ".do?type=" + "${searchVO.type}"
           + "&gubun=" + record.data.WORKDEPT
           + "&work=" + $('#work').val()
           + "&code=" + record.data.WORKCENTERCODE
           + "&workorder=" + record.data.WORKORDERID
           + '&seq=' + record.data.WORKORDERSEQ
           + '&org=' + record.data.ORGID
           + '&company=' + record.data.COMPANYID
           + '&id=' + record.data.FMLID;

        return Ext.String.format(result, url, Ext.util.Format.date(value, 'Y-m-d'));
      },
    }, {
      dataIndex: 'ITEMNAME',
      text: '품명',
      xtype: 'gridcolumn',
      width: 300,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
        var result = '<div><a href="{0}">{1}</a></div>';

        temp = "FmlRegist";
        var url = null;
        url = "<c:url value='/prod/process/'/>" + temp + ".do?type=" + "${searchVO.type}"
           + "&gubun=" + record.data.WORKDEPT
           + "&work=" + $('#work').val()
           + "&code=" + record.data.WORKCENTERCODE
           + "&workorder=" + record.data.WORKORDERID
           + '&seq=' + record.data.WORKORDERSEQ
           + '&org=' + record.data.ORGID
           + '&company=' + record.data.COMPANYID
           + '&id=' + record.data.FMLID;

        return Ext.String.format(result, url, value);
      },
    }, {
      dataIndex: 'ROUTINGOP',
      text: '공정순번',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        var result = '<div><a href="{0}">{1}</a></div>';
        temp = "FmlRegist";
        var url = null;
        url = "<c:url value='/prod/process/'/>" + temp + ".do?type=" + "${searchVO.type}"
           + "&gubun=" + record.data.WORKDEPT
           + "&work=" + $('#work').val()
           + "&code=" + record.data.WORKCENTERCODE
           + "&workorder=" + record.data.WORKORDERID
           + '&seq=' + record.data.WORKORDERSEQ
           + '&org=' + record.data.ORGID
           + '&company=' + record.data.COMPANYID
           + '&id=' + record.data.FMLID;

        return Ext.String.format(result, url, value);
      },
    }, {
      dataIndex: 'ROUTINGNAME',
      text: '공정명',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        var routingcolor = record.data.ROUTINGCOLOR;
        if (routingcolor != "" && routingcolor != "Y") {
          meta.style = "background-color:" + routingcolor + ";";
          meta.style += " color: white;";
        }
        return value;
      },
    }, {
      dataIndex: 'CARTYPENAME',
      text: '기종',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        return value;
      },
    }, {
      dataIndex: 'ITEMSTANDARDDETAIL',
      text: '타입',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        return value;
      },
    }, {
      dataIndex: 'WORKCENTERNAME',
      text: '설비명',
      xtype: 'gridcolumn',
      width: 300,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record) {
        return value;
      },
    }, {
      dataIndex: 'PRODUCEDQTY',
      text: '생산<br/>수량',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      renderer: Ext.util.Format.numberRenderer('0,000'),
    }, {
      dataIndex: 'WORKERQTY',
      text: '작업자<br/>수량',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      renderer: Ext.util.Format.numberRenderer('0,000'),
    }, {
      dataIndex: 'WORKKRNAME',
      text: '작업자 ( NAME )',
      xtype: 'gridcolumn',
      width: 200,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, metaData, record, rowIndex,
        colIndex, store, view) {
        var status = $('#status').val();

        var temp = null;
        if (status === "PROGRESS") {
          // 자주 검사시 관리자 등록화면 링크 O
          var result = '<div><a href="{0}">{1}</a></div>';

          temp = "FmlRegist";
          var url = null;
          url = "<c:url value='/prod/process/'/>" + temp + ".do?type=" + "${searchVO.type}"
             + "&gubun=" + record.data.WORKDEPT
             + "&work=" + $('#work').val()
             + "&code=" + record.data.WORKCENTERCODE
             + "&workorder=" + record.data.WORKORDERID
             + '&seq=' + record.data.WORKORDERSEQ
             + '&org=' + record.data.ORGID
             + '&company=' + record.data.COMPANYID
             + '&id=' + record.data.FMLID;

          return Ext.String.format(result, url, value);
        } else {
          // 그 외 링크 X
          return value;
        }
      },
    }, {
      dataIndex: 'WORKPLANSTARTDATE',
      text: '일자',
      xtype: 'datecolumn',
      width: 150,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      format: 'Y-m-d',
      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
        return Ext.util.Format.date(value, 'Y-m-d');
      },
    }, {
      dataIndex: 'ENDDATE',
      text: '철수시간',
      xtype: 'datecolumn',
      width: 200,
      hidden: true,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      format: 'Y-m-d H:i',
      renderer: function (value, metaData, record, rowIndex,
        colIndex, store, view) {
        var status = $('#status').val();

        var temp = null;
        if (status === "PROGRESS") {
          // 자주 검사시 생산자 등록화면 링크 O
          var result = '<div><a href="{0}">{1}</a></div>';

          temp = "FmlRegist";
          var url = null;
          url = "<c:url value='/prod/process/'/>" + temp + ".do?type=" + "${searchVO.type}"
             + "&gubun=" + record.data.WORKDEPT
             + "&work=" + $('#work').val()
             + "&code=" + record.data.WORKCENTERCODE
             + "&workorder=" + record.data.WORKORDERID
             + '&seq=' + record.data.WORKORDERSEQ
             + '&org=' + record.data.ORGID
             + '&company=' + record.data.COMPANYID
             + '&id=' + record.data.FMLID;

          return Ext.String.format(result, url, Ext.util.Format.date(value, 'Y-m-d H:i'));
        } else {
          // 그 외 링크 X
          return Ext.util.Format.date(value, 'Y-m-d H:i');
        }
      },
    }, {
      dataIndex: 'ORDERNAME',
      text: '품번',
      xtype: 'gridcolumn',
      width: 205,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {

        return value;
      },
    }, {
      dataIndex: 'WORKORDERID',
      text: '작지번호',
      xtype: 'gridcolumn',
      width: 170,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {

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
      dataIndex: 'WORKORDERSEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'MODEL',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGCOLOR',
      xtype: 'hidden',
    }, {
      dataIndex: 'EQUIPMENTCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'FMLID',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKEMPLOYEE',
      xtype: 'hidden',
    }, {
      dataIndex: 'INSPECTIONYN',
      xtype: 'hidden',
    }, {
      dataIndex: 'STARTTIME',
      xtype: 'hidden',
    }, {
      dataIndex: 'ENDTIME',
      xtype: 'hidden',
    }, ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/prod/process/selectWorkCheckNewList.do' />"
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
  // 작업지시 선택시
  var orgid = record.data.ORGID;
  var companyid = record.data.COMPANYID;

  var equipgubun = record.data.WORKDEPT;
  var equipmentcode = record.data.WORKCENTERCODE;
  var equipmentname = record.data.WORKCENTERNAME;

  $("#orgid").val(orgid);
  $("#companyid").val(companyid);
  $("#equipgubun").val(equipgubun);
  $("#equipmentcode").val(equipmentcode);
  $("#equipmentname").val(equipmentname);
};

var gridarea1;
function setExtGrid() {
  setExtGrid_list();

  Ext.EventManager.onWindowResize(function (w, h) {
    gridarea1.updateLayout();
  });
}

function setExtGrid_list() {

  Ext.define(gridnms["model.1"], {
    extend: Ext.data.Model,
    fields: fields["model.1"],
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
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.1"],
              extraParams: {
                ORGID: '${searchVO.ORGID}',
                COMPANYID: '${searchVO.COMPANYID}',
                CHECKBIG: $('#checkbig').val(),
                EMPLOYEENUMBER: (groupid == "ROLE_WORK_CHIEF" || groupid == "ROLE_WORK") ? $('#loginid').val() : "",
                GUBUN: '${searchVO.gubun}',
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

  Ext.define(gridnms["panel.1"], {
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
        height: 857,
        border: 2,
        scrollable: true,
        columns: fields["columns.1"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'FmlSelect',
          trackOver: true,
          loadMask: true,
          striptRows: true,
          forceFit: true,
          listeners: {
            refresh: function (dataView) {
              Ext.each(dataView.panel.columns, function (column) {
                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('WORKCENTERNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 80) {
                    column.width = 80;
                  }
                }
              });
            }
          },
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
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

function fn_goHome() {
   <%--작업시작 처음 화면으로 넘어감.--%>
  go_url('<c:url value="/prod/process/ProcessStart.do" />');
}

function fn_goPrevPage() {
  switch (groupid) {
  case "ROLE_EQUIPMENT":
    fn_goHome();

    break;
  default:
	    fn_goHome();
//     go_url('<c:url value="/prod/process/selectQualityList.do?type="/>' + "${searchVO.type}" + "&gubun=" + "${searchVO.gubun}");

    break;
  }
}
function fn_goMovePage(flag) {
  var equipgubun = $('#equipgubun').val();
  var equipmentcode = $('#equipmentcode').val();
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
    go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + flag + "&gubun=" + $('#gubun').val() + "&work=" + $('#work').val());
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
  //
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
                    <input type="hidden" id="checkbig" name="checkbig" value="${searchVO.CHECKBIG}" />
                    <input type="hidden" id="orgid" name="orgid" />
                    <input type="hidden" id="companyid" name="companyid" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
                    <input type="hidden" id="workorderid" name="workorderid" />
                    <input type="hidden" id="workorderseq" name="workorderseq" />
                    <input type="hidden" id="itemcode" name="itemcode" />
                    <input type="hidden" id="routingcode" name="routingcode" />
                    <input type="hidden" id="routingname" name="routingname" />
                    <input type="hidden" id="equipgubun" name="equipgubun" />
                    <input type="hidden" id="equipmentcode" name="equipmentcode" />
                    <input type="hidden" id="equipmentname" name="equipmentname" />
                    <input type="hidden" id="loginid" name="loginid" value='<c:out value="<%= loginVO.getId()%>"/>' />
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
                                <button type="button" class="yellow " onclick="fn_logout();" style="width: 185px; height: 63px; float: right';">
                                        나가기<br/>( LOGOUT )
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="width: 100%; height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
<!--                                 <button type="button" class="btn_work_home blue3 h " onclick="fn_goHome( );" style="width: 8%; height: 63px; float: left';">HOME</button> -->
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
                    <div id="gridArea" style="width: 100%; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
                </form>
            </div>
        </div>
        <!-- //content 끝 -->
    <!-- //전체 레이어 끝 -->
<div id="loadingBar" style="display: none;">
    <img src='<c:url value="/images/spinner.gif"></c:url>' alt="Loading"/>
</div>
</body>
</html>