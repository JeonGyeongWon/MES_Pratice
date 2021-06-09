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

    setReadOnly();

    setLovList();
});

var gridfilter2, gridfilter3, gridfilter4;
var emptyValue = "";
function setInitial() {
    gridnms["app"] = "base";

    gridfilter2 = fn_option_filter_data(1, 1, 'CMM', 'DEPT_CODE', 'LABEL');
    gridfilter3 = fn_option_filter_data(1, 1, 'CMM', 'POSITION_CODE', 'LABEL');
    gridfilter4 = fn_option_filter_data(1, 1, 'CMM', 'INSPECTOR_TYPE', 'LABEL');

    fn_option_change('CMM', 'INSPECTOR_TYPE', 'searchInspectorType');
    fn_option_change('CMM', 'DEPT_CODE', 'searchDeptCode');
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_list();
    setValues_org();
    setValues_equip();
}

function setValues_list() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "humanList";
    gridnms["grid.11"] = "departmentLov";
    gridnms["grid.12"] = "positionLov";
    gridnms["grid.13"] = "inspectorLov";
    gridnms["grid.14"] = "upperLov";
    gridnms["grid.15"] = "eqsetupLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
    gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];
    gridnms["model.13"] = gridnms["app"] + ".model." + gridnms["grid.13"];
    gridnms["model.14"] = gridnms["app"] + ".model." + gridnms["grid.14"];
    gridnms["model.15"] = gridnms["app"] + ".model." + gridnms["grid.15"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
    gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];
    gridnms["store.13"] = gridnms["app"] + ".store." + gridnms["grid.13"];
    gridnms["store.14"] = gridnms["app"] + ".store." + gridnms["grid.14"];
    gridnms["store.15"] = gridnms["app"] + ".store." + gridnms["grid.15"];

    gridnms["models.list"].push(gridnms["model.1"]);
    gridnms["models.list"].push(gridnms["model.11"]);
    gridnms["models.list"].push(gridnms["model.12"]);
    gridnms["models.list"].push(gridnms["model.13"]);
    gridnms["models.list"].push(gridnms["model.14"]);
    gridnms["models.list"].push(gridnms["model.15"]);

    gridnms["stores.list"].push(gridnms["store.1"]);
    gridnms["stores.list"].push(gridnms["store.11"]);
    gridnms["stores.list"].push(gridnms["store.12"]);
    gridnms["stores.list"].push(gridnms["store.13"]);
    gridnms["stores.list"].push(gridnms["store.14"]);
    gridnms["stores.list"].push(gridnms["store.15"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'RN'
        }, {
            type: 'string',
            name: 'DEPARTMENTCODE',
        }, {
            type: 'string',
            name: 'DEPARTMENTNAME',
        }, {
            type: 'string',
            name: 'POSITIONCODE',
        }, {
            type: 'string',
            name: 'POSITIONNAME',
        }, {
            type: 'string',
            name: 'INSPECTORTYPENAME'
        }, {
            type: 'string',
            name: 'EMPLOYEENUMBER',
        }, {
            type: 'string',
            name: 'KRNAME',
        }, {
            type: 'string',
            name: 'USEYN',
        }, {
            type: 'string',
            name: 'TOPSIZE',
        }, {
            type: 'number',
            name: 'PANTSSIZE',
        }, {
            type: 'date',
            name: 'EFFECTIVESTARTDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'EFFECTIVEENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'PHONENUMBER'
        }
    ];

    fields["model.11"] = [{
            type: 'string',
            name: 'VALUE'
        }, {
            type: 'string',
            name: 'LABEL'
        }
    ];

    fields["model.12"] = [{
            type: 'string',
            name: 'VALUE'
        }, {
            type: 'string',
            name: 'LABEL'
        }
    ];

    fields["model.13"] = [{
            type: 'string',
            name: 'VALUE'
        }, {
            type: 'string',
            name: 'LABEL'
        }
    ];

    fields["model.14"] = [{
            type: 'string',
            name: 'VALUE'
        }, {
            type: 'string',
            name: 'LABEL'
        }
    ];

    fields["model.15"] = [{
            type: 'string',
            name: 'VALUE'
        }, {
            type: 'string',
            name: 'LABEL'
        }
    ];

    fields["columns.1"] = [
        // Display columns
        {
            dataIndex: "EMPLOYEENUMBER",
            text: "사원번호",
            xtype: "gridcolumn",
            width: 120,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: false,
            filterable: true,
            filter: {
                type: 'string',
            },
            align: "center",
            editor: {
                xtype: "textfield",
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
                    meta.style = "background-color:rgb(234, 234, 234);";
                } else {
                    meta.style = "background-color:rgb(258, 218, 255);";
                }

                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213);";
                }
                return value;
            },
        }, {
            dataIndex: 'KRNAME',
            text: '이름',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: true,
            menuDisabled: true,
            align: "center",
            editor: {
                allowBlank: true,
                xtype: "textfield",
                listeners: {
                    change: function (field, newValue) {
                        field.setValue(newValue.toUpperCase());
                    },
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255);";

                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213);";
                }
                return value;
            },
        }, {
            dataIndex: 'DEPARTMENTNAME',
            text: '부서',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: true,
            menuDisabled: false,
            filter: {
                type: 'list',
                options: gridfilter2,
            },
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
                hideTrigger: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("DEPARTMENTCODE", record.data.VALUE);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("DEPARTMENTCODE", "");
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
            renderer: function (value, meta, record) {

                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213);";
                }
                return value;
            },
        }, {
            dataIndex: 'POSITIONNAME',
            text: '직위',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: true,
            menuDisabled: false,
            filter: {
                type: 'list',
                options: gridfilter3,
            },
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
                hideTrigger: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("POSITIONCODE", record.data.VALUE);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("POSITIONCODE", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 110,
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
            renderer: function (value, meta, record) {

                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213);";
                }
                return value;
            },
        }, {
            dataIndex: 'INSPECTORTYPENAME',
            text: '사원구분',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: true,
            menuDisabled: false,
            filter: {
                type: 'list',
                options: gridfilter4,
            },
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
                hideTrigger: true,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("INSPECTORTYPE", record.data.VALUE);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("INSPECTORTYPE", "");
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 330,
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255); ";
                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213); ";
                }
                return value;
            },
        }, {
            dataIndex: 'EQSETUPNAME',
            text: '장비구분',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: true,
            menuDisabled: false,
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.15"],
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
//                 hideTrigger: true,
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
                    width: 330,
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
            renderer: function (value, meta, record) {
                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213); ";
                }
                return value;
            },
        }, {
            dataIndex: 'PHONENUMBER',
            text: '연락처',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            editor: {
                allowBlank: true,
                xtype: "textfield",
            },
            renderer: function (value, meta, record) {

                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213); ";
                }
                return value;
            },
        }, {
            dataIndex: 'TOPSIZE',
            text: '상의<br/>사이즈',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            editor: {
                allowBlank: true,
                xtype: "textfield",
            },
            renderer: function (value, meta, record) {

                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213); ";
                }
                return value;
            },
        }, {
            dataIndex: 'PANTSSIZE',
            text: '신발<br/>사이즈',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: false,
            filterable: true,
            filter: {
                type: 'number',
            },
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            editor: {
                xtype: "textfield",
                minValue: 1,
                format: "0,000",
                enforceMaxLength: true,
                allowBlank: true,
                maxLength: '20',
                maskRe: /[0-9]/,
                selectOnFocus: true,
            },
            renderer: function (value, meta, record) {
                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213); ";
                }
                return value;
            },
        }, {
            dataIndex: 'EFFECTIVESTARTDATE',
            text: '입사일자',
            xtype: 'datecolumn',
            width: 115,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: false,
            filterable: true,
            filter: {
                type: 'date',
            },
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
                meta.style = "background-color:rgb(253, 218, 255); ";
                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213); ";
                }
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'EFFECTIVEENDDATE',
            text: '퇴사일자',
            xtype: 'datecolumn',
            width: 115,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: false,
            filterable: true,
            filter: {
                type: 'date',
            },
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
                listeners: {
                    select: function (value, record) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        var temp = Ext.Date.format(value.getValue(), 'Y-m-d');
                        var end = Ext.Date.format('4999-12-31', 'Y-m-d');

                        if (temp != end) {
                            store.set("USEYN", "N");
                        }

                    },
                    specialkey: function (field, e, eOpts) {
                        if (e.keyCode == e.TAB) {
                            // Tab 키를 눌렀을 때 작동
                            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                            var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                            var temp = Ext.Date.format(field.getValue(), 'Y-m-d');
                            var end = Ext.Date.format('4999-12-31', 'Y-m-d');

                            if (temp != end) {
                                store.set("USEYN", "N");
                            }
                        }

                    },
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255); ";
                if (record.data.RESIGNYN == "N") {
                    meta.style = "color:rgb(213, 213, 213); ";
                }
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        },
        // Hidden Columns
        {
            dataIndex: 'DEPARTMENTCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'POSITIONCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPECTORTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'EQSETUP',
            xtype: 'hidden',
        }, {
            dataIndex: 'USEYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SAVEYN',
            xtype: 'hidden',
        },
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        create: "<c:url value='/insert/human/HumanResourceList.do' />"
    });
    $.extend(items["api.1"], {
        read: "<c:url value='/select/human/HumanResourceList.do' />"
    });
    $.extend(items["api.1"], {
        update: "<c:url value='/update/human/HumanResourceList.do' />"
    });
    $.extend(items["api.1"], {
        destroy: "<c:url value='/delete/human/HumanResourceList.do' />"
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
    //    items["btns.1"].push({
    //      xtype: "button",
    //      text: "펼치기 / 접기",
    //      itemId: "btnAll1"
    //    });

    items["btns.ctr.1"] = {};
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
    $.extend(items["btns.ctr.1"], {
        "#btnAll1": {
            click: 'btnAll1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#humanList": {
            itemclick: 'onMasterClick'
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

function btnAdd1Click(o, e) {
    var model = Ext.create(gridnms["model.1"]);
    var store = this.getStore(gridnms["store.1"]);

    model.set("LEADERYN", "N");
    model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
    model.set("EFFECTIVEENDDATE", "4999-12-31");
    model.set("USEYN", "Y");
    model.set("SAVEYN", "N");

    //    store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
    var view = Ext.getCmp(gridnms['panel.1']).getView();
    var startPoint = 0;

    store.insert(startPoint, model);
    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], startPoint, 0);
};

function btnSav1Click(o, e) {
//     extGridSave(gridnms["store.1"], gridnms["panel.1"]);
    
        Ext.getStore(gridnms["store.1"]).sync({
            success: function (batch, options) {
                var reader = batch.proxy.getReader();
                extAlert(reader.rawData.msg, gridnms["store.1"]);

//                 Ext.getStore(gridnms["store.1"]).load();
                Ext.getStore(gridnms['store.1']).load(function (records, operation, success) {
                    Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rowIdx);
                    Ext.getCmp(gridnms["views.list"]).getView().focusRow(rowIdx);
                    Ext.getCmp(gridnms["views.list"]).view.bufferedRenderer.scrollTo(rowIdx, true);
                });

                setTimeout(function () {
                    Ext.getStore(gridnms["store.2"]).proxy.setExtraParam('EMPLOYEENUMBER', global_employee_number);
                    Ext.getStore(gridnms["store.2"]).load();
                    Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('EMPLOYEENUMBER', global_employee_number);
                    Ext.getStore(gridnms["store.3"]).load();
                }, 300);
            },
            failure: function (batch, options) {
                msg = batch.operations[0].error;
                extAlert(msg);
            },
            callback: function (batch, options) {},
        });
};

function btnDel1Click(o, e) {
    extGridDel(gridnms["store.1"], gridnms["panel.1"]);
};

function btnRef1Click(o, e) {
    Ext.getStore(gridnms["store.1"]).load();

    Ext.getStore(gridnms["store.2"]).removeAll();
    Ext.getStore(gridnms["store.3"]).removeAll();
};

var btn_click = true;
function btnAll1Click(o, e) {
    if (btn_click) {
        // 접기
        Ext.getCmp(gridnms["panel.1"]).features[0].collapseAll();
        btn_click = false;
    } else {
        // 열기
        Ext.getCmp(gridnms["panel.1"]).features[0].expandAll();
        btn_click = true;
    }
};

var global_employee_number = "";
var rowIdx = 0, colIdx = 0;
function onMasterClick(dataview, record, item, index, e, eOpts) {
    rowIdx = e.position.rowIdx;
    colIdx = e.position.colIdx;
    var dataIndex = e.position.column.dataIndex;
    
    global_employee_number = record.data.EMPLOYEENUMBER;

    Ext.getStore(gridnms["store.2"]).proxy.setExtraParam('EMPLOYEENUMBER', global_employee_number);
    Ext.getStore(gridnms["store.2"]).load();
    Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('EMPLOYEENUMBER', global_employee_number);
    Ext.getStore(gridnms["store.3"]).load();
    global_check_Flag = false;
};

function setValues_org() {
    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.2"] = "orgList";

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
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'ORGCODE',
        }, {
            type: 'string',
            name: 'ORGNAME',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'COMPANYNAME'
        }, {
            type: 'string',
            name: 'EMPLOYEENUMBER',
        }, {
            type: 'string',
            name: 'CHK',
        }, {
            type: 'string',
            name: 'REMARKS'
        },
    ];

    fields["columns.2"] = [
        // Display columns
        {
            dataIndex: 'ORGNAME',
            text: '사업장',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'COMPANYNAME',
            text: '공장',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            //        width: 170,
            flex: 1,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            editor: {
                allowBlank: true,
                xtype: "textfield",
            },
        }, {
            dataIndex: 'CHK',
            text: '연결여부',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            align: "center",
            editor: {
                xtype: 'combo',
                store: ['Y', 'N'],
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                return value;
            },
        },
        // Hidden Columns
        {
            dataIndex: 'EMPLOYEENUMBER',
            xtype: 'hidden',
        }, {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        },
    ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/human/HumanResourceDetail.do' />"
    });
    $.extend(items["api.2"], {
        update: "<c:url value='/update/human/HumanResourceDetail.do' />"
    });

    items["btns.2"] = [];
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

