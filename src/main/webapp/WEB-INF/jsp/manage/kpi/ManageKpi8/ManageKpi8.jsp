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
		  drawCharter();
	});

	var d_data;
  var status_data;
	var header_d= ["기준월","소재금액","재공금액","완성품금액","합계금액","소재수량","재공수량","완성품수량","합계수량"];
	  var row_d = "", msg_d = "", check_d = false;
	  var status_d = "";
	function drawCharter() {
	  var sparams = {
		      ORGID: $('#searchOrgId').val(),
		      COMPANYID: $('#searchCompanyId').val(),
		      DATEYEAR: $('#searchdateYear').val(),
	  };

	  var url_x = '<c:url value="/select/manage/kpi/ManageKpi8List1.do" />';
	  $.ajax({
	    url: url_x,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {  var rows_temp = new Array();
        var charcount = data.totcnt;

        for (var i = 0; i < charcount; i++) {
          var list = data.data[i];
          row_d = [list.SEARCHMONTH + "월", list.MATCOUNT, list.ROUTCNT, list.FINISHITEM, list.TOTALCOUNT, list.MATPRICE, list.ROUTPRICE, list.FINISHITEMPRICE, list.TOTALPRICE];
          rows_temp.push(row_d);
        }
        var jsonData_x = [header_d].concat(rows_temp);
        d_data = google.visualization.arrayToDataTable(jsonData_x);
        // 차트 호출
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
	      groupWidth: '40%'
	    },
	    legend: {
	      position: 'right',
	      //                  alignment: 'center'
	    },
	    width: "100%",
	    height: 300,
	    //     vAxis: {
	    //       minValue: 0,
	    //       maxValue: 20,
	    //     },
	    dataOpacity: 0.7,
      seriesType: "bars",
      series: {
        4: {
          type: 'line',
          targetAxisIndex: 1
        },
	      5: {
          type: 'line',
          targetAxisIndex: 1
        },
        6: {
			    type: 'line',
			    targetAxisIndex: 1
			  },
			  7: {
          type: 'line',
          targetAxisIndex: 1
        },
      },
	    allowHtml: true,
	    chartArea:{
	      left: "10%",
	    	width: "75%",
	    	height: 250,
	    }
	  };

	  var chart = new google.visualization.ComboChart(document.getElementById('chart_div'));
	  chart.draw(data_val, options);
	}

	$(document).ready(function () {

	  setInitial();

	  setValues();
	  setExtGrid();

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  gridnms["app"] = "manage";

// 	    calender($('#searchdateYear'));

// 	    $('#searchdateYear').keyup(function (event) {
// 	          if (event.keyCode != '8') {
// 	              var v = this.value;
// 	              if (v.length === 4) {
// 	                  this.value = v + "-";
// 	              } else if (v.length === 7) {
// 	                  this.value = v + "-";
// 	              }
// 	          }
// 	      });

// 	  $("#searchdateYear").val(getToDay("${searchVO.dateFrom}") + "");
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

	  gridnms["grid.1"] = "ManageKpi8List1";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.viewer"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.viewer"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.viewer"].push(gridnms["model.1"]);

	  gridnms["stores.viewer"].push(gridnms["store.1"]);

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
	      name: 'DATE',
	    }, {
	      type: 'number',
	      name: 'QTY1',
	    }, {
	      type: 'number',
	      name: 'PRICE1',
	    }, {
        type: 'number',
        name: 'QTY2',
      }, {
        type: 'number',
        name: 'PRICE2',
	   }, {
	      type: 'number',
	      name: 'QTY3',
	    }, {
	      type: 'number',
	      name: 'PRICE3',
     }, {
	     type: 'number',
	     name: 'TOTALQTY',
	   }, {
	     type: 'number',
	     name: 'TOTALPRICE',
	     }, {
	     type: 'number',
	     name: 'AVGCOUNT',
	   }, {
	       type: 'number',
	       name: 'AVGPRICE',
	      
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      dataIndex: 'SEARCHMONTH',
	      text: '기준월',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryRenderer: function (value, meta, record) {
	          value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>평균</div>";
	          return value;
	        },
	    }, {
	        text: '소재',
	        sortable: false,
	        resizable: false,
	        menuDisabled: true,
	        style: 'text-align:center;',
	        columns: [{
				      dataIndex: 'MATCOUNT',
				      text: '수량',
				      xtype: 'gridcolumn',
				      width: 120,
				      hidden: false,
				      sortable: true,
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
				      dataIndex: 'MATPRICE',
				      text: '금액',
				      xtype: 'gridcolumn',
				      width: 120,
				      hidden: false,
				      sortable: true,
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
	    ]
    },{
        text: '재공',
        sortable: false,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center;',
        columns: [{
            dataIndex: 'ROUTCNT',
            text: '수량',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: true,
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
            dataIndex: 'ROUTPRICE',
            text: '금액',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: true,
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
    ]
  },{
      text: '완성품',
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      columns: [{
          dataIndex: 'FINISHITEM',
          text: '수량',
          xtype: 'gridcolumn',
          width: 120,
          hidden: false,
          sortable: true,
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
          dataIndex: 'FINISHITEMPRICE',
          text: '금액',
          xtype: 'gridcolumn',
          width: 120,
          hidden: false,
          sortable: true,
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
  ]
},{
    text: '합계',
    sortable: false,
    resizable: false,
    menuDisabled: true,
    style: 'text-align:center;',
    columns: [{
        dataIndex: 'TOTALCOUNT',
        text: '수량',
        xtype: 'gridcolumn',
        width: 120,
        hidden: false,
        sortable: true,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "right",
        cls: 'ERPQTY',
        format: "0,000",
        renderer: function (value, meta, eOpts) {

            $("#avgcount").val(eOpts.data.AVGCOUNT);
            $("#avgprice").val(eOpts.data.AVGPRICE);
          return Ext.util.Format.number(value, '0,000');
        },
        summaryRenderer: function (value, meta, record) {
        	  value=$("#avgcount").val();
            var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number($("#avgcount").val(), '0,000') + "</div>";

            return result;
        },
      }, {
        dataIndex: 'TOTALPRICE',
        text: '금액',
        xtype: 'gridcolumn',
        width: 120,
        hidden: false,
        sortable: true,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "right",
        cls: 'ERPQTY',
        format: "0,000",
        renderer: function (value, meta, eOpts) {
          return Ext.util.Format.number(value, '0,000');
        },
        summaryRenderer: function (value, meta, record) {
            value=$("#avgprice").val();
            var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number($("#avgprice").val(), '0,000') + "</div>";

            return result;
         },
      },
      ]
},
	    
	    
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/manage/kpi/ManageKpi8List2.do' />"
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

	var gridarea, gridareadetail;
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
	            	  DATEYEAR: '${searchVO.dateYear}',
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
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
	        height: 368, // 200,
	        border: 2,
	        scrollable: true,
            features: [{
                ftype: 'summary',
                dock: 'bottom'
            }
        ],
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
                  if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('DRAWINGNO') >= 0 || column.dataIndex.indexOf('GROUPNAME') >= 0) {
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
	  var searchfrom = $('#searchdateYear').val();
	  var header = [],
	  count = 0;

	  if (searchfrom === "") {
	    header.push("제조일자");
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
	    DATEYEAR: $('#searchdateYear').val(),
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  var sparams1 = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    DATEYEAR: $('#searchdateYear').val(),
	  };

	  url = "<c:url value='/select/manage/kpi/ManageKpi8List1.do' />";

	  $.ajax({
	    url: url,
	    type: "post",
	    dataType: "json",
	    data: sparams1,
	    success: function (data) {

	      if (data.totcnt == 0) {
	        extAlert("해당 제조일자의 품명 데이터가 없습니다.");
	        drawCharter();
	      } else {
	        drawCharter();
	      }
	    },
	    error: ajaxError
	  });
	  drawCharter();
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {}

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
					<input type="hidden" id="avgcount"  />
					<input type="hidden" id="avgprice" />
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
										<td></td>
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
										<col>
									</colgroup>
									<tr style="height: 34px;">
										<th class="required_text">제조일자</th>
										<td>
										<input type="text" id="searchdateYear" name="searchdateYear" class="input_validation input_center" style="width: 150px;" maxlength="4" />
										</td>
<!-- 										<th class="required_text">품번</th> -->
<!--                     <td><input type="text" id="searchOrdernm" name="searchOrdernm" class="input_center" style="width: 150px"; /></td> -->
<!--                     <th class="required_text">품명</th> -->
<!--                     <td><input type="text" id="searchItemnm" name="searchItemnm" class="input_center" style="width: 150px"; /></td> -->
                    <td></td>
	                  <td></td>
	                  <td></td>
	                  <td></td>
                    <td><div class="buttons" style="float: right; margin-top: 3px;">
                      
                        <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                      </div>
                    </td>
									</tr>
								</table>
								<div id="chart_div" style="width: 100%; height: 30%"></div>
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