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
    setTimeout(function () {
        fn_chart_search();
    }, 200);
});

$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    setReadOnly();

    setLovList();

    setTimeout(function () {
        var tabindex = $('#tabindex').val();
        $('#tabindexTemp').val(tabindex);
        fn_tab(tabindex);
    }, 300);

});

var global_model_label, global_model_value, global_itemdetail_value;
var global_year_label, global_year_value;
function setInitial() {
    gridnms["app"] = "prod";

    $('#searchMonth').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            }
        }
    });

    $("#searchMonth").val(getToDay("${searchVO.SEARCHMONTH}") + "");
    $("#searchYear").val(getToDay("${searchVO.SEARCHYEAR}") + "");

    var orgid = $('#searchOrgId').val();
    var companyid = $('#searchCompanyId').val();
    fn_option_change_r4('OM', 'SHIPPING_ITEM_GROUP', 'Y', 'searchLabel');
    fn_option_change_r4('OM', 'SHIPPING_ITEM_GROUP', 'Y', 'searchLabel1');

    fn_option_change_r1('MFG', 'WORK_GROUP', '01', 'searchRoutingGroup');
    fn_option_change_r1('MFG', 'WORK_GROUP', '01', 'searchRoutingGroup1');

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
        fn_option_change_r4('OM', 'SHIPPING_ITEM_GROUP', 'Y', 'searchLabel');
        fn_option_change_r1('MFG', 'WORK_GROUP', '01', 'searchRoutingGroup');
        fn_option_change_r4('OM', 'SHIPPING_ITEM_GROUP', 'Y', 'searchLabel1');
        fn_option_change_r1('MFG', 'WORK_GROUP', '01', 'searchRoutingGroup1');
    });

    $('#searchLabel').change(function (event) {
        $('#searchLabel1').val(this.value);

        var emptyValue = (this.value == "01") ? "0101" : "0202";
        var attr1 = (this.value == "01") ? this.value : "02";
        fn_option_change_r1('MFG', 'WORK_GROUP', attr1, 'searchRoutingGroup');
        fn_option_change_r1('MFG', 'WORK_GROUP', attr1, 'searchRoutingGroup1');
        $('#searchRoutingGroup').val(emptyValue);
        $('#searchRoutingGroup1').val(emptyValue);
    });

    $('#searchLabel1').change(function (event) {
        $('#searchLabel').val(this.value);

        var emptyValue = (this.value == "01") ? "0101" : "0202";
        var attr1 = (this.value == "01") ? this.value : "02";
        fn_option_change_r1('MFG', 'WORK_GROUP', attr1, 'searchRoutingGroup');
        fn_option_change_r1('MFG', 'WORK_GROUP', attr1, 'searchRoutingGroup1');
        $('#searchRoutingGroup').val(emptyValue);
        $('#searchRoutingGroup1').val(emptyValue);
    });

    $('#searchRoutingGroup').change(function (event) {
        $('#searchRoutingGroup1').val(this.value);

    });

    $('#searchRoutingGroup1').change(function (event) {
        $('#searchRoutingGroup').val(this.value);
    });

    var emptyValue = "";
    $('#searchLabel').val("01");
    $('#searchRoutingGroup').val("0101");

    $('#searchLabel1').val("01");
    $('#searchRoutingGroup1').val("0101");

    var searchMonth = $('#searchMonth').val();
    var searchLabel = $('#searchLabel').val();
    var searchRoutingGroup = $('#searchRoutingGroup').val();
    var searchModelCode = $('#searchModelCode').val();
    global_model_value = fn_group_model_filter_data(searchMonth, searchLabel, searchRoutingGroup, searchModelCode, 'VALUE');
    global_model_label = fn_group_model_filter_data(searchMonth, searchLabel, searchRoutingGroup, searchModelCode, 'LABEL');

    global_itemdetail_value = fn_group_itemdetail_filter_data(searchMonth, searchLabel, searchRoutingGroup, searchModelCode, 'VALUE');

    var searchYear = $('#searchYear').val();
    var searchLabel1 = $('#searchLabel1').val();
    var searchRoutingGroup1 = $('#searchRoutingGroup1').val();
    var searchModelCode1 = $('#searchModelCode1').val();
    global_year_value = fn_group_year_model_filter_data(searchYear, searchLabel1, searchRoutingGroup1, searchModelCode1, 'VALUE');
    global_year_label = fn_group_year_model_filter_data(searchYear, searchLabel1, searchRoutingGroup1, searchModelCode1, 'LABEL');

}

