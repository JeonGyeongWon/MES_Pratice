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
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<!-- <script type="text/javascript" src="https://www.google.com/jsapi?autoload={ 'modules':[{ 'name':'visualization', 'version':'1', 'packages':['corechart'] }] }"></script> -->
<script type="text/javaScript">
$(document).ready(function () {
	  setInitial();

	  setValues();
	  setExtGrid();

	  setReadOnly();

	  setLovList();

	  setDummyTChart();

	  setTimeout(function () {
	    fn_chart_search();
	  }, 200);
	});

	function setInitial() {
	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "prod";

	  $("#searchFrom").val(getToDay("${searchVO.searchFrom}") + "");
	  $("#searchTo").val(getToDay("${searchVO.searchTo}") + "");

	  $("#searchItemCode").val("${searchVO.searchItemCode}");
	  $("#searchOrderName").val("${searchVO.searchOrderName}");
	  $("#searchItemName").val("${searchVO.searchItemName}");
	  $("#searchRoutingId").val("${searchVO.searchRoutingId}");
	  $("#searchRoutingName").val("${searchVO.searchRoutingName}");
	  $("#searchModel").val("${searchVO.searchModel}");
	  $("#searchModelName").val("${searchVO.searchModelName}");
	  $("#orgid").val("${searchVO.orgid}");
	  $("#companyid").val("${searchVO.companyid}");
	  $("#itemcode").val("${searchVO.itemcode}");
	  $("#ordername").val("${searchVO.ordername}");
	  $("#itemname").val("${searchVO.itemname}");
	  $("#model").val("${searchVO.model}");
	  $("#modelname").val("${searchVO.modelname}");
	  $("#routingid").val("${searchVO.routingid}");
	  $("#routingname").val("${searchVO.routingname}");
	}

	var t_data;
	//차트 데이터 Set
	var header_t = ["일자", "양품수량", "불량수량"];
	var row_t = "", msg_t = "", check_t = false;
	//var t_min = 0, t_max = 0;
	function tdrawChart(v) {
	  var title_name = $('#title').val();
	  var view = new google.visualization.DataView(v);

	  var options = {
	    //      title: title_name,
	    width: '100%',
	    height: 280,
	    fontName: 'Malgun Gothic',
	    focusTarget: 'category',
	    isStacked: true,
	    bar: {
	      groupWidth: '50%'
	    },
	    //        legend: {
	    //          position: 'right',
	    //          alignment: 'center',
	    //        },
	    legend: {
	      position: 'none'
	    },
	    series: {
	      0: {
	        targetAxisIndex: 0,
	        type: "bar",
	        color: "blue"
	      },
	    },
	    chartArea: {
	      width: '90%',
	      height: '60%',
	      left: 100,
	    },
	    role: {
	      opacity: 0.7,
	    },
	    vAxis: {
	      minValue: 0, // t_min,
	      maxValue: 10, // t_max,
	    },
	    hAxis: {
	      format: 'none',
	    },
	    //       seriesType: "bars",
	    dataOpacity: 0.7,
	    curveType: 'none',
	    animation: {
	      duration: 2 * 1000,
	      easing: 'out',
	      startup: true,
	    },
	    allowHtml: true,
	  };

	  var tchart = new google.visualization.ColumnChart(document.getElementById('TChartArea'));
	  tchart.draw(view, options);
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "ProdWorkTotalDetail";

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
	      type: 'number',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'date',
	      name: 'STANDARDDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'PRODQTY',
	    }, {
	      type: 'number',
	      name: 'IMPORTQTY',
	    }, {
	      type: 'number',
	      name: 'FAULTQTY',
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
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'STANDARDDATE',
	      text: '일자',
	      xtype: 'datecolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center; ',
	      align: "center",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 220,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center; ',
	      align: "left",
	    }, {
	      dataIndex: 'MODELNAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center; ',
	      align: "center",
	    }, {
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      summaryRenderer: function (value, meta, record) {
	        return ['TOTAL'].map(function (val) {
	          return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + val + '</div>';
	        }).join('<br />');
	      },
	    }, {
	      dataIndex: 'PRODQTY',
	      text: '생산수량',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, summaryData, dataIndex) {
	        var data = Ext.getStore(gridnms["store.1"]).getData().items;
	        var values = extExtractValues(data, dataIndex);
	        var total = value;

	        var result = [total].map(function (val) {
	          return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(val, '0,000') + '</div>';
	        }).join('<br />');
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'IMPORTQTY',
	      text: '양품수량',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, summaryData, dataIndex) {
	        var data = Ext.getStore(gridnms["store.1"]).getData().items;
	        var values = extExtractValues(data, dataIndex);
	        var total = value;

	        var result = [total].map(function (val) {
	          return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(val, '0,000') + '</div>';
	        }).join('<br />');
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'FAULTQTY',
	      text: '불량수량',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: 'sum',
	      summaryRenderer: function (value, summaryData, dataIndex) {
	        var data = Ext.getStore(gridnms["store.1"]).getData().items;
	        var values = extExtractValues(data, dataIndex);
	        var total = value;

	        var result = [total].map(function (val) {
	          return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(val, '0,000') + '</div>';
	        }).join('<br />');
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
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
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'DRAWINGNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODEL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/manage/ProdWorkTotalDetail.do' />"
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
	                SEARCHFROM: $('#searchFrom').val(),
	                SEARCHTO: $('#searchTo').val(),
	                ITEMCODE: $('#itemcode').val(),
	                ROUTINGID: $('#routingid').val(),
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
	      ProdWorkTotalDetail: '#ProdWorkTotalDetail',
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
	        height: 314,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          },
	          'gridfilters',
	        ],
	        features: [$.extend(gridVals.groupingFeature, {
	            groupHeaderTpl: [
	              '{columnName}: {name:this.formatName}' +
	              ' / 목표수량: {[this.groupSum(values.children, "WORKORDERQTY")]}' +
	              ' / 실적수량: {[this.groupSum(values.children, "PRODQTY")]}', {
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
	          }),
	          //{
	          //  ftype: 'summary',
	          //  dock: 'bottom'
	          //}
	        ],
	        viewConfig: {
	          itemId: 'ProdWorkTotalDetail',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
	                  }
	                }

	                if (column.dataIndex.indexOf('MODELNAME') >= 0) {
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
	      gridarea = Ext.create(gridnms["views.list"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function fn_chart_search() {
	  var sparams = {
	    ORGID: $('#searchOrgId option:selected').val(),
	    COMPANYID: $('#searchCompanyId option:selected').val(),
	    SEARCHFROM: $('#searchFrom').val(),
	    SEARCHTO: $('#searchTo').val(),
	    ITEMCODE: $('#itemcode').val(),
	    ROUTINGID: $('#routingid').val(),
	  };

	  var url_t = "<c:url value='/select/prod/manage/ProdWorkTotalDetail.do'/>";
	  $.ajax({
	    url: url_t,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {
	      var rows = new Array();
	      if (data.totcnt == 0) {
	        msg_t = "조회하신 항목에 대한 데이터가 없습니다.";
	        check_t = false;

	        setDummyTChart();
	      } else {
	        msg_t = "데이터가 " + data.totcnt + "건 조회되었습니다.";
	        check_t = true;

	        var rows = new Array();
	        for (var i = 0; i < data.totcnt; i++) {
	          row_t = [data.data[i].STANDARDDATE, data.data[i].IMPORTQTY, data.data[i].FAULTQTY];
	          rows.push(row_t);
	        }

	        var jsonData_t = [header_t].concat(rows);
	        t_data = google.visualization.arrayToDataTable(jsonData_t);

	        // 차트 호출
	        tdrawChart(t_data);
	      }

	      if (check_t == false) {
	        extAlert(msg_t);
	        return;
	      }
	    },
	    error: ajaxError
	  });
	}

	function setDummyTChart() {

	  var rows = new Array();
	  // Dummy 데이터 Set
	  row_t = [null, 0, 0];
	  rows.push(row_t);
	  //    s_min = 0;
	  //    s_max = 0;

	  var jsonData_t = [header_t].concat(rows);
	  t_data = google.visualization.arrayToDataTable(jsonData_t);

	  // 차트 호출
	  tdrawChart(t_data);
	}

	function fn_list() {
// 	  go_url('<c:url value="/prod/manage/ProdWorkTotalList.do" />');
	  var column = 'master';
	  var url = "<c:url value='/prod/manage/ProdWorkTotalList.do'/>";
	  var target = '_self';

	  fn_popup_url(column, url, target);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {

	  //    // 품번 LOV
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
	  //        //          $("#searchOrderName").val("");
	  //        $("#searchItemCode").val("");
	  //        $("#searchItemName").val("");
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
	  //        $("#searchItemCode").val(o.item.ITEMCODE);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);

	  //        return false;
	  //      }
	  //    });

	  //    // 품명 LOV
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
	  //        $("#searchOrderName").val("");
	  //        $("#searchItemCode").val("");
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
	  //        $("#searchItemCode").val(o.item.ITEMCODE);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);

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
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
		                        <input type="hidden" id="searchItemCode" name="searchItemCode" />
                            <input type="hidden" id="searchOrderName" name="searchOrderName" />
                            <input type="hidden" id="searchItemName" name="searchItemName" />
		                        <input type="hidden" id="searchRoutingId" name="searchRoutingId" />
                            <input type="hidden" id="searchRoutingName" name="searchRoutingName" />
		                        <input type="hidden" id="searchModel" name="searchModel" />
                            <input type="hidden" id="searchModelName" name="searchModelName" />
                            <input type="hidden" id="ItemType" name="ItemType" />
		                        <input type="hidden" id="orgid" name="orgid" />
		                        <input type="hidden" id="companyid" name="companyid" />
                            <input type="hidden" id="itemcode" name="itemcode" />
                            <input type="hidden" id="model" name="model" />
                            <input type="hidden" id="routingid" name="routingid" />
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
                                                <a id="btnChk2" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="120px">
                                        <col width="17%">
                                        <col width="120px">
                                        <col width="17%">
                                        <col width="120px">
                                        <col width="17%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">일자</th>
                                        <td >
                                            <input type="text" id="searchFrom" name="searchFrom" class=" input_center" style="width: 90px; " maxlength="10" readonly />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchTo" name="searchTo" class=" input_center" style="width: 90px; " maxlength="10"  readonly />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="ordername" name="ordername" class=" input_left " style="width: 97%; " readonly />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="itemname" name="itemname"  class="input_left" style="width: 97%;" readonly />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
			                                  <th class="required_text">기종</th>
			                                  <td >
			                                      <input type="text" id="modelname" name="modelname"  class="input_left" style="width: 97%;" readonly />
			                                  </td>
                                        <th class="required_text">공정명</th>
                                        <td >
                                            <input type="text" id="routingname" name="routingname" class=" input_center " style="width: 97%; " readonly />
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
			                      <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">실적집계</div></td>
			                  </tr>
			              </table>
                    <div id="TChartArea" style="width: 100%; height: 287px; padding-top: 0px; padding-left: 0px; margin-top: 10px; margin: 0px; float: left;"></div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">실적현황</div></td>
                        </tr>
                    </table>
                    <div id="gridArea" style="width: 100%; padding-bottom: 0px; margin-bottom: 5px; float: left;"></div>
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