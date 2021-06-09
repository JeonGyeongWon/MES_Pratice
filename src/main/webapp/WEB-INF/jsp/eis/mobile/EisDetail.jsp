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
	LoginVO loginVO = (LoginVO) session.getAttribute("LoginVO");
	String authCode = loginVO.getAuthCode();

	/* Image Path 설정 */
	String imagePath_icon = "/images/egovframework/sym/mpm/icon/";
	String imagePath_button = "/images/egovframework/sym/mpm/button/";
%>
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
<link type="text/css" rel="stylesheet" href="<c:url value='/css/custom_mobile.css'/>" />
<html>
<head>
<title>${pageTitle}</title>

<style>
.shadow {
	-webkit-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
	-moz-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
	box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
}

.h:HOVER {
	background-color: highlight;
}

.blue {
	background-color: #003399;
	color: white;
}

.blue2 {
	background-color: #5B9BD5;
	color: white;
}

.gray:HOVER {
	background-color: #EAEAEA;
}

.gray {
	background-color: #BDBDBD;
	color: black;
}

.white:HOVER {
	background-color: #FFFFFF;
	color: black;
}

.white {
	background-color: #000000;
	color: white;
}

.yellow:HOVER {
	background-color: #FFFF7E;
}

.yellow {
	background-color: yellow;
	color: black;
}

.red:HOVER {
	background-color: #FFD8D8;
}

.red {
	background-color: #FFA7A7;
	color: black;
}

.r {
	border-radius: 4px 4px 4px 4px;
	-moz-border-radius: 4px 4px 4px 4px;
	-webkit-border-radius: 4px 4px 4px 4px;
	border: 0px solid #000000;
}

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

ul {
	text-align: center;
	align-items: center;
}

ul li {
	display: inline-block;
	line-height: 28px;
	margin: 0;
	height: 280px;
}

/* html {
	overflow: hidden;
} */

html, body {
  font-family: "Open Sans", sans-serif;
  font-weight: 300;
  font-size: 16px;
  background: #fafafa;
  margin: 0;
  overscroll-behavior-y: contain; /* disable pull to refresh, keeps glow effects */
}
/* html {
  position: fixed;
  overflow: hidden;
} */

body {
	/* 	background-color: rgb(153, 204, 255) !important; */
	/* overscroll-behavior: contain; */
	/* 	overscroll-behavior-y: none; */
	
    height: 100%;
    overflow-y: scroll;
    -webkit-overflow-scrolling: touch;
}

.x-column-header-inner {
	white-space: nowrap;
	position: relative;
	overflow: hidden;
	color: white;
	font-weight: bold;
	/*     background-color: rgb(71, 174, 233); */
	background-color: #122D64;
}

.subConMobile {
	clear: both;
	height: 30px;
	margin-left: 5px;
	padding-top: 0px;
	padding-right: 0;
	padding-left: 15px;
	padding-bottom: 0;
	color: #000000;
	font-family: "NanumGothic Regular";
	font-weight: bold;
	font-size: 23px;
	line-height: 30px;
	margin-bottom: 5px;
	background-image: url(/FNC/css/layout/img/ico_Tit_02.png);
	background-repeat: no-repeat;
	background-position: left center;
	float: left;
}

.subConMobile_ready {
	clear: both;
	margin-left: 5px;
	padding-top: 0px;
	padding-right: 0;
	padding-left: 15px;
	padding-bottom: 0;
	color: gray;
	font-family: "NanumGothic Regular";
	font-weight: bold;
	font-size: 25px;
	line-height: 30px;
	margin-bottom: 5px;
	background-image: url(/FNC/css/layout/img/ico_Tit_02.png);
	background-repeat: no-repeat;
	background-position: left center;
}
</style>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script type="text/javaScript">
google.charts.load('current', {
    packages: ['corechart']
});
google.charts.setOnLoadCallback(fn_chart_search);

$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    setReadOnly();

    setLovList();

    setLastInitial();
});

var occurdata = {};
function setInitial() {
    gridnms["app"] = "eis";
    var num = "${searchVO.num}" * 1;
    global_tab_index = num;

    fn_menu_search();
    fn_option_change_r4('OM', 'SHIPPING_ITEM_GROUP', 'Y', 'searchLabel');

    var orgid = 1;
    var companyid = 1;
    occurdata.label = fn_option_filter_data(orgid, companyid, 'MFG', 'FAULT_TYPE', 'LABEL', "LABEL");
    occurdata.value = fn_option_filter_data(orgid, companyid, 'MFG', 'FAULT_TYPE', 'VALUE', "VALUE");
    occurdata.attribute3 = fn_option_filter_data(orgid, companyid, 'MFG', 'FAULT_TYPE', 'ATTRIBUTE3', "ATTRIBUTE3");

    var limit_leng = 3;
    var label_leng = (searchLabel.options.length < (limit_leng + 1)) ? searchLabel.options.length : limit_leng;
    for (var x = 0; x < label_leng; x++) {
        var label = searchLabel.options[x].text;
        var rn = (x + 1);
        $('#tab3SubTitle' + rn).text(label);

        var value = searchLabel.options[x].value;
        var attr1 = (value == "01") ? value : "02";
        fn_option_change_r1('MFG', 'WORK_GROUP', attr1, 'searchRoutingGroup' + rn);

        var tab3_c_leng = $('#searchRoutingGroup' + rn)[0].length;
        switch (rn) {
        case 1:
            tab3_header1 = new Array();
            tab3_header1.push("월");
            for (var g = 0; g < tab3_c_leng; g++) {
                var text = $('#searchRoutingGroup' + rn)[0][g].text;
                tab3_header1.push(text);
            }
            break;
        case 2:
            tab3_header2 = new Array();
            tab3_header2.push("월");
            for (var g = 0; g < tab3_c_leng; g++) {
                var text = $('#searchRoutingGroup' + rn)[0][g].text;
                tab3_header2.push(text);
            }
            break;
        case 3:
            tab3_header3 = new Array();
            tab3_header3.push("월");
            for (var g = 0; g < tab3_c_leng; g++) {
                var text = $('#searchRoutingGroup' + rn)[0][g].text;
                tab3_header3.push(text);
            }
            break;
        default:
            break;
        }
    }
}

$(window).on("orientationchange", function (event) {
    if (window.matchMedia("(orientation: portrait)").matches) {
        // 세로 모드 (평소 사용하는 각도)
        go_url('<c:url value="/eis/mobile/EisDetail.do?num=' + global_tab_index + '" />');
    } else if (window.matchMedia("(orientation: landscape)").matches) {
        // 가로 모드 (동영상 볼때 사용하는 각도)
        go_url('<c:url value="/eis/mobile/EisDetail.do?num=' + global_tab_index + '" />');
    }
});

var global_tab_index = 1;
function fn_tab(flag) {
    //  var leng = $('ul>li').length;
    //  for( var i = 0 ; i < leng ; i++ ) {
    //    var nm = (i + 1);
    //    $('#list_id' + nm).css("background-color", "");
    //  }
    if (global_tab_index != flag) {
        $('li[name=list_name]').css("background-color", '')

        $('#list_id' + flag).css("background-color", "white");
    }

    var title = "경영자정보";
    var subtitle = "";
    switch (flag) {
    case 1:
        $('#tab_area1').show();
        Ext.getCmp(gridnms["views.tab1"]).show();
        $('#tab_area2').hide();
        $('#tab_area3').hide();
        $('#tab_area4').hide();
        break;
    case 2:
        $('#tab_area1').hide();
        Ext.getCmp(gridnms["views.tab1"]).hide();
        $('#tab_area2').show();
        $('#tab_area3').hide();
        $('#tab_area4').hide();
        break;
    case 3:
        $('#tab_area1').hide();
        Ext.getCmp(gridnms["views.tab1"]).hide();
        $('#tab_area2').hide();
        $('#tab_area3').show();
        $('#tab_area4').hide();
        break;
    case 4:
        $('#tab_area1').hide();
        Ext.getCmp(gridnms["views.tab1"]).hide();
        $('#tab_area2').hide();
        $('#tab_area3').hide();
        $('#tab_area4').show();
        break;
    default:
        break;
    }
    global_tab_index = flag;

    subtitle = $('#title_id' + flag).val();

    title = title + " (" + subtitle + ")";
    $('#pageTitle').text(title);
    fn_search();
    fn_calc_blank_space();
}

