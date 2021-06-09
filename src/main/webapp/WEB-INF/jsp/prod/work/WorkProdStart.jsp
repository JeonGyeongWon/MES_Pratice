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

.gridStyle table td {
  height : 27px;
  font-size : 13px;
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

    $("#gridPopup2Area").hide("blind", {
        direction: "up"
    }, "fast");

    setReadOnly();

    setLovList();
});

function setInitial() {
    calender($('#searchPlanDate, #searchDate'));

    $('#searchPlanDate, #searchDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $("#searchPlanDate").val(getToDay("${searchVO.dateSys}") + "");
    $("#popupWorkStartDate").val(getToDay("${searchVO.LastDate}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        fn_option_change('MFG', 'STATUS', 'searchStatus');

        fn_option_change('MFG', 'WORK_TYPE', 'searchWorkType');
    });

    gridnms["app"] = "prod";
}

var colIdx = 0, rowIdx = 0;
var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_master();
    setValues_detail();
    setValues_Popup();
    setValues_Popup1();
}

function setValues_master() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "WorkOrderStart";
    gridnms["grid.11"] = "itemLov";
    gridnms["grid.12"] = "worktypeLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
    gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
    gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];

    gridnms["models.list"].push(gridnms["model.1"]);
    gridnms["models.list"].push(gridnms["model.11"]);
    gridnms["models.list"].push(gridnms["model.12"]);

    gridnms["stores.list"].push(gridnms["store.1"]);
    gridnms["stores.list"].push(gridnms["store.11"]);
    gridnms["stores.list"].push(gridnms["store.12"]);

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
            name: 'WORKORDERID',
        }, {
            type: 'string',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'WORKSTATUS',
        }, {
            type: 'string',
            name: 'WORKSTATUSNAME',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'ORDERNAME',
        }, {
            type: 'string',
            name: 'DRAWINGNO',
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
            name: 'UOM',
        }, {
            type: 'number',
            name: 'WORKORDERQTY',
        }, {
            type: 'string',
            name: 'MOLDCODE',
        }, {
            type: 'string',
            name: 'MOLDNAME',
        }, {
            type: 'date',
            name: 'WORKPLANSTARTDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'WORKPLANENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'WORKSTARTDATE',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'date',
            name: 'WORKENDDATE',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'date',
            name: 'DUEDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'CUSTOMERGUBUNNAME',
        }, {
            type: 'string',
            name: 'CUSTOMERGUBUN',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'EXCESSQTYYN3',
        },
    ];

    fields["model.11"] = [{
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'ORDERNAME',
        }, {
            type: 'string',
            name: 'DRAWINGNO',
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
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'CUSTOMERGUBUNNAME',
        }, {
            type: 'string',
            name: 'CUSTOMERGUBUN',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, ];

    fields["model.12"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
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
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'CHK',
            text: '',
            xtype: 'checkcolumn',
            width: 35,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'checkbox',
            },
            renderer: function (value, meta, record, row, col) {
                if (record.data.WORKSTATUS == "CANCEL" || record.data.WORKSTATUS == "COMPLETE") {
                    meta['tdCls'] = 'x-item-disabled';
                    meta.style += " background-color: rgb(71, 200, 62);";
                } else {
                    meta['tdCls'] = '';
                }

                return new Ext.ux.CheckColumn().renderer(value);
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
                _btnText: "작지취소",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var status = record.data.WORKSTATUS;
                    var statusname = record.data.WORKSTATUSNAME;
                    if (status == "CANCEL" || status == "END" || status == "COMPLETE") {
                        extAlert(statusname + " 상태에서는 작지취소 처리가 불가능합니다.");
                        return;
                    }

                    var excessyn = record.data.EXCESSQTYYN3;
                    var workorderid = record.data.WORKORDERID;
                    if (excessyn == "Y") {
                        extAlert(workorderid + " 작업지시에 실적이 등록되어있어 투입취소 처리가 불가능합니다.");
                        return;
                    }

                    fn_status_change(record.data, 'CANCEL');
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'WORKORDERID',
            text: '작업지시번호',
            xtype: 'gridcolumn',
            width: 130,
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
            dataIndex: 'WORKSTATUSNAME',
            text: '상태',
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
            dataIndex: 'WORKTYPENAME',
            text: '생산구분',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.12"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("WORKTYPE", record.get("VALUE"));
                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        if (field.getValue() == "") {
                            model.set("WORKTYPE", "");
                        }
                    },

                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 330,
                    getInnerTpl: function () {
                        return '<div>'
                         + '<table>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 280,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.11"],
                valueField: "ITEMNAME",
                displayField: "ITEMNAME",
                matchFieldWidth: false,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                hideTrigger: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("ITEMCODE", record.data.ITEMCODE);
                        model.set("ORDERNAME", record.data.ORDERNAME);
                        model.set("DRAWINGNO", record.data.DRAWINGNO);
                        model.set("MODEL", record.data.MODEL);
                        model.set("MODELNAME", record.data.MODELNAME);
                        model.set("ITEMSTANDARDDETAIL", record.data.ITEMSTANDARDDETAIL);
                        model.set("UOM", record.data.UOM);
                        model.set("UOMNAME", record.data.UOMNAME);
                        model.set("CUSTOMERGUBUN", record.data.CUSTOMERGUBUN);
                        model.set("CUSTOMERGUBUNNAME", record.data.CUSTOMERGUBUNNAME);

                        var item = record.data.ITEMNAME;

                        if (item == "") {
                            model.set("ITEMCODE", "");
                            model.set("ORDERNAME", "");
                            model.set("DRAWINGNO", "");
                            model.set("MODEL", "");
                            model.set("MODELNAME", "");
                            model.set("ITEMSTANDARDDETAIL", "");
                            model.set("UOM", "");
                            model.set("UOMNAME", "");
                            model.set("CUSTOMERGUBUN", "");
                            model.set("CUSTOMERGUBUNNAME", "");

                        }

                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("ITEMCODE", "");
                                model.set("ORDERNAME", "");
                                model.set("DRAWINGNO", "");
                                model.set("MODEL", "");
                                model.set("MODELNAME", "");
                                model.set("ITEMSTANDARDDETAIL", "");
                                model.set("UOM", "");
                                model.set("UOMNAME", "");
                                model.set("CUSTOMERGUBUN", "");
                                model.set("CUSTOMERGUBUNNAME", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 700,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table style="width: 100%; ">'
                         + '<colgroup>'
                         + '<col width="40%">'
                         + '<col width="30%">'
                         + '<col width="10%">'
                         + '<col width="20%">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td class="input_left" style="height: 25px; font-size: 13px; font-weight: bold; ">{ITEMNAME}</td>'
                         + '<td class="input_center" style="height: 25px; font-size: 13px; border-left: 1px dashed gray; ">{MODELNAME}</td>'
                         + '<td class="input_center" style="height: 25px; font-size: 13px; border-left: 1px dashed gray; ">{ITEMSTANDARDDETAIL}</td>'
                         + '<td class="input_center" style="height: 25px; font-size: 13px; border-left: 1px dashed gray; ">{ORDERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
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
            resizable: false,
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
            resizable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKORDERQTY',
            text: '계획수량',
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
            editor: {
                xtype: "textfield",
                minValue: 1,
                format: "0,000",
                enforceMaxLength: true,
                allowBlank: true,
                maxLength: '9',
                maskRe: /[0-9.]/,
                selectOnFocus: true,
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'WORKPLANSTARTDATE',
            text: '시작일(계획)',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'WORKPLANENDDATE',
            text: '종료일(계획)',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'WORKSTARTDATE',
            text: '시작일',
            xtype: 'datecolumn',
            width: 135,
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
        }, {
            dataIndex: 'WORKENDDATE',
            text: '종료일',
            xtype: 'datecolumn',
            width: 135,
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
        }, {
            dataIndex: 'WORKPLANNO',
            text: '생산계획번호',
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
            dataIndex: 'DUEDATE',
            text: '납기일',
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
            editor: {
                xtype: 'combobox',
                store: gridnms["store.11"],
                valueField: "ORDERNAME",
                displayField: "ORDERNAME",
                matchFieldWidth: false,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                hideTrigger: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("ITEMCODE", record.data.ITEMCODE);
                        model.set("ITEMNAME", record.data.ITEMNAME);
                        model.set("DRAWINGNO", record.data.DRAWINGNO);
                        model.set("MODEL", record.data.MODEL);
                        model.set("MODELNAME", record.data.MODELNAME);
                        model.set("ITEMSTANDARDDETAIL", record.data.ITEMSTANDARDDETAIL);
                        model.set("UOM", record.data.UOM);
                        model.set("UOMNAME", record.data.UOMNAME);
                        model.set("CUSTOMERGUBUN", record.data.CUSTOMERGUBUN);
                        model.set("CUSTOMERGUBUNNAME", record.data.CUSTOMERGUBUNNAME);

                        var item = record.data.ITEMNAME;

                        if (item == "") {
                            model.set("ITEMCODE", "");
                            model.set("ITEMNAME", "");
                            model.set("DRAWINGNO", "");
                            model.set("MODEL", "");
                            model.set("MODELNAME", "");
                            model.set("ITEMSTANDARDDETAIL", "");
                            model.set("UOM", "");
                            model.set("UOMNAME", "");
                            model.set("CUSTOMERGUBUN", "");
                            model.set("CUSTOMERGUBUNNAME", "");

                        }

                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("ITEMCODE", "");
                                model.set("ITEMNAME", "");
                                model.set("DRAWINGNO", "");
                                model.set("MODEL", "");
                                model.set("MODELNAME", "");
                                model.set("ITEMSTANDARDDETAIL", "");
                                model.set("UOM", "");
                                model.set("UOMNAME", "");
                                model.set("CUSTOMERGUBUN", "");
                                model.set("CUSTOMERGUBUNNAME", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 700,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table style="width: 100%; ">'
                         + '<colgroup>'
                         + '<col width="20%">'
                         + '<col width="40%">'
                         + '<col width="30%">'
                         + '<col width="10%">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td class="input_center" style="height: 25px; font-size: 13px; font-weight: bold; ">{ORDERNAME}</td>'
                         + '<td class="input_left" style="height: 25px; font-size: 13px; border-left: 1px dashed gray; ">{ITEMNAME}</td>'
                         + '<td class="input_center" style="height: 25px; font-size: 13px; border-left: 1px dashed gray; ">{MODELNAME}</td>'
                         + '<td class="input_center" style="height: 25px; font-size: 13px; border-left: 1px dashed gray; ">{ITEMSTANDARDDETAIL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'CUSTOMERGUBUNNAME',
            text: '거래처',
            xtype: 'gridcolumn',
            width: 170,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            renderer: function (value, meta, record) {
                return value;
            },
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
            renderer: function (value, meta, record) {
                return value;
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
            editor: {
                xtype: 'textfield',
                allowBlank: true,
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
            dataIndex: 'WORKSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'MOLDNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'MOLDCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERGUBUN',
            xtype: 'hidden',
        }, {
            dataIndex: 'EXCESSQTYYN3',
            xtype: 'hidden',
        },
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        create: "<c:url value='/insert/prod/work/WorkProdStart.do' />"
    });
    $.extend(items["api.1"], {
        read: "<c:url value='/select/prod/work/WorkProdStart.do' />"
    });
    $.extend(items["api.1"], {
        update: "<c:url value='/update/prod/work/WorkProdStart.do' />"
    });
    $.extend(items["api.1"], {
        destroy: "<c:url value='/delete/prod/work/WorkProdStart.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChkd1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "이월",
        itemId: "btnUsed1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "추가",
        itemId: "btnAdd1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "저장",
        itemId: "btnSav1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "삭제",
        itemId: "btnDel1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "복사",
        itemId: "btnCopy1"
    });

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnChkd1": {
            click: 'btnChk1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnUsed1": {
            click: 'btnUse1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnAdd1": {
            click: 'btnAdd1'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnSav1": {
            click: 'btnSav1'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnDel1": {
            click: 'btnDel1'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnCopy1": {
            click: 'btnCopy1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#WorkHeaderList": {
            itemclick: 'workOrderClick',
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

var chkFlag = true;
function btnChk1Click() {
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var checkTrue = 0,
    checkFalse = 0;

    if (chkFlag) {
        chkFlag = false;
    } else {
        chkFlag = true;
    }

    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var ynstatus = model1.data.WORKSTATUS;

        if (ynstatus != "CANCEL" && ynstatus != "COMPLETE") { // 상태값이 "대기" 인것만 체크
            if (!chkFlag) {
                // 체크 상태로
                model1.set("CHK", true);
                checkFalse++;
            } else {
                model1.set("CHK", false);
                checkTrue++;
            }
        }
    }
    if (checkTrue > 0) {
        console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
    }
    if (checkFalse > 0) {
        console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
    }
}

function fn_status_change(record, flag) {
    var flag_name = (flag == "COMPLETE") ? "완료" : "취소";
    var workstatus = record.WORKSTATUS;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[작지 " + flag_name + "]<br/>데이터가 등록되지 않았습니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    if (workstatus == flag) {
        extAlert("[작지 " + flag_name + "]<br/>이미 변경된 상태입니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    var url = "<c:url value='/update/prod/work/WorkProdStatus.do' />";
    record.WORKSTATUS = flag;

    Ext.MessageBox.confirm('작지 ' + flag_name, flag_name + ' 상태로 변경 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: record,
                success: function (data) {
                    var success = data.success;
                    var msg = data.msg;
                    if (!success) {
                        extAlert("관리자에게 문의하십시오.<br/>" + msg);
                        return;
                    } else {
                        Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                        Ext.getCmp(gridnms["views.list"]).doLayout();

                        extAlert(msg);

                        Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                            row: rowIdx,
                            column: colIdx,
                            animate: false
                        });

                        var restore = Ext.getCmp(gridnms["views.list"]).getSelectionModel().selected.items[0].data;
                        var sparams = {
                            ORGID: restore.ORGID,
                            COMPANYID: restore.COMPANYID,
                            WORKORDERID: restore.WORKORDERID,
                        };

                        extGridSearch(sparams, gridnms["store.2"]);
                    }
                },
                error: ajaxError
            });

        } else {
            Ext.Msg.alert('작지 ' + flag_name, flag_name + ' 상태 변경이 취소되었습니다.');
            record.WORKSTATUS = workstatus;
            return;
        }
    });
}