var g_data;
// 차트 데이터 Set
var header_g = ["일자", "생산수량"];
var row_g = "", msg_g = "", check_g = false;
function gdrawChart(v) {
    var title_name = '그래프';
    var view = new google.visualization.DataView(v);

    var options = {
        //      title: title_name,
        width: '100%',
        height: '100%', // 580,
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        bar: {
            groupWidth: '100%'
        },
        legend: {
            position: 'right',
            alignment: 'center',
            //         maxLines: 8,
        },
        //     legend: {
        //       position: 'none'
        //     },
        crosshair: {
            trigger: 'both'
        },
        chartArea: {
            width: '85%',
            height: '90%',
            left: '5%',
            //        top: 0,
        },
//         forceIFrame: true,
        role: {
            opacity: 0.7,
        },
        hAxis: {
            format: 'decimal',
        },
        seriesType: "line",
        series: {
            0: {
                type: 'line',
                //             targetAxisIndex: 1,
                color: '#4F81BD', // 'blue',
                visibleInLegend: true, // false,
                //             lineDashStyle: [4, 4, 4, 4],
                pointShape: 'diamond', // 'square',
                pointSize: 15,
                lineWidth: 3,
            }
        },
        tooltip: {
            ignoreBounds: false,
            isHtml: false,
            showColorCode: true,
            text: 'both', // 'value', 'percentage',
            trigger: 'focus', // 'selection',
        },
        dataOpacity: 1, // 0.7,
        curveType: 'none', // 'function',
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var gchart = new google.visualization.ComboChart(document.getElementById('GChartArea'));
    gchart.draw(view, options);
}

var y_data;
// 차트 데이터 Set
var header_y = ["월", "2년 전", "1년 전", "금년"];
var row_y = "", msg_y = "", check_y = false;
function ydrawChart(v) {
    var title_name = '3개년 대비 그래프';
    var view = new google.visualization.DataView(v);

    var options = {
        //      title: title_name,
        width: '100%',
        height: '100%', // 580,
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        bar: {
            groupWidth: '80%'
        },
        legend: {
            position: 'none'
        },
        crosshair: {
            trigger: 'both'
        },
        chartArea: {
            width: '75%',
            height: '80%',
            left: '10%',
            //        top: 0,
        },
//         forceIFrame: true,
        role: {
            opacity: 0.7,
        },
        hAxis: {
            format: 'decimal',
        },
        seriesType: "bars",
        series: {
            0: {
                type: 'bar',
                color: '#1DDB16',
                visibleInLegend: true, // false,
            },
            1: {
                type: 'bar',
                color: '#4F81BD',
                visibleInLegend: true,
            },
            2: {
                type: 'bar',
                color: '#FF0000',
                visibleInLegend: true,
            }
        },
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

    var ychart = new google.visualization.ComboChart(document.getElementById('YChartArea'));
    ychart.draw(view, options);
}

var m_data;
// 차트 데이터 Set
var header_m = ["기종", "비율(%)"];
var row_m = "", msg_m = "", check_m = false;
function mdrawChart(v) {
    var title_name = '금년도 생산 비율';
    var view = new google.visualization.DataView(v);

    var options = {
        //      title: title_name,
        width: '100%',
        height: '100%',
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        is3D: true,
        sliceVisibilityThreshold: .1,
        pieHole: 0.2,
        pieSliceText: 'label',
        pieSliceTextStyle: {
            color: 'white',
            fontName: 'Malgun Gothic',
        },
        slices: {
            //        0: {
            //          color: (occurdata.attribute3[0] == "") ? "auto" : occurdata.attribute3[0]
            //        },
        },
        legend: {
            position: 'bottom',
            alignment: 'center',
            maxLines: 3,
        },
        chartArea: {
            width: '80%',
            height: '75%',
            left: '10%',
            //        top: 0,
        },
//         forceIFrame: true,
        role: {
            opacity: 0.7,
        },
        hAxis: {
            format: 'decimal',
        },
        tooltip: {
            ignoreBounds: false,
            isHtml: false,
            showColorCode: true,
            text: 'both', // 'value', 'percentage',
            trigger: 'selection', // 'focus',
        },
        dataOpacity: 1, // 0.7,
        curveType: 'none',
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var mchart = new google.visualization.PieChart(document.getElementById('MChartArea'));
    mchart.draw(view, options);
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    var searchYear = $('#searchYear').val();
    serValues_year(searchYear);

    var searchMonth = $('#searchMonth').val();
    serValues_month(searchMonth);
    serValues_type(searchMonth);
}

function serValues_year(year) {
    gridnms["models.year"] = [];
    gridnms["stores.year"] = [];
    gridnms["views.year"] = [];
    gridnms["controllers.year"] = [];

    gridnms["grid.1"] = "YearModelMonthlyList";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.year"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.year"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

    gridnms["models.year"].push(gridnms["model.1"]);

    gridnms["stores.year"].push(gridnms["store.1"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'STANDARDMONTH',
        }, {
            type: 'string',
            name: 'NUM01',
        }, {
            type: 'string',
            name: 'NUM02',
        }, {
            type: 'string',
            name: 'NUM03',
        }, {
            type: 'string',
            name: 'NUM04',
        }, {
            type: 'string',
            name: 'NUM05',
        }, {
            type: 'string',
            name: 'NUM06',
        }, {
            type: 'string',
            name: 'NUM07',
        }, {
            type: 'string',
            name: 'NUM08',
        }, {
            type: 'string',
            name: 'NUM09',
        }, {
            type: 'string',
            name: 'NUM10',
        }, {
            type: 'string',
            name: 'NUM11',
        }, {
            type: 'string',
            name: 'NUM12',
        }, {
            type: 'string',
            name: 'NUM13',
        }, {
            type: 'string',
            name: 'NUM14',
        }, {
            type: 'string',
            name: 'NUM15',
        }, {
            type: 'string',
            name: 'IMPORTQTY',
        }, ];

    var colorcode = " color: rgb(255, 255, 255); background-color: rgb(73, 69, 41); ";
    var colorcode1 = " color: rgb(255, 255, 255); background-color: rgb(122, 48, 160); ";
    fields["columns.1"] = [
        // Display Columns
        {
            dataIndex: 'STANDARDMONTH',
            text: '구분',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;' + colorcode,
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
            summaryRenderer: function (value, meta, record) {
                var header1 = "TOTAL";
                return [header1].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 13px; '>" + val + '</div>';
                }).join('<br />');
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

    var max_count = 15;
    var grid_count = (global_year_label.length > 15) ? 15 : global_year_label.length;
    for (var i = 0; i < grid_count; i++) {
        (function (x) {
            var rn = (x + 1) + "";
            var qty_index = fn_lpad(rn, 2, '0');
            var column_text = global_year_label[x];
            fields["columns.1"].push({
                dataIndex: 'NUM' + qty_index,
                text: column_text,
                xtype: 'gridcolumn',
                width: 90,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ' + colorcode,
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                summaryType: 'sum',
                summaryRenderer: function (value, summaryData, dataIndex) {
                    var data = Ext.getStore(gridnms["store.1"]).getData().items;

                    var total = 0;
                    for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    }

                    var result = [total].map(function (val, index) {
                        return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; '>" + Ext.util.Format.number(val, '0,000.#') + '</div>';
                    }).join('<br />');
                    return result;
                },
                renderer: function (value, meta, record) {
                    return Ext.util.Format.number(value, '0,000');
                },
            });

        })(i);
    }

    fields["columns.1"].push({
        dataIndex: 'IMPORTQTY',
        text: 'TOTAL',
        xtype: 'gridcolumn',
        width: 90,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;' + colorcode1,
        align: "right",
        cls: 'ERPQTY',
        format: "0,000",
        summaryType: 'sum',
        summaryRenderer: function (value, summaryData, dataIndex) {
            var data = Ext.getStore(gridnms["store.1"]).getData().items;

            var total = 0;
            for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                total += (extExtractValues(data, dataIndex)[i] * 1);
            }

            var result = [total].map(function (val, index) {
                return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; '>" + Ext.util.Format.number(val, '0,000') + '</div>';
            }).join('<br />');
            return result;
        },
        renderer: function (value, meta, record) {
            meta.style = colorcode1;
            return Ext.util.Format.number(value, '0,000');
        },
    });

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/prod/manage/YearModelMonthlyList.do' />"
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

function serValues_month(mon) {
    gridnms["models.month"] = [];
    gridnms["stores.month"] = [];
    gridnms["views.month"] = [];
    gridnms["controllers.month"] = [];

    gridnms["grid.2"] = "DailyModelMonthlyList";

    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
    gridnms["views.month"].push(gridnms["panel.2"]);

    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
    gridnms["controllers.month"].push(gridnms["controller.2"]);

    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

    gridnms["models.month"].push(gridnms["model.2"]);

    gridnms["stores.month"].push(gridnms["store.2"]);

    fields["model.2"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'STANDARDDATE',
        }, {
            type: 'string',
            name: 'DAYNAME',
        }, {
            type: 'string',
            name: 'IMPORTQTY',
        }, {
            type: 'string',
            name: 'FAULTQTY',
        }, {
            type: 'string',
            name: 'NUM01',
        }, {
            type: 'string',
            name: 'NUM02',
        }, {
            type: 'string',
            name: 'NUM03',
        }, {
            type: 'string',
            name: 'NUM04',
        }, {
            type: 'string',
            name: 'NUM05',
        }, {
            type: 'string',
            name: 'NUM06',
        }, {
            type: 'string',
            name: 'NUM07',
        }, {
            type: 'string',
            name: 'NUM08',
        }, {
            type: 'string',
            name: 'NUM09',
        }, {
            type: 'string',
            name: 'NUM10',
        }, {
            type: 'string',
            name: 'NUM11',
        }, {
            type: 'string',
            name: 'NUM12',
        }, {
            type: 'string',
            name: 'NUM13',
        }, {
            type: 'string',
            name: 'NUM14',
        }, {
            type: 'string',
            name: 'NUM15',
        }, ];

    var colorcode = " color: rgb(255, 255, 255); background-color: rgb(47, 117, 181); ";
    fields["columns.2"] = [
        // Display Columns
        {
            dataIndex: 'STANDARDDATE',
            text: '일자',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;' + colorcode,
            align: "center",
            renderer: function (value, meta, record) {
                var dayname = record.data.DAYNAME;
                switch (dayname) {
                case "토":
                    meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                    break;
                case "일":
                    meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                    meta.style += " border-bottom-style: solid;";
                    meta.style += " border-bottom-width: 1px;";
                    meta.style += " border-bottom-color: blue;";
                    break;
                default:
                    meta.style = " color: rgb(102, 102, 102); ";
                    break;
                }
                return value;
            },
            summaryRenderer: function (value, meta, record) {
                var header1 = "누계";
                var header2 = "비율(%)";
                return [header2, header1].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 13px; " + ((index == 1) ? "color: red; " : "") + "'>" + val + '</div>';
                }).join('<br />');
            },
        }, {
            dataIndex: 'IMPORTQTY',
            text: '생산수량',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;' + colorcode,
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.2"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    total += (extExtractValues(data, dataIndex)[i] * 1);
                }

                var cnt = global_model_value.length;

                var avg = (total / cnt).toFixed(1);
                var result = [avg, total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; " + ((index == 1) ? "color: red; " : "") + "'>" + Ext.util.Format.number(val, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var dayname = record.data.DAYNAME;
                switch (dayname) {
                case "토":
                    meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                    break;
                case "일":
                    meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                    meta.style += " border-bottom-style: solid;";
                    meta.style += " border-bottom-width: 1px;";
                    meta.style += " border-bottom-color: blue;";
                    break;
                default:
                    meta.style = " color: rgb(102, 102, 102); ";
                    break;
                }
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'FAULTQTY',
            text: '불량수량',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;' + colorcode,
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.2"]).getData().items;

                var total = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    total += (extExtractValues(data, dataIndex)[i] * 1);
                }

                var rate = "&nbsp;";
                var result = [rate, total].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; " + ((index == 1) ? "color: red; " : "") + "'>" + ((index == 0) ? val : Ext.util.Format.number(val, '0,000')) + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var dayname = record.data.DAYNAME;
                switch (dayname) {
                case "토":
                    meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                    break;
                case "일":
                    meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                    meta.style += " border-bottom-style: solid;";
                    meta.style += " border-bottom-width: 1px;";
                    meta.style += " border-bottom-color: blue;";
                    break;
                default:
                    meta.style = " color: rgb(102, 102, 102); ";
                    break;
                }
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

    var max_count = 15;
    var grid_count = (global_model_label.length > 15) ? 15 : global_model_label.length;
    for (var i = 0; i < grid_count; i++) {
        (function (x) {
            var rn = (x + 1) + "";
            var qty_index = fn_lpad(rn, 2, '0');
            var column_text = global_model_label[x];
            fields["columns.2"].push({
                dataIndex: 'NUM' + qty_index,
                text: '<div style="width: 100%; height: 100%; cursor: pointer; " onclick="fn_grid_header_click(' + rn + ');" >' + column_text + '</div>',
                xtype: 'gridcolumn',
                width: 90,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ' + colorcode,
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                summaryType: 'sum',
                summaryRenderer: function (value, summaryData, dataIndex) {
                    var data = Ext.getStore(gridnms["store.2"]).getData().items;

                    var total = 0,
                    modelqty = 0;
                    for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                        modelqty += (extExtractValues(data, dataIndex)[i] * 1);

                        total += (extExtractValues(data, "IMPORTQTY")[i] * 1);
                    }

                    var rate = (((modelqty / total) * 100) > 0) ? ((modelqty / total) * 100).toFixed(1) : 0;
                    var result = [rate, modelqty].map(function (val, index) {
                        return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; " + ((index == 1) ? "color: red; " : "") + "'>" + ((index == 0) ? Ext.util.Format.number(val, '0,000.#%') : Ext.util.Format.number(val, '0,000.#')) + '</div>';
                    }).join('<br />');
                    return result;
                },
                renderer: function (value, meta, record) {
                    var dayname = record.data.DAYNAME;
                    switch (dayname) {
                    case "토":
                        meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                        break;
                    case "일":
                        meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                        meta.style += " border-bottom-style: solid;";
                        meta.style += " border-bottom-width: 1px;";
                        meta.style += " border-bottom-color: blue;";
                        break;
                    default:
                        meta.style = " color: rgb(102, 102, 102); ";
                        break;
                    }
                    return Ext.util.Format.number(value, '0,000');
                },
            });

        })(i);
    }

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/prod/manage/DailyModelMonthlyList.do' />"
    });

    items["btns.2"] = [];

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
}

