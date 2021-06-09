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
	LoginVO loginVO = (LoginVO) session.getAttribute("LoginVO");
	String authCode = loginVO.getAuthCode();

	/* Image Path 설정 */
	String imagePath_icon = "/images/egovframework/sym/mpm/icon/";
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

.x-form-field {
	font-size: 10px;
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

    // 제품선택 팝업창 추가
    setValues_Popup();
    setExtGrid_Popup();
    setValues_Popup1();
    setExtGrid_Popup1();

    $("#gridPopup1Area").hide("blind", {
        direction: "up"
    }, "fast");
    $("#gridPopup11Area").hide("blind", {
        direction: "up"
    }, "fast");

    setReadOnly();
    setLovList();

    setLastInitial();
});

var global_close_yn = "N";
function setInitial() {
    // 최초 상태 설정
    gridnms["app"] = "purchase";

    calender($('#PoDate'));

    $('#PoDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    //       fn_option_change_r('CMM', 'TAX_DIV', 'TaxDiv');
    fn_option_change_r('MAT', 'ORDER_DIV', 'OrderDiv');
    fn_option_change_r('MAT', 'DELIVERY_LOCATION', 'DeliveryLocation');
    $('#searchOrgId, #searchCompanyId').change(function (event) {

        //         fn_option_change_r('CMM', 'TAX_DIV', 'TaxDiv');
        fn_option_change_r('MAT', 'ORDER_DIV', 'OrderDiv');
        fn_option_change_r('MAT', 'DELIVERY_LOCATION', 'DeliveryLocation');
    });
}

function setLastInitial() {

    $('#TaxDiv').change(function (event) {
        var count = Ext.getStore(gridnms["store.1"]).count();
        if (count > 0) {
            for (var i = 0; i < count; i++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
                var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                var qty = model1.data.ORDERQTY; // 수량

                var unitpricea = model1.data.UNITPRICE; // 단가
                model1.set("UNITPRICE", unitpricea);

                var supplyprice = qty * unitpricea; //공급가액
                model1.set("SUPPLYPRICE", supplyprice);

                var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                var additionaltax = supplyprice * (tax_rate / 100); // 부가세
                model1.set("ADDITIONALTAX", additionaltax);

                var total = supplyprice + additionaltax; // 합계
                model1.set("TOTAL", total);
            }
        }
    });

    var pono = $('#PoNo').val();
    if (pono != "") {
        fn_search();
    } else {
        $("#PoDate").val(getToDay("${searchVO.TODAY}") + "");

        // 2016.10.04. 관리자 권한 외 사용자 로그인시 담당자에 이름 표기
        var groupid = "${searchVO.groupId}";
        switch (groupid) {
        case "ROLE_ADMIN":
            // 관리자 권한일 때 그냥 놔둠
            break;
        default:
            // 관리자 외 권한일 때 사용자명 표기
            $('#PoPersonName').val("${searchVO.KRNAME}");
            $('#PoPerson').val("${searchVO.EMPLOYEENUMBER}");
            break;
        }

        $('#OrderDiv').val("A");
        $('#TaxDiv').val("01");
        $('#DeliveryLocation').val("01");
    }
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.1"] = "PurchaseOrderDetail";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.detail"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.detail"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

    gridnms["models.detail"].push(gridnms["model.1"]);

    gridnms["stores.detail"].push(gridnms["store.1"]);

    fields["model.1"] = [{
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
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
            name: 'ITEMSTANDARD',
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
            menuDisabled: true,
            align: "center",
            editor: {
                xtype: 'checkbox',
            },
            renderer: function (value, meta, record, row, col) {

                var result = $('#PoStatus').val();

                if (result == "COMPLETE") {
                    meta['tdCls'] = 'x-item-disabled';
                } else {
                    meta['tdCls'] = '';
                }
                return new Ext.ux.CheckColumn().renderer(value);
            },
            listeners: {
                beforecheckchange: function (options, row, value, event) {

                    var record = Ext.getCmp(gridnms["views.detail"]).selModel.store.data.items[row].data;
                    if (value) {
                        var result = $('#PoStatus').val();

                        if (result == "COMPLETE") {
                            extAlert("발주상태가 완료일 때에는 삭제가 불가능합니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }
                    }
                }
            }
        }, {
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
            editor: {
                xtype: "textfield",
                minValue: 1,
                format: "0,000",
                enforceMaxLength: true,
                allowBlank: true,
                maxLength: '4',
                maskRe: /[0-9.]/,
                selectOnFocus: true,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '',
            dataIndex: '',
            width: 100,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "단가적용",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var itemcode = record.data.ITEMCODE;
                    var unitprice = record.data.UNITPRICE;

                    fn_price_default(itemcode, unitprice);
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
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
                meta.style = "background-color:rgb(234, 234, 234); ";
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
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
                meta.style = "background-color:rgb(234, 234, 234); ";
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
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var qty = field.getValue();
                        var tqty = oldValue;
                        var unitcost = store.data.UNITPRICE;
                        var tunitcost = store.data.UNITPRICE;
                        store.set("UNITPRICE", unitcost);

                        var supplyprice = 0,
                        tsupplyprice = 0;
                        var addtax = 0,
                        taddtax = 0;

                        supplyprice = (qty * unitcost) * 1.0;
                        tsupplyprice = (tqty * tunitcost) * 1.0;
                        store.set("SUPPLYPRICE", supplyprice);

                        addtax = Math.round((qty * unitcost) * 0.1);
                        taddtax = Math.round((tqty * tunitcost) * 0.1);

                        var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                        var additionaltax = Math.round(supplyprice * (tax_rate / 100)); // 부가세
                        store.set("ADDITIONALTAX", additionaltax);

                        var total = supplyprice + additionaltax; // 합계
                        store.set("TOTAL", total);

                    },
                },
            },
            renderer: function (value, meta, record) {
                var PoStatus = $('#PoStatus').val();
                if (PoStatus == "COMPLETE" || PoStatus == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    meta.style = "background-color:rgb(253, 218, 255); ";
                }
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
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var qty = store.data.ORDERQTY;
                        var tqty = store.data.ORDERQTY;
                        var unitcost = field.getValue();
                        var tunitcost = oldValue;

                        var supplyprice = 0,
                        tsupplyprice = 0;
                        var addtax = 0,
                        taddtax = 0;

                        supplyprice = (qty * unitcost) * 1.0;
                        tsupplyprice = (tqty * tunitcost) * 1.0;
                        store.set("SUPPLYPRICE", supplyprice);

                        addtax = Math.round((qty * unitcost) * 0.1);
                        taddtax = Math.round((tqty * tunitcost) * 0.1);
                        var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                        var additionaltax = Math.round(supplyprice * (tax_rate / 100)); // 부가세
                        store.set("ADDITIONALTAX", additionaltax);

                        var total = supplyprice + additionaltax; // 합계
                        store.set("TOTAL", total);

                    },
                },
            },
            renderer: function (value, meta, record) {
                var PoStatus = $('#PoStatus').val();
                if (PoStatus == "COMPLETE" || PoStatus == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    meta.style = "background-color:rgb(253, 218, 255); ";
                }
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
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var supplyprice = newValue * 1;

                        var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                        var additionaltax = Math.round(supplyprice * (tax_rate / 100)); // 부가세
                        store.set("ADDITIONALTAX", additionaltax);

                        var total = supplyprice + additionaltax; // 합계
                        store.set("TOTAL", total);
                    },
                },
            },
            renderer: function (value, meta, record) {
                var PoStatus = $('#PoStatus').val();
                if (PoStatus == "COMPLETE" || PoStatus == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    meta.style = "background-color:rgb(253, 218, 255); ";
                }
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
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var supplyprice = store.data.SUPPLYPRICE; // 출고수량

                        var additionaltax = newValue; // 부가세

                        var total = ((supplyprice * 1) + (additionaltax * 1)); // 합계
                        store.set("TOTAL", total);
                    },
                },
            },
            renderer: function (value, meta, record) {
                var PoStatus = $('#PoStatus').val();
                if (PoStatus == "COMPLETE" || PoStatus == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    meta.style = "background-color:rgb(253, 218, 255); ";
                }
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
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
            },
            renderer: function (value, meta, record) {

                var PoStatus = $('#PoStatus').val();
                if (PoStatus == "COMPLETE" || PoStatus == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                }
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
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, meta, record) {

                meta.style = "background-color:rgb(234, 234, 234); ";
                var startdate = Ext.Date.format(record.data.DUEDATE, 'Y-m-d');
                var enddate = Ext.Date.format(value, 'Y-m-d');
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
            align: "center",
            editor: {
                xtype: 'combo',
                store: ['Y', 'N'],
                editable: false,
            },
            renderer: function (value, meta, record) {
                var PoStatus = $('#PoStatus').val();
                if (PoStatus == "COMPLETE" || PoStatus == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                }
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
            //        editor: {
            //          xtype: 'combo',
            //          store: ['Y', 'N'],
            //          editable: false,
            //        },
            //        renderer: function (value, meta, record) {
            //          var PoStatus = $('#PoStatus').val();
            //          if (PoStatus == "COMPLETE" || PoStatus == "CANCEL") {
            //            meta.style = "background-color:rgb(234, 234, 234); ";
            //          }
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
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            width: 160,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: "textfield",
                allowBlank: true,
            },
            renderer: function (value, meta, record) {

                var PoStatus = $('#PoStatus').val();
                if (PoStatus == "COMPLETE" || PoStatus == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                }
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
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'ORDERFINISHYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SCMINSPECTIONYN',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/purchase/order/PurchaseOrderListDetail.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChkd1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "삭제",
        itemId: "btnDel1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "자재불러오기",
        itemId: "btnSel1"
    });

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnChkd1": {
            click: 'btnChk1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnDel1": {
            click: 'btnDel1'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnSel1": {
            click: 'btnSel1'
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

