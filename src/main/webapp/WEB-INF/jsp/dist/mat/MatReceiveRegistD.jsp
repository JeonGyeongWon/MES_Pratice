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

.x-form-field {
	font-size: 10px;
}

.ERPQTY  .x-column-header-text {
	margin-right: 0px;
}

#gridPopup1Area .x-form-field {
	ime-mode: disabled;
	text-transform: uppercase;
}

#gridPopup11Area .x-form-field {
	ime-mode: disabled;
	text-transform: uppercase;
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
    gridnms["app"] = "dist";

    calender($('#TransDate'));

    $('#TransDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    fn_option_change_r('MAT', 'TRANS_DIV', 'TransDiv');
    fn_option_change_r('MAT', 'PAID_YN', 'PaidYn');

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        fn_option_change_r('MAT', 'TRANS_DIV', 'TransDiv');
        fn_option_change_r('MAT', 'PAID_YN', 'PaidYn');
    });

    $('#PaidYn').change(function (event) {
        fn_change_unitprice();
    });

}

function setLastInitial() {

    var Transno = $('#TransNo').val();
    if (Transno != "") {
        fn_search();
    } else {

        $("#TransDate").val(getToDay("${searchVO.TODAY}") + "");
        $("#TradeDate").val(getToDay("${searchVO.TODAY}") + "");

        $('#TransDiv').val("A");
        $('#PaidYn').val("N");
    }
}