function setLastInitial() {
    setTimeout(function () {
        fn_tab(global_tab_index);
        fn_calc_blank_space();
    }, 500);
}

function fn_menu_search() {
    var part = location.pathname.split("/");
    var url = "/" + part[1] + '/searchMobileMenuLov.do';

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        async: false,
        data: "",
        success: function (data) {
            var count = data.totcnt * 1;

            if (count > 0) {
                for (var i = 0; i < count; i++) {
                    var dataList = data.data[i];

                    var menuurl = dataList.MENUURL;
                    var title = dataList.NAMEADD;
                    var menutype = dataList.MENUTYPE * 1;
                    var menusrc = dataList.MENUSRC;
                    var label = dataList.LABEL;

                    var border_css = "";
                    if (i > 0) {
                        border_css = " border-left: 1px solid gray; ";
                    }

                    if (menutype == global_tab_index) {
                        border_css += " background-color: white; ";
                    }

                    fn_list_create(menuurl, menutype, menusrc, label, border_css, title);
                }
            }
        },
        error: ajaxError
    });
}

var global_add_height = 15;
function fn_calc_blank_space() {
    var height = window.innerHeight;
    var top_height = $('#top_area').height() + global_add_height;
    var bottom_height = $('#bottom_area').height() + global_add_height;
    var tab_height = $('#tab_area' + global_tab_index).height();
    var calc_height = Math.ceil(Math.abs(height - (top_height + tab_height))) + bottom_height;
    $('#blank_area1').css("height", top_height);
    //     $('#blank_area2').css("height", calc_height);

    document.body.scrollTop = 0;
    document.documentElement.scrollTop = 0;
}

function fn_list_create(url, type, src, label, css, title) {
    var list_code = '<li id="list_id' + type + '" name="list_name" onclick="fn_tab(' + type + ')" style="width: 25%; height: 100%; border-top: 1px solid gray;' + css + ' ">';
    list_code += '<image src="' + '<c:url value="/' + src + '" />" style="width: 50px; height: 50px; filter: drop-shadow(7px 7px 7px #000); " />';
    list_code += '<input type="hidden" id="title_id' + type + '" value="' + title + '" />';
    list_code += '</li>';

    $('#tab_list').append(list_code);
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_tab1();
    setValues_tab2(today);
    setValues_tab3(today);
    setValues_tab4(today);
}