var btn_click = false;
function btnChk1Click() {
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var checkTrue = 0,
    checkFalse = 0;

    btn_click = !btn_click;

    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

        var Status = $('#PoStatus').val();
        if (Status === "COMPLETE") {}
        else {
            if (btn_click) {
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

function btnDel1() {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var store = this.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var pono = $('#PoNo').val();
    var poseq = "";
    var Status = $('#PoStatus').val();
    var url = "<c:url value='/delete/purchase/order/PurchaseOrderListDetail.do' />";

    if (record === undefined) {
        extAlert("삭제하실 데이터를 선택 해 주십시오.");
        return;
    }
    var gridcount = store.count() * 1;
    if (gridcount == 0) {
        extAlert("삭제하실 데이터가 없습니다.");
        return;
    }

    if (Status === "COMPLETE") {
        extAlert("발주 완료 상태에서는 삭제가 불가능 합니다..");
        return false;
    }

    // 체크여부 확인
    var count = 0;
    for (var k = 0; k < gridcount; k++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(k));
        var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

        if (model.data.CHK) {
            count++;
        }
    }

    var msgdata = "",
    deletecount = 0;
    if (count > 0) {
        // 체크박스 선택시
        Ext.MessageBox.confirm('삭제 알림', '삭제 하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                for (i = gridcount - 1; i >= 0; i--) {
                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
                    var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                    if (model.data.CHK) {
                        orgid = model.data.ORGID;
                        companyid = model.data.COMPANYID;
                        pono = model.data.PONO;
                        poseq = model.data.POSEQ;

                        if (pono == "") {
                            // 데이터 등록되지 않은 건
                            deletecount++;
                            store.remove(model);
                        } else {
                            // 데이터 등록 건

                            var sparams = {
                                ORGID: orgid,
                                COMPANYID: companyid,
                                PONO: pono,
                                POSEQ: poseq,
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
                                        deletecount++;
                                    }

                                    if (deletecount == count) {
                                        extAlert(msgdata);
                                        go_url("<c:url value='/purchase/order/PurchaseOrderManage.do?PONO=' />" + pono + "&ORGID=" + orgid + "&COMPANYID=" + companyid);

                                    }
                                },
                                error: ajaxError
                            });

                        }
                    }
                }
            } else {
                Ext.Msg.alert('취소 알림', '삭제 처리가 취소되었습니다.');
                return;
            }
        });
    } else {
        // 미선택시 하나만 삭제
        Ext.MessageBox.confirm('삭제 알림', '삭제 하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                poseq = record.data.POSEQ;

                if (pono == "") {
                    store.remove(model);
                } else {

                    var sparams = {
                        ORGID: orgid,
                        COMPANYID: companyid,
                        PONO: pono,
                        POSEQ: poseq,
                    };

                    $.ajax({
                        url: url,
                        type: "post",
                        dataType: "json",
                        data: sparams,
                        success: function (data) {
                            var msg = data.msg;
                            extAlert(msg);

                            var returnstatus = data.success;
                            if (returnstatus) {
                                go_url("<c:url value='/purchase/order/PurchaseOrderManage.do?PONO=' />" + pono + "&ORGID=" + orgid + "&COMPANYID=" + companyid);
                            }
                        },
                        error: ajaxError
                    });
                }

            } else {
                Ext.Msg.alert('취소 알림', '삭제 처리가 취소되었습니다.');
                return;
            }
        });
    }
}