function btnUse1Click(o, e) {

    Ext.MessageBox.confirm('이월 ', '이월처리를 하시겠습니까?', function (btn) {
        if (btn == 'yes') {

            var addcounter = 0;
            var chkcnt = 0;
            var count1 = Ext.getStore(gridnms["store.1"]).count();
            if (count1 == 0) {
                extAlert("목록을 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                return;
            }
            for (var m = 0; m < count1; m++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(m));
                var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
                var chk = model1.data.CHK;

                if (chk) {
                    chkcnt = m;
                }
            }

            for (var j = 0; j < count1; j++) {
                addcounter++; // 변경된 갯수 체크

                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(j));
                var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
                var chk = model1.data.CHK;

                if (chk) {

                    var url = "<c:url value='/update/prod/work/WorkProdStartMonth.do' />";

                    var chk = model1.data;

                    var params = [];
                    $.ajax({
                        url: url,
                        type: "post",
                        dataType: "json",
                        data: chk,
                        success: function (data) {

                            var msgdata = data.msg;
                            var success = data.success;
                            if (!success) {
                                extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                                return;
                            } else {
                                msg = "이월 처리를 하였습니다.";
                                extAlert(msg);
                                fn_search();
                            }

                        },
                        error: ajaxError
                    });
                }
            } // for문
        } else {
            Ext.Msg.alert('이월', '이월처리가 취소되었습니다.');
            return;
        }
    });
}

function btnCopy1Click(o, e) {
    btnSel2();
}

function btnAdd1(o, e) {
    var model = Ext.create(gridnms["model.1"]);
    var store = this.getStore(gridnms["store.1"]);

    var sortorder = 0;
    var listcount = Ext.getStore(gridnms["store.1"]).count();
    for (var i = 0; i < listcount; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var dummy = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var dummy_sort = dummy.data.RN * 1;
        if (sortorder < dummy_sort) {
            sortorder = dummy_sort;
        }
    }
    sortorder++;

    model.set("RN", sortorder);

    model.set("ORGID", $("#searchOrgId").val());
    model.set("COMPANYID", $("#searchCompanyId").val());
    model.set("WORKSTATUS", "STAND_BY");
    model.set("WORKSTATUSNAME", "대기");
    model.set("WORKTYPE", "PLAN");
    model.set("WORKTYPENAME", "계획");

    var today = "${searchVO.dateSys}";
    var lastdate = "${searchVO.LastDate}";
    model.set("WORKPLANSTARTDATE", today);
    model.set("WORKPLANENDDATE", lastdate);

    //    store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
    var view = Ext.getCmp(gridnms['panel.1']).getView();
    var startPoint = 0;

    store.insert(startPoint, model);
    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], startPoint, 5);
};

function btnSav1(o, e) {
    // 저장시 필수값 체크
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var header = [],
    count = 0;

    if (count1 > 0) {
        for (i = 0; i < count1; i++) {
            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
            var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

            var worktype = model1.data.WORKTYPE;
            var itemcode = model1.data.ITEMCODE;
            var workplanstartdate = model1.data.WORKPLANSTARTDATE;
            var workplanenddate = model1.data.WORKPLANENDDATE;

            if (worktype == "" || worktype == undefined) {
                header.push("생산구분");
                count++;
            }

            if (itemcode == "" || itemcode == undefined) {
                header.push("품목");
                count++;
            }
            if (workplanstartdate == "" || workplanstartdate == undefined) {
                header.push("시작일");
                count++;
            }

            if (workplanenddate == "" || workplanenddate == undefined) {
                header.push("종료일");
                count++;
            }

            if (count > 0) {
                extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                return;
            }
        }
    } else {
        extAlert("[저장] 작업지시 투입 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
        return;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return;
    } else {
        Ext.getStore(gridnms["store.1"]).sync({
            success: function (batch, options) {
                Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                Ext.getCmp(gridnms["views.list"]).doLayout();

                var reader = batch.proxy.getReader();
                extAlert(reader.rawData.msg, gridnms["store.1"]);

                Ext.getStore(gridnms["store.1"]).load();

                Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                    row: rowIdx,
                    column: colIdx,
                    animate: false
                });

                var restore = Ext.getCmp(gridnms["views.list"]).getSelectionModel().selected.items[0].data;
                var sparams = {
                    ORGID: restore.ORGID,
                    COMPANYID: restore.COMPANYID,
                    WORKORDERID: restore.WORKORDERID,
                    WORKORDERSEQ: "",
                };
                extGridSearch(sparams, gridnms["store.2"]);
                //          Ext.getStore(gridnms["store.2"]).load();
            },
            failure: function (batch, options) {
                msg = batch.operations[0].error;
                extAlert(msg);
            },
            callback: function (batch, options) {},
        });

    }
};

function btnDel1(o, e) {
    var store = this.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];

        var model = Ext.getStore(gridnms['store.1']).getById(Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0].id);
    var count = 0;

    var check2 = model.get("WORKSTATUS") + "";
    if (check2 == "STAND_BY" || check2 == "CANCEL") {}
    else {
        extAlert("대기/취소 상태가 아닌 작업 지시건은 삭제 처리가 불가능 합니다.");
        count++;
    }

    if (record === undefined) {
        return;
    }

    if (count == 0) {
        Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                store.remove(record);
                Ext.getStore(gridnms["store.1"]).sync({
                    success: function (batch, options) {
                        Ext.getCmp(gridnms["views.list"]).supendLayout = false;
                        Ext.getCmp(gridnms["views.list"]).doLayout();

                        var reader = batch.proxy.getReader();
                        extAlert(reader.rawData.msg, gridnms["store.1"]);

                        Ext.getCmp(gridnms["views.list"]).getSelectionModel().setPosition({
                            row: rowIdx,
                            column: colIdx,
                            animate: false
                        });

                        var restore = Ext.getCmp(gridnms["views.list"]).getSelectionModel().selected.items[0].data;
                        var sparams = {
                            ORGID: restore.ORGID,
                            COMPANYID: restore.COMPANYID,
                            WORKORDERID: restore.WORKORDERID,
                            WORKORDERSEQ: "",
                        };

                        extGridSearch(sparams, gridnms["store.2"]);
                    },
                    failure: function (batch, options) {
                        msg = batch.operations[0].error;
                        extAlert(msg);
                    },
                    callback: function (batch, options) {},
                });
            }
        });
    }
};

var global_work_order_id = "", global_model_code = "", global_model_name = "";
var global_item_code = "", global_work_order_qty = 0;
var rowIdx = 0, colIdx = 0;
function workOrderClick(dataview, record, item, index, e, eOpts) {
    rowIdx = e.position.rowIdx;
    colIdx = e.position.colIdx;
    var dataIndex = e.position.column.dataIndex;

    chkFlag = true;
    chkFlag2 = true;

    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    global_work_order_id = record.data.WORKORDERID;
    global_item_code = record.data.ITEMCODE;
    global_work_order_qty = record.data.WORKORDERQTY;
    global_model_code = record.data.MODEL;
    global_model_name = record.data.MODELNAME;
    $('#rowIndexVal').val(index);

    switch (dataIndex) {
    default:
        if (global_work_order_id === "") {
            Ext.getStore(gridnms["store.2"]).removeAll();

        } else {
            var sparams = {
                ORGID: orgid,
                COMPANYID: companyid,
                WORKORDERID: global_work_order_id,
            };
            extGridSearch(sparams, gridnms["store.2"]);
        }

        var params2 = {
            ORGID: orgid,
            COMPANYID: companyid,
            ITEMCODE: global_item_code,
        };
        extGridSearch(params2, gridnms["store.22"]);

        break;
    }
}

