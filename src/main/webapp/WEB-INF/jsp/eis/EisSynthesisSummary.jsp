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
}
</style>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
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
    var isCheck = fn_mobile_check();
    if (isCheck) {
        var chk = "${searchVO.mobileYn}";
        if (chk != "Y") {
            go_url("<c:url value='/eis/mobile/EisMain.do'/>");
        }
    }

    gridnms["app"] = "eis";

    $("#searchYear").val(getToDay("${searchVO.DATEYEAR}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });
}

var c1_data;
// 차트 데이터 Set
var header_c1 = ["월", "매출", "매입"];
var row_c1 = "", msg_c1 = "", check_c1 = false;
function c1drawChart(v) {
    var title_name = '◎ 매출매입 실적';
    var view = new google.visualization.DataView(v);

    var options = {
            //         title: title_name,
            width: '100%',
            height: '100%', // 580,
            fontName: 'Malgun Gothic',
            focusTarget: 'category',
            bar: {
                groupWidth: '100%'
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
            //     legend: {
            //       position: 'none'
            //     },
            crosshair: {
                trigger: 'both'
            },
            chartArea: {
                width: '85%',
                height: '85%',
                left: '15%',
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
                                    color: '3366CC', // 'blue',
                    visibleInLegend: true, // false,
                    //             lineDashStyle: [4, 4, 4, 4],
                    pointShape: 'circle', // 'square',
                    pointSize: 5,
                    lineWidth: 3,
                },
                1: {
                    type: 'line',
                    //             targetAxisIndex: 1,
                                    color: '#FF0000', // 'blue',
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

    var chart1 = new google.visualization.ComboChart(document.getElementById('ChartArea1'));
    chart1.draw(view, options);
}

var c2_data;
// 차트 데이터 Set
var header_c2 = ["월", "계획", "실적"];
var row_c2 = "", msg_c2 = "", check_c2 = false;
function c2drawChart(v) {
    var title_name = '◎ 매입비율 계획 대비 실적';
    var view = new google.visualization.DataView(v);

    var options = {
            //         title: title_name,
            width: '100%',
            height: '100%', // 580,
            fontName: 'Malgun Gothic',
            focusTarget: 'category',
            bar: {
                groupWidth: '100%'
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
            //     legend: {
            //       position: 'none'
            //     },
            crosshair: {
                trigger: 'both'
            },
            chartArea: {
                width: '85%',
                height: '85%',
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
                                    color: '#BDBDBD', // 'blue',
                    visibleInLegend: true, // false,
                    //             lineDashStyle: [4, 4, 4, 4],
                    pointShape: 'circle', // 'square',
                    pointSize: 5,
                    lineWidth: 3,
                },
                1: {
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

    var chart2 = new google.visualization.ComboChart(document.getElementById('ChartArea2'));
    chart2.draw(view, options);
}

var c3_data;
// 차트 데이터 Set
var header_c3 = ["구분", "년도-2", "년도-1", "년도"];
var row_c3 = "", msg_c3 = "", check_c3 = false;
function c3drawChart(v) {
    var title_name = '◎ 년도별 매출매입';
    var view = new google.visualization.DataView(v);

    var options = {
            //         title: title_name,
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
            chartArea: {
                width: '85%',
                height: '85%',
                left: '15%',
                top: 10,
            },
//             forceIFrame: true,
            role: {
                opacity: 0.7,
            },
            hAxis: {
                format: 'decimal',
            },
            seriesType: "bars",
            series: {
                0: {
                    type: 'bars',
                    color: '#8C8C8C', // '#D9E5FF',
                    visibleInLegend: true,
                },
                1: {
                    type: 'bars',
                    color: '#B2CCFF', // '#6799FF',
                    visibleInLegend: true,
                },
                2: {
                    type: 'bars',
                    color: '#0100FF', // '#003399',
                    visibleInLegend: true,
                },
            },
            tooltip: {
                ignoreBounds: false,
                isHtml: false,
                showColorCode: true,
                text: 'both', // 'value', 'percentage',
                trigger: 'focus', // 'selection',
            },
            dataOpacity: 0.8,
            animation: {
                duration: 2 * 1000,
                easing: 'out',
                startup: true,
            },
            allowHtml: true,
    };

    var chart3 = new google.visualization.ComboChart(document.getElementById('ChartArea3'));
    chart3.draw(view, options);
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

    gridnms["grid.1"] = "EisSynthesisSummary";

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
            name: 'PRE2AMOUNT',
        }, {
            type: 'string',
            name: 'PREAMOUNT',
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
            name: 'TOTAL',
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
            	
            	switch ( record.data.GUBUN1 ) {
            	case "1":
            		// 매출
//                 meta.style = " background-color: rgb(217, 229, 255); ";
//                 meta.style += " color: black; ";
                meta.style += " font-weight: bold; ";
//                 if ( record.data.GUBUN2 == "1" ) {
//                     meta.style += " border-right: 2px groove white; ";
//                 } else {
//                     meta.style += " border-bottom: 2px groove white; ";
//                 }
            		break;
            	case "2":
            		// 매입
//                 meta.style = " background-color: rgb(255, 216, 216); ";
                meta.style = " background-color: rgb(178, 204, 255); ";
                meta.style += " color: black; ";
                meta.style += " font-weight: bold; ";
//                 if ( record.data.GUBUN2 == "1" ) {
//                     meta.style += " border-left: 2px dashed blue; ";
//                     meta.style += " border-top: 2px dashed blue; ";
//                     meta.style += " border-right: 2px dashed blue; ";
//                 } else {
//                     meta.style += " border-left: 2px dashed blue; ";
//                     meta.style += " border-bottom: 2px dashed blue; ";
//                 }
            		break;
            	case "3":
            		// 매입비율
//                 meta.style = " background-color: #6799FF; ";
//                 meta.style += " color: black; ";
                meta.style += " font-weight: bold; ";
//                 if ( record.data.GUBUN2 == "1" ) {
//                     meta.style += " border-right: 2px groove white; ";
//                 } else {
//                     meta.style += " border-bottom: 2px groove white; ";
//                 }
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
                case "1":
                  // 매출
//                   if ( record.data.GUBUN2 == "1" ) {
//                       meta.style = " background-color: #bdbdbd; ";
//                       meta.style += " color: black; ";
//                   } else {
//                       meta.style = " background-color: rgb(217, 229, 255); ";
//                       meta.style += " color: black; ";
//                       meta.style += " border-bottom: 2px groove white; ";
//                   }
                  break;
                case "2":
                  // 매입
                  if ( record.data.GUBUN2 == "1" ) {
//                       meta.style = " background-color: #bdbdbd; ";
//                       meta.style += " color: black; ";
//                       meta.style += " border-bottom: 2px dashed blue; ";
                  } else {
//                       meta.style = " background-color: rgb(255, 216, 216); ";
                      meta.style = " background-color: rgb(178, 204, 255); ";
                      meta.style += " color: black; ";
//                       meta.style += " border-bottom: 2px dashed blue; ";
                  }
                  break;
                case "3":
                  // 매입비율
//                   if ( record.data.GUBUN2 == "1" ) {
//                       meta.style = " background-color: #bdbdbd; ";
//                       meta.style += " color: black; ";
//                   } else {
//                       meta.style = " background-color: #6799FF; ";
//                       meta.style += " color: black; ";
//                       meta.style += " border-bottom: 2px groove white; ";
//                   }
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
                	var result;
                    switch ( record.data.GUBUN1 ) {
                    case "1":
                      // 매출
//                       if ( record.data.GUBUN2 == "1" ) {
//                           meta.style = " background-color: #bdbdbd; ";
//                           meta.style += " color: black; ";
//                       } else {
//                           meta.style = " background-color: rgb(217, 229, 255); ";
//                           meta.style += " color: black; ";
//                           meta.style += " border-bottom: 2px groove white; ";
//                       }
                      result = value/1000;
                      break;
                    case "2":
                      // 매입
                      if ( record.data.GUBUN2 == "1" ) {
//                           meta.style = " background-color: #bdbdbd; ";
//                           meta.style += " color: black; ";
//                           meta.style += " border-bottom: 2px dashed blue; ";
                      } else {
//                           meta.style = " background-color: rgb(255, 216, 216); ";
                          meta.style = " background-color: rgb(178, 204, 255); ";
                          meta.style += " color: black; ";
//                           meta.style += " border-bottom: 2px groove white; ";
//                           meta.style += " border-bottom: 2px dashed blue; ";
                      }
                      result = value/1000;
                      break;
                    case "3":
                      // 매입비율
//                       if ( record.data.GUBUN2 == "1" ) {
//                           meta.style = " background-color: #bdbdbd; ";
//                           meta.style += " color: black; ";
//                       } else {
//                           meta.style = " background-color: #6799FF; ";
//                           meta.style += " color: black; ";
//                           meta.style += " border-bottom: 2px groove white; ";
//                       }
                      result = value;
                      break;
                      default:
                        break;
                    }
                    return Ext.util.Format.number(result, '0,000');
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
        	var result;
            switch ( record.data.GUBUN1 ) {
            case "1":
              // 매출
//               if ( record.data.GUBUN2 == "1" ) {
//                   meta.style = " background-color: #bdbdbd; ";
//                   meta.style += " color: black; ";
//               } else {
//                   meta.style = " background-color: rgb(217, 229, 255); ";
//                   meta.style += " color: black; ";
//                   meta.style += " border-bottom: 2px groove white; ";
//               }
              result=value/1000;
              break;
            case "2":
              // 매입
              if ( record.data.GUBUN2 == "1" ) {
//                   meta.style = " background-color: #bdbdbd; ";
//                   meta.style += " color: black; ";
//                   meta.style += " border-bottom: 2px dashed blue; ";
              } else {
//                   meta.style = " background-color: rgb(255, 216, 216); ";
                  meta.style = " background-color: rgb(178, 204, 255); ";
                  meta.style += " color: black; ";
//                   meta.style += " border-bottom: 2px dashed blue; ";
              }
              result=value/1000;
              break;
            case "3":
              // 매입비율
//               if ( record.data.GUBUN2 == "1" ) {
//                   meta.style = " background-color: #bdbdbd; ";
//                   meta.style += " color: black; ";
//               } else {
//                   meta.style = " background-color: #6799FF; ";
//                   meta.style += " color: black; ";
//                   meta.style += " border-bottom: 2px groove white; ";
//               }
              result=value;
              break;
              default:
                break;
            }
            return Ext.util.Format.number(result, '0,000');
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
                	var result;
                    switch ( record.data.GUBUN1 ) {
                    case "1":
                      // 매출
//                       if ( record.data.GUBUN2 == "1" ) {
//                           meta.style = " background-color: #bdbdbd; ";
//                           meta.style += " color: black; ";
//                       } else {
//                           meta.style = " background-color: rgb(217, 229, 255); ";
//                           meta.style += " color: black; ";
//                           meta.style += " border-bottom: 2px groove white; ";
//                       }
                      result = value/1000;
                      break;
                    case "2":
                      // 매입
                      if ( record.data.GUBUN2 == "1" ) {
//                           meta.style = " background-color: #bdbdbd; ";
//                           meta.style += " color: black; ";
//                           meta.style += " border-bottom: 2px dashed blue; ";
                      } else {
//                           meta.style = " background-color: rgb(255, 216, 216); ";
                          meta.style = " background-color: rgb(178, 204, 255); ";
                          meta.style += " color: black; ";
//                           meta.style += " border-bottom: 2px dashed blue; ";
//                           if ( qty_index == "12" ) {
//                               meta.style += " border-right: 2px dashed blue; ";
//                           }
                      }
                      result = value/1000;
                      break;
                    case "3":
                      // 매입비율
//                       if ( record.data.GUBUN2 == "1" ) {
//                           meta.style = " background-color: #bdbdbd; ";
//                           meta.style += " color: black; ";
//                       } else {
//                           meta.style = " background-color: #6799FF; ";
//                           meta.style += " color: black; ";
//                           meta.style += " border-bottom: 2px groove white; ";
//                       }
                      result = value;
                      break;
                      default:
                        break;
                    }
                    return Ext.util.Format.number(result, '0,000');
                },
            });

        })(i);
    }

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/eis/EisSynthesisSummary.do' />"
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
            SynthesisSummaryList: '#SynthesisSummaryList',
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
                height: 201, // 385,
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
                    itemId: 'SynthesisSummaryList',
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

    var url1 = "<c:url value='/select/eis/EisSynthesisSummaryChart1.do'/>";
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

                setDummyChart1();
            } else {
                msg_c1 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                check_c1 = true;

                var rows = new Array();
                for (var i = 0; i < data.totcnt; i++) {
                    row_c1 = [data.data[i].STANDARDMONTH, data.data[i].SALESAMOUNT, data.data[i].PURCHASEAMOUNT];
                    rows.push(row_c1);
                }

                var jsonData_c1 = [header_c1].concat(rows);
                c1_data = google.visualization.arrayToDataTable(jsonData_c1);

                // 차트 호출
                c1drawChart(c1_data);
            }

            if (check_c1 == false) {
                extAlert(msg_c1);
                return;
            }
        },
        error: ajaxError
    });

    var url2 = "<c:url value='/select/eis/EisSynthesisSummaryChart2.do'/>";
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

                setDummyChart2();
            } else {
                msg_c2 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                check_c2 = true;

                var rows = new Array();
                for (var i = 0; i < data.totcnt; i++) {
                    row_c2 = [data.data[i].STANDARDMONTH, data.data[i].PLANAMOUNT, data.data[i].RESULTAMOUNT];
                    rows.push(row_c2);
                }

                var jsonData_c2 = [header_c2].concat(rows);
                c2_data = google.visualization.arrayToDataTable(jsonData_c2);

                // 차트 호출
                c2drawChart(c2_data);
            }

            if (check_c2 == false) {
                extAlert(msg_c2);
                return;
            }
        },
        error: ajaxError
    });

    var searchyear = $('#searchYear').val();
    header_c3[1] = searchyear - 2 + "";
    header_c3[2] = searchyear - 1 + "";
    header_c3[3] = searchyear;
    var url3 = "<c:url value='/select/eis/EisSynthesisSummaryChart3.do'/>";
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

                setDummyChart3();
            } else {
                msg_c3 = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                check_c3 = true;

                var rows = new Array();
                for (var i = 0; i < data.totcnt; i++) {
                    row_c3 = [data.data[i].GUBUN, data.data[i].PRE2AMOUNT, data.data[i].PREAMOUNT, data.data[i].AMOUNT];
                    rows.push(row_c3);
                }

                var jsonData_c3 = [header_c3].concat(rows);
                c3_data = google.visualization.arrayToDataTable(jsonData_c3);

                // 차트 호출
                c3drawChart(c3_data);
            }

            if (check_c3 == false) {
                extAlert(msg_c3);
                return;
            }
        },
        error: ajaxError
    });

}