function btnSav2Click(o, e) {
    extGridSave(gridnms["store.2"]);
};

function btnRef2Click(o, e) {
    Ext.getStore(gridnms["store.2"]).load();
};

function setValues_equip() {
    gridnms["models.equip"] = [];
    gridnms["stores.equip"] = [];
    gridnms["views.equip"] = [];
    gridnms["controllers.equip"] = [];

    gridnms["grid.3"] = "equipList";

    gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
    gridnms["views.equip"].push(gridnms["panel.3"]);

    gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
    gridnms["controllers.equip"].push(gridnms["controller.3"]);

    gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

    gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

    gridnms["models.equip"].push(gridnms["model.3"]);

    gridnms["stores.equip"].push(gridnms["store.3"]);

    fields["model.3"] = [{
            type: 'number',
            name: 'RN'
        }, {
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, {
            type: 'string',
            name: 'EMPLOYEENUMBER'
        }, {
            type: 'boolean',
            name: 'CHK',
        }, {
            type: 'string',
            name: 'REMARKS',
        },
    ];

    fields["columns.3"] = [
        // Display columns
        {
            dataIndex: 'WORKCENTERNAME',
            text: '설비명',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            //        width: 200,
            flex: 1,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            editor: {
                allowBlank: true,
                xtype: "textfield",
            }
        }, {
            dataIndex: 'CHK',
            text: '연결여부',
            xtype: 'checkcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            align: "center",
            //        editor: {
            //          xtype: 'combo',
            //          store: ['Y', 'N'],
            //          editable: false,
            //        },
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'EMPLOYEENUMBER',
            xtype: 'hidden',
        },
    ];

    items["api.3"] = {};
    $.extend(items["api.3"], {
        read: "<c:url value='/select/human/HumanResourceEquip.do' />"
    });
    $.extend(items["api.3"], {
        update: "<c:url value='/update/human/HumanResourceEquip.do' />"
    });

    items["btns.3"] = [];
    items["btns.3"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChkd3"
    });
    items["btns.3"].push({
        xtype: "button",
        text: "저장",
        itemId: "btnSav3"
    });
    items["btns.3"].push({
        xtype: "button",
        text: "새로고침",
        itemId: "btnRef3"
    });

    items["btns.ctr.3"] = {};
    $.extend(items["btns.ctr.3"], {
        "#btnChkd3": {
            click: 'btnChk3Click'
        }
    });
    $.extend(items["btns.ctr.3"], {
        "#btnSav3": {
            click: 'btnSav3Click'
        }
    });
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
    items["docked.3"].push(items["dock.btn.3"]);
}