function setValues_detail() {
    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.2"] = "WorkOrderDetail";
    gridnms["grid.21"] = "firstorderLov";
    gridnms["grid.22"] = "routingLov";
    gridnms["grid.23"] = "equipLov";
    gridnms["grid.24"] = "customerLov";

    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
    gridnms["views.detail"].push(gridnms["panel.2"]);

    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
    gridnms["controllers.detail"].push(gridnms["controller.2"]);

    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];
    gridnms["model.21"] = gridnms["app"] + ".model." + gridnms["grid.21"];
    gridnms["model.22"] = gridnms["app"] + ".model." + gridnms["grid.22"];
    gridnms["model.23"] = gridnms["app"] + ".model." + gridnms["grid.23"];
    gridnms["model.24"] = gridnms["app"] + ".model." + gridnms["grid.24"];

    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];
    gridnms["store.21"] = gridnms["app"] + ".store." + gridnms["grid.21"];
    gridnms["store.22"] = gridnms["app"] + ".store." + gridnms["grid.22"];
    gridnms["store.23"] = gridnms["app"] + ".store." + gridnms["grid.23"];
    gridnms["store.24"] = gridnms["app"] + ".store." + gridnms["grid.24"];

    gridnms["models.detail"].push(gridnms["model.2"]);
    gridnms["models.detail"].push(gridnms["model.21"]);
    gridnms["models.detail"].push(gridnms["model.22"]);
    gridnms["models.detail"].push(gridnms["model.23"]);
    gridnms["models.detail"].push(gridnms["model.24"]);

    gridnms["stores.detail"].push(gridnms["store.2"]);
    gridnms["stores.detail"].push(gridnms["store.21"]);
    gridnms["stores.detail"].push(gridnms["store.22"]);
    gridnms["stores.detail"].push(gridnms["store.23"]);
    gridnms["stores.detail"].push(gridnms["store.24"]);

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
            name: 'WORKORDERID',
        }, {
            type: 'string',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'WORKSTATUS',
        }, {
            type: 'string',
            name: 'WORKSTATUSNAME',
        }, {
            type: 'string',
            name: 'MODEL',
        }, {
            type: 'string',
            name: 'MODELNAME',
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
            name: 'ROUTINGCODE',
        }, {
            type: 'string',
            name: 'ROUTINGNO',
        }, {
            type: 'string',
            name: 'ROUTINGOP',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'number',
            name: 'WORKORDERQTY',
        }, {
            type: 'number',
            name: 'ROUTINGSEQ',
        }, {
            type: 'number',
            name: 'ROUTREMAINQTY',
        }, {
            type: 'number',
            name: 'DAILYQTY',
        }, {
            type: 'number',
            name: 'IMPORTQTY',
        }, {
            type: 'string',
            name: 'MOLDCODE',
        }, {
            type: 'string',
            name: 'MOLDNAME',
        }, {
            type: 'date',
            name: 'WORKPLANSTARTDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'WORKPLANENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'WORKSTARTDATE',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'date',
            name: 'WORKENDDATE',
            dateFormat: 'Y-m-d H:i',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'OUTSIDEORDERGUBUN',
        }, {
            type: 'string',
            name: 'CUSTOMERCODEOUT',
        }, {
            type: 'string',
            name: 'CUSTOMERNAMEOUT',
        }, {
            type: 'string',
            name: 'FIRSTORDER',
        }, {
            type: 'string',
            name: 'FIRSTORDERNAME',
        }, {
            type: 'string',
            name: 'CHANGEEQUIP',
        }, {
            type: 'string',
            name: 'CHANGEEQUIPNAME',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE2',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME2',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE3',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME3',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE4',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME4',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE5',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME5',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE6',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME6',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE7',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME7',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE8',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME8',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE9',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME9',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE10',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME10',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE11',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME11',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE12',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME12',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE13',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME13',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE14',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME14',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE15',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME15',
        }, {
            type: 'string',
            name: 'LUMP',
        }, {
            type: 'string',
            name: 'LASTCHK',
        }, {
            type: 'string',
            name: 'INSPECTIONYN',
        }, ];

    fields["model.22"] = [{
            type: 'string',
            name: 'ROUTINGCODE',
        }, {
            type: 'string',
            name: 'ROUTINGNO',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, ];

    fields["model.23"] = [{
            type: 'string',
            name: 'EQUIPMENTCODE',
        }, {
            type: 'string',
            name: 'EQUIPMENTNAME',
        }, ];

    fields["model.24"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.21"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.2"] = [
        // Display Columns
        {
            dataIndex: 'CHK',
            text: '',
            xtype: 'checkcolumn',
            width: 35,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'checkbox',
            },
            renderer: function (value, meta, record, row, col) {
                if (record.data.WORKSTATUS != "STAND_BY") {
                    meta['tdCls'] = 'x-item-disabled';
                    meta.style += " background-color: rgb(71, 200, 62);";
                } else {
                    meta['tdCls'] = '';
                }
                return new Ext.ux.CheckColumn().renderer(value);
            },
            listeners: {
                beforecheckchange: function (options, row, value, event) {

                    var record = Ext.getCmp(gridnms["views.detail"]).selModel.store.data.items[row].data;
                    if (value) {
                        if (record.WORKSTATUS != "STAND_BY") {
                            extAlert("대기상태의 지시에 대해서만 투입확정 처리가 가능합니다.<br/>다시 한번 확인해주세요.");
                            return false;
                        }
                    }
                }
            }
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
                _btnText: "투입확정",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var status = record.data.WORKSTATUS;
                    if (status != "STAND_BY") {
                        extAlert("대기상태의 지시에 대해서만 투입확정 처리가 가능합니다.");
                        return;
                    }

                    var outsideordergubun = record.data.OUTSIDEORDERGUBUN;
                    if (outsideordergubun == "Y") {
                        var dailyqty = record.data.DAILYQTY;
                        var customercodeout = record.data.CUSTOMERCODEOUT;
                        if (dailyqty == 0 || dailyqty == null || customercodeout == "" || customercodeout == null) {
                            extAlert("외주구분이 Y 인 데이터에 한해서<br/>외주거래처와 일계획수량 항목을 입력해야 합니다.");
                            return;
                        }
                    }
                    fn_detail_status_change(record.data, 'PROGRESS');

                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
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
                _btnText: "투입취소",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var status = record.data.WORKSTATUS;
                    var statusname = record.data.WORKSTATUSNAME;
                    if (status == "STAND_BY" || status == "CANCEL" || status == "END" || status == "COMPLETE") {
                        extAlert(statusname + " 상태에서는 투입취소 처리가 불가능합니다.");
                        return;
                    }

                    fn_detail_status_change(record.data, 'STAND_BY');
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'WORKORDERSEQ',
            text: '작업<br/>순번',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
            editor: {
                xtype: "textfield",
                minValue: 1,
                format: "0,000",
                enforceMaxLength: true,
                allowBlank: true,
                maxLength: '9',
                maskRe: /[0-9.]/,
                selectOnFocus: true,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'FIRSTORDERNAME',
            text: '우선<br/>순위',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.21"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote',
                allowBlank: true,
                typeAhead: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("FIRSTORDER", record.data.VALUE);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("FIRSTORDER", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
                    width: 60,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table style="width: 100%; ">'
                         + '<colgroup>'
                         + '<col width="100%">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td class="input_left" style="height: 25px; font-size: 13px; font-weight: bold; ">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
        }, {
            dataIndex: 'WORKSTATUSNAME',
            text: '상태',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'ROUTINGOP',
            text: '공정순번',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '공정명',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.22"],
                valueField: "ROUTINGNAME",
                displayField: "ROUTINGNAME",
                matchFieldWidth: false,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("ROUTINGCODE", record.data.ROUTINGCODE);
                        model.set("ROUTINGNO", record.data.ROUTINGNO);
                        model.set("ROUTINGOP", record.data.ROUTINGOP);
                        model.set("WORKORDERSEQ", record.data.SORTORDER);

                        var item = record.data.ROUTINGNAME;

                        if (item == "") {
                            model.set("ROUTINGCODE", "");
                            model.set("ROUTINGNO", "");
                            model.set("ROUTINGOP", "");
                            model.set("WORKORDERSEQ", "");

                        } else {
                            model.set("WORKCENTERCODE", "");
                            model.set("WORKCENTERNAME", "");
                            model.set("EQUIPMENTCODE", "");
                            model.set("EQUIPMENTNAME", "");

                            var params = {
                            		ORGID: model.data.ORGID,
                            		COMPANYID: model.data.COMPANYID,
                                ITEMCODE: model.data.ITEMCODE,
                                ROUTINGID: record.data.ROUTINGCODE
                            };
                            extGridSearch(params, gridnms["store.23"]);
                        }
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("ROUTINGCODE", "");
                                model.set("ROUTINGNO", "");
                                model.set("ROUTINGOP", "");
                                model.set("WORKORDERSEQ", "");
                                model.set("WORKCENTERCODE", "");
                                model.set("WORKCENTERNAME", "");
                                model.set("EQUIPMENTCODE", "");
                                model.set("EQUIPMENTNAME", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 320,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table style="width: 100%; ">'
                         + '<colgroup>'
                         + '<col width="30%">'
                         + '<col width="70%">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td class="input_center" style="height: 25px; font-size: 13px; ">{ROUTINGOP}</td>'
                         + '<td class="input_left" style="height: 25px; font-size: 13px; border-left: 1px dashed gray; font-weight: bold; ">{ROUTINGNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                return value;
            },
        }, {
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            dataIndex: 'XXXXXXXXXXX',
            text: '',
            width: 65,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "완료",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var status = record.data.WORKSTATUS;
                    var statusname = record.data.WORKSTATUSNAME;
                    if (status == "CANCEL" || status == "COMPLETE") {
                        extAlert(statusname + " 상태에서는 완료 처리가 불가능합니다.");
                        return;
                    }

                    fn_detail_status_change(record.data, 'COMPLETE');
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'WORKORDERQTY',
            text: '계획수량',
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ROUTREMAINQTY',
            text: '공정별<br/>재고수량',
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'DAILYQTY',
            text: '일<br/>계획수량',
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
            editor: {
                xtype: "textfield",
                format: "0,000",
                enforceMaxLength: true,
                allowBlank: true,
                maxLength: '9',
                maskRe: /[0-9]/,
                selectOnFocus: true,
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'IMPORTQTY',
            text: '양품수량',
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비명<br/>1',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("EQUIPMENTCODE", record.data.EQUIPMENTCODE);
                        model.set("WORKCENTERCODE", record.data.WORKCENTERCODE);
                        model.set("EQUIPMENTNAME", record.data.EQUIPMENTNAME);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("EQUIPMENTCODE", "");
                                model.set("WORKCENTERCODE", "");
                                model.set("EQUIPMENTNAME", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME2',
            text: '설비명<br/>2',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE2", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE2", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME3',
            text: '설비명<br/>3',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE3", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE3", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME4',
            text: '설비명<br/>4',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE4", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE4", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME5',
            text: '설비명<br/>5',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE5", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE5", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME6',
            text: '설비명<br/>6',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE6", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE6", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME7',
            text: '설비명<br/>7',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE7", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE7", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME8',
            text: '설비명<br/>8',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE8", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE8", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME9',
            text: '설비명<br/>9',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE9", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE9", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME10',
            text: '설비명<br/>10',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE10", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE10", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME11',
            text: '설비명<br/>11',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE11", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE11", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME12',
            text: '설비명<br/>12',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE12", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE12", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME13',
            text: '설비명<br/>13',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE13", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE13", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME14',
            text: '설비명<br/>14',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE14", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE14", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME15',
            text: '설비명<br/>15',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.23"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKCENTERCODE15", record.data.WORKCENTERCODE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("WORKCENTERCODE15", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="120px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'OUTSIDEORDERGUBUN',
            text: '외주<br>구분',
            xtype: 'gridcolumn',
            width: 55,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: ['Y', 'N'],
                matchFieldWidth: true,
                editable: false,
                allowBlank: true,
                typeAhead: true,
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        var result = value.getValue();

                        if (result != "Y") {
                            var customercodeout = model.data.CUSTOMERCODEOUT;
                            if (customercodeout != "") {
                                model.set("CUSTOMERCODEOUT", "");
                                model.set("CUSTOMERNAMEOUT", "");
                            }
                        }
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (result == "N") {
                                model.set("CUSTOMERCODEOUT", "");
                                model.set("CUSTOMERNAMEOUT", "");
                            }
                        }
                    },
                },
            },
        }, {
            dataIndex: 'INSPECTIONYN',
            text: '외주검사<br/>유무',
            xtype: 'gridcolumn',
            width: 75,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combo',
                store: ['Y', 'N'],
                editable: false,
                allowBlank: true,
                typeAhead: true,
                forceSelection: false,
            },
            renderer: function (value, meta, record) {
                var gubun = record.data.OUTSIDEORDERGUBUN;
                if (gubun != "Y") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return value;
            },
        }, {
            dataIndex: 'CUSTOMERNAMEOUT',
            text: '외주거래처',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.24"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("CUSTOMERCODEOUT", record.data.VALUE);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                model.set("CUSTOMERCODEOUT", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table >'
                         + '<colgroup>'
                         + '<col width="250px">'
                         + '</colgroup>'
                         + '<tr>'
                         + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                var gubun = record.data.OUTSIDEORDERGUBUN;
                if (gubun != "Y") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return value;
            },
        }, {
            dataIndex: 'WORKPLANSTARTDATE',
            text: '시작일(계획)',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
            },
        }, {
            dataIndex: 'WORKPLANENDDATE',
            text: '종료일(계획)',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
            },
        }, {
            dataIndex: 'WORKSTARTDATE',
            text: '시작일',
            xtype: 'datecolumn',
            width: 135,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d H:i',
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.date(value, 'Y-m-d H:i');
            },
        }, {
            dataIndex: 'WORKENDDATE',
            text: '종료일',
            xtype: 'datecolumn',
            width: 135,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d H:i',
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.date(value, 'Y-m-d H:i');
            },
        }, {
            dataIndex: 'CHANGEEQUIPNAME',
            text: '변경설비',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234);";

                var result = value;
                if (result != "") {
                    meta.style += " color:rgb(255, 0, 0);";
                    meta.style += " font-weight: bold;";
                }
                return value;
            },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            width: 360,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
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
            dataIndex: 'WORKSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORORDERID',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'MOLDNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'EQUIPMENTCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'EQUIPMENTNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE2',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE3',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE4',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE5',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE6',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE7',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE8',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE9',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE10',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE11',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE12',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE13',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE14',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE15',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODEOUT',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHANGEEQUIP',
            xtype: 'hidden',
        }, {
            dataIndex: 'FIRSTORDER',
            xtype: 'hidden',
        }, {
            dataIndex: 'LUMP',
            xtype: 'hidden',
        }, {
            dataIndex: 'LASTCHK',
            xtype: 'hidden',
        }, ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/prod/work/WorkProdStartD.do' />"
    });
    $.extend(items["api.2"], {
        create: "<c:url value='/insert/prod/work/WorkProdStartD.do' />"
    });
    $.extend(items["api.2"], {
        update: "<c:url value='/update/prod/work/WorkProdStartD.do' />"
    });
    $.extend(items["api.2"], {
        destroy: "<c:url value='/delete/prod/work/WorkProdStartD.do' />"
    });

    items["btns.2"] = [];
    items["btns.2"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChkd2"
    });
    items["btns.2"].push({
        xtype: "button",
        text: "투입확정",
        itemId: "btnUsed2"
    });
    items["btns.2"].push({
        xtype: "button",
        text: "추가",
        itemId: "btnAdd2"
    });
    items["btns.2"].push({
        xtype: "button",
        text: "저장",
        itemId: "btnSav2"
    });
    items["btns.2"].push({
        xtype: "button",
        text: "삭제",
        itemId: "btnDel2"
    });

    items["btns.ctr.2"] = {};
    $.extend(items["btns.ctr.2"], {
        "#btnChkd2": {
            click: 'btnChk2Click'
        }
    });
    $.extend(items["btns.ctr.2"], {
        "#btnUsed2": {
            click: 'btnUse2Click'
        }
    });
    $.extend(items["btns.ctr.2"], {
        "#btnAdd2": {
            click: 'btnAdd2'
        }
    });
    $.extend(items["btns.ctr.2"], {
        "#btnSav2": {
            click: 'btnSav2'
        }
    });
    $.extend(items["btns.ctr.2"], {
        "#btnDel2": {
            click: 'btnDel2'
        }
    });
    $.extend(items["btns.ctr.2"], {
        "#WorkOrderDetail": {
            itemclick: 'onDetailClick'
        }
    });

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

