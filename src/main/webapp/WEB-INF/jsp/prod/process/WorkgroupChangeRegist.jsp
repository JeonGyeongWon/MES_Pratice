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
<link rel="stylesheet" href="<c:url value='/css/custom_work.css'/>">

<style>
.x-column-header-inner {
	font-size: 18px;
	line-height: 110%;
	font-weight: bold;
	background-color: #5B9BD5;
	color: white;
	padding-left: 0px;
	padding-right: 0px;
}

.FML .x-grid-cell-inner {
	padding-left: 0px;
	padding-right: 0px;
}

.x-grid-cell-inner {
	position: relative;
	text-overflow: ellipsis;
	padding-top: 8px;
	padding-left: 10px;
	height: 45px;
	font-size: 18px !important;
	font-weight: bold;
}

.x-btn {
	margin-top: 2px;
	height: 39px;
}

.x-btn-inner {
	font-size: 14px !important;
}

#gridArea1 .x-form-field {
	font-size: 18px;
	font-weight: bold;
}

#gridArea2 .x-form-field {
  font-size: 18px;
  font-weight: bold;
}
</style>
  
<style>
.shadow {
	-webkit-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
	-moz-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
	box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
}

.h:HOVER {
	background-color: highlight;
}

.blue {
  background-color: #003399;
  color: white;
}

.blue2:HOVER {
  background-color: highlight;
  font-size: 18px;
  font-weight: bold;
}

.blue2 {
  background-color: #5B9BD5;
  color: white;
  font-size: 18px;
  font-weight: bold;
}

.blue3:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #003399;
}

.blue3 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #003399 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.gray:HOVER {
  background-color: #EAEAEA;
}

.gray {
  background-color: #BDBDBD;
  color: black;
}

.white:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}


.white2:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white2 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 16px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #5B9BD5 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  border-bottom: 4px solid #5B9BD5;
  margin-top: 0px;
  margin-bottom: 0px;
}

.yellow:hover {
  background-color: #FFFFFF;
  color: yellow !important;
  text-shadow: 2px 2px 5px rgb(34, 34, 34);
  border-bottom: 4px solid yellow;
}

.yellow {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.yellow_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid yellow;
}

.yellow_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: yellow !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  text-shadow: 2px 2px 5px rgb(34, 34, 34);
  cursor: pointer;
  border-bottom: 4px solid yellow;
  cursor: pointer;
}

.red:HOVER {
	background-color: #FFD8D8;
}

.red {
	background-color: #FFA7A7;
	color: black;
}

.gray:HOVER {
	background-color: #d8d8d8;
}

.gray {
	background-color: #e1e1e1;
	color: black;
}

.green:HOVER {
	background-color: #CEFBC9;
}

.green {
	background-color: #B7F0B1;
	color: black;
}

.r {
	border-radius: 4px 4px 4px 4px;
	-moz-border-radius: 4px 4px 4px 4px;
	-webkit-border-radius: 4px 4px 4px 4px;
	border: 0px solid #000000;
}

.ui-autocomplete {
	font-size: 33px;
	font-weight: bold;
	max-height: 400px;
	overflow-y: auto;
	/* prevent horizontal scrollbar */
	overflow-x: hidden;
}

* html .ui-autocomplete {
	/* IE 6.0 */
	height: 400px;
	font-size: 33px;
	font-weight: bold;
}

.ui-menu  .ui-menu-item {
  height: 85px;
  line-height: 40px;
  margin-top: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
  display: flex;
  flex-direction: column;
  align-items: left;
  justify-content: center;
}

*::-webkit-input-placeholder {
	color: blue;
}

*:-moz-placeholder {
	/* FF 4-18 */
	color: blue;
}

*::-moz-placeholder {
	/* FF 19+ */
	color: blue;
}

*:-ms-input-placeholder {
	/* IE 10+ */
	color: blue;
}

.F1 a:link {
	color: white;
	text-decoration: none;
}

