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

#gridArea .x-form-field {
	ime-mode: disabled;
	text-transform: uppercase;
}
</style>
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();
    setValues();
    setExtGrid();

    setReadOnly();

    setLovList();
});

function setInitial() {
    gridnms["app"] = "base";
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_master();
    setValues_detail();
    setValues_interface();
}

function setValues_master() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "WorkCenterList";
    gridnms["grid.11"] = "deptcodeLov";
    gridnms["grid.12"] = "workdeptLov";
    gridnms["grid.13"] = "routingLov";
    gridnms["grid.14"] = "eqsetupLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
    gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];
    gridnms["model.13"] = gridnms["app"] + ".model." + gridnms["grid.13"];
    gridnms["model.14"] = gridnms["app"] + ".model." + gridnms["grid.14"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
    gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];
    gridnms["store.13"] = gridnms["app"] + ".store." + gridnms["grid.13"];
    gridnms["store.14"] = gridnms["app"] + ".store." + gridnms["grid.14"];

    gridnms["models.list"].push(gridnms["model.1"]);
    gridnms["models.list"].push(gridnms["model.11"]);
    gridnms["models.list"].push(gridnms["model.12"]);
    gridnms["models.list"].push(gridnms["model.13"]);
    gridnms["models.list"].push(gridnms["model.14"]);

    gridnms["stores.list"].push(gridnms["store.1"]);
    gridnms["stores.list"].push(gridnms["store.11"]);
    gridnms["stores.list"].push(gridnms["store.12"]);
    gridnms["stores.list"].push(gridnms["store.13"]);
    gridnms["stores.list"].push(gridnms["store.14"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'RN'
        }, {
            type: 'string',
            name: 'ORGID'
        }, {
            type: 'string',
            name: 'COMPANYID'
        }, {
            type: 'string',
            name: 'WORKCENTERCODE'
        }, {
            type: 'string',
            name: 'WORKCENTERNAME'
        }, {
            type: 'string',
            name: 'USEYN'
        }, {
            type: 'string',
            name: 'MODELSTANDARD'
        }, {
            type: 'string',
            name: 'MAKE'
        }, {
            type: 'string',
            name: 'MAKENO'
        }, {
            type: 'date',
            name: 'MAKEDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'BUYDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'number',
            name: 'BUYAMOUNT'
        }, {
            type: 'string',
            name: 'DEPTCODE'
        }, {
            type: 'string',
            name: 'DEPTNAME'
        }, {
            type: 'string',
            name: 'WORKDEPT'
        }, {
            type: 'string',
            name: 'WORKDEPTNAME'
        }, {
            type: 'string',
            name: 'ROUTINGCODE'
        }, {
            type: 'string',
            name: 'ROUTINGNAME'
        }, {
            type: 'string',
            name: 'EQSETUPOLD'
        }, {
            type: 'string',
            name: 'EQSETUP'
        }, {
            type: 'string',
            name: 'EQSETUPNAME'
        }, {
            type: 'string',
            name: 'SEQ'
        }, {
            type: 'string',
            name: 'EXCEPTYN'
        }, {
            type: 'string',
            name: 'WORKCENTERCODEIF'
        }, {
            type: 'date',
            name: 'GRADECHECKDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'MANAGEGRADE',
        }, {
            type: 'date',
            name: 'EFFECTIVESTARTDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'EFFECTIVEENDDATE',
            dateFormat: 'Y-m-d',
        }, ];

    fields["model.11"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.12"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.13"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.14"] = [{
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERCODE',
            text: '설비코드',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            },
            renderer: function (value, meta, record) {
                var saveyn = record.data.SAVEYN;
                if (saveyn == "" || saveyn == undefined) {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    meta.style = "background-color:rgb(258, 218, 255); ";
                }
                return value;
            },
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비이름',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(258, 218, 255); ";
                return value;
            },
        }, {
            dataIndex: 'MODELSTANDARD',
            text: '모델 및 규격',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            }
        }, {
            dataIndex: 'MAKE',
            text: '제조사',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            }
        }, {
            dataIndex: 'MAKENO',
            text: '제조번호',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            }
        }, {
            dataIndex: 'MAKEDATE',
            text: '제조일자',
            xtype: 'datecolumn',
            width: 110,
            hidden: false,
            sortable: true,
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
            dataIndex: 'BUYDATE',
            text: '구입일자',
            xtype: 'datecolumn',
            width: 110,
            hidden: false,
            sortable: true,
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
            dataIndex: 'BUYAMOUNT',
            text: '구입금액',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            },
            renderer: function (value, meta, eOpts) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'DEPTNAME',
            text: '부서명',
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
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("DEPTCODE", record.data.VALUE);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("DEPTCODE", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div>' +
                        '<table>' +
                        '<tr>' +
                        '<td style="height: 25px; font-size: 13px;">{LABEL}</td>' +
                        '</tr>' +
                        '</table>' +
                        '</div>';
                    }
                },
            },
            renderer: renderer4combobox,
        }, {
            dataIndex: 'WORKDEPTNAME',
            text: '작업반',
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
                store: gridnms["store.12"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("WORKDEPT", record.data.VALUE);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("WORKDEPT", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div>' +
                        '<table>' +
                        '<tr>' +
                        '<td style="height: 25px; font-size: 13px;">{LABEL}</td>' +
                        '</tr>' +
                        '</table>' +
                        '</div>';
                    }
                },
            },
            renderer: renderer4combobox,
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '해당공정',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.13"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("ROUTINGCODE", record.data.VALUE);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("ROUTINGCODE", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div>' +
                        '<table>' +
                        '<tr>' +
                        '<td style="height: 25px; font-size: 13px;">{LABEL}</td>' +
                        '</tr>' +
                        '</table>' +
                        '</div>';
                    }
                },
            },
            renderer: renderer4combobox,
        }, {
            dataIndex: 'EQSETUPNAME',
            text: '장비구분',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.14"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("EQSETUP", record.data.VALUE);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("EQSETUP", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 120,
                    getInnerTpl: function () {
                        return '<div>' +
                        '<table>' +
                        '<tr>' +
                        '<td style="height: 25px; font-size: 13px;">{LABEL}</td>' +
                        '</tr>' +
                        '</table>' +
                        '</div>';
                    }
                },
            },
            renderer: renderer4combobox,
        }, {
            dataIndex: 'WORKCENTERCODEIF',
            text: '설비연결여부',
            xtype: 'gridcolumn',
            width: 100,
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
            },
        }, {
            dataIndex: 'SEQ',
            text: '출력순번',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(258, 218, 255); ";
                return value;
            },
        }, {
            dataIndex: 'EXCEPTYN',
            text: '우선순위<br>제외여부',
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
                store: ['Y', 'N'],
                matchFieldWidth: true,
                editable: false,
                allowBlank: true,
                typeAhead: true,
                forceSelection: false,
            },
        }, {
            dataIndex: 'GRADECHECKDATE',
            text: '등급측정일',
            xtype: 'datecolumn',
            width: 110,
            hidden: false,
            sortable: true,
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
            dataIndex: 'MANAGEGRADE',
            text: '관리등급',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            }
        }, {
            dataIndex: 'EFFECTIVESTARTDATE',
            text: '유효시작일',
            xtype: 'datecolumn',
            width: 110,
            hidden: false,
            resizable: true,
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
            dataIndex: 'EFFECTIVEENDDATE',
            text: '유효종료일',
            xtype: 'datecolumn',
            width: 110,
            hidden: false,
            resizable: true,
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
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'USEYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'DEPTCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKDEPT',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'EQSETUPOLD',
            xtype: 'hidden',
        }, {
            dataIndex: 'EQSETUP',
            xtype: 'hidden',
        }, {
            dataIndex: 'SAVEYN',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        create: "<c:url value='/insert/master/workcenter/WorkCenterMa.do' />"
    });
    $.extend(items["api.1"], {
        read: "<c:url value='/select/master/workcenter/WorkCenterMa.do' />"
    });
    $.extend(items["api.1"], {
        update: "<c:url value='/update/master/workcenter/WorkCenterMa.do' />"
    });
    $.extend(items["api.1"], {
        destroy: "<c:url value='/delete/master/workcenter/WorkCenterMa.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "추가",
        itemId: "btnAdd1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "삭제",
        itemId: "btnDel1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "저장",
        itemId: "btnSav1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "새로고침",
        itemId: "btnRef1"
    });

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#masterList": {
            itemclick: 'onMasterClick'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnAdd1": {
            click: 'btnAdd1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnDel1": {
            click: 'btnDel1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnSav1": {
            click: 'btnSav1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnRef1": {
            click: 'btnRef1Click'
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