var global_popup_flag = false;
function btnSel1(btn) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var PoDate = $('#PoDate').val();
    var CustomerCode = $('#CustomerCode').val();
    var PoPerson = $('#PoPerson').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (PoDate === "") {
        header.push("발주일");
        count++;
    }
    //    if (CustomerCode === "") {
    //      header.push("공급사");
    //      count++;
    //    }
    //    if (PoPerson === "") {
    //      header.push("발주담당자");
    //      count++;
    //    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    var Status = $('#PoStatus').val();
    if (Status === "COMPLETE") {
        extAlert("발주 완료상태에서 자재 불러오기가 불가능 합니다.");
        return false;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    // 자재불러오기 팝업
    var width = 1209; // 가로
    var height = 640; // 세로
    var title = "자재불러오기 Popup";

    var check = true;

    global_popup_flag = false;
    if (check == true) {
        // 완료 외 상태에서만 팝업 표시하도록 처리
        $('#popupOrgId').val($('#searchOrgId option:selected').val());
        $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
        $('#popupBigCode').val("");
        $('#popupBigName').val("");
        $('#popupMiddleCode').val("");
        $('#popupMiddleName').val("");
        $('#popupSmallCode').val("");
        $('#popupSmallName').val("");
        $('#popupItemCode').val("");
        $('#popupItemName').val("");
        $('#popupOrderName').val("");
        $('#popupItemStandard').val("");
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
                '품명', {
                    xtype: 'textfield',
                    name: 'searchItemName',
                    clearOnReset: true,
                    hideLabel: true,
                    width: 200,
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
                '품번', {
                    xtype: 'textfield',
                    name: 'searchOrderName',
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

                            $('#popupOrderName').val(result);
                        },
                    },
                },
                '규격', {
                    xtype: 'textfield',
                    name: 'searchItemStandard',
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

                            $('#popupItemStandard').val(result);
                        },
                    },
                },
                '거래처', {
                    xtype: 'textfield',
                    name: 'searchCustomerName',
                    clearOnReset: true,
                    hideLabel: true,
                    width: 160,
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
                '유형', {
                    xtype: 'combo',
                    name: 'searchItemType',
                    clearOnReset: true,
                    hideLabel: true,
                    width: 110,
                    store: gridnms["store.8"],
                    valueField: "LABEL",
                    displayField: "LABEL",
                    matchFieldWidth: true,
                    editable: false,
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
                            $('#popupItemType').val(record.data.VALUE);
                            $('#popupItemTypeName').val(record.data.LABEL);

                            var sparams3 = {
                                ORGID: $('#popupOrgId').val(),
                                COMPANYID: $('#popupCompanyId').val(),
                                BIGCD: "CMM",
                                MIDDLECD: "ITEM_TYPE",
                            };
                            extGridSearch(sparams3, gridnms["store.8"]);
                        },
                        change: function (field, ov, nv, eOpts) {
                            var result = field.getValue();

                            if (ov != nv) {
                                if (!isNaN(result)) {
                                    //                      $('#popupItemType').val("M");
                                    //                      $('#popupItemTypeName').val("양산원재료");
                                }
                            }
                        },
                    },
                }, '->', {
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

                        global_popup_flag = !global_popup_flag;
                        for (var i = 0; i < count4; i++) {
                            Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
                            var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];

                            var chk = model4.data.CHK;

                            if (global_popup_flag) {
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
                            extAlert("자재를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (count4 == 0) {
                            console.log("[적용] 자재 정보가 없습니다.");
                        } else {
                            for (var j = 0; j < count4; j++) {
                                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
                                var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                                var chk = model4.data.CHK;

                                if (chk) {
                                    var model = Ext.create(gridnms["model.1"]);
                                    var store = Ext.getStore(gridnms["store.1"]);

                                    // 순번
                                    model.set("POSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("ITEMCODE", model4.data.ITEMCODE);
                                    model.set("ITEMNAME", model4.data.ITEMNAME);
                                    model.set("ORDERNAME", model4.data.ORDERNAME);
                                    model.set("UOM", model4.data.UOM);
                                    model.set("UOMNAME", model4.data.UOMNAME);
                                    model.set("UNITPRICE", model4.data.SALESPRICE);

                                    model.set("MODEL", model4.data.MODEL);
                                    model.set("MODELNAME", model4.data.MODELNAME);

                                    model.set("ITEMSTANDARD", model4.data.ITEMSTANDARD);
                                    model.set("MATERIALTYPE", model4.data.MATERIALTYPE);
                                    model.set("ORDERINSPECTIONYN", model4.data.ORDERINSPECTIONYN);
                                    model.set("SCMINSPECTIONYN", model4.data.SCMINSPECTIONYN);

                                    model.set("ORDERQTY", 0);

                                    model.set("DUEDATE", "${searchVO.TODAY}");
                                    model.set("ORDERFINISHYN", "N");

                                    $('#CustomerName').val(model4.data.CUSTOMERNAME);
                                    $('#CustomerCode').val(model4.data.CUSTOMERCODE);

                                    // 그리드 적용 방식
                                    store.add(model);

                                    checktemp++;
                                };
                            }

                            Ext.getCmp(gridnms["panel.1"]).getView().refresh();

                        }

                        if (checktemp > 0) {
                            win1.close();

                            $("#gridPopup1Area").hide("blind", {
                                direction: "up"
                            }, "fast");
                        }
                    }
                }
            ]
        });

        win1.show();

        var sparams1 = {
            ORGID: $('#popupOrgId').val(),
            COMPANYID: $('#popupCompanyId').val(),
            BIGCD: "CMM",
            MIDDLECD: "ITEM_TYPE",
            USEDIVTYPE: "ETC",
            USEDIV1: "A",
            USEDIV2: "B",
        };
        extGridSearch(sparams1, gridnms["store.8"]);

        $('input[name=searchItemName]').bind("keyup", function (e) {
            if (e.keyCode == 13) {
                fn_popup_search();
            }
        });

        $('input[name=searchOrderName]').bind("keyup", function (e) {
            if (e.keyCode == 13) {
                fn_popup_search();
            }
        });

        $('input[name=searchItemStandard]').bind("keyup", function (e) {
            if (e.keyCode == 13) {
                fn_popup_search();
            }
        });

        $('input[name=searchCustomerName]').bind("keyup", function (e) {
            if (e.keyCode == 13) {
                fn_popup_search();
            }
        });

        $('input[name=searchItemType]').bind("keyup", function (e) {
            if (e.keyCode == 13) {
                fn_popup_search();
            }
        });

    } else {
        extAlert("구매 발주하실 때만 자재불러오기가 가능합니다.");
        return;
    }
}

function fn_popup_search() {
    global_popup_flag = false;
    var sparams = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        ITEMNAME: $('#popupItemName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        ITEMTYPE: $('#popupItemType').val(),
        CUSTOMERNAME: $('#popupCustomerName').val(),
        ITEMSTANDARD: $('#popupItemStandard').val(),
        MATGROUPCODE: 'Y',
    };
    extGridSearch(sparams, gridnms["store.4"]);
}