function setValues_tab1() {
    gridnms["models.tab1"] = [];
    gridnms["stores.tab1"] = [];
    gridnms["views.tab1"] = [];
    gridnms["controllers.tab1"] = [];

    gridnms["grid.1"] = "EisTab1MonthlyList";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.tab1"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.tab1"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

    gridnms["models.tab1"].push(gridnms["model.1"]);

    gridnms["stores.tab1"].push(gridnms["store.1"]);

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
            locked: true,
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
            columns: [{
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
                        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value, '0,000') + "</div>";
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
                        return Ext.util.Format.number(value, '0,000');
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
        if (i + 1 > 9)
            month = i + 1;
        else
            month = '0' + (i + 1);
        fields["columns.1"].push({
            text: (i + 1) + '월',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            columns: [{
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
                        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(value, '0,000') + "</div>";
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
                        return Ext.util.Format.number(value, '0,000');
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

function setValues_tab2(d) {
    gridnms["models.tab2"] = [];
    gridnms["stores.tab2"] = [];
    gridnms["views.tab2"] = [];
    gridnms["controllers.tab2"] = [];

    gridnms["grid.2"] = "EisTab2MonthlyList";

    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
    gridnms["views.tab2"].push(gridnms["panel.2"]);

    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
    gridnms["controllers.tab2"].push(gridnms["controller.2"]);

    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

    gridnms["models.tab2"].push(gridnms["model.2"]);

    gridnms["stores.tab2"].push(gridnms["store.2"]);

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
            name: 'GUBUN1',
        }, {
            type: 'string',
            name: 'GUBUN1NAME',
        }, {
            type: 'string',
            name: 'GUBUN2',
        }, {
            type: 'string',
            name: 'GUBUN2NAME',
        }, {
            type: 'string',
            name: 'PRE2AMOUNT', //재작년 Total
        }, {
            type: 'string',
            name: 'PREAMOUNT', //전년도 Total
        }, {
            type: 'string',
            name: 'MON01',
        }, {
            type: 'string',
            name: 'MON02',
        }, {
            type: 'string',
            name: 'MON03',
        }, {
            type: 'string',
            name: 'MON04',
        }, {
            type: 'string',
            name: 'MON05',
        }, {
            type: 'string',
            name: 'MON06',
        }, {
            type: 'string',
            name: 'MON07',
        }, {
            type: 'string',
            name: 'MON08',
        }, {
            type: 'string',
            name: 'MON09',
        }, {
            type: 'string',
            name: 'MON10',
        }, {
            type: 'string',
            name: 'MON11',
        }, {
            type: 'string',
            name: 'MON12',
        }, {
            type: 'string',
            name: 'TOTAL', //해당년
        }, ];

    fields["columns.2"] = [
        // Display Columns
        {
            dataIndex: 'GUBUN1NAME',
            text: '',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            locked: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                switch (record.data.GUBUN1) {
                case "01":
                case "02":
                case "03":
                case "04":
                case "05":
                case "06":
                    if (record.data.GUBUN2 == "1") {
                        meta.style = " font-weight: bold; ";
                    } else {
                        meta.style = " border-bottom: 1px groove black; ";
                    }
                    break;
                case "99":
                    // 합계
                    meta.style = " font-weight: bold; ";
                    meta.style += " background-color: rgb(178, 204, 255); ";
                    meta.style += " color: black; ";

                    if (record.data.GUBUN2 == 1) {
                        //
                    } else {
                        meta.style += " border-bottom: 2px groove black; ";
                    }
                    break;
                default:
                    break;
                }
                return value;
            },
        }, {
            dataIndex: 'GUBUN2NAME',
            text: '구분',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            locked: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                switch (record.data.GUBUN1) {
                case "01":
                case "02":
                case "03":
                case "04":
                case "05":
                case "06":
                    if (record.data.GUBUN2 == "1") {
                        //
                    } else {
                        meta.style = " border-bottom: 1px groove black; ";
                    }
                    break;
                case "99":
                    // 합계
                    meta.style = " background-color: rgb(178, 204, 255); ";
                    meta.style += " color: black; ";
                    if (record.data.GUBUN2 == "1") {
                        //
                    } else {
                        meta.style += " border-bottom: 2px groove black; ";
                    }
                    break;
                default:
                    break;
                }
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
        }, ];

    for (var y = 2; y > 0; y--) {
        (function (x) {
            var rn = x;
            var searchyear = Ext.util.Format.date(today, 'Y');
            var year = searchyear - rn;
            var column_text = year + "";
            fields["columns.2"].push({
                dataIndex: 'PRE' + ((rn == 2) ? rn : "") + "AMOUNT",
                text: column_text,
                xtype: 'gridcolumn',
                width: 100,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ',
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                renderer: function (value, meta, record) {
                    switch (record.data.GUBUN1) {
                    case "01":
                    case "02":
                    case "03":
                    case "04":
                    case "05":
                    case "06":
                        if (record.data.GUBUN2 == "1") {
                            //
                        } else {
                            meta.style = " border-bottom: 1px groove black; ";
                        }
                        break;
                    case "99":
                        // 합계
                        meta.style = " background-color: rgb(178, 204, 255); ";
                        meta.style += " color: black; ";
                        if (record.data.GUBUN2 == "1") {
                            //
                        } else {
                            meta.style += " border-bottom: 2px groove black; ";
                        }
                        break;
                    default:
                        break;
                    }
                    return Ext.util.Format.number(value, '0,000');
                },
            });

        })(y);
    }

    var searchyear = Ext.util.Format.date(today, 'Y');
    fields["columns.2"].push({
        dataIndex: 'TOTAL',
        text: searchyear,
        xtype: 'gridcolumn',
        width: 110,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "right",
        cls: 'ERPQTY',
        format: "0,000",
        renderer: function (value, meta, record) {
            switch (record.data.GUBUN1) {
            case "01":
            case "02":
            case "03":
            case "04":
            case "05":
            case "06":
                if (record.data.GUBUN2 == "1") {
                    //
                } else {
                    meta.style = " border-bottom: 1px groove black; ";
                }
                break;
            case "99":
                // 합계
                meta.style = " background-color: rgb(178, 204, 255); ";
                meta.style += " color: black; ";
                if (record.data.GUBUN2 == "1") {
                    //
                } else {
                    meta.style += " border-bottom: 2px groove black; ";
                }
                break;
            default:
                break;
            }
            return Ext.util.Format.number(value, '0,000');
        },
    });

    var grid_count = 12;
    for (var i = 0; i < grid_count; i++) {
        (function (x) {
            var rn = (x + 1) + "";
            var qty_index = fn_lpad(rn, 2, '0');
            var column_text = qty_index + "월";
            fields["columns.2"].push({
                dataIndex: 'MON' + qty_index,
                text: column_text,
                xtype: 'gridcolumn',
                width: 90,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ',
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                renderer: function (value, meta, record) {
                    switch (record.data.GUBUN1) {
                    case "01":
                    case "02":
                    case "03":
                    case "04":
                    case "05":
                    case "06":
                        if (record.data.GUBUN2 == "1") {
                            //
                        } else {
                            meta.style += " border-bottom: 1px groove black; ";
                        }
                        break;
                    case "99":
                        // 합계
                        meta.style = " background-color: rgb(178, 204, 255); ";
                        meta.style += " color: black; ";
                        if (record.data.GUBUN2 == "1") {
                            //
                        } else {
                            meta.style += " border-bottom: 2px groove black; ";
                        }
                        break;
                    default:
                        break;
                    }
                    return Ext.util.Format.number(value, '0,000');
                },
            });

        })(i);
    }

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/eis/EisItemPurSummary.do' />"
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

function setValues_tab3(d) {
    gridnms["models.tab3"] = [];
    gridnms["stores.tab3"] = [];
    gridnms["views.tab3"] = [];
    gridnms["controllers.tab3"] = [];

    gridnms["grid.3"] = "EisTab3MonthlyList";

    gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
    gridnms["views.tab3"].push(gridnms["panel.3"]);

    gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
    gridnms["controllers.tab3"].push(gridnms["controller.3"]);

    gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

    gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

    gridnms["models.tab3"].push(gridnms["model.3"]);

    gridnms["stores.tab3"].push(gridnms["store.3"]);

    fields["model.3"] = [{
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
            name: 'STANDARDMONTH',
        }, {
            type: 'number',
            name: 'LABEL101',
        }, {
            type: 'number',
            name: 'LABEL102',
        }, {
            type: 'number',
            name: 'LABEL103',
        }, {
            type: 'number',
            name: 'LABEL104',
        }, {
            type: 'number',
            name: 'LABEL105',
        }, {
            type: 'number',
            name: 'LABEL201',
        }, {
            type: 'number',
            name: 'LABEL202',
        }, {
            type: 'number',
            name: 'LABEL203',
        }, {
            type: 'number',
            name: 'LABEL204',
        }, {
            type: 'number',
            name: 'LABEL205',
        }, {
            type: 'number',
            name: 'LABEL301',
        }, {
            type: 'number',
            name: 'LABEL302',
        }, {
            type: 'number',
            name: 'LABEL303',
        }, {
            type: 'number',
            name: 'LABEL304',
        }, {
            type: 'number',
            name: 'LABEL305',
        }, ];

    fields["columns.3"] = [
        // Display Columns
        {
            dataIndex: 'STANDARDMONTH',
            text: '구분',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            locked: true,
            style: 'text-align:center;',
            align: "center",
            summaryRenderer: function (value, meta, record) {
                var header = "TOTAL";
                return [header].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: center; font-size: 15px; color: red; '>" + val + '</div>';
                }).join('<br />');
            },
            renderer: function (value, meta, record) {
                meta.style += " font-weight: bold; ";
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
        }, ];

    fields["columns-routinggroup.3"] = [];

    var limit_leng = 3;
    var label_leng = (searchLabel.options.length < (limit_leng + 1)) ? searchLabel.options.length : limit_leng;
    var x = 0;
    var g = 0;
    for (; x < label_leng; x++) {
        var label = searchLabel.options[x].text;
        var value = searchLabel.options[x].value;
        var rn = (x + 1);

        var group_leng = $('#searchRoutingGroup' + rn)[0].length;
        g = 0;
        for (; g < group_leng; g++) {
            (function (y) {
                var text = $('#searchRoutingGroup' + (x + 1))[0][y].text;
                var rn1 = fn_lpad((y + 1) + "", 2, '0');

                fields["columns-routinggroup.3"].push({
                    dataIndex: 'LABEL' + (x + 1) + rn1,
                    text: text,
                    xtype: 'gridcolumn',
                    width: 90,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    lockable: false,
                    style: 'text-align:center',
                    align: "right",
                    cls: 'ERPQTY',
                    summaryType: 'sum',
                    summaryRenderer: function (value, summaryData, dataIndex) {
                        var data = Ext.getStore(gridnms["store.3"]).getData().items;

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
            })(g);
        }
        fields["columns.3"].push({
            dataIndex: 'XXXXXXLABEL' + rn,
            text: label,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            columns: fields["columns-routinggroup.3"],
        });
        fields["columns-routinggroup.3"] = [];
    }

    items["api.3"] = {};
    $.extend(items["api.3"], {
        read: "<c:url value='/select/eis/mobile/tab3/searchMonthlyList.do' />"
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

function setValues_tab4(d) {

    gridnms["models.tab4"] = [];
    gridnms["stores.tab4"] = [];
    gridnms["views.tab4"] = [];
    gridnms["controllers.tab4"] = [];

    gridnms["grid.4"] = "EisTab4MonthlyList";

    gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
    gridnms["views.tab4"].push(gridnms["panel.4"]);

    gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
    gridnms["controllers.tab4"].push(gridnms["controller.4"]);

    gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];

    gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];

    gridnms["models.tab4"].push(gridnms["model.4"]);

    gridnms["stores.tab4"].push(gridnms["store.4"]);

    fields["model.4"] = [{
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
            name: 'ITEMNAME',
        }, {
            type: 'number',
            name: 'NCR01',
        }, {
            type: 'number',
            name: 'NCR02',
        }, {
            type: 'number',
            name: 'NCR03',
        }, {
            type: 'number',
            name: 'NCR04',
        }, {
            type: 'number',
            name: 'NCR05',
        }, {
            type: 'number',
            name: 'NCR06',
        }, {
            type: 'number',
            name: 'NCR07',
        }, {
            type: 'number',
            name: 'NCR08',
        }, {
            type: 'number',
            name: 'NCR09',
        }, {
            type: 'number',
            name: 'NCR10',
        }, {
            type: 'number',
            name: 'NCR11',
        }, {
            type: 'number',
            name: 'NCR12',
        }, {
            type: 'number',
            name: 'NCR13',
        }, {
            type: 'number',
            name: 'NCR14',
        }, {
            type: 'number',
            name: 'NCR15',
        }, {
            type: 'number',
            name: 'NCR16',
        }, {
            type: 'number',
            name: 'NCR17',
        }, {
            type: 'number',
            name: 'NCR18',
        }, {
            type: 'number',
            name: 'NCR19',
        }, {
            type: 'number',
            name: 'NCR20',
        }, {
            type: 'number',
            name: 'NCR21',
        }, {
            type: 'number',
            name: 'NCR22',
        }, {
            type: 'number',
            name: 'NCR23',
        }, {
            type: 'number',
            name: 'NCR24',
        }, {
            type: 'number',
            name: 'NCR25',
        }, ];

    fields["columns.4"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'gridcolumn',
            width: 55,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center; ',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
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
            dataIndex: 'CUSTOMERNAME',
            text: '고객사',
            xtype: 'gridcolumn',
            width: 180,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center; ',
            align: "center",
            summaryRenderer: function (value, meta, record) {
                //          value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>총합계<br/><br/>불량율</div>";
                //          return value;
                return ['총합계', '불량율 (%)'].map(function (val) {
                    return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + val + '</div>';
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
        }, {
            dataIndex: 'NCRQTY',
            xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR01',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR02',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR03',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR04',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR05',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR06',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR07',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR08',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR09',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR10',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR11',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR12',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR13',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR14',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR15',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR16',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR17',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR18',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR19',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR20',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR21',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR22',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR23',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR24',
            //        xtype: 'hidden',
            //      }, {
            //        dataIndex: 'NCR25',
            //        xtype: 'hidden',
        },
    ];

    fields["columns-ncr.4"] = [];
    fields["columns.4"].push({
        dataIndex: 'XXXXXXXXXX',
        text: "불량유형",
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        lockable: false,
        style: 'text-align:center; ',
        columns: fields["columns-ncr.4"],
    });

    var ncrcount = occurdata.label.length;
    for (var i = 0; i < ncrcount; i++) {

        (function (x) {
            fields["columns-ncr.4"].push({
                dataIndex: 'NCR' + occurdata.value[x].substring(2),
                text: occurdata.label[x].replace(/ /gi, "<br/>"),
                xtype: 'gridcolumn',
                width: 75,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; font-size: 8pt !important;',
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                summaryType: 'sum',
                summaryRenderer: function (value, summaryData, dataIndex) {
                    var data = Ext.getStore(gridnms["store.4"]).getData().items;
                    var values = extExtractValues(data, dataIndex);
                    var total = value;

                    // 전체합계
                    var ncrqty = 0;
                    for (var l = 0; l < extExtractValues(data, "NCRQTY").length; l++) {
                        ncrqty += extExtractValues(data, "NCRQTY")[l];
                    }

                    // 불량율 = 불량유형 합계 / 전체합계 백분율
                    var rate = (ncrqty == 0) ? 0 : Math.round(((total / ncrqty) * 100));
                    var result = [total, rate].map(function (val) {
                        return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(val, '0,000') + '</div>';
                    }).join('<br />');
                    return result;
                },
                renderer: Ext.util.Format.numberRenderer('0,000'),
            });
        })(i);
    }

    fields["columns.4"].push({
        dataIndex: 'REMARKS',
        text: "비고",
        xtype: 'gridcolumn',
        width: 160,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center',
        align: "left",
    });

    items["api.4"] = {};
    $.extend(items["api.4"], {
        read: "<c:url value='/select/prod/insp/ProdIncTotalList.do' />"
    });

    items["btns.4"] = [];

    items["btns.ctr.4"] = {};

    items["dock.paging.4"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.4"],
    };

    items["dock.btn.4"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.4"],
        items: items["btns.4"],
    };

    items["docked.4"] = [];
}

var tab1_gridarea, tab2_gridarea1, tab3_gridarea1, tab4_gridarea1;
function setExtGrid() {
    setExtGrid_tab1();
    setExtGrid_tab2();
    setExtGrid_tab3();
    setExtGrid_tab4();

    Ext.EventManager.onWindowResize(function (w, h) {
        switch (global_tab_index) {
        case 1:
            tab1_gridarea.updateLayout();
            break;
        case 2:
            tab2_gridarea1.updateLayout();
            break;
        case 3:
            tab3_gridarea1.updateLayout();
            break;
        case 4:
            tab4_gridarea1.updateLayout();
            break;
        default:
            break;
        }
    });
}

function setExtGrid_tab1() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"],
    });

    Ext.define(gridnms["store.1"], {
        extend: Ext.data.JsonStore,
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
                            extraParams: {
                                SEARCHYEAR: Ext.util.Format.date(today, 'Y'),
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
            MobileTab1List: '#MobileTab1List',
        },
        stores: [gridnms["store.1"]],
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
                width: 'auto',
                monitorResize: true,
                autoWidth: true,
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
                    itemId: 'MobileTab1List',
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
        models: gridnms["models.tab1"],
        stores: gridnms["stores.tab1"],
        views: gridnms["views.tab1"],
        controllers: gridnms["controller.1"],

        launch: function () {
            tab1_gridarea = Ext.create(gridnms["views.tab1"], {
                renderTo: 'Tab1GridArea'
            });
        },
    });
}

function setExtGrid_tab2() {

    Ext.define(gridnms["model.2"], {
        extend: Ext.data.Model,
        fields: fields["model.2"],
    });

    Ext.define(gridnms["store.2"], {
        extend: Ext.data.JsonStore,
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
                            extraParams: {
                                SEARCHYEAR: Ext.util.Format.date(today, 'Y'),
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
            MobileTab2List: '#MobileTab2List',
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
                height: 450,
                width: 'auto',
                monitorResize: true,
                autoWidth: true,
                border: 2,
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
                    itemId: 'MobileTab2List',
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
        models: gridnms["models.tab2"],
        stores: gridnms["stores.tab2"],
        views: gridnms["views.tab2"],
        controllers: gridnms["controller.2"],

        launch: function () {
            tab2_gridarea1 = Ext.create(gridnms["views.tab2"], {
                renderTo: 'Tab2GridArea'
            });
        },
    });
}

function setExtGrid_tab3() {
    Ext.define(gridnms["model.3"], {
        extend: Ext.data.Model,
        fields: fields["model.3"],
    });

    Ext.define(gridnms["store.3"], {
        extend: Ext.data.JsonStore,
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
                            extraParams: {
                                SEARCHYEAR: Ext.util.Format.date(today, 'Y'),
                            },
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
            MobileTab3List: '#MobileTab3List',
        },
        stores: [gridnms["store.3"]],
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
                height: 415,
                width: 'auto',
                monitorResize: true,
                autoWidth: true,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'bottom'
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
                    itemId: 'MobileTab3List',
                    striptRows: true,
                    forceFit: true,
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
        models: gridnms["models.tab3"],
        stores: gridnms["stores.tab3"],
        views: gridnms["views.tab3"],
        controllers: gridnms["controller.3"],

        launch: function () {
            tab3_gridarea = Ext.create(gridnms["views.tab3"], {
                renderTo: 'Tab3GridArea'
            });
        },
    });
}

function setExtGrid_tab4() {
    Ext.define(gridnms["model.4"], {
        extend: Ext.data.Model,
        fields: fields["model.4"],
    });

    Ext.define(gridnms["store.4"], {
        extend: Ext.data.JsonStore,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.4"],
                        model: gridnms["model.4"],
                        autoLoad: true,
                        isStore: false,
                        autoDestroy: true,
                        clearOnPageLoad: true,
                        clearRemovedOnLoad: true,
                        pageSize: 9999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.4"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                SEARCHMONTH: Ext.util.Format.date(today, 'Y-m'),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.4"], {
        extend: Ext.app.Controller,
        refs: {
            MobileTab4List: '#MobileTab4List',
        },
        stores: [gridnms["store.4"]],
        control: items["btns.ctr.4"],

    });

    Ext.define(gridnms["panel.4"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.4"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'rowmodel',
                itemId: gridnms["panel.4"],
                id: gridnms["panel.4"],
                store: gridnms["store.4"],
                height: 348,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'bottom'
                    }
                ],
                scrollable: true,
                columns: fields["columns.4"],
                defaults: gridVals.defaultField,
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20,
                        leadingBufferZone: 20,
                        synchronousRender: false,
                        numFromEdge: 19,
                    },
                ],
                viewConfig: {
                    itemId: 'MobileTab4List',

                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.4"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.tab4"],
        stores: gridnms["stores.tab4"],
        views: gridnms["views.tab4"],
        controllers: gridnms["controller.4"],

        launch: function () {
            tab4_gridarea = Ext.create(gridnms["views.tab4"], {
                renderTo: 'Tab4GridArea'
            });
        },
    });
}

function fn_search() {
    var year_c = Ext.util.Format.date(today, 'Y');
    fn_chart_search();

    var params = {
        SEARCHYEAR: year_c,
    };
    switch (global_tab_index) {
    case 1:
        // 매출
        extGridSearch(params, gridnms["store.1"]);

        break;
    case 2:
        // 매입
        setValues_tab2(today);
        Ext.suspendLayouts();
        Ext.getCmp(gridnms["panel.2"]).reconfigure(gridnms["store.2"], fields["columns.2"]);
        Ext.resumeLayouts(true);
        extGridSearch(params, gridnms["store.2"]);

        break;
    case 3:
        // 생산
        setValues_tab3(today);
        Ext.suspendLayouts();
        Ext.getCmp(gridnms["panel.3"]).reconfigure(gridnms["store.3"], fields["columns.3"]);
        Ext.resumeLayouts(true);
        extGridSearch(params, gridnms["store.3"]);

        break;
    case 4:
        // 품질
        var params4 = {
            SEARCHMONTH: Ext.util.Format.date(today, 'Y-m'),
        };
        setValues_tab4(today);
        Ext.suspendLayouts();
        Ext.getCmp(gridnms["panel.4"]).reconfigure(gridnms["store.4"], fields["columns.4"]);
        Ext.resumeLayouts(true);
        extGridSearch(params4, gridnms["store.4"]);

        break;
    default:
        break;
    }
}

var tab1_c_data_y1 = "", tab1_c_data_m1 = "";
var tab2_c_data = "";
var tab3_c_data = "";
var tab4_c_data = "";
// 차트 데이터 Set
var tab2_header = ["월", "계획", "실적"];
var tab2_row1 = "", tab2_msg1 = "", tab2_check1 = false;
var tab2_row2 = "", tab2_msg2 = "", tab2_check2 = false;
var tab2_row3 = "", tab2_msg3 = "", tab2_check3 = false;

var tab3_header1 = ["월", "실적"];
var tab3_header2 = ["월", "실적"];
var tab3_header3 = ["월", "실적"];
var tab3_msg = "", tab3_check = false;

var tab4_header1 = ["불량유형", "수량"];
var tab4_header2 = ["불량유형", "불량율"];
var tab4_row1 = "", tab4_msg1 = "", tab4_check1 = false;
var tab4_row2 = "", tab4_msg2 = "", tab4_check2 = false;
var today = new Date();
function fn_chart_search() {
    var year_c = Ext.util.Format.date(today, 'Y');
    var params = {
        SEARCHYEAR: year_c,
    };

    switch (global_tab_index) {
    case 1:
        // 매출
        var tab1_url_y1 = '<c:url value="/select/eis/mobile/tab1/searchYearChart.do" />';
        $.ajax({
            url: tab1_url_y1,
            type: "post",
            dataType: "json",
            async: false,
            data: params,
            success: function (data) {
                var rows = [];
                rows.push(['년', '금액', '수량']);
                var count = data.totcnt;
                for (var i = 0; i < count; i++) {
                    var record = data.data[i];
                    rows.push([record.SEARCHYEAR, record.AMOUNT, record.QTY]);
                }
                tab1_c_data_y1 = google.visualization.arrayToDataTable(rows);

                tab1drawChart_y1(tab1_c_data_y1);
            },
            error: ajaxError
        });

        var tab1_url_m1 = '<c:url value="/select/eis/mobile/tab1/searchMonthlyChart.do" />';
        $.ajax({
            url: tab1_url_m1,
            type: "post",
            dataType: "json",
            async: false,
            data: params,
            success: function (data) {
                var rows = [];
                rows.push(['월', '금액', '수량']);
                var count = data.totcnt;
                for (var i = 0; i < count; i++) {
                    var record = data.data[i];
                    rows.push([record.SEARCHYEAR, record.AMOUNT, record.QTY]);
                }
                if (count == 0) {
                    var month = '0';
                    for (var i = 0; i < 12; i++) {
                        if (i > 8) {
                            month = i + 1;
                        } else {
                            month = '0' + (i + 1);
                        }
                        rows.push([month + '월', 0, 0]);
                    }
                }
                tab1_c_data_m1 = google.visualization.arrayToDataTable(rows);

                tab1drawChart_m1(tab1_c_data_m1);
            },
            error: ajaxError
        });
        break;
    case 2:
        // 매입
        var tab2_url1 = '<c:url value="/select/eis/EisItemPurSummaryChart.do?GUBUN=01" />';
        $.ajax({
            url: tab2_url1,
            type: "post",
            dataType: "json",
            async: false,
            data: params,
            success: function (data) {
                var rows = new Array();
                if (data.totcnt == 0) {
                    tab2_msg1 = "이번 달에 등록된<br/>데이터가 없습니다.";
                    tab2_check1 = false;

                    setTab2DummyChart(tab2_header, 1);
                } else {
                    tab2_msg1 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                    tab2_check1 = true;

                    var rows = new Array();
                    for (var i = 0; i < data.totcnt; i++) {
                        tab2_row1 = [data.data[i].STANDARDMONTH, data.data[i].PLANAMOUNT, data.data[i].RESULTAMOUNT];
                        rows.push(tab2_row1);
                    }

                    var jsonData = [tab2_header].concat(rows);
                    tab2_c_data = google.visualization.arrayToDataTable(jsonData);

                    // 차트 호출
                    tab2drawChart(tab2_c_data, 1);
                }

                if (!tab2_check1) {
                    extToastView(tab2_msg1);
                    return;
                }
            },
            error: ajaxError
        });

        var tab2_url2 = '<c:url value="/select/eis/EisItemPurSummaryChart.do?GUBUN=02" />';
        $.ajax({
            url: tab2_url2,
            type: "post",
            dataType: "json",
            async: false,
            data: params,
            success: function (data) {
                var rows = new Array();
                if (data.totcnt == 0) {
                    tab2_msg2 = "이번 달에 등록된<br/>데이터가 없습니다.";
                    tab2_check2 = false;

                    setTab2DummyChart(tab2_header, 2);
                } else {
                    tab2_msg2 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                    tab2_check2 = true;

                    var rows = new Array();
                    for (var i = 0; i < data.totcnt; i++) {
                        tab2_row2 = [data.data[i].STANDARDMONTH, data.data[i].PLANAMOUNT, data.data[i].RESULTAMOUNT];
                        rows.push(tab2_row2);
                    }

                    var jsonData = [tab2_header].concat(rows);
                    tab2_c_data = google.visualization.arrayToDataTable(jsonData);

                    // 차트 호출
                    tab2drawChart(tab2_c_data, 2);
                }

                if (!tab2_check2) {
                    extToastView(tab2_msg2);
                    return;
                }
            },
            error: ajaxError
        });

        var tab2_url3 = '<c:url value="/select/eis/EisItemPurSummaryChart.do?GUBUN=03" />';
        $.ajax({
            url: tab2_url3,
            type: "post",
            dataType: "json",
            async: false,
            data: params,
            success: function (data) {
                var rows = new Array();
                if (data.totcnt == 0) {
                    tab2_msg3 = "이번 달에 등록된<br/>데이터가 없습니다.";
                    tab2_check3 = false;

                    setTab2DummyChart(tab2_header, 3);
                } else {
                    tab2_msg3 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                    tab2_check3 = true;

                    var rows = new Array();
                    for (var i = 0; i < data.totcnt; i++) {
                        tab2_row3 = [data.data[i].STANDARDMONTH, data.data[i].PLANAMOUNT, data.data[i].RESULTAMOUNT];
                        rows.push(tab2_row3);
                    }

                    var jsonData = [tab2_header].concat(rows);
                    tab2_c_data = google.visualization.arrayToDataTable(jsonData);

                    // 차트 호출
                    tab2drawChart(tab2_c_data, 3);
                }

                if (!tab2_check3) {
                    extToastView(tab2_msg3);
                    return;
                }
            },
            error: ajaxError
        });

        break;
    case 3:
        // 생산
        var limit_leng = 3;
        var label_leng = (searchLabel.options.length < (limit_leng + 1)) ? searchLabel.options.length : limit_leng;
        for (var x = 0; x < label_leng; x++) {
            var label = searchLabel.options[x].text;
            var rn = (x + 1);
            $('#tab3SubTitle' + rn).text(label);

            var value = searchLabel.options[x].value;
            var attr1 = (value == "01") ? value : "02";
            fn_option_change_r1('MFG', 'WORK_GROUP', attr1, 'searchRoutingGroup' + rn);

            var tab3_c_leng = $('#searchRoutingGroup' + rn)[0].length;
            switch (rn) {
            case 1:
                tab3_header1 = new Array();
                tab3_header1.push("월");
                for (var g = 0; g < tab3_c_leng; g++) {
                    var text = $('#searchRoutingGroup' + rn)[0][g].text;
                    tab3_header1.push(text);
                }
                break;
            case 2:
                tab3_header2 = new Array();
                tab3_header2.push("월");
                for (var g = 0; g < tab3_c_leng; g++) {
                    var text = $('#searchRoutingGroup' + rn)[0][g].text;
                    tab3_header2.push(text);
                }
                break;
            case 3:
                tab3_header3 = new Array();
                tab3_header3.push("월");
                for (var g = 0; g < tab3_c_leng; g++) {
                    var text = $('#searchRoutingGroup' + rn)[0][g].text;
                    tab3_header3.push(text);
                }
                break;
            default:
                break;
            }

            var tab3_url1 = '<c:url value="/select/eis/mobile/tab3/searchMonthlyChart.do?SEARCHLABEL=" />' + value;
            $.ajax({
                url: tab3_url1,
                type: "post",
                dataType: "json",
                async: false,
                data: params,
                success: function (data) {
                    var rows = new Array();
                    if (data.totcnt == 0) {
                        tab3_msg = "이번 달에 등록된<br/>데이터가 없습니다.";
                        tab3_check = false;

                        switch (rn) {
                        case 1:
                            setTab3DummyChart(tab3_header1, rn);
                            break;
                        case 2:
                            setTab3DummyChart(tab3_header2, rn);
                            break;
                        case 3:
                            setTab3DummyChart(tab3_header3, rn);
                            break;
                        default:
                            break;
                        }

                    } else {
                        tab3_msg = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                        tab3_check = true;

                        var rows = new Array();
                        for (var i = 0; i < data.totcnt; i++) {
                            var arr = new Array();
                            arr.push(data.data[i].STANDARDMONTH);

                            switch (tab3_c_leng) {
                            case 1:
                                arr.push(data.data[i].QTY01);
                                break;
                            case 2:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                break;
                            case 3:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                arr.push(data.data[i].QTY03);
                                break;
                            case 4:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                arr.push(data.data[i].QTY03);
                                arr.push(data.data[i].QTY04);
                                break;
                            case 5:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                arr.push(data.data[i].QTY03);
                                arr.push(data.data[i].QTY04);
                                arr.push(data.data[i].QTY05);
                                break;
                            case 6:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                arr.push(data.data[i].QTY03);
                                arr.push(data.data[i].QTY04);
                                arr.push(data.data[i].QTY05);
                                arr.push(data.data[i].QTY06);
                                break;
                            case 7:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                arr.push(data.data[i].QTY03);
                                arr.push(data.data[i].QTY04);
                                arr.push(data.data[i].QTY05);
                                arr.push(data.data[i].QTY06);
                                arr.push(data.data[i].QTY07);
                                break;
                            case 8:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                arr.push(data.data[i].QTY03);
                                arr.push(data.data[i].QTY04);
                                arr.push(data.data[i].QTY05);
                                arr.push(data.data[i].QTY06);
                                arr.push(data.data[i].QTY07);
                                arr.push(data.data[i].QTY08);
                                break;
                            case 9:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                arr.push(data.data[i].QTY03);
                                arr.push(data.data[i].QTY04);
                                arr.push(data.data[i].QTY05);
                                arr.push(data.data[i].QTY06);
                                arr.push(data.data[i].QTY07);
                                arr.push(data.data[i].QTY08);
                                arr.push(data.data[i].QTY09);
                                break;
                            case 10:
                                arr.push(data.data[i].QTY01);
                                arr.push(data.data[i].QTY02);
                                arr.push(data.data[i].QTY03);
                                arr.push(data.data[i].QTY04);
                                arr.push(data.data[i].QTY05);
                                arr.push(data.data[i].QTY06);
                                arr.push(data.data[i].QTY07);
                                arr.push(data.data[i].QTY08);
                                arr.push(data.data[i].QTY09);
                                arr.push(data.data[i].QTY10);
                                break;
                            default:
                                break;
                            }
                            rows.push(arr);
                        }

                        switch (rn) {
                        case 1:
                            var jsonData = [tab3_header1].concat(rows);
                            tab3_c_data = google.visualization.arrayToDataTable(jsonData);
                            break;
                        case 2:
                            var jsonData = [tab3_header2].concat(rows);
                            tab3_c_data = google.visualization.arrayToDataTable(jsonData);
                            break;
                        case 3:
                            var jsonData = [tab3_header3].concat(rows);
                            tab3_c_data = google.visualization.arrayToDataTable(jsonData);
                            break;
                        default:
                            break;
                        }

                        // 차트 호출
                        tab3drawChart(tab3_c_data, rn);
                    }

                    if (!tab3_check) {
                        extToastView(tab3_msg);
                        return;
                    }
                },
                error: ajaxError
            });
        }

        break;
    case 4:
        // 품질
        var params4 = {
            SEARCHMONTH: Ext.util.Format.date(today, 'Y-m'),
        };

        var tab4_url1 = '<c:url value="/select/prod/insp/ProdIncTotalChart.do" />';
        $.ajax({
            url: tab4_url1,
            type: "post",
            dataType: "json",
            async: false,
            data: params4,
            success: function (data) {
                var rows = new Array();
                if (data.totcnt == 0) {
                    tab4_msg1 = "이번 달에 등록된<br/>불량 데이터가 없습니다.";
                    tab4_check1 = false;

                    setTab4DummyChart(tab4_header1, 1);
                } else {
                    tab4_msg1 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                    tab4_check1 = true;

                    var rows = new Array();
                    for (var i = 0; i < data.totcnt; i++) {
                        tab4_row1 = [data.data[i].LABEL, data.data[i].NCRQTY];
                        rows.push(tab4_row1);
                    }

                    var jsonData = [tab4_header1].concat(rows);
                    tab4_c_data = google.visualization.arrayToDataTable(jsonData);

                    // 차트 호출
                    tab4drawChart(tab4_c_data, 1);
                }

                if (!tab4_check1) {
                    extToastView(tab4_msg1);
                    return;
                }
            },
            error: ajaxError
        });

        var tab4_url2 = '<c:url value="/select/prod/insp/ProdIncTotalChart.do" />';
        $.ajax({
            url: tab4_url2,
            type: "post",
            dataType: "json",
            async: false,
            data: params4,
            success: function (data) {
                var rows = new Array();
                if (data.totcnt == 0) {
                    tab4_msg2 = "이번 달에 등록된<br/>불량 데이터가 없습니다.";
                    tab4_check2 = false;

                    setTab4DummyChart(tab4_header2, 2);
                } else {
                    tab4_msg2 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                    tab4_check2 = true;

                    var rows = new Array();
                    for (var i = 0; i < data.totcnt; i++) {
                        tab4_row2 = [data.data[i].LABEL, data.data[i].NCRQTY];
                        rows.push(tab4_row2);
                    }

                    var jsonData = [tab4_header2].concat(rows);
                    tab4_c_data = google.visualization.arrayToDataTable(jsonData);

                    // 차트 호출
                    tab4drawChart(tab4_c_data, 2);
                }

                if (!tab4_check2) {
                    extToastView(tab4_msg2);
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

function tab1drawChart_y1(v) {
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
            width: '70%',
            height: '80%',
            left: '18%',
            top: 15,
        },
        role: {
            opacity: 0.7,
        },
        hAxis: {
            format: 'decimal',
        },
        seriesType: "bars",
        series: {
            1: {
                type: 'line',
                targetAxisIndex: 1
            }
        },
        tooltip: {
            ignoreBounds: false,
            isHtml: false,
            showColorCode: true,
            text: 'both',
            trigger: 'focus',
        },
        dataOpacity: 1,
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var ychart = new google.visualization.ComboChart(document.getElementById('Tab1ChartAreaY1'));
    ychart.draw(view, options);
}

function tab1drawChart_m1(v) {
    var title_name = '월별 매출 실적';
    var view = new google.visualization.DataView(v);

    var options = {
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
            width: '70%',
            height: '80%',
            left: '18%',
            top: 15,
        },
        role: {
            opacity: 0.7,
        },
        hAxis: {
            format: 'decimal',
        },
        seriesType: "bars",
        series: {
            1: {
                type: 'line',
                targetAxisIndex: 1
            }
        },
        tooltip: {
            ignoreBounds: false,
            isHtml: false,
            showColorCode: true,
            text: 'both',
            trigger: 'focus',
        },
        dataOpacity: 1,
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var mchart = new google.visualization.ComboChart(document.getElementById('Tab1ChartAreaM1'));
    mchart.draw(view, options);
}

function setTab2DummyChart(header, num) {
    var rows = new Array();
    var row = "";
    // Dummy 데이터 Set
    var count = 12;
    for (var i = 0; i < count; i++) {
        var rn = (i + 1) + "";
        var col_index = fn_lpad(rn, 2, '0');
        var col_name = col_index + "월";
        row = [col_name, 0, 0];
        rows.push(row);
    }

    var jsonData = [header].concat(rows);
    tab2_c_data = google.visualization.arrayToDataTable(jsonData);

    tab2drawChart(tab2_c_data, num);
}

function tab2drawChart(v, i) {
    var title_name,
    color,
    chartArea;
    switch (i) {
    case 1:
        title_name = '◎ 원소재';
        color = '#BD0000'; //red
        chartArea = 'Tab2ChartArea1';
        break;
    case 2:
        title_name = '◎ 외주가공';
        color = '#00BD00'; //green
        chartArea = 'Tab2ChartArea2';
        break;
    case 3:
        title_name = '◎ 열처리';
        color = '#0000BD'; //blue
        chartArea = 'Tab2ChartArea3';
        break;
    default:
        title_name = '';
        color = '#000000';
        chartArea = '';
        break;
    }
    var view = new google.visualization.DataView(v);

    var options = {
        width: '100%',
        height: '100%',
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        bar: {
            groupWidth: '80%'
        },
        titlePosition: 'out',
        titleTextStyle: {
            color: "black",
            fontName: 'Malgun Gothic',
            fontSize: 14,
            bold: true,
            italic: false
        },
        legend: {
            position: 'bottom',
            alignment: 'center',
        },
        crosshair: {
            trigger: 'both'
        },
        chartArea: {
            width: '85%',
            height: '75%',
            left: '10%',
            top: 10,
        },
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
                color: 'BDBDBD',
                visibleInLegend: true,
                pointShape: 'circle',
                pointSize: 5,
                lineWidth: 3,
            },
            1: {
                type: 'line',
                color: color,
                visibleInLegend: true,
                pointShape: 'diamond',
                pointSize: 10,
                lineWidth: 3,
            }
        },
        tooltip: {
            ignoreBounds: false,
            isHtml: false,
            showColorCode: true,
            text: 'both',
            trigger: 'focus',
        },
        dataOpacity: 1,
        curveType: 'none',
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var chart = new google.visualization.ComboChart(document.getElementById(chartArea));
    chart.draw(view, options);
}

function setTab3DummyChart(header, num) {
    var rows = new Array();
    // Dummy 데이터 Set
    var count = 12;
    for (var i = 0; i < count; i++) {
        var rn = (i + 1) + "";
        var col_index = fn_lpad(rn, 2, '0');
        var col_name = col_index + "월";
        var arr = new Array();
        arr.push(col_name);

        for (var l = 0; l < tab3_c_leng; l++) {
            arr.push(0);
        }
        rows.push(arr);
    }

    var jsonData = [header].concat(rows);
    tab3_c_data = google.visualization.arrayToDataTable(jsonData);

    tab3drawChart(tab3_c_data, num);
}

function tab3drawChart(v, i) {
    var title_name,
    color,
    chartArea;
    switch (i) {
    case 1:
        title_name = '◎ Cylinder block';
        chartArea = 'Tab3ChartArea1';
        break;
    case 2:
        title_name = '◎ Swash plate';
        chartArea = 'Tab3ChartArea2';
        break;
    case 3:
        title_name = '◎ Value Plate';
        chartArea = 'Tab3ChartArea3';
        break;
    default:
        title_name = '';
        color = '#000000';
        chartArea = '';
        break;
    }
    var view = new google.visualization.DataView(v);

    var options = {
        width: '100%',
        height: '100%',
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        bar: {
            groupWidth: '80%'
        },
        titlePosition: 'out',
        titleTextStyle: {
            color: "black",
            fontName: 'Malgun Gothic',
            fontSize: 14,
            bold: true,
            italic: false
        },
        legend: {
            position: 'bottom',
            alignment: 'center',
        },
        crosshair: {
            trigger: 'both'
        },
        chartArea: {
            width: '85%',
            height: '75%',
            left: '10%',
            top: 10,
        },
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
            text: 'both',
            trigger: 'focus',
        },
        dataOpacity: 1,
        curveType: 'none',
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var chart = new google.visualization.ComboChart(document.getElementById(chartArea));
    chart.draw(view, options);
}

function setTab4DummyChart(header, num) {
    var rows = new Array();
    // Dummy 데이터 Set

    var ncrcount = occurdata.label.length;
    for (var i = 0; i < ncrcount; i++) {
        row_t = [occurdata.label[i], 0];
        rows.push(row_t);
    }

    var jsonData = [header].concat(rows);
    tab4_c_data = google.visualization.arrayToDataTable(jsonData);

    tab4drawChart(tab4_c_data, num);
}

function tab4drawChart(v, i) {
    var title_name,
    color,
    chartArea;
    switch (i) {
    case 1:
        title_name = '◎ 불량수량';
        chartArea = 'Tab4ChartArea1';

        var options = {
            width: '100%',
            height: '100%',
            fontName: 'Malgun Gothic',
            focusTarget: 'category',
            bar: {
                groupWidth: '50%'
            },
            legend: {
                position: 'none'
            },
            crosshair: {
                trigger: 'both'
            },
            chartArea: {
                width: '85%',
                height: '75%',
                left: '10%',
                top: 10,
            },
            role: {
                opacity: 0.7,
            },
            hAxis: {
                format: 'none',
            },
            //             seriesType: "bars",
            series: {
                0: {
                    targetAxisIndex: 0,
                    type: "bar",
                    color: "blue"
                },
            },
            tooltip: {
                ignoreBounds: false,
                isHtml: false,
                showColorCode: true,
                text: 'both',
                trigger: 'focus',
            },
            dataOpacity: 1,
            curveType: 'none',
            animation: {
                duration: 2 * 1000,
                easing: 'out',
                startup: true,
            },
            allowHtml: true,
        };

        var chart = new google.visualization.ComboChart(document.getElementById(chartArea));
        break;
    case 2:
        title_name = '◎ 불량율';
        chartArea = 'Tab4ChartArea2';

        var options = {
            width: '100%',
            height: '100%',
            fontName: 'Malgun Gothic',
            focusTarget: 'category',
            is3D: true,
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
                width: '85%',
                height: '75%',
                left: '10%',
                top: 10,
            },
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
                text: 'both',
                trigger: 'focus',
            },
            dataOpacity: 1,
            curveType: 'none',
            animation: {
                duration: 2 * 1000,
                easing: 'out',
                startup: true,
            },
            allowHtml: true,
        };

        var chart = new google.visualization.PieChart(document.getElementById(chartArea));
        break;
    default:
        title_name = '';
        color = '#000000';
        chartArea = '';
        break;
    }
    var view = new google.visualization.DataView(v);

    chart.draw(view, options);
}

function fn_back() {
    go_url('<c:url value="/eis/mobile/EisMain.do" />');
}

function fn_ready() {
    extToastView("준비중입니다...");
}

function setLovList() {
    //
}

function setReadOnly() {
    $("[readonly]").addClass("ui-state-disabled");
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
				<input type="hidden" id="orgid" value="${searchVO.ORGID}" />
				<input type="hidden" id="companyid" value="${searchVO.COMPANYID}" />
				<div id="top_area" style="width: 100%; height: 60px; background-color: rgb(153, 204, 255); box-shadow: 2px 2px 5px gray; position: fixed; top: 0px; left: 0px; z-index: 9999;">
								<button type="button" class="mobile_back" id="btn_back" onclick="fn_back();" style="width: 50px; height: 100%; float: left; display: block; visibility: visibility:;"></button>
								<center id="pageTitle" style="width: calc(100% - 100px); height: 100%; font-size: 35px; line-height: 32px; font-weight: bold; margin-top: 13px; float: left; text-shadow: 2px 2px 5px gray;">${pageTitle}</center>
				</div>
				<div id="blank_area1" style="width: 100%; float: left;"></div>
				<div id="tab_area1" style="width: 100%; height: 100%; float: left;">
								<div class="subConMobile">년도별 매출실적</div>
								<div id="Tab1ChartAreaY1" style="width: 100%; height: 300px; padding: 0px; margin: 0px; float: left;"></div>
								<div class="subConMobile">월별 매출실적</div>
								<div id="Tab1ChartAreaM1" style="width: 100%; height: 250px; padding: 0px; margin: 0px; float: left;"></div>
								<div id="Tab1GridArea" style="width: 100%; height: 310px; padding: 0px; margin-bottom: 15px; float: left;"></div>
				</div>
				<div id="tab_area2" style="width: 100%; float: left;">
								<div class="subConMobile">원소재</div>
								<div id="Tab2ChartArea1" style="width: 100%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
								<div class="subConMobile">외주가공</div>
								<div id="Tab2ChartArea2" style="width: 100%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
								<div class="subConMobile">열처리</div>
								<div id="Tab2ChartArea3" style="width: 100%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
								<div class="subConMobile">집계현황</div>
								<div id="Tab2GridArea" style="width: 100%; height: 500px; padding: 0px; margin-bottom: 15px; float: left;"></div>
				</div>
				<div id="tab_area3" style="width: 100%; float: left;">
								<select id="searchLabel" name="searchLabel" style="display: none;"></select> <select id="searchRoutingGroup1" name="searchRoutingGroup1" style="display: none;"></select> <select id="searchRoutingGroup2" name="searchRoutingGroup2" style="display: none;"></select> <select id="searchRoutingGroup3" name="searchRoutingGroup3" style="display: none;"></select>
								<div class="subConMobile" id="tab3SubTitle1"></div>
								<div id="Tab3ChartArea1" style="width: 100%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
								<div class="subConMobile" id="tab3SubTitle2"></div>
								<div id="Tab3ChartArea2" style="width: 100%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
								<div class="subConMobile" id="tab3SubTitle3"></div>
								<div id="Tab3ChartArea3" style="width: 100%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
								<div class="subConMobile">집계현황</div>
								<div id="Tab3GridArea" style="width: 100%; height: 480px; padding: 0px; margin-bottom: 15px; float: left;"></div>
				</div>
				<div id="tab_area4" style="width: 100%; float: left;">
                <div class="subConMobile">불량수량</div>
                <div id="Tab4ChartArea1" style="width: 100%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
                <div class="subConMobile">불량율</div>
                <div id="Tab4ChartArea2" style="width: 100%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
                <div class="subConMobile">집계현황</div>
                <div id="Tab4GridArea" style="width: 100%; height: 420px; padding: 0px; margin-bottom: 15px; float: left;"></div>
				</div>
<!-- 				<div id="blank_area2" style="width: 100%; height: 60px; float: left;"></div> -->
				<div id="bottom_area" style="width: 100%; height: 70px; background-color: rgb(142, 180, 227); position: fixed; top: calc(100% - 60px); left: 0px; z-index: 9998;">
								<ul id="tab_list" style="width: 100%; height: 100%; float: left; display: block;"></ul>
				</div>
</body>
</html>