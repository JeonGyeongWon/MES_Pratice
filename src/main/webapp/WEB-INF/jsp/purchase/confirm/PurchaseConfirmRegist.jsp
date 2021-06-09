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

var global_close_yn = "N";
function setInitial() {

    gridnms["app"] = "purchase";

    // 입하일자
    calender($('#searchTransFrom, #searchTransTo'));

    $('#searchTransFrom, #searchTransTo').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $("#searchTransFrom").val(getToDay("${searchVO.dateFrom}") + "");
    $("#searchTransTo").val(getToDay("${searchVO.dateTo}") + "");

    // 확정일자
    calender($('#searchConfirmFrom, #searchConfirmTo'));

    $('#searchConfirmFrom, #searchConfirmTo').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $('#searchOrgId, #searchCompanyId').change(function (event) {});
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "PurchaseConfirmRegist";
    gridnms["grid.10"] = "PurchaseGubunLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.10"] = gridnms["app"] + ".model." + gridnms["grid.10"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.10"] = gridnms["app"] + ".store." + gridnms["grid.10"];

    gridnms["models.list"].push(gridnms["model.1"]);
    gridnms["models.list"].push(gridnms["model.10"]);

    gridnms["stores.list"].push(gridnms["store.1"]);
    gridnms["stores.list"].push(gridnms["store.10"]);

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
            name: 'TRANSNO',
        }, {
            type: 'string',
            name: 'TRANSSEQ',
        }, {
            type: 'date',
            name: 'TRANSDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'PERSONNAME',
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
            name: 'ITEMSTANDARD',
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
            type: 'number',
            name: 'TRANSQTY',
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
            name: 'PONO',
        }, {
            type: 'string',
            name: 'POSEQ',
        }, {
            type: 'number',
            name: 'POQTY',
        }, {
            type: 'string',
            name: 'CUSTOMERLOT',
        }, {
            type: 'string',
            name: 'WAREHOUSING',
        }, {
            type: 'string',
            name: 'WAREHOUSINGNAME',
        }, {
            type: 'date',
            name: 'INSPECTIONDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'number',
            name: 'INSPECTIONQTY',
        }, {
            type: 'string',
            name: 'ORDERINSPECTIONYN',
        }, {
            type: 'number',
            name: 'DUEQTY',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'CONFIRMYN',
        }, {
            type: 'date',
            name: 'CONFIRMDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'number',
            name: 'CONFIRMQTY',
        }, {
            type: 'number',
            name: 'SEQ',
        }, {
            type: 'string',
            name: 'PURCHASEGUBUN',
        }, {
            type: 'string',
            name: 'PURCHASEGUBUNNAME',
        }, ];

    fields["model.10"] = [{
            type: 'string',
            name: 'LABEL',
        }, {
            type: 'string',
            name: 'VALUE',
        }, ];

    fields["columns.1"] = [
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
            align: "center",
            editor: {
                xtype: 'checkbox',
            },
        }, {
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
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'XXXXXXXXXX',
            sortable: false,
            resizable: false,
            menuDisabled: true,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '',
            width: 65,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "확정",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    fn_appr(record.data, 'CONFIRM');
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            },
        }, {
            dataIndex: 'XXXXXXXXXY',
            sortable: false,
            resizable: false,
            menuDisabled: true,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '',
            width: 65,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "취소",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    fn_appr(record.data, 'CANCEL');
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            },
        }, {
            dataIndex: 'CONFIRMYNNAME',
            text: '확정여부',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'CONFIRMDATE',
            text: '확정일자',
            xtype: 'datecolumn',
            width: 105,
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
                var confirmyn = record.data.CONFIRMYN;
                if (confirmyn == "N") {
                    meta.style = "background-color:rgb(253, 218, 255)";
                } else {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return Ext.util.Format.date(value, 'Y-m-d');
            },
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
            editor: {
                xtype: "textfield",
                minValue: 1,
                format: "0,000",
                enforceMaxLength: true,
                allowBlank: true,
                maxLength: '9',
                maskRe: /[0-9]/,
                selectOnFocus: true,
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        var qty = field.getValue() * 1;
                        var unitprice = store.data.UNITPRICE * 1;
                        var supplyprice = qty * unitprice;
                        var addtax = Math.round((qty * unitprice) * 0.1);
                        var total = supplyprice + addtax;

                        store.set("SUPPLYPRICE", supplyprice);
                        store.set("ADDITIONALTAX", addtax);
                        store.set("TOTAL", total);
                    },
                },
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.CONFIRMYN;
                if (confirmyn == "N") {
                    meta.style = "background-color:rgb(253, 218, 255)";
                } else {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TRANSDATE',
            text: '입하일',
            xtype: 'datecolumn',
            width: 95,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                editable: false,
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 235,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
            summaryRenderer: function (value, meta, record) {
                value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>TOTAL</div>";
                return value;
            },
        }, {
            dataIndex: 'TRANSQTY',
            text: '입하수량',
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
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
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
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'SUPPLYPRICE',
            text: '공급가액',
            xtype: 'gridcolumn',
            width: 130,
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
                maskRe: /[0-9]/,
                selectOnFocus: true,
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        var supplyprice = newValue;

                        var additionaltax = supplyprice * 0.1; // 부가세
                        store.set("ADDITIONALTAX", additionaltax);

                        var total = ((supplyprice * 1) + (supplyprice * 0.1)); // 합계
                        store.set("TOTAL", total);
                    },
                },
            },
            summaryType: function (records, values) {
                var i = 0,
                length = records.length,
                total = 0,
                record;

                for (; i < length; ++i) {
                    record = records[i];

                    total += (record.data.SUPPLYPRICE * 1);
                }
                return total;
            },
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.CONFIRMYN;
                if (confirmyn == "N") {
                    meta.style = "background-color:rgb(253, 218, 255)";
                } else {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ADDITIONALTAX',
            text: '부가세',
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
            editor: {
                xtype: "textfield",
                minValue: 1,
                format: "0,000",
                enforceMaxLength: true,
                allowBlank: true,
                maxLength: '9',
                maskRe: /[0-9]/,
                selectOnFocus: true,
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        var supplyprice = store.data.SUPPLYPRICE; // 출고수량

                        var additionaltax = newValue; // 부가세

                        var total = ((supplyprice * 1) + (additionaltax * 1)); // 합계
                        store.set("TOTAL", total);
                    },
                },
            },
            summaryType: function (records, values) {
                var i = 0,
                length = records.length,
                total = 0,
                record;

                for (; i < length; ++i) {
                    record = records[i];

                    total += (record.data.ADDITIONALTAX * 1);
                }
                return total;
            },
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.CONFIRMYN;
                if (confirmyn == "N") {
                    meta.style = "background-color:rgb(253, 218, 255)";
                } else {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTAL',
            text: '합계',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            summaryType: function (records, values) {
                var i = 0,
                length = records.length,
                total = 0,
                record;

                for (; i < length; ++i) {
                    record = records[i];

                    total += (record.data.TOTAL * 1);
                }
                return total;
            },
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
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
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'PERSONNAME',
            text: '발주담당자',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'PURCHASEGUBUNNAME',
            text: '매입구분',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.10"],
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

                        model.set("PURCHASEGUBUN", record.data.VALUE);
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
                var confirmyn = record.data.CONFIRMYN;
                if (confirmyn == "N") {
                    meta.style = "background-color:rgb(253, 218, 255)";
                } else {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return value;
            },
        }, {
            dataIndex: 'TOTALCONFIRMQTY',
            text: '기확정수량',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TRANSNO',
            text: '입하번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'TRANSSEQ',
            text: '입하순번',
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
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
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
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'PONO',
            text: '발주번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'POSEQ',
            text: '발주순번',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'POQTY',
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
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'CUSTOMERLOT',
            text: '업체LOT번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'WAREHOUSINGNAME',
            text: '보관위치',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'INSPDATE',
            text: '검사일',
            xtype: 'datecolumn',
            width: 90,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                editable: false,
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'INSPQTY',
            text: '검사수량',
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
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'DUEQTY',
            text: '입고잔량',
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
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
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
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
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
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'WAREHOUSING',
            xtype: 'hidden',
        }, {
            dataIndex: 'ORDERINSPECTIONYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'CONFIRMYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'SAVETYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'PURCHASEGUBUN',
            xtype: 'hidden',
        },
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/purchase/confirm/PurchaseConfirmRegist.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChk1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "확정",
        itemId: "btnCon1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "취소",
        itemId: "btnCan1"
    });

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnChk1": {
            click: 'btnChk1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnCon1": {
            click: 'btnCon1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnCan1": {
            click: 'btnCan1Click'
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

