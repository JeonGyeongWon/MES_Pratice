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
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();

    var searchyear = $('#searchYear').val();
    setValues(searchyear);

    setExtGrid();

    setReadOnly();

    setLovList();
});

function setInitial() {
    gridnms["app"] = "eis";

    $("#searchYear").val(getToDay("${searchVO.DATEYEAR}") + "");
    var searchyear = $('#searchYear').val();

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });
}
var gridnms = {};
var fields = {};
var items = {};
var flag = 0;
function setValues() {
    var searchyear = $('#searchYear').val();
    setValues(searchyear);
}

function setValues(year) {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "EisCustSalesResultList";

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
            name: 'RN2',
        }, {
            type: 'number',
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'SHIPPINGGROUPNAME',
        }, {
            type: 'string',
            name: 'CARTYPENAME',
        }, {
            type: 'number',
            name: 'PRE2AMOUNT',
        }, {
            type: 'number',
            name: 'PRE2QTY',
        }, {
            type: 'number',
            name: 'PREAMOUNT',
        }, {
            type: 'number',
            name: 'PREQTY',
        }, {
            type: 'number',
            name: 'TOTALAMOUNT',
        }, {
            type: 'number',
            name: 'TOTALQTY',
        }, {
            type: 'number',
            name: 'MO1',
        }, {
            type: 'number',
            name: 'MOQ1',
        }, {
            type: 'number',
            name: 'MO2',
        }, {
            type: 'number',
            name: 'MOQ2',
        }, {
            type: 'number',
            name: 'MO3',
        }, {
            type: 'number',
            name: 'MOQ3',
        }, {
            type: 'number',
            name: 'MO4',
        }, {
            type: 'number',
            name: 'MOQ4',
        }, {
            type: 'number',
            name: 'MO5',
        }, {
            type: 'number',
            name: 'MOQ5',
        }, {
            type: 'number',
            name: 'MO6',
        }, {
            type: 'number',
            name: 'MOQ6',
        }, {
            type: 'number',
            name: 'MO7',
        }, {
            type: 'number',
            name: 'MOQ7',
        }, {
            type: 'number',
            name: 'MO8',
        }, {
            type: 'number',
            name: 'MOQ8',
        }, {
            type: 'number',
            name: 'MO9',
        }, {
            type: 'number',
            name: 'MOQ9',
        }, {
            type: 'number',
            name: 'MO10',
        }, {
            type: 'number',
            name: 'MOQ10',
        }, {
            type: 'number',
            name: 'MO11',
        }, {
            type: 'number',
            name: 'MOQ11',
        }, {
            type: 'number',
            name: 'MO12',
        }, {
            type: 'number',
            name: 'MOQ12',
        }
    ];

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
            align: "left",
            renderer: function (value, meta, record) {
                if (record.data.CARTYPENAME == '품목별 소계') {
                    meta.style += " border-bottom: 1px dashed blue; ";
                }
                if (record.data.RN1 != 1) {
                    return null;
                }
                return value;
            }
        }, {
            dataIndex: 'SHIPPINGGROUPNAME',
            text: '품목',
            xtype: 'gridcolumn',
            width: 130,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            align: "center",
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var header = "합계";
                return [header].map(function (val, index) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: center; font-size: 15px; color: red; '>" + val + '</div>';
                }).join('<br />');
            },
            renderer: function (value, meta, record) {
                if (record.data.RN2 != 1) {

                    if (record.data.CARTYPENAME == "품목별 소계") {
                        meta.style += " border-bottom: 1px dashed blue; ";
                    } else {
                        return null;
                    }
                } else {
                    if (record.data.CARTYPENAME == "품목별 소계") {
                        meta.style += " border-bottom: 1px dashed blue; ";
                    }
                }
                return value;
            },
        }, {
            dataIndex: 'CARTYPENAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 130,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                var model = record.data.CARTYPENAME;
                if (model == "기종별 소계") {
                    meta.style = " color: blue; ";
                    meta.style += " font-weight: bold; ";
                    //                     meta.style += " font-size: 15px !important;";
                } else if (model == "품목별 소계") {
                    meta.style = " color: red; ";
                    meta.style += " font-weight: bold; ";
                    meta.style += " border-bottom: 1px dashed blue; ";
                    //                     meta.style += " font-size: 15px !important;";
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
        }, {
            dataIndex: 'RN',
            xtype: 'hidden',
        }, {
            dataIndex: 'RN1',
            xtype: 'hidden',
        }, {
            dataIndex: 'RN2',
            xtype: 'hidden',
        }, ];

    for (var y = 2; y > 0; y--) {
        (function (x) {
            var rn = x;
            var searchyear = $('#searchYear').val();
            var year = searchyear - rn;
            var column_text = year + "";
            fields["columns.1"].push({
                text: column_text,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center;',
                columns: [{
                        dataIndex: 'PRE' + ((rn == 2) ? rn : "") + "AMOUNT",
                        text: '합계',
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
                        summaryType: 'sum',
                        summaryRenderer: function (value, summaryData, dataIndex) {
                            var data = Ext.getStore(gridnms["store.1"]).getData().items;
                            var total = 0;
                            for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                                var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                                if (record.CARTYPENAME == '기종별 소계') {
                                    total += (extExtractValues(data, dataIndex)[i] * 1);
                                }
                            }
                            var result = [total].map(function (val, index) {
                                return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val / 1000, '0,000') + '</div>';
                            }).join('<br />');
                            return result;
                        },
                        renderer: function (value, meta, record) {
                            var model = record.data.CARTYPENAME;
                            if (model == "기종별 소계") {
                                meta.style = " color: blue; ";
                                meta.style += " font-weight: bold; ";
                                //                             meta.style += " font-size: 15px !important;";
                            } else if (model == "품목별 소계") {
                                meta.style = " color: red; ";
                                meta.style += " font-weight: bold; ";
                                meta.style += " border-bottom: 1px dashed blue; ";
                                //                             meta.style += " font-size: 15px !important;";
                            }
                            return Ext.util.Format.number(value / 1000, '0,000');
                        },
                    }, {
                        dataIndex: 'PRE' + ((rn == 2) ? rn : "") + "QTY",
                        text: '수량',
                        xtype: 'gridcolumn',
                        width: 60,
                        hidden: false,
                        sortable: false,
                        resizable: true,
                        menuDisabled: true,
                        style: 'text-align:center; ',
                        align: "right",
                        cls: 'ERPQTY',
                        format: "0,000",
                        summaryType: 'sum',
                        summaryRenderer: function (value, summaryData, dataIndex) {
                            var data = Ext.getStore(gridnms["store.1"]).getData().items;
                            var total = 0;
                            for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                                var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                                if (record.CARTYPENAME == '기종별 소계') {
                                    total += (extExtractValues(data, dataIndex)[i] * 1);
                                }
                            }
                            var result = [total].map(function (val, index) {
                                return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val, '0,000') + '</div>';
                            }).join('<br />');
                            return result;
                        },
                        renderer: function (value, meta, record) {
                            var model = record.data.CARTYPENAME;
                            if (model == "기종별 소계") {
                                meta.style = " color: blue; ";
                                meta.style += " font-weight: bold; ";
                                //                             meta.style += " font-size: 15px !important;";
                            } else if (model == "품목별 소계") {
                                meta.style = " color: red; ";
                                meta.style += " font-weight: bold; ";
                                meta.style += " border-bottom: 1px dashed blue; ";
                                //                             meta.style += " font-size: 15px !important;";
                            }
                            return Ext.util.Format.number(value, '0,000');
                        },
                    }, ]
            });
        })(y);
    }

    fields["columns.1"].push({
        dataIndex: 'TOTAL',
        text: '합계',
        xtype: 'gridcolumn',
        width: 110,
        hidden: false,
        sortable: false,
        resizable: true,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "right",
        cls: 'ERPQTY',
        columns: [{
                dataIndex: 'TOTALAMOUNT',
                text: '금액',
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
                summaryType: 'sum',
                summaryRenderer: function (value, summaryData, dataIndex) {
                    var data = Ext.getStore(gridnms["store.1"]).getData().items;
                    var total = 0;
                    for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                        var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                        if (record.CARTYPENAME == '기종별 소계') {
                            total += (extExtractValues(data, dataIndex)[i] * 1);
                        }
                    }
                    var result = [total].map(function (val, index) {
                        return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val / 1000, '0,000') + '</div>';
                    }).join('<br />');
                    return result;
                },
                renderer: function (value, meta, record) {
                    var model = record.data.CARTYPENAME;
                    if (model == "기종별 소계") {
                        meta.style = " color: blue; ";
                        meta.style += " font-weight: bold; ";
                        //                     meta.style += " font-size: 15px !important;";
                    } else if (model == "품목별 소계") {
                        meta.style = " color: red; ";
                        meta.style += " font-weight: bold; ";
                        meta.style += " border-bottom: 1px dashed blue; ";
                        //                     meta.style += " font-size: 15px !important;";
                    }
                    return Ext.util.Format.number(value / 1000, '0,000');
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
                style: 'text-align:center; ',
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                summaryType: 'sum',
                summaryRenderer: function (value, summaryData, dataIndex) {
                    var data = Ext.getStore(gridnms["store.1"]).getData().items;
                    var total = 0;
                    for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                        var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                        if (record.CARTYPENAME == '기종별 소계') {
                            total += (extExtractValues(data, dataIndex)[i] * 1);
                        }
                    }
                    var result = [total].map(function (val, index) {
                        return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val, '0,000') + '</div>';
                    }).join('<br />');
                    return result;
                },
                renderer: function (value, meta, record) {
                    var model = record.data.CARTYPENAME;
                    if (model == "기종별 소계") {
                        meta.style = " color: blue; ";
                        meta.style += " font-weight: bold; ";
                        //                     meta.style += " font-size: 15px !important;";
                    } else if (model == "품목별 소계") {
                        meta.style = " color: red; ";
                        meta.style += " font-weight: bold; ";
                        meta.style += " border-bottom: 1px dashed blue; ";
                        //                     meta.style += " font-size: 15px !important;";
                    }
                    return Ext.util.Format.number(value, '0,000');
                },
            }, ],
    });

    for (var i = 0; i < 12; i++) {
        (function (x) {
            var rn = (x + 1) + "";
            var qty_index = fn_lpad(rn, 2, '0');
            fields["columns.1"].push({
                text: rn + '월',
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center;',
                align: "right",
                cls: 'ERPQTY',
                columns: [{
                        dataIndex: 'MO' + rn,
                        text: '금액',
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
                        summaryType: 'sum',
                        summaryRenderer: function (value, summaryData, dataIndex) {
                            var data = Ext.getStore(gridnms["store.1"]).getData().items;
                            var total = 0;
                            for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                                var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                                if (record.CARTYPENAME == '기종별 소계') {
                                    total += (extExtractValues(data, dataIndex)[i] * 1);
                                }
                            }
                            var result = [total].map(function (val, index) {
                                return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val / 1000, '0,000') + '</div>';
                            }).join('<br />');
                            return result;
                        },
                        renderer: function (value, meta, record) {
                            var model = record.data.CARTYPENAME;
                            if (model == "기종별 소계") {
                                meta.style = " color: blue; ";
                                meta.style += " font-weight: bold; ";
                                //                             meta.style += " font-size: 15px !important;";
                            } else if (model == "품목별 소계") {
                                meta.style = " color: red; ";
                                meta.style += " font-weight: bold; ";
                                meta.style += " border-bottom: 1px dashed blue; ";
                                //                             meta.style += " font-size: 15px !important;";
                            }
                            return Ext.util.Format.number(value / 1000, '0,000');
                        },
                    }, {
                        dataIndex: 'MOQ' + rn,
                        text: '수량',
                        xtype: 'gridcolumn',
                        width: 60,
                        hidden: false,
                        sortable: false,
                        resizable: true,
                        menuDisabled: true,
                        style: 'text-align:center; ',
                        align: "right",
                        cls: 'ERPQTY',
                        format: "0,000",
                        summaryType: 'sum',
                        summaryRenderer: function (value, summaryData, dataIndex) {
                            var data = Ext.getStore(gridnms["store.1"]).getData().items;
                            var total = 0;
                            for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                                var record = Ext.getStore(gridnms["store.1"]).getData().items[i].data;
                                if (record.CARTYPENAME == '기종별 소계') {
                                    total += (extExtractValues(data, dataIndex)[i] * 1);
                                }
                            }
                            var result = [total].map(function (val, index) {
                                return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 15px; color: red; '>" + Ext.util.Format.number(val, '0,000') + '</div>';
                            }).join('<br />');
                            return result;
                        },
                        renderer: function (value, meta, record) {
                            var model = record.data.CARTYPENAME;
                            if (model == "기종별 소계") {
                                meta.style = " color: blue; ";
                                meta.style += " font-weight: bold; ";
                                //                             meta.style += " font-size: 15px !important;";
                            } else if (model == "품목별 소계") {
                                meta.style = " color: red; ";
                                meta.style += " font-weight: bold; ";
                                meta.style += " border-bottom: 1px dashed blue; ";
                                //                             meta.style += " font-size: 15px !important;";
                            }
                            return Ext.util.Format.number(value, '0,000');
                        },
                    }
                ],
            });

        })(i);
    }

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/eis/CustSalesResultList.do' />"
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
                height: 696,
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
                    itemId: 'EisCustSalesResultList',
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
    };

    setValues(searchyear);
    Ext.suspendLayouts();
    Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
    Ext.resumeLayouts(true);
    extGridSearch(sparams, gridnms["store.1"]);
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
                <div id="gridArea" style="width: 100%; padding-bottom: 5px; margin-bottom: 5px; float: left;"></div>
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