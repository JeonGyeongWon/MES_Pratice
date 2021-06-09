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
<script src="https://www.gstatic.com/charts/loader.js"></script>
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

var c_data = "", c_data2 = "";
function fn_chart_search() {
    var sparams = {
        ORGID: $('#searchOrgId').val(),
        COMPANYID: $('#searchCompanyId').val(),
        SEARCHYEAR: $('#searchYear').val(),
    };
    var url_c = '<c:url value="/select/eis/selectEisMonthlyYearSalesResultChart.do" />';
    $.ajax({
        url: url_c,
        type: "post",
        dataType: "json",
        async: false,
        data: sparams,
        success: function (data) {
            var rows = [];
            rows.push(['월', '금액', '수량'])
            var count = data.totcnt;
            for (var i = 0; i < count; i++) {
                var record = data.data[i];
                rows.push([record.SEARCHYEAR, record.AMOUNT, record.QTY]);
            }
            if (count == 0) {
            	var month = '0';
            	for (var i = 0; i < 12; i++) {
            		if (i > 8) {
            			month = i+1;
            		}
            		else {
            			month = '0' + (i + 1);
            		}
            		rows.push([month + '월', 0, 0]);
            	}
            }
            c_data = google.visualization.arrayToDataTable(rows);

            cdrawChart(c_data);
        },
        error: ajaxError
    });

    var url_c2 = '<c:url value="/select/eis/selectEisMonthlyYearSalesResultChart2.do" />';
    $.ajax({
        url: url_c2,
        type: "post",
        dataType: "json",
        async: false,
        data: sparams,
        success: function (data) {
            var rows = [];
            rows.push(['년', '금액', '수량'])
            var count = data.totcnt;
            for (var i = 0; i < count; i++) {
                var record = data.data[i];
                rows.push([record.SEARCHYEAR, record.AMOUNT, record.QTY]);
            }
            if (count == 0) {
              var year = getToDay("${searchVO.DATEYEAR}");
              rows.push([year, 0, 0]);
            }
            c_data2 = google.visualization.arrayToDataTable(rows);

            cdrawChart2(c_data2);
        },
        error: ajaxError
    });
}

function cdrawChart(v) {
    var title_name = '월별 매출 실적';
    var view = new google.visualization.DataView(v);

    var options = {
        /* title: title_name,
        titleTextStyle: {
        fontSize: 15,
        bold: true,
        }, */
        width: '100%',
        height: '100%',
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        bar: {
            groupWidth: '40%'
        },
        legend: {
            position: 'none'
        },
        crosshair: {
            trigger: 'both'
        },
        chartArea: {
            width: '80%',
            height: '80%',
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
        series: {1: {type: 'line', targetAxisIndex: 1}},
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

function cdrawChart2(v) {
    var title_name = '년도별 매출 실적';
    var view = new google.visualization.DataView(v);

    var options = {
        /* title: title_name,
        titleTextStyle: {
        fontSize: 15,
        bold: true,
        }, */
        width: '100%',
        height: '100%',
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        bar: {
            groupWidth: '40%'
        },
        legend: {
            position: 'none'
        },
        crosshair: {
            trigger: 'both'
        },
        chartArea: {
            width: '80%',
            height: '80%',
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
        series: {1: {type: 'line', targetAxisIndex: 1}},
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

    var cchart2 = new google.visualization.ComboChart(document.getElementById('CChartArea2'));
    cchart2.draw(view, options);
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
	setMonthValues();
	setYearValues();
}

function setMonthValues() {
    gridnms["models.month"] = [];
    gridnms["stores.month"] = [];
    gridnms["views.month"] = [];
    gridnms["controllers.month"] = [];

    gridnms["grid.1"] = "EisMonthlySalesResult";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.month"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.month"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

    gridnms["models.month"].push(gridnms["model.1"]);

    gridnms["stores.month"].push(gridnms["store.1"]);

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
            name: 'LICENSENO',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'number',
            name: 'TOTALAMOUNT',
        }, {
            type: 'number',
            name: 'TOTALQTY',
        }, {
            type: 'number',
            name: 'AMOUNT01',
        }, {
            type: 'number',
            name: 'QTY01',
        }, {
            type: 'number',
            name: 'AMOUNT02',
        }, {
            type: 'number',
            name: 'QTY02',
        }, {
            type: 'number',
            name: 'AMOUNT03',
        }, {
            type: 'number',
            name: 'QTY03',
        }, {
            type: 'number',
            name: 'AMOUNT04',
        }, {
            type: 'number',
            name: 'QTY04',
        }, {
            type: 'number',
            name: 'AMOUNT05',
        }, {
            type: 'number',
            name: 'QTY05',
        }, {
            type: 'number',
            name: 'AMOUNT06',
        }, {
            type: 'number',
            name: 'QTY06',
        }, {
            type: 'number',
            name: 'AMOUNT07',
        }, {
            type: 'number',
            name: 'QTY07',
        }, {
            type: 'number',
            name: 'AMOUNT08',
        }, {
            type: 'number',
            name: 'QTY08',
        }, {
            type: 'number',
            name: 'AMOUNT09',
        }, {
            type: 'number',
            name: 'QTY09',
        }, {
            type: 'number',
            name: 'AMOUNT10',
        }, {
            type: 'number',
            name: 'QTY10',
        }, {
            type: 'number',
            name: 'AMOUNT11',
        }, {
            type: 'number',
            name: 'QTY11',
        }, {
            type: 'number',
            name: 'AMOUNT12',
        }, {
            type: 'number',
            name: 'QTY12',
        }, ];

    fields["columns.1"] = [
        // Display Columns
        {
            dataIndex: 'CUSTOMERNAME',
            text: '거래처',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: true,
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
            	meta.style += " font-weight: bold; ";
                return value;
            },
        }, {
            text: '합계',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            columns: [
		            	{
		                dataIndex: 'TOTALAMOUNT',
		                text: '금액',
		                xtype: 'gridcolumn',
		                width: 80,
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
	                    var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value/1000, '0,000') + "</div>";
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
                    dataIndex: 'TOTALQTY',
                    text: '수량',
                    xtype: 'gridcolumn',
                    width: 60,
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
                    	var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value, '0,000') + "</div>";
                        return result;
                    },
                    renderer: function (value, meta, record) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                },
		        ],
            renderer: function (value, meta, record) {
                return value;
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
            dataIndex: 'LICENSENO',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, ];
    var month = '0';
    for (var i = 0; i < 12; i++) {
    	if (i + 1 > 9) month = i + 1;
    	else month = '0' + (i + 1);
    	fields["columns.1"].push( {
            text: (i+1) + '월',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            columns: [
                  {
                    dataIndex: 'AMOUNT' + month,
                    text: '금액',
                    xtype: 'gridcolumn',
                    width: 80,
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
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value/1000, '0,000') + "</div>";
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
                    dataIndex: 'QTY' + month,
                    text: '수량',
                    xtype: 'gridcolumn',
                    width: 60,
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
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value, '0,000') + "</div>";
                        return result;
                    },
                    renderer: function (value, meta, record) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                },
            ],
            renderer: function (value, meta, record) {
                return value;
            },
        }, )
    }
    
    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/eis/selectEisMonthlyYearSalesResult.do' />"
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