var global_btn_flag = false;
function btnChk1Click() {
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var checkTrue = 0,
    checkFalse = 0;

    global_btn_flag = !global_btn_flag;

    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var confirmyn = model1.data.CONFIRMYN;

        if (global_btn_flag) {
            //          if (confirmyn == "N") {
            // 체크 상태로
            model1.set("CHK", true);
            checkFalse++;
            //          }
        } else {
            //            if (confirmyn == "N") {
            // 체크 상태로
            model1.set("CHK", false);
            checkTrue++;
            //              }
        }
    }
    if (checkTrue > 0) {
        console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
    }
    if (checkFalse > 0) {
        console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
    }
}

function btnCon1Click(o, e) {
    var url = "";
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    if (count1 == 0) {
        extAlert("조회된 데이터가 없습니다.<br/>다시 한번 확인해주십시오.");
        return;
    }

    var chkCount = 0;
    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var chk = model1.data.CHK;
        if (chk) {
            chkCount++;

            var transdate = Ext.util.Format.date(model1.data.TRANSDATE, 'Y-m-d');
            global_close_yn = fn_monthly_close_filter_data(transdate, 'MAT');
            if (global_close_yn == "Y") {
                extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
                return false;
            }
        }
    }

    if (chkCount == 0) {
        extAlert("확정하실 데이터가 선택되지 않았습니다.<br/>다시한번 확인해주십시오.");
        return;
    }

    Ext.MessageBox.confirm('확정 ', '확정처리를 하시겠습니까?', function (btn) {
        if (btn == 'yes') {

            for (var j = 0; j < count1; j++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(j));
                var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
                var chk = model1.data.CHK;

                if (chk) {
                    var confirmyn = model1.data.CONFIRMYN;
                    if (confirmyn == "N") {

                        url = "<c:url value='/appr/purchase/confirm/PurchaseConfirmRegist.do' />";

                        var mData = model1.data;
                        var confirmdate = Ext.util.Format.date(mData.CONFIRMDATE, 'Y-m-d');
                        mData.CONFIRMDATE = confirmdate;
                        mData.SAVETYPE = "CONFIRM";

                        var params = [];
                        $.ajax({
                            url: url,
                            type: "post",
                            dataType: "json",
                            data: mData,
                            success: function (data) {

                                var success = data.success;
                                if (!success) {
                                    extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                                    return;
                                } else {
                                    msg = "매입확정 처리를 하였습니다.";
                                    extAlert(msg);
                                    fn_search();
                                }
                            },
                            error: ajaxError
                        });
                    }
                }
            }
        } else {
            Ext.Msg.alert('매입확정', '매입확정 처리가 취소되었습니다.');
            return;
        }
    });
}

