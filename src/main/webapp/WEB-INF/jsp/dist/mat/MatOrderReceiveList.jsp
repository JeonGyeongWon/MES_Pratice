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

    setReadOnly();

    setLovList();
});

function setInitial() {
    calender($('#SearchFrom, #SearchTo'));

    $('#SearchFrom, #SearchTo').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $("#SearchFrom").val(getToDay("${searchVO.dateFrom}") + "");
    $("#SearchTo").val(getToDay("${searchVO.dateTo}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {});

    gridnms["app"] = "dist";
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "OrderReceive";

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
            type: 'number',
            name: 'POSEQ',
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
            name: 'ITEMSTANDARD',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'ITEMTYPE',
        }, {
            type: 'string',
            name: 'ITEMTYPENAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARD',
        }, {
            type: 'string',
            name: 'MANAGECODE',
        }, {
            type: 'string',
            name: 'MANAGENAME',
        }, {
            type: 'string',
            name: 'UPPERITEMCODE',
        }, {
            type: 'string',
            name: 'UPPERITEMNAME',
        }, {
            type: 'string',
            name: 'UPPERORDERNAME',
        }, {
            type: 'string',
            name: 'PONOSEQ',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'number',
            name: 'ORDERQTY',
        }, {
            type: 'date',
            name: 'PODATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'DUEDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'POPERSON',
        }, {
            type: 'string',
            name: 'POPERSONNAME',
        }, {
            type: 'string',
            name: 'POSTATUS',
        }, {
            type: 'string',
            name: 'POSTATUSNAME',
        }, {
            type: 'string',
            name: 'USEDIV',
        }, {
            type: 'string',
            name: 'USEDIVNAME',
        }, {
            type: 'date',
            name: 'TRANSDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'TRANSNOSEQ',
        }, {
            type: 'number',
            name: 'TRANSQTY',
        }, {
            type: 'number',
            name: 'BEFOREQTY',
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
            name: 'TRANSDIVNAME',
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
            resizable: true,
            menuDisabled: true,
            locked: false,
            lockable: false,
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
            sortable: false,
            resizable: true,
            menuDisabled: false,
            lockable: false,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'POSEQ',
            text: '발주<br/>순번',
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
            dataIndex: 'CUSTOMERNAME',
            text: '공급사',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: false,
            lockable: false,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: false,
            locked: false,
            lockable: false,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'ORDERNAME',
            text: '품번',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: false,
            locked: false,
            lockable: false,
            style: 'text-align:center;',
            align: "center",
            summaryRenderer: function (value, meta, record) {
                value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>TOTAL</div>";
                return value;
            },
        }, {
            dataIndex: 'ORDERQTY',
            text: '발주수량',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            lockable: false,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'TRANSQTY',
            text: '입고수량',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            lockable: false,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'BEFOREQTY',
            text: '미입고수량',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            lockable: false,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'PODATE',
            text: '발주일',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: false,
            lockable: false,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
        }, {
            dataIndex: 'DUEDATE',
            text: '납기일',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: false,
            lockable: false,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
        }, {
            dataIndex: 'SUPPLYPRICE',
            text: '공급가액',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            lockable: false,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'ADDITIONALTAX',
            text: '부가세',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            lockable: false,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'TOTAL',
            text: '입고금액',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            lockable: false,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
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
            dataIndex: 'POSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'USEDIV',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/dist/mat/MatOrderReceiveList.do' />"
    });

    items["btns.1"] = [];

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
}