function setYearValues() {
    gridnms["models.year"] = [];
    gridnms["stores.year"] = [];
    gridnms["views.year"] = [];
    gridnms["controllers.year"] = [];

    gridnms["grid.2"] = "EisYearSalesResult";

    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
    gridnms["views.year"].push(gridnms["panel.2"]);

    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
    gridnms["controllers.year"].push(gridnms["controller.2"]);

    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

    gridnms["models.year"].push(gridnms["model.2"]);

    gridnms["stores.year"].push(gridnms["store.2"]);

    fields["model.2"] = [{
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
            name: 'LICENSENO',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'number',
            name: 'TOTALYEAR',
        }, {
            type: 'number',
            name: 'TOTALQTY',
        }, {
            type: 'number',
            name: 'TOTALYEAR1',
        }, {
            type: 'number',
            name: 'TOTALQTY1',
        }, {
            type: 'number',
            name: 'TOTALYEAR2',
        }, {
            type: 'number',
            name: 'TOTALQTY2',
        }, {
            type: 'number',
            name: 'TOTALYEAR3',
        }, {
            type: 'number',
            name: 'TOTALQTY3',
        }, {
            type: 'number',
            name: 'TOTALYEAR4',
        }, {
            type: 'number',
            name: 'TOTALQTY4',
        }, {
            type: 'number',
            name: 'TOTALYEAR5',
        }, {
            type: 'number',
            name: 'TOTALQTY5',
        }, ];

    fields["columns.2"] = [
        // Display Columns
        {
            dataIndex: 'CUSTOMERNAME',
            text: '거래처',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: true,
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
              meta.style += " font-weight: bold; ";
                return value;
            },
        }, {
            text: '합계',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            columns: [
                  {
                    dataIndex: 'TOTALYEAR',
                    text: '금액',
                    xtype: 'gridcolumn',
                    width: 80,
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
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value/1000, '0,000') + "</div>";
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
                    dataIndex: 'TOTALQTY',
                    text: '수량',
                    xtype: 'gridcolumn',
                    width: 60,
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
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value, '0,000') + "</div>";
                        return result;
                    },
                    renderer: function (value, meta, record) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                },
            ],
            renderer: function (value, meta, record) {
                return value;
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
            dataIndex: 'LICENSENO',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, ];
    var year = Number($('#searchYear').val());
    for (var i = 0; i < 5; i++) {
      fields["columns.2"].push( {
            text: ( year - ( 4 - i ) ) + '년',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            columns: [
                  {
                    dataIndex: 'TOTALYEAR' + (i + 1),
                    text: '금액',
                    xtype: 'gridcolumn',
                    width: 80,
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
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value/1000, '0,000') + "</div>";
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
                    dataIndex: 'TOTALQTY' + (i + 1),
                    text: '수량',
                    xtype: 'gridcolumn',
                    width: 60,
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
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value, '0,000') + "</div>";
                        return result;
                    },
                    renderer: function (value, meta, record) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                },
            ],
            renderer: function (value, meta, record) {
                return value;
            },
        }, )
    }
    
    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/eis/selectEisMonthlyYearSalesResult2.do' />"
    });

    items["btns.2"] = [];
    items["btns.2"].push(
    '->');
  items["btns.2"].push(
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
  
    items["btns.ctr.2"] = {};

    items["dock.paging.2"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.2"],
    };

    items["dock.btn.2"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.2"],
        items: items["btns.2"],
    };

    items["docked.2"] = [];
    items["docked.2"].push(items["dock.btn.2"]);
}