function btnCan1Click(o, e) {
    var url = "";

    var count1 = Ext.getStore(gridnms["store.1"]).count();
    if (count1 == 0) {
        extAlert("조회된 데이터가 없습니다.<br/>다시 한번 확인해주십시오.");
        return;
    }

    var chkCount = 0;
    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var chk = model1.data.CHK;
        if (chk) {
            chkCount++;

            var transdate = Ext.util.Format.date(model1.data.TRANSDATE, 'Y-m-d');
            global_close_yn = fn_monthly_close_filter_data(transdate, 'MAT');
            if (global_close_yn == "Y") {
                extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
                return false;
            }
        }
    }

    if (chkCount == 0) {
        extAlert("취소하실 데이터가 선택되지 않았습니다.<br/>다시한번 확인해주십시오.");
        return;
    }

    Ext.MessageBox.confirm('취소 ', '취소처리를 하시겠습니까?', function (btn) {
        if (btn == 'yes') {

            for (var j = 0; j < count1; j++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(j));
                var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
                var chk = model1.data.CHK;

                if (chk) {
                    var confirmyn = model1.data.CONFIRMYN;
                    if (confirmyn == "Y") {

                        url = "<c:url value='/appr/purchase/confirm/PurchaseConfirmRegist.do' />";

                        var mData = model1.data;
                        var confirmdate = Ext.util.Format.date(mData.CONFIRMDATE, 'Y-m-d');
                        mData.CONFIRMDATE = confirmdate;
                        mData.SAVETYPE = "CANCEL";

                        var params = [];
                        $.ajax({
                            url: url,
                            type: "post",
                            dataType: "json",
                            data: mData,
                            success: function (data) {

                                var success = data.success;
                                if (!success) {
                                    extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                                    return;
                                } else {
                                    msg = "확정취소 처리를 하였습니다.";
                                    extAlert(msg);
                                    fn_search();
                                }
                            },
                            error: ajaxError
                        });
                    }
                }
            }
        } else {
            Ext.Msg.alert('확정취소', '확정취소 처리가 취소되었습니다.');
            return;
        }
    });
}

