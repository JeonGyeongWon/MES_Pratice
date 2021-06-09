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

    setReadOnly();

    setLovList();
});

function setInitial() {
    gridnms["app"] = "purchase";

    // 발주일자
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

    fn_option_change('MAT', 'STATUS_CODE', 'searchPOStatus');
    fn_option_change('MAT', 'ORDER_DIV', 'searchOrderDiv');
    
    $('#searchOrgId, #searchCompanyId').change(function (event) {
        fn_option_change('MAT', 'STATUS_CODE', 'searchPOStatus');
        fn_option_change('MAT', 'ORDER_DIV', 'searchOrderDiv');
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

    gridnms["grid.1"] = "PurchaseOrderList";

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
            name: 'PONO',
        }, {
            type: 'date',
            name: 'PODATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'POSTATUS',
        }, {
            type: 'string',
            name: 'POSTATUSNAME',
        }, {
            type: 'number',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'CUSTOMERPERSON',
        }, {
            type: 'string',
            name: 'CUSTOMERPERSONNAME',
        }, {
            type: 'string',
            name: 'POPERSON',
        }, {
            type: 'string',
            name: 'POPERSONNAME',
        }, {
            type: 'string',
            name: 'USEDIV',
        }, {
            type: 'string',
            name: 'USEDIVNAME',
        }, {
            type: 'string',
            name: 'TAXDIV',
        }, {
            type: 'string',
            name: 'TAXDIVNAME',
        }, {
            type: 'string',
            name: 'DELIVERYLOCATION',
        }, {
            type: 'string',
            name: 'DELIVERYLOCATIONNAME',
        }, {
            type: 'number',
            name: 'TOTAL',
        }, {
            type: 'string',
            name: 'REMARKS',
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
        }, {
            dataIndex: 'PONO',
            text: '발주번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
                var result = '<div><a href="{0}">{1}</a></div>';
                var url = "<c:url value='/purchase/order/PurchaseOrderManage.do?PONO=' />" + record.data.PONO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
                return Ext.String.format(result, url, value);
            },
        }, {
            dataIndex: 'PODATE',
            text: '발주일',
            xtype: 'datecolumn',
            width: 85,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
                var result = '<div><a href="{0}">{1}</a></div>';
                var url = "<c:url value='/purchase/order/PurchaseOrderManage.do?PONO=' />" + record.data.PONO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
                return Ext.String.format(result, url, Ext.util.Format.date(value, 'Y-m-d'));
            },
        }, {
            dataIndex: 'CUSTOMERNAME',
            text: '공급사',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
                var result = '<div><a href="{0}">{1}</a></div>';
                var url = "<c:url value='/purchase/order/PurchaseOrderManage.do?PONO=' />" + record.data.PONO + "&org=" + record.data.ORGID + "&company=" + record.data.COMPANYID;
                return Ext.String.format(result, url, value);
            },
        }, {
            dataIndex: 'CUSTOMERPERSONNAME',
            text: '공급사 담당자',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'POPERSONNAME',
            text: '발주담당자',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            align: "center",
        }, {
            dataIndex: 'USEDIVNAME',
            text: '발주구분',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'TAXDIVNAME',
            text: '세액구분',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'DELIVERYLOCATIONNAME',
            text: '납품장소',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'POSTATUSNAME',
            text: '발주상태',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'TOTAL',
            text: '합계',
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
            renderer: Ext.util.Format.numberRenderer('0,000'),
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

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/purchase/order/PurchaseOrderList.do' />"
    });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#MasterList": {
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
}

function onMasterClick(dataview, record, item, index, e, eOpts) {
    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var pono = record.data.PONO;

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        PONO: pono,
    };
    extGridSearch(sparams, gridnms["store.2"]);
}