function serValues_type(mon) {
    gridnms["models.type"] = [];
    gridnms["stores.type"] = [];
    gridnms["views.type"] = [];
    gridnms["controllers.type"] = [];

    gridnms["grid.3"] = "DailyItemDetailMonthlyList";

    gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
    gridnms["views.type"].push(gridnms["panel.3"]);

    gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
    gridnms["controllers.type"].push(gridnms["controller.3"]);

    gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

    gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

    gridnms["models.type"].push(gridnms["model.3"]);

    gridnms["stores.type"].push(gridnms["store.3"]);

    fields["model.3"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'STANDARDDATE',
        }, {
            type: 'string',
            name: 'DAYNAME',
        }, {
            type: 'string',
            name: 'IMPORTQTY',
        }, {
            type: 'string',
            name: 'FAULTQTY',
        }, {
            type: 'string',
            name: 'NUM01',
        }, {
            type: 'string',
            name: 'NUM02',
        }, {
            type: 'string',
            name: 'NUM03',
        }, {
            type: 'string',
            name: 'NUM04',
        }, {
            type: 'string',
            name: 'NUM05',
        }, {
            type: 'string',
            name: 'NUM06',
        }, {
            type: 'string',
            name: 'NUM07',
        }, {
            type: 'string',
            name: 'NUM08',
        }, {
            type: 'string',
            name: 'NUM09',
        }, {
            type: 'string',
            name: 'NUM10',
        }, {
            type: 'string',
            name: 'NUM11',
        }, {
            type: 'string',
            name: 'NUM12',
        }, {
            type: 'string',
            name: 'NUM13',
        }, {
            type: 'string',
            name: 'NUM14',
        }, {
            type: 'string',
            name: 'NUM15',
        }, ];

    var colorcode = " color: rgb(255, 255, 255); background-color: rgb(47, 117, 181); ";
    fields["columns.3"] = [
        // Display Columns
        {
            dataIndex: 'STANDARDDATE',
            text: '일자',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;' + colorcode,
            align: "center",
            renderer: function (value, meta, record) {
                var dayname = record.data.DAYNAME;
                var lev = record.data.LEV;
                switch (lev) {
                case 1:
                    switch (dayname) {
                    case "토":
                        meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                        break;
                    case "일":
                        meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                        break;
                    default:
                        meta.style = " color: rgb(102, 102, 102); ";
                        break;
                    }
                    break;
                case 2:
                    switch (dayname) {
                    case "토":
                        meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                        break;
                    case "일":
                        meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                        break;
                    default:
                        break;
                    }
                    meta.style += " border-bottom-style: solid;";
                    meta.style += " border-bottom-width: 1px;";
                    meta.style += " border-bottom-color: black;";
                    break;
                default:
                    break;
                }
                return value;
            },
            summaryRenderer: function (value, meta, record) {
                var header1 = "생산누계";
                var header2 = "출&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;하";
                var header3 = "전월이월";
                var header4 = "현재공";
                return [header1, header2, header3, header4].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 13px; '>" + val + '</div>';
                }).join('<br />');
            },
        }, {
            dataIndex: 'IMPORTQTY',
            text: '생산수량',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;' + colorcode,
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.3"]).getData().items;

                var total = 0;
                var ship = 0;
                var pre_qty = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var lev = extExtractValues(data, "LEV")[i];
                    if (lev == "1") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    } else if (lev == "2") {
                        ship += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }

                var current = (total + pre_qty) - ship;
                var result = [total, ship, pre_qty, current].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; '>" + Ext.util.Format.number(val, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var dayname = record.data.DAYNAME;
                var lev = record.data.LEV;
                switch (lev) {
                case 1:
                    switch (dayname) {
                    case "토":
                        meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                        break;
                    case "일":
                        meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                        break;
                    default:
                        meta.style = " color: rgb(102, 102, 102); ";
                        break;
                    }
                    break;
                case 2:
                    meta.style = " color: rgb(0, 0, 0); background-color:rgb(204, 255, 255); ";
                    meta.style += " border-bottom-style: solid;";
                    meta.style += " border-bottom-width: 1px;";
                    meta.style += " border-bottom-color: black;";
                    break;
                default:
                    break;
                }
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'FAULTQTY',
            text: '불량수량',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;' + colorcode,
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, summaryData, dataIndex) {
                var data = Ext.getStore(gridnms["store.3"]).getData().items;

                var total = 0;
                var ship = 0;
                var pre_qty = 0;
                for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                    var lev = extExtractValues(data, "LEV")[i];
                    if (lev == "1") {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                    } else if (lev == "2") {
                        ship += (extExtractValues(data, dataIndex)[i] * 1);
                    }
                }

                var current = (total + pre_qty) - ship;
                var result = [total, ship, pre_qty, current].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; '>" + Ext.util.Format.number(val, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: function (value, meta, record) {
                var dayname = record.data.DAYNAME;
                var lev = record.data.LEV;
                switch (lev) {
                case 1:
                    switch (dayname) {
                    case "토":
                        meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                        break;
                    case "일":
                        meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                        break;
                    default:
                        meta.style = " color: rgb(102, 102, 102); ";
                        break;
                    }
                    break;
                case 2:
                    meta.style = " color: rgb(0, 0, 0); background-color:rgb(204, 255, 255); ";
                    meta.style += " border-bottom-style: solid;";
                    meta.style += " border-bottom-width: 1px;";
                    meta.style += " border-bottom-color: black;";
                    break;
                default:
                    break;
                }
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

    var max_count = 15;
    var grid_count = (global_itemdetail_value.length > 15) ? 15 : global_itemdetail_value.length;
    for (var i = 0; i < grid_count; i++) {
        (function (x) {
            var rn = (x + 1) + "";
            var qty_index = fn_lpad(rn, 2, '0');
            var column_text = global_itemdetail_value[x];
            fields["columns.3"].push({
                dataIndex: 'NUM' + qty_index,
                text: column_text,
                xtype: 'gridcolumn',
                width: 90,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ' + colorcode,
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                summaryType: 'sum',
                summaryRenderer: function (value, summaryData, dataIndex) {
                    var data = Ext.getStore(gridnms["store.3"]).getData().items;

                    var total = 0;
                    var ship = 0;
                    var pre_qty = 0;
                    for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                        var lev = extExtractValues(data, "LEV")[i];
                        if (lev == "1") {
                            total += (extExtractValues(data, dataIndex)[i] * 1);
                        } else if (lev == "2") {
                            ship += (extExtractValues(data, dataIndex)[i] * 1);
                        }
                    }

                    var current = (total + pre_qty) - ship;
                    var result = [total, ship, pre_qty, current].map(function (val, index) {
                        return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; '>" + Ext.util.Format.number(val, '0,000') + '</div>';
                    }).join('<br />');
                    return result;
                },
                renderer: function (value, meta, record) {
                    var dayname = record.data.DAYNAME;
                    var lev = record.data.LEV;
                    switch (lev) {
                    case 1:
                        switch (dayname) {
                        case "토":
                            meta.style = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                            break;
                        case "일":
                            meta.style = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                            break;
                        default:
                            meta.style = " color: rgb(102, 102, 102); ";
                            break;
                        }
                        break;
                    case 2:
                        meta.style = " color: rgb(0, 0, 0); background-color:rgb(204, 255, 255); ";
                        meta.style += " border-bottom-style: solid;";
                        meta.style += " border-bottom-width: 1px;";
                        meta.style += " border-bottom-color: black;";
                        break;
                    default:
                        break;
                    }
                    return Ext.util.Format.number(value, '0,000');
                },
            });

        })(i);
    }

    items["api.3"] = {};
    $.extend(items["api.3"], {
        read: "<c:url value='/select/prod/manage/DailyDetailMonthlyList.do' />"
    });

    items["btns.3"] = [];

    items["btns.ctr.3"] = {};

    items["dock.paging.3"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.3"],
    };

    items["dock.btn.3"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.3"],
        items: items["btns.3"],
    };

    items["docked.3"] = [];
}

