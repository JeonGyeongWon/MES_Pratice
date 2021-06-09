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

    setTimeout(function () {

        setValues();
        setExtGrid();

    }, 200);

    setReadOnly();

    setLovList();

    //    setTimeout(function(){
    //     fn_search();
    //    },200);
});

var occurdata = {};
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

    $("#searchFrom").val(getToDay("${searchVO.dateFrom}") + "");
    $("#searchTo").val(getToDay("${searchVO.dateTo}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {});

    gridnms["app"] = "prod";

    var orgid = $('#searchOrgId').val();
    var companyid = $('#searchCompanyId').val();
    occurdata.label = fn_option_filter_data(orgid, companyid, 'MFG', 'FAULT_TYPE', 'LABEL', "LABEL");
    occurdata.value = fn_option_filter_data(orgid, companyid, 'MFG', 'FAULT_TYPE', 'VALUE', "VALUE");
}

var t_data;
//차트 데이터 Set
var header_t = ["불량유형", "수량"];
var row_t = "", msg_t = "", check_t = false;
//var t_min = 0, t_max = 0;
function tdrawChart(v) {
    var title_name = '불량수량';
    var view = new google.visualization.DataView(v);

    var options = {
        //      title: title_name,
        width: '100%',
        height: 280,
        fontName: 'Malgun Gothic',
        focusTarget: 'category',
        bar: {
            groupWidth: '50%'
        },
        //        legend: {
        //          position: 'right',
        //          alignment: 'center',
        //        },
        legend: {
            position: 'none'
        },
        series: {
            0: {
                targetAxisIndex: 0,
                type: "bar",
                color: "blue"
            },
        },
        chartArea: {
            width: '90%',
            height: '60%',
            left: '5%',
            top: '5%',
        },
        role: {
            opacity: 0.7,
        },
        vAxis: {
            minValue: 0, // t_min,
            maxValue: 10, // t_max,
        },
        hAxis: {
            format: 'none',
        },
        //       seriesType: "bars",
        dataOpacity: 0.7,
        curveType: 'none',
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var tchart = new google.visualization.ColumnChart(document.getElementById('TChartArea'));
    tchart.draw(view, options);
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_list();
}

function setValues_list() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "ProdIncDetailList";

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
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
            type: 'date',
            name: 'CREATIONDATE',
            dateFormat: 'Y-m-d',
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

    fields["columns.1"] = [{
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
            dataIndex: 'CREATIONDATE',
            text: '일자',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
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
                return ['총합계'].map(function (val) {
                    return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + val + '</div>';
                }).join('<br />');
            },
        }, {
            dataIndex: 'NCRQTY',
            text: '불량수량',
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
                var data = Ext.getStore(gridnms["store.1"]).getData().items;
                var values = extExtractValues(data, dataIndex);
                var total = value;

                // 전체합계
                var ncrqty = 0;
                for (var i = 0; i < extExtractValues(data, "NCRQTY").length; i++) {
                    ncrqty += extExtractValues(data, "NCRQTY")[i];
                }

                var result = [total].map(function (val) {
                    return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(val, '0,000') + '</div>';
                }).join('<br />');
                return result;
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
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

    fields["columns-ncr.1"] = [];
    fields["columns.1"].push({
        dataIndex: 'XXXXXXXXXX',
        text: "불량유형",
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        lockable: false,
        style: 'text-align:center; ',
        columns: fields["columns-ncr.1"],
    });

    var ncrcount = occurdata.label.length;
    (function (i) {
        for (var i = 0; i < ncrcount; i++) {

            fields["columns-ncr.1"].push({
                dataIndex: 'NCR' + occurdata.value[i].substring(2),
                text: occurdata.label[i].replace(/ /gi, "<br/>"),
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
                    var data = Ext.getStore(gridnms["store.1"]).getData().items;
                    var values = extExtractValues(data, dataIndex);
                    var total = value;

                    // 전체합계
                    var ncrqty = 0;
                    for (var i = 0; i < extExtractValues(data, "NCRQTY").length; i++) {
                        ncrqty += extExtractValues(data, "NCRQTY")[i];
                    }

                    var result = [total].map(function (val) {
                        return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(val, '0,000') + '</div>';
                    }).join('<br />');
                    return result;
                },
                renderer: Ext.util.Format.numberRenderer('0,000'),
            });
        }
    })(i);

    fields["columns.1"].push({
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

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/prod/insp/ProdIncDetailList.do' />"
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
    setExtGrid_list();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
    });
}

function setExtGrid_list() {
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
                                             SEARCHFROM: $('#searchFrom').val(),
                                             SEARCHTO: $('#searchTo').val(),
                                             ITEMCODE: $('#searchItemCode').val(),
                                             ORDERNAME: $('#searchOrderName').val(),
                                             ITEMNAME: $('#searchItemName').val(),
                                             MODEL: $('#searchModel').val(),
                                             MODELNAME: $('#searchModelName').val(),
                                           },
                            reader: gridVals.reader,
                            //               writer: $.extend(gridVals.writer, {
                            //                 writeAllFields: true
                            //               }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            ProdIncDetailList: '#ProdIncDetailList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

    });

    Ext.define(gridnms["panel.1"], {
        extend: Ext.panel.Panel,
        //         requires: [
        //           'Ext.grid.selection.SpreadsheetModel',
        //           'Ext.grid.plugin.Clipboard',
        //         ],
        alias: 'widget.' + gridnms["panel.1"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'rowmodel', // 'spreadsheet',
                //         allowDeselect: true,
                //         mode: "SINGLE", // "MULTI",
                //         cellSelect: true,
                //         dragSelect: true,
                //         ignoreRightMouseSelection: true,
                //         columnSelect: true,
                //         pruneRemoved: false,
                //         rowSelect: false,
                itemId: gridnms["panel.1"],
                id: gridnms["panel.1"],
                store: gridnms["store.1"],
                height: 408,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'bottom'
                    }
                ],
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                //                 selModel: {
                //                   type: 'spreadsheet',
                //                   rowNumbererHeaderWidth: 0,
                //                 },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20, // #1
                        leadingBufferZone: 20, // #2
                        synchronousRender: false,
                        numFromEdge: 19,
                        //                       }, {
                        //                         // CTRL+C/X/V 활성화
                        //                         ptype: 'clipboard',
                    },
                ],
                viewConfig: {
                    itemId: 'ProdIncDetailList',
                    trackOver: true,
                    loadMask: true,
                },
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
    var searchFrom = $('#searchFrom').val();
    var searchTo = $('#searchTo').val();
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
        header.push("기간 From");
        count++;
    }

    if (searchTo == "") {
        header.push("기간 To");
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
    var searchFrom = $('#searchFrom').val();
    var searchTo = $('#searchTo').val();
    var searchItemCode = $('#searchItemCode').val();
    var searchOrderName = $('#searchOrderName').val();
    var searchItemName = $('#searchItemName').val();
    var searchModel = $('#searchModel').val();
    var searchModelName = $('#searchModelName').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHFROM: searchFrom,
        SEARCHTO: searchTo,
        ITEMCODE: searchItemCode,
        ORDERNAME: searchOrderName,
        ITEMNAME: searchItemName,
        MODEL: searchModel,
        MODELNAME: searchModelName,
    };

    fn_chart_search();

    setValues_list();
    Ext.suspendLayouts();
    Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
    Ext.resumeLayouts(true);
    extGridSearch(sparams, gridnms["store.1"]);
    //       extSpreadSearch(sparams, gridnms["store.1"], gridnms["panel.1"]);
}

