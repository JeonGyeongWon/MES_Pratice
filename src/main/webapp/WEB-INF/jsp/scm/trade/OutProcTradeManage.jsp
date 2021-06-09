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
    ime-mode:disabled;
    text-transform:uppercase;
}
</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    setValues_Popup();
    setExtGrid_Popup();

    $("#gridPopup1Area").hide("blind", {
        direction: "up"
    }, "fast");

    setReadOnly();
    setLovList();

    setLastInitial();
});

var global_close_yn = "N";
function setInitial() {
    // 최초 상태 설정
    gridnms["app"] = "scm";

    calender($('#TradeDate'));

    $('#TradeDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });
}

function setLastInitial() {

    var tradeno = $('#TradeNo').val();
    if (tradeno != "") {
        fn_search();
    } else {
        // 날짜
        $("#TradeDate").val(getToDay("${searchVO.TODAY}") + "");
    }

    if ("${searchVO.CustomerCode}" != "") {
        $('#CustomerName').attr('readonly', true);
        $('#CustomerName').attr('disabled', true);
        $("#CustomerName").val("${searchVO.CustomerName}");
        $("#CustomerCode").val("${searchVO.CustomerCode}");
    } else {
        $('#CustomerName').attr('readonly', false);
        $('#CustomerName').attr('disabled', false);
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

    gridnms["grid.1"] = "OutProcTradeManage";

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
            name: 'TRADENO',
        }, {
            type: 'number',
            name: 'TRADESEQ',
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
            name: 'ORDERQTY',
        }, {
            type: 'number',
            name: 'BEFOREQTY',
        }, {
            type: 'number',
            name: 'TRANSACTIONQTY',
        }, {
            type: 'number',
            name: 'FAULTQTY',
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
            name: 'TOTALQTY',
        }, {
            type: 'string',
            name: 'OUTPONO',
        }, {
            type: 'number',
            name: 'OUTPOSEQ',
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'FORWARDYN',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'string',
            name: 'OUTTRANSYN',
        },
    ];

    fields["columns.1"] = [
        // Display Columns
        {
            dataIndex: 'TRADESEQ',
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
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
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

                var outtransyn = record.data.OUTTRANSYN;
                if (outtransyn == "Y") {
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
                        var outtransyn = record.OUTTRANSYN;
                        if (outtransyn == "Y") {
                            extAlert("외주입고가 완료된 내역은 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
                            return false;
                        }
                    }
                }
            }
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
                meta.style = "background-color:rgb(234, 234, 234)";
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
                meta.style = "background-color:rgb(234, 234, 234)";
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
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            text: '타입',
            xtype: 'gridcolumn',
            width: 60,
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
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
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'ORDERQTY',
            text: '출하수량',
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
                return value;
            },
        }, {
            dataIndex: 'BEFOREQTY',
            text: '기명세서<br/>수량',
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
            summaryRenderer: function (value, meta, record) {
                value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>TOTAL</div>";
                return value;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
            //     },{
            //      dataIndex: 'CHARGETYPENAME',
            //      text: '계산법',
            //      xtype: 'gridcolumn',
            //      width: 85,
            //      hidden: false,
            //      sortable: false,
            //      resizable: false,
            //      menuDisabled: true,
            //      style: 'text-align:center;',
            //      align: "center",
            //      renderer: function (value, meta, record) {
            //        meta.style = "background-color:rgb(234, 234, 234)";
            //        return value;
            //      },
        }, {
            dataIndex: 'TRANSACTIONQTY',
            text: '수량',
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
                        var unitcost = store.data.UNITPRICE;
                        store.set("UNITPRICE", unitcost);

                        var supplyprice = 0,
                        addtax = 0,
                        total = 0;
                        supplyprice = (qty * unitcost) * 1;
                        store.set("SUPPLYPRICE", supplyprice);

                        addtax = Math.round((qty * unitcost) * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        total = (supplyprice * 1) + (addtax * 1);
                        store.set("TOTALQTY", total);
                    },
                },
            },
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'FAULTQTY',
            text: '불량<br/>수량',
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

                        var tradeqty = store.data.TRANSACTIONQTY * 1;
                        var faultqty = field.getValue();

                        var qty = (tradeqty - faultqty);

                        store.set("TRANSACTIONQTY", qty);
                        var unitcost = store.data.UNITPRICE;
                        store.set("UNITPRICE", unitcost);

                        var supplyprice = 0,
                        addtax = 0,
                        total = 0;
                        supplyprice = (qty * unitcost) * 1;
                        store.set("SUPPLYPRICE", supplyprice);

                        addtax = Math.round((qty * unitcost) * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        total = (supplyprice * 1) + (addtax * 1);
                        store.set("TOTALQTY", total);
                    },
                },
            },
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                return Ext.util.Format.number(value, '0,000');
            },
            //     },{
            //         dataIndex: 'CHARGEQTY',
            //         text: '차지수량',
            //         xtype: 'gridcolumn',
            //         width: 100,
            //         hidden: false,
            //         sortable: false,
            //         resizable: false,
            //         menuDisabled: true,
            //         style: 'text-align:center;',
            //         align: "right",
            //         cls: 'ERPQTY',
            //         format: "0,000",
            //         renderer: function (value, meta, record) {
            //           meta.style = "background-color:rgb(234, 234, 234); ";
            //           return Ext.util.Format.number(value, '0,000');
            //         },
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

                        var qty = store.data.TRANSACTIONQTY * 1;
                        var unitcost = field.getValue();

                        var supplyprice = 0,
                        addtax = 0,
                        total = 0;
                        supplyprice = (qty * unitcost) * 1;
                        store.set("SUPPLYPRICE", supplyprice);

                        addtax = Math.round((qty * unitcost) * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        total = (supplyprice * 1) + (addtax * 1);
                        store.set("TOTALQTY", total);
                    },
                },
            },
            renderer: function (value, meta, record) {
                //                 switch (groupid) {
                //                 case "ROLE_ADMIN":
                //                 case "ROLE_MANAGER":
                meta.style = "background-color:rgb(253, 218, 255); ";
                //                     break;
                //                 default:
                //                     meta.style = "background-color:rgb(234, 234, 234); ";

                //                     break;
                //                 }
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

                        var supplyprice = 0,
                        addtax = 0,
                        total = 0;
                        supplyprice = field.getValue();

                        addtax = Math.round(supplyprice * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        total = (supplyprice * 1) + (addtax * 1);
                        store.set("TOTALQTY", total);
                    },
                },
            },
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
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

                        var supplyprice = 0,
                        addtax = 0,
                        total = 0;
                        supplyprice = store.data.SUPPLYPRICE * 1;

                        addtax = field.getValue();

                        total = (supplyprice * 1) + (addtax * 1);
                        store.set("TOTALQTY", total);
                    },
                },
            },
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTALQTY',
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
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'OUTPONO',
            text: '발주번호',
            xtype: 'gridcolumn',
            width: 120,
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
            dataIndex: 'OUTPOSEQ',
            text: '발주<br/>순번',
            xtype: 'gridcolumn',
            width: 50,
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
            dataIndex: 'TRADENO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'ENDDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'FORWARDYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHARGETYPENAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHARGEQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'OUTTRANSYN',
            xtype: 'hidden',
        },
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/scm/trade/OutProcTradeDetailList.do' />"
    });
    $.extend(items["api.1"], {
        destroy: "<c:url value='/delete/scm/trade/OutProcTradeDetailList.do' />"
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

    //     var tradeno = $('#TradeNo').val();
    //     if (tradeno != "") {
    //         switch (groupid) {
    //         case "ROLE_SCM":
    //         case "ROLE_SCM_R":
    //         case "ROLE_SCM_A":
    //             break;
    //         default:
    //             items["docked.1"].push(items["dock.btn.1"]);
    //             break;
    //         }
    //     } else {
    //         items["docked.1"].push(items["dock.btn.1"]);
    //     }
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

        var outtransyn = model1.data.OUTTRANSYN;
        if (outtransyn == "N") {
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
    var store = Ext.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var tradeno = $('#TradeNo').val();
    var tradeseq = "";
    var url = "<c:url value='/delete/scm/trade/OutProcTradeDetailList.do' />";

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    if (record === undefined) {
        extAlert("삭제하실 데이터를 선택 해 주십시오.");
        return;
    }

    var gridcount = store.count() * 1;
    if (gridcount == 0) {
        extAlert("삭제하실 데이터가 없습니다.");
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
                        tradeno = model.data.TRADENO;
                        tradeseq = model.data.TRADESEQ;

                        if (tradeno == "") {
                            // 데이터 등록되지 않은 건
                            deletecount++;
                            store.remove(model);
                        } else {
                            // 데이터 등록 건
                            var sparams = {
                                ORGID: orgid,
                                COMPANYID: companyid,
                                TRADENO: tradeno,
                                TRADESEQ: tradeseq,
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
                                        go_url("<c:url value='/scm/trade/OutProcTradeManage.do?no=' />" + tradeno + "&org=" + orgid + "&company=" + companyid);

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
                tradeseq = record.data.TRADESEQ;

                if (tradeno == "") {
                    store.remove(model);
                } else {

                    var sparams = {
                        ORGID: orgid,
                        COMPANYID: companyid,
                        TRADENO: tradeno,
                        TRADESEQ: tradeseq,
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
                                go_url("<c:url value='/scm/trade/OutProcTradeManage.do?no=' />" + tradeno + "&org=" + orgid + "&company=" + companyid);
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
                                TRADENO: $('#TradeNo').val(),
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
            btnList: '#btnList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        btnChk1Click: btnChk1Click,
        btnDel1: btnDel1,
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
                height: 626,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'bottom'
                    }
                ],
                scrollable: true,
                columns: fields["columns.1"],
                viewConfig: {
                    itemId: 'btnList',
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('MODELNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
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
                                editDisableCols.push("TRADESEQ");

                                var col_index = ctx.colIdx;
                                //                                 switch (col_index) {
                                //                                 case 9:
                                //                                     // 단가
                                //                                     switch (groupid) {
                                //                                     case "ROLE_ADMIN":
                                //                                     case "ROLE_MANAGER":
                                //                                         ctx.cancel = false;
                                //                                         break;
                                //                                     default:
                                //                                         // 1. 신규 레코드 추가시 입력 가능하게 할려면 요걸로
                                //                                         //                      var field_name = ctx.field;
                                //                                         //                      editDisableCols.push(field_name);
                                //                                         // 2. 신규 / 기등록된 항목 입력불가능하게 할려면 요걸로
                                //                                         ctx.cancel = true;

                                //                                         break;
                                //                                     }
                                //                                     break;
                                //                                 default:
                                //                                     break;
                                //                                 }

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
                renderTo: 'gridArea'
            });
        },
    });

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
    });
}

