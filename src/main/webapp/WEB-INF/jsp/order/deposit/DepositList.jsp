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

    $("#SoStatus").val("STAND BY");

    setReadOnly();

    setLovList();
});

function setInitial() {
    gridnms["app"] = "order";

    setTimeout(function () {
        if ("${isExcelUploaded}" === "true") {
            extAlert("${msg}");
        }
    }, 2000);

    $("#excelform").validationEngine('attach');

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

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_master();
    setValues_detail();
}

function setValues_master() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "DepositList";

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
            name: 'TAXINVOICENO',
        }, {
            type: 'date',
            name: 'INVOICEDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'number',
            name: 'SUPPLYPRICE',
        }, {
            type: 'number',
            name: 'ADDITIONALTAX',
        }, {
            type: 'number',
            name: 'TOTAL',
        }, {
            type: 'date',
            name: 'DEPOSITDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'number',
            name: 'DEPOSITPRICE',
        }, {
            type: 'string',
            name: 'ETAX',
        }, {
            type: 'string',
            name: 'REPORTNUMBER',
        }, {
            type: 'string',
            name: 'DIRECTION',
        }, {
            type: 'string',
            name: 'DIRECTIONNAME',
        }, {
            type: 'string',
            name: 'SALESBUYTYPE',
        }, {
            type: 'string',
            name: 'SALESBUYTYPENAME',
        }, {
            type: 'string',
            name: 'TAXTYPE',
        }, {
            type: 'string',
            name: 'TAXTYPENAME',
        }, {
            type: 'string',
            name: 'CHARGETYPE',
        }, {
            type: 'string',
            name: 'CHARGETYPENAME',
        }, {
            type: 'string',
            name: 'DOCUNUMBER',
        }, {
            type: 'string',
            name: 'ISSUENUMBER',
        }, {
            type: 'string',
            name: 'SERIALNUMBER',
        }, {
            type: 'string',
            name: 'ITEMNAME',
        }, ];

    fields["columns.1"] = [
        // Display columns
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
            dataIndex: 'TAXINVOICENO',
            text: '세금계산서번호',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
                var result = '<div><a href="{0}">{1}</a></div>';
                var url = "<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + record.data.TAXINVOICENO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
                return Ext.String.format(result, url, value);
            }
        }, {
            dataIndex: 'INVOICEDATE',
            text: '발행일',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
                var result = '<div><a href="{0}">{1}</a></div>';
                var url = "<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + record.data.TAXINVOICENO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
                return Ext.String.format(result, url, Ext.util.Format.date(value, 'Y-m-d'));
            },
        }, {
            dataIndex: 'CUSTOMERNAME',
            text: '거래처',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
                var result = '<div><a href="{0}">{1}</a></div>';
                var url = "<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + record.data.TAXINVOICENO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
                return Ext.String.format(result, url, value);
            },
        }, {
            dataIndex: 'SUPPLYPRICE',
            text: '공급가',
            xtype: 'gridcolumn',
            width: 115,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ADDITIONALTAX',
            text: '부가세',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTAL',
            text: '합계',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'DEPOSITDATE',
            text: '입금일자',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'DEPOSITPRICE',
            text: '입금금액',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ETAX',
            text: '전자세금계산서 번호',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
        }, {
		        dataIndex: 'DIRECTIONNAME',
		        text: '방향',
		        xtype: 'gridcolumn',
		        width: 100,
		        hidden: false,
		        sortable: true,
		        resizable: true,
		        menuDisabled: true,
		        style: 'text-align:center',
		        align: "center",
		    }, {
		        dataIndex: 'SALESBUYTYPENAME',
		        text: '입/출구분',
		        xtype: 'gridcolumn',
		        width: 100,
		        hidden: false,
		        sortable: true,
		        resizable: true,
		        menuDisabled: true,
		        style: 'text-align:center',
		        align: "center",
		    }, {
		        dataIndex: 'TAXTYPENAME',
		        text: '과세구분',
		        xtype: 'gridcolumn',
		        width: 100,
		        hidden: false,
		        sortable: true,
		        resizable: true,
		        menuDisabled: true,
		        style: 'text-align:center',
		        align: "center",
		    }, {
		        dataIndex: 'CHARGETYPENAME',
		        text: '영수/청구',
		        xtype: 'gridcolumn',
		        width: 100,
		        hidden: false,
		        sortable: true,
		        resizable: true,
		        menuDisabled: true,
		        style: 'text-align:center',
		        align: "center",
		    }, {
		        dataIndex: 'DOCUNUMBER',
		        text: '권번호',
		        xtype: 'gridcolumn',
		        width: 100,
		        hidden: false,
		        sortable: true,
		        resizable: true,
		        menuDisabled: true,
		        style: 'text-align:center',
		        align: "center",
		    }, {
		        dataIndex: 'ISSUENUMBER',
		        text: '호번호',
		        xtype: 'gridcolumn',
		        width: 100,
		        hidden: false,
		        sortable: true,
		        resizable: true,
		        menuDisabled: true,
		        style: 'text-align:center',
		        align: "center",
		    }, {
		        dataIndex: 'SERIALNUMBER',
		        text: '일련번호',
		        xtype: 'gridcolumn',
		        width: 100,
		        hidden: false,
		        sortable: true,
		        resizable: true,
		        menuDisabled: true,
		        style: 'text-align:center',
		        align: "center",
		    }, {
            dataIndex: 'REPORTNUMBER',
            text: '신고번호',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
		        dataIndex: 'ITEMNAME',
		        text: '대표품목',
		        xtype: 'gridcolumn',
		        width: 100,
		        hidden: false,
		        sortable: true,
		        resizable: true,
		        menuDisabled: true,
		        style: 'text-align:center',
		        align: "center",
		    }, 
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/order/deposit/OrderDepositListMaster.do' />"
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
    var taxno = record.data.TAXINVOICENO;

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TAXINVOICENO: taxno,
    };
    extGridSearch(sparams, gridnms["store.2"]);
}