var gridarea, gridarea2, gridarea3;
function setExtGrid() {
    serExtGrid_year();
    serExtGrid_month();
    serExtGrid_type();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
        gridarea2.updateLayout();
        gridarea3.updateLayout();
    });
}

function serExtGrid_year() {
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
                        autoLoad: false,
                        pageSize: 9999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.1"],
                            timeout: gridVals.timeout,
                            //                extraParams: {
                            //                  ORGID: $('#searchOrgId option:selected').val(),
                            //                  COMPANYID: $('#searchCompanyId option:selected').val(),
                            //                  SEARCHYEAR: $("#searchYear").val() + "",
                            //                },
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
            YearModelList: '#YearModelList',
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
                height: 385, // 657,
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
                    itemId: 'YearModelList',
                    trackOver: true,
                    loadMask: true,
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
        models: gridnms["models.year"],
        stores: gridnms["stores.year"],
        views: gridnms["views.year"],
        controllers: gridnms["controller.1"],

        launch: function () {
            gridarea = Ext.create(gridnms["views.year"], {
                renderTo: 'gridArea'
            });
        },
    });
}

function serExtGrid_month() {
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
                        autoLoad: false,
                        pageSize: 9999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.2"],
                            timeout: gridVals.timeout,
                            //                extraParams: {
                            //                  ORGID: $('#searchOrgId option:selected').val(),
                            //                  COMPANYID: $('#searchCompanyId option:selected').val(),
                            //                  SEARCHMONTH: $("#searchMonth").val() + "",
                            //                },
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
            DailyModelList: '#DailyModelList',
        },
        stores: [gridnms["store.2"]],
        control: items["btns.ctr.2"],
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
                height: 657,
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
                    itemId: 'DailyModelList',
                    trackOver: true,
                    loadMask: true,
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
        models: gridnms["models.month"],
        stores: gridnms["stores.month"],
        views: gridnms["views.month"],
        controllers: gridnms["controller.2"],

        launch: function () {
            gridarea2 = Ext.create(gridnms["views.month"], {
                renderTo: 'gridArea2'
            });
        },
    });
}

