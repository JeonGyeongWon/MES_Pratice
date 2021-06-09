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

<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<!-- <script type="text/javascript" src="https://www.google.com/jsapi?autoload={ 'modules':[{ 'name':'visualization', 'version':'1', 'packages':['corechart'] }] }"></script> -->
<script type="text/javaScript">
google.charts.load('current', {
	  packages: ['corechart']
	});
	google.charts.setOnLoadCallback(
	  function () {
		  drawVisualization();
	});

	var g_data;
	var status_data;
	// var header_g;
	var row_g = "", msg_g = "", check_g = false;
	var status_g = "";
	function drawVisualization() {
	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    DATEYEAR: $('#searchdateYear').val(),
	    CUSTOMERNAME: $('#searchCustomerName').val(),
	    ORDERNAME: $('#searchOrdernm').val(),
	    ITEMNAME: $('#searchItemnm').val(),
	    CARTYPENAME: $('#searchCarTypeName').val(),
	    ROUTINGNAME: $('#searchRoutingName').val(),
	  };

	  var datayear = $("#searchdateYear").val();
	  var header_g = [' ', ((datayear * 1) - 2) + '생산수량', ((datayear * 1) - 2) + '불량수량', ((datayear * 1) - 2) + '불량율', ((datayear * 1) - 1) + '생산수량', ((datayear * 1) - 1) + '불량수량', ((datayear * 1) - 1) + '불량율', datayear + '생산수량', datayear + '불량수량', datayear + '불량율'];

	  var url_x = '<c:url value="/select/prod/insp/FaultStatusKpiList.do" />';

	  $.ajax({
	    url: url_x,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {
	      var rows_temp = new Array();
	      var charcount = data.totcnt;

	      for (var i = 0; i < charcount; i++) {
	        var list = data.data[i];
	        row_g = [list.MONTHTITLE, list.PRODY2, list.FAULTY2, list.RATEY2, list.PRODY1, list.FAULTY1, list.RATEY1, list.PRODY0, list.FAULTY0, list.RATEY0];
	        rows_temp.push(row_g);
	      }
	      var jsonData_x = [header_g].concat(rows_temp);
	      g_data = google.visualization.arrayToDataTable(jsonData_x);
	      // 차트 호출
	      setLineChart(g_data);

	    },
	    error: ajaxError
	  });
	}

	function setLineChart(data_val) {
	  var dyear = $('#searchdateYear').val();

	  var options = {
	    fontName: 'Malgun Gothic',
	    focusTarget: 'category', /* 'category', */
	    tooltip: {
	      trigger: 'selection'
	    },
	    bar: {
	      groupWidth: '40%'
	    },
	    legend: {
	      position: 'bottom',
	      alignment: 'center'
	    },
	    width: "100%",
	    height: 300,
	    dataOpacity: 0.7,
	    seriesType: 'bars',
	    series: {
	      2: {
	        type: 'line',
	        targetAxisIndex: 1,
	      },
	      5: {
	        type: 'line',
	        targetAxisIndex: 1,
	      },
	      8: {
	        type: 'line',
	        targetAxisIndex: 1,
	      }
	    },
	    vAxes: {
	      1: {
	        title: '불량율(%)',
	        textStyle: {
	          color: '#ff9900'
	        }
	      }
	    },
	    animation: {
	      duration: 2000,
	      easing: 'out',
	      startup: true,
	    },
	    allowHtml: true,
	  };

	  var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
	  chart.draw(data_val, options);
	}

	$(document).ready(function () {
	  setInitial();

	  setValues();
	  setExtGrid();

	  setLovList();
	  setReadOnly();
	});

	function setInitial() {
	  gridnms["app"] = "manage";

	  $("#searchFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchdateYear").val(getToDay("${searchVO.dateYear}") + "");
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.viewer"] = [];
	  gridnms["stores.viewer"] = [];
	  gridnms["views.viewer"] = [];
	  gridnms["controllers.viewer"] = [];

	  //    gridnms["models.detail"] = [];
	  //    gridnms["stores.detail"] = [];
	  //    gridnms["views.detail"] = [];
	  //    gridnms["controllers.detail"] = [];

	  gridnms["grid.1"] = "ManageKpi1List1";
	  //    gridnms["grid.2"] = "ManageKpi1List2";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.viewer"].push(gridnms["panel.1"]);

	  //    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  //    gridnms["views.detail"].push(gridnms["panel.2"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.viewer"].push(gridnms["controller.1"]);

	  //    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  //    gridnms["controllers.detail"].push(gridnms["controller.2"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  //    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  //    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.viewer"].push(gridnms["model.1"]);
	  //    gridnms["models.detail"].push(gridnms["model.2"]);

	  gridnms["stores.viewer"].push(gridnms["store.1"]);
	  //    gridnms["stores.detail"].push(gridnms["store.2"]);

	  fields["model.1"] = [{
	      type: 'string',
	      name: 'RN',
	    }, {
	      type: 'string',
	      name: 'YYYY',
	    }, {
	      type: 'string',
	      name: 'GUBUNCODE',
	    }, {
	      type: 'string',
	      name: 'GUBUNNAME',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY01',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY02',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY03',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY04',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY05',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY06',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY07',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY08',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY09',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY10',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY11',
	    }, {
	      type: 'number',
	      name: 'MONTHQTY12',
	    }, {
	      type: 'number',
	      name: 'TOTALMONTHQTY',
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
	    }, {
	      dataIndex: 'YYYY',
	      text: '년도',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'GUBUNNAME',
	      text: '구분',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "center",
	    }, {
	      dataIndex: 'MONTHQTY01',
	      text: '1월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY02',
	      text: '2월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY03',
	      text: '3월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY04',
	      text: '4월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY05',
	      text: '5월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY06',
	      text: '6월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY07',
	      text: '7월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY08',
	      text: '8월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY09',
	      text: '9월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY10',
	      text: '10월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY11',
	      text: '11월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTHQTY12',
	      text: '12월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'TOTALMONTHQTY',
	      text: '합계',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, eOpts) {
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
	      dataIndex: 'CUSTOMERGUBUN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODEL',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/insp/FaultStatusList.do' />"
	  });

	  //   items["api.2"] = {};
	  //   $.extend(items["api.2"], {
	  //       read : "<c:url value='/select/manage/kpi/ManageKpi2List2.do' />"
	  //   });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};
	  //   $.extend(items["btns.ctr.1"], {
	  //       "#btnList" : {
	  //           itemclick : 'onMyviewItemcodelistClick'
	  //       }
	  //   });

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

	  //    items["btns.2"] = [];

	  //    items["btns.ctr.2"] = {};

	  //    items["dock.paging.2"] = {
	  //      xtype: 'pagingtoolbar',
	  //      dock: 'bottom',
	  //      displayInfo: true,
	  //      store: gridnms["store.2"],
	  //    };

	  //    items["dock.btn.2"] = {
	  //      xtype: 'toolbar',
	  //      dock: 'top',
	  //      displayInfo: true,
	  //      store: gridnms["store.2"],
	  //      items: items["btns.2"],
	  //    };

	  //    items["docked.2"] = [];
	}

	// function onMyviewItemcodelistClick(dataview, record, item, index, e, eOpts) {