var gridarea;
function setExtGrid() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"],
    });
    
    Ext.define(gridnms["model.10"], {
        extend: Ext.data.Model,
        fields: fields["model.10"],
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
                                TRANSFROM: '${searchVO.dateFrom}',
                                TRANSTO: '${searchVO.dateTo}',
                                CONFIRMYN: $('#searchConfirmyn').val(),
                                ITEMTYPE: $('#searchItemType').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.10"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.10"],
                        model: gridnms["model.10"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                BIGCD: 'MAT',
                                MIDDLECD: 'PURCHASE_GUBUN',
                                GUBUN: 'ORDER BY',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            confirmList: '#confirmList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        btnChk1Click: btnChk1Click,
        btnCon1Click: btnCon1Click,
        btnCan1Click: btnCan1Click,
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
                height: 632,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'bottom'
                    }
                ],
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
                    itemId: 'confirmList',
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
                                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('PERSONNAME') >= 0) {
                                    //                  if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ITEMSTANDARD') >= 0 || column.dataIndex.indexOf('MATERIALTYPE') >= 0) {
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
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = [];
                                var confirmyn = data.data.CONFIRMYN;
                                if (confirmyn != "N") {
                                    editDisableCols.push("CONFIRMDATE");
                                    editDisableCols.push("CONFIRMQTY");
                                    editDisableCols.push("SUPPLYPRICE");
                                    editDisableCols.push("ADDITIONALTAX");
                                    editDisableCols.push("PURCHASEGUBUNNAME");
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

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
    });
}

