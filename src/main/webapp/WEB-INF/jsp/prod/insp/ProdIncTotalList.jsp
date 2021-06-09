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

    $("#gridPopup1Area").hide("blind", {
        direction: "up"
    }, "fast");

    //    setDummyTChart();
    //    setDummyRChart();

    //    setTimeout(function () {
    //      fn_chart_search();
    //    }, 200);


    setTimeout(function () {

        setValues();
        setExtGrid();

    }, 1500);

    setReadOnly();

    setLovList();
});

var occurdata = {};
function setInitial() {
    //    calender($('#searchMonth'));

    $('#searchMonth').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            }
        }
    });

    $("#searchMonth").val(getToDay("${searchVO.dateMonth}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {});

    gridnms["app"] = "prod";

    var orgid = $('#searchOrgId').val();
    var companyid = $('#searchCompanyId').val();
    occurdata.label = fn_option_filter_data(orgid, companyid, 'MFG', 'FAULT_TYPE', 'LABEL', "LABEL");
    occurdata.value = fn_option_filter_data(orgid, companyid, 'MFG', 'FAULT_TYPE', 'VALUE', "VALUE");
    occurdata.attribute3 = fn_option_filter_data(orgid, companyid, 'MFG', 'FAULT_TYPE', 'ATTRIBUTE3', "ATTRIBUTE3");
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
            left: 100,
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

var r_data;
//차트 데이터 Set
var header_r = ["불량유형", "불량율"];
var row_r = "", msg_r = "", check_r = false;
//var r_min = 0, r_max = 0;
function rdrawChart(v) {
    var title_name = '불량율';
    var view = new google.visualization.DataView(v);

    var options = {
        //      title: title_name,
        width: '100%',
        height: 280,
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
            width: '80%',
            height: '75%',
            left: 100,
            //        top: 0,
        },
        //      forceIFrame: true,
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
        dataOpacity: 0.7,
        curveType: 'none',
        animation: {
            duration: 2 * 1000,
            easing: 'out',
            startup: true,
        },
        allowHtml: true,
    };

    var color_length = occurdata.attribute3.length;
    for (var i = 0; i < color_length; i++) {
        var color = {};
        var value = occurdata.attribute3[i];
        if (value != "" || value != undefined) {
            color[i] = {
                color: occurdata.attribute3[i]
            };
            options.slices[i] = color[i];
        }
    }

    var rchart = new google.visualization.PieChart(document.getElementById('RChartArea'));
    rchart.draw(view, options);
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_list();
    setValues_popup();
}

function setValues_list() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "ProdIncTotalList";

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
            renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
                var result = '<a href="#" onclick="{0}">{1}</a>';

                temp = "javascript:fn_detail_popup(" + rowIndex + ");";

                return Ext.String.format(result, temp, value);
            },
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
    for (var i = 0; i < ncrcount; i++) {

        (function (x) {
            fields["columns-ncr.1"].push({
                dataIndex: 'NCR' + occurdata.value[x].substring(2),
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
        read: "<c:url value='/select/prod/insp/ProdIncTotalList.do' />"
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

var popupclick = 0;
function fn_detail_popup(rownum) {

    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rownum));
    var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

    var orgid = model1.data.ORGID;
    var companyid = model1.data.COMPANYID;
    var searchMonth = $('#searchMonth').val();
    var searchItemCode = model1.data.ITEMCODE;
    var searchOrderName = model1.data.ORDERNAME;
    var searchItemName = model1.data.ITEMNAME;
    var searchModel = model1.data.MODEL;
    var searchModelName = model1.data.MODELNAME;
    var searchCustomerName = model1.data.CUSTOMERNAME;
    var searchCustomerName = model1.data.CUSTOMERNAME;

    $('#popupOrgId').val($('#searchOrgId option:selected').val());
    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
    $('#popupItemCode').val(searchItemCode);
    $('#popupOrderName').val(searchOrderName);
    $('#popupItemName').val(searchItemName);
    $('#popupModel').val(searchModel);
    $('#popupModelName').val(searchModelName);
    $('#popupCustomerName').val(searchCustomerName);
    $('#popupCustomerName').val(searchCustomerName);

    Ext.getStore(gridnms['store.10']).removeAll();

    // 상세 팝업
    var width = 1535; // 가로
    var height = 640; // 세로
    var title = "부적합 상세내역 Popup";

    win10 = Ext.create('Ext.window.Window', {
        width: width,
        height: height,
        title: title,
        layout: 'fit',
        header: true,
        draggable: true,
        resizable: false,
        maximizable: false,
        closeAction: 'hide',
        modal: true,
        closable: true,
        buttonAlign: 'center',
        //autoScroll: true,
        overflowX: 'auto', // X축만 스크롤 적용
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.10"],
                id: gridnms["panel.10"],
                store: gridnms["store.10"],
                height: '100%',
                border: 2,
                scrollable: true,
                frameHeader: true,
                columns: fields["columns.10"],
                viewConfig: {
                    itemId: 'ProdIncDetailPopup'
                },
                plugins: 'bufferedrenderer',
                dockedItems: items["docked.10"],
            }
        ],
        tbar: [{
                height: '60px',
                width: '100%',
                layout: 'anchor',
                xtype: 'container',
                magin: '5px',
                defaults: {
                    anchor: '100%',
                    height: 27
                },
                items: [tbar1],
            }
        ]
    });

    win10.show();

    $('input[name=searchOrderName1]').val(searchOrderName);
    $('input[name=searchItemName1]').val(searchItemName);
    $('input[name=searchModelName1]').val(searchModelName);
    $('input[name=searchCustomerName1]').val(searchCustomerName);
    $('input[name=searchOrderName1]').attr('disabled', true).addClass('ui-state-disabled');
    $('input[name=searchItemName1]').attr('disabled', true).addClass('ui-state-disabled');
    $('input[name=searchModelName1]').attr('disabled', true).addClass('ui-state-disabled');
    $('input[name=searchCustomerName1]').attr('disabled', true).addClass('ui-state-disabled');

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHMONTH: searchMonth,
        ITEMCODE: searchItemCode,
        ORDERNAME: searchOrderName,
        ITEMNAME: searchItemName,
        MODEL: searchModel,
        MODELNAME: searchModelName,
    };

    extGridSearch(sparams, gridnms["store.10"]);
}