function setValues_Popup() {
    gridnms["models.popup1"] = [];
    gridnms["stores.popup1"] = [];
    gridnms["views.popup1"] = [];
    gridnms["controllers.popup1"] = [];

    gridnms["grid.4"] = "Popup1";

    gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
    gridnms["views.popup1"].push(gridnms["panel.4"]);

    gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
    gridnms["controllers.popup1"].push(gridnms["controller.4"]);

    gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];

    gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];

    gridnms["models.popup1"].push(gridnms["model.4"]);

    gridnms["stores.popup1"].push(gridnms["store.4"]);

    fields["model.4"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'number',
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMAPNYID',
        }, {
            type: 'string',
            name: 'OUTPONO',
        }, {
            type: 'number',
            name: 'OUTPOSEQ',
        }, {
            type: 'date',
            name: 'OUTPODATE',
            dateFormat: 'Y-m-d',
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
            name: 'WORKORDERID',
        }, {
            type: 'string',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'ROUTINGID',
        }, {
            type: 'string',
            name: 'ROUTINGNO',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'number',
            name: 'ORDERQTY',
        }, {
            type: 'number',
            name: 'BEFOREQTY',
        }, {
            type: 'number',
            name: 'TRADEQTY',
        }, {
            type: 'number',
            name: 'UNITPRICE',
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
            dataIndex: 'CUSTOMERNAME',
            text: '가공처',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
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
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            text: '타입',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '공정명',
            xtype: 'gridcolumn',
            width: 130,
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
            width: 70,
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
            dataIndex: 'BEFOREQTY',
            text: '기명세서<br/>수량',
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
            dataIndex: 'TRADEQTY',
            text: '출하<br/>수량',
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
            dataIndex: 'OUTPONO',
            text: '발주번호',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'OUTPOSEQ',
            text: '발주<br/>순번',
            xtype: 'gridcolumn',
            width: 50,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
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
            dataIndex: 'OUTPODATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'DRAWINGNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'UNITPRICE',
            xtype: 'hidden',
        }, ];

    items["api.4"] = {};
    $.extend(items["api.4"], {
        read: "<c:url value='/searchScmOutProcTradePopup.do' />"
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

var gridpopup1;
function setExtGrid_Popup() {
    Ext.define(gridnms["model.4"], {
        extend: Ext.data.Model,
        fields: fields["model.4"],
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
                height: 563,
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

var global_popup_flag = false;
function btnSel1(btn) {
    var TradeDate = $('#TradeDate').val();
    var CustomerCode = $('#CustomerCode').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    if (TradeDate === "") {
        header.push("발행일자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    // 불러오기 팝업
    var width = 1408; // 가로
    var height = 640; // 세로
    var title = "외주발주 불러오기 Popup";

    var check = true;

    global_popup_flag = false;
    if (check) {
        // 완료 외 상태에서만 팝업 표시하도록 처리
        $('#popupOrgId').val($('#searchOrgId option:selected').val());
        $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
        $('#popupCustomerName').val("");
        $('#popupDateFrom').val("");
        $('#popupDateTo').val("");
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
                            $('#popupDateFrom').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
                        },
                        change: function (value, nv, ov, e) {
                            var result = value.getValue();

                            if (nv !== ov) {
                                if (result === "") {
                                    $('#popupDateFrom').val("");
                                } else {
                                    var popupDueFrom = Ext.Date.format(result, 'Y-m-d');
                                    var popupDueTo = $('#popupDueTo').val();

                                    if (popupDueTo === "") {
                                        $('#popupDateFrom').val(Ext.Date.format(result, 'Y-m-d'));
                                    } else {
                                        var diff = 0;
                                        diff = fn_calc_diff(popupDueFrom, popupDueTo);
                                        if (diff < 0) {
                                            extAlert("이전 날짜가 이후 날짜보다 큽니다.<br/>다시 한번 확인해주십시오.");
                                            value.setValue("");
                                            $('#popupDateFrom').val("");
                                            return;
                                        } else {
                                            $('#popupDateFrom').val(Ext.Date.format(result, 'Y-m-d'));
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
                            $('#popupDateTo').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
                        },
                        change: function (value, nv, ov, e) {
                            var result = value.getValue();

                            if (nv !== ov) {
                                if (result === "") {
                                    $('#popupDateTo').val("");
                                } else {
                                    var popupDueFrom = $('#popupDateFrom').val();
                                    var popupDueTo = Ext.Date.format(result, 'Y-m-d');

                                    if (popupDueFrom === "") {
                                        $('#popupDateTo').val(Ext.Date.format(result, 'Y-m-d'));
                                    } else {
                                        var diff = 0;
                                        diff = fn_calc_diff(popupDueFrom, popupDueTo);
                                        if (diff < 0) {
                                            extAlert("이후 날짜가 이전 날짜보다 작습니다.<br/>다시 한번 확인해주십시오.");
                                            value.setValue("");
                                            $('#popupDateTo').val("");
                                            return;
                                        } else {
                                            $('#popupDateTo').val(Ext.Date.format(result, 'Y-m-d'));
                                        }
                                    }
                                }
                            }
                        },
                    },
                    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
                },
                '가공처', {
                    xtype: 'textfield',
                    name: 'searchCustomerName',
                    clearOnReset: true,
                    hideLabel: true,
                    width: 250,
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

                            if (chk == true) {
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
                            extAlert("외주발주 정보를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (checkqty > 0) {
                            extAlert("다른 가공처명을 선택하셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (count4 == 0) {
                            console.log("[적용] 외주발주 정보가 없습니다.");
                        } else {
                            for (var j = 0; j < count4; j++) {
                                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
                                var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                                var chk = model4.data.CHK;

                                if (chk === true) {
                                    var model = Ext.create(gridnms["model.1"]);
                                    var store = Ext.getStore(gridnms["store.1"]);

                                    // 순번
                                    model.set("TRADESEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("ITEMCODE", model4.data.ITEMCODE);
                                    model.set("ORDERNAME", model4.data.ORDERNAME);
                                    model.set("ITEMNAME", model4.data.ITEMNAME);
                                    model.set("MODEL", model4.data.MODEL);
                                    model.set("MODELNAME", model4.data.MODELNAME);
                                    model.set("ITEMSTANDARDDETAIL", model4.data.ITEMSTANDARDDETAIL);
                                    model.set("ROUTINGNAME", model4.data.ROUTINGNAME);
                                    model.set("UOM", model4.data.UOM);
                                    model.set("UOMNAME", model4.data.UOMNAME);
                                    model.set("ORDERQTY", model4.data.TRANSQTY);
                                    model.set("BEFOREQTY", model4.data.BEFOREQTY);
                                    model.set("TRANSACTIONQTY", model4.data.TRADEQTY);
                                    model.set("OUTPONO", model4.data.OUTPONO);
                                    model.set("OUTPOSEQ", model4.data.OUTPOSEQ);
                                    model.set("UNITPRICE", model4.data.UNITPRICE);

                                    model.set("OUTTRANSYN", "N");

                                    model.set("CHARGEQTY", model4.data.CHARGEQTY);
                                    model.set("CHARGETYPE", model4.data.CHARGETYPE);
                                    model.set("CHARGETYPENAME", model4.data.CHARGETYPENAME);

                                    var qty = model4.data.TRADEQTY * 1;
                                    if (model4.data.CHARGETYPE == "02") {
                                        qty = model4.data.CHARGEQTY * 1;
                                    }

                                    var supplyprice = qty * (model4.data.UNITPRICE * 1);
                                    model.set("SUPPLYPRICE", supplyprice);

                                    var addtax = Math.round(supplyprice * 0.1);
                                    model.set("ADDITIONALTAX", addtax);

                                    var total = (supplyprice * 1) + (addtax * 1);
                                    model.set("TOTALQTY", total);

                                    var customercode = $('#CustomerCode').val();
                                    if (customercode == "") {
                                        $('#CustomerCode').val(model4.data.CUSTOMERCODE);
                                        $('#CustomerName').val(model4.data.CUSTOMERNAME);
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

        var customername = $('#CustomerName').val();
        if (customername == "") {
            $('#popupCustomerName').val("");
            $('input[name=searchCustomerName]').val("");
            $('input[name=searchCustomerName]').attr('disabled', false).removeClass('ui-state-disabled');
        } else {
            $('#popupCustomerName').val(customername);
            $('input[name=searchCustomerName]').val(customername);
            $('input[name=searchCustomerName]').attr('disabled', true).addClass("ui-state-disabled");
        }
    }
}

function fn_popup_search() {
    global_popup_flag = false;
    var sparams3 = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        SEARCHFROM: $('#popupDateFrom').val(),
        SEARCHTO: $('#popupDateTo').val(),
        CUSTOMERNAME: $('#popupCustomerName').val(),
    };
    extGridSearch(sparams3, gridnms["store.4"]);
}

function fn_save() {
    // 필수 체크
    var TradeDate = $('#TradeDate').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    if (TradeDate === "") {
        header.push("발행일자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    // 저장
    var tradeno = $('#TradeNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = tradeno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/scm/trade/OutProcTradeMasterList.do' />";
        url1 = "<c:url value='/insert/scm/trade/OutProcTradeDetailList.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/scm/trade/OutProcTradeMasterList.do' />";
        url1 = "<c:url value='/update/scm/trade/OutProcTradeDetailList.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('외주 거래명세서 등록', '저장 하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: $("#master").serialize(),
                    success: function (data) {
                        var OrgId = data.searchOrgId;
                        var CompanyId = data.searchCompanyId;
                        var TradeNo = data.TRADENO;
                        var TradeDate = data.TradeDate;

                        if (TradeNo.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", OrgId);
                                model.set("COMPANYID", CompanyId);
                                model.set("TRADENO", TradeNo);

                                if (model.data.TRADENO != '') {
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
                                            go_url("<c:url value='/scm/trade/OutProcTradeManage.do?no=' />" + TradeNo + "&org=" + OrgId + "&company=" + CompanyId + "&tradedate=" + TradeDate);
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
                Ext.Msg.alert('외주 거래명세서 생성', '외주 거래명세서 생성이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('외주 거래명세서 변경 알림', '외주 거래명세서를 변경하시겠습니까?', function (btn) {
            if (btn == 'yes') {

                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: $("#master").serialize(),
                    success: function (data) {
                        var OrgId = data.searchOrgId;
                        var CompanyId = data.searchCompanyId;
                        var TradeNo = data.TradeNo;

                        if (TradeNo.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", OrgId);
                                model.set("COMPANYID", CompanyId);
                                model.set("TRADENO", TradeNo);

                                if (model.data.TRADENO != '') {
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
                                            go_url("<c:url value='/scm/trade/OutProcTradeManage.do?no=' />" + TradeNo + "&org=" + OrgId + "&company=" + CompanyId);
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
                Ext.Msg.alert('외주 거래명세서 변경', '외주 거래명세서 변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var TradeNo = $('#TradeNo').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;

    if (TradeNo === "") {
        header.push("거래명세서 번호");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        result = false;
        return result;
    }

    return result;
}

function fn_search() {
    if (!fn_validation())
        return;

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var TradeNo = $('#TradeNo').val();
    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TRADENO: TradeNo,
    };

    url = "<c:url value='/select/scm/trade/OutProcTradeMasterList.do' />";
    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            //        var tradeno = dataList.TRADENO;
            var tradedate = dataList.TRADEDATE;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var modqty = dataList.MODQTY;
            var remarks = dataList.REMARKS;

            //        $("#TradeNo").val(tradeno);
            $("#TradeDate").val(tradedate);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#ModQty").val(modqty);
            $("#Remarks").val(remarks);

            global_close_yn = fn_monthly_close_filter_data(tradedate, 'SCM');
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

    var tradeno = $('#TradeNo').val();
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var url = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount > 0) {
        extAlert("[상세 데이터]<br/> 상세 데이터가 있습니다. <br/>상세 데이터 삭제 후 마스터 정보를 삭제해주세요.");
        return false;
    }

    if (tradeno == "") {
        extAlert("[마스터 데이터]<br/> 미등록 상태에서는 삭제가 불가능 합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    url = "<c:url value='/delete/scm/trade/OutProcTradeMasterList.do' />";

    Ext.MessageBox.confirm('삭제 알림', '데이터를 삭제하시겠습니까?', function (btn) {
        if (btn == 'yes') {

            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: $("#master").serialize(),
                success: function (data) {
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
            Ext.Msg.alert('삭제', '데이터 삭제가 취소되었습니다.');
            return;
        }
    });
}

function fn_list() {
    go_url("<c:url value='/scm/trade/OutProcTradeList.do'/>");
}

function fn_add() {
    go_url("<c:url value='/scm/trade/OutProcTradeManage.do' />");
}

function fn_print() {
    var orgid = $('#searchOrgId').val();
    var companyid = $('#searchCompanyId').val();
    var tradeno = $('#TradeNo').val();
    var tradedate = $("#TradeDate").val();
    var reportsize = Math.ceil(("${searchVO.reportsize}" * 1) / 9);

    var header = [],
    count = 0;

    var url = null;

    //     for (var i = 0; i < reportsize; i++) {
    //         url = "<c:url value='/report/ScmOutTransactionDetailsReport.pdf?ORGID='/>" + orgid
    //              + "&COMPANYID=" + companyid
    //              + "&TRADENO=" + tradeno
    //              + "&TRADEDATE=" + tradedate
    //              + "&STARTNUM=" + (i + 1);

    //         window.open(url, "거래명세서" + i, "");
    //     }
    url = "<c:url value='/report/ScmOutTransactionA4Report.pdf?ORGID='/>" + orgid
         + "&COMPANYID=" + companyid
         + "&TRADENO=" + tradeno
         + "&TRADEDATE=" + tradedate;

    window.open(url, "거래명세서", "");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
    if ("${searchVO.CustomerCode}" == "") {
        // 가공처 Lov
        $("#CustomerName").bind("keydown", function (e) {
            switch (e.keyCode) {
            case $.ui.keyCode.TAB:
                if ($(this).autocomplete("instance").menu.active) {
                    e.preventDefault();
                }
                break;
            case $.ui.keyCode.BACKSPACE:
            case $.ui.keyCode.DELETE:
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
                    ORGID: $('#searchOrgId option:selected').val(),
                    COMPANYID: $('#searchCompanyId option:selected').val(),
                    CUSTOMERTYPE2: 'O',
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
    }
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
														<li>거래명세서관리</li>
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
										<input type="hidden" id="popupCustomerName" name="popupCustomerName" />
										<input type="hidden" id="popupDateFrom" name="popupDateFrom" />
                    <input type="hidden" id="popupDateTo" name="popupDateTo" />
										<fieldset style="width: 100%">
												<legend>조건정보 영역</legend>
												<form id="master" name="master" action="" method="post">
                            <input type="hidden" id="CustomerCode" name="CustomerCode" />
														<div>
																<table class="tbl_type_view" border="0">
																		<colgroup>
																						<col width="18%">
																						<col width="18%">
																						<col width="64%">
																		</colgroup>
																		<tr style="height: 34px;">
																						<td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 90%;">
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
																						<td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 90%;">
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
																														<a id="btnChk1" class="btn_popup" href="#" onclick="javascript:btnSel1();"> 외주발주 불러오기 </a>
<%--                                                            <c:choose> --%>
<%--                                                                 <c:when test="${empty searchVO.TRADENO}"> --%>
<!--                                                                     <a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a> -->
<%--                                                                 </c:when> --%>
<%--                                                                 <c:otherwise> --%>
<%--                                                                 </c:otherwise> --%>
<%--                                                             </c:choose> --%>
<%--                                                             <sec:authorize ifNotGranted="ROLE_SCM,ROLE_SCM_R,ROLE_SCM_A"> --%>
                                                                <a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
                                                                <a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete();"> 삭제 </a>
<%--                                                             </sec:authorize> --%>
																														<a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
																														<a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
																														<a id="btnChk6" class="btn_print" href="#" onclick="javascript:fn_print();"> 거래명세서 출력 </a>
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
                                        <th class="required_text">거래명세서 번호</th>
                                        <td><input type="text" id="TradeNo" name="TradeNo" class="input_center" style="width: 97%;" value="${searchVO.TRADENO}" readonly /></td>
																				<th class="required_text">발행일자</th>
																				<td><input type="text" id="TradeDate" name="TradeDate" class="input_validation input_center" style="width: 97%;" maxlength="10" /></td>
                                        <th class="required_text">가공처</th>
                                        <td><input type="text" id="CustomerName" name="CustomerName" class="input_center" style="width: 97%;" /> 
                                        </td>
                                        <th class="required_text">수정품(수량)</th>
                                        <td>
                                            <input type="text" id="ModQty" name="ModQty" class=" input_right" style="width: 97%;" />
                                        </td>
																		</tr>
																		<tr style="height: 34px;">
																				<th  class="required_text">비고</th>
																				<td colspan = "7"><textarea id="Remarks" name="Remarks" class="input_left" style="width: 99%;" ></textarea></td>
																		</tr>
																</table>
														</div>
												</form>
										</fieldset>
								</div>
								<!-- //검색 필드 박스 끝 -->

                <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
						</div>
						<!-- //content 끝 -->
				</div>
				<!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 1400px; padding-top: 0px; float: left;"></div>

				<!-- footer 시작 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
				<!-- //footer 끝 -->
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>