function fn_chart_search() {
    if (!fn_validation()) {
        return;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchFrom = $('#searchFrom').val();
    var searchTo = $('#searchTo').val();
    var searchItemCode = $('#searchItemCode').val();
    var searchOrderName = $('#searchOrderName').val();
    var searchItemName = $('#searchItemName').val();
    var searchModel = $('#searchModel').val();
    var searchModelName = $('#searchModelName').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHFROM: searchFrom,
        SEARCHTO: searchTo,
        ITEMCODE: searchItemCode,
        ORDERNAME: searchOrderName,
        ITEMNAME: searchItemName,
        MODEL: searchModel,
        MODELNAME: searchModelName,
    };

    var url_t = "<c:url value='/select/prod/insp/ProdIncDetailChart.do'/>";
    $.ajax({
        url: url_t,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var rows = new Array();
            if (data.totcnt == 0) {
                msg_t = "조회하신 항목에 대한 데이터가 없습니다.";
                check_t = false;

                setDummyTChart();
            } else {
                msg_t = "데이터가 " + data.totcnt + "건 조회되었습니다.";
                check_t = true;

                var rows = new Array();
                for (var i = 0; i < data.totcnt; i++) {
                    row_t = [data.data[i].LABEL, data.data[i].NCRQTY];
                    rows.push(row_t);

                    //              t_min = data.data[i].MINVALUE;
                    //              t_max = data.data[i].MAXVALUE;
                }

                var jsonData_t = [header_t].concat(rows);
                t_data = google.visualization.arrayToDataTable(jsonData_t);

                // 차트 호출
                tdrawChart(t_data);
            }

            if (check_t == false) {
                extAlert(msg_t);
                return;
            }
        },
        error: ajaxError
    });
}

function setDummyTChart() {

    var rows = new Array();
    // Dummy 데이터 Set
    row_t = [null, 0];
    rows.push(row_t);
    //    s_min = 0;
    //    s_max = 0;

    var jsonData_t = [header_t].concat(rows);
    t_data = google.visualization.arrayToDataTable(jsonData_t);

    // 차트 호출
    tdrawChart(t_data);
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
	                <fieldset style="width: 100%">
	                <legend>조건정보 영역</legend>
	                <form id="master" name="master" action="" method="post">
                      <input type="hidden" id="title" name="title" value="${pageTitle}"/>
                      <input type="hidden" id="searchItemCode" name="searchItemCode" />
                      <input type="hidden" id="searchModel" name="searchModel" />
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
	                                    </div>
	                                </td>
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
                                  <col width="120px">
                                  <col>
	                            </colgroup>
	                            
	                            <tr style="height: 34px;">
	                                <th class="required_text">년월</th>
	                                <td >
	                                    <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center " style="width: 90px; " maxlength="10" />
	                                    &nbsp;~&nbsp;
	                                    <input type="text" id="searchTo" name="searchTo" class="input_validation input_center " style="width: 90px; " maxlength="10"  />
	                                </td>
                                  <th class="required_text">품번</th>
                                  <td>
                                      <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                  </td>
                                  <th class="required_text">품명</th>
                                  <td >
                                      <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                  </td>
                                  <th class="required_text">기종</th>
                                  <td >
                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                  </td>
	                            </tr>
	                        </table>
	                    </div>
	                </form>
	            </fieldset>
	            </div>
	            <!-- //검색 필드 박스 끝 -->
	            <table style="width: 100%;">
                  <tr>
                      <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">불량수량</div></td>
                  </tr>
              </table>
	            <div id="TChartArea" style="width: 100%; height: 237px; padding-top: 0px; padding-left: 0px; margin-top: 10px; margin: 0px; float: left;"></div>
	            <table style="width: 100%;">
                  <tr>
                      <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">상세내역</div></td>
                  </tr>
              </table>
              <div id="gridArea" style="width: 100%; margin-top: 0px; padding-bottom: 5px; float: left;"></div>
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