function btnSav3Click(o, e) {
    extGridSave(gridnms["store.3"]);
};

function btnRef3Click(o, e) {
    Ext.getStore(gridnms["store.3"]).load();
};

var global_check_Flag = false;
function btnChk3Click() {
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var checkTrue = 0,
    checkFalse = 0;

    if (global_check_Flag) {
        global_check_Flag = false;
    } else {
        global_check_Flag = true;
    }

    for (i = 0; i <= count1; i++) {
        Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.equip"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.equip"]).selModel.getSelection()[0];

        if (global_check_Flag) {
            model1.set("CHK", true);
            checkFalse++;
        } else {
            model1.set("CHK", false);
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

var baseitem, detailitem, equipitem;
function setExtGrid() {
    setExtGrid_list();
    setExtGrid_org();
    setExtGrid_equip();
}

function setExtGrid_list() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"]
    });

    Ext.tip.QuickTipManager.init();

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

    Ext.define(gridnms["model.15"], {
        extend: Ext.data.Model,
        fields: fields["model.15"]
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
                        isStore: false,
                        autoDestroy: true,
                        clearOnPageLoad: true,
                        clearRemovedOnLoad: true,
                        //            groupField: "POSITIONNAME",
                        //            groupDir: 'ASC',
                        //            sorters: [{
                        //                    property: 'POSITIONNAME',
                        //                    direction: 'ASC'
                        //                  }, {
                        //                    property: 'KRNAME',
                        //                    direction: 'ASC'
                        //                  }
                        //                ],
                        //              remoteFilter: false,
                        //              remoteSort: true,
                        //              buffered: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            api: items["api.1"],
                            timeout: gridVals.timeout,
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
                                    	global_employee_number = model.data.EMPLOYEENUMBER;
                                    }

                                    Ext.getStore(gridnms["store.2"]).proxy.setExtraParam('EMPLOYEENUMBER', global_employee_number);
                                    Ext.getStore(gridnms["store.2"]).load();
                                    Ext.getStore(gridnms["store.3"]).proxy.setExtraParam('EMPLOYEENUMBER', global_employee_number);
                                    Ext.getStore(gridnms["store.3"]).load();
                                    global_check_Flag = false;
                                } else {
                                	global_employee_number = "";
                                    Ext.getStore(gridnms['store.2']).removeAll();
                                    Ext.getStore(gridnms['store.3']).removeAll();
                                    global_check_Flag = false;
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
                                ORGID: '1',
                                COMPANYID: '1',
                                BIGCD: 'CMM',
                                MIDDLECD: 'DEPT_CODE',
                                GUBUN: 'DEPT_CODE',
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
                                ORGID: '1',
                                COMPANYID: '1',
                                BIGCD: 'CMM',
                                MIDDLECD: 'POSITION_CODE',
                                GUBUN: 'POSITION_CODE',
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
                                ORGID: '1',
                                COMPANYID: '1',
                                BIGCD: 'CMM',
                                MIDDLECD: 'INSPECTOR_TYPE',
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
                            url: "<c:url value='/searchWorkerLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {},
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.15"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.15"],
                        model: gridnms["model.15"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: '1',
                                COMPANYID: '1',
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
            humanList: '#humanList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        btnAdd1Click: btnAdd1Click,
        btnSav1Click: btnSav1Click,
        btnDel1Click: btnDel1Click,
        btnRef1Click: btnRef1Click,
        btnAll1Click: btnAll1Click,
        onMasterClick: onMasterClick,
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
                height: 450,
                border: 2,
                scrollable: true,
                multiColumnSort: true,
                collapsible: false,
                animCollapse: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'humanList'
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;
                                var editDisableCols = [];
                                
                                editDisableCols.push("EMPLOYEENUMBER");
                                
                                if ( data.data.RESIGNYN == "N" ) {
                                    editDisableCols.push("KRNAME");
                                    editDisableCols.push("DEPARTMENTNAME");
                                    editDisableCols.push("POSITIONNAME");
                                    editDisableCols.push("INSPECTORTYPENAME");
                                    editDisableCols.push("EQSETUPNAME");
                                    editDisableCols.push("PHONENUMBER");
                                    editDisableCols.push("TOPSIZE");
                                    editDisableCols.push("PANTSSIZE");
                                    editDisableCols.push("EFFECTIVESTARTDATE");
                                }
                                
                                var isNew = ctx.record.phantom || false;
                                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                                    return false;
                                else {
                                    return true;
                                }
                            }
                        },
                    }, 'gridfilters', ],
                //          features: [$.extend(gridVals.groupingFeature, {
                //              groupHeaderTpl: [
                //                '{columnName}: {name:this.formatName} ({[values.children[0].data["KRNAME"]]} {[values.children.length > 1 ? "포함" : ""]} {rows.length}명) / 소계: {[this.groupSum(values.children, "PANTSSIZE")]}', {
                //                  formatName: function (name) {
                //                    var result = (name == "") ? "미정 " : name;
                //                    return Ext.String.trim(result);
                //                  },
                //                  groupSum: function (record, field) {
                //                    var result = record;
                //                    var size = record.length;
                //                    var sum = 0;

                //                    if (size > 0) {
                //                      for (var i = 0; i < size; i++) {
                //                        sum += parseFloat(result[i].data[field]);
                //                      }
                //                    } else {
                //                      sum = 0;
                //                    }
                //                    return Ext.util.Format.number(sum, '0,000');
                //                  }
                //                },
                //              ],
                //            }
                //          ), {
                //              ftype: 'summary',
                //              dock: 'bottom'
                //            }
                //          ],
                dockedItems: items["docked.1"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.list"],
        stores: gridnms["stores.list"],
        views: gridnms["panel.1"],
        controllers: gridnms["controller.1"],

        launch: function () {
            baseitem = Ext.create(gridnms["panel.1"], {
                renderTo: 'gridArea'
            });
        },
    });
}

