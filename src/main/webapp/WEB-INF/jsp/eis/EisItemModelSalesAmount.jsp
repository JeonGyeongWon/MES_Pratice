<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
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

.tbl_type_view, .tbl_type_view th, .tbl_type_view td {
  border: 0;
/*   background-color: rgb(202, 202, 202); */
}

.tbl_type_view {
  width: 100%;
  border-top: 1px solid #999;
  border-bottom: 1px solid #999;
  font-size: 12px;
  table-layout: fixed;
}

.tbl_type_view caption {
  display: none
}

.tbl_type_view th {
  padding: 0px 0px 0px 0px;
  border-bottom: solid 1px #d2d2d2;
/*   background-color: rgb(202, 202, 202); */
  color: black;
  font-weight: bold;
  text-align: center;
  line-height: 18px;
}

.tbl_type_view td {
  padding: 0px 0 3px 7px;
  border-bottom: solid 1px #d2d2d2;
  text-align: left;
  word-break: break-all;
}

.x-column-header-inner {
/*  white-space: nowrap; */
/*  position: relative; */
/*  overflow: hidden; */
  color: white;
  font-weight: bold;
  /*     background-color: rgb(71, 174, 233); */
  background-color: #444F83;
}

.total-row { 
background-color: #ffe2e2 !important; 
color: blue; 
font-weight: bold;
} 

</style>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javascript" src="https://www.google.com/jsapi"></script>
<script type="text/javaScript">
google.charts.load('current', {
    packages: ['corechart']
});
google.charts.setOnLoadCallback(
    function () {
    setTimeout(function () {
        fn_chart_search();
    }, 200);
});

var c_data;
var header_c;
var row_c = "";
var status_c = "";
function fn_chart_search() {
    var sparams = {
        ORGID: $('#searchOrgId').val(),
        COMPANYID: $('#searchCompanyId').val(),
        SEARCHYEAR: $('#searchYear').val(),
        GUBUN: $('#searchGubun').val(),
    };
    var year = Number(${
        searchVO.DATEYEAR
    });
    var url_c = '<c:url value="/select/eis/EisItemModelSalesChart.do" />';
    $.ajax({
        url: url_c,
        type: "post",
        dataType: "json",
        async: false,
        data: sparams,
        success: function (data) {
            var rows = [];
            rows.push(['월', 'Swash Plate 합계', 'Cylinder Block 합계', 'Valve Plate 합계'])
            var count = data.totcnt;
            for (var i = 0; i < count; i++) {
                var ajaxData = data.data[i];
                rows.push([ajaxData.TITLE, ajaxData.LABEL01, ajaxData.LABEL02, ajaxData.LABEL03])
            }
            c_data = google.visualization.arrayToDataTable(rows);

            cdrawChart(c_data);
        },
        error: ajaxError
    });
}

