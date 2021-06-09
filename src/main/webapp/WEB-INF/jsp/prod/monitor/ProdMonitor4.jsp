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
<script type="text/javascript">
google.charts.load('current', {
	  packages: ['corechart']
	});
	google.charts.setOnLoadCallback(
	  function () {
		  xdrawChart();
		  rdrawChart();
	});

$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  setReadOnly();

  setLovList();

  setDummyXChart();
  setDummyRChart();
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

  $('#searchOrgId, #searchCompanyId').change(function (event) {
    //       fn_option_change('MFG', 'STATUS', 'searchStatus');
  });

  $('#searchCheckBig').change(function (event) {
    fn_clear();
  });

  gridnms["app"] = "prod";
}

function fn_clear() {
  $('#searchCheckSmallName').val("");
  $('#searchCheckSmallCode').val("");
}

var x_data;
//차트 데이터 Set
var header_x = ['NO', '최소', '기준', '최대', '값'];
var row_x = "", msg_x = "", check_x = false;
var x_min = 0, x_max = 0;
function xdrawChart(v) {
  var title_name = 'X 관리도 ( X bar Chart )';
  var view = new google.visualization.DataView(v);

  var options = {
    title: title_name,
    width: '100%',
    height: 280,
    fontName: 'Malgun Gothic',
    focusTarget: 'category',
    //bar: { groupWidth: '50%' },
    legend: {
      position: 'right',
      alignment: 'center',
    },
    series: {
      0: {
        targetAxisIndex: 1,
        type: "line",
        color: "red" // 최소 값 색상
      },
      1: {
        targetAxisIndex: 1,
        type: "line",
        color: "green" // 기준 값 색상
      },
      2: {
        targetAxisIndex: 1,
        type: "line",
        color: "blue" // 최대 값 색상
      },
      3: {
        targetAxisIndex: 1,
        type: "line",
        color: "black"
      }
    },
    chartArea: {
      width: '90%',
      height: '85%',
    },
    role: {
      opacity: 0.7,
    },
    vAxis: {
      maxValue: x_max,
      minValue: x_min,
    },
    hAxis: {
      format: 'decimal',
    },
    dataOpacity: 0.8,
    animation: {
      duration: 2 * 1000,
      easing: 'out',
      startup: true,
    },
    allowHtml: true,
  };

  var xchart = new google.visualization.ColumnChart(document.getElementById('XChartArea'));
  xchart.draw(view, options);
}

