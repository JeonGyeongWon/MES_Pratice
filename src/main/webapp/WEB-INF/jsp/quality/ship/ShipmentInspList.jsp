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

<style>
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
<script type="text/javaScript">
$(document).ready(function () {
	  setInitial();

	  setValues();
	  setExtGrid();

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  // 출하일자
	  calender($('#searchInspFrom, #searchInspTo, #searchFrom, #searchTo'));

	  $('#searchInspFrom, #searchInspTo,#searchFrom, #searchTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchInspFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchInspTo").val(getToDay("${searchVO.dateTo}") + "");
	  $("#searchFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchTo").val(getToDay("${searchVO.dateTo}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	    fn_option_change('QM', 'CHECK_YN', 'searchCheckYn');
	  });

	  gridnms["app"] = "quality";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_master();
	  setValues_detail();
	}

	function setValues_master() {
	  gridnms["models.master"] = [];
	  gridnms["stores.master"] = [];
	  gridnms["views.master"] = [];
	  gridnms["controllers.master"] = [];

	  gridnms["grid.1"] = "ShipmentInspMaster";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.master"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.master"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.master"].push(gridnms["model.1"]);

	  gridnms["stores.master"].push(gridnms["store.1"]);

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
	      name: 'SHIPINSNO',
	    }, {
	      type: 'date',
	      name: 'MFGDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'SHIPNO',
	    }, {
	      type: 'number',
	      name: 'SHIPSEQ',
	    }, {
	      type: 'date',
	      name: 'SHIPDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
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
	      name: 'SHIPGUBUN',
	    }, {
	      type: 'string',
	      name: 'SHIPGUBUNNAME',
	    }, {
	      type: 'number',
	      name: 'DETAILQTY',
	    }, {
	      type: 'number',
	      name: 'SHIPQTY',
	    }, {
	      type: 'number',
	      name: 'PASSQTY',
	    }, {
	      type: 'number',
	      name: 'FAULTQTY',
	    }, {
	      type: 'string',
	      name: 'CHECKYN',
	    }, {
	      type: 'string',
	      name: 'CHECKYNNAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'PERSONID',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, {
	      type: 'string',
	      name: 'MANAGEEMPLOYEE',
	    }, {
	      type: 'string',
	      name: 'MANAGENAME',
	    }, {
	      type: 'string',
	      name: 'MFGNO',
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'SHIPINSNO',
	      text: '출하검사번호',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
	        var result = '<div><a href="{0}">{1}</a></div>';
	        var url = "<c:url value='/quality/ship/ShipmentInspManage.do?no=' />" + record.data.SHIPINSNO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
	        return Ext.String.format(result, url, value);
	      }
	    }, {
	      dataIndex: 'MFGDATE',
	      text: '검사일',
	      xtype: 'datecolumn',
	      width: 90,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
	        var result = '<div><a href="{0}">{1}</a></div>';
	        var url = "<c:url value='/quality/ship/ShipmentInspManage.do?no=' />" + record.data.SHIPINSNO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
	        return Ext.String.format(result, url, Ext.util.Format.date(value, 'Y-m-d'));
	      }
	    }, {
	      dataIndex: 'SHIPNO',
	      text: '출하번호',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
	        var result = '<div><a href="{0}">{1}</a></div>';
	        var url = "<c:url value='/quality/ship/ShipmentInspManage.do?no=' />" + record.data.SHIPINSNO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
	        return Ext.String.format(result, url, value);
	      }
	    }, {
	      dataIndex: 'SHIPDATE',
	      text: '출하일',
	      xtype: 'datecolumn',
	      width: 90,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
	        var result = '<div><a href="{0}">{1}</a></div>';
	        var url = "<c:url value='/quality/ship/ShipmentInspManage.do?no=' />" + record.data.SHIPINSNO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
	        return Ext.String.format(result, url, Ext.util.Format.date(value, 'Y-m-d'));
	      }
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
	        if (value) {

	          var result = '<div><a href="{0}">{1}</a></div>';
	          var url = "<c:url value='/quality/ship/ShipmentInspManage.do?no=' />" + record.data.SHIPINSNO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
	          return Ext.String.format(result, url, value);
	        }
	      }
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'DRAWINGNO',
	      text: '도번',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 280,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'SHIPGUBUNNAME',
	      text: '매출구분',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'DETAILQTY',
	      text: '출하<br/>수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'SHIPQTY',
	      text: '검사<br/>수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'PASSQTY',
	      text: '합격<br/>수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'FAILQTY',
	      text: '불합격<br/>수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'CHECKYNNAME',
	      text: '결과',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'KRNAME',
	      text: '검사자',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'MANAGENAME',
	      text: '품질책임자',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'MFGNO',
	      text: 'LOT번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPGUBUN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'PERSONID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MANAGEEMPLOYEE',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/quality/ship/ShipmentInspMaster.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnList": {
	      itemclick: 'onMasterClick'
	    }
	  });

	  items["dock.paging.1"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.1"],
	  };

	  items["dock.btn.1"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.1"],
	    items: items["btns.1"],
	  };

	  items["docked.1"] = [];
	}

	function onMasterClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var shipinsno = record.data.SHIPINSNO;

	  var params = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SHIPINSNO: shipinsno,
	  };

	  extGridSearch(params, gridnms["store.2"]);
	}

	function setValues_detail() {

	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.2"] = "ShipmentInspDetail";

	  gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  gridnms["views.detail"].push(gridnms["panel.2"]);

	  gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  gridnms["controllers.detail"].push(gridnms["controller.2"]);

	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.detail"].push(gridnms["model.2"]);

	  gridnms["stores.detail"].push(gridnms["store.2"]);

	  fields["model.2"] = [{
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
	      name: 'SHIPINSNO',
	    }, {
	      type: 'string',
	      name: 'SHIPINSPECTIONNO',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'number',
	      name: 'CHECKLISTID',
	    }, {
	      type: 'number',
	      name: 'ORDERNO',
	    }, {
	      type: 'string',
	      name: 'CHECKMIDDLE',
	    }, {
	      type: 'string',
	      name: 'CHECKMIDDLENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSMALL',
	    }, {
	      type: 'string',
	      name: 'CHECKSMALLNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKUOM',
	    }, {
	      type: 'string',
	      name: 'CHECKUOMNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSTANDARD',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE',
	    }, {
	      type: 'string',
	      name: 'MAXVALUE',
	    }, {
	      type: 'string',
	      name: 'MINVALUE',
	    }, {
	      type: 'string',
	      name: 'EXTSTANDARD',
	    }, {
	      type: 'number',
	      name: 'CHECKQTY',
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
	      name: 'CHECKYN',
	    }, {
	      type: 'string',
	      name: 'CHECKYNNAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'PERSONID',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, ];

	  fields["columns.2"] = [
	    // Display Columns
	    {
	      dataIndex: 'ORDERNO',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'CHECKSMALLNAME',
	      text: '검사항목',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKUOMNAME',
	      text: '검사단위',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKSTANDARD',
	      text: '검사내용',
	      xtype: 'gridcolumn',
	      width: 350,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'STANDARDVALUE',
	      text: '검사기준',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'MINVALUE',
	      text: '허용치<br/>(하한)',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'MAXVALUE',
	      text: '허용치<br/>(상한)',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'EXTSTANDARD',
	      text: '규정',
	      xtype: 'gridcolumn',
	      width: 350,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT1',
	      text: 'X1',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT2',
	      text: 'X2',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT3',
	      text: 'X3',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT4',
	      text: 'X4',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT5',
	      text: 'X5',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT6',
	      text: 'X6',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT7',
	      text: 'X7',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT8',
	      text: 'X8',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT9',
	      text: 'X9',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKRESULT10',
	      text: 'X10',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //      }, {
	      //        dataIndex: 'CHECKYNNAME',
	      //        text: '판정',
	      //        xtype: 'gridcolumn',
	      //        width: 65,
	      //         hidden: false,
	      //         sortable: false,
	      //         resizable: false,
	      //         menuDisabled: true,
	      //        align: "center",
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPINSNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPINSPECTIONNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKLISTID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMIDDLE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMIDDLENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKSMALL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKUOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKQTY',
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
	    },
	  ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/quality/ship/ShipmentInspDetail.do' />"
	  });

	  items["btns.2"] = [];

	  items["btns.ctr.2"] = {};

	  items["dock.paging.2"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.2"],
	  };

	  items["dock.btn.2"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.2"],
	    items: items["btns.2"],
	  };

	  items["docked.2"] = [];
	}

	var gridarea, gridarea1;
	function setExtGrid() {
	  setExtGrid_master();
	  setExtGrid_detail();

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	    gridarea1.updateLayout();
	  });
	}

	function setExtGrid_master() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
	  });

	  Ext.define(gridnms["store.1"], {
	    extend: Ext.data.JsonStore, // Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.1"],
	            model: gridnms["model.1"],
	            autoLoad: true,
	            isStore: false,
	            autoDestroy: true,
	            clearOnPageLoad: true,
	            clearRemovedOnLoad: true,
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                INSPFROM: '${searchVO.dateFrom}',
	                INSPTO: '${searchVO.dateTo}',
	                SEARCHFROM: '${searchVO.dateFrom}',
	                SEARCHTO: '${searchVO.dateTo}',
	                GUBUN: 'LIST',
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnList: '#btnList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    onMasterClick: onMasterClick,
	  });

	  Ext.define(gridnms["panel.1"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.1"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel',
	        itemId: gridnms["panel.1"],
	        id: gridnms["panel.1"],
	        store: gridnms["store.1"],
	        height: 362,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'btnList',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 120) {
	                    column.width = 120;
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
	    models: gridnms["models.master"],
	    stores: gridnms["stores.master"],
	    views: gridnms["views.master"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.master"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });

	}

	function setExtGrid_detail() {
	  Ext.define(gridnms["model.2"], {
	    extend: Ext.data.Model,
	    fields: fields["model.2"],
	  });

	  Ext.define(gridnms["store.2"], {
	    extend: Ext.data.JsonStore, // Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.2"],
	            model: gridnms["model.2"],
	            autoLoad: true,
	            isStore: false,
	            autoDestroy: true,
	            clearOnPageLoad: true,
	            clearRemovedOnLoad: true,
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.2"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                INSPFROM: '${searchVO.dateFrom}',
	                INSPTO: '${searchVO.dateTo}',
	                SEARCHFROM: '${searchVO.dateFrom}',
	                SEARCHTO: '${searchVO.dateTo}',
	                GUBUN: 'LIST',
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.2"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnList: '#btnListDetail',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],
	  });

	  Ext.define(gridnms["panel.2"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.2"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel',
	        itemId: gridnms["panel.2"],
	        id: gridnms["panel.2"],
	        store: gridnms["store.2"],
	        height: 200,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'btnListDetail',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('CHECKSMALLNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 100) {
	                    column.width = 100;
	                  }
	                }

	                if (column.dataIndex.indexOf('CHECKSTANDARD') >= 0 || column.dataIndex.indexOf('EXTSTANDARD') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 150) {
	                    column.width = 150;
	                  }
	                }
	              });
	            }
	          },
	        },
	        bufferedRenderer: false,
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	          }
	        ],
	        dockedItems: items["docked.2"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.detail"],
	    stores: gridnms["stores.detail"],
	    views: gridnms["views.detail"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      gridarea1 = Ext.create(gridnms["views.detail"], {
	          renderTo: 'gridAreaDetail'
	        });
	    },
	  });

	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var datefrom = $('#searchInspFrom').val();
	  var dateto = $('#searchInspTo').val();
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

	  if (datefrom === "") {
	    header.push("검사일자 From");
	    count++;
	  }

	  if (dateto === "") {
	    header.push("검사일자 To");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력(선택)해주세요.");
	    result = false;
	  }

	  return result;
	}

	function fn_search() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var datefrom = $('#searchInspFrom').val();
	  var dateto = $('#searchInspTo').val();
	  var inspno = $('#searchInspNo').val();
	  var checkyn = $('#searchCheckYn option:selected').val();
	  var searchfrom = $('#searchFrom').val();
	  var searchto = $('#searchTo').val();
	  var shipno = $('#searchShipNo').val();
	  var customercode = $('#searchCustomerCode').val();
	  var itemcode = $('#searchItemCode').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    INSPFROM: datefrom,
	    INSPTO: dateto,
	    SHIPINSNO: inspno,
	    CHECKYN: checkyn,
	    SEARCHFROM: searchfrom,
	    SEARCHTO: searchto,
	    SHIPNO: shipno,
	    CUSTOMERCODE: customercode,
	    ITEMCODE: itemcode,
	    GUBUN: 'LIST',
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.2"]);
	  }, 300);
	}

	function fn_save() {
	  go_url("<c:url value='/quality/ship/ShipmentInspManage.do'/>");
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 검사번호 Lov
	  $("#searchInspNo").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  }).focus(
	    function (e) {
	    $(this).autocomplete("search",
	      (this.value === "") ? "%" : this.value);
	  }).autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/select/order/ship/ShipInspectionMaster.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        SEARCHFROM: $('#searchInspFrom').val(),
	        SEARCHTO: $('#searchInspTo').val(),
	        GUBUN: "LIST",
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.SHIPINSNO,
	              label: m.SHIPINSNO,
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
	      $("#searchInspNo").val(o.item.value);

	      return false;
	    }
	  });

	  // 출하번호 Lov
	  $("#searchShipNo").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchShipNo").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  }).focus(
	    function (e) {
	    $(this).autocomplete("search",
	      (this.value === "") ? "%" : this.value);
	  }).autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchShipNoFindLovList.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        SEARCHFROM: $('#searchFrom').val(),
	        SEARCHTO: $('#searchTo').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.SHIPNO,
	              label: m.SHIPNO,
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
	      $("#searchShipNo").val(o.item.value);

	      return false;
	    }
	  });

	  // 거래처명 Lov
	  $("#searchCustomerName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchCustomerName").val("");
	      $("#searchCustomerCode").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  }).focus(
	    function (e) {
	    $(this).autocomplete("search",
	      (this.value === "") ? "%" : this.value);
	  }).autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchCustomernameLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        CUSTOMERTYPE1: 'S',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL + ", " + m.CUSTOMERTYPENAME + ", " + m.ADDRESS,
	              NAME: m.LABEL,
	              ADDRESS: m.ADDRESS,
	              FREIGHT: m.FREIGHT,
	              PHONENUMBER: m.PHONENUMBER,
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
	      $("#searchCustomerCode").val(o.item.value);
	      $("#searchCustomerName").val(o.item.NAME);

	      return false;
	    }
	  });

	  // 품번 Lov
	  $("#searchOrderName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchItemCode").val("");
	      $("#searchItemName").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })
	  .bind("keyup", function (e) {
	    if (this.value === "")
	      $(this).autocomplete("search", "%");
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .click(function (e) {
	    $(this).autocomplete("search", "%");
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GUBUN: 'ORDERNAME', // 제품, 반제품 조회
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.ORDERNAME + ', ' + m.ITEMNAME,
	              value: m.ITEMCODE,
	              ITEMNAME: m.ITEMNAME,
	              ORDERNAME: m.ORDERNAME,
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
	      $("#searchItemCode").val(o.item.value);
	      $("#searchItemName").val(o.item.ITEMNAME);
	      $("#searchOrderName").val(o.item.ORDERNAME);
	      return false;
	    }
	  });

	  // 품명 Lov
	  $("#searchItemName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchItemCode").val("");
	      $("#searchOrderName").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })
	  .bind("keyup", function (e) {
	    if (this.value === "")
	      $(this).autocomplete("search", "%");
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .click(function (e) {
	    $(this).autocomplete("search", "%");
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GUBUN: 'ITEMNAME', // 제품, 반제품 조회
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.ITEMNAME + ', ' + m.ORDERNAME,
	              value: m.ITEMCODE,
	              ITEMNAME: m.ITEMNAME,
	              ORDERNAME: m.ORDERNAME,
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
	      $("#searchItemCode").val(o.item.value);
	      $("#searchItemName").val(o.item.ITEMNAME);
	      $("#searchOrderName").val(o.item.ORDERNAME);
	      return false;
	    }
	  });
	}

	function setReadOnly() {
	  $("[readonly]").addClass("ui-state-disabled");
	}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;">
	<!-- 전체 레이어 시작 -->
    <div id="wrap">
        <!-- header 시작 -->
        <div id="header">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncHeader" />
        </div>
        <div id="topnavi">
            <c:import url="/sym/mms/EgovMainMenuHead.do" />
        </div>
        <!-- //header 끝 -->
        <!-- container 시작 -->
        <div id="container">
            <!-- 좌측메뉴 시작 -->
            <div id="leftmenu">
                <c:import url="/sym/mms/EgovMainMenuLeft.do" />
            </div>
            <!-- //좌측메뉴 끝 -->
            <!-- 현재위치 네비게이션 시작 -->
            <div id="content">
                    <div id="cur_loc">
                        <div id="cur_loc_align">
                            <ul>
                                <li>HOME</li>
                                <li>&gt;</li>
                                <li>출하검사</li>
                                <li>&gt;</li>
                                <li><strong>${pageTitle}</strong></li>
                            </ul>
                        </div>
                    </div>
                    <!-- 검색 필드 박스 시작 -->
                    <div id="search_field">
                        <div id="search_field_loc">
                            <h2>
                                <strong>${pageTitle}</strong>
                            </h2>
                        </div>
                        <input type="hidden" id="orgid" />
                        <input type="hidden" id="companyid" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                        <input type="hidden" id="searchItemCode" name="searchItemCode" />
                            <div>
                                <table class="tbl_type_view" border="0">
																		<colgroup>
																				<col width="23%">
                                        <col width="23%">
                                        <col width="43%">
																		</colgroup>
																		<tr style="height: 34px;">
                                        <td>
                                            <select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 50%;">
                                                <c:forEach var="item" items="${labelBox.findByOrgId}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.ORGID}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td>
                                            <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 50%;">
                                                <c:forEach var="item" items="${labelBox.findByCompanyId}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.COMPANYID}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td >
                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
                                                   조회
                                                </a>
                                                <a id="btnChk3" class="btn_add" href="#" onclick="javascript:fn_save();">
                                                   추가
                                                </a>
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="12%">
                                        <col width="22%">
                                        <col width="12%">
                                        <col width="22%">
                                        <col width="12%">
                                        <col width="22%">
                                    </colgroup>
                                    
                                    <tr style="height: 34px;">
                                        <th class="required_text">검사일자</th>
                                        <td >
                                            <input type="text" id="searchInspFrom" name="searchInspFrom" class="input_validation input_center " style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchInspTo" name="searchInspTo" class="input_validation input_center " style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">출하검사번호</th>
                                        <td>
                                            <input type="text" id="searchInspNo" name="searchInspNo" class="input_left"  style="width: 97%;" />
                                        </td>                                        
                                        <th class="required_text">결과</th>
                                        <td>
                                            <select id="searchCheckYn" name="searchCheckYn" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.CHECKYN}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByCheckYn}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.CHECKYN}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">출하일자</th>
                                        <td >
                                            <input type="text" id="searchFrom" name="searchFrom" class=" input_center " style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchTo" name="searchTo" class=" input_center " style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">출하번호</th>
                                        <td>
                                            <input type="text" id="searchShipNo" name="searchShipNo" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">거래처</th>
                                        <td>
                                            <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left"  style="width: 97%;" />
                                            <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" class=""  />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->
                    
                <div style="width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">기본 정보</div></td>
                        </tr>
                    </table>
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">상세 정보</div></td>
                        </tr>
                    </table>
                    <div id="gridAreaDetail" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
            </div>
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>