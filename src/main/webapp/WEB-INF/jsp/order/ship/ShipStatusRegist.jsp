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
.gridStyle table td {
  height : 27px;
  font-size : 13px;
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
	  calender($('#searchDateFrom, #searchDateTo'));

	  $('#searchDateFrom, #searchDateTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchDateFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchDateTo").val(getToDay("${searchVO.dateTo}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	    //       상태 option 변경
	  });

	  gridnms["app"] = "app";

	}

	var gridnms = {};
	var fields = {};
	var items = {};

	function setValues() {
	  gridnms["models.ship"] = [];
	  gridnms["stores.ship"] = [];
	  gridnms["views.ship"] = [];
	  gridnms["controllers.ship"] = [];

	  gridnms["grid.1"] = "ShipStatusRegist";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.ship"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.ship"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.ship"].push(gridnms["model.1"]);

	  gridnms["stores.ship"].push(gridnms["store.1"]);

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
	      name: 'CARTYPE',
	    }, {
	      type: 'string',
	      name: 'CARTYPENAME',
	    }, {
	      type: 'string',
	      name: 'MATERIALTYPE',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'number',
	      name: 'SHIPQTY',
	    }, {
	      type: 'number',
	      name: 'SUPPLYPRICE',
	    }, {
	      type: 'number',
	      name: 'ADDITIONALTAX',
	    }, {
	      type: 'number',
	      name: 'TOTAL',
	    }, {
	      type: 'string',
	      name: 'SONO',
	    }, {
	      type: 'number',
	      name: 'SOSEQ',
	    }, {
	      type: 'string',
	      name: 'SHIPCHECKSTATUSE',
	    }, {
	      type: 'string',
	      name: 'SHIPCHECKSTATUSNAME',
	    }, {
	      type: 'string',
	      name: 'TRADEYN',
	    }, {
	      type: 'string',
	      name: 'TRADEYNNAME',
	    }, {
	      type: 'string',
	      name: 'SHIPGUBUN',
	    }, {
	      type: 'string',
	      name: 'SHIPGUBUNNAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'SHIPMENTINSPECTIONYN',
	    }, {
	      type: 'string',
	      name: 'DELIVERYVAN',
	    }, {
	      type: 'string',
	      name: 'DELIVERYVANNAME',
	    }, {
	      type: 'string',
	      name: 'TAXDIV',
	    }, {
	      type: 'string',
	      name: 'TAXDIVNAME',
	    }, {
	      type: 'string',
	      name: 'SONOPOST',
	    }, {
	      type: 'string',
	      name: 'SOSEQPOST',
	    }, {
	      type: 'string',
	      name: 'ITEMCODEPOST',
	    }, {
	      type: 'string',
	      name: 'LOTNOPOST',
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'rownumberer',
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
	      dataIndex: 'SHIPNO',
	      text: '출하번호',
	      xtype: 'gridcolumn',
	      width: 130,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'SHIPSEQ',
	      text: '출하<br/>순번',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SHIPDATE',
	      text: '출하일자',
	      xtype: 'datecolumn',
	      width: 105,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'SHIPMENTINSPECTIONYN',
	      text: '검사<br/>여부',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
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
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    },  {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      summaryRenderer: function (value, meta, record) {
	        value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>TOTAL</div>";
	        return value;
	      },
	    }, {
	      dataIndex: 'CARTYPENAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      //      }, {
	      //        dataIndex: 'MATERIALTYPE',
	      //        text: '재질',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //         hidden: false,
	      //         sortable: false,
	      //         resizable: false,
	      //         menuDisabled: true,
	      //        align: "center",
	    }, {
        dataIndex: 'ITEMSTANDARDDETAIL',
        text: '타입',
        xtype: 'gridcolumn',
        width: 60,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
      },{
        dataIndex: 'ORDERNAME',
        text: '품번',
        xtype: 'gridcolumn',
        width: 120,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
      },{
	      dataIndex: 'UOMNAME',
	      text: '단위',
	      xtype: 'gridcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'SHIPQTY',
	      text: '출하수량',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SUPPLYPRICE',
	      text: '공급가',
	      xtype: 'gridcolumn',
	      width: 115,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'ADDITIONALTAX',
	      text: '부가세',
	      xtype: 'gridcolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'TOTAL',
	      text: '합계',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'TAXDIVNAME',
	      text: '세액구분',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'SONO',
	      text: '수주번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'SOSEQ',
	      text: '수주내역<br/>순번',
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
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SONOPOST',
	      text: '변경<br/>수주번호',
	      xtype: 'gridcolumn',
	      width: 130,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'SOSEQPOST',
	      text: '변경<br/>수주순번',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'LOTNOPOST',
	      text: '변경 소재LOT',
	      xtype: 'gridcolumn',
	      width: 350,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'TRADEYNNAME',
	      text: '거래명세서<br/>생성여부',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
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
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CARTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPCHECKSTATUS',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPCHECKSTATUSNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPGUBUN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'DELIVERYVAN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'TAXDIV',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/order/ship/ShipStatusRegist.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};

	  //    $.extend(items["btns.ctr.1"], {
	  //      "#MasterList": {
	  //        itemclick: 'onShippingClick'
	  //      }
	  //    });

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
	  //    items["docked.1"].push(items["dock.btn.1"]);
	}

	function onShippingClick(dataview, record, item, index, e, eOpts) {
	  $("#SHIPNO").val(record.get("SHIPNO"));
	  $("#SHIPQTY").val(record.get("SHIPQTY"));
	  $("#ORGID").val(record.get("ORGID"));
	  $("#COMPANYID").val(record.get("COMPANYID"));
	}

	var gridarea;
	function setExtGrid() {
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
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                DATEFROM: $('#searchDateFrom').val(),
	                DATETO: $('#searchDateTo').val(),
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
	      MasterList: '#MasterList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],
	    //      btnAdd1: btnAdd1,
	    //      btnSav1: btnSav1,
	    //      btnDel1: btnDel1,
	    //      btnRef1: btnRef1,
	    //      onShippingClick: onShippingClick,
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
	        height: 629,
	        border: 2,
	        features: [{
	            ftype: 'summary',
	            dock: 'bottom'
	          }
	        ],
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
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
	          itemId: 'MasterList',
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('SHIPGUBUNNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 120) {
	                    column.width = 120;
	                  }
	                }
	              });
	            },
	          }
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
	    models: gridnms["models.ship"],
	    stores: gridnms["stores.ship"],
	    views: gridnms["views.ship"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.ship"], {
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
	  var datefrom = $('#searchDateFrom').val();
	  var dateto = $('#searchDateTo').val();
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
	    header.push("수주일 From");
	    count++;
	  }

	  if (dateto === "") {
	    header.push("수주일 To");
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
	  var datefrom = $('#searchDateFrom').val();
	  var dateto = $('#searchDateTo').val();
	  var shipno = $('#ShipNo').val();
	  var customercode = $('#CustomerCode').val();
	  var itemcode = $('#searchItemcd').val();
	  var shipgubun = $('#ShipGubun').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    DATEFROM: datefrom,
	    DATETO: dateto,
	    SHIPNO: shipno,
	    CUSTOMERCODE: customercode,
	    ITEMCODE: itemcode,
	    SHIPGUBUN: shipgubun,
	  };
	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var datefrom = $('#searchDateFrom').val();
	  var dateto = $('#searchDateTo').val();
	  var shipno = $('#ShipNo').val();
	  var customercode = $('#CustomerCode').val();
	  var itemcode = $('#searchItemcd').val();
	  var shipgubun = $('#ShipGubun').val();

	  go_url("<c:url value='/order/ship/ExcelDownload.do?ORGID='/>" + orgid
	     + "&COMPANYID=" + companyid + ""
	     + "&DATEFROM=" + datefrom + ""
	     + "&DATETO=" + dateto + ""
	     + "&SHIPNO=" + shipno + ""
	     + "&CUSTOMERCODE=" + customercode + ""
	     + "&ITEMCODE=" + itemcode + ""
	     + "&SHIPGUBUN=" + shipgubun + ""
	     + "&TITLE=" + "${pageTitle}" + "");
	}

	function setLovList() {
	  //품명 LOV
	  $("#searchItemnm")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchOrdernm").val("");
	      $("#searchItemcd").val("");
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
	        GUBUN: 'ITEMNAME',
	        ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
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
	      $("#searchItemcd").val(o.item.ITEMCODE);
	      $("#searchItemnm").val(o.item.ITEMNAME);
	      $("#searchOrdernm").val(o.item.ORDERNAME);
	      return false;
	    }
	  });

	  //품번 LOV
	  $("#searchOrdernm")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchItemcd").val("");
	      $("#searchItemnm").val("");
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
	        GUBUN: 'ORDERNAME',
	        ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
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
	      $("#searchItemcd").val(o.item.ITEMCODE);
	      $("#searchItemnm").val(o.item.ITEMNAME);
	      $("#searchOrdernm").val(o.item.ORDERNAME);
	      return false;
	    }
	  });

	  // 출하번호 Lov
	  $("#ShipNo").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //  $("#SalesPersonName").val("");
	      //  $("#ShipNo").val("");
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
	        SEARCHFROM: $('#searchDateFrom').val(),
	        SEARCHTO: $('#searchDateTo').val(),
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
	      $("#ShipNo").val(o.item.value);

	      return false;
	    }
	  });

	  // 거래처명 lov
	  $("#CustomerName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#CustomerCode").val("");

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
	              UNITPRICEDIV: m.UNITPRICEDIV,
	              UNITPRICEDIVNAME: m.UNITPRICEDIVNAME,
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
	      $("#CustomerCode").val(o.item.value);
	      $("#CustomerName").val(o.item.NAME);

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
                                <li>출하 관리</li>
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
                        <input type="hidden" id="searchGroupCode" name=searchGroupCode value="P" />
                        <input type="hidden" id="orgid" value="<c:out value='${OrgIdVal}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${CompanyIdVal}'/>" />
		                    <input type="hidden" id="SHIPNO" />
		                    <input type="hidden" id="ORGID" />
		                    <input type="hidden" id="COMPANYID" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
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
                                  <th class="required_text">출하일자</th>
                                  <td >
		                                  <div>
		                                      <input type="text" id="searchDateFrom" name="searchDateFrom" class="input_validation input_center validate[custom[date],past[#searchShipTo]]" style="width: 90px; " maxlength="10" />
		                                      <span style="padding-top: 7px;">&nbsp;~&nbsp;</span>
		                                      <input type="text" id="searchDateTo" name="searchDateTo" class="input_validation input_center validate[custom[date],future[#searchShipFrom]]" style="width: 90px; " maxlength="10"  />
                                      </div>
                                      <div class="buttons" style="float: left; margin-top: 3px;">
			                                    <a id="btnChkDate1" class="" href="#" onclick="javascript:fn_btn_change_date('searchDateFrom', 'searchDateTo', '${searchVO.dateSys}', '${searchVO.dateSys}');">
			                                       &nbsp;&nbsp;금일&nbsp;&nbsp;
			                                    </a>
			                                    <a id="btnChkDate2" class="" href="#" onclick="javascript:fn_btn_change_date('searchDateFrom', 'searchDateTo', '${searchVO.predateSys}', '${searchVO.predateSys}');">
			                                       &nbsp;&nbsp;전일&nbsp;&nbsp;
			                                    </a>
			                                    <a id="btnChkDate3" class="" href="#" onclick="javascript:fn_btn_change_date('searchDateFrom', 'searchDateTo', '${searchVO.postdateFrom}', '${searchVO.postdateTo}');">
			                                       &nbsp;&nbsp;금월&nbsp;&nbsp;
			                                    </a>
			                                    <a id="btnChkDate4" class="" href="#" onclick="javascript:fn_btn_change_date('searchDateFrom', 'searchDateTo', '${searchVO.predateFrom}', '${searchVO.predateTo}');">
			                                       &nbsp;&nbsp;전월&nbsp;&nbsp;
			                                    </a>
                                      </div>
                                  </td>
                                  <th class="required_text">출하번호</th>
                                  <td>
                                      <input type="text" id="ShipNo" name="ShipNo" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                                  </td>
                                  <th class="required_text">거래처명</th>
                                  <td>
                                        <input type="text" id="CustomerName" name="CustomerName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                                        <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                  </td>
                              </tr>
                              <tr style="height: 34px;">
                                  <th class="required_text">매출구분</th>
                                  <td>
                                      <select id="ShipGubun" name="ShipGubun" class="input_center " style="width: 94%;">
                                          <c:if test="${empty searchVO.SHIPGUBUN}">
                                              <option value=""  >전체</option>
                                          </c:if>
                                          <c:forEach var="item" items="${labelBox.findByShipGubun}" varStatus="status">
                                              <c:choose>
                                                  <c:when test="${item.VALUE==searchVO.SHIPGUBUN}">
                                                      <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                  </c:when>
                                                  <c:otherwise>
                                                      <option value="${item.VALUE}">${item.LABEL}</option>
                                                  </c:otherwise>
                                              </c:choose>
                                          </c:forEach>
                                      </select>
                                  </td>
                                  <th class="required_text">품번</th>
                                  <td>
                                        <input type="text" id="searchOrdernm" name="searchOrdernm" class="input_center" style="width: 94%;" />
                                        <input type="hidden" id="searchItemcd" name="searchItemcd" />
                                  </td>
                                  <th class="required_text">품명</th>
                                  <td>
                                        <input type="text" id="searchItemnm" name="searchItemnm"  class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
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