var r_data;
//차트 데이터 Set
var header_r = ['NO', '기준', '값'];
var r_min = 0, r_max = 0;
var row_r = "", msg_r = "", check_r = false;
function rdrawChart(v) {
  var title_name = 'R 관리도 ( Ranges Chart )';
  var view = new google.visualization.DataView(v);

  var options = {
    title: title_name,
    width: '100%',
    height: 280,
    fontName: 'Malgun Gothic',
    focusTarget: 'category',
    //bar: { groupWidth: '50%' },
    legend: {
      position: 'right',
      alignment: 'center',
    },
    series: {
      0: {
        targetAxisIndex: 1,
        type: "line",
        color: "green" // 기준 값 색상
      },
      1: {
        targetAxisIndex: 1,
        type: "line",
        color: "black" // 값 색상
      },
    },
    chartArea: {
      width: '90%',
      height: '85%',
    },
    role: {
      opacity: 0.7,
    },
    vAxis: {
      maxValue: r_max,
      minValue: r_min,
    },
    hAxis: {
      format: 'decimal',
    },
    dataOpacity: 0.8,
    animation: {
      duration: 2 * 1000,
      easing: 'out',
      startup: true,
    },
    allowHtml: true,
  };

  var rchart = new google.visualization.ColumnChart(document.getElementById('RChartArea'));
  rchart.draw(view, options);
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
  gridnms["models.viewer"] = [];
  gridnms["stores.viewer"] = [];
  gridnms["views.viewer"] = [];
  gridnms["controllers.viewer"] = [];

  gridnms["grid.1"] = "ProdMonitor4";

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
      type: 'string',
      name: 'GUBUN',
    }, {
      type: 'number',
      name: 'CNT',
    }
  ];

  var check_count = 25;
  for (var i = 0; i < check_count; i++) {
    fields["model.1"].push({
      type: 'string',
      name: 'X' + (i + 1)
    });
  }

  fields["columns.1"] = [
    // Display Columns
    {
      dataIndex: 'GUBUN',
      text: '구분',
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
      renderer: function (value, meta, record) {
        meta.style = "font-weight:bold; ";

        return value;
      },
    },
    // Hidden Columns
    {
      dataIndex: 'RN',
      xtype: 'hidden',
    }, {
      dataIndex: 'CNT',
      xtype: 'hidden',
    }
  ];

  for (var j = 0; j < check_count; j++) {
    fields["columns.1"].push({
      dataIndex: 'X' + (j + 1),
      text: (j + 1),
      xtype: 'gridcolumn',
      width: 70,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      lockable: false,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      renderer: function (value, meta, record) {
        var gubun = record.data.GUBUN;

        meta.style = "font-weight:bold; ";

        switch (gubun) {
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
          meta.style += " background-color:rgb(255, 255, 0); ";
          break;
        default:
          break;
        }

        return value;
      },
    });
  }

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/prod/monitor/ProdMonitor4.do' />"
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
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.1"], {
    extend: Ext.app.Controller,
    refs: {
      SPCList: '#SPCList',
    },
    stores: [gridnms["store.1"]],
    //        control: items["btns.ctr.1"],
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
        height: 270,
        border: 2,
        scrollable: true,
        columns: fields["columns.1"],
        plugins: [{
            ptype: 'bufferedrenderer',
            trailingBufferZone: 20,
            leadingBufferZone: 20,
            synchronousRender: false,
            numFromEdge: 19,
          }
        ],
        viewConfig: {
          itemId: 'SPCList',
          trackOver: true,
          loadMask: true,
          striptRows: true,
          forceFit: true,
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
      gridarea = Ext.create(gridnms["views.viewer"], {
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
  var searchFrom = $("#searchFrom").val();
  var searchTo = $("#searchTo").val();
  var searchItemCode = $("#searchItemCode").val();
  var searchRoutingId = $("#searchRoutingId").val();
  var searchCheckSmallCode = $("#searchCheckSmallCode").val();
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
    header.push("일자 FROM");
    count++;
  }

  if (searchTo == "") {
    header.push("일자 TO");
    count++;
  }

  if (searchItemCode == "") {
    header.push("품번 / 품명");
    count++;
  }

  if (searchRoutingId == "") {
    header.push("공정");
    count++;
  }

  if (searchCheckSmallCode == "") {
    header.push("검사내용");
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
  var searchRoutingId = $("#searchRoutingId").val();
  var searchCheckBig = $('#searchCheckBig option:selected').val();
  var searchCheckSmallCode = $("#searchCheckSmallCode").val();

  var sparams = {
    ORGID: $('#searchOrgId option:selected').val(),
    COMPANYID: $('#searchCompanyId option:selected').val(),
    ITEMCODE: searchItemCode,
    ROUTINGID: searchRoutingId,
    CHECKLISTID: searchCheckSmallCode,
    CHECKBIG: searchCheckBig,
    SEARCHFROM: searchFrom,
    SEARCHTO: searchTo,
  };

  extGridSearch(sparams, gridnms["store.1"]);

  var url_result = '<c:url value="/select/prod/monitor/TotalProdMonitor4.do" />';
  $.ajax({
    url: url_result,
    type: "post",
    dataType: "json",
    data: sparams,
    success: function (data) {
      var result = data.data[0];

      var avgval = result.AVGVAL;
      var uslval = result.USLVAL;
      var lslval = result.LSLVAL;
      var devval = result.DEVVAL;
      var ucrval = result.UCRVAL;
      var lcrval = result.LCRVAL;
      var cpval = result.CPVAL;
      var cpkval = result.CPKVAL;

      $('#AVGVAL span').text(avgval);
      $('#USLVAL span').text(uslval);
      $('#LSLVAL span').text(lslval);
      $('#DEVVAL span').text(devval);
      $('#UCRVAL span').text(ucrval);
      $('#LCRVAL span').text(lcrval);
      $('#CPVAL span').text(cpval);
      $('#CPKVAL span').text(cpkval);
    },
    error: ajaxError
  });

  var url_x = '<c:url value="/select/prod/monitor/XChartGrid.do" />';
  $.ajax({
    url: url_x,
    type: "post",
    dataType: "json",
    data: sparams,
    success: function (data) {
      var rows = new Array();
      if (data.totcnt == 0) {
        msg_x = "조회하신 항목에 대한 데이터가 없습니다.";
        check_x = false;

        setDummyXChart();
      } else {
        msg_x = "데이터가 " + data.totcnt + "건 조회되었습니다.";
        check_x = true;

        var rows = new Array();
        for (var i = 0; i < data.totcnt; i++) {
          var standardvalue = (data.data[i].LSL + data.data[i].USL) / 2;
          row_x = [data.data[i].RN, data.data[i].LSL, standardvalue, data.data[i].USL, data.data[i].VALUE];
          rows.push(row_x);

          x_min = data.data[i].LSL;
          x_max = data.data[i].USL;
        }

        var jsonData_x = [header_x].concat(rows);
        x_data = google.visualization.arrayToDataTable(jsonData_x);

        // 차트 호출
        xdrawChart(x_data);
      }

      if (check_x == false) {
        extAlert(msg_x);
        return;
      }
    },
    error: ajaxError
  });

  var url_r = '<c:url value="/select/prod/monitor/RChartGrid.do" />';
  $.ajax({
    url: url_r,
    type: "post",
    dataType: "json",
    data: sparams,
    success: function (data) {
      var rows = new Array();
      if (data.totcnt == 0) {
        msg_r = "조회하신 항목에 대한 데이터가 없습니다.";
        check_r = false;

        setDummyRChart();
      } else {
        msg_r = "데이터가 " + data.totcnt + "건 조회되었습니다.";
        check_r = true;

        var rows = new Array();
        var c1 = 0,
        c2 = 0; // 최소, 최대 구하기
        for (var j = 0; j < data.totcnt; j++) {
          row_r = [data.data[j].RN, 0, data.data[j].VALUE];
          rows.push(row_r);

          c1 = data.data[j].LSL;
          c2 = data.data[j].USL;
        }

        r_min = -c2 * 1;
        r_max = c2 * 1;

        var jsonData_r = [header_r].concat(rows);
        r_data = google.visualization.arrayToDataTable(jsonData_r);

        // 차트 호출
        rdrawChart(r_data);
      }

      if (check_r == false) {
        extAlert(msg_r);
        return;
      }
    },
    error: ajaxError
  });
}

function fn_print(flag) {
  if (!fn_validation()) {
    return;
  }

  var orgid = $('#searchOrgId option:selected').val();
  var companyid = $('#searchCompanyId option:selected').val();
  var searchFrom = $("#searchFrom").val();
  var searchTo = $("#searchTo").val();
  var searchItemCode = $("#searchItemCode").val();
  var searchRoutingId = $("#searchRoutingId").val();
  var searchCheckBig = $('#searchCheckBig option:selected').val();
  var searchCheckSmallCode = $("#searchCheckSmallCode").val();

  var sparams = {
    ORGID: $('#searchOrgId option:selected').val(),
    COMPANYID: $('#searchCompanyId option:selected').val(),
    ITEMCODE: searchItemCode,
    ROUTINGID: searchRoutingId,
    CHECKLISTID: searchCheckSmallCode,
    CHECKBIG: searchCheckBig,
    SEARCHFROM: searchFrom,
    SEARCHTO: searchTo,
  };

  var url = "";
  var column = 'master';
  var target = '_blank';

  switch (flag) {
  case "SPC":
    url = "<c:url value='/report/SPCControlChartReport.pdf'/>";

    fn_popup_url(column, url, target);

    break;
  case "WORKSHEET":
    url = "<c:url value='/report/ProcCapaSheetReport.pdf'/>";

    fn_popup_url(column, url, target);

    break;
  default:
    break;
  }
}

function setDummyXChart() {

  var rows = new Array();
  var lastday = 25;
  var countday = 0;

  // Dummy 데이터 Set
  for (var i = 0; i < lastday; i++) {
    countday = i + 1;

    row_x = [countday, -1, 0, 1, 0];
    rows.push(row_x);

    x_min = -1;
    x_max = 1;
  }

  var jsonData_x = [header_x].concat(rows);
  x_data = google.visualization.arrayToDataTable(jsonData_x);

  // 차트 호출
  xdrawChart(x_data);
}

function setDummyRChart() {

  var rows = new Array();
  var lastday = 25;
  var countday = 0;

  // Dummy 데이터 Set
  for (var j = 0; j < lastday; j++) {
    countday = j + 1;

    row_r = [countday, 0, 0];
    rows.push(row_r);

    r_min = -1;
    r_max = 1;
  }

  var jsonData_r = [header_r].concat(rows);
  r_data = google.visualization.arrayToDataTable(jsonData_r);

  // 차트 호출
  rdrawChart(r_data);
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
      $("#searchItemName").val("");
      $("#searchItemCode").val("");

      var routingid = $("#searchRoutingId").val();
      if (routingid != "") {
        $("#searchRoutingName").val("");
        $("#searchRoutingNo").val("");
        $("#searchRoutingOp").val("");
        $("#searchRoutingId").val("");
      }

      var checkid = $("#searchCheckSmallCode").val();
      if (checkid != "") {
        $("#searchCheckSmallName").val("");
        $("#searchCheckSmallCode").val("");
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

      var routingid = $("#searchRoutingId").val();
      if (routingid != "") {
        $("#searchRoutingName").val("");
        $("#searchRoutingNo").val("");
        $("#searchRoutingOp").val("");
        $("#searchRoutingId").val("");
      }

      var checkid = $("#searchCheckSmallCode").val();
      if (checkid != "") {
        $("#searchCheckSmallName").val("");
        $("#searchCheckSmallCode").val("");
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

      var routingid = $("#searchRoutingId").val();
      if (routingid != "") {
        $("#searchRoutingName").val("");
        $("#searchRoutingNo").val("");
        $("#searchRoutingOp").val("");
        $("#searchRoutingId").val("");
      }

      var checkid = $("#searchCheckSmallCode").val();
      if (checkid != "") {
        $("#searchCheckSmallName").val("");
        $("#searchCheckSmallCode").val("");
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

      var routingid = $("#searchRoutingId").val();
      if (routingid != "") {
        $("#searchRoutingName").val("");
        $("#searchRoutingNo").val("");
        $("#searchRoutingOp").val("");
        $("#searchRoutingId").val("");
      }

      var checkid = $("#searchCheckSmallCode").val();
      if (checkid != "") {
        $("#searchCheckSmallName").val("");
        $("#searchCheckSmallCode").val("");
      }
      return false;
    }
  });

  // 공정 Lov
  $("#searchRoutingName").bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      // $("#searchRoutingName").val("");
      $("#searchRoutingNo").val("");
      $("#searchRoutingOp").val("");
      $("#searchRoutingId").val("");

      var checkid = $("#searchCheckSmallCode").val();
      if (checkid != "") {
        $("#searchCheckSmallName").val("");
        $("#searchCheckSmallCode").val("");
      }
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
      $.getJSON("<c:url value='/searchRoutingItemLov.do' />", {
        keyword: extractLast(request.term),
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
        ITEMCODE: $('#searchItemCode').val(),
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              value: m.ROUTINGCODE,
              label: m.ROUTINGOP + ", " + m.ROUTINGNAME,
              ROUTINGNO: m.ROUTINGNO,
              ROUTINGNAME: m.ROUTINGNAME,
              SORTORDER: m.SORTORDER,
              ROUTINGOP: m.ROUTINGOP,
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
      $("#searchRoutingId").val(o.item.value);
      $("#searchRoutingName").val(o.item.ROUTINGNAME);
      $("#searchRoutingNo").val(o.item.ROUTINGNO);
      $("#searchRoutingOp").val(o.item.ROUTINGOP);

      var checkid = $("#searchCheckSmallCode").val();
      if (checkid != "") {
        $("#searchCheckSmallName").val("");
        $("#searchCheckSmallCode").val("");
      }
      return false;
    }
  });

  // 검사내용 Lov
  $("#searchCheckSmallName").bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      //  $("#searchCheckSmallName").val("");
      $("#searchCheckSmallCode").val("");
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
      $.getJSON("<c:url value='/searchCheckMasterListLov.do' />", {
        keyword: extractLast(request.term),
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
        ITEMCODE: $('#searchItemCode').val(),
        ROUTINGID: $('#searchRoutingId').val(),
        GUBUN: 'S',
        CHECKBIG: $('#searchCheckBig option:selected').val(),
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              value: m.CHECKSEQ,
              label: m.CHECKSTANDARD,

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
      $("#searchCheckSmallCode").val(o.item.value);
      $("#searchCheckSmallName").val(o.item.label);

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
                                <li>품질관리</li>
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
                        <input type="hidden" id="orgid" value="<c:out value='${searchVO.ORGID}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${searchVO.COMPANYID}'/>" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="searchItemCode" name="searchItemCode" />
                            <input type="hidden" id="searchRoutingNo" name="searchRoutingNo" />
                            <input type="hidden" id="searchRoutingOp" name="searchRoutingOp" />
                            <input type="hidden" id="searchRoutingId" name="searchRoutingId" />
                            <input type="hidden" id="searchCheckSmallCode" name="searchCheckSmallCode" />
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
                                                <a id="btnChk2" class="btn_print" href="#" onclick="javascript:fn_print('SPC');">
                                                   X-R 관리도 (해석용)
                                                </a>
                                                <a id="btnChk3" class="btn_print" href="#" onclick="javascript:fn_print('WORKSHEET');">
                                                   공정능력 분석시트
                                                </a>
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="8%">
                                        <col width="160px">
                                        <col width="8%">
                                        <col width="15%">
                                        <col width="8%">
                                        <col width="20%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">일자</th>
                                        <td>
                                            <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchTo" name="searchTo" class="input_validation input_center" style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td>
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_validation input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td>
                                            <input type="text" id="searchItemName" name="searchItemName" class="input_validation input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">검사구분</th>
                                        <td>
                                            <select id="searchCheckBig" name="searchCheckBig" class="input_left input_validation" style="width: 97%;">
                                                <c:forEach var="item" items="${labelBox.findByCheckBig}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.CHECKBIG}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th class="required_text">공정</th>
                                        <td>
                                            <input type="text" id="searchRoutingName" name="searchRoutingName" class="input_validation input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                                        </td>
                                        <th class="required_text">검사내용</th>
                                        <td>
                                            <input type="text" id="searchCheckSmallName" name="searchCheckSmallName" class="input_validation input_left imetype"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                        
                        <table class="tbl_type_view" border="0" style="margin-top: 15px; margin-bottom: 0px; padding-bottom: 0px; float: left; ">
                            <colgroup>
                                <col width="8%">
                                <col width="160px">
                                <col width="8%">
                                <col width="15%">
                                <col width="8%">
                                <col width="20%">
                            </colgroup>
                            <tbody>
                                    <tr style="height: 34px;">
                                        <th class="required_text">X</th>
                                        <td>
                                            <label id="AVGVAL" name="AVGVAL" style="font-size: 18px; color: black; font-weight: bold; padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                                                <span>0.0000</span>
                                            </label>
                                        </td>
                                        <th class="required_text">UCL = X + A2R</th>
                                        <td>
                                            <label id="USLVAL" name="USLVAL" style="font-size: 18px; color: black; font-weight: bold; padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                                                <span>0.0000</span>
                                            </label>
                                        </td>
                                        <th class="required_text">LCL = X - A2R</th>
                                        <td>
                                            <label id="LSLVAL" name="LSLVAL" style="font-size: 18px; color: black; font-weight: bold; padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                                                <span>0.0000</span>
                                            </label>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">R</th>
                                        <td>
                                            <label id="DEVVAL" name="DEVVAL" style="font-size: 18px; color: black; font-weight: bold; padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                                                <span>0.0000</span>
                                            </label>
                                        </td>
                                        <th class="required_text">UCL = D4 R</th>
                                        <td>
                                            <label id="UCRVAL" name="UCRVAL" style="font-size: 18px; color: black; font-weight: bold; padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                                                <span>0.0000</span>
                                            </label>
                                        </td>
                                        <th class="required_text">LCL = D3 R</th>
                                        <td>
                                            <label id="LCRVAL" name="LCRVAL" style="font-size: 18px; color: black; font-weight: bold; padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                                                <span>0.0000</span>
                                            </label>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">CP</th>
                                        <td>
                                            <label id="CPVAL" name="CPVAL" style="font-size: 18px; color: black; font-weight: bold; padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                                                <span>0.000</span>
                                            </label>
                                        </td>
                                        <th class="required_text">CPK</th>
                                        <td style="background-color: rgb(255, 192, 0);">
                                            <label id="CPKVAL" name="CPKVAL" style="font-size: 18px; color: black; font-weight: bold; padding-right: 10px; padding-top: 2px; padding-bottom: 0px; float: right;">
                                                <span>0.000</span>
                                            </label>
                                        </td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                            </tbody>
                        </table>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->
                    
				        <div class="subContent2" style="margin-top: 0px; margin-right: 0px;">
				            <div class="subConTit3">X-R 관리도</div>
				            <div class="subContent2" id="XChartArea" style="width: 100%; height: 300px; padding-top: 0px; padding-left: 0px; margin-top: 0px; margin-bottom: 0px;"></div>
				            <div class="subContent2" id="RChartArea" style="width: 100%; height: 300px; padding-top: 0px; padding-left: 0px; margin-top: 10px; margin-bottom: 0px;"></div>
				        </div>
                    
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