function setExtGrid_org() {
    Ext.define(gridnms["model.2"], {
        extend: Ext.data.Model,
        fields: fields["model.2"]
    });

    Ext.tip.QuickTipManager.init();

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
            orgList: '#orgList',
        },
        stores: [gridnms["store.2"]],
        control: items["btns.ctr.2"],

        btnSav2Click: btnSav2Click,
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
                height: 241,
                border: 2,
                scrollable: true,
                columns: fields["columns.2"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'orgList'
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
        views: gridnms["panel.2"],
        controllers: gridnms["controller.2"],

        launch: function () {
            detailitem = Ext.create(gridnms["panel.2"], {
                renderTo: 'gridArea1'
            });
        },
    });

}

function setExtGrid_equip() {
    Ext.define(gridnms["model.3"], {
        extend: Ext.data.Model,
        fields: fields["model.3"]
    });

    Ext.tip.QuickTipManager.init();

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
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.3"], {
        extend: Ext.app.Controller,
        refs: {
            equipList: '#equipList',
        },
        stores: [gridnms["store.3"]],
        control: items["btns.ctr.3"],

        btnSav3Click: btnSav3Click,
        btnRef3Click: btnRef3Click,
        btnChk3Click: btnChk3Click,
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
                height: 241,
                border: 2,
                scrollable: true,
                columns: fields["columns.3"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'equipList'
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
        models: gridnms["models.equip"],
        stores: gridnms["stores.equip"],
        views: gridnms["panel.3"],
        controllers: gridnms["controller.3"],

        launch: function () {
            equipitem = Ext.create(gridnms["panel.3"], {
                renderTo: 'gridArea2'
            });
        },
    });
}