function fn_grid_header_click(flag) {

    var rn = flag - 1;
    var modelname = global_model_label[rn];
    var model = global_model_value[rn];

    $('#searchModelName').val(modelname);
    $('#searchModelCode').val(model);

    var searchMonth = $('#searchMonth').val();
    var searchLabel = $('#searchLabel').val();
    var searchRoutingGroup = $('#searchRoutingGroup').val();
    var searchModelCode = $('#searchModelCode').val();

    global_itemdetail_value = fn_group_itemdetail_filter_data(searchMonth, searchLabel, searchRoutingGroup, searchModelCode, 'VALUE');

    $('#tabindex').val('3');
    var tabindex = $('#tabindex').val();
    fn_tab(tabindex);
}

function serExtGrid_type() {
    Ext.define(gridnms["model.3"], {
        extend: Ext.data.Model,
        fields: fields["model.3"],
    });

    Ext.define(gridnms["store.3"], {
        extend: Ext.data.JsonStore, // Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.3"],
                        model: gridnms["model.3"],
                        autoLoad: false,
                        pageSize: 9999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.3"],
                            timeout: gridVals.timeout,
                            //                extraParams: {
                            //                  ORGID: $('#searchOrgId option:selected').val(),
                            //                  COMPANYID: $('#searchCompanyId option:selected').val(),
                            //                  SEARCHMONTH: $("#searchMonth").val() + "",
                            //                },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.3"], {
        extend: Ext.app.Controller,
        refs: {
            DailyTypeList: '#DailyTypeList',
        },
        stores: [gridnms["store.3"]],
        control: items["btns.ctr.3"],
    });

    Ext.define(gridnms["panel.3"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.3"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'rowmodel',
                itemId: gridnms["panel.3"],
                id: gridnms["panel.3"],
                store: gridnms["store.3"],
                height: 657,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'top'
                    }
                ],
                scrollable: true,
                columns: fields["columns.3"],
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
                    itemId: 'DailyTypeList',
                    trackOver: true,
                    loadMask: true,
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                    }
                ],
                dockedItems: items["docked.3"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.type"],
        stores: gridnms["stores.type"],
        views: gridnms["views.type"],
        controllers: gridnms["controller.3"],

        launch: function () {
            gridarea3 = Ext.create(gridnms["views.type"], {
                renderTo: 'gridArea3'
            });
        },
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchMonth = $('#searchMonth').val();
    var searchLabel = $('#searchLabel').val();
    var searchRoutingGroup = $('#searchRoutingGroup').val();
    var searchModelCode = $('#searchModelCode').val();
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

    if (searchMonth == "") {
        header.push("년월");
        count++;
    }

    if (searchLabel == "") {
        header.push("매출그룹");
        count++;
    }

    if (searchRoutingGroup == "") {
        header.push("공정그룹");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        result = false;
    }

    return result;
}