function cdrawChart(v) {
    var title_name = '※ 단위 ( 원 )';
    var view = new google.visualization.DataView(v);

    var options = {
        title: title_name,
        titleTextStyle: {
        fontSize: 15,
        bold: true,
        },
        width: '100%',
        height: '100%',
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        bar: {
            groupWidth: '40%'
        },
        legend: {
            position: 'bottom'
        },
        crosshair: {
            trigger: 'both'
        },
        chartArea: {
            width: '80%',
            height: '65%',
            left: '10%',
                   top: 10,
        },
//         forceIFrame: true,
        role: {
            opacity: 0.7,
        },
        hAxis: {
            format: 'decimal',
        },
        seriesType: "bars",
        tooltip: {
            ignoreBounds: false,
            isHtml: false,
            showColorCode: true,
            text: 'both', // 'value', 'percentage',
            trigger: 'focus', // 'selection',
        },
        dataOpacity: 1, // 0.7,
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var cchart = new google.visualization.ComboChart(document.getElementById('CChartArea'));
    cchart.draw(view, options);
}

function setDummyYChart() {

    var rows = new Array();
    // Dummy 데이터 Set
    row_c = ['', 0, 0, 0];
    rows.push(row_c);

    var jsonData_c = [header_c].concat(rows);
    c_data = google.visualization.arrayToDataTable(jsonData_c);

    // 차트 호출
    cdrawChart(c_data);
}

$(document).ready(function () {
    setInitial();

    setValues();

    setExtGrid();

    setReadOnly();

    setLovList();
});

function setInitial() {
    gridnms["app"] = "eis";

    $("#searchYear").val(getToDay("${searchVO.DATEYEAR}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "EisItemModelSalesAmount";

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
            name: 'RN1',
        }, {
            type: 'number',
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'LABELNAME',
        }, {
            type: 'string',
            name: 'MODELNAME',
        }, {
            type: 'number',
            name: 'PRE2AMOUNT',
        }, {
            type: 'number',
            name: 'PREAMOUNT',
        }, {
            type: 'number',
            name: 'TOTAL',
        }, {
            type: 'number',
            name: 'AMOUNT01',
        }, {
            type: 'number',
            name: 'AMOUNT02',
        }, {
            type: 'number',
            name: 'AMOUNT03',
        }, {
            type: 'number',
            name: 'AMOUNT04',
        }, {
            type: 'number',
            name: 'AMOUNT05',
        }, {
            type: 'number',
            name: 'AMOUNT06',
        }, {
            type: 'number',
            name: 'AMOUNT07',
        }, {
            type: 'number',
            name: 'AMOUNT08',
        }, {
            type: 'number',
            name: 'AMOUNT09',
        }, {
            type: 'number',
            name: 'AMOUNT10',
        }, {
            type: 'number',
            name: 'AMOUNT11',
        }, {
            type: 'number',
            name: 'AMOUNT12',
        }, {
            type: 'string',
            name: 'LABEL',
        }, {
            type: 'string',
            name: 'MODEL',
        }, ];

    fields["columns.1"] = [
        // Display Columns
        {
            dataIndex: 'LABELNAME',
            text: '품목',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                var rn1 = record.data.RN1;
                var result = "";
                var emptyValue = "";
                if (rn1 == "1") {
                    result = value;
                } else {
                    var model = record.data.MODEL;
                    if (model == "999") {
                        meta.style = " color: blue; ";
                        meta.style += " font-weight: bold; ";
                        meta.style += " font-size: 15px !important;";
                        meta.style += " border-bottom: 1px dashed blue; ";
                    }
                    result = emptyValue;
                }
                return result;
            },
        }, {
            dataIndex: 'MODELNAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            summaryRenderer: function (value, meta, record) {
                var header = "합계";
                return [header].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: center; font-size: 15px; color: red; '>" + val + '</div>';
                }).join('<br />');
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return value;
            },
        }, {
            dataIndex: 'PRE2AMOUNT',
            text: String(Number(${
                    searchVO.DATEYEAR
                }) - 2),
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'PREAMOUNT',
            text: String(Number(${
                    searchVO.DATEYEAR
                }) - 1),
            xtype: 'datecolumn',
            width: 100,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'TOTAL',
            text: ${
                searchVO.DATEYEAR
            },
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT01',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT02',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT03',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT04',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT05',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT06',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT07',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT08',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT09',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT10',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT11',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
            },
        }, {
            dataIndex: 'AMOUNT12',
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
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.1"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                    if (record.MODELNAME == "합계") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }
                var result = [total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val/1000, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var model = record.data.MODEL;
                if (model == "999") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " font-size: 15px !important;";
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                return Ext.util.Format.number(value/1000, '0,000');
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
            dataIndex: 'LABEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/eis/EisItemModelSalesList.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push(
    '->');
  items["btns.1"].push(
    '<table>' +
    '<colgroup>' +
    '<col>' +
    '</colgroup>' +
    '<tr>' +
    '<td>' +
    '<strong>(단위: 천원)</strong>' +
    '</td>' +
    '</tr>' +
    '</table>');
  
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
    items["docked.1"].push(items["dock.btn.1"]);
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
                                SEARCHYEAR: $('#searchYear').val(),
                                GUBUN: $('#searchGubun').val(),
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
        //     control: items["btns.ctr.1"],
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
                height: 458,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'top'
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
                    //          getRowClass: function (record, rowIndex, rowParams, store) {
                    //              if (record.get('MODELNAME') == '합계') return 'total-row'
                    //             },
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
    var searchyear = $('#searchYear').val();
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

    if (searchyear == "") {
        header.push("기준년도");
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
    var searchyear = $('#searchYear').val();
    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHYEAR: searchyear,
        GUBUN: $('#searchGubun').val(),
    };
    extGridSearch(sparams, gridnms["store.1"]);

    fn_chart_search();
    var year = $('#searchYear').val();
    Ext.getCmp(gridnms["views.list"]).headerCt.getHeaderAtIndex(4).setText(year);
    Ext.getCmp(gridnms["views.list"]).headerCt.getHeaderAtIndex(3).setText(String(Number(year) - 1));
    Ext.getCmp(gridnms["views.list"]).headerCt.getHeaderAtIndex(2).setText(String(Number(year) - 2));
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
                            <li>경영자정보</li>
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
                        <input type="hidden" id="searchGubun" name="searchGubun" value="AMOUNT" />
                            <table class="tbl_type_view" border="0">
                                <colgroup>
                                    <col width="250px">
                                    <col width="120px">
                                    <col>
                                    <col>
                                </colgroup>
                                <tr style="height: 34px;">
                                    <td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 97%;">
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
                                    <th class="required_text">기준년도</th>
                                    <td>
                                        <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="display: none;; ">
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
                                        <input type="text" id="searchYear" name="searchYear" class="input_validation input_center" style="width: 100px; min-width: 100px;" maxlength="4" />
                                    </td>
                                    <td>
                                        <div class="buttons" style="float: right; margin-top: 3px;">
                                            <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                <div class="subConTit3" >품목/기종별 매출 차트</div>
<!--                 <div style="float:right; padding-right: 3%; font-size:15px;">(단위: 원)</div> -->
                <div id="CChartArea" style="width: 100%; height: 200px; padding-bottom: 30px; margin: 0px; margin-top: 1%; float: left;"></div>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">집계 현황</div></td>
                    </tr>
                </table>
                <div id="gridArea" style="width: 100%; padding-bottom: 5px; margin-bottom: 5px; float: left;"></div>
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