function fn_search() {
    global_employee_number = "";

    btn_click = true;

    var sparams = {
        person: $("#searchInspectorType").val() + "",
        inspector: $("#inspector2").val() + "",
        depname: $("#searchKrName").val() + "",
        departname: $("#searchDeptCode").val() + "",
        EMPLOYEENUMBER: global_employee_number,
    };
    extGridSearch(sparams, gridnms["store.1"]);
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
                        <table class="tbl_type_view" border="1">
                            <colgroup>
                                <col width="120px">
                                <col>
                                <col width="120px">
                                <col>
                                <col width="120px">
                                <col>
                                <col>
                            </colgroup>
                            <tr>
                                <th class="required_text">사원 구분</th>
                                <td>
                                    <select id="searchInspectorType" name="searchInspectorType" class="input_left " style="width: 99%;">
                                    </select>
                                </td>
                                <th class="required_text">이름</th>
                                <td>
                                    <input type="text" id="searchKrName" name="searchKrName" class="input_left" style="width: 99%;" />
                                </td>
                                <th class="required_text">부서</th>
                                <td>
                                    <select id="searchDeptCode" name="searchDeptCode" class="input_left " style="width: 99%;">
                                    </select>
                                </td>
                                <td>
                                    <div class="buttons" style="float: right; margin-top: 3px;">
                                        <div class="buttons" style="float: right;">
                                            <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
                                               조회
                                            </a>
                                        </div>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                    
                <div id="gridArea" style="width: 100%; padding: 0px; margin-bottom: 10px; float: left;"></div>
                <div>
					          <table style="width: 100%">
					            <tr>
					              <td style="width: 49%;"><div class="subConTit2">사업장 연결</div></td>
					              <td style="width: 2%;"></td>
					              <td style="width: 49%;"><div class="subConTit2">설비 연결</div></td>
					            </tr>
					          </table>
                    <div id="gridArea1" style="width: 49%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>             
					          <div  style="width: 2%; padding-bottom: 5px; float: left;"></div>
                    <div id="gridArea2" style="width: 49%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>             
					        </div>
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