function setValues_detail() {

    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.2"] = "PurchaseOrderListDetail";

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
            name: 'CUSTOMERGUBUN',
        }, {
            type: 'string',
            name: 'CUSTOMERGUBUNNAME',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'number',
            name: 'ORDERQTY',
        }, {
            type: 'number',
            name: 'UNITPRICE',
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
            type: 'string',
            name: 'POPERSONNAME',
        }, {
            type: 'date',
            name: 'DUEDATE',
            dateFormat: 'Y-m-d'
        }, {
            type: 'date',
            name: 'SCMDUEDATE',
            dateFormat: 'Y-m-d'
        }, {
            type: 'string',
            name: 'PORNO',
        }, {
            type: 'string',
            name: 'PORSEQ',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'ORDERINSPECTIONYN',
        }, {
            type: 'string',
            name: 'SCMINSPECTIONYN',
        }, ];

    fields["columns.2"] = [
        // Display Columns
        {
            dataIndex: 'POSEQ',
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
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return value;
            },
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 235,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            renderer: function (value, meta, record) {
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return value;
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
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return value;
            },
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
            renderer: function (value, meta, record) {
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return value;
            },
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
            renderer: function (value, meta, record) {
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

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
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return value;
            },
        }, {
            dataIndex: 'ORDERQTY',
            text: '발주수량',
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
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'UNITPRICE',
            text: '단가',
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
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'SUPPLYPRICE',
            text: '공급가액',
            xtype: 'gridcolumn',
            width: 115,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ADDITIONALTAX',
            text: '부가세',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTAL',
            text: '합계',
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
            renderer: function (value, meta, record) {
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'DUEDATE',
            text: '납기일',
            xtype: 'datecolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {

                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'SCMDUEDATE',
            text: '납기예정일',
            xtype: 'datecolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {

                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'ORDERINSPECTIONYN',
            text: '수입검사<br/>유무',
            xtype: 'gridcolumn',
            width: 75,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {

                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return value;
            },
            //      }, {
            //        dataIndex: 'SCMINSPECTIONYN',
            //        text: '수입검사<br/>유무<br/>(SCM용)',
            //        xtype: 'gridcolumn',
            //        width: 75,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        align: "center",
            //        renderer: function (value, meta, record) {

            //          var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
            //          var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
            //          if (enddate != "") {

            //            var diff = 0;
            //            diff = fn_calc_diff(startdate, enddate);
            //            if (diff < 0) {}
            //            else {
            //              meta.style += " color:rgb(255, 0, 0); ";
            //              meta.style += " font-weight: bold; ";
            //            }
            //          }

            //          return value;
            //        },
        }, {
            dataIndex: 'PORNO',
            text: '요청번호',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {

                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
                }

                return value;
            },
        }, {
            dataIndex: 'PORSEQ',
            text: '요청순번',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {

                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
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
            renderer: function (value, meta, record) {

                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(record.data.SCMDUEDATE, 'Y-m-d');
                if (enddate != "") {

                    var diff = 0;
                    diff = fn_calc_diff(startdate, enddate);
                    if (diff < 0) {}
                    else {
                        meta.style += " color:rgb(255, 0, 0); ";
                        meta.style += " font-weight: bold; ";
                    }
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
            dataIndex: 'PONO',
            xtype: 'hidden',
        }, ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/purchase/order/PurchaseOrderListDetail.do' />"
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
                                POFROM: $('#searchFrom').val(),
                                POTO: $('#searchTo').val(),
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

                                    var orgid = model.data.ORGID;
                                    var companyid = model.data.COMPANYID;
                                    var pono = model.data.PONO;

                                    var sparams = {
                                        ORGID: orgid,
                                        COMPANYID: companyid,
                                        PONO: pono,
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
            MasterList: '#MasterList',
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
                height: 396,
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
                    itemId: 'MasterList',
                    trackOver: true,
                    loadMask: true,
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
            btnDetail: '#btnDetail',
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
                plugins: [{
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20, // #1
                        leadingBufferZone: 20, // #2
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'btnDetail',
                    trackOver: true,
                    loadMask: true,
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
                renderTo: 'gridArea1'
            });
        },
    });
}

