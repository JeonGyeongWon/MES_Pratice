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
/* 	background-color: rgb(202, 202, 202); */
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
/* 	background-color: rgb(202, 202, 202); */
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
  white-space: nowrap;
  position: relative;
  overflow: hidden;
  color: white;
  font-weight: bold;
  /*     background-color: rgb(71, 174, 233); */
  background-color: #122D64;
/* 	background-color: #FFFF00; */
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
});

function setInitial() {
    gridnms["app"] = "eis";
    $("#searchYear").val(getToDay("${searchVO.DATEYEAR}") + "");

    var orgid = $('#searchOrgId').val();
    var companyid = $('#searchCompanyId').val();

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });
}

var c1_data;
// 차트 데이터 Set
var header = ["월", "계획", "실적"];
var row_c1 = "", msg_c1 = "", check_c1 = false;
var c2_data;
//차트 데이터 Set
var row_c2 = "", msg_c2 = "", check_c2 = false;
var c3_data;
//차트 데이터 Set
var row_c3 = "", msg_c3 = "", check_c3 = false;

function drawChart(v, i) {  //v = 차트데이터 , i는 1,2,3 에 따른 차트그리기
    var title_name,color,chartArea;
    switch( i) {
    case 1:
    title_name= '◎ 원소재';
    color='#BD0000';          //red
    chartArea='ChartArea1';
    break;
    case 2:
	  title_name= '◎ 외주가공';
	  color='#00BD00';         //green
	  chartArea='ChartArea2';
    	break;
    case 3:
    title_name= '◎ 열처리';
    color='#0000BD';          //blue
    chartArea='ChartArea3';
    break;
    default:
    title_name='';
    color='#000000';
    chartArea='';
    break;
    }
    var view = new google.visualization.DataView(v);

    var options = {
            width: '100%',
            height: '100%', // 580,
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
                //         maxLines: 8,
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
//             forceIFrame: true,
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
                                    color: 'BDBDBD', // 'grey',
                    visibleInLegend: true, // false,
                    //             lineDashStyle: [4, 4, 4, 4],
                    pointShape: 'circle', // 'square',
                    pointSize: 5,
                    lineWidth: 3,
                },
                1: {
                    type: 'line',
                    //             targetAxisIndex: 1,
                                    color: color, // 'red',
                    visibleInLegend: true, // false,
                    //             lineDashStyle: [4, 4, 4, 4],
                    pointShape: 'diamond', // 'square',
                    pointSize: 10,
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

    var chart = new google.visualization.ComboChart(document.getElementById(chartArea));
    chart.draw(view, options);
}


var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    var searchYear = $('#searchYear').val();
    serValues_list(searchYear);
}