.F1 a:visited {
	color: black;
	text-decoration: none;
}

.F1 a:hover {
	color: white;
	text-decoration: underline;
}
</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
var gridnms = {};
var fields = {};
var items = {};
var rowIdx_master = 0, rowIdx_detail = 0;
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    setReadOnly();

    setLovList();
});

function setInitial() {
    gridnms["app"] = "prod";
}

function setValues() {
    setValues_master();
    setValues_detail();
}

function setValues_master() {
    gridnms["models.master"] = [];
    gridnms["stores.master"] = [];
    gridnms["views.master"] = [];
    gridnms["controllers.master"] = [];

    gridnms["grid.1"] = "WorkGroupMaster";

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
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.1"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                if (rowIdx_master == ((record.data.RN * 1) - 1)) {
                    meta.style = "background-color:rgb(255,204,0);";
                }
                return value;
            },
        }, {
            dataIndex: 'LABEL',
            text: '작업그룹(모니터번호)',
            xtype: 'gridcolumn',
            //        width: 350,
            flex: 1,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            renderer: function (value, meta, record) {
                if (rowIdx_master == ((record.data.RN * 1) - 1)) {
                    meta.style = "background-color:rgb(255,204,0);";
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
            dataIndex: 'VALUE',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/searchSmallCodeListLov.do' />"
    });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#WorkGroupSelect": {
            itemclick: 'MasterClick'
        }
    });

    // 페이징
    items["dock.paging.1"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.1"],
    };

    // 버튼 컨트롤
    items["dock.btn.1"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.1"],
        items: items["btns.1"],
    };

    items["docked.1"] = [];
}

var global_org_id = "", global_company_id = "", global_work_dept = "", global_work_center = "";
function MasterClick(dataview, record, item, index, e, eOpts) {
    global_org_id = record.data.ORGID;
    global_company_id = record.data.COMPANYID;
    global_work_dept = record.data.VALUE;
    global_work_center = "";

    rowIdx_master = (record.data.RN * 1) - 1;
    rowIdx_detail = 0;
    isChecked = true;

    var sparams = {
        ORGID: global_org_id,
        COMPANYID: global_company_id,
        WORKDEPT: global_work_dept,
    };
    extGridSearch(sparams, gridnms["store.2"]);
    Ext.getCmp(gridnms["panel.1"]).getView().refresh();
};