var gridarea, gridarea2;
function setExtGrid() {
	setExtMonthGrid();
	setExtYearGrid();
	
	Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
        gridarea2.updateLayout();
  });
}

function setExtMonthGrid() {
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
            MonthList: '#MonthList',
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
                height: 242,
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
                    itemId: 'MonthList',
                    striptRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
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
        models: gridnms["models.month"],
        stores: gridnms["stores.month"],
        views: gridnms["views.month"],
        controllers: gridnms["controller.1"],

        launch: function () {
            gridarea = Ext.create(gridnms["views.month"], {
                renderTo: 'gridArea'
            });
        },
    });
}

function setExtYearGrid() {
    Ext.define(gridnms["model.2"], {
        extend: Ext.data.Model,
        fields: fields["model.2"],
    });

    Ext.define(gridnms["store.2"], {
        extend: Ext.data.JsonStore, // Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.2"],
                        model: gridnms["model.2"],
                        autoLoad: true,
                        pageSize: 9999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.2"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                SEARCHYEAR: $('#searchYear').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.2"], {
        extend: Ext.app.Controller,
        refs: {
            YearList: '#YearList',
        },
        stores: [gridnms["store.2"]],
        //     control: items["btns.ctr.2"],
    });

    Ext.define(gridnms["panel.2"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.2"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'rowmodel',
                itemId: gridnms["panel.2"],
                id: gridnms["panel.2"],
                store: gridnms["store.2"],
                height: 200,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'top'
                    }
                ],
                scrollable: true,
                columns: fields["columns.2"],
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
                    itemId: 'YearList',
                    striptRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
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
                dockedItems: items["docked.2"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.year"],
        stores: gridnms["stores.year"],
        views: gridnms["views.year"],
        controllers: gridnms["controller.2"],

        launch: function () {
            gridarea2 = Ext.create(gridnms["views.year"], {
                renderTo: 'gridArea2'
            });
        },
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
    };
    extGridSearch(sparams, gridnms["store.1"]);
    extGridSearch(sparams, gridnms["store.2"]);

    fn_chart_search();
    var year = $('#searchYear').val();
    for (var i = 0; i < 5; i++) {
    	Ext.getCmp(gridnms["views.year"]).columns[7 + (i * 2)].ownerCt.setText(year - (4 - i));
    }
}

//PDF 다운로드
function fn_pdf_download() {
 var orgid = $('#searchOrgId option:selected').val();
 var companyid = $('#searchCompanyId option:selected').val();
 var searchYear = $("#searchYear").val();

 var column = 'master';
 var url = null;
 var target = '_blank';

 url = "<c:url value='/report/EisMonthlyYearSalesResultReport.pdf'/>"; // 월별/년도별 매출실적(거래처별)

 fn_popup_url(column, url, target);

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
                                            <a id="btnChk2" class="btn_print" href="#" onclick="javascript:fn_pdf_download();"> 월별/년도별 매출실적 </a>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                        </form>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                <table style="width: 100%;">
                <colgroup>
                <col width="49%">
                <col width="2%">
                <col width="49%">
                </colgroup>
                <tr>
                <td><div class="subConTit3">월별 매출실적</div></td>
                <td></td>
                <td><div class="subConTit3">년도별 매출실적</div></td>
                </tr>
                </table>
                <div id="CChartArea" style="width: 49%; height: 200px; padding-bottom: 30px; margin: 0px; float: left;"></div>
                <div style="width:2%; height: 200px; float: left;"></div>
                <div id="CChartArea2" style="width: 49%; height: 200px; padding-bottom: 30px; margin: 0px; float: left;"></div>
                <div class="subConTit3" >월별 매출실적</div>
                <div id="gridArea" style="width: 100%; padding-bottom: 5px; margin-bottom: 5px; float: left;"></div>
                <div class="subConTit3" >년도별 매출실적</div>
                <div id="gridArea2" style="width: 100%; padding-bottom: 5px; margin-bottom: 5px; float: left;"></div>
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