function serValues_list(year) {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "EisItemPurSummary";

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
            name: 'PRE2AMOUNT',   //재작년 Total
        }, {
            type: 'string',
            name: 'PREAMOUNT',    //전년도 Total
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
            name: 'TOTAL',    //해당년
        }, ];

    fields["columns.1"] = [
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
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
//             	meta.style = " font-weight: bold; ";
            	
            	switch ( record.data.GUBUN1 ) {
                case "01":
                case "02":
                case "03":
                case "04":
                case "05":
                case "06":
                  if ( record.data.GUBUN2 == "1" ) {
                	  meta.style = " font-weight: bold; ";      
                  } else {
                      
//                       meta.style += " border-bottom: 2px groove white; ";
                    meta.style = " border-bottom: 1px groove black; ";
                  }
                  break;
            	case "99":
            		// 합계
            		meta.style = " font-weight: bold; ";
//                 meta.style += " background-color: #FFFF00; ";
                meta.style += " background-color: rgb(178, 204, 255); ";
                meta.style += " color: black; ";
                
                if ( record.data.GUBUN2 == 1 ) {
//                     meta.style += " border-right: 2px groove white; ";
                } else {
//                     meta.style += " border-bottom: 2px groove white; ";
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
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                switch ( record.data.GUBUN1 ) {
                case "01":
                case "02":
                case "03":
                case "04":
                case "05":
                case "06":
                  if ( record.data.GUBUN2 == "1" ) {
                  } else {
//                       meta.style += " border-bottom: 2px groove white; ";
                      meta.style = " border-bottom: 1px groove black; ";
                  }
                  break;
                case "99":
                  // 합계
                  meta.style = " background-color: rgb(178, 204, 255); ";
                  meta.style += " color: black; ";
                  if ( record.data.GUBUN2 == "1" ) {
//                       meta.style = " background-color: #FFFF00; ";
                      
                  } else {
//                       meta.style = " background-color: #FFFF00; ";
                      
//                       meta.style += " border-bottom: 2px groove white; ";
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
            var searchyear = $('#searchYear').val();
            var year = searchyear - rn;
            var column_text = year + "";
            fields["columns.1"].push({
                dataIndex: 'PRE' + ((rn == 2) ? rn : "") + "AMOUNT",
                text: column_text,
                xtype: 'gridcolumn',
                width: 110,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ',
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                renderer: function (value, meta, record) {
                    switch ( record.data.GUBUN1 ) {
                    case "01":
                    case "02":
                    case "03":
                    case "04":
                    case "05":
                    case "06":
                      if ( record.data.GUBUN2 == "1" ) {
                          
                      } else {
                          
//                           meta.style += " border-bottom: 2px groove white; ";
                    	  meta.style = " border-bottom: 1px groove black; ";
                      }
                      break;
                    case "99":
                      // 합계
                      meta.style = " background-color: rgb(178, 204, 255); ";
                      meta.style += " color: black; ";
                      if ( record.data.GUBUN2 == "1" ) {
//                           meta.style = " background-color: #ffff00; ";
                          
                      } else {
//                           meta.style = " background-color: #ffff00; ";
                          
//                           meta.style += " border-bottom: 2px groove white; ";
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

    var searchyear = $('#searchYear').val();
    fields["columns.1"].push({
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
            switch ( record.data.GUBUN1 ) {
            case "01":
            case "02":
            case "03":
            case "04":
            case "05":
            case "06":
            	 if ( record.data.GUBUN2 == "1" ) {
                 } else {
//                      meta.style += " border-bottom: 2px groove white; ";
                     meta.style = " border-bottom: 1px groove black; ";
                 }
                 break;
            case "99":
              // 합계
              meta.style = " background-color: rgb(178, 204, 255); ";
              meta.style += " color: black; ";
              if ( record.data.GUBUN2 == "1" ) {
//                   meta.style = " background-color: #ffff00; ";
                  
              } else {
//                   meta.style = " background-color: #ffff00; ";
                  
//                   meta.style += " border-bottom: 2px groove white; ";
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
            fields["columns.1"].push({
                dataIndex: 'MON' + qty_index,
                text: column_text,
                xtype: 'gridcolumn',
                width: 95,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ',
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                renderer: function (value, meta, record) {
                    switch ( record.data.GUBUN1 ) {
                    case "01":
                    case "02":
                    case "03":
                    case "04":
                    case "05":
                    case "06":
                      if ( record.data.GUBUN2 == "1" ) {
                      } else {
//                           meta.style += " border-bottom: 2px groove white; ";
                    	  meta.style += " border-bottom: 1px groove black; ";
                      }
                      break;
                    case "99":
                      // 합계
                      meta.style = " background-color: rgb(178, 204, 255); ";
                      meta.style += " color: black; ";
                      if ( record.data.GUBUN2 == "1" ) {
//                           meta.style = " background-color: #ffff00; ";
                          
                      } else {
//                           meta.style = " background-color: #ffff00; ";
                          
//                           meta.style += " border-bottom: 2px groove white; ";
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

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/eis/EisItemPurSummary.do' />"
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
    serExtGrid_list();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
    });
}

function serExtGrid_list() {
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
                                SEARCHYEAR: $("#searchYear").val() + "",
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
            PoTotalList: '#PoTotalList',
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
                height: 450,
                border: 2,
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
                    itemId: 'PoTotalList',
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
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchYear = $('#searchYear').val();
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
    var searchYear = $('#searchYear').val();
    fn_chart_search();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHYEAR: searchYear,
    };

    serValues_list(searchYear);
    Ext.suspendLayouts();
    Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
    Ext.resumeLayouts(true);
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_chart_search() {
    if (!fn_validation()) {
        return;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchYear = $('#searchYear').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHYEAR: searchYear,
    };

    var url1 = "<c:url value='/select/eis/EisItemPurSummaryChart.do?GUBUN=01'/>";
    $.ajax({
        url: url1,
        type: "post",
        dataType: "json",
        async: false,
        data: sparams,
        success: function (data) {
            var rows = new Array();
            if (data.totcnt == 0) {
                msg_c1 = "조회하신 항목에 대한 데이터가 없습니다.";
                check_c1 = false;

                setDummyChart(header,1);
            } else {
                msg_c1 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                check_c1 = true;

                var rows = new Array();
                for (var i = 0; i < data.totcnt; i++) {
                    row_c1 = [data.data[i].STANDARDMONTH, data.data[i].PLANAMOUNT, data.data[i].RESULTAMOUNT];
                    rows.push(row_c1);
                }

                var jsonData_c1 = [header].concat(rows);
                c1_data = google.visualization.arrayToDataTable(jsonData_c1);

                // 차트 호출
                drawChart(c1_data,1);
            }

            if (!check_c1) {
                extAlert(msg_c1);
                return;
            }
        },
        error: ajaxError
    });

    var url2 = "<c:url value='/select/eis/EisItemPurSummaryChart.do?GUBUN=02'/>";
    $.ajax({
        url: url2,
        type: "post",
        dataType: "json",
        async: false,
        data: sparams,
        success: function (data) {
            var rows = new Array();
            if (data.totcnt == 0) {
                msg_c2 = "조회하신 항목에 대한 데이터가 없습니다.";
                check_c2 = false;

                setDummyChart(header,2);
            } else {
                msg_c2 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                check_c2 = true;

                var rows = new Array();
                for (var i = 0; i < data.totcnt; i++) {
                    row_c2 = [data.data[i].STANDARDMONTH, data.data[i].PLANAMOUNT, data.data[i].RESULTAMOUNT];
                    rows.push(row_c2);
                }

                var jsonData_c2 = [header].concat(rows);
                c2_data = google.visualization.arrayToDataTable(jsonData_c2);

                // 차트 호출
                drawChart(c2_data,2);
            }

            if (!check_c2) {
                extAlert(msg_c2);
                return;
            }
        },
        error: ajaxError
    });

    var url3 = "<c:url value='/select/eis/EisItemPurSummaryChart.do?GUBUN=03'/>";
    $.ajax({
        url: url3,
        type: "post",
        dataType: "json",
        async: false,
        data: sparams,
        success: function (data) {
            var rows = new Array();
            if (data.totcnt == 0) {
                msg_c3 = "조회하신 항목에 대한 데이터가 없습니다.";
                check_c3 = false;

                setDummyChart(header,3);
            } else {
                msg_c3 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                check_c3 = true;

                var rows = new Array();
                for (var i = 0; i < data.totcnt; i++) {
                	 row_c3 = [data.data[i].STANDARDMONTH, data.data[i].PLANAMOUNT, data.data[i].RESULTAMOUNT];
                    rows.push(row_c3);
                }

                var jsonData_c3 = [header].concat(rows);
                c3_data = google.visualization.arrayToDataTable(jsonData_c3);

                // 차트 호출
                drawChart(c3_data,3);
            }

            if (!check_c3) {
                extAlert(msg_c3);
                return;
            }
        },
        error: ajaxError
    });

}

function setDummyChart(header, i) {

    var rows = new Array();
    var row = "";
    // Dummy 데이터 Set
    var count = 12;
    for (var i = 0; i < count; i++) {
        var rn = (i + 1) + "";
        var col_index = fn_lpad(rn, 2, '0');
        var col_name = col_index + "월";
        row = [col_name, 0, 0];
        rows.push(row); ;
    }

    var jsonData = [header].concat(rows);
    c_data = google.visualization.arrayToDataTable(jsonData);

    // 차트 호출
    drawChart(c_data, i);
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
                                        </div>
                                    </td>
                                </tr>
                            </table>
										    </form>
										</fieldset>
                </div>
								<!-- //검색 필드 박스 끝 -->
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">집계 현황</div></td>
                    </tr>
                </table>
                <div id="gridArea" style="width: 100%; padding-bottom: 5px; margin-bottom: 15px; float: left;"></div>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 34%;"><div class="subConTit3" >원소재</div></td>
                        <td style="width: 34%;"><div class="subConTit3" >외주가공</div></td>
                        <td style="width: 32%;"><div class="subConTit3" >열처리</div></td>
                    </tr>
                </table>
                <div id="ChartArea1" style="width: 32%; height: 200px; padding: 0px; margin: 0px; float: left;"></div>
                <div id="ChartArea2" style="width: 32%; height: 200px; padding: 0px; margin: 0px; margin-left: 2%; float: left;"></div>
                <div id="ChartArea3" style="width: 32%; height: 200px; padding: 0px; margin: 0px; margin-left: 2%; float: left;"></div>
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