function setValues_detail() {
    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.2"] = "WorkgroupChangeRegist";
    gridnms["grid.21"] = "workdeptLov";

    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
    gridnms["views.detail"].push(gridnms["panel.2"]);

    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
    gridnms["controllers.detail"].push(gridnms["controller.2"]);

    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];
    gridnms["model.21"] = gridnms["app"] + ".model." + gridnms["grid.21"];

    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];
    gridnms["store.21"] = gridnms["app"] + ".store." + gridnms["grid.21"];

    gridnms["models.detail"].push(gridnms["model.2"]);
    gridnms["models.detail"].push(gridnms["model.21"]);

    gridnms["stores.detail"].push(gridnms["store.2"]);
    gridnms["stores.detail"].push(gridnms["store.21"]);

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
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, {
            type: 'string',
            name: 'WORKDEPT',
        }, {
            type: 'string',
            name: 'WORKDEPTNAME',
        }, {
            type: 'string',
            name: 'ROUTINGCODE',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'string',
            name: 'CHANGEWORKDEPT',
        }, {
            type: 'string',
            name: 'CHANGEWORKDEPTNAME',
        }, ];

    fields["columns.2"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            align: "center",
            renderer: function (value, meta, record) {
                if (rowIdx_detail == ((record.data.RN * 1) - 1)) {
                    meta.style = "background-color:rgb(255, 204, 0); ";
                } else {
                    meta.style = " background-color: rgb(234, 234, 234); ";
                }
                return value;
            },
        }, {
            dataIndex: 'LABEL',
            text: '설비번호',
            xtype: 'gridcolumn',
            width: 350,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            renderer: function (value, meta, record) {
                if (rowIdx_detail == ((record.data.RN * 1) - 1)) {
                    meta.style = "background-color:rgb(255, 204, 0); ";
                } else {
                    meta.style = " background-color: rgb(234, 234, 234); ";
                }
                return value;
            },
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '해당공정',
            xtype: 'gridcolumn',
            width: 300,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            renderer: function (value, meta, record) {
                if (rowIdx_detail == ((record.data.RN * 1) - 1)) {
                    meta.style = "background-color:rgb(255, 204, 0); ";
                } else {
                    meta.style = " background-color: rgb(234, 234, 234); ";
                }
                return value;
            },
        }, {
            dataIndex: 'CHANGEWORKDEPTNAME',
            text: '변경그룹(모니터번호)',
            xtype: 'gridcolumn',
            width: 250,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.21"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                allowBlank: true,
                height: 50,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var code = record.data.VALUE;

                        if (code != "") {
                            model.set("CHANGEWORKDEPT", code);
                            model.set("CHK", true);
                        } else {
                            model.set("CHK", false);
                        }
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("CHANGEWORKDEPT", "");
                                model.set("CHK", false);
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">등록되지 않았습니다.<br/>관리자에게 문의해주세요.</span>',
                    width: 200,
                    getInnerTpl: function () {
                        return '<div>'
                         + '<table>'
                         + '<tr>'
                         + '<td style="height: 40px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                if (rowIdx_detail == ((record.data.RN * 1) - 1)) {
                    meta.style = "background-color:rgb(255, 204, 0); ";
                } else {

                    var saveyn = record.data.SAVEYN;
                    if (saveyn != "Y") {
                        meta.style = " background-color: rgb(234, 234, 234); ";
                    }
                }
                return value;
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
            align: "center",
            componentCls: 'CHK',
            editor: {
                xtype: 'checkbox',
            },
            renderer: function (value, meta, record, row, col) {
                if (rowIdx_detail == ((record.data.RN * 1) - 1)) {
                    meta.style = "background-color:rgb(255, 204, 0); ";
                }

                var saveyn = record.data.SAVEYN;
                if (saveyn != "Y") {
                    meta['tdCls'] = 'x-item-disabled';
                } else {
                    meta['tdCls'] = '';
                }

                return new Ext.ux.CheckColumn().renderer(value);
            },
            listeners: {
                beforecheckchange: function (options, row, value, event) {

                    var record = Ext.getCmp(gridnms["views.detail"]).selModel.store.data.items[row].data;
                    Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(row));
                    var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
                    if (value) {
                        var saveyn = record.SAVEYN;
                        if (saveyn != "Y") {
                            extToastView("현재 사용하지 않는 설비입니다.<br/>다시 한번 확인해주세요.");
                            return false;
                        } else {

                            var searchGubun = $("#searchGubun option:selected").val();
                            var searchGubunName = $("#searchGubun option:selected").text();

                            if (searchGubun != "") {
                                model.set("CHANGEWORKDEPT", searchGubun);
                                model.set("CHANGEWORKDEPTNAME", searchGubunName);
                            } else {
                                extToastView("[실패]<br/>그룹을 선택하여주세요.");
                                model.set("CHANGEWORKDEPT", "");
                                model.set("CHANGEWORKDEPTNAME", "");
                                return false;
                            }
                        }
                    } else {
                        model.set("CHANGEWORKDEPT", "");
                        model.set("CHANGEWORKDEPTNAME", "");
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
            dataIndex: 'VALUE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKDEPT',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKDEPTNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHANGEWORKDEPT',
            xtype: 'hidden',
        }, ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/searchWorkCenterLov.do' />"
    });
    $.extend(items["api.2"], {
        update: "<c:url value='/update/prod/process/WorkgroupChangeRegist.do' />"
    });

    items["btns.2"] = [];

    items["btns.ctr.2"] = {};
    $.extend(items["btns.ctr.2"], {
        "#WorkCenterSelect": {
            itemclick: 'DetailClick'
        }
    });

    // 페이징
    items["dock.paging.2"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.2"],
    };

    // 버튼 컨트롤
    items["dock.btn.2"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.2"],
        items: items["btns.2"],
    };

    items["docked.2"] = [];
}