var global_org_id = "", global_company_id = "", global_work_center_code = "";
function onMasterClick(dataview, record, item, index, e, eOpts) {
    global_org_id = record.data.ORGID;
    global_company_id = record.data.COMPANYID;
    global_work_center_code = record.data.WORKCENTERCODE;

    if (global_work_center_code != "") {

        var params = {
            ORGID: global_org_id,
            COMPANYID: global_company_id,
            WORKCENTERCODE: global_work_center_code,
        };
        extGridSearch(params, gridnms["store.2"]);

        var params2 = {
            orgid: global_org_id,
            companyid: global_company_id,
            EQUIPMENTCODE: global_work_center_code,
        };
        extGridSearch(params2, gridnms["store.3"]);
    } else {
        Ext.getStore(gridnms['store.2']).removeAll();
        Ext.getStore(gridnms['store.3']).removeAll();
    }
}

function btnAdd1Click(o, e) {
    var model = Ext.create(gridnms["model.1"]);
    var store = this.getStore(gridnms["store.1"]);

    var seq = Ext.getStore(gridnms["store.1"]).count() + 1;
    model.set("SEQ", seq);

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

    model.set("USEYN", "Y");
    model.set("SAVEYN", "N");
    model.set("EXCEPTYN", "N");
    model.set("WORKCENTERCODEIF", "N");
    model.set("ORGID", $('#searchOrgId').val());
    model.set("COMPANYID", $('#searchCompanyId').val());

    var startdate = Ext.util.Format.date("${searchVO.TODAY}", 'Y-m-d');
    var enddate = Ext.util.Format.date("4999-12-31", 'Y-m-d');
    model.set("EFFECTIVESTARTDATE", startdate);
    model.set("EFFECTIVEENDDATE", enddate);

    //    store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
    var view = Ext.getCmp(gridnms['panel.1']).getView();
    var startPoint = 0;

    store.insert(startPoint, model);
    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], startPoint, 1);
};