var global_popup_flag2 = false;
function btnSel2(btn) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var PoDate = $('#PoDate').val();
    var CustomerCode = $('#CustomerCode').val();
    var PoPerson = $('#PoPerson').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (PoDate === "") {
        header.push("발주일");
        count++;
    }
    //    if (CustomerCode === "") {
    //      header.push("공급사");
    //      count++;
    //    }
    //    if (PoPerson === "") {
    //      header.push("발주담당자");
    //      count++;
    //    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    var status = $('#PoStatus').val();
    if (status === "COMPLETE") {
        extAlert("발주 완료상태에서 요청서 불러오기가 불가능 합니다.");
        return false;
    }

    // 요청서 불러오기 팝업
    var width = 1208; // 가로
    var height = 640; // 500; // 세로
    var title = "요청서불러오기 Popup";

    var check = false;

    if (status === "") {
        // 제품선택 팝업표시 여부
        check = true;
    } else if (status == "STAND_BY") {
        // 제품선택 팝업표시 여부
        check = true;
    } else if (status == "COMPLETE") {
        // 완료시 팝업표시 여부
        check = false;
    } else {
        check = true;
    }

    global_popup_flag2 = false;
    if (check) {
        // 완료 외 상태에서만 팝업 표시하도록 처리
        $('#popupOrgId').val($('#searchOrgId option:selected').val());
        $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
        $('#popupBigCode').val("");
        $('#popupBigName').val("");
        $('#popupMiddleCode').val("");
        $('#popupMiddleName').val("");
        $('#popupSmallCode').val("");
        $('#popupSmallName').val("");
        $('#popupItemCode').val("");
        $('#popupItemName').val("");
        $('#popupOrderName').val("");
        $('#popupItemStandard').val("");
        Ext.getStore(gridnms['store.44']).removeAll();

        win11 = Ext.create('Ext.window.Window', {
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
                    itemId: gridnms["panel.44"],
                    id: gridnms["panel.44"],
                    store: gridnms["store.44"],
                    height: '100%',
                    border: 2,
                    scrollable: true,
                    frameHeader: true,
                    columns: fields["columns.44"],
                    viewConfig: {
                        itemId: 'btnPopup11'
                    },
                    plugins: 'bufferedrenderer',
                    dockedItems: items["docked.44"],
                }
            ],
            tbar: [
                '기간', {
                    xtype: 'datefield',
                    enforceMaxLength: true,
                    maxLength: 10,
                    allowBlank: true,
                    format: 'Y-m-d',
                    altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
                    align: 'center',
                    width: 100,
                    listeners: {
                        scope: this,
                        buffer: 50,
                        select: function (value, record) {
                            $('#popupDueFrom').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
                        },
                        change: function (value, nv, ov, e) {
                            var result = value.getValue();

                            if (nv !== ov) {
                                if (result === "") {
                                    $('#popupDueFrom').val("");
                                } else {
                                    var popupDueFrom = Ext.Date.format(result, 'Y-m-d');
                                    var popupDueTo = $('#popupDueTo').val();

                                    if (popupDueTo === "") {
                                        $('#popupDueFrom').val(Ext.Date.format(result, 'Y-m-d'));
                                    } else {
                                        var diff = 0;
                                        diff = fn_calc_diff(popupDueFrom, popupDueTo);
                                        if (diff < 0) {
                                            extAlert("이전 날짜가 이후 날짜보다 큽니다.<br/>다시 한번 확인해주십시오.");
                                            value.setValue("");
                                            $('#popupDueFrom').val("");
                                            return;
                                        } else {
                                            $('#popupDueFrom').val(Ext.Date.format(result, 'Y-m-d'));
                                        }
                                    }
                                }
                            }
                        },
                    },
                    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
                }, ' ~ ', {
                    xtype: 'datefield',
                    enforceMaxLength: true,
                    maxLength: 10,
                    allowBlank: true,
                    format: 'Y-m-d',
                    altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
                    width: 100,
                    align: 'center',
                    listeners: {
                        scope: this,
                        buffer: 50,
                        select: function (value, record) {
                            $('#popupDueTo').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
                        },
                        change: function (value, nv, ov, e) {
                            var result = value.getValue();

                            if (nv !== ov) {
                                if (result === "") {
                                    $('#popupDueTo').val("");
                                } else {
                                    var popupDueFrom = $('#popupDueFrom').val();
                                    var popupDueTo = Ext.Date.format(result, 'Y-m-d');

                                    if (popupDueFrom === "") {
                                        $('#popupDueTo').val(Ext.Date.format(result, 'Y-m-d'));
                                    } else {
                                        var diff = 0;
                                        diff = fn_calc_diff(popupDueFrom, popupDueTo);
                                        if (diff < 0) {
                                            extAlert("이후 날짜가 이전 날짜보다 작습니다.<br/>다시 한번 확인해주십시오.");
                                            value.setValue("");
                                            $('#popupDueTo').val("");
                                            return;
                                        } else {
                                            $('#popupDueTo').val(Ext.Date.format(result, 'Y-m-d'));
                                        }
                                    }
                                }
                            }
                        },
                    },
                    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
                },
                '품번', {
                    xtype: 'textfield',
                    name: 'searchOrderName1',
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

                            $('#popupOrderName').val(result);
                        },
                    },
                },
                '품명', {
                    xtype: 'textfield',
                    name: 'searchItemName1',
                    clearOnReset: true,
                    hideLabel: true,
                    width: 200,
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
                '규격', {
                    xtype: 'textfield',
                    name: 'searchItemStandard1',
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

                            $('#popupItemStandard').val(result);
                        },
                    },
                },
                '->', {
                    text: '조회',
                    scope: this,
                    handler: function () {
                        fn_popup_search1();
                    }
                }, {
                    text: '전체선택/해제',
                    scope: this,
                    handler: function () {
                        // 전체등록 Pop up 전체선택 버튼 핸들러
                        var count44 = Ext.getStore(gridnms["store.44"]).count();
                        var checkTrue = 0,
                        checkFalse = 0;

                        global_popup_flag2 = !global_popup_flag2;
                        for (var i = 0; i < count44; i++) {
                            Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(i));
                            var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];

                            var chk = model44.data.CHK;

                            if (global_popup_flag2) {
                                // 체크 상태로
                                model44.set("CHK", true);
                                checkFalse++;
                            } else {
                                model44.set("CHK", false);
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
                        var count44 = Ext.getStore(gridnms["store.44"]).count();
                        var checknum = 0,
                        checkqty = 0,
                        checktemp = 0;
                        var qtytemp = [];

                        for (var i = 0; i < count44; i++) {
                            Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(i));
                            var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];
                            var chk = model44.data.CHK;

                            if (chk) {
                                checknum++;
                            }
                        }
                        console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                        if (checknum == 0) {
                            extAlert("요청서정보를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (count44 == 0) {
                            console.log("[적용] 요청서 정보가 없습니다.");
                        } else {
                            for (var j = 0; j < count44; j++) {
                                Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(j));
                                var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];
                                var chk = model44.data.CHK;
                                if (chk) {
                                    var model = Ext.create(gridnms["model.1"]);
                                    var store = Ext.getStore(gridnms["store.1"]);

                                    $('#OrderDiv').val('C');
                                    // 순번
                                    model.set("POSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("ITEMCODE", model44.data.ITEMCODE);
                                    model.set("ITEMNAME", model44.data.ITEMNAME);
                                    model.set("ORDERNAME", model44.data.ORDERNAME);
                                    model.set("UOM", model44.data.UOM);
                                    model.set("UOMNAME", model44.data.UOMNAME);

                                    model.set("MODEL", model44.data.MODEL);
                                    model.set("MODELNAME", model44.data.MODELNAME);
                                    model.set("CUSTOMERGUBUN", model44.data.CUSTOMERGUBUN);
                                    model.set("CUSTOMERGUBUNNAME", model44.data.CUSTOMERGUBUNNAME);

                                    $("#CustomerName").val(model44.data.CUSTOMERNAME)
                                    $("#CustomerCode").val(model44.data.CUSTOMERCODE)

                                    model.set("PORNO", model44.data.PORNO);
                                    model.set("PORSEQ", model44.data.PORSEQ);
                                    model.set("UNITPRICE", model44.data.UNITPRICE);
                                    model.set("ORDERQTY", model44.data.POQTY);

                                    model.set("ITEMSTANDARD", model44.data.ITEMSTANDARD);
                                    model.set("MATERIALTYPE", model44.data.MATERIALTYPE);
                                    model.set("ORDERINSPECTIONYN", model44.data.ORDERINSPECTIONYN);
                                    model.set("SCMINSPECTIONYN", model44.data.SCMINSPECTIONYN);
                                    //                         model.set("OLDQTY", model44.data.OLDQTY);

                                    //                         var qty = model4.data.QTYDETAIL * 1;
                                    //                         if (qty > 0) {
                                    //                           model.set("ORDERQTY", qty);
                                    //                         } else {
                                    //                           model.set("ORDERQTY", 0);
                                    //                         }


                                    var qty = model44.data.POQTY * 1;
                                    var unitcost = model44.data.UNITPRICE;

                                    var supplyprice = 0;
                                    var addtax = 0,
                                    taddtax = 0;

                                    supplyprice = (qty * unitcost) * 1.0;
                                    model.set("SUPPLYPRICE", supplyprice);
                                    //                             store.set("SUPPLYPRICE", supplyprice );

                                    addtax = Math.round((qty * unitcost) * 0.1);
                                    model.set("ADDITIONALTAX", addtax);
                                    //                             store.set("ADDITIONALTAX", addtax);

                                    var total = (supplyprice * 1) + (addtax * 1);
                                    model.set("TOTAL", total);
                                    //                         store.set("TOTAL", total );


                                    model.set("DUEDATE", "${searchVO.TODAY}");
                                    model.set("ORDERFINISHYN", "N");

                                    // 그리드 적용 방식
                                    store.add(model);

                                    checktemp++;
                                };
                            }

                            Ext.getCmp(gridnms["panel.1"]).getView().refresh();

                        }

                        if (checktemp > 0) {
                            win11.close();

                            $("#gridPopup11Area").hide("blind", {
                                direction: "up"
                            }, "fast");
                        }
                    }
                }
            ]
        });

        win11.show();

        $('input[name=searchItemName1]').bind("keyup", function (e) {
            if (e.keyCode == 13) {
                fn_popup_search1();
            }
        });

        $('input[name=searchOrderName1]').bind("keyup", function (e) {
            if (e.keyCode == 13) {
                fn_popup_search1();
            }
        });

        $('input[name=searchItemStandard1]').bind("keyup", function (e) {
            if (e.keyCode == 13) {
                fn_popup_search1();
            }
        });

    } else {
        extAlert("발주 등록 하실 경우에만 요청서 불러오기가 가능합니다.");
        return;
    }
}