function setDummyChart1() {

    var rows = new Array();
    // Dummy 데이터 Set
    var count = 12;
    for (var i = 0; i < count; i++) {
        var rn = (i + 1) + "";
        var col_index = fn_lpad(rn, 2, '0');
        var col_name = col_index + "월";
        row_c1 = [col_name, 0, 0];
        rows.push(row_c1); ;
    }

    var jsonData_c1 = [header_c1].concat(rows);
    c1_data = google.visualization.arrayToDataTable(jsonData_c1);

    // 차트 호출
    c1drawChart(c1_data);
}

function setDummyChart2() {

    var rows = new Array();
    // Dummy 데이터 Set
    var count = 12;
    for (var i = 0; i < count; i++) {
        var rn = (i + 1) + "";
        var col_index = fn_lpad(rn, 2, '0');
        var col_name = col_index + "월";
        row_c2 = [col_name, 0, 0];
        rows.push(row_c2); ;
    }

    var jsonData_c2 = [header_c2].concat(rows);
    c2_data = google.visualization.arrayToDataTable(jsonData_c2);

    // 차트 호출
    c2drawChart(c2_data);
}

var global_chart3 = ["매출", "매입"];
function setDummyChart3() {

    var rows = new Array();
    // Dummy 데이터 Set
    var count = 2;
    for (var i = 0; i < count; i++) {
        var col_name = global_chart3[0];
        row_c3 = [col_name, 0, 0, 0];
        rows.push(row_c3); ;
    }

    var jsonData_c3 = [header_c3].concat(rows);
    c3_data = google.visualization.arrayToDataTable(jsonData_c3);

    // 차트 호출
    c3drawChart(c3_data);
}

