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

    $("#gridPopup1Area").hide("blind", {
        direction: "up"
    }, "fast");

    setReadOnly();

    setLovList();
});

function setInitial() {
    gridnms["app"] = "prod";
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

    $("#searchDate").val(getToDay("${searchVO.dateSys}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });
}

var colIdx = 0, rowIdx = 0;
var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_list();
    setValues_Popup();
}

function setValues_list() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "WorkOrderEquipmentList";

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
            name: 'WORKDEPT',
        }, {
            type: 'string',
            name: 'WORKDEPTNAME',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, {
            type: 'string',
            name: 'OPERATEYN',
        }, {
            type: 'string',
            name: 'SOWOYN',
        }, {
            type: 'string',
            name: 'BTNDISABLEDYN',
        }, {
            type: 'string',
            name: 'SEQ',
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
            type: 'string',
            name: 'MODEL',
        }, {
            type: 'string',
            name: 'MODELNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARDDETAIL',
        }, {
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'string',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'SEQNO',
        }, {
            type: 'string',
            name: 'ROUTINGID',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'string',
            name: 'EMPLOYEENUMBER',
        }, {
            type: 'string',
            name: 'KRNAME',
        }, {
            type: 'string',
            name: 'QTY',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'date',
            name: 'STARTTIME',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'date',
            name: 'ENDTIME',
            dateFormat: 'Y-m-d H:i',
        },
    ];

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
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'XXXXXXXXXX',
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '',
            width: 85,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "수주연결",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    btnSel1(record.data);
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            },
            onWidgetAttach: function (col, widget, rec) {
                // 버튼 활성화/비활성화
                if (rec.data.BTNDISABLEDYN == "Y") {
                    widget.setDisabled(false);
                } else {
                    widget.setDisabled(true);
                }
                col.mon(col.up('gridpanel').getView(), {
                    itemupdate: function () {
                        if (rec.data.BTNDISABLEDYN == "Y") {
                            widget.setDisabled(false);
                        } else {
                            widget.setDisabled(true);
                        }
                    }
                });
            },
        }, {
            dataIndex: 'WORKDEPTNAME',
            text: '모니터<br/>번호',
            xtype: 'gridcolumn',
            width: 65,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비번호',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'XXXXXXXXXX1',
            text: '가동유무',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                var emptyValue = "";
                var operateyn = record.data.OPERATEYN;
                meta.style = "background-color: " + operateyn + "; ";
                return emptyValue;
            },
        }, {
            dataIndex: 'XXXXXXXXXX2',
            text: '수주 /<br/>작지 유',
            xtype: 'gridcolumn',
            width: 65,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                var emptyValue = "";
                var operateyn = record.data.SOWOYN;
                meta.style = "background-color: " + operateyn + "; ";
                return emptyValue;
            },
        }, {
            dataIndex: 'ORDERNAME',
            text: '품번',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
//             width: 280,
            flex: 1,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'MODELNAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            text: '타입',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKORDERID',
            text: '작업지시번호',
            xtype: 'gridcolumn',
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '공정명',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'KRNAME',
            text: '작업자',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'QTY',
            text: '생산수량',
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
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'SONO',
            text: '수주번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'STARTTIME',
            text: '투입일자',
            xtype: 'datecolumn',
            width: 125,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d H:i',
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d H:i');
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
            dataIndex: 'WORKDEPT',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'OPERATEYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'BTNDISABLEDYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'SEQNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'EMPLOYEENUMBER',
            xtype: 'hidden',
        }, {
            dataIndex: 'ENDTIME',
            xtype: 'hidden',
        },
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/prod/work/WorkOrderEquipmentList.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push(
        '->');
    items["btns.1"].push(
        '<table>' +
        '<colgroup>' +
        '<col width="30px">' +
        '<col width="80px">' +
        '<col width="80px">' +
        '<col width="80px">' +
        '<col width="80px">' +
        '<col width="80px">' +
        '<col width="80px">' +
        '</colgroup>' +
        '<tr>' +
        '<td>' +
        '<strong>범례: </strong>' +
        '</td>' +
        '<td style="width: 80px; height: 15px; background-color: #0BE710; "></td>' +
        '<td style="text-align: left;">&nbsp;&nbsp;가동중 </td>' +
        '<td style="width: 80px; height: 15px; background-color: #FFFF00; border: solid 1px; "></td>' +
        '<td style="text-align: left;">&nbsp;&nbsp;미입력 </td>' +
        '<td style="width: 80px; height: 15px; background-color: #FF0000; "></td>' +
        '<td style="text-align: left;">&nbsp;&nbsp;작업지시(작업자) </td>' +
        '</tr>' +
        '</table>');

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#WorkOrderEquipmentList": {
            itemclick: 'onMasterClick',
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
    items["docked.1"].push(items["dock.btn.1"]);
}

