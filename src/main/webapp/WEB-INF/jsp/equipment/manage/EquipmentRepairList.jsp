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
    gridnms["app"] = "Equipment";

//     calender($('#searchFrom'));

    $('#searchFrom').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } 
        }
    });

    $("#searchFrom").val(getToDay("${searchVO.dateFrom}") + "");

}


var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_master();
    setValues_line();
    setValues_detail();
}

function setValues_master() {

    gridnms["models.master"] = [];
    gridnms["stores.master"] = [];
    gridnms["views.master"] = [];
    gridnms["controllers.master"] = [];

    gridnms["grid.1"] = "EquipmentRepairMaster";

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
            name: 'WORKDEPTCODE',
        }, {
            type: 'string',
            name: 'WORKDEPTNAME',
        }, {
            type: 'number',
            name: 'MATCOST',
        }, {
            type: 'number',
            name: 'REPAIRCOST',
        }, {
            type: 'number',
            name: 'TOTAL',
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
            style: 'text-align:center',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
        }, {
            dataIndex: 'WORKDEPTNAME',
            text: '작업반',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
        }, {
          dataIndex: 'MATCOST',
            text: '부품비',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, eOpts) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'REPAIRCOST',
            text: '수리비',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, eOpts) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTAL',
            text: '합계',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, eOpts) {
                meta.style = " background-color: rgb(234, 234, 234); ";
                return Ext.util.Format.number(value, '0,000');
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
            dataIndex: 'WORKDEPTCODE',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/equipment/manage/EquipmentRepairMaster.do' />"
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
        '<strong>(단위: 원)</strong>' +
        '</td>' +
        '</tr>' +
        '</table>');

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
    items["docked.1"].push(items["dock.btn.1"]);
}

function MasterClick(dataview, record, item, index, e, eOpts) {
    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var workdept = record.data.WORKDEPT;

    var params = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHFROM: $('#searchFrom').val(),
        WORKDEPT: workdept,
    };
    
    extGridSearch(params, gridnms["store.3"]);
    
    setTimeout(function () {
//     	 extGridSearch(params, gridnms["store.2"]);
    }, 300);
    
}