var chkFlag2 = true;
function btnChk2Click() {
    var count1 = Ext.getStore(gridnms["store.2"]).count();
    var checkTrue = 0,
    checkFalse = 0;

    if (chkFlag2) {
        chkFlag2 = false;
    } else {
        chkFlag2 = true;
    }

    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

        var ynstatus = model1.data.WORKSTATUS;

        if (ynstatus == "STAND_BY") { // 상태값이 "대기" 인것만 체크
            if (!chkFlag2) {
                // 체크 상태로
                model1.set("CHK", true);
                checkFalse++;
            } else {
                model1.set("CHK", false);
                checkTrue++;
            }
        }
    }
    if (checkTrue > 0) {
        console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
    }
    if (checkFalse > 0) {
        console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
    }
}

function fn_detail_status_change(record, flag) {
    var rowindex = Ext.getStore(gridnms["store.1"]).indexOf(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0]);
    var flag_name = (flag == "PROGRESS") ? "확정" : "취소";
    var workstatus = record.WORKSTATUS;

    var gridcount = Ext.getStore(gridnms["store.2"]).count();
    if (gridcount == 0) {
        extAlert("[투입 " + flag_name + "]<br/>상세데이터가 등록되지 않았습니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    if (workstatus == flag) {
        extAlert("[투입 " + flag_name + "]<br/>이미 변경된 상태입니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    Ext.getStore(gridnms["store.2"]).sync();

    var url = "<c:url value='/update/prod/work/WorkProdDetailStatus.do' />";
    record.WORKSTATUS = flag;

    Ext.MessageBox.confirm('투입 ' + flag_name, flag_name + ' 상태로 변경 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: record,
                async: false,
                success: function (data) {
                    var success = data.success;
                    var msg = data.msg;
                    if (!success) {
                        extAlert("관리자에게 문의하십시오.<br/>" + msg);
                        return;
                    } else {
                        extAlert(msg);

                        Ext.getStore(gridnms['store.1']).load(function (records, operation, success) {
                            Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx);
                            Ext.getCmp(gridnms["views.list"]).getView().focusRow(rowIdx);
                            Ext.getCmp(gridnms["views.list"]).view.bufferedRenderer.scrollTo(rowIdx, true);
                        });

                        setTimeout(function () {
                            var sparams = {
                                ORGID: record.ORGID,
                                COMPANYID: record.COMPANYID,
                                WORKORDERID: record.WORKORDERID,
                            };
                            extGridSearch(sparams, gridnms["store.2"]);
                        }, 300);
                    }
                },
                error: ajaxError
            });

        } else {
            Ext.Msg.alert('투입 ' + flag_name, flag_name + ' 상태 변경이 취소되었습니다.');
            record.WORKSTATUS = workstatus;
            return;
        }
    });
}

function btnUse2Click(o, e) {
    Ext.getStore(gridnms["store.2"]).sync();

    Ext.MessageBox.confirm('확정 ', '일괄 확정처리를 하시겠습니까?', function (btn) {
        if (btn == 'yes') {

            var addcounter = 0;
            var chkcnt = 0;
            var count1 = Ext.getStore(gridnms["store.2"]).count();
            if (count1 == 0) {
                extAlert("목록을 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                return;
            }
            for (var m = 0; m < count1; m++) {
                Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(m));
                var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
                var chk = model1.data.CHK;

                if (chk == true) {
                    chkcnt = m;
                }
            }

            for (var j = 0; j < count1; j++) {
                addcounter++; // 변경된 갯수 체크

                Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(j));
                var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
                var chk = model1.data.CHK;

                if (chk === true) {
                    model1.set("LUMP", "Y");
                    if (j == chkcnt) {
                        model1.set("LASTCHK", "Y");
                    }

                    var status = model1.data.WORKSTATUS;
                    if (status != "STAND_BY") {
                        extAlert("대기상태의 지시에 대해서만 투입확정 처리가 가능합니다.");
                        return;
                    }
                    var url = "<c:url value='/update/prod/work/WorkProdDetailStatus.do' />";

                    var gridcount = Ext.getStore(gridnms["store.2"]).count();
                    if (gridcount == 0) {
                        extAlert("[투입확정]<br/> 투입확정 데이터가 선택 되지 않았습니다.");
                        return false;
                    }

                    var chk = model1.data;
                    var workplanstartdate = Ext.util.Format.date(chk.WORKPLANSTARTDATE, 'Y-m-d');
                    chk.WORKPLANSTARTDATE = workplanstartdate;
                    var workplanenddate = Ext.util.Format.date(chk.WORKPLANENDDATE, 'Y-m-d');
                    chk.WORKPLANENDDATE = workplanenddate;
                    chk.WORKSTATUS = "PROGRESS";
                    var params = [];
                    $.ajax({
                        url: url,
                        type: "post",
                        dataType: "json",
                        data: chk,
                        success: function (data) {

                            var apprid = data.WORKORDERID;

                            if (!(apprid.length == 0)) {
                                var success = data.success;
                                if (success == false) {
                                    extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                                    return;
                                } else {
                                    msg = "투입확정 처리를 하였습니다.";
                                    extAlert(msg);
                                    fn_search();
                                }
                            }
                        },
                        error: ajaxError
                    });
                }
            } // for문
        } else {
            Ext.Msg.alert('투입확정', '투입확정 처리가 취소되었습니다.');
            return;
        }
    });

}