function DetailClick(dataview, record, item, index, e, eOpts) {
    global_org_id = record.data.ORGID;
    global_company_id = record.data.COMPANYID;
    global_work_center = record.data.VALUE;

    rowIdx_detail = (record.data.RN * 1) - 1;

    Ext.getCmp(gridnms["panel.2"]).getView().refresh();
};

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
        fields: fields["model.1"],
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
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                                BIGCD: 'CMM',
                                MIDDLECD: 'WORK_DEPT',
                                GUBUN: 'WORKGROUP',
                                ORDERATTRIBUTE1: 'WORKGROUP'
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
                                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.master"]).getSelectionModel().select(0));
                                    var model = Ext.getCmp(gridnms["views.master"]).selModel.getSelection()[0];

                                    global_org_id = model.data.ORGID;
                                    global_company_id = model.data.COMPANYID;
                                    global_work_dept = model.data.VALUE;
                                    global_work_center = "";

                                    rowIdx_master = (model.data.RN * 1) - 1;
                                    rowIdx_detail = 0;
                                    isChecked = true;

                                    var sparams = {
                                        ORGID: global_org_id,
                                        COMPANYID: global_company_id,
                                        WORKDEPT: global_work_dept,
                                    };
                                    extGridSearch(sparams, gridnms["store.2"]);
                                    Ext.getCmp(gridnms["panel.1"]).getView().refresh();
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
            WorkGroupSelect: '#WorkGroupSelect',
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
                height: 787,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                plugins: [{
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20, // #1
                        leadingBufferZone: 20, // #2
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'WorkGroupSelect',
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
            gridarea1 = Ext.create(gridnms["views.master"], {
                renderTo: 'gridArea1'
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
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#orgid').val(),
                                COMPANYID: $('#companyid').val(),
                                BIGCD: 'CMM',
                                MIDDLECD: 'WORK_DEPT',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.2"], {
        extend: Ext.app.Controller,
        refs: {
            WorkCenterSelect: '#WorkCenterSelect',
        },
        stores: [gridnms["store.2"]],
        control: items["btns.ctr.2"],

        DetailClick: DetailClick,
    });

    Ext.define(
        gridnms["panel.2"], {
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
                height: 787,
                border: 2,
                scrollable: true,
                columns: fields["columns.2"],
                defaults: gridVals.defaultField,
                plugins: [{
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20, // #1
                        leadingBufferZone: 20, // #2
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'WorkCenterSelect',
                    trackOver: true,
                    loadMask: true,
                    striptRows: true,
                    forceFit: true,
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = [];

                                var saveyn = data.data.SAVEYN;
                                if (saveyn != "Y") {
                                    editDisableCols.push("CHANGEWORKDEPTNAME");
                                }

                                var isNew = ctx.record.phantom || false;
                                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                                    return false;
                                else {
                                    return true;
                                }
                            },
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
            gridarea2 = Ext.create(gridnms["views.detail"], {
                renderTo: 'gridArea2'
            });
        },
    });
}

function fn_search() {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var workdept = "";

    rowIdx_master = 0;
    rowIdx_detail = 0;

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        BIGCD: 'CMM',
        MIDDLECD: 'WORK_DEPT',
        WORKDEPT: workdept,
        GUBUN: 'WORKGROUP',
        ORDERATTRIBUTE1: 'WORKGROUP'
    };
    extGridSearch(sparams, gridnms["store.1"]);
    isChecked = true;

}