var global_record = {};
function onMasterClick(dataview, record, item, index, e, eOpts) {
    rowIdx = e.position.rowIdx;
    colIdx = e.position.colIdx;
    var dataIndex = e.position.column.dataIndex;

    global_record = record.data;
}

var gridarea;
function setExtGrid() {
    setExtGrid_list();
    setExtGrid_Popup();

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
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                SEARCHDATE: $('#searchDate').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        },
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            WorkOrderEquipmentList: '#WorkOrderEquipmentList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        onMasterClick: onMasterClick,
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
                height: 653,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                plugins: [{
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20, // #1
                        leadingBufferZone: 20, // #2
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'WorkOrderEquipmentList',
                    trackOver: true,
                    loadMask: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if ( column.dataIndex.indexOf('ITEMSTANDARDDETAIL') >= 0 ) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 80) {
                                        column.width = 80;
                                    }
                                }
                                if ( column.dataIndex.indexOf('ORDERNAME') >= 0 ) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 120) {
                                        column.width = 120;
                                    }
                                }
                                if ( /* column.dataIndex.indexOf('ITEMNAME') >= 0 || */ column.dataIndex.indexOf('MODELNAME') >= 0 ) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 150) {
                                        column.width = 150;
                                    }
                                }
                            });
                        }
                    },
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        triggerEvent: 'cellclick',
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
        header.push("기준일자");
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

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHDATE: searchDate,
        WORKCENTERNAME: $('#searchWorkCenterName').val(),
        ORDERNAME: $('#searchOrderName').val(),
        ITEMNAME: $('#searchItemName').val(),
        MODELNAME: $('#searchModelName').val(),
        ITEMSTANDARDDETAIL: $('#searchItemStandardD').val(),
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_ready() {
    extAlert("준비중입니다...");
}

