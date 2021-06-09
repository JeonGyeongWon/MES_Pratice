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
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    // 팝업창 추가
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
    gridnms["app"] = "purchase";

    calender($('#RequestDate'));

    $('#RequestDate').keyup(function (event) {
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

    var porno = $('#PorNo').val();
    if (porno != "") {
        fn_search();
    } else {
        $("#RequestDate").val(getToDay("${searchVO.TODAY}") + "");

        // 2016.10.04. 관리자 권한 외 사용자 로그인시 담당자에 이름 표기
        var groupid = "${searchVO.groupId}";
        switch (groupid) {
        case "ROLE_ADMIN":
            // 관리자 권한일 때 그냥 놔둠
            break;
        default:
            // 관리자 외 권한일 때 사용자명 표기
            $('#RequestPersonName').val("${searchVO.KRNAME}");
            $('#RequestPerson').val("${searchVO.EMPLOYEENUMBER}");
            break;
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

    gridnms["grid.1"] = "purchaseDetail";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.detail"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.detail"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

    gridnms["models.detail"].push(gridnms["model.1"]);

    gridnms["stores.detail"].push(gridnms["store.1"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'string',
            name: 'PORNO',
        }, {
            type: 'number',
            name: 'PORSEQ',
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
            name: 'REQUESTQTY',
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
            name: 'ORDERFINISHYN',
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
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'checkbox',
            },
            renderer: function (value, meta, record, row, col) {

                var result = $('#ConfirmStatus').val();

                if (result == "COMPLETE") {
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
                        var result = $('#ConfirmStatus').val();

                        if (result == "COMPLETE") {
                            extAlert("확정 완료된 경우 요청삭제가 불가능합니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }
                    }
                }
            },
        }, {
            dataIndex: 'PORSEQ',
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
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'ORDERNAME',
            text: '품번',
            xtype: 'gridcolumn',
            width: 280,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            summaryRenderer: function (value, meta, record) {
                value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>TOTAL</div>";
                return value;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
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
                meta.style = "background-color:rgb(234, 234, 234)";
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
            dataIndex: 'REQUESTQTY',
            text: '요청수량',
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
                        store.set("ADDITIONALTAX", addtax);

                        store.set("TOTAL", supplyprice * 1 + addtax * 1);
                    },
                },
            },
            renderer: function (value, meta, record) {
                var ConfirmStatus = $('#ConfirmStatus').val();
                var OrderFinishYn = $('#OrderFinishYn').val();

                if (OrderFinishYn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                } else {
                    if (ConfirmStatus == "COMPLETE" || ConfirmStatus == "CANCEL") {
                        meta.style = "background-color:rgb(234, 234, 234)";
                    } else {
                        meta.style = "background-color:rgb(253, 218, 255)";
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

                        var qty = store.data.REQUESTQTY;
                        var tqty = store.data.REQUESTQTY;
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
                        store.set("ADDITIONALTAX", addtax);

                        store.set("TOTAL", supplyprice * 1 + addtax * 1);
                    },
                },
            },
            renderer: function (value, meta, record) {
                var ConfirmStatus = $('#ConfirmStatus').val();
                var OrderFinishYn = $('#OrderFinishYn').val();

                if (OrderFinishYn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                } else {
                    if (ConfirmStatus == "COMPLETE" || ConfirmStatus == "CANCEL") {
                        meta.style = "background-color:rgb(234, 234, 234)";
                    } else {
                        meta.style = "background-color:rgb(253, 218, 255)";
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
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
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
                var ConfirmStatus = $('#ConfirmStatus').val();
                var OrderFinishYn = $('#OrderFinishYn').val();

                if (OrderFinishYn == "Y") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                } else {
                    if (ConfirmStatus == "COMPLETE" || ConfirmStatus == "CANCEL") {
                        meta.style = "background-color:rgb(234, 234, 234)";
                    } else {
                        //              meta.style = "background-color:rgb(253, 218, 255)";
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
            dataIndex: 'PORNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/purchase/request/PurchaseRequestDetailList.do' />"
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

var global_popup_flag = false;
function btnSel1(btn) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var PorNo = $('#PorNo').val();
    var RequestDate = $('#RequestDate').val();
    var RequestPerson = $('#RequestPerson').val();
    var CustomerCode = $('#CustomerCode').val();
    var dataSuccess = 0;

    var OrderFinishYn = $('#OrderFinishYn').val();
    if (OrderFinishYn === "Y") {
        extAlert("구매 발주내역에서 확정되어 자재 불러오기가 불가능 합니다.");
        return false;
    }

    var ConfirmStatus = $('#ConfirmStatus').val();
    if (ConfirmStatus === "COMPLETE") {
        extAlert("요청 완료상태에서 자재 불러오기가 불가능 합니다.");
        return false;
    }

    // 자재불러오기 팝업
    var width = 1209; // 가로
    var height = 640; // 세로
    var title = "자재불러오기 Popup";

    var check = true;

    global_popup_flag = false;
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
        $('#popupModelName').val("");
        $('#popupItemStandard').val("");
        $('#popupItemName').val("");
        $('#popupOrderName').val("");
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

                        if (checknum > 1) {
                            for (var s = 1; s < count4; s++) {
                                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(s));
                                var models = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                                var chks = models.data.CHK;
                                var customercodes = models.data.CUSTOMERCODE;
                                if (chks) {
                                    for (var t = 0; t < s; t++) {
                                        Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(t));
                                        var modelt = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                                        var chkt = modelt.data.CHK;
                                        var customercodet = modelt.data.CUSTOMERCODE;
                                        if (chkt) {
                                            if (customercodes != customercodet) {
                                                extAlert("동일한 거래처만 적용이 가능합니다.");
                                                return;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if ($("#CustomerCode").val() != "") {
                            for (var f = 0; f < count4; f++) {
                                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(f));
                                var modelf = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                                var chkf = modelf.data.CHK;

                                if (chkf) {
                                    if ($("#CustomerCode").val() != modelf.data.CUSTOMERCODE) {
                                        extAlert("동일한 거래처만 적용이 가능합니다.");
                                        return;
                                    }
                                }
                            }
                        }

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
                                    model.set("PORSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("ITEMCODE", model4.data.ITEMCODE);
                                    model.set("ITEMNAME", model4.data.ITEMNAME);
                                    model.set("ORDERNAME", model4.data.ORDERNAME);
                                    model.set("UOM", model4.data.UOM);
                                    model.set("UOMNAME", model4.data.UOMNAME);
                                    model.set("UNITPRICE", model4.data.SALESPRICE);
                                    model.set("REQUESTQTY", 0);

                                    model.set("ITEMSTANDARD", model4.data.ITEMSTANDARD);
                                    model.set("MATERIALTYPE", model4.data.MATERIALTYPE);

                                    $("#CustomerName").val(model4.data.CUSTOMERNAME);
                                    $("#CustomerCode").val(model4.data.CUSTOMERCODE);

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
        extAlert("구매요청하실 때만 자재불러오기가 가능합니다.");
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

var btn_click = false;
function btnChk1Click() {
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var checkTrue = 0,
    checkFalse = 0;

    btn_click = !btn_click;

    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

        var OrderFinishYn = $('#OrderFinishYn').val();
        var ConfirmStatus = $('#ConfirmStatus').val();
        if (OrderFinishYn == "Y" || ConfirmStatus == "COMPLETE") {}
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
    var OrderFinishYn = $('#OrderFinishYn').val();
    var ConfirmStatus = $('#ConfirmStatus').val();
    var porno = $('#PorNo').val();
    var porseq = "";
    var url = "<c:url value='/delete/purchase/request/PurchaseRequestEtcMaster.do' />";

    if (record === undefined) {
        extAlert("삭제하실 데이터를 선택 해 주십시오.");
        return;
    }
    var gridcount = store.count() * 1;
    if (gridcount == 0) {
        extAlert("삭제하실 데이터가 없습니다.");
        return;
    }

    if (OrderFinishYn == "Y") {
        extAlert("[삭제 불가]<br/>해당 항목은 구매 발주내역에서 확정되어 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    if (ConfirmStatus == "COMPLETE") {
        extAlert("[삭제 불가]<br/>해당 항목은 확정 완료되어 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
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
                        porno = model.data.PORNO;
                        porseq = model.data.PORSEQ;

                        if (porno == "") {
                            // 데이터 등록되지 않은 건
                            deletecount++;
                            store.remove(model);
                        } else {
                            // 데이터 등록 건

                            var sparams = {
                                ORGID: orgid,
                                COMPANYID: companyid,
                                PORNO: porno,
                                PORSEQ: porseq,
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
                                        go_url("<c:url value='/purchase/request/PurchaseRequestManage.do?reqno=' />" + porno + "&org=" + orgid + "&company=" + companyid);

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
                porseq = record.data.PORSEQ;

                if (porno == "") {
                    store.remove(model);
                } else {

                    var sparams = {
                        ORGID: orgid,
                        COMPANYID: companyid,
                        PORNO: porno,
                        PORSEQ: porseq,
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
                                go_url("<c:url value='/purchase/request/PurchaseRequestManage.do?reqno=' />" + porno + "&org=" + orgid + "&company=" + companyid);
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
                                PORNO: "${searchVO.REQUESTNO}",
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

        // 2016.07.27 추가 제외, 제품선택 (팝업창) 추가
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
                    itemId: 'btnList',
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ITEMSTANDARD') >= 0 || column.dataIndex.indexOf('MATERIALTYPE') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 80) {
                                        column.width = 80;
                                    }
                                }
                                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
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
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = [];
                                var OrderFinishYn = $('#OrderFinishYn').val();
                                if (OrderFinishYn == "Y") {
                                    editDisableCols.push("PORSEQ");
                                    editDisableCols.push("REQUESTQTY");
                                    editDisableCols.push("UNITPRICE");
                                    editDisableCols.push("REMARKS");
                                } else {
                                    var ConfirmStatus = $('#ConfirmStatus').val();
                                    if (ConfirmStatus == "COMPLETE" || ConfirmStatus == "CANCEL") {
                                        editDisableCols.push("PORSEQ");
                                        editDisableCols.push("REQUESTQTY");
                                        editDisableCols.push("UNITPRICE");
                                        editDisableCols.push("REMARKS");
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
                                c.cascade(function (field) {
                                    var xtypeChains = field.xtypesChain;

                                    var isField = Ext.Array.findBy(xtypeChains, function (item) {

                                        if (item == 'displayfield') {
                                            return false;
                                        }

                                        if (item == 'field') {
                                            return true;
                                        }
                                    });
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

                                        if (thisField.isShiftKeyPressed == false && (e.getKey() == e.ENTER || e.getKey() == e.TAB)) { // tab 이나 enter 누름 다음 field 포커싱하도록함.
                                            this.nextField.focus();
                                            e.stopEvent();

                                        } else if (thisField.isShiftKeyPressed == true && e.getKey() == e.TAB) {
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

var gridpopup1;
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
                                MATGROUPCODE: 'Y',
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

function fn_save() {
    // 필수 체크
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var RequestDate = $('#RequestDate').val();
    var RequestPerson = $('#RequestPerson').val();
    var CustomerCode = $('#CustomerCode').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (RequestDate === "") {
        header.push("요청일");
        count++;
    }
    if (RequestPerson === "") {
        header.push("요청자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    var mcount1 = Ext.getStore(gridnms["store.1"]).count();
    for (var i = 0; i < mcount1; i++) {
        var model = Ext.getStore(gridnms["store.1"]).data.items[i].data;
        var header = [],
        gubun = null; ;
        // 미입력 사항 체크
        var itemcode = model.ITEMCODE + "";
        if (itemcode.length == 0) {
            header.push("품명");
            count++;
        }

        if (count > 0) {
            extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
            return;
        }
    }

    var OrderFinishYn = $('#OrderFinishYn').val();
    if (OrderFinishYn == "Y") {
        extAlert("구매 발주내역에서 확정되어 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    var ConfirmStatus = $('#ConfirmStatus').val();
    if (ConfirmStatus == "COMPLETE") {
        extAlert("확정 완료되어 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    // 저장
    var porno = $('#PorNo').val();
    var Orgid = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = porno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/>요청 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/purchase/request/PurchaseRequestManage.do' />";
        url1 = "<c:url value='/insert/purchase/request/PurchaseRequestEtcMaster.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/purchase/request/PurchaseRequestManage.do' />";
        url1 = "<c:url value='/update/purchase/request/PurchaseRequestEtcMaster.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('구매요청 알림', '저장 하시겠습니까?', function (btn) {
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
                        var pono = data.PORNO;

                        if (pono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("PORNO", pono);

                                if (model.data.PORNO != '') {
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
                                            msg = "요청한 구매 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/purchase/request/PurchaseRequestManage.do?reqno=' />" + pono + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('구매요청 등록', '등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('구매요청 변경 알림', '요청을 변경하시겠습니까?', function (btn) {
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
                        var pono = data.PorNo;

                        if (pono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("PORNO", pono);
                                if (model.data.PORNO != '') {
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
                                            msg = "요청한 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/purchase/request/PurchaseRequestManage.do?reqno=' />" + pono + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('구매요청 변경', '변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_search() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var PorNo = $('#PorNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        PORNO: PorNo,
    };

    url = "<c:url value='/searchPorNoListLov.do' />";
    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var porno = dataList.PORNO;
            var requestdate = dataList.REQUESTDATE;
            var requestperson = dataList.REQUESTPERSON;
            var requestpersonname = dataList.REQUESTPERSONNAME;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var remarks = dataList.REMARKS;
            var confirmstatus = dataList.CONFIRMSTATUS;
            var confirmstatusname = dataList.CONFIRMSTATUSNAME;
            var orderfinishyn = dataList.ORDERFINISHYN;

            $("#PorNo").val(porno);
            $("#RequestDate").val(requestdate);
            $("#RequestPerson").val(requestperson);
            $("#RequestPersonName").val(requestpersonname);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#Remarks").val(remarks);
            $("#ConfirmStatus").val(confirmstatus);
            $("#ConfirmStatusName").val(confirmstatusname);
            $("#OrderFinishYn").val(orderfinishyn);

            global_close_yn = fn_monthly_close_filter_data(requestdate, 'MAT');
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

    var porno = $('#PorNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var url = "";
    var OrderFinishYn = $('#OrderFinishYn').val();
    var ConfirmStatus = $('#ConfirmStatus').val();

    if (porno == "") {
        extAlert("[삭제 불가]<br/>요청 정보가 등록되지 않아 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    if (OrderFinishYn == "Y") {
        extAlert("[삭제 불가]<br/>해당 항목은 구매 발주내역에서 확정되어 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    if (ConfirmStatus == "COMPLETE") {
        extAlert("[삭제 불가]<br/>해당 항목은 확정 완료되어 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount > 0) {
        extAlert("[상세 데이터]<br/>상세 데이터가 있습니다.<br/>상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return false;
    }

    url = "<c:url value='/delete/purchase/request/PurchaseRequestManage.do' />";

    Ext.MessageBox.confirm('구매요청 삭제 알림', '요청 데이터를 삭제하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: $("#master").serialize(),
                success: function (data) {
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

function fn_status_change(flag) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var PorNo = $('#PorNo').val();
    var ConfirmStatus = $('#ConfirmStatus').val();
    var OrderFinishYn = $('#OrderFinishYn').val();
    if (PorNo == "") {
        extAlert("[미등록]<br/>구매요청 등록이 되어있지 않아 상태변경이 불가능 합니다.<br/>다시 한번 확인해주세요.");
        return;
    }

    var title_name = "";
    if (flag == "COMPLETE") {
        title_name = "완료";
        if (ConfirmStatus == "COMPLETE") {
            extAlert("[확인]<br/>이미 완료처리되어 상태 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        }
    } else if (flag == "STAND_BY") {
        title_name = "대기";

        if (ConfirmStatus == "CANCEL") {
            extAlert("[확인]<br/>취소처리되어 상태 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        } else if (ConfirmStatus == "STAND_BY") {
            extAlert("[확인]<br/>대기상태일 때 확정 취소 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        }

        if (OrderFinishYn == "Y") {
            extAlert("[확인]<br/>해당 내역들이 발주 확정되어있어 상태 변경이 불가능합니다.<br/>다시 한번 확인해주세요.");
            return;
        }
    }

    url = "<c:url value='/change/purchase/request/PurchaseRequestStatus.do' />";

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        PORNO: PorNo,
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
    go_url("<c:url value='/purchase/request/PurchaseRequestList.do'/>");
}

function fn_add() {
    go_url("<c:url value='/purchase/request/PurchaseRequestManage.do' />");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
    // 요청자 Lov
    $("#RequestPersonName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#RequestPerson").val("");
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
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.VALUE,
                            label: m.LABEL,
                            DEPTCODE: m.DEPTCODE,
                            DEPTNAME: m.DEPTNAME,
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
            $("#RequestPerson").val(o.item.value);
            $("#RequestPersonName").val(o.item.label);

            return false;
        }
    });

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
						<div id="content" style="padding-bottom: 0px;">
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
												<form id="master" name="master" action="" method="post" onkeydown="return fn_key_break(event, 13)">
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
																						<a id="btnChk1" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
																						<a id="btnChk2" class="btn_delete" href="#" onclick="javascript:fn_delete();"> 삭제 </a>
																						<a id="btnChk3" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
																						<a id="btnChk4" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
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
																		<th class="required_text">요청번호</th>
																		<td><input type="text" id="PorNo" name="PorNo" class="input_center" style="width: 97%;" value="${searchVO.REQUESTNO}" readonly /></td>
																		<th class="required_text">요청일</th>
																		<td><input type="text" id="RequestDate" name="RequestDate" class="input_validation input_center" style="width: 97%;" maxlength="10" /></td>
                                    <th class="required_text">공급사</th>
                                    <td><input type="text" id="CustomerName" name="CustomerName" class="input_center" style="width: 97%;" />
                                    <input type="hidden" id="CustomerCode" name="CustomerCode" /></td>
																		<th class="required_text">요청자</th>
																		<td><input type="text" id="RequestPersonName" name="RequestPersonName" class="input_validation input_center" style="width: 97%;" />
																		<input type="hidden" id="RequestPerson" name="RequestPerson" /></td>
																</tr>
																<tr style="height: 34px;">
																		<th class="required_text">확정상태</th>
																		<td><input type="text" id="ConfirmStatusName" name="ConfirmStatusName" class="input_center" style="width: 97%;" readonly />
																		<input type="hidden" id="ConfirmStatus" name="ConfirmStatus" />
																		<input type="hidden" id="OrderFinishYn" name="OrderFinishYn" /></td>
																		<td colspan="6">
																				<div class="buttons" style="float: center; margin-top: 3px;">
																						<a id="btnChk100" class="btn_list" href="#" onclick="javascript:fn_status_change('COMPLETE');"> 확정 완료 </a>
																						<a id="btnChk101" class="btn_list" href="#" onclick="javascript:fn_status_change('STAND_BY');"> 확정 취소 </a>
																				</div>
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
								<div id="gridArea" style="width: 100%; padding-bottom: 0px; float: left;"></div>
						</div>
						<!-- //content 끝 -->
				</div>
				<!-- //container 끝 -->
				<div id="gridPopup1Area" style="width: 1200px; padding-top: 0px; float: left;"></div>

				<!-- footer 시작 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
				<!-- //footer 끝 -->
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>