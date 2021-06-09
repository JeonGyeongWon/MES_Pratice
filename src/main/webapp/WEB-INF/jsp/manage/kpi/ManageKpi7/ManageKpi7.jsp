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
	var header_d;
	var row_d = "";
	var status_d = "";
	function drawCharter() {
	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    TXRDATEFROM: $('#searchFrom').val(),
	    ITEMNAME: $('#searchItemnm').val(),
	    ORDERNAME: $('#searchOrdernm').val(),
	  };

	  var url_x = '<c:url value="/select/manage/kpi/ManageKpi7List1.do" />';
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
	          if (date_temp[l] == list.GROUPNAME) {
	            c_count++;
	          }
	        }
	        if (c_count == 0) {
	          date_temp.push(list.GROUPNAME);
	        }
	      }
	      date_temp.sort();

	      for (n = 0; n < date_temp.length; n++) {

	        // 2. 중복 제거된 설비명을 가지고 Loop
	        var v_count = 0;
	        prodqty_temp = [];
	        prodname_title = [];
	        prodname_title[0] = " ";

	        prodqty_temp[0] = date_temp[n];
	        for (var k = 0; k < work_hd.length; k++) {
	          v_count = 0;
	          var qty = 0;
	          // 중복제거된 설비명 Loop
	          for (var i = 0; i < charcount; i++) {
	            var list = data.data[i];
	            var enddate = date_temp[n];

	            if (work_hd[k] == list.ITEMNAME) { // 이름이 중복 된 애들의 데이터를 넣지않기위해서 설비명 중복여부 체크

	              if (list.GROUPNAME == enddate) { // 같은 일자인지 체크
	                //                                            prodqty_temp.push( list.PRODUCEDQTY );
	                //                                            prodname_temp.push( list.WORKCENTERNAME );
	                ++v_count;
	                qty = list.GROUPQTY;
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
	    //     vAxis: {
	    //       minValue: 0,
	    //       maxValue: 20,
	    //     },
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

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  gridnms["app"] = "manage";

	    calender($('#searchFrom'));

	    $('#searchFrom').keyup(function (event) {
	          if (event.keyCode != '8') {
	              var v = this.value;
	              if (v.length === 4) {
	                  this.value = v + "-";
	              } else if (v.length === 7) {
	                  this.value = v + "-";
	              }
	          }
	      });

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

	  gridnms["grid.1"] = "ManageKpi1List1";

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
	      name: 'GROUPNAME',
	    }, {
	      type: 'number',
	      name: 'GROUPQTY',
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'rownumberer',
	      width: 65,
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
	      width: 180,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'DRAWINGNO',
	      text: '도번',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'GROUPNAME',
	      text: '공정그룹',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'GROUPQTY',
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
	    read: "<c:url value='/select/manage/kpi/ManageKpi7List2.do' />"
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
	              extraParams: {
	                TXRDATEFROM: '${searchVO.dateFrom}',
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                ITEMNAME: $('#searchItemnm').val(),
	                ORDERNAME: $('#searchOrdernm').val(),
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
	  var searchfrom = $('#searchFrom').val();
	  var workcode = $('#searchItemnm').val();
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
	    TXRDATEFROM: $('#searchFrom').val(),
	    ITEMNAME: $('#searchItemnm').val(),
	    ORDERNAME: $('#searchOrdernm').val(),
	    //      GUBUN: 'LIST',
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  var sparams1 = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    TXRDATEFROM: $('#searchFrom').val(),
	    ITEMNAME: $('#searchItemnm').val(),
	    ORDERNAME: $('#searchOrdernm').val(),
	  };

	  url = "<c:url value='/select/manage/kpi/ManageKpi7List1.do' />";

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
										<input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 150px;" maxlength="10" />
										</td>
										<th class="required_text">품번</th>
                    <td><input type="text" id="searchOrdernm" name="searchOrdernm" class="input_center" style="width: 150px"; /></td>
                    <th class="required_text">품명</th>
                    <td><input type="text" id="searchItemnm" name="searchItemnm" class="input_center" style="width: 150px"; /></td>
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