var tbar1 = Ext.create('Ext.toolbar.Toolbar', {
    height: '30px',
    items: [
        // '품번',
        {
            xtype: 'textfield',
            name: 'searchOrderName1',
            clearOnReset: true,
            fieldLabel: '품번',
            labelWidth: 90,
            labelPad: 1,
            labelSeparator: "&nbsp;&nbsp;",
            labelAlign: 'right',
            hideLabel: false,
            width: 210,
            editable: true,
            allowBlank: true,
            enableKeyEvents: true,
        }, // '품명',
        {
            xtype: 'textfield',
            name: 'searchItemName1',
            clearOnReset: true,
            fieldLabel: '품명',
            labelWidth: 90,
            labelPad: 1,
            labelSeparator: "&nbsp;&nbsp;",
            labelAlign: 'right',
            hideLabel: false,
            width: 290,
            editable: true,
            allowBlank: true,
            enableKeyEvents: true,
        }, // '기종',
        {
            xtype: 'textfield',
            name: 'searchModelName1',
            clearOnReset: true,
            fieldLabel: '기종',
            labelWidth: 90,
            labelPad: 1,
            labelSeparator: "&nbsp;&nbsp;",
            labelAlign: 'right',
            hideLabel: false,
            width: 210,
            editable: true,
            allowBlank: true,
            enableKeyEvents: true,
        },
        // '고객사',
        {
            xtype: 'textfield',
            name: 'searchCustomerName1',
            clearOnReset: true,
            fieldLabel: '고객사',
            labelWidth: 90,
            labelPad: 1,
            labelSeparator: "&nbsp;&nbsp;",
            labelAlign: 'right',
            hideLabel: false,
            width: 360,
            editable: true,
            allowBlank: true,
            enableKeyEvents: true,
        },
    ]

});