function btnAdd2(o, e) {
    var check_index = $('#rowIndexVal').val();

    if (check_index === "") {
        extAlert("작업지시를 선택 후 추가해주세요.");
        return;
    }

    var temp = ($('#rowIndexVal').val() == "") ? 0 : $('#rowIndexVal').val();
    $('#rowIndexVal').val(temp);

    var p_rowIndex = $('#rowIndexVal').val() * 1;

    var model1 = Ext.getCmp(gridnms["panel.1"]).getStore().getAt(p_rowIndex);
    var workorderid = model1.data.WORKORDERID;
    var itemcode = model1.data.ITEMCODE;
    var worktype = model1.data.WORKTYPE;
    var status = model1.data.WORKSTATUS;
    var workorderqty = model1.data.WORKORDERQTY;

    if (status == "CANCEL" || status == "COMPLETE") {
        Ext.Msg.alert('추가', '완료, 취소 상태 외의 지시에 대해서만 추가 기능이 가능합니다.');
        return;
    }

    if (workorderid === "") {
        extAlert("작업지시를 선택 후 추가해주세요.");
        return;
    }

    var model = Ext.create(gridnms["model.2"]);
    var store = this.getStore(gridnms["store.2"]);

    //    model.set("RN", Ext.getStore(gridnms["store.2"]).count() + 1);
    model.set("WORKORDERSEQ", ((Ext.getStore(gridnms["store.2"]).count() * 10) + 10));
    model.set("WORKSTATUS", "STAND_BY");
    model.set("WORKSTATUSNAME", "대기");

    model.set("OUTSIDEORDERGUBUN", "N");
    model.set("INSPECTIONYN", "N");
    model.set("ORGID", $("#searchOrgId").val());
    model.set("COMPANYID", $("#searchCompanyId").val());

    model.set("WORKORDERID", workorderid);
    model.set("ITEMCODE", itemcode);
    model.set("WORKTYPE", worktype);
    model.set("WORKORDERQTY", workorderqty);
    model.set("DAILYQTY", workorderqty);
    model.set("FIRSTORDER", "99");
    model.set("FIRSTORDERNAME", "N");

    //    store.insert(Ext.getStore(gridnms["store.2"]).count() + 1, model);

    var view = Ext.getCmp(gridnms['panel.2']).getView();
    var startPoint = 0;

    store.insert(startPoint, model);
    fn_grid_focus_move("UP", gridnms["store.2"], gridnms["views.detail"], startPoint, 3);
};

function btnSav2(o, e) {

    var check_index = ($('#rowIndexVal').val() == "") ? 0 : $('#rowIndexVal').val() * 1;
    if (check_index === "") {
        extAlert("작업지시를 선택 후 추가해주세요.");
        return;
    }

    var p_rowIndex = ($('#rowIndexVal').val() == "") ? 0 : $('#rowIndexVal').val() * 1;

    var model1 = Ext.getCmp(gridnms["panel.1"]).getStore().getAt(p_rowIndex);
    var status = model1.data.WORKSTATUS;

    if (status == "CANCEL" || status == "COMPLETE") {
        Ext.Msg.alert('추가', '완료, 취소 상태 외의 지시에 대해서만 저장 기능이 가능합니다.');
        return;
    }
    // 저장시 필수값 체크
    var count1 = Ext.getStore(gridnms["store.2"]).count();
    var header = [],
    count = 0;

    if (count1 > 0) {
        for (i = 0; i < count1; i++) {
            Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
            var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

            var worktype = model1.data.WORKTYPE;
            var itemcode = model1.data.ITEMCODE;
            var routingno = model1.data.ROUTINGNO;
            var equipmentcode = model1.data.EQUIPMENTCODE;

            //          if ( worktype == "" || worktype == undefined ) {
            //              header.push("생산구분");
            //              count++;
            //          }

            if (itemcode == "" || itemcode == undefined) {
                header.push("품목");
                count++;
            }

            if (routingno == "" || routingno == undefined) {
                header.push("공정번호");
                count++;
            }

            //           if ( equipmentcode == "" || equipmentcode == undefined ) {
            //               header.push("설비명");
            //               count++;
            //           }

            if (count > 0) {
                extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                return;
            }
        }
    } else {
        extAlert("[저장] 작업지시 투입 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
        return;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return;
    } else {
        Ext.getStore(gridnms["store.2"]).sync({
            success: function (batch, options) {
                var reader = batch.proxy.getReader();
                extAlert(reader.rawData.msg, gridnms["store.2"]);

//                 Ext.getStore(gridnms["store.2"]).load();
                Ext.getStore(gridnms['store.1']).load(function (records, operation, success) {
                    Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx);
                    Ext.getCmp(gridnms["views.list"]).getView().focusRow(rowIdx);
                    Ext.getCmp(gridnms["views.list"]).view.bufferedRenderer.scrollTo(rowIdx, true);
                });

                setTimeout(function () {
                        var sparams = {
                            ORGID: $('#searchOrgId').val(),
                            COMPANYID: $('#searchCompanyId').val(),
                            WORKORDERID: global_work_order_id,
                        };
                        extGridSearch(sparams, gridnms["store.2"]);
                }, 300);
            },
            failure: function (batch, options) {
                msg = batch.operations[0].error;
                extAlert(msg);
            },
            callback: function (batch, options) {},
        });
    }
};

function btnDel2(o, e) {
    var store = this.getStore(gridnms["store.2"]);
    var record = Ext.getCmp(gridnms["panel.2"]).selModel.getSelection()[0];

    var model = Ext.getStore(gridnms['store.2']).getById(Ext.getCmp(gridnms["panel.2"]).selModel.getSelection()[0].id);
    var count = 0;

    var check2 = model.data.WORKSTATUS + "";

    if (check2 == "CANCEL" || check2 == "COMPLETE") {
        Ext.Msg.alert('추가', '완료, 취소 상태 외의 지시에 대해서만 삭제 처리가 가능합니다.');
        count++;
    }

    if (record === undefined) {
        return;
    }

    if (count == 0) {
        Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                store.remove(record);
                Ext.getStore(gridnms["store.2"]).sync({
                    success: function (batch, options) {
                        var reader = batch.proxy.getReader();
                        extAlert(reader.rawData.msg, gridnms["store.2"]);
                    },
                    failure: function (batch, options) {
                        msg = batch.operations[0].error;
                        extAlert(msg);
                    },
                    callback: function (batch, options) {},
                });
            }
        });
    }
};

var rowIdx2 = 0, colIdx2 = 0;
function onDetailClick(dataview, record, item, index, e, eOpts) {
    rowIdx2 = e.position.rowIdx;
    colIdx2 = e.position.colIdx;
    var dataIndex = e.position.column.dataIndex;

    //      Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(index));
    //      var model2 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
    //      var ynstatus = model2.data.WORKSTATUS;

    //      if (ynstatus != "STAND_BY") { //
    //        // 체크 상태로
    //        model2.set("CHK", false);
    //      }

    switch (dataIndex) {
    case "FIRSTORDERNAME":
        // 우선순위
        //         var params1 = {
        //             ORGID: record.data.ORGID,
        //             COMPANYID: record.data.COMPANYID,
        //             BIGCD: 'MFG',
        //             MIDDLECD: 'FIRST_ORDER',
        //         };
        //         extGridSearch(params1, gridnms["store.21"]);

        break;
    case "ROUTINGNAME":
        // 공정명
        var params2 = {
            ORGID: record.data.ORGID,
            COMPANYID: record.data.COMPANYID,
            ITEMCODE: record.data.ITEMCODE,
            //             ROUTINGID: record.data.ROUTINGCODE
        };
        extGridSearch(params2, gridnms["store.22"]);

        break;
    case "WORKCENTERNAME":
    case "WORKCENTERNAME2":
    case "WORKCENTERNAME3":
    case "WORKCENTERNAME4":
    case "WORKCENTERNAME5":
    case "WORKCENTERNAME6":
    case "WORKCENTERNAME7":
    case "WORKCENTERNAME8":
    case "WORKCENTERNAME9":
    case "WORKCENTERNAME10":
    case "WORKCENTERNAME11":
    case "WORKCENTERNAME12":
    case "WORKCENTERNAME13":
    case "WORKCENTERNAME14":
    case "WORKCENTERNAME15":
        // 설비명
        var params3 = {
            ORGID: record.data.ORGID,
            COMPANYID: record.data.COMPANYID,
            ITEMCODE: record.data.ITEMCODE,
            ROUTINGID: record.data.ROUTINGCODE
        };
        extGridSearch(params3, gridnms["store.23"]);

        break;
    case "CUSTOMERNAMEOUT":
        // 외주거래처
        //         var params4 = {
        //             ORGID: record.data.ORGID,
        //             COMPANYID: record.data.COMPANYID,
        //             CUSTOMERTYPE2: 'O',
        //             USEYN: 'Y',
        //         };
        //         extGridSearch(params4, gridnms["store.24"]);

        break;
    default:

        break;
    }

};