function fn_validation1() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchYear = $('#searchYear').val();
    var searchLabel = $('#searchLabel1').val();
    var searchRoutingGroup = $('#searchRoutingGroup1').val();
    var searchModelCode = $('#searchModelCode1').val();
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

    if (searchYear == "") {
        header.push("년도");
        count++;
    }

    if (searchLabel == "") {
        header.push("매출그룹");
        count++;
    }

    if (searchRoutingGroup == "") {
        header.push("공정그룹");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        result = false;
    }

    return result;
}

function fn_search() {
    var tabindex = $('#tabindex').val();

    switch (tabindex) {
    case "1":
        if (!fn_validation1()) {
            return;
        }
        break;
    case "2":
    case "3":
    case "4":
        if (!fn_validation()) {
            return;
        }

        break;
    default:
        break;
    }

    var emptyValue = "";
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchMonth = $('#searchMonth').val();
    var searchLabel = $('#searchLabel').val();
    var searchRoutingGroup = $('#searchRoutingGroup').val();
    var searchModelCode = $('#searchModelCode').val();

    switch (tabindex) {
    case "1":
        var searchYear = $('#searchYear').val();
        $('#searchModelCode1').val(emptyValue);
        $('#searchModelName1').val(emptyValue);
        var searchLabel1 = $('#searchLabel1').val();
        var searchRoutingGroup1 = $('#searchRoutingGroup1').val();
        var searchModelCode1 = $('#searchModelCode1').val();
        global_year_value = fn_group_year_model_filter_data(searchYear, searchLabel1, searchRoutingGroup1, searchModelCode1, 'VALUE');
        global_year_label = fn_group_year_model_filter_data(searchYear, searchLabel1, searchRoutingGroup1, searchModelCode1, 'LABEL');

        fn_chart_search();

        var sparams = {
            ORGID: orgid,
            COMPANYID: companyid,
            SEARCHYEAR: searchYear,
            LABEL: searchLabel1,
            ROUTINGGROUP: searchRoutingGroup1,
            MODEL: searchModelCode1,
        };

        serValues_year(searchYear);
        Ext.suspendLayouts();
        Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
        Ext.resumeLayouts(true);
        extGridSearch(sparams, gridnms["store.1"]);
        break;
    case "2":
        $('#searchModelCode').val(emptyValue);
        $('#searchModelName').val(emptyValue);
        searchModelCode = $('#searchModelCode').val();
        global_model_value = fn_group_model_filter_data(searchMonth, searchLabel, searchRoutingGroup, searchModelCode, 'VALUE');
        global_model_label = fn_group_model_filter_data(searchMonth, searchLabel, searchRoutingGroup, searchModelCode, 'LABEL');

        var sparams = {
            ORGID: orgid,
            COMPANYID: companyid,
            SEARCHMONTH: searchMonth,
            LABEL: searchLabel,
            ROUTINGGROUP: searchRoutingGroup,
            MODEL: searchModelCode,
        };

        serValues_month(searchMonth);
        Ext.suspendLayouts();
        Ext.getCmp(gridnms["panel.2"]).reconfigure(gridnms["store.2"], fields["columns.2"]);
        Ext.resumeLayouts(true);
        extGridSearch(sparams, gridnms["store.2"]);
        break;
    case "3":
        global_itemdetail_value = fn_group_itemdetail_filter_data(searchMonth, searchLabel, searchRoutingGroup, searchModelCode, 'VALUE');

        var sparams = {
            ORGID: orgid,
            COMPANYID: companyid,
            SEARCHMONTH: searchMonth,
            LABEL: searchLabel,
            ROUTINGGROUP: searchRoutingGroup,
            MODEL: searchModelCode,
        };

        serValues_type(searchMonth);
        Ext.suspendLayouts();
        Ext.getCmp(gridnms["panel.3"]).reconfigure(gridnms["store.3"], fields["columns.3"]);
        Ext.resumeLayouts(true);
        extGridSearch(sparams, gridnms["store.3"]);
        break;
    case "4":
        fn_chart_search();

        break;
    default:
        break;
    }
}

