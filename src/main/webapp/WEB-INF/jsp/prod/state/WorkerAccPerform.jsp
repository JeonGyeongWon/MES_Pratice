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
	  //    calender($('#SearchFrom, #SearchTo, #SearchDate'));
	  calender($('#SearchFrom, #SearchTo'));

	  //     $('#SearchFrom, #SearchTo, #SearchDate').keyup(function (event) {
	  $('#SearchFrom, #SearchTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#SearchFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#SearchTo").val(getToDay("${searchVO.dateTo}") + "");
	  //    $("#SearchDate").val(getToDay("${searchVO.Predate}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.prod"] = [];
	  gridnms["stores.prod"] = [];
	  gridnms["views.prod"] = [];
	  gridnms["controllers.prod"] = [];

	  gridnms["grid.1"] = "WorkerAccPerform";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.prod"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.prod"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.prod"].push(gridnms["model.1"]);

	  gridnms["stores.prod"].push(gridnms["store.1"]);

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
	      type: 'date',
	      name: 'PRODDATE',
	      dateFormat: 'Y-m-d',
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
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
	    }, {
	      type: 'string',
	      name: 'MATERIALTYPE',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'WORKDEPT',
	    }, {
	      type: 'string',
	      name: 'WORKDEPTNAME',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERCODE',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERNAME',
	    }, {
	      type: 'string',
	      name: 'EMPLOYEENUMBER',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, {
	      type: 'string',
	      name: 'WORKDIV',
	    }, {
	      type: 'string',
	      name: 'WORKDIVNAME',
	    }, {
	      type: 'number',
	      name: 'CLOSINGTIME',
	    }, {
	      type: 'number',
	      name: 'WORKERTIME',
	    }, {
	      type: 'number',
	      name: 'NONOPERQTY',
	    }, {
	      type: 'number',
	      name: 'WORKPLANQTY',
	    }, {
	      type: 'number',
	      name: 'DEFECTEDQTY',
	    }, {
	      type: 'number',
	      name: 'PRODQTY',
	    }, {
	      type: 'number',
	      name: 'PRODCOST',
	    }, {
	      type: 'number',
	      name: 'FAULTQTY',
	    }, {
	      type: 'number',
	      name: 'FAULTCOST',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
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
	      dataIndex: 'PRODDATE',
	      text: '작업일자',
	      xtype: 'datecolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	      renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	    }, {
	      dataIndex: 'KRNAME',
	      text: '작업자',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      //          menuDisabled: true,
	      locked: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'WORKDIVNAME',
	      text: '주야구분',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'WORKCENTERNAME',
	      text: '설비명',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
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
	      locked: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	      //      }, {
	      //        dataIndex: 'DRAWINGNO',
	      //        text: '도번',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        locked: true,
	      //        lockable: false,
	      //        style: 'text-align:center',
	      //        align: "left",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      align: "center",
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
	      locked: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	      //      }, {
	      //        dataIndex: 'MATERIALTYPE',
	      //        text: '재질',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        locked: true,
	      //        lockable: false,
	      //        style: 'text-align:center;',
	      //        align: "center",
	    }, {
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'WORKDEPTNAME',
	      text: '작업반',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CLOSINGTIME',
	      text: '투입시간<br/>(분)',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'WORKERTIME',
	      text: '작업시간<br/>(분)',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'NONOPERQTY',
	      text: '비가동시간<br/>(분)',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'WORKPLANQTY',
	      text: '목표수량',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'DEFECTEDQTY',
	      text: '생산수량',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'PRODQTY',
	      text: '양품수량',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'PRODCOST',
	      text: '생산금액',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'FAULTQTY',
	      text: '불량수량',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'FAULTCOST',
	      text: '불량금액',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      lockable: false,
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
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EMPLOYEENUMBER',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKDIV',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/state/WorkerAccPerform.do' />"
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
	                SEARCHFROM: $('#SearchFrom').val(),
	                SEARCHTO: $('#SearchTo').val(),
	              },
	              reader: gridVals.reader,
	              //                writer: $.extend(gridVals.writer, {
	              //                  writeAllFields: true
	              //                }),
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
	        height: 653, // 635,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20,
	            leadingBufferZone: 20,
	            synchronousRender: false,
	            numFromEdge: 19,
	          },
	          'gridfilters',
	        ],
	        features: [$.extend(gridVals.groupingFeature, {
	            groupHeaderTpl: [
	              '{columnName}: {name:this.formatName}' +
	              ' / 투입시간: {[this.groupSum(values.children, "CLOSINGTIME")]}' +
	              ' / 작업시간: {[this.groupSum(values.children, "WORKERTIME")]}' +
	              ' / 비가동시간: {[this.groupSum(values.children, "NONOPERQTY")]}' +
	              ' / 목표수량: {[this.groupSum(values.children, "WORKPLANQTY")]}' +
	              ' / 생산수량: {[this.groupSum(values.children, "DEFECTEDQTY")]}' +
	              ' / 양품수량: {[this.groupSum(values.children, "PRODQTY")]}' +
	              ' / 생산금액: {[this.groupSum(values.children, "PRODCOST")]}' +
	              ' / 불량수량: {[this.groupSum(values.children, "FAULTQTY")]}' +
	              ' / 불량금액: {[this.groupSum(values.children, "FAULTCOST")]}', {
	                formatName: function (name) {
	                  var result = (name == "") ? "미정 " : name;
	                  return Ext.String.trim(result);
	                },
	                groupSum: function (record, field) {
	                  var result = record;
	                  var size = record.length;
	                  var sum = 0;

	                  if (size > 0) {
	                    for (var i = 0; i < size; i++) {
	                      sum += parseFloat(result[i].data[field]);
	                    }
	                  } else {
	                    sum = 0;
	                  }
	                  return Ext.util.Format.number(sum, '0,000');
	                }
	              },
	            ],
	          }), {
	            ftype: 'summary',
	            dock: 'bottom'
	          }
	        ],
	        viewConfig: {
	          itemId: 'workReportList',
	          trackOver: true,
	          loadMask: true,
	          stripeRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('WORKCENTERNAME') >= 0 || column.dataIndex.indexOf('KRNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 120) {
	                    column.width = 120;
	                  }
	                }

	                if (column.dataIndex.indexOf('CARTYPENAME') >= 0) {
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
	    models: gridnms["models.viewer"],
	    stores: gridnms["stores.viewer"],
	    views: gridnms["views.viewer"],
	    controllers: gridnms["controller.1"],
	    launch: function () {
	      gridarea = Ext.create(gridnms["views.prod"], {
	          renderTo: 'gridViewArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function fn_excel_download() {
	  var bigcd = $("#searchbigcd").val();
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var datefrom = $('#searchFrom').val();
	  var dateto = $('#searchTo').val();
	  var header = [],
	  count = 0;

	  if (datefrom === "") {
	    header.push("작업일자 From");
	    count++;
	  }

	  if (dateto === "") {
	    header.push("작업일자 To");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  }

	  go_url("<c:url value='/prod/state/AccPerformExcelDownload.do?ORGID='/>" + $('#searchOrgId option:selected').val() + ""
	     + "&COMPANYID=" + $('#searchCompanyId option:selected').val() + ""
	     + "&SEARCHFROM=" + $("#SearchFrom").val() + ""
	     + "&SEARCHTO=" + $("#SearchTo").val() + ""
	     + "&WORKDEPT=" + $("#WorkDept").val() + ""
	     + "&WORKCENTERCODE=" + $("#searchWorkCentercd").val() + ""
	     + "&EMPLOYEENUMBER=" + $("#searchWorkerCode").val() + ""
	     + "&ITEMCODE=" + $("#searchItemcd").val() + ""
	     + "&ORDERNAME=" + $("#searchOrdernm").val() + ""
	     + "&ITEMNAME=" + $("#searchItemnm").val() + ""
	     + "&MODELNAME=" + $("#searchModelName").val() + "");
	}

	function fn_search() {
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var datefrom = $('#SearchFrom').val();
	  var dateto = $('#SearchTo').val();
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
	    header.push("작업일자 From");
	    count++;
	  }

	  if (dateto === "") {
	    header.push("작업일자 To");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return;
	  }

	  var sparams = {
	    ORGID: $('#searchOrgId option:selected').val(),
	    COMPANYID: $('#searchCompanyId option:selected').val(),
	    SEARCHFROM: datefrom,
	    SEARCHTO: dateto,
	    WORKDEPT: $('#WorkDept').val(),
	    WORKCENTERCODE: $('#searchWorkCentercd').val(),
	    EMPLOYEENUMBER: $('#searchWorkerCode').val(),
	    ITEMCODE: $('#searchItemcd').val(),
	    ORDERNAME: $('#searchOrdernm').val(),
	    ITEMNAME: $('#searchItemnm').val(),
	    MODELNAME: $('#searchModelName').val(),
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_print(flag) {
	  var searchdate = $('#SearchDate').val();
	  var header = [],
	  count = 0;

	  if (searchdate === "") {
	    header.push("출력일자");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return;
	  }

	  var url = "";
	  var column = 'master';
	  var target = '_blank';

	  switch (flag) {
	  case '1':
	    url = "<c:url value='/report/DayProdStateReport.pdf'/>";
	    fn_popup_url(column, url, target);

	    break;
	  case '2':
	    url = "<c:url value='/report/DailyLaborReport.pdf'/>";
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

	  // 작업자 Lov
	  $("#searchWorker")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchWorkerCode").val("");
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
	      $.getJSON("<c:url value='/searchWorkerLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        INSPECTORTYPE: '20', // 생산관리직
	        NOTEMP: 'F0001',
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
	      $("#searchWorkerCode").val(o.item.value);
	      $("#searchWorker").val(o.item.label);
	      return false;
	    }
	  });

	  //    // 품번 LOV
	  //    $("#searchOrdernm")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        //          $("#searchOrdernm").val("");
	  //        $("#searchItemcd").val("");
	  //        $("#searchItemnm").val("");
	  //        $("#searchModel").val("");
	  //        $("#searchModelName").val("");
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
	  //          GUBUN: 'ORDERNAME',
	  //          ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ORDERNAME + ', ' + m.ITEMNAME + ', ' + m.MODELNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //                MODEL: m.MODEL,
	  //                MODELNAME: m.MODELNAME,
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
	  //        $("#searchItemcd").val(o.item.ITEMCODE);
	  //        $("#searchItemnm").val(o.item.ITEMNAME);
	  //        $("#searchOrdernm").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);
	  //        return false;
	  //      }
	  //    });

	  //    // 품명 LOV
	  //    $("#searchItemnm")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        $("#searchOrdernm").val("");
	  //        $("#searchItemcd").val("");
	  //        $("#searchModel").val("");
	  //        $("#searchModelName").val("");

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
	  //          GUBUN: 'ITEMNAME',
	  //          ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ITEMNAME + ', ' + m.ORDERNAME + ', ' + m.MODELNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //                MODEL: m.MODEL,
	  //                MODELNAME: m.MODELNAME,
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
	  //        $("#searchItemcd").val(o.item.ITEMCODE);
	  //        $("#searchItemnm").val(o.item.ITEMNAME);
	  //        $("#searchOrdernm").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);
	  //        return false;
	  //      }
	  //    });

	  // 설비명 lov
	  $("#searchWorkCenternm")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchWorkCentercd").val("");
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
	      $.getJSON("<c:url value='/searchWorkCenterLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val()
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL,
	              name: m.LABEL,
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
	      $("#searchWorkCenternm").val(o.item.name);
	      $("#searchWorkCentercd").val(o.item.value);
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
                                <li>공정 현황</li>
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
                        <input type="hidden" id="ORGID" />
                        <input type="hidden" id="COMPANYID" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                            <form id="master" name="master" action="" method="post">
                                <input type="hidden" id="searchModel" name="searchModel" />
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
                                                       일일생산현황표
                                                    </a>
                                                    <a id="btnChk4" class="btn_print" href="#" onclick="javascript:fn_print('2');">
                                                       작업일보
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
                                            <th class="required_text">작업일자</th>
                                            <td>
                                                <input type="text" id="SearchFrom" name="SearchFrom" class="input_validation input_center validate[custom[date],past[#searchSearchTo]]" style="width: 120px; " maxlength="10" />
                                                &nbsp;~&nbsp;
                                                <input type="text" id="SearchTo" name="SearchTo" class="input_validation input_center validate[custom[date],future[#searchSearchFrom]]" style="width: 120px; " maxlength="10"  />
                                            </td>
																				    <th class="required_text">작업반</th>
																				    <td><select id="WorkDept" name="WorkDept" class="input_left" style="width: 97%;">
																				            <c:if test="${empty searchVO.WORKDEPT}">
																				                <option value="" >전체</option>
																				            </c:if>
																				            <c:forEach var="item" items="${labelBox.findByWorkDeptGubun}" varStatus="status">
																				                <c:choose>
																				                    <c:when test="${item.VALUE==searchVO.WORKDEPT}">
																				                        <option value="${item.VALUE}" selected>${item.LABEL}</option>
																				                    </c:when>
																				                    <c:otherwise>
																				                        <option value="${item.VALUE}">${item.LABEL}</option>
																				                    </c:otherwise>
																				                </c:choose>
																				            </c:forEach>
																				        </select></td>
                                              <th class="required_text">설비명</th>
                                              <td>
                                                    <input type="text" id="searchWorkCenternm" name="searchWorkCenternm" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                                    <input type="hidden" id="searchWorkCentercd" name="searchWorkCentercd" />
                                              </td>
                                              <th class="required_text">작업자</th>
                                              <td>
                                                    <input type="text" id="searchWorker" name=searchWorker class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                                    <input type="hidden" id="searchWorkerCode" name="searchWorkerCode" />
                                              </td>
                                              <!-- <th class="required_text">출력일자</th>
                                              <td>
                                                  <input type="text" id="SearchDate" name="SearchDate" class="input_validation input_center " style="width: 90px; " maxlength="10" />
                                              </td> -->
                                        </tr>   
                                        <tr style="height: 34px;">
					                                    <th class="required_text">품번</th>
					                                    <td>
					                                          <input type="text" id="searchOrdernm" name="searchOrdernm" class="input_left" style="width: 96%;" />
					                                    </td>
					                                    <th class="required_text">품명</th>
					                                    <td>
					                                          <input type="text" id="searchItemnm" name="searchItemnm"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
					                                          <input type="hidden" id="searchItemcd" name="searchItemcd" />
                                              </td>
						                                  <th class="required_text">기종</th>
						                                  <td >
						                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 96%;" />
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
                        <div id="gridViewArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                    </div>
                </div>
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