function fn_appr(record, flag) {
    var transdate = Ext.util.Format.date(record.TRANSDATE, 'Y-m-d');
    global_close_yn = fn_monthly_close_filter_data(transdate, 'MAT');
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }
    var url = "";

    var count1 = Ext.getStore(gridnms["store.1"]).count();
    if (count1 == 0) {
        extAlert("조회된 데이터가 없습니다.<br/>다시 한번 확인해주십시오.");
        return;
    }

    var confirmyn = record.CONFIRMYN;
    if (flag == "CONFIRM") {
        if (confirmyn == "Y") {
            extAlert("미확정 상태에 대해서만 확정 처리가 가능합니다.");
            return;
        }
    } else if (flag == "CANCEL") {

        if (confirmyn == "N") {
            extAlert("확정 상태에 대해서만 취소 처리가 가능합니다.");
            return;
        }
    }

    url = "<c:url value='/appr/purchase/confirm/PurchaseConfirmRegist.do' />";

    var mData = record;
    var confirmdate = Ext.util.Format.date(mData.CONFIRMDATE, 'Y-m-d');
    mData.CONFIRMDATE = confirmdate;
    mData.SAVETYPE = flag;

    Ext.MessageBox.confirm(((flag == "CONFIRM") ? '확정' : '취소'), ((flag == "CONFIRM") ? '확정' : '취소') + ' 처리를 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: mData,
                success: function (data) {

                    var success = data.success;
                    if (!success) {
                        extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                        return;
                    } else {
                        msg = ((flag == "CONFIRM") ? "확정" : "취소") + " 처리를 하였습니다.";
                        extAlert(msg);
                        fn_search();
                    }
                },
                error: ajaxError
            });

            return;
        } else {
            Ext.Msg.alert((flag == "CONFIRM") ? '확정' : '취소', ((flag == "CONFIRM") ? '확정' : '취소') + ' 처리가 취소되었습니다.');
            return;
        }
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var transfrom = $('#searchTransFrom').val();
    var transto = $('#searchTransTo').val();
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

    if (transfrom === "") {
        header.push("입하일자 From");
        count++;
    }

    if (transto === "") {
        header.push("입하일자 To");
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

    global_btn_flag = false;

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var transfrom = $('#searchTransFrom').val();
    var transto = $('#searchTransTo').val();
    var confirmfrom = $('#searchConfirmFrom').val();
    var confirmto = $('#searchConfirmTo').val();
    var confirmyn = $('#searchConfirmyn option:selected').val();
    var itemtype = $('#searchItemType option:selected').val();
    var customercode = $('#searchCustomerCode').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TRANSFROM: transfrom,
        TRANSTO: transto,
        CONFIRMFROM: confirmfrom,
        CONFIRMTO: confirmto,
        CONFIRMYN: confirmyn,
        ITEMTYPE: itemtype,
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
    var transfrom = $('#searchTransFrom').val();
    var transto = $('#searchTransTo').val();
    var confirmfrom = $('#searchConfirmFrom').val();
    var confirmto = $('#searchConfirmTo').val();
    var customercode = $('#searchCustomerCode').val();
    var confirmyn = $('#searchConfirmyn option:selected').val();
    var itemtype = $('#searchItemType option:selected').val();

    go_url("<c:url value='/purchase/confirm/ExcelDownload.do?ORGID='/>" + orgid
         + "&COMPANYID=" + companyid + ""
         + "&TRANSFROM=" + transfrom + ""
         + "&TRANSTO=" + transto + ""
         + "&CONFIRMFROM=" + confirmfrom + ""
         + "&CONFIRMTO=" + confirmto + ""
         + "&CONFIRMYN=" + confirmyn + ""
         + "&ITEMTYPE=" + itemtype + ""
         + "&CUSTOMERCODE=" + customercode + ""
         + "&TITLE=" + "${pageTitle}" + "");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {

    // 공급사 Lov
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
                CUSTOMERTYPE3: 'A',
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
                            <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" />
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
                                    <td>
                                        <div class="buttons" style="float: right; margin-top: 3px;">
                                            <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                                            <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <table class="tbl_type_view" border="1">
                                <colgroup>
                                    <col width="120px">
                                    <col width="320px">
                                    <col width="120px">
                                    <col width="320px">
                                    <col width="120px">
                                    <col>
                                    <col width="120px">
                                    <col>
                                </colgroup>
                                <tr style="height: 34px;">
                                        <th class="required_text">입하일자</th>
                                        <td>
	                                            <input type="text" id="searchTransFrom" name="searchTransFrom" class="input_validation input_center " style="width: 90px; margin-top: 6px; " maxlength="10" />
	                                            &nbsp;~&nbsp;
	                                            <input type="text" id="searchTransTo" name="searchTransTo" class="input_validation input_center " style="width: 90px; margin-top: 6px; " maxlength="10" />
				                                      <div class="buttons" style="float: right; margin-top: 3px;">
				                                          <a id="btnChkDate1" class="" href="#" onclick="javascript:fn_btn_change_date('searchTransFrom', 'searchTransTo', '${searchVO.postdateFrom}', '${searchVO.postdateTo}');">
				                                             &nbsp;&nbsp;금월&nbsp;&nbsp;
				                                          </a>
				                                          <a id="btnChkDate2" class="" href="#" onclick="javascript:fn_btn_change_date('searchTransFrom', 'searchTransTo', '${searchVO.predateFrom}', '${searchVO.predateTo}');">
				                                             &nbsp;&nbsp;전월&nbsp;&nbsp;
				                                          </a>
				                                      </div>
                                        </td>
                                        <th class="required_text">확정일자</th>
                                        <td>
	                                            <input type="text" id="searchConfirmFrom" name="searchConfirmFrom" class=" input_center " style="width: 90px; margin-top: 6px; " maxlength="10" />
	                                            &nbsp;~&nbsp;
	                                            <input type="text" id="searchConfirmTo" name="searchComfirmTo" class=" input_center " style="width: 90px; margin-top: 6px; " maxlength="10" />
                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                <a id="btnChkDate3" class="" href="#" onclick="javascript:fn_btn_change_date('searchConfirmFrom', 'searchConfirmTo', '${searchVO.postdateFrom}', '${searchVO.postdateTo}');">
                                                   &nbsp;&nbsp;금월&nbsp;&nbsp;
                                                </a>
                                                <a id="btnChkDate4" class="" href="#" onclick="javascript:fn_btn_change_date('searchConfirmFrom', 'searchConfirmTo', '${searchVO.predateFrom}', '${searchVO.predateTo}');">
                                                   &nbsp;&nbsp;전월&nbsp;&nbsp;
                                                </a>
                                            </div>
                                        </td>
                                        <th class="required_text">확정여부</th>
                                        <td>
                                            <select id="searchConfirmyn" name="searchConfirmyn" class="input_left" style="width: 97%;">
                                                <option value="" label="전체" />
                                                <option value="N" label="미확정" selected="selected" />
                                                <option value="Y" label="확정" />
                                            </select>
                                        </td>
                                        <th class="required_text">유형</th>
                                        <td>
                                            <select id="searchItemType" name="searchItemType" class="input_center " style="width: 94%;">
                                                <c:if test="${empty searchVO.ITEMTYPE}">
                                                    <option value=""  >전체</option>
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
                                        <!-- <th class="required_text">입하번호</th>
                                        <td>
                                            <input type="text" id="searchTransNo" name="searchTransNo" class="input_left" style="width: 97%;" />
                                        </td> -->
                                </tr>
                                <tr style="height: 34px;">
                                        <th class="required_text">공급사</th>
                                        <td>
	                                            <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left" style="width: 97%;" />
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

                <div style="width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">매입확정</div></td>
                        </tr>
                    </table>
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>