function fn_chart_search() {

    if (!fn_validation()) {
        return;
    }

    var emptyValue = "";
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchMonth = $('#searchMonth').val();
    var searchLabel = $('#searchLabel').val();
    var searchRoutingGroup = $('#searchRoutingGroup').val();
    var searchModelCode = $('#searchModelCode').val();
    var tabindex = $('#tabindex').val();

    switch (tabindex) {
    case "1":
        var searchYear = $('#searchYear').val();
        $('#searchModelCode1').val(emptyValue);
        $('#searchModelName1').val(emptyValue);
        var searchLabel1 = $('#searchLabel1').val();
        var searchRoutingGroup1 = $('#searchRoutingGroup1').val();
        var searchModelCode1 = $('#searchModelCode1').val();
        
        var year = new Date(searchYear);
        var year1 = year.getFullYear()-1;
        var year2 = year.getFullYear()-2;
        
        var year_c = Ext.util.Format.date(year, 'Y년');
        var year1_c = Ext.util.Format.date(year1, 'Y년');
        var year2_c = Ext.util.Format.date(year2, 'Y년');
        header_y[1] = year2_c;
        header_y[2] = year1_c;
        header_y[3] = year_c;
        
        var sparams = {
            ORGID: orgid,
            COMPANYID: companyid,
            SEARCHYEAR: searchYear,
            LABEL: searchLabel1,
            ROUTINGGROUP: searchRoutingGroup1,
            MODEL: searchModelCode1,
        };

        var url_y = "<c:url value='/select/prod/manage/DailyGraphYearList.do'/>";
        $.ajax({
            url: url_y,
            type: "post",
            dataType: "json",
            data: sparams,
            success: function (data) {
                var rows = new Array();
                if (data.totcnt == 0) {
                    msg_y = "조회하신 항목에 대한 데이터가 없습니다.";
                    check_y = false;

                    setDummyYChart();
                } else {
                    msg_y = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                    check_y = true;

                    var rows = new Array();
                    for (var i = 0; i < data.totcnt; i++) {
                        row_y = [data.data[i].STANDARDMONTH, data.data[i].IMPORTQTY2, data.data[i].IMPORTQTY1, data.data[i].IMPORTQTY];
                        rows.push(row_y);
                    }

                    var jsonData_y = [header_y].concat(rows);
                    y_data = google.visualization.arrayToDataTable(jsonData_y);

                    // 차트 호출
                    ydrawChart(y_data);
                }

                if (check_y == false) {
                    extAlert(msg_y);
                    return;
                }
            },
            error: ajaxError
        });

        var url_m = "<c:url value='/select/prod/manage/DailyGraphModelList.do'/>";
        $.ajax({
            url: url_m,
            type: "post",
            dataType: "json",
            data: sparams,
            success: function (data) {
                var rows = new Array();
                if (data.totcnt == 0) {
                    msg_m = "조회하신 항목에 대한 데이터가 없습니다.";
                    check_m = false;

                    setDummyMChart();
                } else {
                    msg_m = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                    check_m = true;

                    var rows = new Array();
                    for (var i = 0; i < data.totcnt; i++) {
                        row_m = [data.data[i].MODELNAME, data.data[i].QTY];
                        rows.push(row_m);
                    }

                    var jsonData_m = [header_m].concat(rows);
                    m_data = google.visualization.arrayToDataTable(jsonData_m);

                    // 차트 호출
                    mdrawChart(m_data);
                }

                if (check_m == false) {
                    extAlert(msg_m);
                    return;
                }
            },
            error: ajaxError
        });
        break;
    case "4":
        var sparams = {
            ORGID: orgid,
            COMPANYID: companyid,
            SEARCHMONTH: searchMonth,
            LABEL: searchLabel,
            ROUTINGGROUP: searchRoutingGroup,
            MODEL: searchModelCode,
        };

        var url_g = "<c:url value='/select/prod/manage/DailyGraphMonthlyList.do'/>";
        $.ajax({
            url: url_g,
            type: "post",
            dataType: "json",
            data: sparams,
            success: function (data) {
                var rows = new Array();
                if (data.totcnt == 0) {
                    msg_g = "조회하신 항목에 대한 데이터가 없습니다.";
                    check_g = false;

                    setDummyGChart();
                } else {
                    msg_g = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                    check_g = true;

                    var rows = new Array();
                    for (var i = 0; i < data.totcnt; i++) {
                        row_g = [data.data[i].STANDARDDATE, data.data[i].IMPORTQTY];
                        rows.push(row_g);
                    }

                    var jsonData_g = [header_g].concat(rows);
                    g_data = google.visualization.arrayToDataTable(jsonData_g);

                    // 차트 호출
                    gdrawChart(g_data);
                }

                if (check_g == false) {
                    extAlert(msg_g);
                    return;
                }
            },
            error: ajaxError
        });

        break;
    default:
        break;
    }

}

function setDummyYChart() {

    var rows = new Array();
    // Dummy 데이터 Set
    row_y = [null, 0, 0, 0];
    rows.push(row_y); ;

    var jsonData_y = [header_y].concat(rows);
    y_data = google.visualization.arrayToDataTable(jsonData_y);

    // 차트 호출
    ydrawChart(y_data);
}

function setDummyMChart() {

    var rows = new Array();
    // Dummy 데이터 Set
    row_m = [null, 0];
    rows.push(row_m); ;

    var jsonData_m = [header_m].concat(rows);
    m_data = google.visualization.arrayToDataTable(jsonData_m);

    // 차트 호출
    mdrawChart(m_data);
}

function setDummyGChart() {

    var rows = new Array();
    // Dummy 데이터 Set
    row_g = [null, 0];
    rows.push(row_g); ;

    var jsonData_g = [header_g].concat(rows);
    g_data = google.visualization.arrayToDataTable(jsonData_g);

    // 차트 호출
    gdrawChart(g_data);
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
    // 기종 Lov
    $("#searchModelName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //        $("#searchModelName").val("");
            $("#searchModelCode").val("");
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
            $.getJSON("<c:url value='/searchSmallCodeListLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
                BIGCD: 'CMM',
                MIDDLECD: 'MODEL',
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            label: m.LABEL,
                            value: m.VALUE
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
            $("#searchModelName").val(o.item.label);
            $("#searchModelCode").val(o.item.value);
            return false;
        }
    });

    $("#searchModelName1").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //        $("#searchModelName1").val("");
            $("#searchModelCode1").val("");
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
            $.getJSON("<c:url value='/searchSmallCodeListLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
                BIGCD: 'CMM',
                MIDDLECD: 'MODEL',
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            label: m.LABEL,
                            value: m.VALUE
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
            $("#searchModelName1").val(o.item.label);
            $("#searchModelCode1").val(o.item.value);
            return false;
        }
    });
}