function setValues_line() {

    gridnms["models.line"] = [];
    gridnms["stores.line"] = [];
    gridnms["views.line"] = [];
    gridnms["controllers.line"] = [];

    gridnms["grid.3"] = "EquipmentRepairLine";

    gridnms["panel.3"] = gridnms["app"] + ".view." + gridnms["grid.3"];
    gridnms["views.line"].push(gridnms["panel.3"]);

    gridnms["controller.3"] = gridnms["app"] + ".controller." + gridnms["grid.3"];
    gridnms["controllers.line"].push(gridnms["controller.3"]);

    gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];

    gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];

    gridnms["models.line"].push(gridnms["model.3"]);

    gridnms["stores.line"].push(gridnms["store.3"]);

    fields["model.3"] = [{
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
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'ITEMNAME',
        }, {
            type: 'string',
            name: 'ITEMTYPENAME',
        }, {
            type: 'number',
            name: 'SALESTOTAL',
        }, {
            type: 'number',
            name: 'TRANSTOTAL',
        }, {
            type: 'number',
            name: 'TRANSQTY',
        }, ];

    fields["columns.3"] = [
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
            style: 'text-align:center',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비명',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
        }, {
            dataIndex: 'REPAIRCENTERNAME',
            text: '수리업체',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
            dataIndex: 'WORKDEPTNAME',
            text: '작업반',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
        }, {
            dataIndex: 'MATCOST',
            text: '부품비',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, eOpts) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'REPAIRCOST',
            text: '수리비',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, eOpts) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTAL',
            text: '합계',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, eOpts) {
                meta.style = " background-color: rgb(234, 234, 234); ";
                return Ext.util.Format.number(value, '0,000');
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
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, ];

    items["api.3"] = {};
    $.extend(items["api.3"], {
        read: "<c:url value='/select/equipment/manage/EquipmentRepairLine.do' />"
    });

    items["btns.3"] = [];
    items["btns.3"].push(
        '->');
    items["btns.3"].push(
        '<table>' +
        '<colgroup>' +
        '<col>' +
        '</colgroup>' +
        '<tr>' +
        '<td>' +
        '<strong>(단위: 원)</strong>' +
        '</td>' +
        '</tr>' +
        '</table>');

    items["btns.ctr.3"] = {};
    $.extend(items["btns.ctr.3"], {
        "#lineClick": {
            itemclick: 'lineClick'
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

function lineClick(dataview, record, item, index, e, eOpts) {
    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var workcentercode = record.data.WORKCENTERCODE;

    var params = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHFROM: $('#searchFrom').val(),
        WORKCENTERCODE: workcentercode,
    };
    extGridSearch(params, gridnms["store.2"]);
}

function setValues_detail() {

    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.2"] = "EquipmentRepairDetail";

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
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
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
            name: 'CARTYPE',
        }, {
            type: 'string',
            name: 'CARTYPENAME',
        }, {
            type: 'string',
            name: 'MATERIALTYPE',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'number',
            name: 'SOSEQ',
        }, {
            type: 'number',
            name: 'SALESPRICE',
        }, {
            type: 'string',
            name: 'TRADENO',
        }, {
            type: 'number',
            name: 'TRADESEQ',
        }, {
            type: 'date',
            name: 'TRADEDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'number',
            name: 'QTY',
        }, {
            type: 'number',
            name: 'TRADEAMOUNT',
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
            style: 'text-align:center',
            align: "center"
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비명',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = " background-color: rgb( 258, 218, 255 ); ";
                return value;
            },
        }, {
            dataIndex: 'REPAIRDATE',
            text: '등록일자',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {
                meta.style = " background-color: rgb( 258, 218, 255 ); ";
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'FILEYN',
            text: '첨부<br/>유무',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            renderer: function (value, meta, record) {
                if (value == "Y") {
                    meta.style = "background-color:rgb(100, 100, 234); ";
                    meta.style += "color: white; ";
                    meta.style += "font-weight: bold;";
                } else {
                    meta.style = " background-color: rgb(234, 234, 234); ";
                }
                return value;
            },
        }, {
            dataIndex: 'REASONGUBUNNAME',
            text: '현상분류',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
        }, {
            dataIndex: 'REASONNAME',
            text: '현상',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
        }, {
            dataIndex: 'DETAILREASON',
            text: '원인',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
            dataIndex: 'ACTIONCONTEXTNAME',
            text: '조치내용',
            xtype: 'gridcolumn',
            width: 240,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
            dataIndex: 'ITEMSTANDARD',
            text: '수리부품',
            xtype: 'gridcolumn',
            width: 240,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
            dataIndex: 'REPAIRCENTERNAME',
            text: '수리업체',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
            text: '품목정보',
            menuDisabled: true,
            columns: [{
                    dataIndex: 'MATCOST',
                    text: '부품비',
                    xtype: 'gridcolumn',
                    width: 100,
                    hidden: false,
                    sortable: false,
                    menuDisabled: true,
                    style: 'text-align:center',
                    align: "right",
                    cls: 'ERPQTY',
                    format: "0,000",
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'REPAIRCOST',
                    text: '수리비',
                    xtype: 'gridcolumn',
                    width: 100,
                    hidden: false,
                    sortable: false,
                    menuDisabled: true,
                    style: 'text-align:center',
                    align: "right",
                    cls: 'ERPQTY',
                    format: "0,000",
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'TOTAL',
                    text: '합계',
                    xtype: 'gridcolumn',
                    width: 100,
                    hidden: false,
                    sortable: false,
                    menuDisabled: true,
                    style: 'text-align:center',
                    align: "right",
                    cls: 'ERPQTY',
                    format: "0,000",
                    renderer: function (value, meta, eOpts) {
                        meta.style = " background-color: rgb(234, 234, 234); ";
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, ]
        }, {
            dataIndex: 'ACTIONRESULT',
            text: '조치결과',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
            dataIndex: 'FOLLOWUP',
            text: '사후관리',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
            dataIndex: 'ENDDATE',
            text: '완료일',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            width: 240,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
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
            dataIndex: 'ACTIONCONTEXT',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'SAVEYN',
            xtype: 'hidden',
        }
    ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/equipment/manage/EquipmentRepairDetailList.do' />"
    });

    items["btns.2"] = [];
    items["btns.2"].push(
        '->');
    items["btns.2"].push(
        '<table>' +
        '<colgroup>' +
        '<col>' +
        '</colgroup>' +
        '<tr>' +
        '<td>' +
        '<strong>(단위: 원)</strong>' +
        '</td>' +
        '</tr>' +
        '</table>');

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
    items["docked.2"].push(items["dock.btn.2"]);
}

var gridarea, gridarea1, gridarea2;
function setExtGrid() {
    setExtGrid_master();
    setExtGrid_line();
    setExtGrid_detail();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
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
                                SEARCHFROM: $('#searchFrom').val(),
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
                                    var workdept = model.data.WORKDEPT;

                                    var params = {
                                        ORGID: orgid,
                                        COMPANYID: companyid,
                                        SEARCHFROM: $('#searchFrom').val(),
                                        WORKDEPT: workdept,
                                        WORKCENTERCODE:$("#searchWorkcenterName").val(),
                                    };
                                    extGridSearch(params, gridnms["store.3"]);
                                    extGridSearch(params, gridnms["store.2"]);
                                } else {
                                    Ext.getStore(gridnms['store.2']).removeAll();
                                    Ext.getStore(gridnms['store.3']).removeAll();
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
                height: 300,
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

function setExtGrid_line() {
    Ext.define(gridnms["model.3"], {
        extend: Ext.data.Model,
        fields: fields["model.3"],
    });

    Ext.define(gridnms["store.3"], {
        extend: Ext.data.JsonStore, // Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.3"],
                        model: gridnms["model.3"],
                        autoLoad: false,
                        isStore: false,
                        autoDestroy: true,
                        clearOnPageLoad: true,
                        clearRemovedOnLoad: true,
                        pageSize: 9999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.3"],
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
                                    Ext.getStore(gridnms["store.3"]).getById(Ext.getCmp(gridnms["views.line"]).getSelectionModel().select(0));
                                    var model = Ext.getCmp(gridnms["views.line"]).selModel.getSelection()[0];

                                    var orgid = model.data.ORGID;
                                    var companyid = model.data.COMPANYID;
                                    var workcentercode = model.data.WORKCENTERCODE;

                                    var params = {
                                        ORGID: orgid,
                                        COMPANYID: companyid,
                                        SEARCHFROM: $('#searchFrom').val(),
                                        WORKCENTERCODE:workcentercode,
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

    Ext.define(gridnms["controller.3"], {
        extend: Ext.app.Controller,
        refs: {
            lineClick: '#lineClick',
        },
        stores: [gridnms["store.3"]],
        control: items["btns.ctr.3"],
        
        lineClick: lineClick,
    });

    Ext.define(gridnms["panel.3"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.3"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'rowmodel',
                itemId: gridnms["panel.3"],
                id: gridnms["panel.3"],
                store: gridnms["store.3"],
                height: 300,
                border: 2,
                scrollable: true,
                columns: fields["columns.3"],
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
                    itemId: 'lineClick',
                    trackOver: true,
                    loadMask: true,
                    striptRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('REPAIRCENTERNAME') >= 0) {
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
                    }
                ],
                dockedItems: items["docked.3"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.line"],
        stores: gridnms["stores.line"],
        views: gridnms["views.line"],
        controllers: gridnms["controller.3"],

        launch: function () {
            gridarea2 = Ext.create(gridnms["views.line"], {
                renderTo: 'gridArea2'
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
                height: 330,
                border: 2,
                scrollable: true,
                columns: fields["columns.2"],
                viewConfig: {
                    itemId: 'DetailList',
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('REPAIRCENTERNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 120) {
                                        column.width = 120;
                                    }
                                }

                                if (column.dataIndex.indexOf('REASONNAME') >= 0 || column.dataIndex.indexOf('REASONGUBUNNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 80) {
                                        column.width = 80;
                                    }
                                }

                            });
                        }
                    }
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
                renderTo: 'gridArea1'
            });
        },
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchfrom = $('#searchFrom').val();
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

    if (searchfrom == "") {
        header.push("기준일자 FROM");
        count++;
    }


    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        result = false;
    }

    return result;
}

// PDF 다운로드

function fn_search() {
    if (!fn_validation()) {
        return;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchfrom = $('#searchFrom').val();
    var searchWorkcenterCode = $("#searchWorkcenterName").val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHFROM: searchfrom,
        WORKCENTERCODE: searchWorkcenterCode,
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_excel_download() {
    if (!fn_validation()) {
        return;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var dateFrom = $("#searchFrom").val();
    var searchWorkcenterName = $("#searchWorkcenterName").val();
    var searchWorkcenterCode = $("#searchWorkcenterCode").val();
    var title = $('#title').val();

    go_url("<c:url value='/equipment/manage/ExcelDownload.do?GUBUN=' />" + "REPAIR"
         + "&ORGID=" + orgid + ""
         + "&COMPANYID=" + companyid + ""
         + "&SEARCHFROM=" + dateFrom + ""
         + "&WORKCENTERCODE=" + searchWorkcenterCode + ""
         + "&WORKCENTERNAME=" + searchWorkcenterName + ""
         + "&GUBUN=" + "REGIST"
         + "&TITLE=" + title + "");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
	//설비명 Lov
    $("#searchWorkcenterName")
    .bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#searchWorkcenterCode").val("");
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
            $.getJSON("<c:url value='/select/master/workcenter/WorkCenterMa.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val()
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.WORKCENTERCODE,
                            label: m.WORKCENTERNAME,
                            name: m.WORKCENTERNAME,
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
            $("#searchWorkcenterName").val(o.item.name);
            $("#searchWorkcenterCode").val(o.item.value);
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
                        <li>설비관리</li>
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
                <fieldset style="width: 100%;">
                    <legend>조건정보 영역</legend>

                    <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="searchWorkcenterCode" name="searchWorkcenterCode" />
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
                            <div>
                                <table class="tbl_type_view" border="1">
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
                                        <td>
                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                                                <a id="btnChk3" class="btn_download" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <input type="hidden" id="orgid" name="orgid" /> <input type="hidden" id="companyid" name="companyid" />
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="120px">
                                        <col >
                                        <col width="120px">
                                        <col>
                                        <col width="120px">
                                        <col>
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">수리년월</th>
                                        <td>
                                            <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center " style="width: 90%;" maxlength="7" />
                                        </td>
		                                    <th class="required_text">설비명</th>
		                                    <td><input type="text" id="searchWorkcenterName" name="searchWorkcenterName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" /></td>
<!-- 		                                    <th class="required_text">설비번호</th> -->
<!-- 		                                    <td><input type="text" id="searchWorkcenterCode" name="searchWorkcenterCode" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" /></td> -->
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </table>
                            </div>
                    </form>
                </fieldset>
            </div>
            <!-- //검색 필드 박스 끝 -->

            <div>
              <table style="width: 100%">
                <tr>
                  <td style="width: 33%;"><div class="subConTit3">설비 수리 이력 현황 집계</div></td>
                  <td style="width: 2%;"></td>
                  <td style="width: 65%;"><div class="subConTit3">설비 수리 이력 현황 요약</div></td>
                </tr>
              </table>
              <div id="gridArea" style="width: 33%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>             
              <div  style="width: 2%; padding-bottom: 5px; float: left;"></div>
              <div id="gridArea2" style="width: 65%; padding-bottom: 5px; padding-top: 0px; float: left;"></div>             
            </div>
                  
            <table style="width: 100%;">
                <tr>
                    <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">설비 수리 이력 현황 상세</div></td>
                </tr>
            </table>
            <div id="gridArea1" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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