var gridarea, gridarea1;
function setExtGrid() {
    setExtGrid_master();
    setExtGrid_detail();
    setExtGrid_Popup();
    setExtGrid_Popup1();

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

    Ext.define(gridnms["model.11"], {
        extend: Ext.data.Model,
        fields: fields["model.11"],
    });

    Ext.define(gridnms["model.12"], {
        extend: Ext.data.Model,
        fields: fields["model.12"],
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
                                WORKPLANDATE: $('#searchPlanDate').val(),
                                PRODSTART: 'Y',
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
                                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(0));
                                    var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                                    if ( rowIdx == 0 ) {
                                        global_work_order_id = model.data.WORKORDERID;
                                        global_item_code = model.data.ITEMCODE;
                                        global_work_order_qty = model.data.WORKORDERQTY;
                                        global_model_code = model.data.MODEL;
                                        global_model_name = model.data.MODELNAME;
                                        $('#rowIndexVal').val(0);
                                    }

                                    var params = {
                                        ORGID: model.data.ORGID,
                                        COMPANYID: model.data.COMPANYID,
                                        WORKORDERID: model.data.WORKORDERID,
                                    };
                                    extGridSearch(params, gridnms["store.2"]);
                                } else {
                                	global_work_order_id = "";
                                    Ext.getStore(gridnms['store.2']).removeAll();
                                }
                            },
                            scope: this
                        },
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.11"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.11"],
                        model: gridnms["model.11"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchItemNameLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                GUBUN: 'A',
                                //                  ROUTING_BOM_GUBUN : 'Y' ,
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.12"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.12"],
                        model: gridnms["model.12"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'MFG',
                                MIDDLECD: 'WORK_TYPE'
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            WorkHeaderList: '#WorkHeaderList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        btnAdd1: btnAdd1,
        btnSav1: btnSav1,
        btnDel1: btnDel1,
        btnChk1Click: btnChk1Click,
        workOrderClick: workOrderClick,
        btnUse1Click: btnUse1Click,
        btnCopy1Click: btnCopy1Click,
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
                height: 224,
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
                    itemId: 'WorkHeaderList',
                    trackOver: true,
                    loadMask: true,
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        triggerEvent: 'cellclick',
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = [];
                                var status = data.data.WORKSTATUS;
                                if (status != "STAND_BY") {
                                    editDisableCols.push("WORKTYPENAME");
                                    editDisableCols.push("ITEMNAME");
                                    editDisableCols.push("WORKORDERQTY");
                                    editDisableCols.push("WORKPLANSTARTDATE");
                                    editDisableCols.push("WORKPLANENDDATE");
                                    editDisableCols.push("ORDERNAME");
                                }

                                var isNew = ctx.record.phantom || false;
                                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                                    return false;
                                else {
                                    return true;
                                }
                            },
                            beforerender: function (c) {
                                var formFields = [];
                                //컴포넌트를 탐색하면서 field인것만 검
                                c.cascade(function (field) {
                                    var xtypeChains = field.xtypesChain;

                                    var isField = Ext.Array.findBy(xtypeChains, function (item) {

                                        // DisplayField는 이벤트 대상에서 제외
                                        if (item == 'displayfield') {
                                            return false;
                                        }

                                        // Ext.form.field.Base를 상속받는 모든객체
                                        if (item == 'field') {
                                            return true;
                                        }
                                    });
                                    //keyup이벤트 처리를 위해 enableKeyEvent를 true로 설정해야만함...
                                    if (isField) {
                                        field.enableKeyEvents = true;
                                        field.isShiftKeyPressed = false;
                                        formFields.push(field);
                                    }
                                });

                                for (var i = 0; i < formFields.length - 1; i++) {
                                    var beforeField = (i == 0) ? null : formFields[i - 1];
                                    var field = formFields[i];
                                    var nextField = formFields[i + 1];

                                    field.addListener('keyup', function (thisField, e) {
                                        //Shift Key 처리방법
                                        if (e.getKey() == e.SHIFT) {
                                            thisField.isShiftKeyPressed = false;
                                            return;
                                        }
                                    });

                                    field.addListener('keydown', function (thisField, e) {
                                        if (e.getKey() == e.SHIFT) {
                                            thisField.isShiftKeyPressed = true;
                                            return;
                                        }

                                        // Shift키 안누르고 ENTER키 또는 TAB키 누를때 다음필드로 이동
                                        if (thisField.isShiftKeyPressed == false && (e.getKey() == e.ENTER || e.getKey() == e.TAB)) { // tab 이나 enter 누름 다음 field 포커싱하도록함.
                                            this.nextField.focus();
                                            e.stopEvent();
                                        }
                                        // Shift키 누른상태에서 TAB키 누를때 이전필드로 이동
                                        else if (thisField.isShiftKeyPressed == true && e.getKey() == e.TAB) {
                                            if (this.beforeField != null) {
                                                this.beforeField.focus();
                                                e.stopEvent();
                                            }
                                        }
                                    }, {
                                        nextField: nextField,
                                        beforeField: beforeField
                                    });
                                }
                            }
                        },
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

function setExtGrid_detail() {
    Ext.define(gridnms["model.2"], {
        extend: Ext.data.Model,
        fields: fields["model.2"],
    });

    Ext.define(gridnms["model.21"], {
        extend: Ext.data.Model,
        fields: fields["model.21"],
    });

    Ext.define(gridnms["model.22"], {
        extend: Ext.data.Model,
        fields: fields["model.22"],
    });

    Ext.define(gridnms["model.23"], {
        extend: Ext.data.Model,
        fields: fields["model.23"],
    });

    Ext.define(gridnms["model.24"], {
        extend: Ext.data.Model,
        fields: fields["model.24"],
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
                            //                             extraParams: {
                            //                                 ORGID: $('#searchOrgId option:selected').val(),
                            //                                 COMPANYID: $('#searchCompanyId option:selected').val(),
                            //                                 WORKPLANDATE: $('#searchPlanDate').val(),
                            //                             },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.21"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.21"],
                        model: gridnms["model.21"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'MFG',
                                MIDDLECD: 'FIRST_ORDER',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.22"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.22"],
                        model: gridnms["model.22"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchRoutingItemLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.23"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.23"],
                        model: gridnms["model.23"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchEquipmentLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.24"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.24"],
                        model: gridnms["model.24"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchCustomernameLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                CUSTOMERTYPE2: 'O',
                                USEYN: 'Y',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.2"], {
        extend: Ext.app.Controller,
        refs: {
        	WorkOrderDetail: '#WorkOrderDetail',
        },
        stores: [gridnms["store.2"]],
        control: items["btns.ctr.2"],

        btnChk2Click: btnChk2Click,
        btnUse2Click: btnUse2Click,
        btnAdd2: btnAdd2,
        btnSav2: btnSav2,
        btnDel2: btnDel2,
        onDetailClick: onDetailClick
    });

    Ext.define(gridnms["panel.2"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.2"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.2"],
                id: gridnms["panel.2"],
                store: gridnms["store.2"],
                height: 338,
                border: 2,
                scrollable: true,
                columns: fields["columns.2"],
                plugins: [{
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20, // #1
                        leadingBufferZone: 20, // #2
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'WorkOrderDetail',
                    trackOver: true,
                    loadMask: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ROUTINGNAME') >= 0 /* || column.dataIndex.indexOf('WORKCENTERNAME') >= 0 */) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 80) {
                                        column.width = 80;
                                    }
                                }
                                if (column.dataIndex.indexOf('CHANGEEQUIPNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 120) {
                                        column.width = 120;
                                    }
                                }
                            });
                        }
                    },
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = [];
                                var status = data.data.WORKSTATUS;

                                if (status == "STAND_BY" || status == "PROGRESS" || status == "START") {

                                    if (status != "STAND_BY") {
                                        editDisableCols.push("WORKORDERSEQ");
                                    }

                                    var gubun = data.data.OUTSIDEORDERGUBUN;
                                    if (gubun != "Y") {
                                        editDisableCols.push("CUSTOMERNAMEOUT");
                                        editDisableCols.push("INSPECTIONYN");
                                    }
                                } else {
                                    editDisableCols.push("WORKORDERSEQ");
                                    editDisableCols.push("FIRSTORDERNAME");
                                    editDisableCols.push("ROUTINGNAME");
                                    editDisableCols.push("WORKCENTERNAME");
                                    editDisableCols.push("WORKCENTERNAME2");
                                    editDisableCols.push("WORKCENTERNAME3");
                                    editDisableCols.push("WORKCENTERNAME4");
                                    editDisableCols.push("WORKCENTERNAME5");
                                    editDisableCols.push("WORKCENTERNAME6");
                                    editDisableCols.push("WORKCENTERNAME7");
                                    editDisableCols.push("WORKCENTERNAME8");
                                    editDisableCols.push("WORKCENTERNAME9");
                                    editDisableCols.push("WORKCENTERNAME10");
                                    editDisableCols.push("DAILYQTY");
                                    editDisableCols.push("WORKPLANSTARTDATE");
                                    editDisableCols.push("WORKPLANENDDATE");
                                    editDisableCols.push("OUTSIDEORDERGUBUN");
                                    editDisableCols.push("CUSTOMERNAMEOUT");
                                    editDisableCols.push("INSPECTIONYN");

                                }

                                var isNew = ctx.record.phantom || false;
                                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                                    return false;
                                else {
                                    return true;
                                }
                            },
                            beforerender: function (c) {
                                var formFields = [];
                                //컴포넌트를 탐색하면서 field인것만 검
                                c.cascade(function (field) {
                                    var xtypeChains = field.xtypesChain;

                                    var isField = Ext.Array.findBy(xtypeChains, function (item) {

                                        // DisplayField는 이벤트 대상에서 제외
                                        if (item == 'displayfield') {
                                            return false;
                                        }

                                        // Ext.form.field.Base를 상속받는 모든객체
                                        if (item == 'field') {
                                            return true;
                                        }
                                    });
                                    //keyup이벤트 처리를 위해 enableKeyEvent를 true로 설정해야만함...
                                    if (isField) {
                                        field.enableKeyEvents = true;
                                        field.isShiftKeyPressed = false;
                                        formFields.push(field);
                                    }
                                });

                                for (var i = 0; i < formFields.length - 1; i++) {
                                    var beforeField = (i == 0) ? null : formFields[i - 1];
                                    var field = formFields[i];
                                    var nextField = formFields[i + 1];

                                    field.addListener('keyup', function (thisField, e) {
                                        //Shift Key 처리방법
                                        if (e.getKey() == e.SHIFT) {
                                            thisField.isShiftKeyPressed = false;
                                            return;
                                        }
                                    });

                                    field.addListener('keydown', function (thisField, e) {
                                        if (e.getKey() == e.SHIFT) {
                                            thisField.isShiftKeyPressed = true;
                                            return;
                                        }

                                        // Shift키 안누르고 ENTER키 또는 TAB키 누를때 다음필드로 이동
                                        if (thisField.isShiftKeyPressed == false && (e.getKey() == e.ENTER || e.getKey() == e.TAB)) { // tab 이나 enter 누름 다음 field 포커싱하도록함.
                                            this.nextField.focus();
                                            e.stopEvent();
                                        }
                                        // Shift키 누른상태에서 TAB키 누를때 이전필드로 이동
                                        else if (thisField.isShiftKeyPressed == true && e.getKey() == e.TAB) {
                                            if (this.beforeField != null) {
                                                this.beforeField.focus();
                                                e.stopEvent();
                                            }
                                        }
                                    }, {
                                        nextField: nextField,
                                        beforeField: beforeField
                                    });
                                }
                            }
                        },
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
                renderTo: 'gridArea1'
            });
        },
    });
}

function fn_search() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var workdate = $('#searchDate').val();
    var workplandate = $('#searchPlanDate').val();
    var header = [],
    count = 0;

    chkFlag = true;
    chkFlag2 = true;

    if (isNaN(orgid)) {
        header.push("사업장");
        count++;
    }

    if (isNaN(companyid)) {
        header.push("공장");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return;
    }

    var sparams = {
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
        WORKDATE: $('#searchDate').val(),
        WORKPLANDATE: $('#searchPlanDate').val(),
        WORKSTATUS: $('#searchStatus option:selected').val(),
        WORKTYPE: $('#searchWorkType option:selected').val(),
        WORKORDERID: $('#searchWorkNo').val(),
        ITEMCODE: $('#searchItemCode').val(),
        ORDERNAME: $('#searchOrderName').val(),
        ITEMNAME: $('#searchItemName').val(),
        MODELNAME: $('#searchModelName').val(),
        BIGCODE: $('#searchBigCode').val(),
        PRODSTART: 'Y',
    };

    extGridSearch(sparams, gridnms["store.1"]);
    setTimeout(function () {

        $('#rowIndexVal').val("");

        extGridSearch(sparams, gridnms["store.2"]);
        //      Ext.getStore(gridnms["store.2"]).removeAll();
        var sparams2 = {
            ORGID: $('#searchOrgId option:selected').val(),
            COMPANYID: $('#searchCompanyId option:selected').val(),
        };

        extGridSearch(sparams2, gridnms["store.11"]);
        extGridSearch(sparams2, gridnms["store.22"]);
        extGridSearch(sparams2, gridnms["store.23"]);
        extGridSearch(sparams2, gridnms["store.12"]);
    }, 200);

}

