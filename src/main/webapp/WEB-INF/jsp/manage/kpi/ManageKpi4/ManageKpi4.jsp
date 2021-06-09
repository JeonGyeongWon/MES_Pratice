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
    	drawCharter();
  });

	var g_data;
	var status_data;
	// var header_g;
	var header_g = [' ', '출하예정', '출하실적', '납품율'];
	var row_g = "", msg_g = "", check_g = false;
	var status_g = "";
	function drawVisualization() {
	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    DATEYEAR: $('#searchdateYear').val(),
	  };

	  var datayear = $("#searchdateYear").val();

	  var url_x = '<c:url value="/select/manage/kpi/ManageKpi4List1.do" />';
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
	        row_g = [list.TRXMONTHS + "월", list.SOQTY, list.SHIPQTY, list.SHIPRATE];
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
	    bar: {
	      groupWidth: '40%'
	    },
	    legend: {
	      position: 'bottom',
	      alignment: 'center'
	    },
	    width: "100%",
	    height: 300,
	    //        vAxis: {
	    //            minValue: 0,
	    //            maxValue: 450,
	    //          },
	    dataOpacity: 0.7,
	    seriesType: "bars",
	    series: {
	      2: {
	        type: 'line',
	        targetAxisIndex: 1
	      }
	    },
	    vAxes: {
	      1: {
	        title: '납품율(%)',
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

	var d_data;
	var header_d;
	var row_d = "";
	var status_d = "";
	function drawCharter() {
	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    TXRDATEFROM: $('#searchFrom').val(),
	    ITEMNAME: $('#searchItemName').val(),
	    ORDERNAME: $('#searchOrderName').val(),
	  };

	  var url_x = '<c:url value="/select/manage/kpi/ManageKpi4List2.do" />';
	  $.ajax({
	    url: url_x,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {
	      var workname_header = new Array();
	      var work_value = new Array();
	      var work_hd = new Array();
	      var work_inhead = new Array();
	      var prodname_title = new Array();
	      var prodqty_temp = new Array();
	      var rows_temp = new Array();
	      var date_temp = new Array();

	      var charcount = data.totcnt;

	      var fromdate = $("#searchFrom").val();

	      var strdate = fromdate.split("-");

	      var dt = new Date(strdate[0], strdate[1], 0);
	      var lastdate = dt.getDate();

	      // 중복된 이름 걸러낸다.
	      var n_count = 0;
	      for (var i = 0; i < charcount; i++) {
	        var list = data.data[i];
	        n_count = 0;
	        for (k = 0; k < work_hd.length; k++) {
	          if (work_hd[k] == list.ITEMNAME) {
	            n_count++;
	          }
	        }
	        if (n_count == 0) {
	          work_hd.push(list.ITEMNAME);
	        }
	      }
	      work_hd.sort();

	      // DB에 있는 날짜만
	      var c_count = 0;
	      for (var j = 0; j < charcount; j++) {
	        var list = data.data[j];
	        c_count = 0;
	        for (l = 0; l < date_temp.length; l++) {
	          if (date_temp[l] == list.SHIPDATE) {
	            c_count++;
	          }
	        }
	        if (c_count == 0) {
	          date_temp.push(list.SHIPDATE);
	        }
	      }
	      date_temp.sort();

	      for (n = 0; n < date_temp.length; n++) {

	        // 2. 중복 제거된 설비명을 가지고 Loop
	        var v_count = 0;
	        prodqty_temp = [];
	        prodname_title = [];
	        prodname_title[0] = " ";

	        prodqty_temp[0] = date_temp[n] + "일";
	        for (var k = 0; k < work_hd.length; k++) {
	          v_count = 0;
	          var qty = 0;
	          // 중복제거된 설비명 Loop
	          for (var i = 0; i < charcount; i++) {
	            var list = data.data[i];
	            var enddate = parseInt(date_temp[n]);

	            if (work_hd[k] == list.ITEMNAME) { // 이름이 중복 된 애들의 데이터를 넣지않기위해서 설비명 중복여부 체크

	              if ((list.SHIPDATE * 1) == enddate) { // 같은 일자인지 체크
	                //                                            prodqty_temp.push( list.PRODUCEDQTY );
	                //                                            prodname_temp.push( list.WORKCENTERNAME );
	                ++v_count;
	                qty = list.SHIPQTY;
	              }
	            }

	          }

	          if (v_count > 0) {
	            prodqty_temp.push(qty);
	            prodname_title.push(work_hd[k]);
	          } else { // 12월달까지 값은 없어도 보이려면 타이틀에 푸쉬하고 값을 0으로 줘야 함
	            prodqty_temp.push(0);
	            prodname_title.push(work_hd[k]);
	          }
	        }
	        rows_temp.push(prodqty_temp);
	      }
	      var jsonData_x = [prodname_title].concat(rows_temp);
	      d_data = google.visualization.arrayToDataTable(jsonData_x);

	      setChartd(d_data);
	    },
	    error: ajaxError
	  });
	}

	function setChartd(data_val) {
	  var options = {
	    fontName: 'Malgun Gothic',
	    focusTarget: 'category',
	    bar: {
	      groupWidth: '100%'
	    },
	    legend: {
	      position: 'right',
	      //                  alignment: 'center'
	    },
	    width: "100%",
	    height: 300,
	    vAxis: {
	      minValue: 0,
	      maxValue: 20,
	    },
	    allowHtml: true,
      chartArea:{
	      left: "10%",
	      width: "75%",
	      height: 250,
	    }
	  };

	  var chart = new google.visualization.LineChart(document.getElementById('chart_div2'));
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
	      type: 'number',
	      name: 'RN',
	    }, {
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'string',
	      name: 'BIGNAME',
	    }, {
	      type: 'string',
	      name: 'MIDDLENAME',
	    }, {
	      type: 'string',
	      name: 'SMALLNAME',
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
	      name: 'SHIPPERSON',
	    }, {
	      type: 'string',
	      name: 'SHIPPERSONNAME',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERGUBUN',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERGUBUNNAME',
	    }, {
	      type: 'number',
	      name: 'SHIPQTY',
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
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 220,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'SHIPDATE',
	      text: '출하일',
	      xtype: 'datecolumn',
	      width: 105,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: true,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'SHIPPERSONNAME',
	      text: '담당자',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	    }, {
	      dataIndex: 'SHIPQTY',
	      text: '출하량',
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
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/manage/kpi/ManageKpi4List3.do' />"
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
//	             $("#searchREQFrom").val(record.get("TXRDATETO"));
//	             $("#searchREQTo").val(record.get("TXRDATEFROM"));
//	             $("#orgid").val(record.get("ORGID"));
//	             $("#companyid").val(record.get("COMPANYID"));
//	             var reqfrom = $('#searchREQFrom').val();
//	             var reqto = $('#searchREQTo').val();
//	             var OrgIdVal = $('#orgid').val();
//	             var CompanyIdVal = $('#companyid').val();

//	             var params = {
//	               TXRDATETO :   reqto,
//	               TXRDATEFROM :   reqfrom,
//	               orgid : OrgIdVal,
//	               companyid : CompanyIdVal,
//	             };

//	             extGridSearch(params, gridnms["store.2"]);
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
	                TXRDATEFROM: '${searchVO.dateFrom}',
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                ITEMNAME: $('#searchItemName').val(),
	                ORDERNAME: $('#searchOrderName').val(),
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
	        height: 332, // 200,
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
	                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('SHIPPERSONNAME') >= 0) {
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

	function fn_search() {
	  // 필수 체크
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchfrom = $('#searchFrom').val();
	  var itemname = $('#searchItemName').val();
	  var ordername = $('#searchOrderName').val();
	  var header = [],
	  count = 0;

	  if (searchfrom === "") {
	    header.push("제조월");
	    count++;
	  }

	  //    if (workcode === "") {
	  //      header.push("설비명");
	  //      count++;
	  //    }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  }

	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    TXRDATEFROM: $('#searchFrom').val(),
	    ITEMNAME: $('#searchItemName').val(),
	    ORDERNAME: $('#searchOrderName').val(),
	    //      GUBUN: 'LIST',
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  var sparams1 = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    TXRDATEFROM: $('#searchFrom').val(),
	    ITEMNAME: $('#searchItemName').val(),
	    ORDERNAME: $('#searchOrderName').val(),
	  };

	  url = "<c:url value='/select/manage/kpi/ManageKpi4List2.do' />";

	  $.ajax({
	    url: url,
	    type: "post",
	    dataType: "json",
	    data: sparams1,
	    success: function (data) {

	      if (data.totcnt == 0) {
	        extAlert("해당 제조 월의 데이터가 없습니다.");
	        drawCharter();
	      } else {
	        drawCharter();
	      }
	    },
	    error: ajaxError
	  });
	  drawCharter();
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
	  };

	  url = "<c:url value='/select/manage/kpi/ManageKpi4List1.do' />";

	  $.ajax({
	    url: url,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {

	      if (data.totcnt == 0) {
	        extAlert("해당 년도의 데이터가 없습니다.");
	        drawVisualization();
	      } else {
	        drawVisualization();
	      }
	    },
	    error: ajaxError
	  });

	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 품목 Lov
	  $("#searchItemcd")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //         $("#searchItemcd").val("");
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
	        GUBUN: '07', // 제품
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.ITEMCODE + ', ' + m.ITEMNAME + ', ' + m.ORDERNAME,
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
	      $("#searchItemcd").val(o.item.ITEMNAME);
	      $("#searchItemnm").val(o.item.value);
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
					<input type="hidden" id="searchGroupCode" name=searchGroupCode value="P" />
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
                    <col width="120px">
                    <col>
                  </colgroup>
                  <tr style="height: 34px;">
                    <th class="required_text">년도</th>
                    <td>
                    <input type="text" id="searchdateYear" name="searchdateYear" class="input_validation input_center" style="width: 150px;" maxlength="10" />
<!--                    &nbsp;~&nbsp; -->
<!--                    <input type="text" id="searchTo" name="searchTo" class="input_validation input_center" style="width: 90px;" maxlength="10" /> -->
                    </td>
                  </tr>
                </table>
                
                <div id="chart_div" style="width: 100%; height: 30%"></div>

								<table class="tbl_type_view" border="1">
									<colgroup>
										<col width="120px">
										<col>
										<col width="120px">
                    <col>
                    <col width="120px">
                    <col>
										<col>
									</colgroup>
									<tr style="height: 34px;">
										<th class="required_text">제조월</th>
										<td>
										<input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 150px;" maxlength="10" />
										</td>
                    <th class="required_text">품번</th>
                    <td><input type="text" id="searchOrderName" name="searchOrderName" class="input_center" style="width: 150px"; /></td>
                    <th class="required_text">품명</th>
                    <td><input type="text" id="searchItemName" name="searchItemName" class="input_center" style="width: 150px"; /></td>
<!-- 										<th class="required_text">품명</th> -->
<!-- 										<td><input type="text" id="searchItemcd" name="searchItemcd" class="input_center" style="width: 150px"; /> -->
<!--                     <input type="hidden" id="searchItemnm" name="searchItemnm" /></td> -->
                    
<!--                     <td><select id="searchItemnm" name="searchItemnm" class="input_left validate[required]" style="width: 150px;"> -->
<%--                         <c:if test="${empty searchVO.WorkCode}"> --%>
<!--                             <option value="" label="전체" /> -->
<%--                         </c:if> --%>
<%--                         <c:forEach var="item" items="${labelBox.findByWorkCode}" varStatus="status"> --%>
<%--                             <c:choose> --%>
<%--                                 <c:when test="${item.VALUE==searchVO.WorkCode}"> --%>
<%--                                     <option value="${item.VALUE}" selected>${item.LABEL}</option> --%>
<%--                                 </c:when> --%>
<%--                                 <c:otherwise> --%>
<%--                                     <option value="${item.VALUE}">${item.LABEL}</option> --%>
<%--                                 </c:otherwise> --%>
<%--                             </c:choose> --%>
<%--                         </c:forEach> --%>
<!--                     </select></td> -->
                    <td><div class="buttons" style="float: right; margin-top: 3px;">
                        <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                      </div>
                    </td>
									</tr>
								</table>
								<div id="chart_div2" style="width: 100%; height: 30%"></div>
							</div>
						</form>
					</fieldset>
				</div>
				<!-- //검색 필드 박스 끝 -->
				<div style="width: 100%;">
					<div id="gridViewArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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