var isChecked = true;
function fn_check_all(o, e) {
    var recount = Ext.getStore(gridnms["store.2"]).count();
    var chkcount = 0;
    var searchGubun = $("#searchGubun option:selected").val();
    var searchGubunName = $("#searchGubun option:selected").text();
    if (searchGubun != "") {
        for (var i = 0; i < recount; i++) {
            var model = Ext.getStore(gridnms["store.2"]).getAt(i);

            var saveyn = model.data.SAVEYN;
            if (saveyn == "Y") {
                if (isChecked) {
                    model.set("CHANGEWORKDEPT", searchGubun);
                    model.set("CHANGEWORKDEPTNAME", searchGubunName);
                    model.set("CHK", true);
                    chkcount++;
                } else {
                    model.set("CHANGEWORKDEPT", "");
                    model.set("CHANGEWORKDEPTNAME", "");
                    model.set("CHK", false);
                }
            }
        }

        if (isChecked) {
            isChecked = false;
        } else {
            isChecked = true;
        }
    } else {
        extToastView("[전체선택/해제 실패]<br/>그룹을 선택하여주세요.");
    }
}

function fn_save_all() {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var gridcount = Ext.getStore(gridnms["store.2"]).count();
    var url = "<c:url value='/update/prod/process/WorkgroupChangeRegist.do' />";

    var count = 0;
    for (var k = 0; k < gridcount; k++) {
        Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(k));
        var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
        // var record = Ext.getStore(gridnms["store.2"]).getAt(k);

        if (model1.data.CHK) {
            count++;
        }
    }

    var updatecount = 0;
    Ext.MessageBox.confirm('설비그룹 변경', '변경 처리하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            for (var i = 0; i < gridcount; i++) {
                Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
                var model2 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
                //           var record = Ext.getStore(gridnms["store.2"]).getAt(i);
                var chk = model2.data.CHK;

                if (chk == true) {
                    var orgid = model2.data.ORGID;
                    var companyid = model2.data.COMPANYID;
                    var value = model2.data.VALUE;
                    var workdept = model2.data.CHANGEWORKDEPT;

                    var sparams = {
                        ORGID: orgid,
                        COMPANYID: companyid,
                        WORKCENTERCODE: value,
                        WORKDEPT: workdept,
                    };

                    $.ajax({
                        url: url,
                        type: "post",
                        dataType: "json",
                        data: sparams,
                        success: function (data) {
                            msgdata = data.msg;

                            var returnstatus = data.success;
                            if (returnstatus) {
                                updatecount++;
                            }

                            if (updatecount == count) {
                                extAlert(msgdata);

                                Ext.getStore(gridnms["store.2"]).load();

                            }
                        },
                        error: ajaxError
                    });
                }
            }
        } else {
            extToastView("변경 처리가 취소되었습니다.");
            return;
        }
    });
}

