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
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    setLovList();
    setReadOnly();
});

function setInitial() {
    gridnms["app"] = "cost";

    calender($('#searchDate'));

    $('#searchDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $("#searchDate").val(getToDay("${searchVO.dateFrom}") + "");
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_master();
    setValues_detail();
}

function setValues_master() {
    gridnms["models.master"] = [];
    gridnms["stores.master"] = [];
    gridnms["views.master"] = [];
    gridnms["controllers.master"] = [];

    gridnms["grid.1"] = "CostStdPoMaster";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.master"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.master"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

    gridnms["models.master"].push(gridnms["model.1"]);

    gridnms["stores.master"].push(gridnms["store.1"]);

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
            name: 'CUSTOMERTYPE',
        }, {
            type: 'string',
            name: 'CUSTOMERTYPENAME',
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
            name: 'PREQTY',
        }, {
            type: 'number',
            name: 'PRETOTAL',
        }, {
            type: 'number',
            name: 'POSTQTY',
        }, {
            type: 'number',
            name: 'POSTTOTAL',
        }, {
            type: 'number',
            name: 'POSTMONTHQTY',
        }, {
            type: 'number',
            name: 'POSTMONTHSUPPLY',
        }, {
            type: 'number',
            name: 'POSTMONTHADDTAX',
        }, {
            type: 'number',
            name: 'POSTMONTHTOTAL',
        }, ];

    fields["columns.1"] = [
        // Display Columns
        {
            dataIndex: 'RN',
            text: '순번',
            xtype: 'gridcolumn',
            width: 55,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'LICENSENO',
            text: '사업자번호',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'CUSTOMERNAME',
            text: '거래처명',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'CUSTOMERTYPENAME',
            text: '거래처분류',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            text: '전일입고누계',
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            columns: [{
                    dataIndex: 'PREQTY',
                    text: '수량',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'PRETOTAL',
                    text: '금액',
                    xtype: 'gridcolumn',
                    width: 120,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "right",
                    cls: 'ERPQTY',
                    format: "0,000",
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, ]
        }, {
            text: '당일입고실적',
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            columns: [{
                    dataIndex: 'POSTQTY',
                    text: '수량',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'POSTTOTAL',
                    text: '금액',
                    xtype: 'gridcolumn',
                    width: 120,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "right",
                    cls: 'ERPQTY',
                    format: "0,000",
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, ]
        }, {
            text: '당월입고누계',
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            columns: [{
                    dataIndex: 'POSTMONTHQTY',
                    text: '수량',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'POSTMONTHSUPPLY',
                    text: '공급가액',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'POSTMONTHADDTAX',
                    text: '부가세',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'POSTMONTHTOTAL',
                    text: '합계금액',
                    xtype: 'gridcolumn',
                    width: 120,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "right",
                    cls: 'ERPQTY',
                    format: "0,000",
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, ]
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/cost/std/CostStdPoList.do' />"
    });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#MasterClick": {
            itemclick: 'MasterClick'
        }
    });

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

function MasterClick(dataview, record, item, index, e, eOpts) {
    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var customercode = record.data.CUSTOMERCODE;

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TRXDATEFROM: $('#searchDate').val(),
        CUSTOMERCODE: customercode,
    };
    extGridSearch(sparams, gridnms["store.2"]);
}