function fn_print() {
    var workorderid = global_work_order_id;
    if (workorderid == "") {
        extAlert("출력 할 작업지시를 선택 해 주세요.");
        return;
    }

    var column = 'master';
    var url = null;
    var target = '_blank';

    url = "<c:url value='/report/LotTransSlipReport.pdf'/>";

    fn_popup_url(column, url, target);
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
    gridnms["grid.41"] = "BigCodeLov";

    gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
    gridnms["views.popup1"].push(gridnms["panel.4"]);

    gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
    gridnms["controllers.popup1"].push(gridnms["controller.4"]);

    gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
    gridnms["model.41"] = gridnms["app"] + ".model." + gridnms["grid.41"];

    gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
    gridnms["store.41"] = gridnms["app"] + ".store." + gridnms["grid.41"];

    gridnms["models.popup1"].push(gridnms["model.4"]);
    gridnms["models.popup1"].push(gridnms["model.41"]);

    gridnms["stores.popup1"].push(gridnms["store.4"]);
    gridnms["stores.popup1"].push(gridnms["store.41"]);

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
            name: 'DRAWINGNO',
        }, {
            type: 'string',
            name: 'ITEMNAME',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
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
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'number',
            name: 'WORKPLANQTY',
        }, {
            type: 'number',
            name: 'BEFOREWORKQTY',
        }, {
            type: 'date',
            name: 'DUEDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'WORKSTARTDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'number',
            name: 'SOSEQ',
        }, {
            type: 'string',
            name: 'WORKORDERYN',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, ];

    fields["model.41"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
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
            dataIndex: 'CHK',
            text: '',
            xtype: 'checkcolumn',
            width: 35,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'WORKPLANNO',
            text: '생산계획번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'CUSTOMERNAME',
            text: '거래처',
            xtype: 'gridcolumn',
            width: 200,
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
            dataIndex: 'WORKPLANQTY',
            text: '수주수량',
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
            dataIndex: 'BEFOREWORKQTY',
            text: '기지시<br/>생산수량',
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
            dataIndex: 'DUEDATE',
            text: '납기일자',
            xtype: 'datecolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'WORKSTARTDATE',
            text: '작업지시<br/>확정일자',
            xtype: 'datecolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
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
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOMNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SONO',
            xtype: 'hidden',
        }, {
            dataIndex: 'SOSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ENDDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'REMARKS',
            xtype: 'hidden',
        }, {
            dataIndex: 'CONFIRMYNNAME',
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

function setValues_Popup1() {
    gridnms["models.popup2"] = [];
    gridnms["stores.popup2"] = [];
    gridnms["views.popup2"] = [];
    gridnms["controllers.popup2"] = [];

    gridnms["grid.5"] = "Popup2";

    gridnms["panel.5"] = gridnms["app"] + ".view." + gridnms["grid.5"];
    gridnms["views.popup2"].push(gridnms["panel.5"]);

    gridnms["controller.5"] = gridnms["app"] + ".controller." + gridnms["grid.5"];
    gridnms["controllers.popup2"].push(gridnms["controller.5"]);

    gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];

    gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];

    gridnms["models.popup2"].push(gridnms["model.5"]);

    gridnms["stores.popup2"].push(gridnms["store.5"]);

    fields["model.5"] = [{
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
            name: 'WORKORDERID',
        }, {
            type: 'string',
            name: 'WORKORDERSEQ',
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
        }, ];

    fields["columns.5"] = [
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
            dataIndex: 'CHK',
            text: '',
            xtype: 'checkcolumn',
            width: 35,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'checkbox',
            },
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
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 280,
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
            resizable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'WORKORDERID',
            text: '작업지시번호',
            xtype: 'gridcolumn',
            width: 130,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
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
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, ];

    items["api.5"] = {};
    $.extend(items["api.5"], {
        read: "<c:url value='/select/prod/work/WorkProdStart.do' />"
    });

    items["btns.5"] = [];

    items["btns.ctr.5"] = {};

    items["dock.paging.5"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.5"],
    };

    items["dock.btn.5"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.5"],
        items: items["btns.5"],
    };

    items["docked.5"] = [];
}