function fn_change_unitprice() {

    var count = Ext.getStore(gridnms["store.1"]).count();
    if (count > 0) {
        for (var i = 0; i < count; i++) {
            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
            var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

            var qty = model.data.TRANSQTY;
            var unitprice = 0;
            var unitprice_old = model.data.UNITPRICEOLD;

            var paidyn = $('#PaidYn').val();
            var supplyprice = 0,
            addtax = 0,
            total = 0;
            if (paidyn == "Y") {
                unitprice = unitprice_old;
            } else {
                unitprice = 0;
            }
            model.set("UNITPRICE", unitprice);

            supplyprice = (qty * unitprice) * 1.0;
            model.set("SUPPLYPRICE", supplyprice);

            addtax = Math.round(supplyprice * 0.1);
            model.set("ADDITIONALTAX", addtax);

            total = supplyprice + addtax;
            model.set("TOTAL", total);
        }
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

    gridnms["grid.1"] = "ReceiveRegistD";

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
            name: 'TRANSNO',
        }, {
            type: 'number',
            name: 'TRANSSEQ',
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
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'MODELNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARDDETAIL',
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
            type: 'number',
            name: 'OLDQTY',
        }, {
            type: 'number',
            name: 'TRANSQTY',
        }, {
            type: 'number',
            name: 'UNITPRICE',
        }, {
            type: 'number',
            name: 'UNITPRICEOLD',
        }, {
            type: 'number',
            name: 'SUPPLYPRICE',
        }, {
            type: 'number',
            name: 'ADDITIONALTAX',
        }, {
            type: 'number',
            name: 'INSPQTY',
        }, {
            type: 'number',
            name: 'TRANSDUEQTY',
        }, {
            type: 'number',
            name: 'DUEQTY',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'number',
            name: 'INSPCHK',
        }, {
            type: 'number',
            name: 'LOTCHK',
        }, {
            type: 'string',
            name: 'PURCHASECONFIRM',
        }, {
            type: 'string',
            name: 'LOTNO',
        }, {
            type: 'number',
            name: 'INPUTQTY',
        }, {
            type: 'number',
            name: 'INTQTY',
        }, {
            type: 'number',
            name: 'RESTQTY',
        }, {
            type: 'number',
            name: 'LOTCNT',
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

                var result = record.data.TRANSFINISHYN;
                if (result == "Y") {
                    meta['tdCls'] = 'x-item-disabled';
                } else {
                    meta['tdCls'] = '';
                }
                return new Ext.ux.CheckColumn().renderer(value);
            },
            listeners: {
                beforecheckchange: function (options, row, value, event) {

                    var record = Ext.getCmp(gridnms["views.order"]).selModel.store.data.items[row].data;
                    if (value) {
                        var result = record.data.TRANSFINISHYN;
                        if (result == "Y") {
                            extAlert("입하완료된 경우 삭제가 불가능합니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }
                    }
                }
            }
        }, {
            dataIndex: 'TRANSSEQ',
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
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 250,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
                return value;
            },
        }, {
            dataIndex: 'ITEMSTANDARD',
            text: '규격',
            xtype: 'gridcolumn',
            width: 100,
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            summaryRenderer: function (value, meta, record) {
                value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>TOTAL</div>";
                return value;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return Ext.util.Format.number(value, '0,000');
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

                        var qty = field.getValue();
                        var unitcost = store.data.UNITPRICE;
                        store.set("UNITPRICE", unitcost);

                        var supplyprice = 0,
                        addtax = 0,
                        total = 0;

                        supplyprice = (qty * unitcost) * 1.0;
                        store.set("SUPPLYPRICE", supplyprice);

                        addtax = Math.round(supplyprice * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        total = supplyprice + addtax;
                        store.set("TOTAL", total);

                        var qty = field.getValue();
                        var po = store.data.POQTY;
                        var oldqty = store.data.OLDQTY * 1;
                        var insp = store.data.INSPQTY;
                        var dueqty = ((po * 1) - (qty * 1));
//                         var dueqty1 = ((qty * 1) - (insp * 1));
                        var dueqty1 = ((po * 1) - (oldqty * 1) - (qty * 1));

                        if(dueqty1 < 0 )
                            dueqty1=0
                        store.set("DUEQTY", dueqty1);

                        if ((po * 1) > 0) {
                            if ((po * 1) <= (qty * 1) + oldqty) {
                                store.set("TRANSFINISHYN", "Y");
                                store.set("TRANSFINISHYNNAME", "완료");
                            } else {
                                store.set("TRANSFINISHYN", "N");
                                store.set("TRANSFINISHYNNAME", "미완료");
                            }
                        } else {
                            store.set("TRANSFINISHYN", "Y");
                            store.set("TRANSFINISHYNNAME", "완료");
                        }
                    },
                },
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.PURCHASECONFIRM;
                var finishyn = record.data.TRANSFINISHYN;

                if (confirmyn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    if (finishyn == "Y") {
                        meta.style = "background-color:rgb(234, 234, 234); ";
                    } else {
                        meta.style = "background-color:rgb(253, 218, 255); ";
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

                        var qty = store.data.TRANSQTY;
                        var unitcost = field.getValue();

                        var supplyprice = 0,
                        addtax = 0,
                        total = 0;

                        supplyprice = (qty * unitcost) * 1.0;
                        store.set("SUPPLYPRICE", supplyprice);

                        addtax = Math.round(supplyprice * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        total = supplyprice + addtax;
                        store.set("TOTAL", total);

                    },
                },
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.PURCHASECONFIRM;
                var finishyn = record.data.TRANSFINISHYN;

                if (confirmyn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    if (finishyn == "Y") {
                        meta.style = "background-color:rgb(234, 234, 234); ";
                    } else {
                        meta.style = "background-color:rgb(253, 218, 255); ";
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
                maskRe: /[0-9.]/,
                selectOnFocus: true,
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
                        var supplyprice = newValue * 1;

                        var addtax = Math.round(supplyprice * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        var total = supplyprice + addtax;
                        store.set("TOTAL", total);
                    },
                },
            },
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.PURCHASECONFIRM;
                var finishyn = record.data.TRANSFINISHYN;

                if (confirmyn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    if (finishyn == "Y") {
                        meta.style = "background-color:rgb(234, 234, 234); ";
                    } else {
                        meta.style = "background-color:rgb(253, 218, 255); ";
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
                maskRe: /[0-9.]/,
                selectOnFocus: true,
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
                        var supplyprice = store.data.SUPPLYPRICE * 1;

                        var addtax = newValue * 1;
                        store.set("ADDITIONALTAX", addtax);

                        var total = supplyprice + addtax;
                        store.set("TOTAL", total);

                    },
                },
            },
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.PURCHASECONFIRM;
                var finishyn = record.data.TRANSFINISHYN;

                if (confirmyn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    if (finishyn == "Y") {
                        meta.style = "background-color:rgb(234, 234, 234); ";
                    } else {
                        meta.style = "background-color:rgb(253, 218, 255); ";
                    }
                }
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TRANSFINISHYNNAME',
            text: '완료여부',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: ['완료', '미완료'],
                editable: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        if (value.getValue() == "완료") {
                            model.set("TRANSFINISHYN", "Y");
                        } else if (value.getValue() == "미완료") {
                            model.set("TRANSFINISHYN", "N");
                        }
                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        if (field.getValue() == "") {
                            model.set("TRANSFINISHYN", "N");
                        }
                    },
                },
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.PURCHASECONFIRM;

                if (confirmyn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                }
                return value;
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return Ext.util.Format.number(value, '0,000');
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            },
            renderer: function (value, meta, record) {
                var confirmyn = record.data.PURCHASECONFIRM;

                if (confirmyn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
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
            dataIndex: 'TRANSNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODELNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'TRANSFINISHYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'PURCHASECONFIRM',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPCHK',
            xtype: 'hidden',
        }, {
            dataIndex: 'LOTCHK',
            xtype: 'hidden',
        }, {
            dataIndex: 'OLDQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'INTQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'RESTQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'LOTNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'UNITPRICEOLD',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/dist/mat/MatTransDetailList.do' />"
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
        text: "자재 불러오기",
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

var global_popup_flag = false;
function btnSel1(btn) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var TransNo = $('#TransNo').val();
    var TransDate = $('#TransDate').val();
    var TradeDate = $('#TradeDate').val();
    var TransDiv = $('#TransDiv').val();
    var CustomerCode = $('#CustomerCode').val();
    var ItemCode = $('#ItemCode').val();
    var Qty = $('#Qty').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (TransDate === "") {
        header.push("요청일");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return false;
    }

    // 자재 불러오기 팝업
    var width = 1309; // 가로
    var height = 640; // 세로
    var title = "자재불러오기 Popup";

    var status = $('#Status').val();
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

    global_popup_flag = false;
    if (check) {
        // 완료 외 상태에서만 팝업 표시하도록 처리
        $('#popupOrgId').val($('#searchOrgId option:selected').val());
        $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
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
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
                        //                buffer: 50,
                        change: function (value, nv, ov, e) {
                            value.setValue(nv.toUpperCase());
                            var result = value.getValue();

                            $('#popupItemName').val(result);
                        },
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search();
                            }
                        }
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
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
                        change: function (value, nv, ov, e) {
                            value.setValue(nv.toUpperCase());
                            var result = value.getValue();

                            $('#popupOrderName').val(result);
                        },
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search();
                            }
                        }
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
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
                        change: function (value, nv, ov, e) {
                            value.setValue(nv.toUpperCase());
                            var result = value.getValue();

                            $('#popupItemStandard').val(result);
                        },
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search();
                            }
                        }
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
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
                        change: function (value, nv, ov, e) {
                            value.setValue(nv.toUpperCase());
                            var result = value.getValue();

                            $('#popupCustomerName').val(result);
                        },
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search();
                            }
                        }
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
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
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
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search();
                            }
                        }
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

                        var customertemp;
                        for (var i = 0; i < count4; i++) {
                            Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
                            var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                            var chk = model4.data.CHK;
                            var customer = model4.data.CUSTOMERCODE;

                            if (chk) {
                                checknum++;
                                if (customertemp == "" || customertemp == undefined) {
                                    customertemp = customer;
                                } else {
                                    if (customertemp != customer) {
                                        checkqty++;
                                    }
                                }
                            }
                        }
                        console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                        if (checknum == 0) {
                            extAlert("자재를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (checkqty > 0) {
                            extAlert("다른 공급사을 선택하셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (count4 == 0) {
                            console.log("[적용] 자재 정보가 없습니다.");
                        } else {
                            for (var j = 0; j < count4; j++) {
                                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
                                var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                                var chk = model4.data.CHK;
                                var gubun = $('#TransDiv').val();
                                if (chk) {
                                    var model = Ext.create(gridnms["model.1"]);
                                    var store = Ext.getStore(gridnms["store.1"]);

                                    // 순번
                                    model.set("TRANSSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("ITEMCODE", model4.data.ITEMCODE);
                                    model.set("ITEMNAME", model4.data.ITEMNAME);
                                    model.set("ORDERNAME", model4.data.ORDERNAME);
                                    model.set("UOM", model4.data.UOM);
                                    model.set("UOMNAME", model4.data.UOMNAME);
                                    model.set("MODEL", model4.data.MODEL);
                                    model.set("MODELNAME", model4.data.MODELNAME);
                                    model.set("LOTYN", model4.data.LOTYN);

                                    model.set("ITEMSTANDARD", model4.data.ITEMSTANDARD);
                                    model.set("MATERIALTYPE", model4.data.MATERIALTYPE);

                                    var qty = model4.data.QTYDETAIL * 1;
                                    var tempQty = 0;

                                    if (qty > 0) {
                                        model.set("TRANSQTY", qty);
                                        tempQty = qty
                                    } else {
                                        model.set("TRANSQTY", 1);
                                        tempQty = 1;
                                    }

                                    var unitprice = model4.data.SALESPRICE;
                                    model.set("UNITPRICE", unitprice);
                                    model.set("UNITPRICEOLD", unitprice);

                                    var supplyprice = (tempQty * unitprice) * 1.0;
                                    model.set("SUPPLYPRICE", supplyprice);

                                    var addtax = Math.round(supplyprice * 0.1);
                                    model.set("ADDITIONALTAX", addtax);

                                    var total = supplyprice + addtax;
                                    model.set("TOTAL", total);

                                                         model.set("TRANSFINISHYN", "Y");
                                                         model.set("TRANSFINISHYNNAME", "완료");
//                                     model.set("TRANSFINISHYN", "N");
//                                     model.set("TRANSFINISHYNNAME", "미완료");

                                    $('#CustomerCode').val(model4.data.CUSTOMERCODE);
                                    $('#CustomerName').val(model4.data.CUSTOMERNAME);

                                    var subitem = model4.data.SUBITEM + "";
                                    if (subitem == "" || subitem == undefined || subitem == "10") {
                                        $('#TransDiv').val("S");
                                    } else {
                                        $('#TransDiv').val("A");
                                    }
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
            USEDIV2: "T",
        };
        extGridSearch(sparams1, gridnms["store.8"]);

        //      $('#popupItemType').val($('#searchGroupCode').val());
        //      $('#popupItemTypeName').val("양산원재료");
        //      var popupItemTypeName = $('#popupItemTypeName').val();
        //      $('input[name=searchItemType]').val(popupItemTypeName);

        var customername = $('#CustomerName').val();
        if (customername == "") {
            $('#popupCustomerName').val("");
            $('input[name=searchCustomerName]').val("");
            $('input[name=searchCustomerName]').attr('disabled', false).removeClass('ui-state-disabled');
        } else {
            $('#popupCustomerName').val(customername);
            $('input[name=searchCustomerName]').val(customername);
            $('input[name=searchCustomerName]').attr('disabled', true).addClass('ui-state-disabled');
        }
    } else {
        extAlert("입하 등록 하실 경우에만 자재 불러오기가 가능합니다.");
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
        MATGROUPCODE2: 'Y',
    };
    extGridSearch(sparams, gridnms["store.4"]);
}

var global_popup_flag2 = false;
function btnSel2(btn) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var TransNo = $('#TransNo').val();
    var TransDate = $('#TransDate').val();
    var TradeDate = $('#TradeDate').val();
    var TransDiv = $('#TransDiv').val();
    var CustomerCode = $('#CustomerCode').val();
    var ItemCode = $('#ItemCode').val();
    var Qty = $('#Qty').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (TransDate === "") {
        header.push("요청일");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return false;
    }

    // 자재 불러오기 팝업
    var width = 1428; // 가로
    var height = 640; // 500; // 세로
    var title = "입하대기LIST(발주정보) Pop up";

    var status = $('#Status').val();
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
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
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
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search1();
                            }
                        }
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
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
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
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search1();
                            }
                        }
                    },
                    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
                },
                '품명', {
                    xtype: 'textfield',
                    name: 'searchItemName1',
                    clearOnReset: true,
                    hideLabel: true,
                    width: 200,
                    editable: true,
                    allowBlank: true,
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
                        change: function (value, nv, ov, e) {
                            value.setValue(nv.toUpperCase());
                            var result = value.getValue();

                            $('#popupItemName').val(result);
                        },
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search1();
                            }
                        }
                    },
                },
                '품번', {
                    xtype: 'textfield',
                    name: 'searchOrderName1',
                    clearOnReset: true,
                    hideLabel: true,
                    width: 120,
                    editable: true,
                    allowBlank: true,
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
                        change: function (value, nv, ov, e) {
                            value.setValue(nv.toUpperCase());
                            var result = value.getValue();

                            $('#popupOrderName').val(result);
                        },
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search1();
                            }
                        }
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
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
                        change: function (value, nv, ov, e) {
                            value.setValue(nv.toUpperCase());
                            var result = value.getValue();

                            $('#popupItemStandard').val(result);
                        },
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search1();
                            }
                        }
                    },
                },
                '공급사', {
                    xtype: 'textfield',
                    name: 'searchCustomerName1',
                    clearOnReset: true,
                    hideLabel: true,
                    width: 150,
                    editable: true,
                    allowBlank: true,
                    enableKeyEvents: true,
                    listeners: {
                        scope: this,
                        change: function (value, nv, ov, e) {
                            value.setValue(nv.toUpperCase());
                            var result = value.getValue();

                            $('#popupCustomerName').val(result);
                        },
                        keyup: function (o, e) {
                            if (e.getKey() == 13) {
                                fn_popup_search1();
                            }
                        }
                    },
                }, '->', {
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

                        var customertemp;
                        for (var i = 0; i < count44; i++) {
                            Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(i));
                            var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];
                            var chk = model44.data.CHK;
                            var customer = model44.data.CUSTOMERCODE;

                            if (chk) {
                                checknum++;
                                if (customertemp == "" || customertemp == undefined) {
                                    customertemp = customer;
                                } else {
                                    if (customertemp != customer) {
                                        checkqty++;
                                    }
                                }
                            }
                        }
                        console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                        if (checknum == 0) {
                            extAlert("발주정보를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (checkqty > 0) {
                            extAlert("다른 업체명을 선택하셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (count44 == 0) {
                            console.log("[적용] 발주 정보가 없습니다.");
                        } else {
                            for (var j = 0; j < count44; j++) {
                                Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(j));
                                var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];
                                var chk = model44.data.CHK;
                                var gubun = $('#TransDiv').val();
                                if (chk) {
                                    var model = Ext.create(gridnms["model.1"]);
                                    var store = Ext.getStore(gridnms["store.1"]);

                                    // 순번
                                    model.set("TRANSSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("ITEMCODE", model44.data.ITEMCODE);
                                    model.set("ITEMNAME", model44.data.ITEMNAME);
                                    model.set("ORDERNAME", model44.data.ORDERNAME);
                                    model.set("UOM", model44.data.UOM);
                                    model.set("UOMNAME", model44.data.UOMNAME);
                                    model.set("MODEL", model44.data.MODEL);
                                    model.set("MODELNAME", model44.data.MODELNAME);
                                    model.set("LOTYN", model44.data.LOTYN);

                                    model.set("PONO", model44.data.PONO);
                                    model.set("POSEQ", model44.data.POSEQ);
                                    model.set("POQTY", model44.data.ORDERQTY);
                                    model.set("TRANSQTY", model44.data.TRANSQTY);
                                    model.set("OLDQTY", model44.data.OLDQTY);

                                    model.set("ITEMSTANDARD", model44.data.ITEMSTANDARD);
                                    model.set("MATERIALTYPE", model44.data.MATERIALTYPE);

                                    var unitprice = model44.data.UNITPRICE;
                                    model.set("UNITPRICE", unitprice);
                                    model.set("UNITPRICEOLD", unitprice);

                                    var qty = model44.data.TRANSQTY;
                                    var supplyprice = (qty * unitprice) * 1.0;
                                    model.set("SUPPLYPRICE", supplyprice);

                                    var addtax = Math.round(supplyprice * 0.1);
                                    model.set("ADDITIONALTAX", addtax);

                                    var total = supplyprice + addtax;
                                    model.set("TOTAL", total);

                                    var orderqty = model44.data.ORDERQTY * 1;
                                    var transqty = model44.data.TRANSQTY * 1;
                                    var oldqty = model44.data.OLDQTY * 1;

                                    if (orderqty == (transqty + oldqty)) {
                                        model.set("TRANSFINISHYN", "Y");
                                        model.set("TRANSFINISHYNNAME", "완료");
                                    } else {
                                        model.set("TRANSFINISHYN", "N");
                                        model.set("TRANSFINISHYNNAME", "미완료");
                                    }

                                    $('#CustomerCode').val(model44.data.CUSTOMERCODE);
                                    $('#CustomerName').val(model44.data.CUSTOMERNAME);

                                    var subitem = model44.data.SUBITEM + "";
                                    if (subitem == "" || subitem == undefined || subitem == "10") {
                                        $('#TransDiv').val("S");
                                    } else {
                                        $('#TransDiv').val("A");
                                    }

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

        var customername = $('#CustomerName').val();
        if (customername == "") {
            $('#popupCustomerName').val("");
            $('input[name=searchCustomerName1]').val("");
            $('input[name=searchCustomerName1]').attr('disabled', false).removeClass('ui-state-disabled');
        } else {
            $('#popupCustomerName').val(customername);
            $('input[name=searchCustomerName1]').val(customername);
            $('input[name=searchCustomerName1]').attr('disabled', true).addClass('ui-state-disabled');
        }
    } else {
        extAlert("입하 등록 하실 경우에만 입하대기LIST(발주정보) 불러오기가 가능합니다.");
        return;
    }
}

function fn_popup_search1() {
    global_popup_flag2 = false;
    var sparams = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        POFROM: $('#popupDueFrom').val(),
        POTO: $('#popupDueTo').val(),
        ITEMCODE: $('#popupItemCode').val(),
        ITEMNAME: $('#popupItemName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        ITEMTYPE: $('#popupItemType').val(),
        CUSTOMERNAME: $('#popupCustomerName').val(),
        ITEMSTANDARD: $('#popupItemStandard').val(),
    };
    extGridSearch(sparams, gridnms["store.44"]);
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

        var inspchk = model1.data.INSPCHK;
        var lotchk = model1.data.LOTCHK;

        if (lotchk != 0 || inspchk != 0) {}
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
    var transno = $('#TransNo').val();
    var transseq = "";
    var inspchk = record.data.INSPCHK;
    var lotchk = record.data.LOTCHK;
    var url = "<c:url value='/delete/dist/mat/MatTransDetailList.do' />";

    if (record === undefined) {
        extAlert("삭제하실 데이터를 선택 해 주십시오.");
        return;
    }
    var gridcount = store.count() * 1;
    if (gridcount == 0) {
        extAlert("삭제하실 데이터가 없습니다.");
        return;
    }

    if (lotchk != 0) {
        extAlert("LOT 발행 정보가 있을 경우 삭제가 불가능 합니다.<br/>LOT 발행 정보 자료 확인 후 진행 하세요.");
        return;
    }

    if (inspchk != 0) {
        extAlert("입고검사 자료가 있을 경우 삭제가 불가능 합니다.<br/>입고 검사 자료 확인 후 진행 하세요.");
        return;
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
                        transno = model.data.TRANSNO;
                        transseq = model.data.TRANSSEQ;
                        pono = model.data.PONO;

                        if (transno == "") {
                            // 데이터 등록되지 않은 건
                            deletecount++;
                            store.remove(model);
                        } else {
                            // 데이터 등록 건

                            var sparams = {
                                ORGID: orgid,
                                COMPANYID: companyid,
                                TRANSNO: transno,
                                TRANSSEQ: transseq,
                                PONO: pono,
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
                                        go_url("<c:url value='/dist/mat/ReceiveRegistD.do?no=' />" + transno + "&org=" + orgid + "&company=" + companyid);
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
                transseq = record.data.TRANSSEQ;

                if (tradeno == "") {
                    store.remove(model);
                } else {

                    var sparams = {
                        ORGID: orgid,
                        COMPANYID: companyid,
                        TRANSNO: transno,
                        TRANSSEQ: transseq,
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
                                go_url("<c:url value='/dist/mat/ReceiveRegistD.do?no=' />" + transno + "&org=" + orgid + "&company=" + companyid);
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
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                TRANSNO: "${searchVO.TRANSNO}",
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
            TransDetailList: '#TransDetailList',
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
                height: 592,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'bottom'
                    }
                ],
                scrollable: true,
                columns: fields["columns.1"],
                viewConfig: {
                    itemId: 'TransDetailList',
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('MATERIALTYPE') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 80) {
                                        column.width = 80;
                                    }
                                }
                                
                                if (column.dataIndex.indexOf("ITEMSTANDARD") >= 0 && column.dataIndex!="ITEMSTANDARDDETAIL" ) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 100) {
                                      column.width = 100;
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
                                var finishyn = data.data.TRANSFINISHYN;
                                var confirmyn = data.data.PURCHASECONFIRM;

                                editDisableCols.push("TRANSSEQ");
                                if (confirmyn == "Y") {
                                    editDisableCols.push("TRANSQTY");
                                    editDisableCols.push("UNITPRICE");
                                    editDisableCols.push("SUPPLYPRICE");
                                    editDisableCols.push("ADDITIONALTAX");
                                    editDisableCols.push("TRANSFINISHYNNAME");
                                    editDisableCols.push("REMARKS");
                                } else {

                                    if (finishyn == "Y") {
                                        editDisableCols.push("TRANSQTY");
                                        editDisableCols.push("UNITPRICE");
                                        editDisableCols.push("SUPPLYPRICE");
                                        editDisableCols.push("ADDITIONALTAX");

                                    }
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
        models: gridnms["models.detail"],
        stores: gridnms["stores.detail"],
        views: gridnms["views.detail"],
        controllers: gridnms["controller.1"],

        launch: function () {
            gridarea = Ext.create(gridnms["views.detail"], {
                renderTo: 'gridDetailArea'
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
            name: 'COMAPNYID',
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
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARD',
        }, {
            type: 'number',
            name: 'SALESPRICE',
        }, {
            type: 'string',
            name: 'SUBITEM',
        }, {
            type: 'string',
            name: 'SUBITEMNAME',
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
            width: 60,
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
            width: 255,
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
            width: 160,
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
            dataIndex: 'SUBITEM',
            xtype: 'hidden',
        }, {
            dataIndex: 'SUBITEMNAME',
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
                        autoLoad: true,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.4"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#popupOrgId').val(),
                                COMPANYID: $('#popupCompanyId').val(),
                                RECEIPTCHK: 'Y',
                                TRANSITEMTYPE: 'Y',
                                MATGROUPCODE2: 'Y',
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

// 입하대기LIST 불러오기 팝업
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
            name: 'COMAPNYID',
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
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERCODENAME',
        }, {
            type: 'string',
            name: 'POPERSON',
        }, {
            type: 'string',
            name: 'POPERSONNAME',
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
            name: 'SUBITEM',
        }, {
            type: 'string',
            name: 'SUBITEMNAME',
        }, {
            type: 'number',
            name: 'UNITCOST',
        }, {
            type: 'string',
            name: 'LOTYN',
        }, {
            type: 'string',
            name: 'INSPYN',
        }, {
            type: 'string',
            name: 'PONO',
        }, {
            type: 'string',
            name: 'POSEQ',
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
            type: 'number',
            name: 'ORDERQTY',
        }, {
            type: 'number',
            name: 'TRANSQTY',
        }, {
            type: 'number',
            name: 'OLDQTY',
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
            dataIndex: 'PONO',
            text: '발주번호',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'POSEQ',
            text: '발주<br/>순번',
            xtype: 'gridcolumn',
            width: 65,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'CUSTOMERNAME',
            text: '공급사',
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
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 250,
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
            width: 120,
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
            dataIndex: 'ORDERQTY',
            text: '발주<br/>수량',
            xtype: 'gridcolumn',
            width: 75,
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
            text: '기입하<br/>수량',
            xtype: 'gridcolumn',
            width: 75,
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
            dataIndex: 'TRANSQTY',
            text: '입하<br/>가능수량',
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
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'LOTYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SUBITEM',
            xtype: 'hidden',
        }, {
            dataIndex: 'SUBITEMNAME',
            xtype: 'hidden',
        }, ];

    items["api.44"] = {};
    $.extend(items["api.44"], {
        read: "<c:url value='/MatReceiveRegistPop1.do' />"
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
    var TransDate = $('#TransDate').val();
    var CustomerCode = $('#CustomerCode').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    if (TransDate === "") {
        header.push("입하일");
        count++;
    }
    //     if (CustomerCode === "") {
    //       header.push("공급사");
    //       count++;
    //     }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return false;
    }

    // 저장
    var transno = $('#TransNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = transno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 입하 등록 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/dist/mat/MatTransMasterList.do' />";
        url1 = "<c:url value='/insert/dist/mat/MatTransDetailList.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/dist/mat/MatTransMasterList.do' />";
        url1 = "<c:url value='/update/dist/mat/MatTransDetailList.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('알림', '저장 하시겠습니까?', function (btn) {
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
                        var transno = data.TRANSNO;

                        if (transno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("TRANSNO", transno);

                                if (model.data.TRANSNO != '') {
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
                                            msg = "내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/dist/mat/ReceiveRegistD.do?no=' />" + transno + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('입하등록', '입하등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('입하등록 변경 알림', '입하등록을 변경하시겠습니까?', function (btn) {
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
                        var transno = data.TransNo;

                        if (transno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("TRANSNO", transno);
                                if (model.data.TRANSNO != '') {
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
                                            msg = "내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/dist/mat/ReceiveRegistD.do?no=' />" + transno + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('변경', '변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_search() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var transno = $('#TransNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TRANSNO: transno,
    };

    url = "<c:url value='/searchTransNoListLov.do' />";

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var transno = dataList.TRANSNO;
            var transdate = dataList.TRANSDATE;
            var tradedate = dataList.TRADEDATE;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var transdiv = dataList.TRANSDIV;
            var paidyn = dataList.PAIDYN;
            var customercodes = dataList.CUSTOMERCODES;
            var customernames = dataList.CUSTOMERNAMES;
            var remarks = dataList.REMARKS;

            $("#TransNo").val(transno);
            $("#TransDate").val(transdate);
            $("#TradeDate").val(tradedate);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#TransDiv").val(transdiv);
            $("#PaidYn").val(paidyn);
            $("#CustomerCodeS").val(customercodes);
            $("#CustomerNameS").val(customernames);
            $("#Remarks").val(remarks);

            global_close_yn = fn_monthly_close_filter_data(transdate, 'MAT');
        },
        error: ajaxError
    });
}

function fn_delete() {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (!gridcount == 0) {
        extAlert("[상세 데이터 ]<br/> 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return false;
    }

    url = "<c:url value='/delete/dist/mat/MatTransMasterList.do' />";

    Ext.MessageBox.confirm('삭제 알림', '해당 데이터를 삭제하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: $("#master").serialize(),
                success: function (data) {
                    extAlert(data.msg);

                    var result = data.success;
                    var msg = data.msg;
                    extAlert(msg);

                    if (result) {
                        fn_list();
                    } else {
                        return;
                    }
                },
                error: ajaxError
            });
        } else {
            Ext.Msg.alert('삭제', '해당 데이터 삭제가 취소되었습니다.');
            return;
        }
    });
}

function fn_list() {
    go_url("<c:url value='/dist/mat/MatReceiveRegist.do'/>");
}

function fn_add() {
    go_url("<c:url value='/dist/mat/ReceiveRegistD.do' />");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
    // 공급사 Lov
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

            return false;
        }
    });

    // 사급처 Lov
    $("#CustomerNameS").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#CustomerNameS").val("");
            $("#CustomerCodeS").val("");
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
                CUSTOMERTYPE1: 'S',
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
            $("#CustomerCodeS").val(o.item.value);
            $("#CustomerNameS").val(o.item.NAME);

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
										<input type="hidden" id="searchGroupCode" name="searchGroupCode" value="M" />
										<input type="hidden" id="popupOrgId" name="popupOrgId" />
										<input type="hidden" id="popupCompanyId" name="popupCompanyId" />
										<input type="hidden" id="popupDueFrom" />
										<input type="hidden" id="popupDueTo" />
										<input type="hidden" id="popupGroupCode" name=popupGroupCode value="M" />
										<input type="hidden" id="popupItemCode" name="popupItemCode" />
										<input type="hidden" id="popupItemName" name="popupItemName" />
										<input type="hidden" id="popupOrderName" name="popupOrderName" />
										<input type="hidden" id="popupItemStandard" name="popupItemStandard" />
										<input type="hidden" id="popupItemType" name="popupItemType" />
										<input type="hidden" id="popupItemTypeName" name="popupItemTypeName" />
										<input type="hidden" id="popupCustomerName" name="popupCustomerName" />
										<fieldset style="width: 100%">
												<legend>조건정보 영역</legend>
												<form id="master" name="master" action="" method="post">
														<input type="hidden" id="CustomerCode" name="CustomerCode" />
														<input type="hidden" id="CustomerCodeS" name="CustomerCodeS" />
                            <input type="hidden" id="TradeDate" name="TradeDate" />
														<table class="tbl_type_view" border="0">
																<colgroup>
																		<col width="23%">
																		<col width="23%">
																		<col width="43%">
																</colgroup>
																<tr style="height: 34px;">
																		<td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 50%;">
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
																		<td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 50%;">
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
																						<a id="btnChk1" class="btn_search" href="#" onclick="javascript:btnSel2();"> 입하대기 LIST(발주정보) </a>
																						<a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
																						<a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete();"> 삭제 </a>
																						<a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
																						<a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
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
																		<th class="required_text">입하번호</th>
																		<td><input type="text" id="TransNo" name="TransNo" class="input_center" style="width: 97%;" value="${searchVO.TRANSNO}" readonly /></td>
																		<th class="required_text">입하일</th>
																		<td><input type="text" id="TransDate" name="TransDate" class="input_validation input_center" style="width: 97%;" maxlength="10" /></td>
																		<!-- <th class="required_text">납기일</th>
																		<td><input type="text" id="TradeDate" name="TradeDate" class="input_validation input_center" style="width: 97%;" maxlength="10" /></td> -->
                                    <th class="required_text">공급사</th>
                                    <td><input type="text" id="CustomerName" name="CustomerName" class="input_center" style="width: 97%;" /></td>
                                    <th class="required_text">입하구분</th>
                                    <td>
                                        <select id="TransDiv" name="TransDiv" class="input_left" style="width: 97%;">
                                        </select>
                                    </td>
																</tr>
																<tr style="height: 34px;">
                                    <th class="required_text">유무상구분</th>
                                    <td>
		                                    <select id="PaidYn" name="PaidYn" class="input_left" style="width: 97%;">
		                                    </select>
                                    </td>
																		<th class="required_text">사급처</th>
																		<td><input type="text" id="CustomerNameS" name="CustomerNameS" class="input_center" style="width: 97%;" /></td>
																		<td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
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

								<div id="gridDetailArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
						</div>
						<!-- //content 끝 -->
				</div>
				<!-- //container 끝 -->
				<div id="gridPopup1Area" style="width: 1300px; padding-top: 0px; float: left;"></div>
				<div id="gridPopup11Area" style="width: 1415px; padding-top: 0px; float: left;"></div>

				<!-- footer 시작 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
				<!-- //footer 끝 -->
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>