function fn_goHome() {
    go_url('<c:url value="/prod/process/ProcessStart.do" />');
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

function fn_ready() {
    extToastView("준비중입니다...");
    return;
}

function setLovList() {
    //
}

function setReadOnly() {
    $("[readonly]").addClass("ui-state-disabled");
}

function fn_goMovePage(flag) {
    if (flag === 8) {
        go_url('<c:url value="/prod/process/WarehousingRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 10) {
        go_url('<c:url value="/prod/process/selectWorkOrderNewRegist.do?type="/>' + flag + "&work=" + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 11) {
        go_url('<c:url value="/prod/process/WorkgroupChangeRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 12) {
        go_url('<c:url value="/prod/process/WorkOutOrderRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 13) {
        go_url('<c:url value="/prod/process/WorkOrderInOut.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else {
        go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + flag + "&gubun=" + $('#gubun').val() + "&work=" + $('#work').val());
    }
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
        <!-- 현재위치 네비게이션 시작 -->
        <div style="margin-top: 0px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
            <div style="width: 100%; padding-left: 0px; ">
                <form id="master" name="master" method="post" onkeydown="return fn_key_break(event, 13)" >
                    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
                    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
                    <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
                    <c:choose>
                        <c:when test="${searchVO.work == 'Y'}">
                            <div style="width: calc(100% - 200px); height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
<!--                                 <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                         생산실적<br/>( TOUCH ) -->
<!--                                 </button> -->
                                <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                        생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                        래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                        자주검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                        공구변경<br/>( TOOL CHANGE )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                        외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                        반입반출<br/>( STORED & RELEASED )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                        설비변경<br/>( FACILITIES )
                                </button>
                            </div>
                            <div style="width: 200px; height: 65px; margin-top: 0px; margin-right: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: right;">
                                <button type="button" class="yellow " onclick="fn_logout();" style="width: 185px; height: 63px; float: right';">
                                        나가기<br/>( LOGOUT )
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="width: 100%; height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
                                <button type="button" class="btn_work_prev blue3 h " onclick="fn_goHome( );" style="width: 8%; height: 63px; float: left';">
                                        이전화면<br/>( BACK )
                                </button>
<!--                                 <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                         생산실적<br/>( TOUCH ) -->
<!--                                 </button> -->
                                <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                        생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                        래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                        자주검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                        공구변경<br/>( TOOL CHANGE )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                        외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                        반입반출<br/>( STORED & RELEASED )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                        설비변경<br/>( FACILITIES )
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <table class="blue" style="width: 100%; height:70px; margin-top: 0px; ">
		                    <colgroup>
				                    <col width="160px">
                            <col width="20%">
				                    <col width="160px">
                            <col width="10%">
                            <col width="25%">
                            <col width="10%">
                            <col width="10%">
                            <col width="10%">
		                    </colgroup>
		                    <tbody>
			                      <tr>
			                        <th colspan="4" style="color: white; font-size:30px; font-weight: bold; text-align: right;">설비별 해당 모니터를 선택하십시오.&nbsp;</th>
			                        <td>
			                            <select id="searchGubun" name="searchGubun" class="input_left " style="width:99%; height:50px;  font-size:25px; vertical-align: middle;" onkeydown="javascript:if (event.keyCode == 13) { fn_search(); }">
		                                  <option value="" ></option>
			                                <c:forEach var="item" items="${labelBox.findByWorkDept}" varStatus="status">
			                                    <c:choose>
			                                        <c:when test="${item.VALUE==searchVO.WORKDEPT}">
			                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
			                                        </c:when>
			                                        <c:otherwise>
			                                            <option value="${item.VALUE}">${item.LABEL}</option>
			                                        </c:otherwise>
			                                    </c:choose>
			                                </c:forEach>
                                  </select>
			                        </td>
                              <td style="padding-left: 10px; padding-right: 5px;">
                                  <button type="button" id="btn_search" class="blue2 r shadow" onclick="fn_search();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">조회</button>
                              </td>
                              <td style="padding-left: 5px; padding-right: 5px;">
                                  <button type="button" id="btn_checkall" class="blue2 r shadow" onclick="fn_check_all();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">일괄선택</button>
                              </td>
                              <td style="padding-left: 5px; padding-right: 15px;">
                                  <button type="button" id="btn_save" class="blue2 r shadow" onclick="fn_save_all();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">일괄저장</button>
                              </td>
			                      </tr>
		                    </tbody>
                    </table>
                    </center>
                    <div id="gridArea1" style="width: 20%; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
                    <div id="gridArea2" style="width: 79%; padding-bottom: 0px; padding-top: 0px; margin-left: 1%; float: left;"></div>
                </form>
            </div>
        </div>
        <!-- //content 끝 -->
    <!-- //전체 레이어 끝 -->
<div id="loadingBar" style="display: none;">
    <img src='<c:url value="/images/spinner.gif"></c:url>' alt="Loading"/>
</div>
</body>
</html>