function setValues_detail() {
    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.2"] = "CostStdPoDetail";

    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
    gridnms["views.detail"].push(gridnms["panel.2"]);

    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
    gridnms["controllers.detail"].push(gridnms["controller.2"]);

    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

    gridnms["models.detail"].push(gridnms["model.2"]);

    gridnms["stores.detail"].push(gridnms["store.2"]);

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
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'ITEMNAME',
        }, {
            type: 'string',
            name: 'ORDERNAME',
        }, {
            type: 'string',
            name: 'MODEL',
        }, {
            type: 'string',
            name: 'MODELNAME',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARD',
        }, {
            type: 'string',
            name: 'MATERIALTYPE',
        }, {
            type: 'number',
            name: 'UNITPRICE',
        }, {
            type: 'string',
            name: 'ITEMTYPE',
        }, {
            type: 'string',
            name: 'ITEMTYPENAME',
        }, {
            type: 'date',
            name: 'TRANSDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'number',
            name: 'TRANSQTY',
        }, {
            type: 'date',
            name: 'CONFIRMDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'number',
            name: 'CONFIRMQTY',
        }, {
            type: 'number',
            name: 'TRANSSUPPLYPRICE',
        }, {
            type: 'number',
            name: 'TRANSADDITIONALTAX',
        }, {
            type: 'number',
            name: 'TRANSAMOUNT',
        }, ];

    fields["columns.2"] = [
        // Display Columns
        {
            dataIndex: 'RN',
            text: '순번',
            xtype: 'rownumberer',
            width: 55,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
        }, {
            text: '품목정보',
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            columns: [{
                    dataIndex: 'ITEMNAME',
                    text: '품명',
                    xtype: 'gridcolumn',
                    width: 250,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "left",
                }, {
                    dataIndex: 'ORDERNAME',
                    text: '품번',
                    xtype: 'gridcolumn',
                    width: 120,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                }, {
                    dataIndex: 'ITEMSTANDARD',
                    text: '규격',
                    xtype: 'gridcolumn',
                    width: 120,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                }, {
                    dataIndex: 'MATERIALTYPE',
                    text: '재질',
                    xtype: 'gridcolumn',
                    width: 120,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                }, {
                    dataIndex: 'UOMNAME',
                    text: '단위',
                    xtype: 'gridcolumn',
                    width: 50,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                }, {
                    dataIndex: 'UNITPRICE',
                    text: '단가',
                    xtype: 'gridcolumn',
                    width: 90,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "right",
                    cls: 'ERPQTY',
                    format: "0,000",
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'ITEMTYPENAME',
                    text: '유형',
                    xtype: 'gridcolumn',
                    width: 100,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                }, ]
        }, {
            text: '입고현황',
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            columns: [{
                    dataIndex: 'TRANSDATE',
                    text: '입고일',
                    xtype: 'datecolumn',
                    width: 95,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                    format: 'Y-m-d',
                }, {
                    dataIndex: 'TRANSQTY',
                    text: '입고수량',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'CONFIRMDATE',
                    text: '확정일',
                    xtype: 'datecolumn',
                    width: 95,
                    hidden: false,
                    sortable: false,
                    resizable: false,
                    menuDisabled: true,
                    style: 'text-align:center;',
                    align: "center",
                    format: 'Y-m-d',
                }, {
                    dataIndex: 'CONFIRMQTY',
                    text: '확정수량',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'TRANSSUPPLYPRICE',
                    text: '공급가액',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'TRANSADDITIONALTAX',
                    text: '부가세',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'TRANSAMOUNT',
                    text: '합계금액',
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
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, ]
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/cost/std/CostStdPoListDetail.do' />"
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

var gridarea, gridarea1;
function setExtGrid() {
    setExtGrid_master();
    setExtGrid_detail();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
        gridarea1.updateLayout();
    });
}

function setExtGrid_master() {
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
                                ORGID: $('#searchOrgId').val(),
                                COMPANYID: $('#searchCompanyId').val(),
                                TRXDATEFROM: $('#searchDate').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        },
                        listeners: {
                            load: function (dataStore, rows, bool) {
                                var cnt = rows.length;
                                if (cnt > 0) {
                                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.master"]).getSelectionModel().select(0));
                                    var model = Ext.getCmp(gridnms["views.master"]).selModel.getSelection()[0];

                                    var orgid = model.data.ORGID;
                                    var companyid = model.data.COMPANYID;
                                    var customercode = model.data.CUSTOMERCODE;

                                    var params = {
                                        ORGID: orgid,
                                        COMPANYID: companyid,
                                        TRXDATEFROM: $('#searchDate').val(),
                                        CUSTOMERCODE: customercode,
                                    };
                                    extGridSearch(params, gridnms["store.2"]);
                                } else {
                                    Ext.getStore(gridnms['store.2']).removeAll();
                                }
                            },
                            scope: this
                        },
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            MasterClick: '#MasterClick',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        MasterClick: MasterClick,
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
                height: 423,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                viewConfig: {
                    itemId: 'MasterClick',
                    trackOver: true,
                    loadMask: true,
                    striptRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('CUSTOMERTYPENAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 80) {
                                        column.width = 80;
                                    }
                                }
                            });
                        }
                    },
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
        models: gridnms["models.master"],
        stores: gridnms["stores.master"],
        views: gridnms["views.master"],
        controllers: gridnms["controller.1"],

        launch: function () {
            gridarea = Ext.create(gridnms["views.master"], {
                renderTo: 'gridArea'
            });
        },
    });

}