function setValues_detail() {
    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.2"] = "DepositListDetail";

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
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
            type: 'number',
            name: 'TAXINVOICENO',
        }, {
            type: 'number',
            name: 'TAXINVOICESEQ',
        }, {
            type: 'string',
            name: 'SMALLNAME',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'number',
            name: 'SUPPLYPRICE',
        }, {
            type: 'number',
            name: 'ADDITIONALTAX',
        }, {
            type: 'number',
            name: 'TOTAL',
        }, {
            type: 'date',
            name: 'DEPOSITDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, ];

    fields["columns.2"] = [
        // Display columns
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
            cls: 'ERPQTY',
            format: "0,000",
        }, {
            dataIndex: 'DEPOSITDATE',
            text: '입금일자',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'SUPPLYPRICE',
            text: '공급가',
            xtype: 'gridcolumn',
            width: 115,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ADDITIONALTAX',
            text: '부가세',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTAL',
            text: '합계',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'TAXINVOICENO',
            xtype: 'hidden',
        }, {
            dataIndex: 'TAXINVOICESEQ',
            xtype: 'hidden',
        }, ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/order/deposit/OrderDepositListDetail.do' />"
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

var gridarea1, gridarea2;
function setExtGrid() {
    setExtGrid_master();
    setExtGrid_detail();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea1.updateLayout();
        gridarea2.updateLayout();
    });
}

function setExtGrid_master() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"]
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
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                DATEFROM: $('#searchFrom').val(),
                                DATETO: $('#searchTo').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true,
                            }),
                        },
                        listeners: {
                            load: function (dataStore, rows, bool) {
                                var cnt = rows.length;
                                if (cnt > 0) {
                                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(0));
                                    var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                                    var orgid = model.data.ORGID;
                                    var companyid = model.data.COMPANYID;
                                    var taxno = model.data.TAXINVOICENO;

                                    var sparams = {
                                        ORGID: orgid,
                                        COMPANYID: companyid,
                                        TAXINVOICENO: taxno,
                                    };
                                    extGridSearch(sparams, gridnms["store.2"]);
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
                height: 401,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                plugins: [{
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20,
                        leadingBufferZone: 20,
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'MasterClick',
                    trackOver: true,
                    loadMask: true,
                    striptRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 150) {
                                        column.width = 150;
                                    }
                                }
                                if (column.dataIndex.indexOf('REPORTNUMBER') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 150) {
                                        column.width = 150;
                                    }
                                }

                                if (column.dataIndex.indexOf('SERIALNUMBER') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 100) {
                                        column.width = 100;
                                    }
                                }
                                if (column.dataIndex.indexOf('ITEMNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 100) {
                                        column.width = 100;
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
        models: gridnms["models.list"],
        stores: gridnms["stores.list"],
        views: gridnms["views.list"],
        controllers: gridnms["controller.1"],

        launch: function () {
            gridarea1 = Ext.create(gridnms["views.list"], {
                renderTo: 'gridArea'
            });
        },
    });
}