//	                   $("#searchREQFrom").val(record.get("TXRDATETO"));
//	                   $("#searchREQTo").val(record.get("TXRDATEFROM"));
//	                   $("#orgid").val(record.get("ORGID"));
//	                   $("#companyid").val(record.get("COMPANYID"));
//	                   var reqfrom = $('#searchREQFrom').val();
//	                   var reqto = $('#searchREQTo').val();
//	                   var OrgIdVal = $('#orgid').val();
//	                   var CompanyIdVal = $('#companyid').val();

//	                   var params = {
//	                     TXRDATETO :   reqto,
//	                     TXRDATEFROM :   reqfrom,
//	                     orgid : OrgIdVal,
//	                     companyid : CompanyIdVal,
//	                   };

//	                   extGridSearch(params, gridnms["store.2"]);
	// }

	var gridarea, gridareadetail;
	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
	  });

	  //    Ext.define(gridnms["model.2"], {
	  //      extend: Ext.data.Model,
	  //      fields: fields["model.2"],
	  //    });

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
	                DATEYEAR: $('#searchdateYear').val(),
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  //    Ext.define(gridnms["store.2"], {
	  //      extend: Ext.data.JsonStore, // Ext.data.Store,
	  //      constructor: function (cfg) {
	  //        var me = this;
	  //        cfg = cfg || {};
	  //        me.callParent([Ext.apply({
	  //              storeId: gridnms["store.2"],
	  //              model: gridnms["model.2"],
	  //              autoLoad: true,
	  //              isStore: false,
	  //              autoDestroy: true,
	  //              clearOnPageLoad: true,
	  //              clearRemovedOnLoad: true,
	  //              pageSize: 9999,
	  //              proxy: {
	  //                type: 'ajax',
	  //                api: items["api.2"],
	  //                extraParams: {
	  //                  TXRDATEFROM: '${searchVO.dateFrom}',
	  //                  //                              TXRDATETO : '${searchVO.dateTo}',
	  //                  ORGID: $('#searchOrgId option:selected').val(),
	  //                  COMPANYID: $('#searchCompanyId option:selected').val(),
	  //                },
	  //                reader: gridVals.reader,
	  //                writer: $.extend(gridVals.writer, {
	  //                  writeAllFields: true
	  //                }),
	  //              }
	  //            }, cfg)]);
	  //      },
	  //    });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnList: '#btnList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],
	    //          onMyviewItemcodelistClick : onMyviewItemcodelistClick,
	  });

	  //    Ext.define(gridnms["controller.2"], {
	  //      extend: Ext.app.Controller,
	  //      refs: {
	  //        btnList: '#btnListDetail',
	  //      },
	  //      stores: [gridnms["store.2"]],
	  //      control: items["btns.ctr.1"],
	  //    });

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
	        height: 332,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
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
	                if (column.dataIndex.indexOf('OWNERCUSTOMERNAME') >= 0 || column.dataIndex.indexOf('OWNERPERSONNAME') >= 0 || column.dataIndex.indexOf('MGRCUSTOMERNAME') >= 0 || column.dataIndex.indexOf('MGRPERSONNAME') >= 0 || column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('CUSTOMERPERSONNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('PROJECTNO') >= 0 || column.dataIndex.indexOf('QUOTATIONPJT') >= 0 || column.dataIndex.indexOf('SERIALNO') >= 0 || column.dataIndex.indexOf('BIGNAME') >= 0 || column.dataIndex.indexOf('MIDDLENAME') >= 0 || column.dataIndex.indexOf('SMALLNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
	                  }
	                }
	              });
	            }
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

	  //    Ext.define(gridnms["panel.2"], {
	  //      extend: Ext.panel.Panel,
	  //      alias: 'widget.' + gridnms["panel.2"],
	  //      layout: 'fit',
	  //      header: false,
	  //      items: [{
	  //          xtype: 'gridpanel',
	  //          selType: 'cellmodel',
	  //          itemId: gridnms["panel.2"],
	  //          id: gridnms["panel.2"],
	  //          store: gridnms["store.2"],
	  //          height: 200,
	  //          border: 2,
	  //          scrollable: true,
	  //          columns: fields["columns.2"],
	  //          autoDestroy: true,
	  //          clearOnPageLoad: true,
	  //          clearRemovedOnLoad: true,
	  //          viewConfig: {
	  //            itemId: 'btnListDetail',
	  //            listeners: {
	  //              refresh: function (dataView) {
	  //                Ext.each(dataView.panel.columns, function (column) {
	  //                  if (column.autoResizeWidth)
	  //                    column.autoSize();
	  //                });
	  //              }
	  //            }
	  //          },
	  //          bufferedRenderer: false,
	  //          plugins: [{
	  //              ptype: 'cellediting',
	  //              clicksToEdit: 1,
	  //            }
	  //          ],
	  //          dockedItems: items["docked.2"],
	  //        }
	  //      ],
	  //    });

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

	  //    Ext.application({
	  //      name: gridnms["app"],
	  //      models: gridnms["models.detail"],
	  //      stores: gridnms["stores.detail"],
	  //      views: gridnms["views.detail"],
	  //      controllers: gridnms["controller.2"],

	  //      launch: function () {
	  //        gridareadetail = Ext.create(gridnms["views.detail"], {
	  //            renderTo: 'gridViewAreaDetail'
	  //          });
	  //      },
	  //    });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	    //        gridareadetail.updateLayout();
	  });
	}

	function fn_search_y() {
	  // 필수 체크
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchdateyear = $('#searchdateYear').val();
	  var header = [],
	  count = 0;

	  if (searchdateyear === "") {
	    header.push("년도");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  }

	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    DATEYEAR: $('#searchdateYear').val(),
	    CUSTOMERNAME: $('#searchCustomerName').val(),
	    ORDERNAME: $('#searchOrdernm').val(),
	    ITEMNAME: $('#searchItemnm').val(),
	    CARTYPENAME: $('#searchCarTypeName').val(),
	    ROUTINGNAME: $('#searchRoutingName').val(),
	  };

	  url = "<c:url value='/select/prod/insp/FaultStatusList.do' />";

	  $.ajax({
	    url: url,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {

	      if (data.totcnt == 0) {
	        extAlert("해당 조회조건에 대한 데이터가 없습니다.");
	        drawVisualization();
	        extGridSearch(sparams, gridnms["store.1"]);
	      } else {
	        drawVisualization();
	        extGridSearch(sparams, gridnms["store.1"]);
	      }
	    },
	    error: ajaxError
	  });

	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  //
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
							<li>KPI 관리</li>
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
					<input type="hidden" id="searchGroupCode" name=searchGroupCode value="A" />
					<input type="hidden" id="orgid" value="<c:out value='${OrgIdVal}'/>" />
					<input type="hidden" id="companyid" value="<c:out value='${CompanyIdVal}'/>" />
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
										<td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 50%;">
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
										</select></td>
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
												<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search_y();"> 조회 </a>
											</div>
										</td>
									</tr>
								</table>
								
                <table class="tbl_type_view" border="1">
                  <colgroup>
                    <col width="90px">
                    <col>
                    <col width="90px">
                    <col>
                    <col width="90px">
                    <col>
                    <col width="90px">
                    <col>
                  </colgroup>
                  <tr style="height: 34px;">
                    <th class="required_text">년도</th>
                    <td>
                          <input type="text" id="searchdateYear" name="searchdateYear" class="input_validation input_center" style="width: 150px;" maxlength="4" />
                    </td>
                    <th class="required_text">고객사</th>
                    <td>
                          <input type="text" id="searchCustomerName" name="searchCustomerName"  class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                    </td>
                    <th class="required_text">품번</th>
                    <td>
                          <input type="text" id="searchOrdernm" name="searchOrdernm"  class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                    </td>
                    <th class="required_text">품명</th>
                    <td>
                          <input type="text" id="searchItemnm" name="searchItemnm"  class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                    </td>
                  </tr>
                  <tr style="height: 34px;">
                    <th class="required_text">기종</th>
                    <td>
                          <input type="text" id="searchCarTypeName" name="searchCarTypeName"  class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                    </td>
                    <th class="required_text">공정</th>
                    <td>
                          <input type="text" id="searchRoutingName" name="searchRoutingName"  class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                    </td>
                    <td></td>
                    <td></td>
                    <td></td>
                    <td></td>
                  </tr>
                </table>
                
                <div id="chart_div" style="width: 100%; height: 30%"></div>
							</div>
						</form>
					</fieldset>
				</div>
				<!-- //검색 필드 박스 끝 -->
              <table style="width: 100%;">
                  <tr>
                      <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">내역</div></td>
                  </tr>
              </table>
          <div id="gridViewArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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