function fn_popup_search1() {
    global_popup_flag2 = false;
    var sparams = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        REQFROM: $('#popupDueFrom').val(),
        REQTO: $('#popupDueTo').val(),
        ITEMCODE: $('#popupItemCode').val(),
        ITEMNAME: $('#popupItemName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        MODELNAME: $('#popupModelName').val(),
        ITEMSTANDARD: $('#popupItemStandard').val(),
        ITEMTYPE: $('#popupItemType').val(),
    };
    extGridSearch(sparams, gridnms["store.44"]);
}

var gridarea;
function setExtGrid() {
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
                                PONO: $('#PoNo').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            btnDetailList: '#btnDetailList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        btnChk1Click: btnChk1Click,
        btnDel1: btnDel1,
        btnSel1: btnSel1,
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
                height: 564,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                viewConfig: {
                    itemId: 'btnDetailList',
                    trackOver: true,
                    loadMask: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ITEMSTANDARD') >= 0) {
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
                bufferedRenderer: false,
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = [];
                                editDisableCols.push("POSEQ");
                                var status = $('#PoStatus').val();
                                if (status == "COMPLETE" || status == "CANCEL") {
                                    // 완료시 입력 불가
                                    editDisableCols.push("ORDERQTY");
                                    editDisableCols.push("UNITPRICE");
                                    editDisableCols.push("DUEDATE");
                                    editDisableCols.push("ORDERINSPECTIONYN");
                                    editDisableCols.push("SCMINSPECTIONYN");
                                    editDisableCols.push("REMARKS");
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
                dockedItems: items["docked.1"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.detail"],
        stores: gridnms["stores.detail"],
        views: gridnms["views.detail"],
        controllers: gridnms["controller.1"],

        launch: function () {
            gridarea = Ext.create(gridnms["views.detail"], {
                renderTo: 'gridPurchaseDetailArea'
            });
        },
    });

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
    });
}