function setExtGrid_detail() {
    Ext.define(gridnms["model.2"], {
        extend: Ext.data.Model,
        fields: fields["model.2"]
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
                                writeAllFields: true,
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.2"], {
        extend: Ext.app.Controller,
        refs: {
            OrderDetailList: '#OrderDetailList',
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
                height: 200,
                border: 2,
                scrollable: true,
                columns: fields["columns.2"],
                defaults: gridVals.defaultField,
                plugins: [{
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20,
                        leadingBufferZone: 20,
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'OrderDetailList',
                    trackOver: true,
                    loadMask: true,
                    striptRows: true,
                    forceFit: true,
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
            gridarea2 = Ext.create(gridnms["views.detail"], {
                renderTo: 'gridArea2'
            });
        },
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var datefrom = $('#searchFrom').val();
    var dateto = $('#searchTo').val();
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

    if (datefrom === "") {
        header.push("발행일 From");
        count++;
    }

    if (dateto === "") {
        header.push("발행일 To");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력(선택)해주세요.");
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
    var datefrom = $('#searchFrom').val();
    var dateto = $('#searchTo').val();
    var customercode = $('#CustomerCode').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        DATEFROM: datefrom,
        DATETO: dateto,
        CUSTOMERCODE: customercode,
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_save() {
    go_url("<c:url value='/order/deposit/DepositRegist.do' />");
}

function fn_excel_upload() {
    if (!valid_chk("excelform"))
        return;

    document.excelform.action = "<c:url value='/order/deposit/ExcelUpload.do'/>";
    document.excelform.submit();
}

function fn_excel_sample() {
    go_url("<c:url value='/uploadfiles/excel/template/DepositUploadSample.xlsx' />");
}

function fn_ready() {
    extAlert("준비중입니다...");
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
                CUSTOMERTYPE1: 'S',
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
                            <li>수금관리</li>
                            <li>&gt;</li>
                            <li><strong>${pageTitle}</strong></li>
                        </ul>
                    </div>
                </div>
                <!-- 검색 필드 박스 시작 -->
                <div id="search_field" style="margin-bottom: 5px;">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                    <fieldset>
                        <legend>조건정보 영역</legend>
                        <table class="tbl_type_view" border="0">
                            <colgroup>
                                <col width="20%">
                                <col width="20%">
                                <col width="60%">
                            </colgroup>
                            <tr style="height: 34px;">
                                <td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 70%;">
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
                                <td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 70%; visibility: hidden;">
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
                                <td colspan="6">
                                        <div class="buttons" style="float: right; margin-top: 3px;">
                                            <a id="btnChk4" class="btn_download" href="#" onclick="javascript:fn_excel_sample();">
                                               샘플 다운로드
                                            </a>
                                            <a id="btnChk3" class="btn_upload" href="#" onclick="javascript:fn_excel_upload();">
                                               업로드
                                            </a>
                                            <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
                                               조회
                                            </a>
                                            <a id="btnChk2" class="btn_add" href="#" onclick="javascript:fn_save();">
                                               추가
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
                                <th class="required_text">발행일자</th>
                                <td >
                                    <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center " style="width: 90px; " maxlength="10" />
                                    &nbsp;~&nbsp;
                                    <input type="text" id="searchTo" name="searchTo" class="input_validation input_center " style="width: 90px; " maxlength="10"  />
                                </td>
                                <th class="required_text">거래처명</th>
                                <td>
                                      <input type="text" id="CustomerName" name="CustomerName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                                      <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                </td>
                            </tr>
                            <tr style="height: 34px;">
                                <td colspan="8" style="margin: 0px; padding: 0px;">
                                      <form id="excelform" name="excelform" method="post" enctype="multipart/form-data">
                                      <div><input type="file" id="excelfile" name="excelfile" class="validate[required] btn btn-primary start" style="width: 100%; padding: 2px; border: 2px solid #81B1D5; float: left; overflow: auto;" /></div>
                                      </form>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">기본 정보</div></td>
                    </tr>
                </table>
                <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                
                <table style="width: 100%;">
                    <tr>
                        <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">상세 정보</div></td>
                    </tr>
                </table>
                <div id="gridArea2" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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