var gridarea;
function setExtGrid() {
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
                                SEARCHFROM: $('#SearchFrom').val(),
                                SEARCHTO: $('#SearchTo').val(),
                            },
                            reader: gridVals.reader,
                            //                writer: $.extend(gridVals.writer, {
                            //                  writeAllFields: true
                            //                }),
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
        control: items["btns.ctr.1"],
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
                height: 619,
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
                    },
                    'gridfilters',
                ],
                features: [$.extend(gridVals.groupingFeature, {
                        groupHeaderTpl: [
                            '{columnName}: {name:this.formatName}' +
                            ' / 입고수량: {[this.groupSum(values.children, "TRANSQTY")]}' +
                            ' / 단가: {[this.groupSum(values.children, "UNITPRICE")]}' +
                            ' / 공급가액: {[this.groupSum(values.children, "SUPPLYPRICE")]}' +
                            ' / 부가세: {[this.groupSum(values.children, "ADDITIONALTAX")]}' +
                            ' / 입고금액: {[this.groupSum(values.children, "TOTAL")]}', {
                                formatName: function (name) {
                                    var result = (name == "") ? "미정 " : name;
                                    return Ext.String.trim(result);
                                },
                                groupSum: function (record, field) {
                                    var result = record;
                                    var size = record.length;
                                    var sum = 0;

                                    if (size > 0) {
                                        for (var i = 0; i < size; i++) {
                                            sum += parseFloat(result[i].data[field]);
                                        }
                                    } else {
                                        sum = 0;
                                    }
                                    return Ext.util.Format.number(sum, '0,000.########');
                                }
                            },
                        ],
                    }), {
                        ftype: 'summary',
                        dock: 'bottom'
                    }
                ],
                viewConfig: {
                    itemId: 'workReportList',
                    trackOver: true,
                    loadMask: true,
                    stripeRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMSTANDARD') >= 0 || column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 80; //5;
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

function fn_excel_download() {
    var bigcd = $("#searchbigcd").val();
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var datefrom = $('#searchFrom').val();
    var dateto = $('#searchTo').val();
    var header = [],
    count = 0;

    if (datefrom === "") {
        header.push("발주일자 From");
        count++;
    }

    if (dateto === "") {
        header.push("발주일자 To");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return;
    }

    go_url("<c:url value='/dist/mat/MatOrderReceiveList/ExcelDownload.do?ORGID='/>" + $('#searchOrgId option:selected').val() + ""
         + "&COMPANYID=" + $('#searchCompanyId option:selected').val() + ""
         + "&SEARCHFROM=" + $("#SearchFrom").val() + ""
         + "&SEARCHTO=" + $("#SearchTo").val() + ""
         + "&PONO=" + $("#searchPoNo").val() + ""
         + "&CUSTOMERNAME=" + $("#searchCustomerName").val() + ""
         + "&ITEMTYPE=" + $("#searchItemType").val() + ""
         + "&ORDERNAME=" + $("#searchOrderName").val() + ""
         + "&ITEMNAME=" + $("#searchItemName").val() + ""
         + "&ORDERDIV=" + $("#searchOrderDiv").val() + ""
         + "&STATUS=" + $("#searchStatus").val() + ""
         + "&TRANSCHK=" + $("#TransChk").val() + "");
}

function fn_search() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var datefrom = $('#SearchFrom').val();
    var dateto = $('#SearchTo').val();
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
        header.push("발주일자 From");
        count++;
    }

    if (dateto === "") {
        header.push("발주일자 To");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return;
    }

    var sparams = {
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
        SEARCHFROM: datefrom,
        SEARCHTO: dateto,
        PONO: $('#searchPoNo').val(),
        CUSTOMERNAME: $('#searchCustomerName').val(),
        ITEMTYPE: $('#searchItemType').val(),
        ORDERNAME: $('#searchOrderName').val(),
        ITEMNAME: $('#searchItemName').val(),
        ORDERDIV: $('#searchOrderDiv').val(),
        STATUS: $('#searchStatus').val(),
        TRANSCHK: $('#TransChk').val(),
    };
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
                                                <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();">
                                                     엑셀
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
                                        <th class="required_text">발주일자</th>
                                        <td >
                                            <input type="text" id="SearchFrom" name="SearchFrom" class="input_validation input_center " style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="SearchTo" name="SearchTo" class="input_validation input_center " style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">발주번호</th>
                                        <td>
                                            <input type="text" id="searchPoNo" name="searchPoNo" class="input_left"  style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" />
                                        </td>
                                        <th class="required_text">공급사</th>
                                        <td>
                                            <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left"  style="width: 97%;" />
                                            <input type="hidden" id="searchCustomerCode" name="searchCustomerCode"  />
                                        </td>
                                        <th class="required_text">품목유형</th>
                                        <td>
                                            <select id="searchItemType" name="searchItemType" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.ITEMTYPE}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByItemType}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.ITEMTYPE}">
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
                                        <th class="required_text">품명</th>
                                        <td>
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">발주구분</th>
                                        <td>
                                            <select id="searchOrderDiv" name="searchOrderDiv" class="input_left" style="width: 97%;">
                                                <c:if test="${empty searchVO.ORDERDIV}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByOrderDiv}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.ORDERDIV}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th class="required_text">발주상태</th>
                                        <td>
                                            <select id="searchStatus" name="searchStatus" class="input_left" style="width: 97%;">
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
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">입고여부</th>
                                        <td>
                                            <select id="TransChk" name="TransChk" class="input_left" style="width: 97%;">
                                                <c:if test="${empty searchVO.TRANSCHECK}">
                                                    <option value="" >전체</option>
                                                    <option value="Y" >입고</option>
                                                    <option value="N" >미입고</option>
                                                </c:if>
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
                            </form>
                        </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
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