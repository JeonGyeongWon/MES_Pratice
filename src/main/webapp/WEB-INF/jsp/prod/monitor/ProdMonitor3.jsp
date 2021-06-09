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

.blue2 {
    background-color: #5B9BD5;
    color: white;
    cursor: default;
}

.r {
    border-radius: 4px 4px 4px 4px;
    -moz-border-radius: 4px 4px 4px 4px;
    -webkit-border-radius: 4px 4px 4px 4px;
    border: 0px solid #000000;
}
</style>

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

	  setLovList();
	  setReadOnly();
	});

	function setInitial() {
	  calender($('#searchFrom, #searchTo'));
	  $('#searchFrom, #searchTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchFrom").val(getToDay("${searchVO.DATEFROM}") + "");
	  $("#searchTo").val(getToDay("${searchVO.DATETO}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_work();
	  setValues_trans();
	  setValues_warehousing();
	}

	function setValues_work() {
	  gridnms["models.work"] = [];
	  gridnms["stores.work"] = [];
	  gridnms["views.work"] = [];
	  gridnms["controllers.work"] = [];

	  gridnms["grid.1"] = "LotHistoryWorkList";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.work"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.work"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.work"].push(gridnms["model.1"]);

	  gridnms["stores.work"].push(gridnms["store.1"]);

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
	      name: 'LOTNO',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'number',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'ROUTINGOP',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERCODE',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERNAME',
	    }, {
	      type: 'date',
	      name: 'WORKSTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'WORKENDDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'PRODUCEDQTY',
	    }, {
	      type: 'number',
	      name: 'IMPORTQTY',
	    }, {
	      type: 'number',
	      name: 'FAULTQTY',
	      //    }, {
	      //      type: 'string',
	      //      name: 'FIRSTLOTNO',
	    }, {
	      type: 'string',
	      name: 'TRANSLOT',
	    }, {
	      type: 'string',
	      name: 'LASTLOTNO',
	    }, {
	      type: 'string',
	      name: 'WAREHOUSINGLOT',
	    }
	  ];

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
	      //    }, {
	      //      dataIndex: 'FIRSTLOTNO',
	      //      text: '첫공정 생산 LOT',
	      //      xtype: 'gridcolumn',
	      //      width: 110,
	      //      hidden: false,
	      //      sortable: false,
	      //      align: "center",
	    }, {
	      dataIndex: 'LOTNO',
	      text: 'LOT NO',
	      xtype: 'gridcolumn',
	      width: 110,
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
	      width: 150,
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
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ROUTINGOP',
	      text: '공정순번',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ROUTINGNAME',
	      text: '공정',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'WORKCENTERNAME',
	      text: '설비',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'WORKSTARTDATE',
	      text: '작업시작일',
	      xtype: 'datecolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'WORKENDDATE',
	      text: '작업종료일',
	      xtype: 'datecolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'PRODUCEDQTY',
	      text: '생산수량',
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
	      dataIndex: 'IMPORTQTY',
	      text: '양품수량',
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
	      dataIndex: 'FAULTQTY',
	      text: '불량수량',
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
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKCENTERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'TRANSLOT',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LASTLOTNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WAREHOUSINGLOT',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/monitor/ProdMonitor3Work.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#LotHistoryWorkList": {
	      itemclick: 'onWorkClick'
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

	function onWorkClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var lotno = record.data.LOTNO;
	  var searchFrom = $("#searchFrom").val();
	  var searchTo = $("#searchTo").val();
	  var itemcode = record.data.ITEMCODE;
	  var translotno = record.data.TRANSLOT;
	  var warehousinglotno = record.data.WAREHOUSINGLOT;
	  var lastlotno = record.data.LASTLOTNO;

	  $('#itemcode').val(itemcode);

	  var params = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHFROM: searchFrom,
	    SEARCHTO: searchTo,
	    ITEMCODE: itemcode,
	    LOTNO: lotno,
	    TRANSLOT: translotno,
	    LASTLOTNO: lastlotno,
	  };

	  if (translotno != "") {
	    extGridSearch(params, gridnms["store.2"]);
	  } else {

	    Ext.getStore(gridnms["store.2"]).removeAll();
	  }

	  if (warehousinglotno != "") {
	    setTimeout(function () {
	      extGridSearch(params, gridnms["store.3"]);
	    }, 400);
	  } else {

	    Ext.getStore(gridnms["store.3"]).removeAll();
	  }

	  fn_label_display(lotno, warehousinglotno, translotno);
	}

	function setValues_trans() {
	  gridnms["models.trans"] = [];
	  gridnms["stores.trans"] = [];
	  gridnms["views.trans"] = [];
	  gridnms["controllers.trans"] = [];

	  gridnms["grid.2"] = "LotHistoryTransList";

	  gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  gridnms["views.trans"].push(gridnms["panel.2"]);

	  gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  gridnms["controllers.trans"].push(gridnms["controller.2"]);

	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.trans"].push(gridnms["model.2"]);

	  gridnms["stores.trans"].push(gridnms["store.2"]);

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
	      name: 'LOTNO',
	    }, {
	      type: 'string',
	      name: 'TRANSLOT',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'TRANSNO',
	    }, {
	      type: 'number',
	      name: 'TRANSSEQ',
	    }, {
	      type: 'date',
	      name: 'TRANSDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'LOTQTY',
	    }
	  ];

	  fields["columns.2"] = [
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
	    }, {
	      dataIndex: 'TRANSLOT',
	      text: 'LOT NO',
	      xtype: 'gridcolumn',
	      width: 250,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '제품 품번',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '제품 품명',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      text: '입하정보',
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      columns: [{
	          dataIndex: 'TRANSNO',
	          text: '입하번호',
	          xtype: 'gridcolumn',
	          width: 100,
	          hidden: false,
	          sortable: true,
	          resizable: false,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "center",
	        }, {
	          dataIndex: 'TRANSSEQ',
	          text: '순번',
	          xtype: 'gridcolumn',
	          width: 50,
	          hidden: false,
	          sortable: false,
	          resizable: false,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "center",
	        }, ]
	    }, {
	      dataIndex: 'TRANSDATE',
	      text: '입하일자',
	      xtype: 'datecolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'LOTQTY',
	      text: '사용중량',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LOTNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/prod/monitor/ProdMonitor3Trans.do' />"
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

	function setValues_warehousing() {
	  gridnms["models.warehousing"] = [];
	  gridnms["stores.warehousing"] = [];
	  gridnms["views.warehousing"] = [];
	  gridnms["controllers.warehousing"] = [];

	  gridnms["grid.3"] = "LotHistoryWarehousingList";

	  gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
	  gridnms["views.warehousing"].push(gridnms["panel.3"]);

	  gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
	  gridnms["controllers.warehousing"].push(gridnms["controller.3"]);

	  gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

	  gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

	  gridnms["models.warehousing"].push(gridnms["model.3"]);

	  gridnms["stores.warehousing"].push(gridnms["store.3"]);

	  fields["model.3"] = [{
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
	      name: 'LOTNO',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'CUSTLOTNO',
	    }, {
	      type: 'string',
	      name: 'SHIPNO',
	    }, {
	      type: 'date',
	      name: 'SHIPDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'SHIPQTY',
	    }
	  ];

	  fields["columns.3"] = [
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
	    }, {
	      dataIndex: 'SHIPNO',
	      text: 'LOT NO',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'SHIPDATE',
	      text: '출고일',
	      xtype: 'datecolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 150,
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
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'LOTNO',
	      text: '생산 LOT NO',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'SHIPQTY',
	      text: '출고수량',
	      xtype: 'gridcolumn',
	      width: 90,
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
	      dataIndex: 'CUSTLOTNO',
	      text: '고객 LOT',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, ];

	  items["api.3"] = {};
	  $.extend(items["api.3"], {
	    read: "<c:url value='/select/prod/monitor/ProdMonitor3Warehousing.do' />"
	  });

	  items["btns.3"] = [];

	  items["btns.ctr.3"] = {};

	  items["dock.paging.3"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.3"],
	  };

	  items["dock.btn.3"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.3"],
	    items: items["btns.3"],
	  };

	  items["docked.3"] = [];
	}

	var gridarea, gridarea1, gridarea2;
	function setExtGrid() {
	  setExtGrid_work();
	  setExtGrid_trans();
	  setExtGrid_warehousing();

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	    gridarea1.updateLayout();
	    gridarea2.updateLayout();
	  });
	}

	function setExtGrid_work() {
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
	                SEARCHFROM: $("#searchFrom").val() + "",
	                SEARCHTO: $("#searchTo").val() + "",
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
	      LotHistoryWorkList: '#LotHistoryWorkList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    onWorkClick: onWorkClick,
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
	        height: 303,
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
	          itemId: 'LotHistoryWorkList',
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
	    models: gridnms["models.work"],
	    stores: gridnms["stores.work"],
	    views: gridnms["views.work"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.work"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });
	}

	function setExtGrid_trans() {
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
	                SEARCHFROM: $("#searchFrom").val() + "",
	                SEARCHTO: $("#searchTo").val() + "",
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
	      LotHistoryTransList: '#LotHistoryTransList',
	    },
	    stores: [gridnms["store.2"]],
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
	        height: 150,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
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
	          itemId: 'LotHistoryTransList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
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
	        dockedItems: items["docked.2"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.trans"],
	    stores: gridnms["stores.trans"],
	    views: gridnms["views.trans"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      gridarea1 = Ext.create(gridnms["views.trans"], {
	          renderTo: 'gridArea1'
	        });
	    },
	  });
	}

	function setExtGrid_warehousing() {
	  Ext.define(gridnms["model.3"], {
	    extend: Ext.data.Model,
	    fields: fields["model.3"],
	  });

	  Ext.define(gridnms["store.3"], {
	    extend: Ext.data.JsonStore, // Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.3"],
	            model: gridnms["model.3"],
	            autoLoad: true,
	            isStore: false,
	            autoDestroy: true,
	            clearOnPageLoad: true,
	            clearRemovedOnLoad: true,
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.3"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                SEARCHFROM: $("#searchFrom").val() + "",
	                SEARCHTO: $("#searchTo").val() + "",
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.3"], {
	    extend: Ext.app.Controller,
	    refs: {
	      LotHistoryWarehousingList: '#LotHistoryWarehousingList',
	    },
	    stores: [gridnms["store.3"]],
	  });

	  Ext.define(gridnms["panel.3"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.3"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel',
	        itemId: gridnms["panel.3"],
	        id: gridnms["panel.3"],
	        store: gridnms["store.3"],
	        height: 150,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.3"],
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
	          itemId: 'LotHistoryWarehousingList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
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
	        dockedItems: items["docked.3"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.warehousing"],
	    stores: gridnms["stores.warehousing"],
	    views: gridnms["views.warehousing"],
	    controllers: gridnms["controller.3"],

	    launch: function () {
	      gridarea2 = Ext.create(gridnms["views.warehousing"], {
	          renderTo: 'gridArea2'
	        });
	    },
	  });
	}

	function fn_clear() {
	  $('#itemcode').val("");
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchFrom = $("#searchFrom").val();
	  var searchTo = $("#searchTo").val();
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

	  if (searchFrom == "") {
	    header.push("기간 From");
	    count++;
	  }

	  if (searchTo == "") {
	    header.push("기간 To");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
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
	  var searchFrom = $("#searchFrom").val();
	  var searchTo = $("#searchTo").val();
	  var searchItemCode = $("#searchItemCode").val();
	  var searchLotNo = $("#searchLotNo").val();

	  fn_clear();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHFROM: searchFrom,
	    SEARCHTO: searchTo,
	    ITEMCODE: searchItemCode,
	    LOTNO: searchLotNo,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  var searchTransLotNo = $("#searchTransLotNo").val();
	  var searchWarehousingLotNo = $("#searchWarehousingLotNo").val();
	  fn_label_display(searchLotNo, searchWarehousingLotNo, searchTransLotNo);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.2"]);
	  }, 400);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.3"]);
	  }, 800);
	}

	function fn_label_display(val1, val2, val3) {
	  if (val1 != "") {
	    $('#lotRemarks span').text("");
	    $('#resultLotNo1').val(val2);
	    $('#resultLotNo2').val(val1);
	    $('#resultLotNo3').val(val3);
	    //         $('#resultLotNo3').text(val3);
	  } else {
	    $('#lotRemarks span').text("※ 공정 LOT의 항목을 클릭해주세요.");
	    $('#resultLotNo1').val("");
	    $('#resultLotNo2').val("");
	    $('#resultLotNo3').val("");
	    //         $('#resultLotNo3').text("");
	  }
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
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

	      fn_clear();

	      var lotno = $('#searchLotNo').val();
	      if (lotno != "") {
	        $('#searchLotNo').val("");
	      }

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

	      $('#itemcode').val(o.item.value);

	      var lotno = $('#searchLotNo').val();
	      if (lotno != "") {
	        $('#searchLotNo').val("");
	      }

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

	      fn_clear();

	      var lotno = $('#searchLotNo').val();
	      if (lotno != "") {
	        $('#searchLotNo').val("");
	      }

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

	      $('#itemcode').val(o.item.value);

	      var lotno = $('#searchLotNo').val();
	      if (lotno != "") {
	        $('#searchLotNo').val("");
	      }

	      return false;
	    }
	  });

	  // LOT NO Lov
	  $("#searchLotNo")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $('#searchLotNo').val("");
	      $('#searchItemCode').val("");
	      $('#searchItemName').val("");
	      $('#searchOrderName').val("");

	      fn_clear();

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
	      $.getJSON("<c:url value='/searchHistoryLotNoListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        SEARCHFROM: $('#searchFrom').val(),
	        SEARCHTO: $('#searchTo').val(),
	        ITEMCODE: $('#searchItemCode').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.LOTNO + ', ' + m.ORDERNAME + ', ' + m.ITEMNAME,
	              value: m.LOTNO,
	              TRANSLOT: m.TRANSLOT,
	              LASTLOTNO: m.LASTLOTNO,
	              WAREHOUSINGLOT: m.WAREHOUSINGLOT,
	              ITEMCODE: m.ITEMCODE,
	              ORDERNAME: m.ORDERNAME,
	              ITEMNAME: m.ITEMNAME,
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
	      $("#searchLotNo").val(o.item.value);
	      $("#searchTransLotNo").val(o.item.TRANSLOT);
	      $("#searchWarehousingLotNo").val(o.item.WAREHOUSINGLOT);

	      $("#searchItemCode").val(o.item.ITEMCODE);
	      $("#searchItemName").val(o.item.ITEMNAME);
	      $("#searchOrderName").val(o.item.ORDERNAME);

	      $('#itemcode').val(o.item.ITEMCODE);

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
								<input type="hidden" id="tempMonth" value="${dateMonth}" />
								<div id="cur_loc">
										<div id="cur_loc_align">
												<ul>
														<li>HOME</li>
														<li>&gt;</li>
														<li>품질관리</li>
														<li>&gt;</li>
														<li><strong>${pageTitle}</strong></li>
												</ul>
										</div>
								</div>
								<div id="search_field" style="margin-bottom: 5px;">
										<div id="search_field_loc">
												<h2>
														<strong>${pageTitle}</strong>
												</h2>
										</div>
										<fieldset style="width: 100%;">
												<legend>조건정보 영역</legend>

												<form id="master" name="master" action="" method="post">
                            <input type="hidden" id="searchBigCode" name="searchBigCode" />
                            <input type="hidden" id="searchItemCode" name="searchItemCode" />
                            <input type="hidden" id="searchTransLotNo" name="searchTransLotNo" />
                            <input type="hidden" id="searchWarehousingLotNo" name="searchWarehousingLotNo" />
                            <input type="hidden" id="itemcode" name="itemcode" />
														<div>
																<table class="tbl_type_view" border="1">
																		<colgroup>
																				<col width="120px">
																				<col width="23%">
																				<col width="120px">
                                        <col>
																				<col width="120px">
																				<col>
																		</colgroup>
																		<tr style="height: 34px;">
                                        <td colspan="2">
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
                                        <td colspan="2">
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
                                        <td colspan="2">
																						<div class="buttons" style="float: right; margin-top: 3px;">
																								<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
																						</div>
																				</td>
																		</tr>
																		<tr style="height: 34px;">
																				<th class="required_text">기간</th>
																				<td>
                                            <input type="text" id="searchFrom" name="searchFrom" class=" input_center input_validation" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchTo" name="searchTo" class=" input_center input_validation" style="width: 90px; " maxlength="10"  />
																				</td>
                                        <th class="required_text">품번</th>
                                        <td>
                                          <input type="text" id="searchOrderName" name="searchOrderName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td>
                                          <input type="text" id="searchItemName" name="searchItemName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false"  style="width: 97%;" />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">LOT NO</th>
                                        <td>
                                          <input type="text" id="searchLotNo" name="searchLotNo" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false"  style="width: 97%;" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
																</table>
														</div>
												</form>
										</fieldset>
								</div>
								<table style="width: 100%">
								  <tr>
								  <td style="width: 100%;"><div class="subConTit3">
								  LOT 이력 정보
								  <label id="lotRemarks" style="font-size: 15px; color: red; font-weight: bold; margin-bottom: 0px;" >
	                <span>※ 공정 LOT의 항목을 클릭해주세요.</span>
	                </label>
								  </div>
								  </td>
								  </tr>
								</table>
				        <div style="width: 100%; border-width: 2px solid; border-color: #5B9BD5;">
		                <table style="width: 100%;" class="" border="0">
		                        <colgroup>
                                <col width="4%">
                                <col width="22%">
                                <col width="10%">
                                <col width="22%">
                                <col width="10%">
                                <col width="22%">
                                <col width="4%">
		                        </colgroup>
		                        <tr>
                                <td style="border-left-style: solid; border-left-width: 1px; border-left-color: #5B9BD5; border-top-style: solid; border-top-width: 1px; border-top-color: #5B9BD5;">
                                </td>
                                <td style="padding: 0px !important; border-top-style: solid; border-top-width: 1px; border-top-color: #5B9BD5;">
                                <button type="button" class="blue2 r shadow" style="width: 96%; height: 40px; font-size: 20px; font-weight: bold; margin-top: 5px; margin-left: 5px; margin-right: 0%;">자재 LOT</button>
                                </td>
                                <td rowspan="2" style="padding: 0px !important; border-top-style: solid; border-top-width: 1px; border-top-color: #5B9BD5; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: #5B9BD5;">
                                <center>
                                    <img alt="" id='image1' src="<c:url value='/images/new_icon/switch-arrows.png' />" style="width: auto; height: 80px; margin-top: 5px;">
                                </center>
                                </td>
                                <td style="padding: 0px !important; border-top-style: solid; border-top-width: 1px; border-top-color: #5B9BD5;">
                                <button type="button" class="blue2 r shadow" style="width: 96%; height: 40px; font-size: 20px; font-weight: bold; margin-top: 5px; margin-left: 5px; margin-right: 0%;">공정 LOT</button>
                                </td>
                                <td rowspan="2" style="padding: 0px !important; border-top-style: solid; border-top-width: 1px; border-top-color: #5B9BD5; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: #5B9BD5;">
                                <center>
                                    <img alt="" id='image2' src="<c:url value='/images/new_icon/switch-arrows.png' />" style="width: auto; height: 80px; margin-top: 5px;">
                                </center>
                                </td>
                                <td style="padding: 0px !important; border-top-style: solid; border-top-width: 1px; border-top-color: #5B9BD5;">
                                <button type="button" class="blue2 r shadow" style="width: 96%; height: 40px; font-size: 20px; font-weight: bold; margin-top: 5px; margin-left: 5px; margin-right: 0%;">출하 LOT</button>
                                </td>
                                <td style="border-right-style: solid; border-right-width: 1px; border-right-color: #5B9BD5; border-top-style: solid; border-top-width: 1px; border-top-color: #5B9BD5;">
                                </td>
		                        </tr>
		                        <tr>
                                <td style="border-left-style: solid; border-left-width: 1px; border-left-color: #5B9BD5; border-bottom-style: solid; border-bottom-width: 1px; border-top-color: #5B9BD5;"></td>
                                <td style="padding: 0px !important; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: #5B9BD5;">
                                    <input type="text" class="shadow" id="resultLotNo3" name="resultLotNo3" style="width: 96%; height: 40px; font-size: 18px; font-weight: bold; margin-left: 5px; margin-top: 5px; margin-bottom: 5px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: center; word-wrap:break-word;" readonly />
<%--                                     <section class="shadow" id="resultLotNo3" name="resultLotNo3" style="width: 96%; height: 40px; font-size: 18px; font-weight: bold; background-color: #EAEAEA; margin-left: 5px; margin-top: 5px; margin-bottom: 5px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: center; word-wrap:break-word;" /> --%>
                                    
                                </td>
                                <td style="padding: 0px !important; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: #5B9BD5;">
                                    <input type="text" class="shadow" id="resultLotNo2" name="resultLotNo2" style="width: 96%; height: 40px; font-size: 18px; font-weight: bold; margin-left: 5px; margin-top: 5px; margin-bottom: 5px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: center; word-wrap:break-word;" readonly />
                                </td>
                                <td style="padding: 0px !important; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: #5B9BD5;">
                                    <input type="text" class="shadow" id="resultLotNo1" name="resultLotNo1" style="width: 96%; height: 40px; font-size: 18px; font-weight: bold; margin-left: 5px; margin-top: 5px; margin-bottom: 5px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center; float: center; word-wrap:break-word;" readonly />
                                </td>
                                <td style="border-right-style: solid; border-right-width: 1px; border-right-color: #5B9BD5; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: #5B9BD5;">
                                </td>
		                        </tr>
		                </table>
				        </div>
                <div style="width: 100%;">
				            <table style="width: 100%">
				              <tr>
				                <td style="width: 100%;"><br><div class="subConTit2">공정 LOT</div></td>
				              </tr>
				            </table>  
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                    <table style="width: 100%">
                      <tr>
                        <td style="width: 100%;"><br><div class="subConTit2">자재 LOT</div></td>
                      </tr>
                    </table>  
                    <div id="gridArea1" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                    <table style="width: 100%">
                      <tr>
                        <td style="width: 100%;"><br><div class="subConTit2">출하 LOT</div></td>
                      </tr>
                    </table>  
                    <div id="gridArea2" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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