var gridpopup1, gridpopup2;
function setExtGrid_Popup() {
    Ext.define(gridnms["model.4"], {
        extend: Ext.data.Model,
        fields: fields["model.4"],
    });

    Ext.define(gridnms["model.41"], {
        extend: Ext.data.Model,
        fields: fields["model.41"],
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

    Ext.define(gridnms["store.41"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.41"],
                        model: gridnms["model.41"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchBigClassListLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#searchOrgId').val(),
                                COMPANYID: $('#searchCompanyId').val(),
                                ITEMTYPE: 'A',
                                GUBUN: 'A',
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

function setExtGrid_Popup1() {
    Ext.define(gridnms["model.5"], {
        extend: Ext.data.Model,
        fields: fields["model.5"],
    });

    Ext.define(gridnms["store.5"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.5"],
                        model: gridnms["model.5"],
                        autoLoad: false,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.5"],
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

    Ext.define(gridnms["controller.5"], {
        extend: Ext.app.Controller,
        refs: {
            btnPopup2: '#btnPopup2',
        },
        stores: [gridnms["store.5"]],
    });

    Ext.define(gridnms["panel.5"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.5"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.5"],
                id: gridnms["panel.5"],
                store: gridnms["store.5"],
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
                columns: fields["columns.5"],
                viewConfig: {
                    itemId: 'btnPopup2',
                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.5"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup2"],
        stores: gridnms["stores.popup2"],
        views: gridnms["views.popup2"],
        controllers: gridnms["controller.5"],

        launch: function () {
            gridpopup2 = Ext.create(gridnms["views.popup2"], {
                renderTo: 'gridPopup2Area'
            });
        },
    });
}

var popup_flag = false;
var win1 = "";
function btnSel1(btn) {
    // 생산계획 팝업
    var width = 1357; // 가로
    var height = 640; // 세로
    var title = "생산계획 Popup";

    popup_flag = false;
    win1 = "";
    // 완료 외 상태에서만 팝업 표시하도록 처리
    $('#popupOrgId').val($('#searchOrgId option:selected').val());
    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
    $("#popupWorkStartDate").val(getToDay("${searchVO.LastDate}") + "");
    $('#popupCustomerName').val("");
    $('#popupBigCode').val("");
    $('#popupBigName').val("");
    $('#popupOrderName').val("");
    $('#popupItemName').val("");
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
            '작업예정일', {
                xtype: 'datefield',
                name: 'searchWorkStartDate',
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
                align: 'center',
                width: 110,
                listeners: {
                    scope: this,
                    buffer: 50,
                    select: function (value, record) {
                        $('#popupWorkStartDate').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
                    },
                    change: function (value, nv, ov, e) {
                        var result = value.getValue();

                        if (nv !== ov) {

                            if (result === "") {
                                $('#popupWorkStartDate').val("");
                            } else {
                                $('#popupWorkStartDate').val(Ext.Date.format(result, 'Y-m-d'));
                            }

                        }
                    },
                    renderer: function (value, meta, record) {
                        meta.style = "background-color:rgb(234, 234, 234)";
                        return Ext.util.Format.date(value, 'Y-m-d');
                    },
                },
            },
            '거래처', {
                xtype: 'textfield',
                name: 'searchCustomerName1',
                clearOnReset: true,
                hideLabel: true,
                width: 120,
                editable: true,
                allowBlank: true,
                listeners: {
                    scope: this,
                    buffer: 50,
                    change: function (value, nv, ov, e) {
                        value.setValue(nv.toUpperCase());
                        var result = value.getValue();

                        $('#popupCustomerName').val(result);
                    },
                },
            },
            '대분류', {
                xtype: 'combo',
                name: 'searchBigName1',
                clearOnReset: true,
                hideLabel: true,
                width: 110,
                store: gridnms["store.41"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'remote', // 'remote',
                allowBlank: true,
                typeAhead: false,
                triggerAction: 'all',
                selectOnFocus: false,
                applyTo: 'local-states',
                forceSelection: false,
                listeners: {
                    scope: this,
                    buffer: 50,
                    select: function (value, record) {
                        $('#popupBigCode').val(record.data.VALUE);
                        $('#popupBigName').val(record.data.LABEL);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                $('#popupBigCode').val("");
                                $('#popupBigName').val("");
                            }
                        }
                    },
                },
            },
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
                name: 'searchModelName',
                clearOnReset: true,
                hideLabel: true,
                width: 100,
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
            '->', {
                text: '조회',
                scope: this,
                handler: function () {
                    fn_popup_search();
                }
            }, {
                text: '전체선택/해제',
                scope: this,
                handler: function () {
                    // 전체등록 Pop up 전체선택 버튼 핸들러
                    var count4 = Ext.getStore(gridnms["store.4"]).count();
                    var checkTrue = 0,
                    checkFalse = 0;

                    if (popup_flag) {
                        popup_flag = false;
                    } else {
                        popup_flag = true;
                    }
                    for (var i = 0; i < count4; i++) {
                        Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
                        var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];

                        if (popup_flag) {
                            // 체크 상태로
                            model4.set("CHK", true);
                            checkFalse++;
                        } else {
                            model4.set("CHK", false);
                            checkTrue++;
                        }

                    }
                    if (checkTrue > 0) {
                        console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
                    }
                    if (checkFalse > 0) {
                        console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
                    }
                }
            }, {
                text: '적용',
                scope: this,
                handler: function () {
                    // 전체등록 Pop up 적용 버튼 핸들러
                    var count = Ext.getStore(gridnms["store.1"]).count();
                    var count4 = Ext.getStore(gridnms["store.4"]).count();
                    var checknum = 0,
                    checkqty = 0,
                    checktemp = 0;
                    var qtytemp = [];

                    for (var i = 0; i < count4; i++) {
                        Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
                        var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                        var chk = model4.data.CHK;

                        if (chk) {
                            checknum++;
                        }
                    }
                    console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                    if (checknum == 0) {
                        extAlert("생산계획 내역을 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                        return false;
                    }

                    if (count4 == 0) {
                        console.log("[적용] 생산계획 정보가 없습니다.");
                    } else {
                        for (var j = 0; j < count4; j++) {
                            Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
                            var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                            var chk = model4.data.CHK;

                            if (chk === true) {
                                var model = Ext.create(gridnms["model.1"]);
                                var store = Ext.getStore(gridnms["store.1"]);

                                // 순번
                                model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);

                                // 팝업창의 체크된 항목 이동
                                model.set("ORGID", model4.data.ORGID);
                                model.set("COMPANYID", model4.data.COMPANYID);
                                model.set("ITEMCODE", model4.data.ITEMCODE);
                                model.set("ORDERNAME", model4.data.ORDERNAME);
                                model.set("DRAWINGNO", model4.data.DRAWINGNO);
                                model.set("ITEMNAME", model4.data.ITEMNAME);
                                model.set("MODEL", model4.data.CARTYPE);
                                model.set("MODELNAME", model4.data.CARTYPENAME);
                                model.set("ITEMSTANDARDDETAIL", model4.data.ITEMSTANDARDDETAIL);
                                model.set("UOM", model4.data.UOM);
                                model.set("UOMNAME", model4.data.UOMNAME);
                                model.set("CUSTOMERGUBUNNAME", model4.data.CUSTOMERNAME);
                                model.set("CUSTOMERGUBUN", model4.data.CUSTOMERCODE);
                                model.set("WORKSTATUS", "STAND_BY");
                                model.set("WORKSTATUSNAME", "대기");
                                model.set("WORKTYPENAME", "계획");
                                model.set("WORKTYPE", "PLAN");

                                var sumqty = (model4.data.WORKPLANQTY * 1) - (model4.data.BEFOREWORKQTY * 1);
                                model.set("WORKORDERQTY", sumqty);

                                model.set("WORKPLANSTARTDATE", model4.data.WORKSTARTDATE);

                                model.set("WORKPLANNO", model4.data.WORKPLANNO);
                                model.set("DUEDATE", model4.data.DUEDATE);
                                model.set("WORKPLANENDDATE", model4.data.ENDDATE); // 납기일 - 3을 종료일(계획)에 입력


                                // 그리드 적용 방식
                                store.insert(0, model);
                                extAlert("제일 위의 LINE에 복사되었습니다.");
                            };
                        }

                        Ext.getCmp(gridnms["panel.1"]).getView().refresh();

                    }

                    win1.close();

                    $("#gridPopup1Area").hide("blind", {
                        direction: "up"
                    }, "fast");

                }
            }
        ]
    });
    win1.show();

    $('input[name=searchWorkStartDate]').val($('#popupWorkStartDate').val());
    fn_popup_search();
}

function fn_popup_search() {
    popup_flag = false;
    var workstart = $('#popupWorkStartDate').val();
    if (workstart === "") {
        extAlert("작업예정일을 작성 후 조회가 가능합니다.");
        return;
    }
    var sparams = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        //                DUEDATE: $('#popupDueDate').val(),
        //                WORKSTARTDATE: 'Y',
        EQUALSTATUS: 'Y',
        COMPLETEYN: 'N',
        //                STARTDATE: $('#popupWorkStartDate').val(),
        CUSTOMERNAME: $('#popupCustomerName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        ITEMNAME: $('#popupItemName').val(),
        BIGCODE: $('#popupBigCode').val(),
        BIGNAME: $('#popupBigName').val(),
        MODELNAME: $('#popupModelName').val(),
    };
    extGridSearch(sparams, gridnms["store.4"]);
}

var popup_flag2 = false;
var win2 = "";
function btnSel2(btn) {
    if (global_model_code == "" || global_model_name == undefined) {
        extAlert("작업지시 항목을 먼저 선택하여주십시오.");
        return false;
    }

    // 생산계획 팝업
    var width = 857; // 가로
    var height = 640; // 세로
    var title = "투입설비복사 Popup";

    popup_flag2 = false;
    win2 = "";
    // 완료 외 상태에서만 팝업 표시하도록 처리
    $('#popupOrgId').val($('#searchOrgId option:selected').val());
    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
    $('#popupItemName').val("");
    Ext.getStore(gridnms['store.5']).removeAll();

    win2 = Ext.create('Ext.window.Window', {
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
                itemId: gridnms["panel.5"],
                id: gridnms["panel.5"],
                store: gridnms["store.5"],
                height: '100%',
                border: 2,
                scrollable: true,
                frameHeader: true,
                columns: fields["columns.5"],
                viewConfig: {
                    itemId: 'btnPopup2'
                },
                plugins: 'bufferedrenderer',
                dockedItems: items["docked.5"],
            }
        ],
        tbar: [
            '기종', {
                xtype: 'textfield',
                name: 'searchModelName1',
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

                        $('#popupModelName').val(result);
                    },
                },
            },
            '->', {
                text: '조회',
                scope: this,
                handler: function () {
                    fn_popup_search2();
                }
            }, {
                text: '전체선택/해제',
                scope: this,
                handler: function () {
                    // 전체등록 Popup 전체선택 버튼 핸들러
                    var count5 = Ext.getStore(gridnms["store.5"]).count();
                    var checkTrue = 0,
                    checkFalse = 0;

                    if (popup_flag2) {
                        popup_flag2 = false;
                    } else {
                        popup_flag2 = true;
                    }
                    for (var i = 0; i < count5; i++) {
                        Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(i));
                        var model5 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];

                        if (popup_flag2) {
                            // 체크 상태로
                            model5.set("CHK", true);
                            checkFalse++;
                        } else {
                            model5.set("CHK", false);
                            checkTrue++;
                        }
                    }

                    if (checkTrue > 0) {
                        console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
                    }
                    if (checkFalse > 0) {
                        console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
                    }
                }
            }, {
                text: '적용',
                scope: this,
                handler: function () {
                    // 적용
                    var count5 = Ext.getStore(gridnms["store.5"]).count();
                    var check_count = 0;
                    for (var i = 0; i < count5; i++) {
                        Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(i));
                        var model5 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];

                        var chk = model5.data.CHK;
                        if (chk) {
                            check_count++;
                        }
                    }

                    if (check_count == 0) {
                        extAlert("복사할 작업지시를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                        return false;
                    }

                    if (count5 == 0) {
                        console.log("[적용] 투입설비 정보가 없습니다.");
                    } else {
                        var start_count = 0;
                        var insert_count = 0;
                        for (var k = 0; k < count5; k++) {
                            Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(k));
                            var model5 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
                            var chk = model5.data.CHK;
                            var orgid = model5.data.ORGID;
                            var companyid = model5.data.COMPANYID;
                            var workorderid = model5.data.WORKORDERID;
                            var itemcode = model5.data.ITEMCODE;
                            if (chk) {
                                var startyn = (start_count == 0) ? "Y" : "N";
                                var endyn = (check_count == (insert_count + 1)) ? "Y" : "N";
                                var params = {
                                    ORGID: orgid,
                                    COMPANYID: companyid,
                                    WORKORDERIDF: global_work_order_id,
                                    WORKORDERIDT: workorderid,
                                    ITEMCODE: itemcode,
                                    STARTYN: startyn,
                                    ENDYN: endyn,
                                };

                                start_count++;

                                $.ajax({
                                    url: "<c:url value='/insert/prod/work/WorkOrderCopy.do' />",
                                    type: "post",
                                    dataType: "json",
                                    data: params,
                                    async: false,
                                    success: function (data) {
                                        var msgdata = data.msg;
                                        if (data.success) {
                                            insert_count++;
                                        } else {
                                            extAlert(msgdata);
                                            return false;
                                        }

                                        if (check_count == insert_count) {
                                            extAlert(msgdata);
                                        }
                                    },
                                    error: ajaxError
                                });
                            }

                        }
                    }

                    win2.close();

                    $("#gridPopup2Area").hide("blind", {
                        direction: "up"
                    }, "fast");
                }
            }
        ]
    });
    win2.show();

    $('input[name=searchModelName1]').val(global_model_name);
    $('#popupModelName').val(global_model_name);
    $('input[name=searchModelName1]').attr('disabled', true).addClass('ui-state-disabled');
    
    fn_popup_search2();
}

function fn_popup_search2() {
    popup_flag2 = false;
    var sparams = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        MODELNAME: $('#popupModelName').val(),
        NOTWORKORDERID: global_work_order_id,
        POPUPGUBUN: 'COPY',
    };
    extGridSearch(sparams, gridnms["store.5"]);
}

function setLovList() {
    // 작업지시번호 Lov
    $("#searchWorkNo").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#searchWorkNo").val("");
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
            $.getJSON("<c:url value='/searchWorkNoListLov.do' />", {
                keyword: extractLast(request.term),
                WORKPLANDATE: $('#searchPlanDate').val(),
                WORKDATE: $('#searchDate').val(),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.WORKORDERID,
                            label: m.WORKORDERID,
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
            $("#searchWorkNo").val(o.item.value);

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
                        <input type="hidden" id="rowIndexVal" />
                        <input type="hidden" id="popupOrgId" name="popupOrgId" />
                        <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                        <input type="hidden" id="popupCustomerName" />
                        <input type="hidden" id="popupBigCode" />
                        <input type="hidden" id="popupBigName" />
                        <input type="hidden" id="popupOrderName" />
                        <input type="hidden" id="popupItemName" />
                        <input type="hidden" id="popupDueDate" name="popupDueDate" />
                        <input type="hidden" id="popupWorkStartDate" name="popupWorkStartDate" />
                        <input type="hidden" id="popupModelName" name="popupModelName" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
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
                                                <a id="btnChk2" class="btn_popup" href="#" onclick="javascript:btnSel1();">
                                                   생산계획
                                                </a>
                                                 <!-- <a id="btnChk3" class="btn_print" href="#" onclick="javascript:fn_print();">
                                                   공정이동전표
                                                 </a> -->
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="8%">
                                        <col width="17%">
                                        <col width="8%">
                                        <col width="17%">
                                        <col width="8%">
                                        <col width="17%">
                                        <col width="8%">
                                        <col width="17%">
                                    </colgroup>
                                    
                                    <tr style="height: 34px;">
                                        <th class="required_text">기준일자(계획)</th>
                                        <td >
                                            <input type="text" id="searchPlanDate" name="searchPlanDate" class="input_center " style="width: 97%; " maxlength="10" />
                                        </td>
                                        <th class="required_text">기준일자(실적)</th>
                                        <td >
                                            <input type="text" id="searchDate" name="searchDate" class="input_center " style="width: 97%; " maxlength="10" />
                                        </td>
                                        <th class="required_text">상태</th>
                                        <td>
                                            <select id="searchStatus" name="searchStatus" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.STATUS}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByStatus}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.STATUS}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th class="required_text">생산구분</th>
                                        <td>
                                            <select id="searchWorkType" name="searchWorkType" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.STATUS}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByWorkType}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.STATUS}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">작업지시번호</th>
                                        <td>
                                            <input type="text" id="searchWorkNo" name="searchWorkNo" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class=" input_left " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
			                                  <th class="required_text">기종</th>
			                                  <td >
			                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
			                                  </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">대분류</th>
                                        <td>
                                            <select id="searchBigCode" name="searchBigCode" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.STATUS}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByBigNmType}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.BIGCODE}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <td></td>
                                        <td></td>
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
                <div style="width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">작업지시 투입/변경</div></td>
                        </tr>
                    </table>
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
                <div style="width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">공정 투입</div></td>
                        </tr>
                    </table>
                    <div id="gridArea1" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
            </div>
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 1348px; padding-top: 0px; float: left;"></div>
        <div id="gridPopup2Area" style="width: 848px; padding-top: 0px; float: left;"></div>
        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>