// 자재불러오기 팝업
function setValues_Popup() {
    gridnms["models.popup1"] = [];
    gridnms["stores.popup1"] = [];
    gridnms["views.popup1"] = [];
    gridnms["controllers.popup1"] = [];

    gridnms["grid.4"] = "Popup1";
    gridnms["grid.5"] = "SetBigCodeLov"; // 팝업 조회 대분류
    gridnms["grid.6"] = "SetMiddleCodeLov"; // 팝업 조회 중분류
    gridnms["grid.7"] = "SetSmallCodeLov"; // 팝업 조회 소분류
    gridnms["grid.8"] = "SetItemTypeLov"; // 팝업 조회 유형

    gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
    gridnms["views.popup1"].push(gridnms["panel.4"]);

    gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
    gridnms["controllers.popup1"].push(gridnms["controller.4"]);

    gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
    gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
    gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
    gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];
    gridnms["model.8"] = gridnms["app"] + ".model." + gridnms["grid.8"];

    gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
    gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
    gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
    gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];
    gridnms["store.8"] = gridnms["app"] + ".store." + gridnms["grid.8"];

    gridnms["models.popup1"].push(gridnms["model.4"]);
    gridnms["models.popup1"].push(gridnms["model.5"]);
    gridnms["models.popup1"].push(gridnms["model.6"]);
    gridnms["models.popup1"].push(gridnms["model.7"]);
    gridnms["models.popup1"].push(gridnms["model.8"]);

    gridnms["stores.popup1"].push(gridnms["store.4"]);
    gridnms["stores.popup1"].push(gridnms["store.5"]);
    gridnms["stores.popup1"].push(gridnms["store.6"]);
    gridnms["stores.popup1"].push(gridnms["store.7"]);
    gridnms["stores.popup1"].push(gridnms["store.8"]);

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
            name: 'ORDERNAME',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'ITEMNAME',
        }, {
            type: 'string',
            name: 'ITEMTYPE',
        }, {
            type: 'string',
            name: 'ITEMTYPE',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'MODEL',
        }, {
            type: 'string',
            name: 'MODELNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARD',
        }, {
            type: 'string',
            name: 'MATERIALTYPE',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'number',
            name: 'SALESPRICE',
        }, {
            type: 'string',
            name: 'ORDERINSPECTIONYN',
        }, {
            type: 'string',
            name: 'SCMINSPECTIONYN',
        }, ];

    fields["model.5"] = [{
            type: 'string',
            name: 'ID',
        }, {
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.6"] = [{
            type: 'string',
            name: 'ID',
        }, {
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.7"] = [{
            type: 'string',
            name: 'ID',
        }, {
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.8"] = [{
            type: 'string',
            name: 'ID',
        }, {
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.4"] = [{
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
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 295,
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
            dataIndex: 'ITEMSTANDARD',
            text: '규격',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
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
        }, {
            dataIndex: 'CUSTOMERNAME',
            text: '거래처',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'ITEMTYPENAME',
            text: '유형',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
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
        }, {
            dataIndex: 'SALESPRICE',
            text: '단가',
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
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ORDERINSPECTIONYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SCMINSPECTIONYN',
            xtype: 'hidden',
        }, ];

    items["api.4"] = {};
    $.extend(items["api.4"], {
        read: "<c:url value='/searchItemCodeOrderLov.do' />"
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

// 요청서 불러오기 팝업
function setValues_Popup1() {
    gridnms["models.popup11"] = [];
    gridnms["stores.popup11"] = [];
    gridnms["views.popup11"] = [];
    gridnms["controllers.popup11"] = [];

    gridnms["grid.44"] = "Popup11";

    gridnms["panel.44"] = gridnms["app"] + ".view." + gridnms["grid.44"];
    gridnms["views.popup11"].push(gridnms["panel.44"]);

    gridnms["controller.44"] = gridnms["app"] + ".controller." + gridnms["grid.44"];
    gridnms["controllers.popup11"].push(gridnms["controller.44"]);

    gridnms["model.44"] = gridnms["app"] + ".model." + gridnms["grid.44"];

    gridnms["store.44"] = gridnms["app"] + ".store." + gridnms["grid.44"];

    gridnms["models.popup11"].push(gridnms["model.44"]);

    gridnms["stores.popup11"].push(gridnms["store.44"]);

    fields["model.44"] = [{
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
            name: 'ORDERNAME',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'ITEMNAME',
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
            name: 'MATERIALTYPE',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'PORNO',
        }, {
            type: 'string',
            name: 'PORSEQ',
        }, {
            type: 'number',
            name: 'REQUESTQTY',
        }, {
            type: 'number',
            name: 'OLDQTY',
        }, {
            type: 'number',
            name: 'UNITPRICE',
        }, {
            type: 'number',
            name: 'POQTY',
        }, {
            type: 'string',
            name: 'ORDERINSPECTIONYN',
        }, {
            type: 'string',
            name: 'SCMINSPECTIONYN',
        },

    ];

    fields["columns.44"] = [{
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
        }, {
            dataIndex: 'PORNO',
            text: '요청번호',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'PORSEQ',
            text: '요청<br/>순번',
            xtype: 'gridcolumn',
            width: 55,
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
            width: 210,
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
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'ITEMSTANDARD',
            text: '규격',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'MATERIALTYPE',
            text: '재질',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
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
        }, {
            dataIndex: 'ITEMTYPENAME',
            text: '유형',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'UNITPRICE',
            text: '단가',
            xtype: 'gridcolumn',
            width: 65,
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
            dataIndex: 'REQUESTQTY',
            text: '요청<br/>수량',
            xtype: 'gridcolumn',
            width: 70,
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
            dataIndex: 'OLDQTY',
            text: '기발주<br/>수량',
            xtype: 'gridcolumn',
            width: 70,
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
            dataIndex: 'POQTY',
            text: '발주가능<br/>수량',
            xtype: 'gridcolumn',
            width: 85,
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
            dataIndex: 'CHK',
            text: '',
            xtype: 'checkcolumn',
            width: 50,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            name: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            name: 'CUSTOMERNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ORDERINSPECTIONYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SCMINSPECTIONYN',
            xtype: 'hidden',
        }, ];

    items["api.44"] = {};
    $.extend(items["api.44"], {
        read: "<c:url value='/PurchaseOrderPop1.do' />"
    });

    items["btns.44"] = [];

    items["btns.ctr.44"] = {};

    items["dock.paging.44"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.44"],
    };

    items["dock.btn.44"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.44"],
        items: items["btns.44"],
    };

    items["docked.44"] = [];
}

var gridpopup1, gridpopup11;
function setExtGrid_Popup() {
    Ext.define(gridnms["model.4"], {
        extend: Ext.data.Model,
        fields: fields["model.4"],
    });

    Ext.define(gridnms["model.5"], {
        extend: Ext.data.Model,
        fields: fields["model.5"],
    });

    Ext.define(gridnms["model.6"], {
        extend: Ext.data.Model,
        fields: fields["model.6"],
    });

    Ext.define(gridnms["model.7"], {
        extend: Ext.data.Model,
        fields: fields["model.7"],
    });

    Ext.define(gridnms["model.8"], {
        extend: Ext.data.Model,
        fields: fields["model.8"],
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
                                MATGROUPCODE: 'M',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.5"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.5"],
                        model: gridnms["model.5"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchBigClassListLov.do' />",
                            extraParams: {
                                GROUPCODE: $('#popupGroupCode').val(),
                                GUBUN: 'BIG_CODE',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.6"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.6"],
                        model: gridnms["model.6"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchMiddleClassListLov.do' />",
                            extraParams: {
                                GROUPCODE: $('#popupGroupCode').val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.7"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.7"],
                        model: gridnms["model.7"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallClassListLov.do' />",
                            extraParams: {
                                GROUPCODE: $('#popupGroupCode').val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.8"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.8"],
                        model: gridnms["model.8"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#popupOrgId').val(),
                                COMPANYID: $('#popupCompanyId').val(),
                                BIGCD: "CMM",
                                MIDDLECD: "ITEM_TYPE"
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
    Ext.define(gridnms["model.44"], {
        extend: Ext.data.Model,
        fields: fields["model.44"],
    });

    Ext.define(gridnms["store.44"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.44"],
                        model: gridnms["model.44"],
                        autoLoad: true,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.44"],
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

    Ext.define(gridnms["controller.44"], {
        extend: Ext.app.Controller,
        refs: {
            btnPopup11: '#btnPopup11',
        },
        stores: [gridnms["store.44"]],
    });

    Ext.define(gridnms["panel.44"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.44"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.44"],
                id: gridnms["panel.44"],
                store: gridnms["store.44"],
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
                columns: fields["columns.44"],
                viewConfig: {
                    itemId: 'btnPopup11',
                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.44"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup11"],
        stores: gridnms["stores.popup11"],
        views: gridnms["views.popup11"],
        controllers: gridnms["controller.44"],

        launch: function () {
            gridpopup11 = Ext.create(gridnms["views.popup11"], {
                renderTo: 'gridPopup11Area'
            });
        },
    });
}

function fn_save() {
    // 필수 체크
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var PoDate = $('#PoDate').val();
    var CustomerCode = $('#CustomerCode').val();
    var PoPerson = $('#PoPerson').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (PoDate === "") {
        header.push("발주일");
        count++;
    }
    if (CustomerCode === "") {
        header.push("공급사");
        count++;
    }
    if (PoPerson === "") {
        header.push("발주담당자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    var Status = $('#PoStatus').val();
    if (Status === "COMPLETE") {
        extAlert("발주 완료 상태에서는 저장이 불가능 합니다.");
        return false;
    }

    // 저장
    var pono = $('#PoNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = pono.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;
    var statusconfirm = $('#PoStatus').val();
    var statustype = $('#StatusType').val() + "";

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 자재 요청 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/purchase/order/PurchaseOrderMaster.do' />";
        url1 = "<c:url value='/insert/purchase/order/PurchaseOrderDetail.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/purchase/order/PurchaseOrderMaster.do' />";
        url1 = "<c:url value='/update/purchase/order/PurchaseOrderDetail.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('자재발주 알림', '저장 하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: $("#master").serialize(),
                    success: function (data) {
                        var orgid = data.searchOrgId;
                        var companyid = data.searchCompanyId;
                        var pono = data.PoNo;

                        if (pono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();

                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("PONO", pono);

                                if (model.data.PONO != '') {
                                    params.push(model.data);
                                }
                            }
                            dataSuccess = 1;

                            if (params.length > 0) {
                                Ext.Ajax.request({
                                    url: url1,
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    jsonData: {
                                        data: params
                                    },
                                    success: function (conn, response, options, eOpts) {
                                        if (msgGubun == 1) {
                                            msg = "정상적으로 저장 하였습니다.";
                                        } else if (msgGubun == 2) {
                                            msg = "요청한 발주 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/purchase/order/PurchaseOrderManage.do?PONO=' />" + pono + "&org=" + orgid + "&company=" + companyid);
                                        }
                                    },
                                    error: ajaxError
                                });
                            }
                        }
                    },
                    error: ajaxError
                });
            } else {
                Ext.Msg.alert('구매발주', '구매발주가 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('구매발주 변경 알림', '구매발주를 변경하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: $("#master").serialize(),
                    success: function (data) {
                        var orgid = data.searchOrgId;
                        var companyid = data.searchCompanyId;
                        var pono = data.PoNo;

                        if (pono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("PONO", pono);
                                if (model.data.PONO != '') {
                                    params.push(model.data);

                                }
                            }
                            dataSuccess = 1;

                            if (params.length > 0) {
                                Ext.Ajax.request({
                                    url: url1,
                                    method: 'POST',
                                    headers: {
                                        'Content-Type': 'application/json'
                                    },
                                    jsonData: {
                                        data: params
                                    },
                                    success: function (conn, response, options, eOpts) {
                                        if (msgGubun == 1) {
                                            msg = "정상적으로 저장 하였습니다.";
                                        } else if (msgGubun == 2) {
                                            msg = "요청한 자재 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/purchase/order/PurchaseOrderManage.do?PONO=' />" + pono + "&org=" + orgid + "&company=" + companyid);
                                        }
                                    },
                                    error: ajaxError
                                });
                            }
                        }
                    },
                    error: ajaxError
                });
            } else {
                Ext.Msg.alert('자재발주 변경', '변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_price_default(code, price) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var url = "<c:url value='/pkg/purchase/order/PurchaseOrderPriceDefault.do' />";
    var itemcode = code;
    var unitprice = price;

    if (unitprice == 0) {
        extAlert("단가를 먼저 입력해주십시오.");
        return;
    }

    Ext.MessageBox.confirm('단가적용 알림', '단가를 적용 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = {
                ORGID: orgid,
                COMPANYID: companyid,
                ITEMCODE: itemcode,
                PRICE: unitprice,
            };

            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: params,
                success: function (data) {
                    var status = data.STATUS;
                    if (status != "S") {
                        var msg = data.MSGDATA;
                        extAlert(msg);
                    } else {
                        extAlert("적용이 완료되었습니다.");
                    }
                },
                error: ajaxError
            });
        }
    });
}