//PDF 다운로드
function fn_pdf_download() {
 var orgid = $('#searchOrgId option:selected').val();
 var companyid = $('#searchCompanyId option:selected').val();
 var searchYear = $("#searchYear").val();

 var column = 'master';
 var url = null;
 var target = '_blank';

 url = "<c:url value='/report/EisSynthesisSummaryReport.pdf'/>"; // 월별/년도별 매출실적(거래처별)

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
																						<a id="btnChk2" class="btn_print" href="#" onclick="javascript:fn_pdf_download();"> 매출매입종합요약 </a>
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
                        <td style="width: 34%;"><div class="subConTit3" >매출매입 실적</div></td>
                        <td style="width: 34%;"><div class="subConTit3" >매입비율 계획 대비 실적</div></td>
                        <td style="width: 32%;"><div class="subConTit3" >년도별 매출매입</div></td>
                    </tr>
                </table>
                <div id="ChartArea1" style="width: 32%; height: 352px; padding: 0px; margin: 0px; float: left;"></div>
                <div id="ChartArea2" style="width: 32%; height: 352px; padding: 0px; margin: 0px; margin-left: 2%; float: left;"></div>
                <div id="ChartArea3" style="width: 32%; height: 352px; padding: 0px; margin: 0px; margin-left: 2%; float: left;"></div>
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