function setExtGrid_detail() {
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
                        isStore: false,
                        autoDestroy: true,
                        clearOnPageLoad: true,
                        clearRemovedOnLoad: true,
                        pageSize: 9999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.2"],
                            timeout: gridVals.timeout,
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
            DetailList: '#DetailList',
        },
        stores: [gridnms["store.2"]],
        //           control : items["btns.ctr.2"],
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
                scrollable: true,
                columns: fields["columns.2"],
                viewConfig: {
                    itemId: 'DetailList',
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ITEMSTANDARD') >= 0 || column.dataIndex.indexOf('MATERIALTYPE') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 80) {
                                        column.width = 80;
                                    }
                                }
                            });
                        }
                    },
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
        models: gridnms["models.detail"],
        stores: gridnms["stores.detail"],
        views: gridnms["views.detail"],
        controllers: gridnms["controller.2"],

        launch: function () {
            gridarea1 = Ext.create(gridnms["views.detail"], {
                renderTo: 'gridDetailArea'
            });
        },
    });
}
function fn_ready() {
    extAlert("준비중입니다...");
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchDate = $('#searchDate').val();
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

    if (searchDate == "") {
        header.push("기준일");
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
    var searchDate = $('#searchDate').val();
    var customercode = $('#CustomerCode').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TRXDATEFROM: searchDate,
        CUSTOMERCODE: customercode,
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_excel_download() {
    if (!fn_validation()) {
        return;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchDate = $('#searchDate').val();
    var customercode = $('#CustomerCode').val();
    var title = $('#title').val();

    go_url("<c:url value='/cost/std/CostStdPoListExcelDownload.do?ORGID='/>" + orgid + ""
         + "&COMPANYID=" + companyid + ""
         + "&TRXDATEFROM=" + searchDate + ""
         + "&CUSTOMERCODE=" + customercode + ""
         + "&TITLE=" + "${pageTitle}" + "");
}

function fn_excel_download2(){
	 if (!fn_validation()) {
	      return;
	    }

	    var orgid = $('#searchOrgId option:selected').val();
	    var companyid = $('#searchCompanyId option:selected').val();
	    var searchDate = $("#searchDate").val();
	    var searchCustomerCode = $("#CustomerCode").val();
	    var title = "매입현황 자동전표";

	    go_url("<c:url value='/cost/std/ExcelDownload.do?GUBUN='/>" + "POIF"
	       + "&ORGID=" + orgid + ""
	       + "&COMPANYID=" + companyid + ""
	       + "&SEARCHDATE=" + searchDate + ""
	       + "&CUSTOMERCODE=" + searchCustomerCode + ""
	       + "&TITLE=" + title + "");
}

function setLovList() {
    // 거래처명 lov
    $("#CustomerName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#CustomerCode").val("");

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
            $.getJSON("<c:url value='/searchCustomernameLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
                CUSTOMERTYPE3: 'S',
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.VALUE,
                            label: m.LABEL + ", " + m.CUSTOMERTYPENAME + ", " + m.ADDRESS,
                            NAME: m.LABEL,
                            ADDRESS: m.ADDRESS,
                            FREIGHT: m.FREIGHT,
                            PHONENUMBER: m.PHONENUMBER,
                            UNITPRICEDIV: m.UNITPRICEDIV,
                            UNITPRICEDIVNAME: m.UNITPRICEDIVNAME,
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
            $("#CustomerCode").val(o.item.value);
            $("#CustomerName").val(o.item.NAME);

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
                        <li>자재 관리</li>
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
                    <input type="hidden" id="title" name="title" value="${pageTitle}" />
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
<!--                                             <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a> -->
                                            <a id="btnChk3" class="btn_download" href="#" onclick="javascript:fn_excel_download2();"> 회계 I/F </a>
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
                                <th class="required_text">기준일</th>
                                <td>
                                    <input type="text" id="searchDate" name="searchDate" class="input_validation input_center" style="width: 120px;" maxlength="10" />
                                </td>
                                <th class="required_text">거래처명</th>
                                <td>
                                      <input type="text" id="CustomerName" name="CustomerName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                                      <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                </td>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                        </table>
                    </form>
                </fieldset>
            </div>
            <!-- //검색 필드 박스 끝 -->

            <div style="width: 100%;">
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3">1. 매입 현황 요약</div></td>
                    </tr>
                </table>
                <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                <br>&nbsp;<br>
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3">2. 매입 현황 상세</div></td>
                    </tr>
                </table>
                <div id="gridDetailArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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