// 복사 팝업
function setValues_Popup() {
    gridnms["models.popup1"] = [];
    gridnms["stores.popup1"] = [];
    gridnms["views.popup1"] = [];
    gridnms["controllers.popup1"] = [];

    gridnms["grid.4"] = "Popup1";

    gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
    gridnms["views.popup1"].push(gridnms["panel.4"]);

    gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
    gridnms["controllers.popup1"].push(gridnms["controller.4"]);

    gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];

    gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];

    gridnms["models.popup1"].push(gridnms["model.4"]);

    gridnms["stores.popup1"].push(gridnms["store.4"]);

    fields["model.4"] = [{
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
            name: 'WORKPLANNO',
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
            type: 'string',
            name: 'MODEL',
        }, {
            type: 'string',
            name: 'MODELNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARDDETAIL',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'string',
            name: 'SOSEQ',
        }, {
            type: 'number',
            name: 'SOQTY',
        }, ];

    fields["columns.4"] = [
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
            cls: 'ERPQTY',
            format: "0,000",
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
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 230,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'MODELNAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            text: '타입',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'SONO',
            text: '수주번호',
            xtype: 'gridcolumn',
            width: 125,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'SOSEQ',
            text: '수주순번',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'SOQTY',
            text: '수량',
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
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'XXXXXXXXXX',
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            width: 70,
            text: '',
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "적용",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var orgid = record.data.ORGID;
                    var companyid = record.data.COMPANYID;
                    var sono = record.data.SONO;
                    var soseq = record.data.SOSEQ;
                    var workplanno = record.data.WORKPLANNO;

                    var params = {
                        ORGID: orgid,
                        COMPANYID: companyid,
                        SONO: sono,
                        SOSEQ: soseq,
                        WORKPLANNO: workplanno,
                        WORKORDERID: global_record.WORKORDERID,
                        ITEMCODE: global_record.ITEMCODE,
                    };

                    fn_popup_closed();

                    $.ajax({
                        url: "<c:url value='/update/prod/work/WorkOrderEquipmentList.do' />",
                        type: "post",
                        dataType: "json",
                        data: params,
                        async: false,
                        success: function (data) {
                            var msgdata = data.msg;
                            extAlert(msgdata);
                            if (!data.success) {
                                return false;
                            } else {
                                fn_search();
                            }
                        },
                        error: ajaxError
                    });
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKPLANNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, ];

    items["api.4"] = {};
    $.extend(items["api.4"], {
        read: "<c:url value='/select/prod/manage/ProdPlanRegistManage.do' />"
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

var gridpopup1;
function setExtGrid_Popup() {
    Ext.define(gridnms["model.4"], {
        extend: Ext.data.Model,
        fields: fields["model.4"],
    });

    Ext.define(gridnms["store.4"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.4"],
                        model: gridnms["model.4"],
                        autoLoad: false,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.4"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#popupOrgId').val(),
                                COMPANYID: $('#popupCompanyId').val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.4"], {
        extend: Ext.app.Controller,
        refs: {
            btnPopup1: '#btnPopup1',
        },
        stores: [gridnms["store.4"]],
    });

    Ext.define(gridnms["panel.4"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.4"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.4"],
                id: gridnms["panel.4"],
                store: gridnms["store.4"],
                height: 565,
                border: 2,
                scrollable: true,
                plugins: [{
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20, // #1
                        leadingBufferZone: 20, // #2
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                columns: fields["columns.4"],
                viewConfig: {
                    itemId: 'btnPopup1',
                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.4"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup1"],
        stores: gridnms["stores.popup1"],
        views: gridnms["views.popup1"],
        controllers: gridnms["controller.4"],

        launch: function () {
            gridpopup1 = Ext.create(gridnms["views.popup1"], {
                renderTo: 'gridPopup1Area'
            });
        },
    });
}

var win1 = "";
function btnSel1(rec) {
    // 수주현황 팝업
    var width = 987; // 가로
    var height = 640; // 세로
    var title = "수주현황 Popup";

    global_record = rec;
    win1 = "";

    var emptyValue = "";
    // 완료 외 상태에서만 팝업 표시하도록 처리
    $('#popupOrgId').val($('#searchOrgId option:selected').val());
    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
    $('#popupOrderName').val(emptyValue);
    $('#popupItemName').val(emptyValue);
    $('#popupModelName').val(emptyValue);
    $('#popupItemStandardD').val(emptyValue);
    Ext.getStore(gridnms['store.4']).removeAll();

    win1 = Ext.create('Ext.window.Window', {
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
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.4"],
                id: gridnms["panel.4"],
                store: gridnms["store.4"],
                height: '100%',
                border: 2,
                scrollable: true,
                frameHeader: true,
                columns: fields["columns.4"],
                viewConfig: {
                    itemId: 'btnPopup1'
                },
                plugins: 'bufferedrenderer',
                dockedItems: items["docked.4"],
            }
        ],
        tbar: [
            '품번', {
                xtype: 'textfield',
                name: 'searchOrderName1',
                clearOnReset: true,
                hideLabel: true,
                width: 150,
                editable: true,
                allowBlank: true,
                listeners: {
                    scope: this,
                    buffer: 50,
                    change: function (value, nv, ov, e) {
                        value.setValue(nv.toUpperCase());
                        var result = value.getValue();

                        $('#popupOrderName').val(result);
                    },
                },
            },
            '품명', {
                xtype: 'textfield',
                name: 'searchItemName1',
                clearOnReset: true,
                hideLabel: true,
                width: 180,
                editable: true,
                allowBlank: true,
                listeners: {
                    scope: this,
                    buffer: 50,
                    change: function (value, nv, ov, e) {
                        value.setValue(nv.toUpperCase());
                        var result = value.getValue();

                        $('#popupItemName').val(result);
                    },
                },
            },
            '기종', {
                xtype: 'textfield',
                name: 'searchModelName1',
                clearOnReset: true,
                hideLabel: true,
                width: 150,
                editable: true,
                allowBlank: true,
                listeners: {
                    scope: this,
                    buffer: 50,
                    change: function (value, nv, ov, e) {
                        value.setValue(nv.toUpperCase());
                        var result = value.getValue();

                        $('#popupModelName').val(result);
                    },
                },
            },
            '타입', {
                xtype: 'textfield',
                name: 'searchItemStandardD1',
                clearOnReset: true,
                hideLabel: true,
                width: 150,
                editable: true,
                allowBlank: true,
                listeners: {
                    scope: this,
                    buffer: 50,
                    change: function (value, nv, ov, e) {
                        value.setValue(nv.toUpperCase());
                        var result = value.getValue();

                        $('#popupItemStandardD').val(result);
                    },
                },
            },
            '->', {
                text: '조회',
                scope: this,
                handler: function () {
                    fn_popup_search();
                }
            }
        ]
    });
    win1.show();

    var ordername = rec.ORDERNAME;
    if (ordername == "" || ordername == undefined) {
        $('input[name=searchOrderName1]').val(emptyValue);
        $('#popupOrderName').val(emptyValue);
        //         $('input[name=searchOrderName1]').attr('disabled', false).removeClass('ui-state-disabled');
    } else {
        $('input[name=searchOrderName1]').val(ordername);
        $('#popupOrderName').val(ordername);
    }
    $('input[name=searchOrderName1]').attr('disabled', true).addClass('ui-state-disabled');

    var itemname = rec.ITEMNAME;
    if (itemname == "" || itemname == undefined) {
        $('input[name=searchItemName1]').val(emptyValue);
        $('#popupItemName').val(emptyValue);
        //         $('input[name=searchItemName1]').attr('disabled', false).removeClass('ui-state-disabled');
    } else {
        $('input[name=searchItemName1]').val(itemname);
        $('#popupItemName').val(itemname);
    }
    $('input[name=searchItemName1]').attr('disabled', true).addClass('ui-state-disabled');

    var modelname = rec.MODELNAME;
    if (modelname == "" || modelname == undefined) {
        $('input[name=searchModelName1]').val(emptyValue);
        $('#popupModelName').val(emptyValue);
        //         $('input[name=searchModelName1]').attr('disabled', false).removeClass('ui-state-disabled');
    } else {
        $('input[name=searchModelName1]').val(modelname);
        $('#popupModelName').val(modelname);
    }
    $('input[name=searchModelName1]').attr('disabled', true).addClass('ui-state-disabled');

    var itemstandarddetail = rec.ITEMSTANDARDDETAIL;
    if (itemstandarddetail == "" || itemstandarddetail == undefined) {
        $('input[name=searchItemStandardD1]').val(emptyValue);
        $('#popupItemStandardD').val(emptyValue);
        //         $('input[name=searchItemStandardD1]').attr('disabled', false).removeClass('ui-state-disabled');
    } else {
        $('input[name=searchItemStandardD1]').val(itemstandarddetail);
        $('#popupItemStandardD').val(itemstandarddetail);
    }
    $('input[name=searchItemStandardD1]').attr('disabled', true).addClass('ui-state-disabled');

    fn_popup_search();
}

function fn_popup_search() {
    var params1 = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        ORDERNAME: $('#popupOrderName').val(),
        ITEMCODE: global_record.ITEMCODE,
        ITEMNAME: $('#popupItemName').val(),
        MODELNAME: $('#popupModelName').val(),
        ITEMSTANDARDDETAIL: $('#popupItemStandardD').val(),
        MULTIWORKORDERYN: 'N',
    };
    extGridSearch(params1, gridnms["store.4"]);
}

function fn_popup_closed() {
    if (win1 != "") {
        win1.close();

        $("#gridPopup1Area").hide("blind", {
            direction: "up"
        }, "fast");
    }
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
                                <li>공정관리</li>
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
                            <input type="hidden" id="popupOrderName" name="popupOrderName" />
                            <input type="hidden" id="popupItemName" name="popupItemName" />
                            <input type="hidden" id="popupModelName" name="popupModelName" />
                            <input type="hidden" id="popupItemStandardD" name="popupItemStandardD" />
                        <form id="master" name="master" action="" method="post">
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
                                        <th class="required_text">기준일자</th>
                                        <td >
                                            <input type="text" id="searchDate" name="searchDate" class="input_validation input_center " style="width: 97%; " maxlength="10" />
                                        </td>
                                        <th class="required_text">설비명</th>
                                        <td>
                                            <input type="text" id="searchWorkCenterName" name="searchWorkCenterName" class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class=" input_left " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
			                                  <th class="required_text">기종</th>
			                                  <td >
			                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
			                                  </td>
                                        <th class="required_text">타입</th>
                                        <td >
                                            <input type="text" id="searchItemStandardD" name="searchItemStandardD"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
            </div>
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 978px; padding-top: 0px; float: left;"></div>
        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>