function fn_tab(flag) {
    $("#tab1,#tab2,#tab3,#tab4").removeClass("active");
    switch (flag) {
    case "1":
        // 년도종합
        $("#tab1").addClass("active");

        $('#YChartArea').show();
        $('#MChartArea').show();

        $('#daily_tab').hide();
        $('#year_tab').show();

        $('#gridArea').show();
        Ext.getCmp(gridnms["views.year"]).show();

        $('#gridArea2').hide();
        Ext.getCmp(gridnms["views.month"]).hide();

        $('#gridArea3').hide();
        Ext.getCmp(gridnms["views.type"]).hide();

        $('#GChartArea').hide();

        break;
    case "2":
        // 월별종합
        $("#tab2").addClass("active");

        $('#YChartArea').hide();
        $('#MChartArea').hide();

        $('#daily_tab').show();
        $('#year_tab').hide();

        $('#gridArea').hide();
        Ext.getCmp(gridnms["views.year"]).hide();

        $('#gridArea2').show();
        Ext.getCmp(gridnms["views.month"]).show();

        $('#gridArea3').hide();
        Ext.getCmp(gridnms["views.type"]).hide();

        $('#GChartArea').hide();

        break;
    case "3":
        // 타입별
        $("#tab3").addClass("active");

        var tabindextemp = $('#tabindexTemp').val();
        if ( tabindextemp != flag ) {

        	var modelcode = $('#searchModelCode').val();
        	if ( modelcode === "" || modelcode === undefined ) {

                var modelname = global_model_label[0];
                var model = global_model_value[0];

                $('#searchModelName').val(modelname);
                $('#searchModelCode').val(model);

                var searchMonth = $('#searchMonth').val();
                var searchLabel = $('#searchLabel').val();
                var searchRoutingGroup = $('#searchRoutingGroup').val();
                var searchModelCode = $('#searchModelCode').val();

                global_itemdetail_value = fn_group_itemdetail_filter_data(searchMonth, searchLabel, searchRoutingGroup, searchModelCode, 'VALUE');

        	}
        }
        
        $('#YChartArea').hide();
        $('#MChartArea').hide();

        $('#daily_tab').show();
        $('#year_tab').hide();

        $('#gridArea').hide();
        Ext.getCmp(gridnms["views.year"]).hide();

        $('#gridArea2').hide();
        Ext.getCmp(gridnms["views.month"]).hide();

        $('#gridArea3').show();
        Ext.getCmp(gridnms["views.type"]).show();

        $('#GChartArea').hide();

        break;
    case "4":
        // 그래프
        $("#tab4").addClass("active");

        $('#YChartArea').hide();
        $('#MChartArea').hide();

        $('#daily_tab').show();
        $('#year_tab').hide();

        $('#gridArea').hide();
        Ext.getCmp(gridnms["views.year"]).hide();

        $('#gridArea2').hide();
        Ext.getCmp(gridnms["views.month"]).hide();

        $('#gridArea3').hide();
        Ext.getCmp(gridnms["views.type"]).hide();

        $('#GChartArea').show();

        break;
    default:
        fn_tab('2');

        fn_ready();
        break;
    }

    setTimeout(function () {

        $('#tabindex').val(flag);
        fn_search();
    }, 200);
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
														<li>공정현황</li>
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
												    <input type="hidden" id="tabindex" name="tabindex" value="${searchVO.tabindex}" />
                            <input type="hidden" id="tabindexTemp" name="tabindexTemp" value="" />
                            <input type="hidden" id="searchMonthTemp" name="searchMonthTemp" value="" />
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
																		<td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 50%;">
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
																		</select></td>
																		<td>
																				<div class="buttons" style="float: right; margin-top: 3px;">
																						<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
																				</div>
																		</td>
																</tr>
														</table>
														<div id="daily_tab">
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
		                                    <th class="required_text">년월</th>
		                                    <td>
		                                        <input type="text" id="searchMonth" name="searchMonth" class="input_validation input_center" style="width: 100px; min-width: 100px;" maxlength="7" />
		                                    </td>
		                                    <th class="required_text">매출그룹</th>
		                                    <td>
		                                        <select id="searchLabel" name="searchLabel" class="input_validation input_left" style="width: 97%;" ></select>
		                                    </td>
		                                    <th class="required_text">공정그룹</th>
		                                    <td>
		                                        <select id="searchRoutingGroup" name="searchRoutingGroup" class="input_validation input_left" style="width: 97%;" ></select>
		                                    </td>
		                                    <th class="required_text">기종</th>
		                                    <td>
		                                        <input type="text" id="searchModelName" name="searchModelName" class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
		                                        <input type="hidden" id="searchModelCode" name="searchModelCode" />
		                                    </td>
		                                </tr>
		                            </table>
														</div>
                            <div id="year_tab">
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
                                        <th class="required_text">년도</th>
                                        <td>
                                            <input type="text" id="searchYear" name="searchYear" class="input_validation input_center" style="width: 100px; min-width: 100px;" maxlength="4" />
                                        </td>
                                        <th class="required_text">매출그룹</th>
                                        <td>
                                            <select id="searchLabel1" name="searchLabel1" class="input_validation input_left" style="width: 97%;" ></select>
                                        </td>
                                        <th class="required_text">공정그룹</th>
                                        <td>
                                            <select id="searchRoutingGroup1" name="searchRoutingGroup1" class="input_validation input_left" style="width: 97%;" ></select>
                                        </td>
                                        <th class="required_text">기종</th>
                                        <td>
                                            <input type="text" id="searchModelName1" name="searchModelName1" class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                            <input type="hidden" id="searchModelCode1" name="searchModelCode1" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
										    </form>
										</fieldset>
                </div>
								<!-- //검색 필드 박스 끝 -->
                <div id="YChartArea" style="width: 49%; height: 272px; padding-top: 0px; padding-left: 0px; margin-top: 0px; margin: 0px; float: left;"></div>
                <div id="MChartArea" style="width: 49%; height: 272px; padding-top: 0px; padding-left: 0px; margin-top: 0px; margin: 0px; margin-left: 2%; float: left;"></div>
                <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
								<div id="gridArea2" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                <div id="gridArea3" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                <div id="GChartArea" style="width: 100%; height: 662px; padding-top: 0px; padding-left: 0px; margin-top: 0px; margin: 0px; float: left;"></div>
                <div class="tab line" style="width: 100%; float: left; margin-top: 0px; padding-bottom: 0px;">
                    <ul>
                        <li id="tab1"><a href="#" onclick="javascript:fn_tab('1');" select><span style=" font-size: 14px;">년간종합</span></a></li>
                        <li id="tab2"><a href="#" onclick="javascript:fn_tab('2');" select><span style=" font-size: 14px;">월별종합</span></a></li>
                        <li id="tab3"><a href="#" onclick="javascript:fn_tab('3');" select><span style=" font-size: 14px;">타입별</span></a></li>
                        <li id="tab4"><a href="#" onclick="javascript:fn_tab('4');" select><span style=" font-size: 14px;">그래프</span></a></li>
                    </ul>
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