function fn_search() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var PoNo = $('#PoNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        PONO: PoNo,
    };

    var url = "<c:url value='/searchPonoListLov.do' />";

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            //        var pono = dataList.PONO;
            var podate = dataList.PODATE;
            var postatus = dataList.POSTATUS;
            var postatusname = dataList.POSTATUSNAME;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var customerperson = dataList.CUSTOMERPERSON;
            var customerpersonname = dataList.CUSTOMERPERSONNAME;
            var poperson = dataList.POPERSON;
            var popersonname = dataList.POPERSONNAME;
            var usediv = dataList.USEDIV;
            var taxdiv = dataList.TAXDIV;
            var deliverylocation = dataList.DELIVERYLOCATION;
            var remarks = dataList.REMARKS;

            //        $("#PoNo").val(pono);
            $("#PoDate").val(podate);
            $("#PoStatus").val(postatus);
            $("#PoStatusName").val(postatusname);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#CustomerPerson").val(customerperson);
            $("#CustomerPersonName").val(customerpersonname);
            $("#PoPerson").val(poperson);
            $("#PoPersonName").val(popersonname);
            $("#OrderDiv").val(usediv);
            $('#TaxDiv').val(taxdiv);
            $('#DeliveryLocation').val(deliverylocation);
            $('#Remarks').val(remarks);

            global_close_yn = fn_monthly_close_filter_data(podate, 'MAT');
        },
        error: ajaxError
    });

}