function fn_search() {
    // 필수 체크
    var pofrom = $('#searchFrom').val();
    var poto = $('#searchTo').val();
    var header = [],
    count = 0;

    if (pofrom === "") {
        header.push("발주기간 From");
        count++;
    }

    if (poto === "") {
        header.push("발주기간 To");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return;
    }

    var sparams = {
        ORGID: $('#searchOrgId').val(),
        COMPANYID: $('#searchCompanyId').val(),
        POFROM: $('#searchFrom').val(),
        POTO: $('#searchTo').val(),
        PONO: $('#searchPoNo').val(),
        ORDERDIV: $('#searchOrderDiv').val(),
        CUSTOMERCODE: $('#searchCustomerCode').val(),
        POSTATUS: $('#searchPOStatus').val(),
        ITEMCODE: $('#searchItemCode').val(),
        GUBUN: 'LIST',
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_save() {
    go_url("<c:url value='/purchase/order/PurchaseOrderManage.do' />");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {

    // 발주번호 Lov
    $("#searchPoNo").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //               $("#searchPoNo").val("");
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
            $.getJSON("<c:url value='/searchPonoListLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
                POFROM: $('#searchFrom').val(),
                POTO: $('#searchTo').val(),
                GUBUN: 'LIST',
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.PONO,
                            label: m.PONO,
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
            $("#searchPoNo").val(o.item.value);

            return false;
        }
    });

    // 거래처명 Lov
    $("#searchCustomerName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#searchCustomerName").val("");
            $("#searchCustomerCode").val("");
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
                CUSTOMERTYPE: 'A',
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.VALUE,
                            label: m.LABEL + ", " + m.CUSTOMERTYPENAME,
                            NAME: m.LABEL,
                            ADDRESS: m.ADDRESS,
                            FREIGHT: m.FREIGHT,
                            PHONENUMBER: m.PHONENUMBER,
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
            $("#searchCustomerCode").val(o.item.value);
            $("#searchCustomerName").val(o.item.NAME);

            return false;
        }
    });

    // 품번 Lov
    $("#searchOrderName")
    .bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#searchItemCode").val("");
            $("#searchItemName").val("");
            break;
        case $.ui.keyCode.ENTER:
            $(this).autocomplete("search", "%");
            break;

        default:
            break;
        }
    })
    .bind("keyup", function (e) {
        if (this.value === "")
            $(this).autocomplete("search", "%");
    })
    .focus(function (e) {
        $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
    })
    .click(function (e) {
        $(this).autocomplete("search", "%");
    })
    .autocomplete({
        source: function (request, response) {
            $.getJSON("<c:url value='/searchItemNameLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
                MATGUBUN: 'ORDERNAME', // 제품, 반제품 조회
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            label: m.ORDERNAME + ', ' + m.ITEMNAME,
                            value: m.ITEMCODE,
                            ITEMNAME: m.ITEMNAME,
                            ORDERNAME: m.ORDERNAME,
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
            $("#searchItemCode").val(o.item.value);
            $("#searchItemName").val(o.item.ITEMNAME);
            $("#searchOrderName").val(o.item.ORDERNAME);
            return false;
        }
    });

    // 품명 Lov
    $("#searchItemName")
    .bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#searchItemCode").val("");
            $("#searchOrderName").val("");
            break;
        case $.ui.keyCode.ENTER:
            $(this).autocomplete("search", "%");
            break;

        default:
            break;
        }
    })
    .bind("keyup", function (e) {
        if (this.value === "")
            $(this).autocomplete("search", "%");
    })
    .focus(function (e) {
        $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
    })
    .click(function (e) {
        $(this).autocomplete("search", "%");
    })
    .autocomplete({
        source: function (request, response) {
            $.getJSON("<c:url value='/searchItemNameLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
                MATGUBUN: 'ITEMNAME', // 제품, 반제품 조회
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            label: m.ITEMNAME + ', ' + m.ORDERNAME,
                            value: m.ITEMCODE,
                            ITEMNAME: m.ITEMNAME,
                            ORDERNAME: m.ORDERNAME,
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
            $("#searchItemCode").val(o.item.value);
            $("#searchItemName").val(o.item.ITEMNAME);
            $("#searchOrderName").val(o.item.ORDERNAME);
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
                            <li>구매 관리</li>
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
                            <input type="hidden" id="searchItemCode" name="searchItemCode" />
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
                                    <th class="required_text">발주기간</th>
                                    <td >
                                        <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 100px;" maxlength="10" />
                                        &nbsp;~&nbsp;
                                        <input type="text" id="searchTo" name="searchTo" class="input_validation input_center" style="width: 100px;" maxlength="10" />
                                    </td>
                                    <th class="required_text">발주번호</th>
                                    <td>
                                        <input type="text" id="searchPoNo" name="searchPoNo" class="input_left"  style="width: 97%;" />
                                    </td>        
                                    <th class="required_text">공급사</th>
                                    <td >
                                        <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left"  style="width: 97%;" />
                                        <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" />
                                    </td>
                                    <th class="required_text">발주상태</th>
                                    <td>
                                        <select id="searchPOStatus" name="searchPOStatus" class="input_left validate[required]" style="width: 97%;">
                                        </select>
                                    </td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">발주구분</th>
                                    <td>
                                        <select id="searchOrderDiv" name="searchOrderDiv" class="input_left" style="width: 97%;">
                                        </select>
                                    </td>
                                    <th class="required_text">품명</th>
                                    <td>
                                        <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                    </td>
                                    <th class="required_text">품번</th>
                                    <td >
                                        <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                    </td>
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
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">기본 정보</div></td>
                        </tr>
                    </table>
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">상세 정보</div></td>
                        </tr>
                    </table>
                    <div id="gridArea1" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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