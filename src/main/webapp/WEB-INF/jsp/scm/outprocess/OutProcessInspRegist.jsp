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
	  calender($('#searchInspFrom, #searchInspTo'));

	  $('#searchInspFrom, #searchInspTo').keyup(function (event) {
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

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  if ("${searchVO.CustomerCode}" == "admin") {}
	  else {
	    $('#searchCustomerName').attr('disabled', true);
	    $("#searchCustomerName").val("${searchVO.CustomerName}");
	    $("#searchCustomerCode").val("${searchVO.CustomerCode}");
	  }

	  gridnms["app"] = "scm";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.viewer"] = [];
	  gridnms["stores.viewer"] = [];
	  gridnms["views.viewer"] = [];
	  gridnms["controllers.viewer"] = [];

	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.1"] = "master";
	  gridnms["grid.2"] = "detail";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.viewer"].push(gridnms["panel.1"]);

	  gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  gridnms["views.detail"].push(gridnms["panel.2"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.viewer"].push(gridnms["controller.1"]);

	  gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  gridnms["controllers.detail"].push(gridnms["controller.2"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.viewer"].push(gridnms["model.1"]);
	  gridnms["models.detail"].push(gridnms["model.2"]);

	  gridnms["stores.viewer"].push(gridnms["store.1"]);
	  gridnms["stores.detail"].push(gridnms["store.2"]);

	  fields["model.1"] = [{
	      type: 'number',
	      name: 'RN',
	    }, {
	      type: 'string',
	      name: 'INSPECTIONPLANNO',
	    }, {
	      type: 'date',
	      name: 'INSPECTIONDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'WORKORDERID',
	    }, {
	      type: 'number',
	      name: 'CHECKQTY',
	    }, {
	      type: 'number',
	      name: 'CHECKYN',
	    }, {
	      type: 'string',
	      name: 'CHECKYNNAME',
	    }, {
	      type: 'number',
	      name: 'PASSQTY',
	    }, {
	      type: 'number',
	      name: 'FAILQTY',
	    }, {
	      type: 'string',
	      name: 'FAILTYPE',
	    }, {
	      type: 'number',
	      name: 'NONCHECKQTY',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'ORDERNO',
	    }, {
	      type: 'number',
	      name: 'ORDERSEQ',
	    }, {
	      type: 'date',
	      name: 'PODATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAME',
	    }, {
	      type: 'date',
	      name: 'DUEDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'SCMDUEDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	      //      }, {
	      //        type: 'string',
	      //        name: 'ITEMSTANDARD',
	      //      }, {
	      //        type: 'string',
	      //        name: 'MATERIALTYPE',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'string',
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
	    }, {
	      type: 'number',
	      name: 'ORDERQTY',
	    }, {
	      type: 'number',
	      name: 'RETURNQTY',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
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
	      dataIndex: 'INSPECTIONPLANNO',
	      text: '검사번호',
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
	        var url = "<c:url value='/scm/outprocess/OutProcessInspRegistD.do?no=' />" + record.get("INSPECTIONPLANNO") + "&org=" + record.get("ORGID") + "&company=" + record.get("COMPANYID");
	        return Ext.String.format(result, url, value);
	      }
	    }, {
	      dataIndex: 'INSPECTIONDATE',
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
	    }, {
	      dataIndex: 'WORKORDERID',
	      text: '작업지시번호',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //      }, {
	      //        dataIndex: 'INSPECTIONDATE',
	      //        text: '발주일',
	      //        xtype: 'datecolumn',
	      //        width: 90,
	      //        hidden: false,
	      //        sortable: true,
	      //        align: "center",
	      //        format: 'Y-m-d',
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '공급사',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
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
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //      }, {
	      //        dataIndex: 'ITEMSTANDARD',
	      //        text: '규격',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        align: "center",
	      //      }, {
	      //        dataIndex: 'MATERIALTYPE',
	      //        text: '재질',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        align: "center",
	    }, {
	      dataIndex: 'ORDERQTY',
	      text: '발주<br/>수량',
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
	      dataIndex: 'CHECKQTY',
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
	      width: 60,
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
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    },
	  ];

	  fields["model.2"] = [{
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
	      name: 'INSPECTIONPLANNO',
	    }, {
	      type: 'string',
	      name: 'INSPECTIONSEQ',
	    }, {
	      type: 'string',
	      name: 'CHECKSEQ',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKYN',
	    }, {
	      type: 'string',
	      name: 'CHECKYNNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKBIG',
	    }, {
	      type: 'string',
	      name: 'CHECKBIGNAME',
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
	      name: 'UOMNAME',
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
	      name: 'PERSONID',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, ];

	  fields["columns.2"] = [
	    // Display Columns
	    {
	      dataIndex: 'INSPECTIONSEQ',
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
        dataIndex: 'CHECKMIDDLENAME',
        text: '검사분류',
        xtype: 'gridcolumn',
        width: 100,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        align: "center",
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
	      dataIndex: 'UOMNAME',
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
	      width: 95,
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
	      width: 85,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'MAXVALUE',
	      text: '허용치<br/>(상한)',
	      xtype: 'gridcolumn',
	      width: 85,
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
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 250,
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
	      dataIndex: 'INSPECTIONPLANNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'INSPECTIONSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'PERSONID',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/scm/outprocess/OutProcessInspMasterRegist.do' />"
	  });

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/scm/outprocess/OutProcessInspDetailRegist.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnList": {
	      itemclick: 'onMyviewItemcodelistClick'
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

	function onMyviewItemcodelistClick(dataview, record, item, index, e, eOpts) {
	  $("#inspno").val(record.get("INSPECTIONPLANNO"));
	  $("#orgid").val(record.get("ORGID"));
	  $("#companyid").val(record.get("COMPANYID"));
	  var InspNoVal = $('#inspno').val();
	  var OrgIdVal = $('#orgid').val();
	  var CompanyIdVal = $('#companyid').val();

	  var params = {
	    INSPECTIONPLANNO: InspNoVal,
	    ORGID: OrgIdVal,
	    COMPANYID: CompanyIdVal,
	  };

	  extGridSearch(params, gridnms["store.2"]);
	}

	var gridarea;
	var gridareadetail;

	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
	  });

	  Ext.define(gridnms["model.2"], {
	    extend: Ext.data.Model,
	    fields: fields["model.2"],
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
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                INSPFROM: '${searchVO.dateFrom}',
	                INSPTO: '${searchVO.dateTo}',
	                CUSTOMERCODE: $('#searchCustomerCode').val(),
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
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                INSPFROM: '${searchVO.dateFrom}',
	                INSPTO: '${searchVO.dateTo}',
                  CUSTOMERCODE: $('#searchCustomerCode').val(),	                
	                GUBUN: 'Y',
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

	    onMyviewItemcodelistClick: onMyviewItemcodelistClick,
	  });

	  Ext.define(gridnms["controller.2"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnList: '#btnListDetail',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],
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
	                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
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

	  Ext.define(gridnms["panel.2"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.2"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.2"],
	        id: gridnms["panel.2"],
	        store: gridnms["store.2"],
	        height: 234,
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

	                if (column.dataIndex.indexOf('CHECKSTANDARD') >= 0) {
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
	    models: gridnms["models.viewer"],
	    stores: gridnms["stores.viewer"],
	    views: gridnms["views.viewer"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.viewer"], {
	          renderTo: 'gridViewArea'
	        });
	    },
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.detail"],
	    stores: gridnms["stores.detail"],
	    views: gridnms["views.detail"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      gridareadetail = Ext.create(gridnms["views.detail"], {
	          renderTo: 'gridViewAreaDetail'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	    gridareadetail.updateLayout();
	  });
	}

	function fn_search() {
	  // 필수 체크
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var inspfrom = $('#searchInspFrom').val();
	  var inspto = $('#searchInspTo').val();
	  var itemname = $('#searchItemName').val();
	  var ordername = $('#searchOrderName').val();
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

	  if (inspfrom === "") {
	    header.push("검사일자 From");
	    count++;
	  }

	  if (inspto === "") {
	    header.push("검사일자 To");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return;
	  }

	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    INSPFROM: $('#searchInspFrom').val(),
	    INSPTO: $('#searchInspTo').val(),
	    INSPECTIONPLANNO: $('#searchInspNo').val(),
	    CUSTOMERCODE: $('#searchCustomerCode').val(),
	    //      ITEMCODE: $('#searchItemCode').val(),
	    ITEMNAME: itemname,
	    ORDERNAME: ordername,
	    GUBUN: 'Y',
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.2"]);
	  }, 300);
	}

	function fn_save() {
	  go_url("<c:url value='/scm/outprocess/OutProcessInspRegistD.do'/>");
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
	      //             $("#PorNo").val("");
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
	      $.getJSON("<c:url value='/scm/outprocess/OutProcessInspNoListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        INSPFROM: $('#searchInspFrom').val(),
	        INSPTO: $('#searchInspTo').val(),
	        INSPECTIONPLANNO: $('#searchInspNo').val(),
	        CUSTOMERCODE: $('#searchCustomerCode').val(),
	        CHECKTYPE: 'L',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.INSPECTIONPLANNO,
	              label: m.INSPECTIONPLANNO,
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
	        //CUSTOMERTYPE: 'A',
	        CUSTOMERTYPE2: 'O',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL + ", " + m.CUSTOMERTYPENAME,
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

	  //    // 품번 Lov
	  //    $("#searchOrderName")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        $("#searchItemCode").val("");
	  //        $("#searchItemName").val("");
	  //        break;
	  //      case $.ui.keyCode.ENTER:
	  //        $(this).autocomplete("search", "%");
	  //        break;

	  //      default:
	  //        break;
	  //      }
	  //    })
	  //    .bind("keyup", function (e) {
	  //      if (this.value === "")
	  //        $(this).autocomplete("search", "%");
	  //    })
	  //    .focus(function (e) {
	  //      $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  //    })
	  //    .click(function (e) {
	  //      $(this).autocomplete("search", "%");
	  //    })
	  //    .autocomplete({
	  //      source: function (request, response) {
	  //        $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	  //          keyword: extractLast(request.term),
	  //          ORGID: $('#searchOrgId option:selected').val(),
	  //          COMPANYID: $('#searchCompanyId option:selected').val(),
	  //          CUSTOMERCODE: $('#searchCustomerCode').val(),
	  //          MATGUBUN: 'ORDERNAME', // 제품, 반제품 조회
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ORDERNAME + ', ' + m.ITEMNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //              });
	  //            }));
	  //        });
	  //      },
	  //      search: function () {
	  //        if (this.value === "")
	  //          return;

	  //        var term = extractLast(this.value);
	  //        if (term.length < 1) {
	  //          return false;
	  //        }
	  //      },
	  //      focus: function () {
	  //        return false;
	  //      },
	  //      select: function (e, o) {
	  //        $("#searchItemCode").val(o.item.value);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ORDERNAME);
	  //        return false;
	  //      }
	  //    });

	  //    // 품명 Lov
	  //    $("#searchItemName")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        $("#searchItemCode").val("");
	  //        $("#searchOrderName").val("");
	  //        break;
	  //      case $.ui.keyCode.ENTER:
	  //        $(this).autocomplete("search", "%");
	  //        break;

	  //      default:
	  //        break;
	  //      }
	  //    })
	  //    .bind("keyup", function (e) {
	  //      if (this.value === "")
	  //        $(this).autocomplete("search", "%");
	  //    })
	  //    .focus(function (e) {
	  //      $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  //    })
	  //    .click(function (e) {
	  //      $(this).autocomplete("search", "%");
	  //    })
	  //    .autocomplete({
	  //      source: function (request, response) {
	  //        $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	  //          keyword: extractLast(request.term),
	  //          ORGID: $('#searchOrgId option:selected').val(),
	  //          COMPANYID: $('#searchCompanyId option:selected').val(),
	  //          CUSTOMERCODE: $('#searchCustomerCode').val(),
	  //          MATGUBUN: 'ITEMNAME', // 제품, 반제품 조회
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ITEMNAME + ', ' + m.ORDERNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //              });
	  //            }));
	  //        });
	  //      },
	  //      search: function () {
	  //        if (this.value === "")
	  //          return;

	  //        var term = extractLast(this.value);
	  //        if (term.length < 1) {
	  //          return false;
	  //        }
	  //      },
	  //      focus: function () {
	  //        return false;
	  //      },
	  //      select: function (e, o) {
	  //        $("#searchItemCode").val(o.item.value);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ORDERNAME);
	  //        return false;
	  //      }
	  //    });
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
                                <li>외주공정관리</li>
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
                        <input type="hidden" id="orgid" value="<c:out value='${OrgIdVal}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${CompanyIdVal}'/>" />
                        <input type="hidden" id="inspno" value="<c:out value='${InspNoVal}'/>" />
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
                                        <td>
                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
                                                   조회
                                                </a>
                                                <a id="btnChk2" class="btn_add" href="#" onclick="javascript:fn_save();">
                                                   추가
                                                </a>
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="120px">
                                        <col>
                                        <col width="120px">
                                        <col>
                                        <col width="120px">
                                        <col>
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">검사일자</th>
                                        <td >
                                            <input type="text" id="searchInspFrom" name="searchInspFrom" class="input_validation input_center validate[custom[date],past[#searchInspTo]]" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchInspTo" name="searchInspTo" class="input_validation input_center validate[custom[date],future[#searchInspFrom]]" style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">검사번호</th>
                                        <td>
                                            <input type="text" id="searchInspNo" name="searchInspNo" class="input_center"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">가공처</th>
                                        <td>
                                            <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_center"  style="width: 97%;" />
                                            <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" class=""  />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
                                        <td></td>
                                        <td></td>
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
                    <div id="gridViewArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">상세 정보</div></td>
                        </tr>
                    </table>
                    <div id="gridViewAreaDetail" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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