function setValues_popup() {
    gridnms["models.popup"] = [];
    gridnms["stores.popup"] = [];
    gridnms["views.popup"] = [];
    gridnms["controllers.popup"] = [];

    gridnms["grid.10"] = "ProdIncDetailList";

    gridnms["panel.10"] = gridnms["app"] + ".view." + gridnms["grid.10"];
    gridnms["views.popup"].push(gridnms["panel.10"]);

    gridnms["controller.10"] = gridnms["app"] + ".controller." + gridnms["grid.10"];
    gridnms["controllers.popup"].push(gridnms["controller.10"]);

    gridnms["model.10"] = gridnms["app"] + ".model." + gridnms["grid.10"];

    gridnms["store.10"] = gridnms["app"] + ".store." + gridnms["grid.10"];

    gridnms["models.popup"].push(gridnms["model.10"]);

    gridnms["stores.popup"].push(gridnms["store.10"]);

    fields["model.10"] = [{
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

    fields["columns.10"] = [{
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
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
            //      }, {
            //        dataIndex: 'ORDERNAME',
            //        text: '품번',
            //        xtype: 'gridcolumn',
            //        width: 110,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center; ',
            //        align: "center",
            //      }, {
            //        dataIndex: 'ITEMNAME',
            //        text: '품명',
            //        xtype: 'gridcolumn',
            //        width: 220,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center; ',
            //        align: "left",
            //      }, {
            //        dataIndex: 'MODELNAME',
            //        text: '기종',
            //        xtype: 'gridcolumn',
            //        width: 90,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center; ',
            //        align: "center",
            //      }, {
            //        dataIndex: 'CUSTOMERNAME',
            //        text: '고객사',
            //        xtype: 'gridcolumn',
            //        width: 180,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center; ',
            //        align: "center",
        }, {
            dataIndex: 'NCRQTY',
            text: '불량수량',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
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

    fields["columns-detail.10"] = [];
    fields["columns.10"].push({
        dataIndex: 'XXXXXXXXXX',
        text: "불량유형",
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        lockable: false,
        style: 'text-align:center; ',
        columns: fields["columns-detail.10"],
    });

    var ncrcount = occurdata.label.length;
    (function (i) {
        for (var i = 0; i < ncrcount; i++) {

            fields["columns-detail.10"].push({
                dataIndex: 'NCR' + occurdata.value[i].substring(2),
                text: occurdata.label[i].replace(/ /gi, "<br/>"),
                xtype: 'gridcolumn',
                width: 75,
                hidden: false,
                sortable: false,
                resizable: false,
                menuDisabled: true,
                style: 'text-align:center; font-size: 8pt !important;',
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                renderer: Ext.util.Format.numberRenderer('0,000'),
            });
        }
    })(i);

    items["api.10"] = {};
    $.extend(items["api.10"], {
        read: "<c:url value='/select/prod/insp/ProdIncDetailPopupList.do' />"
    });

    items["btns.10"] = [];

    items["btns.ctr.10"] = {};

    items["dock.paging.10"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.10"],
    };

    items["dock.btn.10"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.10"],
        items: items["btns.10"],
    };

    items["docked.10"] = [];
}

var gridarea, gridpopup;
function setExtGrid() {
    setExtGrid_list();
    setExtGrid_popup();

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
                                SEARCHMONTH: $('#searchMonth').val(),
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
            ProdIncTotalList: '#ProdIncTotalList',
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
                height: 348,
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
                    itemId: 'ProdIncTotalList',

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

function setExtGrid_popup() {
    Ext.define(gridnms["model.10"], {
        extend: Ext.data.Model,
        fields: fields["model.10"],
    });

    Ext.define(gridnms["store.10"], {
        extend: Ext.data.JsonStore,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.10"],
                        model: gridnms["model.10"],
                        autoLoad: false,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.10"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                SEARCHMONTH: $('#searchMonth').val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.10"], {
        extend: Ext.app.Controller,
        refs: {
            ProdIncDetailPopup: '#ProdIncDetailPopup',
        },
        stores: [gridnms["store.10"]],
        control: items["btns.ctr.10"],

    });

    Ext.define(gridnms["panel.10"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.10"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'rowmodel',
                itemId: gridnms["panel.10"],
                id: gridnms["panel.10"],
                store: gridnms["store.10"],
                height: 565,
                border: 2,
                scrollable: true,
                columns: fields["columns.10"],
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
                    itemId: 'ProdIncDetailPopup',

                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.10"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup"],
        stores: gridnms["stores.popup"],
        views: gridnms["views.popup"],
        controllers: gridnms["controller.10"],

        launch: function () {
            gridpopup = Ext.create(gridnms["views.popup"], {
                renderTo: 'gridPopup1Area'
            });
        },
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchMonth = $('#searchMonth').val();
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
    var searchMonth = $('#searchMonth').val();
    var searchItemCode = $('#searchItemCode').val();
    var searchOrderName = $('#searchOrderName').val();
    var searchItemName = $('#searchItemName').val();
    var searchModel = $('#searchModel').val();
    var searchModelName = $('#searchModelName').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHMONTH: searchMonth,
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
    var searchMonth = $('#searchMonth').val();
    var searchItemCode = $('#searchItemCode').val();
    var searchOrderName = $('#searchOrderName').val();
    var searchItemName = $('#searchItemName').val();
    var searchModel = $('#searchModel').val();
    var searchModelName = $('#searchModelName').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHMONTH: searchMonth,
        ITEMCODE: searchItemCode,
        ORDERNAME: searchOrderName,
        ITEMNAME: searchItemName,
        MODEL: searchModel,
        MODELNAME: searchModelName,
    };

    var url_t = "<c:url value='/select/prod/insp/ProdIncTotalChart.do'/>";
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

    var url_r = "<c:url value='/select/prod/insp/ProdIncTotalChart.do'/>";
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
                for (var i = 0; i < data.totcnt; i++) {
                    row_r = [data.data[i].LABEL, data.data[i].NCRQTY];
                    rows.push(row_r);

                    //                r_min = data.data[i].MINVALUE;
                    //                r_max = data.data[i].MAXVALUE;
                }

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

function setDummyRChart() {

    var rows = new Array();
    // Dummy 데이터 Set
    row_r = [null, 0];
    rows.push(row_r);
    //      r_min = 0;
    //      r_max = 0;

    var jsonData_r = [header_r].concat(rows);
    r_data = google.visualization.arrayToDataTable(jsonData_r);

    // 차트 호출
    rdrawChart(r_data);
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
                  <input type="hidden" id="popupOrgId" name="popupOrgId" />
                  <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                  <input type="hidden" id="popupItemCode" name="popupItemCode" />
                  <input type="hidden" id="popupOrderName" name="popupOrderName" />
                  <input type="hidden" id="popupItemName" name="popupItemName" />
                  <input type="hidden" id="popupModel" name="popupModel" />
                  <input type="hidden" id="popupModelName" name="popupModelName" />
                  <input type="hidden" id="popupCustomerName" name="popupCustomerName" />
                  <input type="hidden" id="popupCustomerName" name="popupCustomerName" />
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
	                                    <input type="text" id="searchMonth" name="searchMonth" class="input_validation input_center " style="width: 90px; " maxlength="8" />
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
	                    <td style="width: 49%;"><div class="subConTit3" style="margin-top: 10px;">불량수량</div></td>
	                    <td style="width: 2%;"></td>
	                    <td style="width: 49%;"><div class="subConTit3" style="margin-top: 10px;">불량율</div></td>
	                </tr>
	            </table>
	            <div id="TChartArea" style="width: 49%; height: 287px; padding-top: 0px; padding-left: 0px; margin-top: 10px; margin: 0px; float: left;"></div>
	            <div id="RChartArea" style="width: 49%; height: 287px; padding-top: 0px; padding-left: 0px; margin-top: 10px; margin: 0px; margin-left: 2%; float: left;"></div>
              <table style="width: 100%;">
                  <tr>
                      <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">집계내역</div></td>
                  </tr>
              </table>
              <div id="gridArea" style="width: 100%; margin-top: 0px; padding-bottom: 5px; float: left;"></div>
	        </div>
	        <!-- //content 끝 -->
	    </div>
	    <!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 2645px; padding-top: 0px; float: left;"></div>
	    <!-- footer 시작 -->
	    <div id="footer">
	        <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
	    </div>
	    <!-- //footer 끝 -->
	</div>
	<!-- //전체 레이어 끝 -->
</body>
</html>