function fn_delete() {
    // 삭제
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var pono = $('#PoNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var url = "";
    var statusconfirm = $('#PoStatus').val();
    var statustype = $('#StatusType').val() + "";

    if (pono == "") {
        extAlert("[삭제 불가]<br/>발주 정보가 등록되지 않아 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    var Status = $('#PoStatus').val();
    if (Status === "COMPLETE") {
        extAlert("[삭제 불가]<br/>발주 완료 상태에서는 삭제가 불가능 합니다.");
        return false;
    }

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (!gridcount == 0) {
        extAlert("[상세 데이터 ]<br/> 구매 발주 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return false;
    }

    url = "<c:url value='/delete/purchase/order/PurchaseOrderRegist.do' />";

    Ext.MessageBox.confirm('구매발주 삭제 알림', '구매발주서 데이터를 삭제하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: $("#master").serialize(),
                success: function (data) {
                    extAlert(data.msg);
                    //   정상적으로 생성이 되었으면
                    var result = data.success;
                    var msg = data.msg;
                    extAlert(msg);
                    if (result) {
                        // 삭제 성공
                        fn_list();
                    } else {
                        // 실패 했을 경우
                        return;
                    }

                },
                error: ajaxError
            });
        } else {
            Ext.Msg.alert('구매요청 삭제', '구매요청 삭제가 취소되었습니다.');
            return;
        }
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var PoNo = $('#PoNo').val();

    var header = [],
    count = 0;
    var dataSuccess = 0;

    if (orgid === "") {
        header.push("사업장");
        count++;
    }
    if (companyid === "") {
        header.push("공장");
        count++;
    }
    if (PoNo === "") {
        header.push("발주번호");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        result = false;
        return result;
    }

    return result;
}

function fn_print() {
    if (!fn_validation())
        return;

    var column = 'master';
    var url = null;
    var target = '_blank';

    url = "<c:url value='/report/OrderReport.pdf'/>";

    fn_popup_url(column, url, target);
}

function fn_status_change(flag) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var CustomerCode = $('#CustomerCode').val();
    var PoNo = $('#PoNo').val();
    var PoDate = $('#PoDate').val();
    var PoStatus = $('#PoStatus').val();
    var PoPerson = $('#PoPerson').val();
    var PoStatus = $('#PoStatus').val();
    var header = [],
    count = 0;
    if (PoDate === "") {
        header.push("발주일");
        count++;
    }
    if (CustomerCode === "") {
        header.push("공급사");
        count++;
    }
    if (PoPerson === "") {
        header.push("발주담당자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return;
    }
    if (PoNo == "") {
        extAlert("[미등록]<br/>구매발주 등록이 되어있지 않아 상태변경이 불가능 합니다.<br/>다시 한번 확인해주세요.");
        return;
    }
    var title_name;

    if (flag == "COMPLETE") {
        title_name = "완료";
        if (PoStatus == "COMPLETE") {
            extAlert("[확인]<br/>이미 완료처리되어 상태 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        }
    } else if (flag == "CANCEL") {
        title_name = "취소";

        if (PoStatus == "CANCEL") {
            extAlert("[확인]<br/>취소처리되어 상태 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        } else if (PoStatus == "COMPLETE") {
            extAlert("[확인]<br/>이미 완료처리되어 상태 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        }

    } else if (flag == "STAND_BY") {
        title_name = "대기";

        if (PoStatus == "CANCEL") {
            extAlert("[확인]<br/>취소처리되어 상태 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        } else if (PoStatus == "STAND_BY") {
            extAlert("[확인]<br/>대기상태일 때 상태 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        }
    }

    url = "<c:url value='/change/purchase/order/PurchaseOrderStatus.do' />";

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        PONO: PoNo,
        CHANGESTATUS: flag,
    };

    Ext.MessageBox.confirm('상태변경 알림', title_name + ' 상태로 변경 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: sparams,
                success: function (data) {

                    var success = data.success;
                    if (!success) {
                        extAlert("상태 변경이 실패하였습니다.<br/>관리자에게 문의하십시요.");
                        return;
                    } else {
                        msg = title_name + " 상태로 변경 완료하였습니다.";
                        extAlert(msg);
                        fn_search();
                    }
                },
                error: ajaxError
            });

        } else {
            Ext.Msg.alert('상태변경 취소', title_name + ' 상태로 변경 취소되었습니다.');
            return;
        }
    });
}

function fn_list() {
    go_url("<c:url value='/purchase/order/PurchaseOrderRegist.do'/>");
}

function fn_add() {
    go_url("<c:url value='/purchase/order/PurchaseOrderManage.do' />");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
    // 업체명 Lov
    $("#CustomerName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#CustomerName").val("");
            $("#CustomerCode").val("");

            var CustomerPerson = $('#CustomerPerson').val();
            if (CustomerPerson != "") {
                $("#CustomerPerson").val("");
                $("#CustomerPersonName").val("");
            }
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
                USEYN: 'Y',
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.VALUE,
                            label: m.LABEL + ", " + m.CUSTOMERTYPENAME,
                            NAME: m.LABEL,
                            ADDRESS: m.ADDRESS,
                            FREIGHT: m.FREIGHT,
                            PHONENUMBER: m.PHONENUMBER,
                            CUSTOMERPERSON: m.CUSTOMERPERSON,
                            CUSTOMERPERSONNAME: m.CUSTOMERPERSONNAME,
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
            $("#CustomerPerson").val(o.item.CUSTOMERPERSON);
            $("#CustomerPersonName").val(o.item.CUSTOMERPERSONNAME);

            return false;
        }
    });

    // 공급사담당자 Lov
    $("#CustomerPersonName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#CustomerPersonName").val("");
            $("#CustomerPerson").val("");
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
            $.getJSON("<c:url value='/searchCustomerMemberLov.do' />", {
                keyword: extractLast(request.term),
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
                CUSTOMERCODE: $('#CustomerCode').val(),
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.VALUE,
                            label: m.LABEL,
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
            $("#CustomerPerson").val(o.item.value);
            $("#CustomerPersonName").val(o.item.label);

            return false;
        }
    });

    // 발주담당자 Lov
    $("#PoPersonName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#PoPersonName").val("");
            $("#PoPerson").val("");
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
            $.getJSON("<c:url value='/searchWorkerLov.do' />", {
                keyword: extractLast(request.term),
                INSPECTORTYPE: '10', // 관리직 검색
                //          INSPECTORTYPE2: '20', // 생산관리직 추가
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.VALUE,
                            label: m.LABEL,

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
            $("#PoPerson").val(o.item.value);
            $("#PoPersonName").val(o.item.label);

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
                    <input type="hidden" id="popupOrgId" name="popupOrgId" />
                    <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                    <input type="hidden" id="popupDueFrom" />
                    <input type="hidden" id="popupDueTo" />
                    <input type="hidden" id="popupGroupCode" name="popupGroupCode" value="M" />
                    <input type="hidden" id="popupBigCode" name="popupBigCode" />
                    <input type="hidden" id="popupBigName" name="popupBigName" />
                    <input type="hidden" id="popupMiddleCode" name="popupMiddleCode" />
                    <input type="hidden" id="popupMiddleName" name="popupMiddleName" />
                    <input type="hidden" id="popupSmallCode" name="popupSmallCode" />
                    <input type="hidden" id="popupSmallName" name="popupSmallName" />
                    <input type="hidden" id="popupItemCode" name="popupItemCode" />
                    <input type="hidden" id="popupItemName" name="popupItemName" />
                    <input type="hidden" id="popupOrderName" name="popupOrderName" />
                    <input type="hidden" id="popupItemStandard" name="popupItemStandard" />
                    <input type="hidden" id="popupModelName" name="popupModelName" />
                    <input type="hidden" id="popupItemType" name="popupItemType" />
                    <input type="hidden" id="popupItemTypeName" name="popupItemTypeName" />
                    <input type="hidden" id="popupCustomerName" name="popupCustomerName" />
                    <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                                <table class="tbl_type_view" border="0">
                                    <colgroup>
                                        <col width="20%">
                                        <col width="20%">
                                        <col width="60%">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <td>
		                                        <select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 70%;">
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
		                                        <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 70%;">
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
                                        <td colspan="6">
                                            <div class="buttons" style="float: right; margin-top: 3px;">
		                                            <a id="btnChk1" class="btn_popup" href="#" onclick="javascript:btnSel2();"> 요청서불러오기 </a>
		                                            <a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
		                                            <a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete()"> 삭제 </a>
		                                            <a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
		                                            <a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
		                                            <c:choose>
				                                            <c:when test="${gubun=='MODIFY'}">
				                                                    <a id="btnChk6" class="btn_print" href="#" onclick="javascript:fn_print();"> 발주서 </a>
				                                            </c:when>
				                                            <c:otherwise>
				                                            </c:otherwise>
		                                            </c:choose>
                                            </div>
                                        </td>
                                    </tr>
                                </table>
                                <table class="tbl_type_view" border="1">
                                        <colgroup>
                                            <col width="12%">
                                            <col width="22%">
                                            <col width="12%">
                                            <col width="22%">
                                            <col width="12%">
                                            <col width="22%">
                                            <col width="12%">
                                            <col width="22%">
                                        </colgroup>
                                        <tr style="height: 34px;">
                                            <th class="required_text">발주번호</th>
                                            <td>
                                                <input type="text" id="PoNo" name="PoNo" class="input_center" style="width: 97%;" value="${searchVO.PONO}" readonly />
                                            </td>
                                            <th class="required_text">발주일</th>
                                            <td>
                                                <input type="text" id="PoDate" name="PoDate" class="input_validation input_center" style="width: 97%;" maxlength="10" />
                                            </td>

                                            <th class="required_text">발주상태</th>
                                            <td>
		                                            <input type="text" id="PoStatusName" name="PoStatusName" class=" input_center" style="width: 97%;" readonly />
		                                            <input type="hidden" id="PoStatus" name="PoStatus" />
                                            </td>
                                            <td colspan="2">
		                                            <div class="buttons" style="float: center; margin-top: 3px;">
                                                    <a id="btnChk100" class="btn_list" href="#" onclick="javascript:fn_status_change('COMPLETE');"> 완료 처리 </a>
                                                    <a id="btnChk101" class="btn_list" href="#" onclick="javascript:fn_status_change('CANCEL');"> 취소 처리 </a>
		                                            </div>
                                            </td>
                                        </tr>
                                        <tr style="height: 34px;">
                                            <th class="required_text">공급사</th>
                                            <td>
                                                <input type="text" id="CustomerName" name="CustomerName" class="input_validation input_center" style="width: 98%;" />
                                                <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                            </td>
                                            <th class="required_text">공급사담당자</th>
                                            <td>
                                                <input type="text" id="CustomerPersonName" name="CustomerPersonName" class=" input_center" style="width: 97%;" />
                                                <input type="hidden" id="CustomerPerson" name="CustomerPerson" />
                                            </td>
                                            <th class="required_text">발주담당자</th>
                                            <td>
                                                <input type="text" id="PoPersonName" name="PoPersonName" class="input_validation input_center" style="width: 97%;" />
                                                <input type="hidden" id="PoPerson" name="PoPerson" />
                                            </td>
                                            <th class="required_text">발주구분</th>
                                            <td>
		                                            <select id="OrderDiv" name="OrderDiv" class="input_left " style="width: 97%;">
		                                            </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="required_text">세액구분</th>
                                            <td>
		                                            <select id="TaxDiv" name="TaxDiv" class="input_left " style="width: 97%;">
				                                            <c:forEach var="item" items="${labelBox.findByTaxDivGubun}" varStatus="status">
		                                                    <c:choose>
				                                                    <c:when test="${item.VALUE==searchVO.TAXDIV}">
				                                                            <option value="${item.VALUE}" data-val="${item.ATTRIBUTE1}" selected>${item.LABEL}</option>
				                                                    </c:when>
				                                                    <c:otherwise>
				                                                            <option value="${item.VALUE}" data-val="${item.ATTRIBUTE1}">${item.LABEL}</option>
				                                                    </c:otherwise>
		                                                    </c:choose>
				                                            </c:forEach>
		                                            </select>
                                            </td>
                                            <th class="required_text">납품장소</th>
                                            <td>
                                                <select id="DeliveryLocation" name="DeliveryLocation" class="input_left " style="width: 97%;">
                                                </select>
                                            </td>
                                        </tr>
                                        <tr style="height: 34px;">
                                            <th class="required_text">비고</th>
                                            <td colspan="7"><textarea id="Remarks" name="Remarks" class="input_left" style="width: 99%;"></textarea></td>
                                        </tr>
                                </table>
                        </form>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->
                <div id="gridPurchaseDetailArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
            </div>
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 1200px; padding-top: 0px; float: left;"></div>
        <div id="gridPopup11Area" style="width: 1200px; padding-top: 0px; float: left;"></div>

        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>