function btnSav1Click(o, e) {
    var count = Ext.getStore(gridnms["store.1"]).count();
    var header = [],
    check_count = 0;

    for (i = 0; i < count; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var saveyn = model1.data.SAVEYN;
        var workcentercode = model1.data.WORKCENTERCODE;
        var workcentername = model1.data.WORKCENTERNAME;
        var effectivestartdate = Ext.util.Format.date(model1.data.EFFECTIVESTARTDATE, 'Y-m-d');
        var effectiveenddate = Ext.util.Format.date(model1.data.EFFECTIVEENDDATE, 'Y-m-d');

        if (saveyn == "N") {
            if (workcentercode == "" || workcentercode == undefined) {
                header.push("설비코드");
                check_count++;
            }

            if (workcentername == "" || workcentername == undefined) {
                header.push("설비이름");
                check_count++;
            }

            if (effectivestartdate == "" || effectivestartdate == undefined) {
                header.push("유효시작일자");
                check_count++;
            }

            if (effectiveenddate == "" || effectiveenddate == undefined) {
                header.push("유효종료일자");
                check_count++;
            }
        }

        if (check_count > 0) {
            extAlert("[설비 필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
            return;
        }
    }

    Ext.getStore(gridnms["store.1"]).sync({
        success: function (batch, options) {
            extAlert(msgs.noti.save, gridnms["store.1"]);
            Ext.getStore(gridnms["store.1"]).load();
        },
        failure: function (batch, options) {
            extAlert(batch.exceptions[0].error, gridnms["store.1"]);
        },
        callback: function (batch, options) {},
    });
};

function btnDel1Click(o, e) {
    extGridDel(gridnms["store.1"], gridnms["panel.1"]);
};

function btnRef1Click(o, e) {
    Ext.getStore(gridnms["store.1"]).load();
};

function setValues_detail() {
    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.2"] = "WorkCenterRepairList";

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
            name: 'RN'
        }, {
            type: 'number',
            name: 'ORGID'
        }, {
            type: 'number',
            name: 'COMPANYID'
        }, {
            type: 'number',
            name: 'SEQNO'
        }, {
            type: 'string',
            name: 'WORKCENTERCODE'
        }, {
            type: 'date',
            name: 'REPAIRDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'REASONGUBUN',
        }, {
            type: 'string',
            name: 'REASONGUBUNNAME',
        }, {
            type: 'string',
            name: 'REASON',
        }, {
            type: 'string',
            name: 'REASONNAME',
        }, {
            type: 'string',
            name: 'DETAILREASON',
        }, {
            type: 'string',
            name: 'ACTIONCONTEXT',
        }, {
            type: 'string',
            name: 'ACTIONCONTEXTNAME',
        }, {
            type: 'string',
            name: 'REPAIRCENTERNAME',
        }, {
            type: 'number',
            name: 'MATCOST',
        }, {
            type: 'number',
            name: 'REPAIRCOST',
        }, {
            type: 'number',
            name: 'TOTAL',
        }, {
            type: 'string',
            name: 'ACTIONRESULT',
        }, {
            type: 'string',
            name: 'FOLLOWUP',
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, ];

    fields["columns.2"] = [
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'REPAIRDATE',
            text: '설비수리일자',
            xtype: 'datecolumn',
            width: 125,
            hidden: false,
            sortable: true,
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
                meta.style = "background-color:rgb(258, 218, 255); ";
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'ACTIONRESULT',
            text: '조치결과',
            xtype: 'gridcolumn',
            width: 300,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            }
        }, {
            dataIndex: 'REPAIRCENTERNAME',
            text: '수리처',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            }
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            //width: 240,
            flex: 1,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
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
            dataIndex: 'SEQNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'REASONGUBUN',
            xtype: 'hidden',
        }, {
            dataIndex: 'REASON',
            xtype: 'hidden',
        }, {
            dataIndex: 'DETAILREASON',
            xtype: 'hidden',
        }, {
            dataIndex: 'ACTIONCONTEXT',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMSTANDARD',
            xtype: 'hidden',
        }, {
            dataIndex: 'MATCOST',
            xtype: 'hidden',
        }, {
            dataIndex: 'REPAIRCOST',
            xtype: 'hidden',
        }, {
            dataIndex: 'FOLLOWUP',
            xtype: 'hidden',
        }, {
            dataIndex: 'ENDDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'SAVEYN',
            xtype: 'hidden',
        }, ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        create: "<c:url value='/insert/equipment/manage/EquipmentRepairList.do' />"
    });
    $.extend(items["api.2"], {
        read: "<c:url value='/select/equipment/manage/EquipmentRepairList.do' />"
    });
    $.extend(items["api.2"], {
        update: "<c:url value='/update/equipment/manage/EquipmentRepairList.do' />"
    });
    $.extend(items["api.2"], {
        destroy: "<c:url value='/delete/equipment/manage/EquipmentRepairList.do' />"
    });

    items["btns.2"] = [];
    items["btns.2"].push({
        xtype: "button",
        text: "추가",
        itemId: "btnAdd2"
    });
    items["btns.2"].push({
        xtype: "button",
        text: "삭제",
        itemId: "btnDel2"
    });
    items["btns.2"].push({
        xtype: "button",
        text: "저장",
        itemId: "btnSav2"
    });
    items["btns.2"].push({
        xtype: "button",
        text: "새로고침",
        itemId: "btnRef2"
    });

    items["btns.ctr.2"] = {};
    $.extend(items["btns.ctr.2"], {
        "#btnAdd2": {
            click: 'btnAdd2Click'
        }
    });
    $.extend(items["btns.ctr.2"], {
        "#btnDel2": {
            click: 'btnDel2Click'
        }
    });
    $.extend(items["btns.ctr.2"], {
        "#btnSav2": {
            click: 'btnSav2Click'
        }
    });
    $.extend(items["btns.ctr.2"], {
        "#btnRef2": {
            click: 'btnRef2Click'
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

function btnAdd2Click(o, e) {
    var model2 = Ext.create(gridnms["model.2"]);
    var store = this.getStore(gridnms["store.2"]);

    var orgid = (global_org_id == "") ? $('#searchOrgId').val() : global_org_id;
    var companyid = (global_company_id == "") ? $('#searchCompanyId').val() : global_company_id;
    var workcentercode = global_work_center_code;
    if (workcentercode !== "") {

        var sortorder = 0;
        var listcount = Ext.getStore(gridnms["store.2"]).count();
        for (var i = 0; i < listcount; i++) {
            Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
            var dummy = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

            var dummy_sort = dummy.data.RN * 1;
            if (sortorder < dummy_sort) {
                sortorder = dummy_sort;
            }
        }
        sortorder++;
        model2.set("RN", sortorder);

        model2.set("ORGID", orgid);
        model2.set("COMPANYID", companyid);
        model2.set("WORKCENTERCODE", workcentercode);

        var today = new Date();
        var today_c = Ext.util.Format.date(today, 'Y-m-d');
        model2.set("REPAIRDATE", today_c);

        var view = Ext.getCmp(gridnms['panel.2']).getView();
        var startPoint = 0;

        store.insert(startPoint, model2);
        fn_grid_focus_move("UP", gridnms["store.2"], gridnms["views.detail"], startPoint, 1);
    }
};

function btnSav2Click(o, e) {
    var count2 = Ext.getStore(gridnms["store.2"]).count();
    var header = [],
    check_count = 0;

    for (i = 0; i < count2; i++) {
        Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
        var model2 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

        var saveyn = model2.data.SAVEYN;
        var workcentercode = model2.data.WORKCENTERCODE;
        var repairdate = Ext.util.Format.date(model2.data.REPAIRDATE, 'Y-m-d');
        var actionresult = model2.data.ACTIONRESULT;
        var repaircentername = model2.data.REPAIRCENTERNAME;

        if (saveyn == "N") {
            if (workcentercode == "" || workcentercode == undefined) {
                header.push("설비코드");
                check_count++;
            }

            if (repairdate == "" || repairdate == undefined) {
                header.push("설비수리일자");
                check_count++;
            }

            if (actionresult == "" || actionresult == undefined) {
                header.push("조치결과");
                check_count++;
            }

            if (repaircentername == "" || repaircentername == undefined) {
                header.push("수리처");
                check_count++;
            }
        }

        if (check_count > 0) {
            extAlert("[설비 수리내역 필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
            return;
        }
    }

    Ext.getStore(gridnms["store.2"]).sync({
        success: function (batch, options) {
            extAlert(msgs.noti.save, gridnms["store.2"]);
            Ext.getStore(gridnms["store.2"]).load();
        },
        failure: function (batch, options) {
            extAlert(batch.exceptions[0].error, gridnms["store.2"]);
        },
        callback: function (batch, options) {},
    });
};

function btnDel2Click(o, e) {
    extGridDel(gridnms["store.2"], gridnms["panel.2"]);
};

function btnRef2Click(o, e) {
    Ext.getStore(gridnms["store.2"]).load();
};

function setValues_interface() {
    gridnms["models.interface"] = [];
    gridnms["stores.interface"] = [];
    gridnms["views.interface"] = [];
    gridnms["controllers.interface"] = [];

    gridnms["grid.3"] = "WorkcenterInterface";

    gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
    gridnms["views.interface"].push(gridnms["panel.3"]);

    gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
    gridnms["controllers.interface"].push(gridnms["controller.3"]);

    gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

    gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

    gridnms["models.interface"].push(gridnms["model.3"]);

    gridnms["stores.interface"].push(gridnms["store.3"]);

    fields["model.3"] = [{
            type: 'date',
            name: 'STARTTIME',
            dateFormat: 'Y-m-d H:i:s',
        }, {
            type: 'string',
            name: 'IFTIME',
            //        dateFormat: 'H-i',
        }, {
            type: 'string',
            name: 'IFCODE',
        }, {
            type: 'number',
            name: 'QTY',
        }, {
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'number',
            name: 'RN',
        }, ];

    fields["columns.3"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'STARTTIME',
            text: '일자',
            xtype: 'datecolumn',
            width: 150,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d H:i:s',
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d H:i:s');
            },
        }, {
            dataIndex: 'QTY',
            text: '수량',
            xtype: 'gridcolumn',
            //             width: 100,
            flex: 1,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        },
        // Hidden Columns
        {
            //        dataIndex: 'IFCODE',
            //        xtype: 'hidden',
            //      }, {
            dataIndex: 'IP',
            xtype: 'hidden',
        }, ];

    items["api.3"] = {};
    $.extend(items["api.3"], {
        read: "<c:url value='/select/master/workcenter/WorkCenterInterface.do' />"
    });

    items["btns.3"] = [];
    items["btns.3"].push({
        xtype: "button",
        text: "새로고침",
        itemId: "btnRef3"
    });

    items["btns.ctr.3"] = {};
    $.extend(items["btns.ctr.3"], {
        "#btnRef3": {
            click: 'btnRef3Click'
        }
    });

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

function btnRef3Click(o, e) {
    Ext.getStore(gridnms["store.3"]).load();
};

var gridarea, gridarea1, gridarea2;
function setExtGrid() {
    setExtGrid_master();
    setExtGrid_detail();
    setExtGrid_interface();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
        gridarea1.updateLayout();
        gridarea2.updateLayout();
    });
}

function setExtGrid_master() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"]
    });

    Ext.define(gridnms["model.11"], {
        extend: Ext.data.Model,
        fields: fields["model.11"]
    });

    Ext.define(gridnms["model.12"], {
        extend: Ext.data.Model,
        fields: fields["model.12"]
    });

    Ext.define(gridnms["model.13"], {
        extend: Ext.data.Model,
        fields: fields["model.13"]
    });

    Ext.define(gridnms["model.14"], {
        extend: Ext.data.Model,
        fields: fields["model.14"]
    });

    Ext.define(gridnms["store.1"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.1"],
                        model: gridnms["model.1"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            api: items["api.1"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        },
                        listeners: {
                            load: function (dataStore, rows, bool) {
                                var emptyValue = "";
                                var cnt = rows.length;
                                if (cnt > 0) {
                                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(0));
                                    var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                                    global_org_id = model.data.ORGID;
                                    global_company_id = model.data.COMPANYID;
                                    global_work_center_code = model.data.WORKCENTERCODE;

                                    var params = {
                                        ORGID: global_org_id,
                                        COMPANYID: global_company_id,
                                        WORKCENTERCODE: global_work_center_code,
                                    };
                                    extGridSearch(params, gridnms["store.2"]);

                                    var params2 = {
                                        orgid: global_org_id,
                                        companyid: global_company_id,
                                        EQUIPMENTCODE: global_work_center_code,
                                    };
                                    extGridSearch(params2, gridnms["store.3"]);
                                } else {
                                    global_org_id = emptyValue;
                                    global_company_id = emptyValue;
                                    global_work_center_code = emptyValue;
                                    Ext.getStore(gridnms['store.2']).removeAll();
                                    Ext.getStore(gridnms['store.3']).removeAll();
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
                            type: 'ajax',
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'CMM',
                                MIDDLECD: 'DEPT_CODE',
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
                            type: 'ajax',
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'CMM',
                                MIDDLECD: 'WORK_DEPT',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.13"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.13"],
                        model: gridnms["model.13"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'MFG',
                                MIDDLECD: 'ROUTING_GROUP',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.14"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.14"],
                        model: gridnms["model.14"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'CMM',
                                MIDDLECD: 'EQ_SETUP',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            masterList: '#masterList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        onMasterClick: onMasterClick,
        btnAdd1Click: btnAdd1Click,
        btnSav1Click: btnSav1Click,
        btnDel1Click: btnDel1Click,
        btnRef1Click: btnRef1Click,
    });

    Ext.define(gridnms["panel.1"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.1"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.1"],
                id: gridnms["panel.1"],
                store: gridnms["store.1"],
                height: 436,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'masterList',
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = ["WORKCENTERCODE"];

                                var isNew = ctx.record.phantom || false;
                                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                                    return false;
                                else {
                                    return true;
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
        fields: fields["model.2"]
    });

    Ext.define(gridnms["store.2"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.2"],
                        model: gridnms["model.2"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            api: items["api.2"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                orgid: $("#searchOrgId").val(),
                                companyid: $("#searchCompanyId").val(),
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
            btnLine2: '#btnLine2',
        },
        stores: [gridnms["store.2"]],
        control: items["btns.ctr.2"],

        btnAdd2Click: btnAdd2Click,
        btnSav2Click: btnSav2Click,
        btnDel2Click: btnDel2Click,
        btnRef2Click: btnRef2Click,
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
                height: 250,
                border: 2,
                scrollable: true,
                columns: fields["columns.2"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'btnLine2',
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var editDisableCols = ["WORKCD"];
                                var isNew = ctx.record.phantom || false;
                                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                                    return false;
                                else {
                                    return true;
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
                renderTo: 'gridAreaDetail'
            });
        },
    });
}

function setExtGrid_interface() {
    Ext.define(gridnms["model.3"], {
        extend: Ext.data.Model,
        fields: fields["model.3"]
    });

    Ext.define(gridnms["store.3"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.3"],
                        model: gridnms["model.3"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            api: items["api.3"],
                            timeout: gridVals.timeout,
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.3"], {
        extend: Ext.app.Controller,
        refs: {
            btnInterface: '#btnInterface',
        },
        stores: [gridnms["store.3"]],
        control: items["btns.ctr.3"],

        btnRef3Click: btnRef3Click,
    });

    Ext.define(gridnms["panel.3"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.3"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.3"],
                id: gridnms["panel.3"],
                store: gridnms["store.3"],
                height: 250,
                border: 2,
                scrollable: true,
                columns: fields["columns.3"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'btnInterface',
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
        models: gridnms["models.interface"],
        stores: gridnms["stores.interface"],
        views: gridnms["views.interface"],
        controllers: gridnms["controller.3"],

        launch: function () {
            gridarea2 = Ext.create(gridnms["views.interface"], {
                renderTo: 'gridAreaInterface'
            });
        },
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var itemcode = $("#searchWorkcenterName").val();
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
    var workcentercode = $("#searchWorkcenterCode").val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        WORKCENTERCODE: workcentercode,
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_excel_download() {
    if (!fn_validation()) {
        return;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var workcentercode = $("#searchWorkcenterCode").val();
    var title = $('#title').val();

    go_url("<c:url value='/workcenter/ExcelDownload.do?GUBUN='/>" + "WORKCENTER"
         + "&ORGID=" + orgid + ""
         + "&COMPANYID=" + companyid + ""
         + "&workcentercode=" + workcentercode + ""
         + "&TITLE=" + title + "");
}

function setLovList() {
    $("#searchWorkcenterName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#searchWorkcenterCode").val("");
            //             $("#searchWorkcenterName").val("");
            break;
        case $.ui.keyCode.ENTER:
            $(this).autocomplete("search", "%");
            break;

        default:
            break;
        }
    })
    .focus(function (e) {
        $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
    })
    .autocomplete({
        source: function (request, response) {
            $.getJSON("<c:url value='/searchWorkCenterLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val()
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.VALUE,
                            label: m.LABEL + ((m.MODELSTANDARD == undefined) ? "" : (", " + m.MODELSTANDARD)),
                            name: m.LABEL,
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
            $("#searchWorkcenterCode").val(o.item.value);
            $("#searchWorkcenterName").val(o.item.name);
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
																<li>기준정보</li>
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
												<fieldset>
														<legend>조건정보 영역</legend>
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
															<table class="tbl_type_view" border="1">
																	<colgroup>
																			<col width="10%">
																			<col width="20%">
																			<col width="10%">
																			<col width="20%">
																			<col width="10%">
																			<col width="20%">
																			<col>
																	</colgroup>
																	<tr>
																			<th class="required_text">사업장</th>
																			<td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 80%;">
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
																			<th class="required_text">공장</th>
																			<td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 80%;">
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
																			<th class="required_text">설비명</th>
																			<td>
																				<input type="text" id="searchWorkcenterName" name="searchWorkcenterName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" />
																				<input type="hidden" id="searchWorkcenterCode" name="searchWorkcenterCode" />
																			</td>
																			<td>
																					<div class="buttons" style="float: right; margin-top: 3px;">
																							<div class="buttons" style="float: right;">
																									<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
	                                                <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();">
	                                                   엑셀
	                                                </a>
																							</div>
																					</div>
																			</td>
																	</tr>
															</table>
												</fieldset>
										</div>
										<!-- //검색 필드 박스 끝 -->

										<div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 77%;"><div class="subConTit3" style="margin-top: 10px;">수리내역 List</div></td>
                            <td style="width: 21%;"><div class="subConTit3" style="margin-top: 10px; margin-left: 1%; ">설비 I/F</div></td>
                        </tr>
                    </table>
										<div id="gridAreaDetail" style="width: 77%; padding-bottom: 5px; float: left;"></div>
                    <div id="gridAreaInterface" style="width: 21%; margin-left: 1%; padding-bottom: 5px; float: left;"></div>
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