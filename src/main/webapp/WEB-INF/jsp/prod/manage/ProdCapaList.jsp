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
$(document).ready(function () {
	  setInitial();

	  var searchdate = $('#searchDate').val();
	  setValues(searchdate);
	  setExtGrid();

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  gridnms["app"] = "prod";

	  calender($('#searchDate, #searchPrintDate'));

	  $('#searchDate, #searchPrintDate').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchDate").val(getToDay("${searchVO.DATETO}") + "");
	  $("#searchPrintDate").val(getToDay("${searchVO.DATESYS}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues(sdate) {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "ProdCapaList";

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
	      name: 'SONO',
	    }, {
	      type: 'number',
	      name: 'SOSEQ',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAME',
	    }, {
	      type: 'string',
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
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
	      name: 'MATERIALTYPE',
	    }, {
	      type: 'string',
	      name: 'MATCOUNT',
	    }, {
	      type: 'string',
	      name: 'GROUP01',
	    }, {
	      type: 'string',
	      name: 'GROUP02',
	    }, {
	      type: 'string',
	      name: 'GROUP03',
	    }, {
	      type: 'string',
	      name: 'GROUP04',
	    }, {
	      type: 'string',
	      name: 'GROUP05',
	    }, {
	      type: 'string',
	      name: 'GROUP06',
	    }, {
	      type: 'string',
	      name: 'FINISHITEM',
	    }, {
	      type: 'string',
	      name: 'SOQTY',
	    }, {
	      type: 'string',
	      name: 'SOREMAINQTY',
	    }, {
	      type: 'string',
	      name: 'MORELESSQTY1',
	    }, {
	      type: 'number',
	      name: 'PLANQTY',
	    }, {
	      type: 'number',
	      name: 'PLANNEXTQTY',
	    }, {
	      type: 'string',
	      name: 'SHIPQTY',
	    }, {
	      type: 'string',
	      name: 'MORELESSQTY2',
	    }, {
	      type: 'string',
	      name: 'NEXTREQUIREQTY',
	    }, {
	      type: 'number',
	      name: 'ROUTINGCNT',
	    }, {
	      type: 'number',
	      name: 'ROUT01',
	    }, {
	      type: 'number',
	      name: 'ROUT02',
	    }, {
	      type: 'number',
	      name: 'ROUT03',
	    }, {
	      type: 'number',
	      name: 'ROUT04',
	    }, {
	      type: 'number',
	      name: 'ROUT05',
	    }, {
	      type: 'number',
	      name: 'ROUT06',
	    }, {
	      type: 'number',
	      name: 'ROUT07',
	    }, {
	      type: 'number',
	      name: 'ROUT08',
	    }, {
	      type: 'number',
	      name: 'ROUT09',
	    }, {
	      type: 'number',
	      name: 'ROUT10',
	    }, {
	      type: 'number',
	      name: 'ROUT11',
	    }, {
	      type: 'number',
	      name: 'ROUT12',
	    }, {
	      type: 'number',
	      name: 'ROUT13',
	    }, {
	      type: 'number',
	      name: 'ROUT14',
	    }, {
	      type: 'number',
	      name: 'ROUT15',
	    }, {
	      type: 'number',
	      name: 'ROUT16',
	    }, {
	      type: 'number',
	      name: 'ROUT17',
	    }, {
	      type: 'number',
	      name: 'ROUT18',
	    }, {
	      type: 'number',
	      name: 'ROUT19',
	    }, {
	      type: 'number',
	      name: 'ROUT20',
	    }, {
	      type: 'number',
	      name: 'STAN01',
	    }, {
	      type: 'number',
	      name: 'STAN02',
	    }, {
	      type: 'number',
	      name: 'STAN03',
	    }, {
	      type: 'number',
	      name: 'STAN04',
	    }, {
	      type: 'number',
	      name: 'STAN05',
	    }, {
	      type: 'number',
	      name: 'STAN06',
	    }, {
	      type: 'number',
	      name: 'STAN07',
	    }, {
	      type: 'number',
	      name: 'STAN08',
	    }, {
	      type: 'number',
	      name: 'STAN09',
	    }, {
	      type: 'number',
	      name: 'STAN10',
	    }, {
	      type: 'number',
	      name: 'STAN11',
	    }, {
	      type: 'number',
	      name: 'STAN12',
	    }, {
	      type: 'number',
	      name: 'STAN13',
	    }, {
	      type: 'number',
	      name: 'STAN14',
	    }, {
	      type: 'number',
	      name: 'STAN15',
	    }, {
	      type: 'number',
	      name: 'STAN16',
	    }, {
	      type: 'number',
	      name: 'STAN17',
	    }, {
	      type: 'number',
	      name: 'STAN18',
	    }, {
	      type: 'number',
	      name: 'STAN19',
	    }, {
	      type: 'number',
	      name: 'STAN20',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME01',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME02',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME03',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME04',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME05',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME06',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME07',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME08',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME09',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME10',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME11',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME12',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME13',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME14',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME15',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME16',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME17',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME18',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME19',
	    }, {
	      type: 'string',
	      name: 'ROUTNAME20',
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
	      locked: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'XXXXXXXXXX',
	      menuDisabled: true,
	      sortable: false,
	      resizable: false,
	      locked: true,
	      lockable: false,
	      xtype: 'widgetcolumn',
	      stopSelection: true,
	      text: '',
	      width: 65,
	      style: 'text-align:center',
	      align: "center",
	      widget: {
	        xtype: 'button',
	        _btnText: "상세",
	        defaultBindProperty: null, //important
	        handler: function (widgetColumn) {
	          var record = widgetColumn.getWidgetRecord();

	          fn_detail_popup(record.data);
	        },
	        listeners: {
	          beforerender: function (widgetColumn) {
	            var record = widgetColumn.getWidgetRecord();
	            widgetColumn.setText(widgetColumn._btnText);
	          }
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
	      locked: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'DRAWINGNO',
	      text: '도번',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 260,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
        style: 'text-align:center',
        align: "left",
	      //      }, {
	      //        dataIndex: 'MODELNAME',
	      //        text: '기종',
	      //        xtype: 'gridcolumn',
	      //        width: 110,
	      //        hidden: false,
	      //        sortable: false,
	      //        align: "center",
	      //       }, {
	      //         dataIndex: 'MATERIALTYPE',
	      //         text: '재질',
	      //         xtype: 'gridcolumn',
	      //         width: 120,
	      //         hidden: false,
	      //         sortable: false,
	      //         resizable: false,
	      //         align: "center",
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 135,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'MATCOUNT',
	      text: '소재',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
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
	      dataIndex: 'SONO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SOSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODEL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODELNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MATERIALTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, ];

	  var routinggroup = "${searchVO.ROUTINGGROUP}";
	  var groupcode = routinggroup.split(",");
	  var routinggroupname = "${searchVO.ROUTINGGROUPNAME}";
	  var groupname = routinggroupname.split(",");
	  for (var i = 0; i < groupcode.length; i++) {

	    fields["columns.1"].push({
	      dataIndex: 'GROUP' + fn_lpad(groupcode[i] + "", 2, '0'),
	      text: groupname[i],
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000.00",
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    });
	  }

	  fields["columns.1"].push({
	    dataIndex: 'FINISHITEM',
	    text: '완제품',
	    xtype: 'gridcolumn',
	    width: 80,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    lockable: false,
	    style: 'text-align:center',
	    align: "right",
	    cls: 'ERPQTY',
	    format: "0,000.00",
	    renderer: function (value, meta, record) {
	      var moreqty = record.data.MORELESSQTY2 * 1;

	      if ((value * 1) < moreqty) {
	        meta.style = "color: rgb(156, 0, 6);";
	        meta.style += " background-color: rgb(255, 199, 206);";
	      }
	      return Ext.util.Format.number(value, '0,000');
	    },
	  }, {
	    dataIndex: 'SOREMAINQTY',
	    text: '수주잔량',
	    xtype: 'gridcolumn',
	    width: 80,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    lockable: false,
	    style: 'text-align:center',
	    align: "right",
	    cls: 'ERPQTY',
	    format: "0,000.00",
	    renderer: function (value, meta, record) {
	      return Ext.util.Format.number(value, '0,000');
	    },
	  }, {
	    dataIndex: 'MORELESSQTY1',
	    text: '과부족수량',
	    xtype: 'gridcolumn',
	    width: 110,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    lockable: false,
	    style: 'text-align:center',
	    align: "right",
	    cls: 'ERPQTY',
	    format: "0,000.00",
	    renderer: function (value, meta, record) {
	      if ((value * 1) < 0) {
	        meta.style = "color: rgb(156, 0, 6);";
	        meta.style += " background-color: rgb(255, 199, 206);";
	      }
	      return Ext.util.Format.number(value, '0,000');
	    },
	  });

	  var month = new Date(sdate);
	  var tempMonth1 = month.getMonth() + 1;
	  var nowMonth = fn_lpad(tempMonth1 + "", 2, '0');
	  month.setMonth(tempMonth1 + 1, 0);
	  var tempMonth2 = month.getMonth() + 1;
	  var nextMonth = fn_lpad(tempMonth2 + "", 2, '0');

	  fields["columns.1"].push({
	    dataIndex: 'PLANQTY',
	    text: nowMonth + "월<br/>수주계획",
	    xtype: 'gridcolumn',
	    width: 80,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    lockable: false,
	    style: 'text-align:center',
	    align: "right",
	    cls: 'ERPQTY',
	    format: "0,000.00",
	    renderer: function (value, meta, record) {
	      return Ext.util.Format.number(value, '0,000');
	    },
	  }, {
	    dataIndex: 'PLANNEXTQTY',
	    text: nextMonth + "월<br/>수주계획",
	    xtype: 'gridcolumn',
	    width: 80,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    lockable: false,
	    style: 'text-align:center',
	    align: "right",
	    cls: 'ERPQTY',
	    format: "0,000.00",
	    renderer: function (value, meta, record) {
	      return Ext.util.Format.number(value, '0,000');
	    },
	  }, {
	    dataIndex: 'SHIPQTY',
	    text: '출하수량',
	    xtype: 'gridcolumn',
	    width: 80,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    lockable: false,
	    style: 'text-align:center',
	    align: "right",
	    cls: 'ERPQTY',
	    format: "0,000.00",
	    renderer: function (value, meta, record) {
	      return Ext.util.Format.number(value, '0,000');
	    },
	  }, {
	    dataIndex: 'MORELESSQTY2',
	    text: '출하잔량',
	    xtype: 'gridcolumn',
	    width: 80,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    lockable: false,
	    style: 'text-align:center',
	    align: "right",
	    cls: 'ERPQTY',
	    format: "0,000.00",
	    renderer: function (value, meta, record) {
	      if ((value * 1) < 0) {
	        meta.style = "color: rgb(156, 0, 6);";
	        meta.style += " background-color: rgb(255, 199, 206);";
	      }
	      return Ext.util.Format.number(value, '0,000');
	    },
	  }, {
	    dataIndex: 'NEXTREQUIREQTY',
	    text: '익월<br/>과부족수량',
	    xtype: 'gridcolumn',
	    width: 110,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    menuDisabled: true,
	    lockable: false,
	    style: 'text-align:center',
	    align: "right",
	    cls: 'ERPQTY',
	    format: "0,000.00",
	    renderer: function (value, meta, record) {
	      if ((value * 1) < 0) {
	        meta.style = "color: rgb(156, 0, 6);";
	        meta.style += " background-color: rgb(255, 199, 206);";
	        meta.style += " font-weight: bold;";
	      }
	      return Ext.util.Format.number(value, '0,000');
	    },
	  });

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/manage/ProdCapaList.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};

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

	function fn_detail_popup(data) {

	  var width = 1376;
	  var height = 400;
	  var title = "생산현황 및 CAPA 상세";

	  Ext.create('Ext.window.Window', {
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
	    '</colgroup>' +
	    '<tbody>' +
	    '<tr style="height: 80px;">' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '품번' +
	    '</th>' +
	    '<td colspan="2" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '<label id="ordername" name="ordername" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + data.ORDERNAME + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '품명' +
	    '</th>' +
	    '<td colspan="4" class="input_center" style="background-color: rgb(234, 234, 234); border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '<label id="itemname" name="itemname" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + data.ITEMNAME + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th scope="col" style="border-right-style: solid; border-right-width: 1px; border-right-color: black; border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black; ">' +
	    '거래처' +
	    '</th>' +
	    '<td colspan="7" class="input_center" style="background-color: rgb(234, 234, 234); border-bottom-style: solid; border-bottom-width: 1px; border-bottom-color: black;">' +
	    '<label id="customername" name="customername" style="font-size: 22px; color: black; font-weight: bold;">' +
	    '<span>' + data.CUSTOMERNAME + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    '소재' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    ((data.ROUTNAME02 == "") ? '완제품' : data.ROUTNAME01) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME01 != "") && (data.ROUTNAME02 == "")) ? '완제품' : data.ROUTNAME02) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME02 != "") && (data.ROUTNAME03 == "")) ? '완제품' : data.ROUTNAME03) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME03 != "") && (data.ROUTNAME04 == "")) ? '완제품' : data.ROUTNAME04) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME04 != "") && (data.ROUTNAME05 == "")) ? '완제품' : data.ROUTNAME05) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME05 != "") && (data.ROUTNAME06 == "")) ? '완제품' : data.ROUTNAME06) +
	    '</th>' +
	    '<th>' +
	    (((data.ROUTNAME06 != "") && (data.ROUTNAME07 == "")) ? '완제품' : data.ROUTNAME07) +
	    '</th>' +
	    '</tr>' +
	    '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + numeral(data.MATCOUNT).format('0,0') + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME01 == "") ? ((data.ROUTNAME02 == "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN01 == "") ? numeral(data.ROUT01).format('0,0') : "(" + numeral(data.STAN01).format('0,0') + ") " + numeral(data.ROUT01).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME02 == "") ? ((data.ROUTNAME01 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN02 == "") ? numeral(data.ROUT02).format('0,0') : "(" + numeral(data.STAN02).format('0,0') + ") " + numeral(data.ROUT02).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME03 == "") ? ((data.ROUTNAME02 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN03 == "") ? numeral(data.ROUT03).format('0,0') : "(" + numeral(data.STAN03).format('0,0') + ") " + numeral(data.ROUT03).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME04 == "") ? ((data.ROUTNAME03 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN04 == "") ? numeral(data.ROUT04).format('0,0') : "(" + numeral(data.STAN04).format('0,0') + ") " + numeral(data.ROUT04).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME05 == "") ? ((data.ROUTNAME04 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN05 == "") ? numeral(data.ROUT05).format('0,0') : "(" + numeral(data.STAN05).format('0,0') + ") " + numeral(data.ROUT05).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME06 == "") ? ((data.ROUTNAME05 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN06 == "") ? numeral(data.ROUT06).format('0,0') : "(" + numeral(data.STAN06).format('0,0') + ") " + numeral(data.ROUT06).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME07 == "") ? ((data.ROUTNAME06 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN07 == "") ? numeral(data.ROUT07).format('0,0') : "(" + numeral(data.STAN07).format('0,0') + ") " + numeral(data.ROUT07).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME07 != "") && (data.ROUTNAME08 == "")) ? '완제품' : data.ROUTNAME08) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME08 != "") && (data.ROUTNAME09 == "")) ? '완제품' : data.ROUTNAME09) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME09 != "") && (data.ROUTNAME10 == "")) ? '완제품' : data.ROUTNAME10) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME10 != "") && (data.ROUTNAME11 == "")) ? '완제품' : data.ROUTNAME11) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME11 != "") && (data.ROUTNAME12 == "")) ? '완제품' : data.ROUTNAME12) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME12 != "") && (data.ROUTNAME13 == "")) ? '완제품' : data.ROUTNAME13) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME13 != "") && (data.ROUTNAME14 == "")) ? '완제품' : data.ROUTNAME14) +
	    '</th>' +
	    '<th>' +
	    (((data.ROUTNAME14 != "") && (data.ROUTNAME15 == "")) ? '완제품' : data.ROUTNAME15) +
	    '</th>' +
	    '</tr>' +
	    '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME08 == "") ? ((data.ROUTNAME07 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN08 == "") ? numeral(data.ROUT08).format('0,0') : "(" + numeral(data.STAN08).format('0,0') + ") " + numeral(data.ROUT08).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME09 == "") ? ((data.ROUTNAME08 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN09 == "") ? numeral(data.ROUT09).format('0,0') : "(" + numeral(data.STAN09).format('0,0') + ") " + numeral(data.ROUT09).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME10 == "") ? ((data.ROUTNAME09 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN10 == "") ? numeral(data.ROUT10).format('0,0') : "(" + numeral(data.STAN10).format('0,0') + ") " + numeral(data.ROUT10).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME11 == "") ? ((data.ROUTNAME10 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN11 == "") ? numeral(data.ROUT11).format('0,0') : "(" + numeral(data.STAN11).format('0,0') + ") " + numeral(data.ROUT11).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME12 == "") ? ((data.ROUTNAME11 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN12 == "") ? numeral(data.ROUT12).format('0,0') : "(" + numeral(data.STAN12).format('0,0') + ") " + numeral(data.ROUT12).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME13 == "") ? ((data.ROUTNAME12 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN13 == "") ? numeral(data.ROUT13).format('0,0') : "(" + numeral(data.STAN13).format('0,0') + ") " + numeral(data.ROUT13).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME14 == "") ? ((data.ROUTNAME13 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN14 == "") ? numeral(data.ROUT14).format('0,0') : "(" + numeral(data.STAN14).format('0,0') + ") " + numeral(data.ROUT14).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME15 == "") ? ((data.ROUTNAME14 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN15 == "") ? numeral(data.ROUT15).format('0,0') : "(" + numeral(data.STAN15).format('0,0') + ") " + numeral(data.ROUT15).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '</tr>' +
	    '<tr style="height: 40px;">' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME15 != "") && (data.ROUTNAME16 == "")) ? '완제품' : data.ROUTNAME16) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME16 != "") && (data.ROUTNAME17 == "")) ? '완제품' : data.ROUTNAME17) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME17 != "") && (data.ROUTNAME18 == "")) ? '완제품' : data.ROUTNAME18) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME18 != "") && (data.ROUTNAME19 == "")) ? '완제품' : data.ROUTNAME19) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    (((data.ROUTNAME19 != "") && (data.ROUTNAME20 == "")) ? '완제품' : data.ROUTNAME20) +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    '</th>' +
	    '<th style="border-right-style: solid; border-right-width: 1px; border-right-color: black;">' +
	    '</th>' +
	    '<th>' +
	    '</th>' +
	    '</tr>' +
	    '<tr style="height: 40px; background-color: rgb(234, 234, 234);">' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME16 == "") ? ((data.ROUTNAME15 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN16 == "") ? numeral(data.ROUT16).format('0,0') : "(" + numeral(data.STAN16).format('0,0') + ") " + numeral(data.ROUT16).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME17 == "") ? ((data.ROUTNAME16 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN17 == "") ? numeral(data.ROUT17).format('0,0') : "(" + numeral(data.STAN17).format('0,0') + ") " + numeral(data.ROUT17).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME18 == "") ? ((data.ROUTNAME17 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN18 == "") ? numeral(data.ROUT18).format('0,0') : "(" + numeral(data.STAN18).format('0,0') + ") " + numeral(data.ROUT18).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME19 == "") ? ((data.ROUTNAME18 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN19 == "") ? numeral(data.ROUT19).format('0,0') : "(" + numeral(data.STAN19).format('0,0') + ") " + numeral(data.ROUT19).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + ((data.ROUTNAME20 == "") ? ((data.ROUTNAME19 != "") ? numeral(data.FINISHITEM).format('0,0') : "") : (data.STAN20 == "") ? numeral(data.ROUT20).format('0,0') : "(" + numeral(data.STAN20).format('0,0') + ") " + numeral(data.ROUT20).format('0,0')) + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + '</span>' +
	    '</label>' +
	    '</td>' +
	    '<td>' +
	    '<label style="font-size: 22px; color: black; font-weight: bold; padding-right: 10px; float: right;">' +
	    '<span>' + '</span>' +
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
	  });
	}

	var gridarea;
	function setExtGrid() {
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
	            autoLoad: false,
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                SEARCHDATE: $('#searchDate').val(),
	                GROUPCODE: $('#searchGroupCode').val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      ProdCapaListSelect: '#ProdCapaListSelect',
	    },
	    stores: [gridnms["store.1"]],
	    //      control: items["btns.ctr.1"],
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
	        height: 653,
	        border: 2,
	        scrollable: true,
	        enableLocking: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        split: false,
	        lockedGridConfig: {
	          emptyText: '',
	          collapsible: false,
	          trackOver: false, // true,
	          loadMask: false,
	          striptRows: false,
	          forceFit: false,
	        },
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'ProdCapaListSelect',
	          trackOver: true,
	          loadMask: true,
	          //            listeners: {
	          //              refresh: function (dataView) {
	          //                Ext.each(dataView.panel.columns, function (column) {
	          //                  if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
	          //                    column.autoSize();
	          //                    column.width += 5;
	          //                    if (column.width < 150) {
	          //                      column.width = 150;
	          //                    }
	          //                  }
	          //                });
	          //              }
	          //            },
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
	      gridarea = Ext.create(gridnms["views.list"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchDate = $('#searchDate').val();
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

	  if (searchDate === "") {
	    header.push("일자");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력(선택)해주세요.");
	    result = false;
	  }

	  return result;
	}

	function fn_validation1() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchDate = $('#searchPrintDate').val();
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

	  if (searchDate === "") {
	    header.push("출력일자");
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
	  var searchDate = $('#searchDate').val();
	  var searchGroupCode = $('#searchGroupCode').val();
	  var searchBigName = $('#searchBigName').val();
	  var searchMiddleName = $('#searchMiddleName').val();
	  var searchSmallName = $('#searchSmallName').val();
	  var searchItemCode = $('#searchItemCode').val();

	  var sparams = {
	    ORGID: $('#searchOrgId option:selected').val(),
	    COMPANYID: $('#searchCompanyId option:selected').val(),
	    SEARCHDATE: searchDate,
	    GROUPCODE: searchGroupCode,
	    BIGNAME: searchBigName,
	    MIDDLENAME: searchMiddleName,
	    SMALLNAME: searchSmallName,
	    ITEMCODE: searchItemCode,
	  };

	  setValues(searchDate);
	  Ext.suspendLayouts();
	  Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
	  Ext.resumeLayouts(true);
	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchDate = $('#searchDate').val();
	  var searchGroupCode = $('#searchGroupCode').val();
	  var searchBigName = $('#searchBigName').val();
	  var searchMiddleName = $('#searchMiddleName').val();
	  var searchSmallName = $('#searchSmallName').val();
	  var searchItemCode = $('#searchItemCode').val();
	  var title = $('#title').val();

	  go_url("<c:url value='/prod/manage/ExcelDownload.do?GUBUN='/>" + "PRODCAPA"
	     + "&ORGID=" + orgid + ""
	     + "&COMPANYID=" + companyid + ""
	     + "&SEARCHDATE=" + searchDate
	     + "&GROUPCODE=" + searchGroupCode
	     + "&BIGNAME=" + searchBigName
	     + "&MIDDLENAME=" + searchMiddleName
	     + "&SMALLNAME=" + searchSmallName
	     + "&ITEMCODE=" + searchItemCode
	     + "&TITLE=" + title + "");
	}

	function fn_print(flag) {
	  var url = "";

	  var column = 'master';
	  var target = '_blank';

	  switch (flag) {
	  case '1':

	    if (!fn_validation()) {
	      return;
	    }

	    url = "<c:url value='/report/StockAmountReport.pdf'/>";

	    fn_popup_url(column, url, target);
	    break;
	  case '2':
	    if (!fn_validation1()) {
	      return;
	    }

	    url = "<c:url value='/report/DayWorkOrderStatusReport.pdf'/>";

	    fn_popup_url(column, url, target);
	    break;
	  default:

	    break;
	  }
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 대분류 Lov
	  $("#searchBigName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:

	      var middlename = $('#searchMiddleName').val();
	      if (middlename != "") {
	        $('#searchMiddleName').val("");
	      }

	      var smallname = $('#searchSmallName').val();
	      if (smallname != "") {
	        $('#searchSmallName').val("");
	      }

	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchDistinctBigClassListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GROUPCODE: $('#searchGroupCode').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL,
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
	      $("#searchBigName").val(o.item.label);

	      var middlename = $('#searchMiddleName').val();
	      if (middlename != "") {
	        $('#searchMiddleName').val("");
	      }

	      var smallname = $('#searchSmallName').val();
	      if (smallname != "") {
	        $('#searchSmallName').val("");
	      }

	      return false;
	    }
	  });

	  // 중분류 Lov
	  $("#searchMiddleName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:

	      var smallname = $('#searchSmallName').val();
	      if (smallname != "") {
	        $('#searchSmallName').val("");
	      }

	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchDistinctMiddleClassListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GROUPCODE: $('#searchGroupCode').val(),
	        BIGNAME: $('#searchBigName').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL,
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
	      $("#searchMiddleName").val(o.item.label);

	      var smallname = $('#searchSmallName').val();
	      if (smallname != "") {
	        $('#searchSmallName').val("");
	      }

	      return false;
	    }
	  });

	  // 소분류 Lov
	  $("#searchSmallName")
	  .bind("keydown", function (e) {
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
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchDistinctSmallClassListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GROUPCODE: $('#searchGroupCode').val(),
	        BIGNAME: $('#searchBigName').val(),
	        MIDDLENAME: $('#searchMiddleName').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL,
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
	      $("#searchSmallName").val(o.item.label);

	      return false;
	    }
	  });

	  // 품번 Lov
	  $("#searchOrderName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchOrderName").val("");
	      $("#searchItemCode").val("");
	      $("#searchItemName").val("");

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
	      $.getJSON("<c:url value='/searchItemCodeOrderLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GROUPCODE: $('#searchGroupCode').val(),
	        GUBUN: 'ORDERNAME',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.ITEMCODE,
	              label: m.ORDERNAME + ", " + m.ITEMNAME,
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
	  $("#searchItemName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchItemName").val("");
	      $("#searchItemCode").val("");
	      $("#searchOrderName").val("");

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
	      $.getJSON("<c:url value='/searchItemCodeOrderLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GROUPCODE: $('#searchGroupCode').val(),
	        GUBUN: 'ITEMNAME',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.ITEMCODE,
	              label: m.ITEMNAME + ", " + m.ORDERNAME,
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
                                <li>계획관리</li>
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
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
                            <input type="hidden" id="searchGroupCode" name="searchGroupCode" value="${searchVO.GROUPCODE}" />
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
                                                <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();">
                                                   엑셀
                                                </a>
                                                <!-- <a id="btnChk3" class="btn_print" href="#" onclick="javascript:fn_print('1');">
                                                   재고금액
                                                </a>
                                                <a id="btnChk4" class="btn_print" href="#" onclick="javascript:fn_print('2');">
                                                   일일작업지시현황
                                                </a> -->
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
                                        <col width="120px">
                                        <col>
                                    </colgroup>
                                    
                                    <tr style="height: 34px;">
                                        <th class="required_text">일자</th>
                                        <td>
                                            <input type="text" id="searchDate" name="searchDate" class="input_validation input_center " style="width: 90px; " maxlength="10" />
                                        </td>
                                        <th class="required_text">대분류</th>
                                        <td>
                                            <input type="text" id="searchBigName" name="searchBigName" class="input_center " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">중분류</th>
                                        <td>
                                            <input type="text" id="searchMiddleName" name="searchMiddleName" class="input_center " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">소분류</th>
                                        <td>
                                            <input type="text" id="searchSmallName" name="searchSmallName" class="input_center " style="width: 97%; " />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class=" input_left " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
                                        <td></td>
                                        <td></td>
                                        <th class="required_text">출력일자</th>
                                        <td>
                                            <input type="text" id="searchPrintDate" name="searchPrintDate" class="input_validation input_center " style="width: 90px; " maxlength="10" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->                    
                <div style="width: 100%;">
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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