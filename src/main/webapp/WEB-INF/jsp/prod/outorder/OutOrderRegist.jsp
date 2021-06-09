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
</style>
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    // 제품선택 팝업창 추가
    setValues_Popup();
    setExtGrid_Popup();

    setValues_Popup2();
    setExtGrid_Popup2();

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
    gridnms["app"] = "prod";

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

    $("#PoFrom").val(getToDay("${searchVO.dateFrom}") + "");
    $("#PoTo").val(getToDay("${searchVO.dateTo}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });
}

function setLastInitial() {

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

    gridnms["grid.1"] = "ProdOutOrderDetail";
    gridnms["grid.2"] = "routingnameLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.detail"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.detail"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

    gridnms["models.detail"].push(gridnms["model.1"]);
    gridnms["models.detail"].push(gridnms["model.2"]);

    gridnms["stores.detail"].push(gridnms["store.1"]);
    gridnms["stores.detail"].push(gridnms["store.2"]);

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
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'number',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'number',
            name: 'ORDERQTY',
            //      }, {
            //        type: 'number',
            //        name: 'TRANSQTY',
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
            type: 'date',
            name: 'DUEDATE',
            dateFormat: 'Y-m-d'
        }, {
            type: 'string',
            name: 'OUTPONO',
        }, {
            type: 'string',
            name: 'OUTPOSEQ',
        }, {
            type: 'string',
            name: 'WORKSTATUS',
        }, {
            type: 'string',
            name: 'SCMINSPECTIONYN',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, ];

    fields["model.2"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.1"] = [
        // Display Columns
        {
            dataIndex: 'OUTPOSEQ',
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
            width: 235,
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
            width: 140,
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
            dataIndex: 'WORKORDERID',
            text: '작업지시번호',
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
            dataIndex: 'ROUTINGNAME',
            text: '공정',
            xtype: 'gridcolumn',
            width: 170,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.2"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote', // 'local',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("ROUTINGNO", record.data.VALUE);
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
                var workorderid = record.data.WORKORDERID;
                if (workorderid != "") {
                    meta.style = " background-color:rgb(234, 234, 234); ";
                }
                return value;
            },
        }, {
            dataIndex: 'SCMINSPECTIONYN',
            text: '외주공정<br>검사유무',
            xtype: 'gridcolumn',
            width: 75,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                editable: false,
                xtype: 'combo',
                store: ['Y', 'N'],
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
                        store.set("ADDITIONALTAX", addtax);

                        store.set("TOTAL", supplyprice * 1 + addtax * 1);

                    },
                },
            },
            renderer: function (value, meta, record) {
                var postatus = $('#PoStatus').val();
                if (postatus == "COMPLETE") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                } else {
                    meta.style += " background-color:rgb(253, 218, 255);";
                }
                return Ext.util.Format.number(value, '0,000');
            },
            //       }, {
            //        dataIndex: 'TRANSQTY',
            //        text: '기입고수량',
            //        xtype: 'gridcolumn',
            //        width: 80,
            //        hidden: false,
            //        sortable: false,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        format: "0,000",
            //         renderer: function (value, meta, record) {
            //             meta.style = "background-color:rgb(234, 234, 234)";
            //             return Ext.util.Format.number(value, '0,000');
            //           },
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
                        store.set("ADDITIONALTAX", addtax);

                        store.set("TOTAL", supplyprice * 1 + addtax * 1);

                    },
                },
            },
            renderer: function (value, meta, record) {
                var postatus = $('#PoStatus').val();
                if (postatus == "COMPLETE") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                } else {
                    meta.style += " background-color:rgb(253, 218, 255);";
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
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
                var postatus = $('#PoStatus').val();
                if (postatus == "COMPLETE") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        },
        //      {
        //         dataIndex: 'ORDERFINISHYNNAME',
        //         text: '완료여부',
        //         xtype: 'gridcolumn',
        //         width: 70,
        //         hidden: false,
        //         sortable: false,
        //         align: "center",
        //         editor: {
        //             xtype: 'combobox',
        //             store: ['완료', '미완료'],
        //             editable: false,
        //             listeners: {
        //               select: function (value, record, eOpts) {
        //                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

        //                 if (value.getValue() == "완료") {
        //                   model.set("ORDERFINISHYN", "Y");
        //                 } else if (value.getValue() == "미완료") {
        //                   model.set("ORDERFINISHYN", "N");
        //                 }
        //               },
        //               blur: function (field, e, eOpts) {
        //                 var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
        //                 if (field.getValue() == "") {
        //                   model.set("ORDERFINISHYN", "N");
        //                 }
        //               },
        //             },
        //           },
        //           renderer: function (value, meta, record) {
        //             return value;
        //           },
        //       },
        {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            width: 235,
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
                var postatus = $('#PoStatus').val();
                if (postatus == "COMPLETE") {
                    meta.style = "background-color:rgb(234, 234, 234)";
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
            dataIndex: 'OUTPONO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGNO',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/prod/outorder/OutOrderListDetail.do' />"
    });
    $.extend(items["api.1"], {
        destroy: "<c:url value='/delete/prod/outorder/OutOrderRegistGrid.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "제품선택",
        itemId: "btnSel1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "삭제",
        itemId: "btnDel1"
    });
    //    items["btns.1"].push({
    //      xtype: "button",
    //      text: "자재불러오기",
    //      itemId: "btnSel1"
    //    });

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnSel1": {
            click: 'btnSel1'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnDel1": {
            click: 'btnDel1'
        }
    });
    //    $.extend(items["btns.ctr.1"], {
    //      "#btnSel1": {
    //        click: 'btnSel1'
    //      }
    //    });

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
    var width = 1550; // 가로
    var height = 640; // 500; // 세로
    var title = "제품 불러오기 Popup";
    global_popup_flag = false;

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    // 완료 외 상태에서만 팝업 표시하도록 처리
    $('#popupOrgId').val($('#searchOrgId option:selected').val());
    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
    var emptyValue = "";
    $('#popupBigCode').val(emptyValue);
    $('#popupBigName').val(emptyValue);
    $('#popupMiddleCode').val(emptyValue);
    $('#popupMiddleName').val(emptyValue);
    $('#popupSmallCode').val(emptyValue);
    $('#popupSmallName').val(emptyValue);
    $('#popupItemCode').val(emptyValue);
    $('#popupItemName').val(emptyValue);
    $('#popupCarTypeName').val(emptyValue);
    $('#popupItemStandardD').val(emptyValue);
    $('#popupOrderName').val(emptyValue);
    Ext.getStore(gridnms['store.5']).removeAll();

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
                itemId: gridnms["panel.5"],
                id: gridnms["panel.5"],
                store: gridnms["store.5"],
                height: '100%',
                border: 2,
                scrollable: true,
                frameHeader: true,
                columns: fields["columns.5"],
                viewConfig: {
                    itemId: 'onMypopClick'
                },
                plugins: 'bufferedrenderer',
                dockedItems: items["docked.5"],
            }
        ],
        tbar: [
            '대분류', {
                xtype: 'combo',
                name: 'searchBigCode',
                clearOnReset: true,
                hideLabel: true,
                width: 120,
                store: gridnms["store.10"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
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

                        $('#popupBigCode').val(record.data.VALUE);
                        $('#popupBigName').val(record.data.LABEL);

                        var emptyValue = "";
                        $('#popupMiddleCode').val(emptyValue);
                        $('#popupMiddleName').val(emptyValue);
                        $('#popupSmallCode').val(emptyValue);
                        $('#popupSmallName').val(emptyValue);

                        $('input[name=searchMiddleName]').val(emptyValue);
                        $('input[name=searchSmallName]').val(emptyValue);
                        $('input[name=searchItemName]').val(emptyValue);

                        var sparams1 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                        };
                        extGridSearch(sparams1, gridnms["store.11"]);

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.12"]);
                    },
                    change: function (value, nv, ov, e) {
                        var result = value.getValue();

                        $('#popupBigCode').val(record.data.VALUE);
                        $('#popupBigName').val(record.data.LABEL);

                        var emptyValue = "";
                        $('#popupMiddleCode').val(emptyValue);
                        $('#popupMiddleName').val(emptyValue);
                        $('#popupSmallCode').val(emptyValue);
                        $('#popupSmallName').val(emptyValue);

                        $('input[name=searchMiddleName]').val(emptyValue);
                        $('input[name=searchSmallName]').val(emptyValue);
                        $('input[name=searchItemName]').val(emptyValue);

                        var sparams1 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                        };
                        extGridSearch(sparams1, gridnms["store.11"]);

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.12"]);

                        if (nv !== ov) {
                            if (result === emptyValue) {
                                $('#popupBigCode').val(emptyValue);
                                $('#popupBigName').val(emptyValue);
                                $('#popupMiddleCode').val(emptyValue);
                                $('#popupMiddleName').val(emptyValue);
                                $('#popupSmallCode').val(emptyValue);
                                $('#popupSmallName').val(emptyValue);

                                $('input[name=searchMiddleName]').val(emptyValue);
                                $('input[name=searchSmallName]').val(emptyValue);
                            }
                        }
                    }
                }
            },
            '중분류', {
                xtype: 'combo',
                name: 'searchMiddleCode',
                clearOnReset: true,
                hideLabel: true,
                width: 120,
                store: gridnms["store.11"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
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
                        $('#popupMiddleCode').val(record.data.VALUE);
                        $('#popupMiddleName').val(record.data.LABEL);

                        var emptyValue = "";
                        $('#popupSmallCode').val(emptyValue);
                        $('#popupSmallName').val(emptyValue);

                        $('input[name=searchSmallName]').val(emptyValue);

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.12"]);
                    },
                    change: function (value, nv, ov, e) {
                        var result = value.getValue();

                        $('#popupMiddleCode').val(record.get("VALUE"));
                        $('#popupMiddleName').val(record.get("LABEL"));

                        var emptyValue = "";
                        $('#popupSmallCode').val(emptyValue);
                        $('#popupSmallName').val(emptyValue);

                        $('input[name=searchSmallName]').val(emptyValue);

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.12"]);

                        if (nv !== ov) {

                            if (result === emptyValue) {
                                $('#popupMiddleCode').val(emptyValue);
                                $('#popupMiddleName').val(emptyValue);
                                $('#popupSmallCode').val(emptyValue);
                                $('#popupSmallName').val(emptyValue);

                                $('input[name=searchSmallName]').val(emptyValue);
                            }

                            var sparams2 = {
                                GROUPCODE: $('#popupGroupCode').val(),
                                BIGCODE: $('#popupBigCode').val(),
                                MIDDLECODE: $('#popupMiddleCode').val(),
                            };
                            extGridSearch(sparams2, gridnms["store.12"]);
                        }
                    },
                }
            },
            '소분류', {
                xtype: 'combo',
                name: 'searchSmallCode',
                clearOnReset: true,
                hideLabel: true,
                width: 120,
                store: gridnms["store.12"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
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
                        $('#popupSmallCode').val(record.data.VALUE);
                        $('#popupSmallName').val(record.data.LABEL);
                    },
                    change: function (value, nv, ov, e) {
                        var result = value.getValue();

                        if (nv !== ov) {

                            var emptyValue = "";
                            if (result === emptyValue) {
                                $('#popupSmallCode').val(emptyValue);
                                $('#popupSmallName').val(emptyValue);
                            }
                        }
                    },
                }
            },
            '품번', {
                xtype: 'textfield',
                name: 'searchOrderName',
                clearOnReset: true,
                hideLabel: true,
                width: 150,
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
                name: 'searchItemName',
                clearOnReset: true,
                hideLabel: true,
                width: 220,
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
            '기종', {
                xtype: 'textfield',
                name: 'searchCarTypeName',
                clearOnReset: true,
                hideLabel: true,
                width: 150,
                editable: true,
                allowBlank: true,
                listeners: {
                    scope: this,
                    buffer: 50,
                    change: function (value, nv, ov, e) {
                        value.setValue(nv.toUpperCase());
                        var result = value.getValue();

                        $('#popupCarTypeName').val(result);
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
                    var count5 = Ext.getStore(gridnms["store.5"]).count();
                    var checkTrue = 0,
                    checkFalse = 0;

                    global_popup_flag = !global_popup_flag;
                    for (var i = 0; i < count5; i++) {
                        Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
                        var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];

                        var chk = model5.data.CHK;

                        if (global_popup_flag) {
                            model5.set("CHK", true);
                            checkFalse++;
                        } else {
                            model5.set("CHK", false);
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
                    var count5 = Ext.getStore(gridnms["store.5"]).count();
                    var checknum = 0,
                    checkqty = 0,
                    checktemp = 0;
                    var qtytemp = [];

                    for (var i = 0; i < count5; i++) {
                        Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
                        var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                        var chk = model5.data.CHK;
                        if (chk) {
                            checknum++;
                        }
                    }

                    //               var countTemp = Ext.getStore(gridnms["store.1"]).count();
                    //               var seqTemp = 0;
                    //               if (countTemp > 0) {
                    //                 for (var r = 1; r < countTemp; r++) {
                    //                   Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(r));
                    //                   var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                    //                   seqCheck1 = model1.data.OUTPOSEQ;
                    //                   for (var s = 0; s < r; s++) {
                    //                     Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(s));
                    //                     var model2 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                    //                     seqCheck2 = model2.data.OUTPOSEQ;
                    //                     if (seqCheck1 <= seqCheck2) {
                    //                      seqTemp = (seqCheck2 * 1) + 1;
                    //                     } else {
                    //                      seqTemp = (seqCheck1 * 1) + 1;
                    //                     }
                    //                   }
                    //                 }
                    //               } else {
                    //                seqTemp = 1;
                    //               }
                    console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                    if (checknum == 0) {
                        extAlert("선택 된 제품이 없습니다.<br/>다시 한번 확인해주십시오.");
                        return false;
                    }

                    if (count5 == 0) {
                        console.log("[적용] 제품 정보가 없습니다.");
                    } else {
                        for (var j = 0; j < count5; j++) {
                            Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
                            var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                            var chk = model5.data.CHK;
                            if (chk) {
                                var model = Ext.create(gridnms["model.1"]);
                                var store = Ext.getStore(gridnms["store.1"]);

                                // 순번
                                model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);
                                model.set("OUTPONO", $('#PoNo').val());
                                model.set("OUTPOSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);
                                //                     model.set("OUTPOSEQ", seqTemp);

                                // 팝업창의 체크된 항목 이동
                                model.set("SMALLCODE", model5.data.SMALLCODE);
                                model.set("SMALLNAME", model5.data.SMALLNAME);
                                model.set("ITEMCODE", model5.data.ITEMCODE);
                                model.set("ORDERNAME", model5.data.ORDERNAME);
                                model.set("ITEMNAME", model5.data.ITEMNAME);
                                model.set("MODEL", model5.data.CARTYPE);
                                model.set("MODELNAME", model5.data.CARTYPENAME);
                                model.set("ITEMSTANDARDDETAIL", model5.data.ITEMSTANDARDDETAIL);
                                model.set("UOM", model5.data.UOM);
                                model.set("UOMNAME", model5.data.UOMNAME);

                                model.set("SCMINSPECTIONYN", "N");
                                model.set("COMPLETEYN", "N");
                                model.set("DUEDATE", $('#PoDate').val());

                                model.set("UNITPRICE", model5.data.UNITPRICEA); // 단가
                                model.set("SUPPLYPRICE", model5.data.UNITPRICEA); // 공급가액
                                model.set("ORDERQTY", 1); // 수량

                                var tax_rate = 10; // $('#TaxDiv option:selected').attr("data-val");
                                var tax = Math.round((model5.data.UNITPRICEA) * (tax_rate / 100));
                                model.set("ADDITIONALTAX", tax); // 부가세
                                var total = model5.data.UNITPRICEA + tax;
                                model.set("TOTAL", total); // 토탈

                                var emptyValue = "";
                                var postatus = $('#PoStatus').val();
                                if (postatus == emptyValue) {
                                    $('#PoStatus').val('STAND_BY');
                                    $('#PoStatusName').val('대기');
                                }

                                // 그리드 적용 방식
                                store.add(model);

                                //                     seqTemp++; // 수주순번 증가;
                                checktemp++;
                            };
                        }

                        Ext.getCmp(gridnms["panel.1"]).getView().refresh();

                    }

                    if (checktemp > 0) {
                        win11.close();

                        $("#gridPopup1Area").hide("blind", {
                            direction: "up"
                        }, "fast");
                    }
                }
            }
        ]
    });
    win11.show();

    $('input[name=searchBigCode]').bind("mousedown", function (e) {
        fn_popup_search();
    });

    $('input[name=searchMiddleCode]').bind("mousedown", function (e) {
        fn_popup_search();
    });

    $('input[name=searchSmallCode]').bind("mousedown", function (e) {
        fn_popup_search();
    });

    $('input[name=searchOrderName]').bind("keyup", function (e) {
        if (e.keyCode == 13) {
            fn_popup_search();
        }
    });

    $('input[name=searchItemName]').bind("keyup", function (e) {
        if (e.keyCode == 13) {
            fn_popup_search();
        }
    });
}

function fn_popup_search() {
    global_popup_flag = false;
    var params = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        BIGCODE: $('#popupBigCode').val(),
        MIDDLECODE: $('#popupMiddleCode').val(),
        SMALLCODE: $('#popupSmallCode').val(),
        ITEMCODE: $('#popupItemCode').val(),
        ITEMNAME: $('#popupItemName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        ITEMTYPE: $('#popupItemType').val(),
        CARTYPENAME: $('#popupCarTypeName').val(),
    };
    extGridSearch(params, gridnms["store.5"]);
}

function btnDel1() {
    // Detail 삭제
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var store = this.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
    var pono = $('#PoNo').val();
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var PoStatus = $('#PoStatus').val();
    if (PoStatus === "COMPLETE") {
        extAlert("발주상태가 완료 상태에서는 삭제가 불가능 합니다..");
        return false;
    }

    if (record === undefined) {
        return;
    }

    Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            //        store.remove(record);
            //        Ext.getStore(gridnms["store.1"]).sync();

            //        extAlert("정상적으로 삭제 하였습니다.");

            var url = "<c:url value='/delete/prod/outorder/OutOrderRegistGrid.do' />";

            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: record.data,
                success: function (data) {
                    var msg = data.masage;
                    extAlert(msg);

                    var returnstatus = data.success;
                    if (returnstatus) {
                        setInterval(function () {
                            go_url("<c:url value='/prod/outorder/OutOrderManage.do?no=' />" + pono + "&ORGID=" + orgid + "&COMPANYID=" + companyid);

                        }, 1 * 0.5 * 1000);
                    }
                },
                error: ajaxError
            });
        }
    });
}

var global_popup_flag1 = false;
function btnSel2(btn) {
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

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    //    if (TransDate === "") {
    //      header.push("요청일");
    //      count++;
    //    }

    //    var Status = $('#Status').val();
    //    if (Status === "COMPLETE") {
    //      extAlert("결재상태가 승인 상태에서는 자재 불러오기가 불가능 합니다..");
    //      return false;
    //    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    // 외주공정 불러오기 팝업
    var width = 1590; // 가로
    var height = 640; // 500; // 세로
    var title = "외주공정 불러오기 Popup";

    var status = $('#Status').val();
    var check = false;

    var emptyValue = "";
    if (status === emptyValue) {
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

    global_popup_flag1 = false;
    if (check) {
        // 완료 외 상태에서만 팝업 표시하도록 처리
        $('#popupOrgId').val($('#searchOrgId option:selected').val());
        $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
        //$('#popupWorkOrderNo').val($('#PoNo option:selected').val());
        $('#popupCustomerCode').val($('#CustomerCode option:selected').val());
        $('#popupCustomerName').val($('#CustomerName option:selected').val());

        //      $('#popupBigCode').val(emptyValue);
        //      $('#popupBigName').val(emptyValue);
        //      $('#popupMiddleCode').val(emptyValue);
        //      $('#popupMiddleName').val(emptyValue);
        //      $('#popupSmallCode').val(emptyValue);
        //      $('#popupSmallName').val(emptyValue);
        //      $('#popupItemCode').val(emptyValue);
        $('#popupWorkOrderNo').val(emptyValue);
        $('#popupOrderName').val(emptyValue);
        $('#popupItemName').val(emptyValue);
        $('#popupCarTypeName').val(emptyValue);
        $('#popupItemStandardD').val(emptyValue);
        $('#popupRoutingName').val(emptyValue);
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
                '작업지시번호', {
                    xtype: 'textfield',
                    name: 'searchWorkOrderNo',
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

                            $('#popupWorkOrderNo').val(result);
                        },
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
                    width: 120,
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
                '기종', {
                    xtype: 'textfield',
                    name: 'searchModelName',
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

                            $('#popupCarTypeName').val(result);
                        },
                    },
                },
                '타입', {
                    xtype: 'textfield',
                    name: 'searchItemStandardD',
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

                            $('#popupItemStandardD').val(result);
                        },
                    },
                },
                '거래처명', {
                    xtype: 'textfield',
                    name: 'searchCustomerName',
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

                            $('#popupCustomerCodeOutName').val(result);
                        },
                    },
                },
                '공정명', {
                    xtype: 'textfield',
                    name: 'searchRoutingName',
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

                            $('#popupRoutingName').val(result);
                        },
                    },
                }, '->', {
                    text: '조회',
                    scope: this,
                    handler: function () {
                        fn_popup_search2();
                    }
                }, {
                    text: '전체선택/해제',
                    scope: this,
                    handler: function () {
                        // 전체등록 Pop up 전체선택 버튼 핸들러
                        var count44 = Ext.getStore(gridnms["store.44"]).count();
                        var checkTrue = 0,
                        checkFalse = 0;

                        global_popup_flag1 = !global_popup_flag1;
                        for (var i = 0; i < count44; i++) {
                            Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(i));
                            var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];

                            var chk = model44.data.CHK;

                            if (global_popup_flag1) {
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
                            var chk44 = model44.data.CHK;
                            var customer44 = model44.data.CUSTOMERCODEOUT;

                            if (chk44) {
                                var customercd = $("#CustomerCode").val();
                                checknum++;
                                if (customercd == "") {
                                    for (var m = 0; m < count44; m++) {
                                        Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(m));
                                        var model444 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];
                                        var chk444 = model444.data.CHK;
                                        var customer444 = model444.data.CUSTOMERCODEOUT;

                                        if (chk444) {
                                            if (customer44 != customer444) {
                                                checkqty++;
                                            }
                                        }
                                    }
                                } else {
                                    if (customercd != customer44) {
                                        checkqty++;
                                    }
                                }
                            }
                        }
                        console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                        if (checknum == 0) {
                            extAlert("공정정보를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (checkqty > 0) {
                            extAlert("다른 공급사을 선택하셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (count44 == 0) {
                            console.log("[적용] 공정 정보가 없습니다.");
                        } else {
                            for (var j = 0; j < count44; j++) {
                                Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(j));
                                var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];
                                var chk = model44.data.CHK;
                                if (chk) {
                                    var model = Ext.create(gridnms["model.1"]);
                                    var store = Ext.getStore(gridnms["store.1"]);

                                    // 순번
                                    model.set("POSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);
                                    model.set("OUTPOSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    //model.set("OUTPONO", model44.data.ITEMCODE);
                                    //model.set("OUTPOSEQ", model44.data.ITEMNAME);
                                    model.set("ITEMCODE", model44.data.ITEMCODE);
                                    model.set("ORDERNAME", model44.data.ORDERNAME);
                                    model.set("ITEMNAME", model44.data.ITEMNAME);

                                    model.set("MODEL", model44.data.MODEL);
                                    model.set("MODELNAME", model44.data.MODELNAME);
                                    model.set("ITEMSTANDARDDETAIL", model44.data.ITEMSTANDARDDETAIL);
                                    model.set("UOM", model44.data.UOM);
                                    model.set("UOMNAME", model44.data.UOMNAME);

                                    model.set("WORKORDERID", model44.data.WORKORDERID);
                                    model.set("WORKORDERSEQ", model44.data.WORKORDERSEQ);

                                    model.set("ROUTINGNAME", model44.data.ROUTINGNAME);

                                    model.set("ORDERQTY", model44.data.FINISHQTY);
                                    model.set("UNITPRICE", model44.data.CONVERSIONCOST);
                                    model.set("REMARKS", model44.data.REMARKS);
                                    model.set("WORKSTATUS", model44.data.WORKSTATUS);
                                    model.set("SCMINSPECTIONYN", model44.data.INSPECTIONYN);

                                    var postatus = $('#PoStatus').val();
                                    if (postatus == "") {
                                        $('#PoStatus').val('STAND_BY');
                                        $('#PoStatusName').val('대기');
                                    }
                                    //                       $('#PoStatus').val('STAND_BY');
                                    //                       $('#PoStatusName').val('대기');
                                    $('#CustomerCode').val(model44.data.CUSTOMERCODEOUT);
                                    $('#CustomerName').val(model44.data.CUSTOMERNAMEOUT);

                                    //                         model.set("OLDQTY", model44.data.OLDQTY);

                                    //                         var qty = model4.data.QTYDETAIL * 1;
                                    //                         if (qty > 0) {
                                    //                           model.set("ORDERQTY", qty);
                                    //                         } else {
                                    //                           model.set("ORDERQTY", 0);
                                    //                         }


                                    var qty = model44.data.FINISHQTY * 1;
                                    var unitcost = model44.data.CONVERSIONCOST;

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

        var customercode = $('#CustomerCode').val();
        var customername = $('#CustomerName').val();

        if (customercode == emptyValue) {
            $('#popupCustomerCode').val(emptyValue);
            $('input[name=searchCustomerCode]').val(emptyValue);
            $('input[name=searchCustomerCode]').attr('disabled', false).removeClass('ui-state-disabled');

            $('#popupCustomerCodeOutName').val(emptyValue);
            $('input[name=searchCustomerName]').val(emptyValue);
            $('input[name=searchCustomerName]').attr('disabled', false).removeClass('ui-state-disabled');
        } else {
            $('#popupCustomerCode').val(customercode);
            $('input[name=searchCustomerCode]').val(customercode);
            $('input[name=searchCustomerCode]').attr('disabled', true).addClass('ui-state-disabled');

            $('#popupCustomerCodeOutName').val(customername);
            $('input[name=searchCustomerName]').val(customername);
            $('input[name=searchCustomerName]').attr('disabled', true).removeClass('ui-state-disabled');
        }
        fn_popup_search2();
    } else {
        extAlert("발주 등록 하실 경우에만 요청서 불러오기가 가능합니다.");
        return;
    }
}

function fn_popup_search2() {
    global_popup_flag1 = false;
    var params = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        WORKORDERNO: $('#popupWorkOrderNo').val(),
        ITEMCODE: $('#popupItemCode').val(),
        ITEMNAME: $('#popupItemName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        CARTYPENAME: $('#popupCarTypeName').val(),
        ITEMSTANDARDDETAIL: $('#popupItemStandardD').val(),
        CUSTOMERCODEOUT: $('#popupCustomerCode').val(),
        CUSTOMERCODEOUTNAME: $('#popupCustomerCodeOutName').val(),
        ROUTINGNAME: $('#popupRoutingName').val(),
        //                  ITEMTYPE: $('#popupItemType').val(),
    };
    extGridSearch(params, gridnms["store.44"]);
}

var gridarea, gridpopup11, gridpopup1;
function setExtGrid() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"],
    });

    Ext.define(gridnms["model.2"], {
        extend: Ext.data.Model,
        fields: fields["model.2"],
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
                                OUTPONO: $('#PoNo').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.2"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.2"],
                        model: gridnms["model.2"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'MFG',
                                MIDDLECD: 'ROUTING_NAME',
                                GUBUN: 'ROUTING_NAME',
                            },
                            reader: gridVals.reader,
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

        btnSel1: btnSel1,
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
                height: 592,
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
                                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 150) {
                                        column.width = 150;
                                    }
                                }
                                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('MODELNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 80) {
                                        column.width = 80;
                                    }
                                }
                                if (column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
                                    //                       column.autoSize();
                                    column.width += 5;
                                    if (column.width < 180) {
                                        column.width = 180;
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
                                var postatus = $('#PoStatus').val();
                                editDisableCols.push("OUTPOSEQ");
                                if (postatus == "COMPLETE") {
                                    editDisableCols.push("ORDERQTY");
                                    editDisableCols.push("UNITPRICE");
                                    editDisableCols.push("SUPPLYPRICE");
                                    editDisableCols.push("ADDITIONALTAX");
                                    editDisableCols.push("DUEDATE");
                                    editDisableCols.push("REMARKS");
                                }

                                var workorderid = data.data.WORKORDERID;
                                if (workorderid != "") {
                                    editDisableCols.push("ROUTINGNAME");
                                }

                                //                  if (releaseyn == "Y") {
                                //                    editDisableCols.push("ORDERQTY");
                                //                    editDisableCols.push("UNITPRICE");
                                //                    editDisableCols.push("SUPPLYPRICE");
                                //                     editDisableCols.push("ADDITIONALTAX");
                                //                     editDisableCols.push("DUEDATE");
                                //                     editDisableCols.push("REMARKS");
                                //                  } else {
                                //                    var confirmyn = data.data.CONFIRMYN;

                                //                    if (confirmyn == "Y") {
                                //                      editDisableCols.push("PORSEQ");
                                //                    }

                                //                    var status = $('#Status').val();
                                //                    if (status == "COMPLETE") {
                                //                      // 완료시 입력 불가

                                //                      editDisableCols.push("POSEQ");
                                //                      editDisableCols.push("ORDERQTY");
                                //                      editDisableCols.push("UNITPRICE");
                                //                      editDisableCols.push("SUPPLYPRICE");
                                //                      editDisableCols.push("ADDITIONALTAX");
                                //                      editDisableCols.push("DUEDATE");
                                //                    }
                                //                  }

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
                renderTo: 'gridArea'
            });
        },
    });

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
    });
}

// 요청서 불러오기 팝업
function setValues_Popup() {
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
            name: 'ITEMTYPE',
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
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'string',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'ROUTINGNO',
        }, {
            type: 'string',
            name: 'ROUTINGCODE',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'number',
            name: 'CONVERSIONCOST',
        }, {
            type: 'number',
            name: 'IMPORTQTY',
        }, {
            type: 'number',
            name: 'WORKORDERQTY',
        }, {
            type: 'number',
            name: 'ORDERQTY',
        }, {
            type: 'number',
            name: 'FINISHQTY',
        }, {
            type: 'string',
            name: 'CUSTOMERNAMEOUT',
        }, {
            type: 'string',
            name: 'CUSTOMERCODEOUT',
        }, {
            type: 'string',
            name: 'WORKSTATUS',
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
            width: 300,
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
            width: 140,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            align: "center",
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            text: '타입',
            xtype: 'gridcolumn',
            width: 50,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
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
            dataIndex: 'CUSTOMERNAMEOUT',
            text: '거래처',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'WORKORDERID',
            text: '작업지시번호',
            xtype: 'gridcolumn',
            width: 130,
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
            dataIndex: 'CONVERSIONCOST',
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
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'WORKORDERQTY',
            text: '계획수량',
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
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'ORDERQTY',
            text: '기외주<br/>발주수량',
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
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'FINISHQTY',
            text: '잔여수량',
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
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'IMPORTQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKSTATUS',
            xtype: 'hidden',
        }, ];

    items["api.44"] = {};
    $.extend(items["api.44"], {
        read: "<c:url value='/ProdOutOrderWorkOrderList.do' />"
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

function setExtGrid_Popup() {
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
                        autoLoad: false,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.44"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                //                  ORGID: $('#popupOrgId').val(),
                                //                  COMPANYID: $('#popupCompanyId').val(),
                                //                  CUSTOMERCODE: $('#popupCustomerCode').val(),
                                //                  ITEMCODE: $('#popupItemCode').val(),
                                //                  ITEMNAME: $('#popupItemName').val(),
                                //                  ORDERNAME: $('#popupOrderName').val(),
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

function setValues_Popup2() {
    gridnms["models.popup1"] = [];
    gridnms["stores.popup1"] = [];
    gridnms["views.popup1"] = [];
    gridnms["controllers.popup1"] = [];

    gridnms["grid.5"] = "Popup1";
    gridnms["grid.10"] = "BigCodePopup";
    gridnms["grid.11"] = "MiddleCodePopup";
    gridnms["grid.12"] = "SmallCodePopup";

    gridnms["panel.5"] = gridnms["app"] + ".view." + gridnms["grid.5"];
    gridnms["views.popup1"].push(gridnms["panel.5"]);

    gridnms["controller.5"] = gridnms["app"] + ".controller." + gridnms["grid.5"];
    gridnms["controllers.popup1"].push(gridnms["controller.5"]);

    gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
    gridnms["model.10"] = gridnms["app"] + ".model." + gridnms["grid.10"];
    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
    gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];

    gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
    gridnms["store.10"] = gridnms["app"] + ".store." + gridnms["grid.10"];
    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
    gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];

    gridnms["models.popup1"].push(gridnms["model.5"]);
    gridnms["models.popup1"].push(gridnms["model.10"]);
    gridnms["models.popup1"].push(gridnms["model.11"]);
    gridnms["models.popup1"].push(gridnms["model.12"]);

    gridnms["stores.popup1"].push(gridnms["store.5"]);
    gridnms["stores.popup1"].push(gridnms["store.10"]);
    gridnms["stores.popup1"].push(gridnms["store.11"]);
    gridnms["stores.popup1"].push(gridnms["store.12"]);

    fields["model.5"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'string',
            name: 'BIGCODE',
        }, {
            type: 'string',
            name: 'BIGNAME',
        }, {
            type: 'string',
            name: 'MIDDLECODE',
        }, {
            type: 'string',
            name: 'MIDDLENAME',
        }, {
            type: 'string',
            name: 'SMALLCODE',
        }, {
            type: 'string',
            name: 'SMALLNAME',
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
            name: 'CARTYPE',
        }, {
            type: 'string',
            name: 'CARTYPENAME',
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
            name: 'UNITPRICEA',
        }, {
            type: 'number',
            name: 'WEIGHT',
        }, {
            type: 'number',
            name: 'PRESENTINVENTORYQTY',
        }, ];

    fields["model.10"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.11"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.12"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.5"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'rownumberer',
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
            dataIndex: 'BIGNAME',
            text: '대분류',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'MIDDLENAME',
            text: '중분류',
            xtype: 'gridcolumn',
            width: 180,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'SMALLNAME',
            text: '소분류',
            xtype: 'gridcolumn',
            width: 120,
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
            width: 480,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'CARTYPENAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 140,
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
            width: 50,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'UNITPRICEA',
            text: '단가',
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
                return Ext.util.Format.number(value, '0,000');
            },
            //      }, {
            //        dataIndex: 'WEIGHT',
            //        text: '제품중량',
            //        xtype: 'gridcolumn',
            //        width: 95,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        format: "0,000.00",
            //        renderer: function (value, meta, record) {
            //          return Ext.util.Format.number(value, '0,000.00');
            //        },
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
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'PRESENTINVENTORYQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'BIGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'MIDDLECODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'SMALLCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOMNAME',
            xtype: 'hidden',
        }, ];

    items["api.5"] = {};
    $.extend(items["api.5"], {
        read: "<c:url value='/searchOrderItemLovList.do'/>"
    });

    items["btns.5"] = [];

    items["btns.ctr.5"] = {};

    items["dock.paging.5"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.5"],
    };

    items["dock.btn.5"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.5"],
        items: items["btns.5"],
    };

    items["docked.5"] = [];
}

function setExtGrid_Popup2() {
    Ext.define(gridnms["model.5"], {
        extend: Ext.data.Model,
        fields: fields["model.5"],
    });

    Ext.define(gridnms["model.10"], {
        extend: Ext.data.Model,
        fields: fields["model.10"],
    });

    Ext.define(gridnms["model.11"], {
        extend: Ext.data.Model,
        fields: fields["model.11"],
    });

    Ext.define(gridnms["model.12"], {
        extend: Ext.data.Model,
        fields: fields["model.12"],
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
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.5"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#popupOrgId').val(),
                                COMPANYID: $('#popupCompanyId').val(),
                                ITEMTYPE: $('#popupItemType').val(),
                            },
                            reader: gridVals.reader,
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
                            type: "ajax",
                            url: "<c:url value='/searchBigClassListLov.do' />",
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                GROUPCODE: $('#popupGroupCode').val(),
                                GUBUN: 'BIG_CODE',
                            },
                            reader: gridVals.reader,
                        }
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
                            type: "ajax",
                            url: "<c:url value='/searchMiddleClassListLov.do' />",
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                GROUPCODE: $('#popupGroupCode').val(),
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
                            type: "ajax",
                            url: "<c:url value='/searchSmallClassListLov.do' />",
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                GROUPCODE: $('#popupGroupCode').val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.5"], {
        extend: Ext.app.Controller,
        refs: {
            btnPopup1: '#btnPopup1',
        },
        stores: [gridnms["store.5"]],
    });

    Ext.define(gridnms["panel.5"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.5"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.5"],
                id: gridnms["panel.5"],
                store: gridnms["store.5"],
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
                columns: fields["columns.5"],
                viewConfig: {
                    itemId: 'btnPopup1',
                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.5"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup1"],
        stores: gridnms["stores.popup1"],
        views: gridnms["views.popup1"],
        controllers: gridnms["controller.5"],

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

    var PoDate = $('#PoDate').val();
    var PoPerson = $('#PoPerson').val();
    var PoPersonName = $('#PoPerson').val();
    var PoStatus = $('#PoStatus').val();
    var CustomerCode = $('#CustomerCode').val();

    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (PoDate === "") {
        header.push("발주일");
        count++;
    }
    if (PoPerson === "") {
        header.push("발주담당자");
        count++;
    }

    if (CustomerCode === "") {
        header.push("거래처");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    var mcount3 = Ext.getStore(gridnms["store.1"]).count();
    for (var k = 0; k < mcount3; k++) {
        var model = Ext.getStore(gridnms["store.1"]).data.items[k].data;
        var header = [],
        gubun = null;

        // 미입력 사항 체크
        var orderqty = model.ORDERQTY;
        if (orderqty == 0) {
            header.push("발주수량");
            count++;
        }

        if (count > 0) {
            extAlert("[필수항목 미입력]<br/>" + (k + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
            return;
        }
    }

    //    var Status = $('#Status').val();
    //    if (Status === "COMPLETE") {
    //      extAlert("결재상태가 승인 상태에서는 자재 불러오기가 불가능 합니다..");
    //      return false;
    //    }

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
        extAlert("[상세 미등록]<br/> 외주 발주 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/prod/outorder/OutOrderRegist.do' />";
        url1 = "<c:url value='/insert/prod/outorder/OutOrderRegistGrid.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/prod/outorder/OutOrderRegist.do' />";
        url1 = "<c:url value='/update/prod/outorder/OutOrderRegistGrid.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('외주발주 알림', '저장 하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: $("#master").serialize(),
                    success: function (data) {
                        var outpono = data.OUTPONO;
                        var orgid = data.searchOrgId;
                        var companyid = data.searchCompanyId;

                        if (outpono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("OUTPONO", outpono);
                                if (model.data.OUTPONO != '') {
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
                                        var matcheck = conn.responseText;
                                        var temp = matcheck.substr(23, 1);

                                        if (temp == "Y") {
                                            if (msgGubun == 1) {
                                                msg = "해당 자재의 LOT수량이 부족하여 저장에 실패하였습니다.";
                                            } else if (msgGubun == 2) {
                                                msg = "해당 자재의 LOT수량이 부족하여 변경에 실패하였습니다.";
                                            }
                                            extAlert(msg);
                                            return;
                                        } else if (temp == "P") {
                                            if (msgGubun == 1) {
                                                msg = "해당 작지의 첫 공정이 외주가 아니므로<br/>자재출고가 되지 않았습니다.";
                                            } else if (msgGubun == 2) {
                                                msg = "해당 작지의 첫 공정이 외주가 아니므로<br/>자재출고가 되지 않았습니다.";
                                            }
                                            extAlert(msg);
                                        } else {
                                            if (msgGubun == 1) {
                                                msg = "정상적으로 저장 하였습니다.";
                                            } else if (msgGubun == 2) {
                                                msg = "요청한 발주 내역이 변경되었습니다.";
                                            }
                                            extAlert(msg);
                                        }

                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/prod/outorder/OutOrderManage.do?no=' />" + outpono + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('외주발주', '외주발주가 취소되었습니다.');
                $('#Status').val($('#StatusTemp').val());
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('외주발주 변경 알림', '외주발주를 변경하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: $("#master").serialize(),
                    success: function (data) {
                        var outpono = data.PoNo;
                        var orgid = data.searchOrgId;
                        var companyid = data.searchCompanyId;

                        if (pono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("OUTPONO", outpono);
                                if (model.data.OUTPONO != '') {
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
                                        var matcheck = conn.responseText;
                                        var temp = matcheck.substr(23, 1);

                                        if (temp == "Y") {
                                            if (msgGubun == 1) {
                                                msg = "해당 자재의 LOT수량이 부족하여 저장에 실패하였습니다.";
                                            } else if (msgGubun == 2) {
                                                msg = "해당 자재의 LOT수량이 부족하여 변경에 실패하였습니다.";
                                            }
                                            extAlert(msg);
                                            return;
                                        } else if (temp == "P") {
                                            if (msgGubun == 1) {
                                                msg = "해당 작지의 첫 공정이 외주가 아니므로<br/>자재출고가 되지 않았습니다.";
                                            } else if (msgGubun == 2) {
                                                msg = "해당 작지의 첫 공정이 외주가 아니므로<br/>자재출고가 되지 않았습니다.";
                                            }
                                            extAlert(msg);
                                        } else {
                                            if (msgGubun == 1) {
                                                msg = "정상적으로 저장 하였습니다.";
                                            } else if (msgGubun == 2) {
                                                msg = "요청한 발주 내역이 변경되었습니다.";
                                            }
                                            extAlert(msg);
                                        }

                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/prod/outorder/OutOrderManage.do?no=' />" + outpono + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('외주발주 변경', '변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_search() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var PoNo = $('#PoNo').val();

    var sparams = {
        OUTPONO: $('#PoNo').val(),
        ORGID: orgid,
        COMPANYID: companyid,
        GUBUN: 'REGIST',
    };

    var url = "<c:url value='/select/prod/outorder/OutOrderList.do' />";

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var outpono = dataList.OUTPONO;
            var podate = dataList.OUTPODATE;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var outpoperson = dataList.OUTPOPERSON;
            var outpopersonname = dataList.OUTPOPERSONNAME;
            var postatus = dataList.OUTPOSTATUS;
            var postatusname = dataList.OUTPOSTATUSNAME;
            var modqty = dataList.MODQTY;
            var remarks = dataList.REMARKS;

            $("#PoNo").val(outpono);
            $("#PoDate").val(podate);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#PoPerson").val(outpoperson);
            $("#PoPersonName").val(outpopersonname);
            $("#PoStatus").val(postatus);
            $("#PoStatusName").val(postatusname);
            $("#ModQty").val(modqty);
            $('#Remarks').val(remarks);

            global_close_yn = fn_monthly_close_filter_data(podate, 'SCM');
        },
        error: ajaxError
    });

}

function fn_delete() {
    // H 삭제
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var outpono = $('#PoNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = outpono.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;
    var statusconfirm = $('#PoStatus').val();
    //var statustype = $('#StatusType').val() + "";

    var gridcount = Ext.getStore(gridnms["store.1"]).count();

    //    var Status = $('#Status').val();
    //    if (Status === "COMPLETE") {
    //      extAlert("결재상태가 완료 상태에서는 삭제가 불가능 합니다..");
    //      return false;
    //    }

    if (statusconfirm === "COMPLETE") {
        extAlert("발주상태가 완료 상태에서는 삭제가 불가능 합니다..");
        return false;
    }

    if (!gridcount == 0) {
        extAlert("[상세 데이터 ]<br/> 외주 발주 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return false;
    }

    url = "<c:url value='/delete/prod/outorder/OutOrderRegist.do' />";

    Ext.MessageBox.confirm('외주발주 삭제 알림', '외주발주 데이터를 삭제하시겠습니까?', function (btn) {
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
            Ext.Msg.alert('외주발주 삭제', '외주발주 삭제가 취소되었습니다.');
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

    url = "<c:url value='/report/OutOrderReport.pdf'/>";

    fn_popup_url(column, url, target);
}

function fn_complete() {
    // 완료처리
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 완료하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var CustomerCode = $('#CustomerCode').val();
    var PoNo = $('#PoNo').val();
    var PoDate = $('#PoDate').val();
    var PoStatus = $('#PoStatus').val();
    var header = [],
    count = 0;
    if (CustomerCode === "") {
        header.push("거래처명");
        count++;
    }
    if (PoNo === "") {
        header.push("발주번호");
        count++;
    }
    if (PoDate === "") {
        header.push("발주일자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return;
    }
    if (PoStatus === "COMPLETE") {
        extAlert("해당 자료는 이미 완료 처리 되어 있습니다.");
        return;
    }

    url = "<c:url value='/complete/purchase/order/PurchaseOrderMaster.do' />";

    Ext.MessageBox.confirm('완료처리 알림', '완료 처리 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: $("#master").serialize(),
                success: function (data) {

                    var success = data.success;
                    if (!success) {
                        extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                        return;
                    } else {
                        msg = "완료처리를 하였습니다.";
                        extAlert(msg);
                        fn_search();
                    }
                },
                error: ajaxError
            });
        } else {
            Ext.Msg.alert('완료처리', '완료처리가 취소되었습니다.');
            return;
        }
    });
}

function fn_cancel() {
    // 취소처리
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 취소하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var CustomerCode = $('#CustomerCode').val();
    var PoNo = $('#PoNo').val();
    var PoDate = $('#PoDate').val();
    var PoStatus = $('#PoStatus').val();
    var header = [],
    count = 0;
    if (CustomerCode === "") {
        header.push("거래처명");
        count++;
    }
    if (PoNo === "") {
        header.push("발주번호");
        count++;
    }
    if (PoDate === "") {
        header.push("발주일자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return;
    }
    if (PoStatus === "CANCEL") {
        extAlert("해당 자료는 이미 취소 처리 되어 있습니다.");
        return;
    }
    if (PoStatus === "COMPLETE") {
        extAlert("해당 자료는 이미 완료처리 되어 있어 취소 처리가 불가능 합니다.");
        return;
    }

    url = "<c:url value='/cancel/purchase/order/PurchaseOrderMaster.do' />";

    Ext.MessageBox.confirm('취소처리 알림', '취소 처리 하시겠습니까?', function (btn) {
        if (btn == 'yes') {

            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: $("#master").serialize(),
                success: function (data) {

                    var success = data.success;
                    if (!success) {
                        extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                        return;
                    } else {
                        msg = "취소처리를 하였습니다.";
                        extAlert(msg);
                        fn_search();
                    }
                },
                error: ajaxError
            });
        } else {
            Ext.Msg.alert('취소처리', '취소처리가 취소되었습니다.');
            return;
        }
    });
}

function fn_list() {
    go_url("<c:url value='/prod/outorder/OutOrderList.do'/>");
}

function fn_add() {
    go_url("<c:url value='/prod/outorder/OutOrderManage.do' />");
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
                            <li>외주 관리</li>
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
                    <input type="hidden" id="popupGroupCode" name="popupGroupCode" value="A" />
                    <input type="hidden" id="popupBigCode" name="popupBigCode" />
                    <input type="hidden" id="popupBigName" name="popupBigName" />
                    <input type="hidden" id="popupMiddleCode" name="popupMiddleCode" />
                    <input type="hidden" id="popupMiddleName" name="popupMiddleName" />
                    <input type="hidden" id="popupSmallCode" name="popupSmallCode" />
                    <input type="hidden" id="popupSmallName" name="popupSmallName" />
                    <input type="hidden" id="popupItemCode" name="popupItemCode" />
                    <input type="hidden" id="popupItemName" name="popupItemName" />
                    <input type="hidden" id="popupOrderName" name="popupOrderName" />
                    <input type="hidden" id="popupCarTypeName" name="popupCarTypeName" />
                    <input type="hidden" id="popupItemStandardD" name="popupItemStandardD" />
                    <input type="hidden" id="popupItemTypeName" name="popupItemTypeName" />
                    
                    <input type="hidden" id="popupWorkOrderNo" name="popupWorkOrderNo" />
                    <input type="hidden" id="popupItemType" name="popupItemType" />
                    <input type="hidden" id="popupCustomerName" name="popupCustomerName" />
                    <input type="hidden" id="popupCustomerCode" name="popupCustomerCode" />
                    <input type="hidden" id="popupCustomerCodeOutName" name="popupCustomerCodeOutName" />
                    <input type="hidden" id="popupRoutingName" name="popupRoutingName" />
                    <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                                <div>
                                    <table class="tbl_type_view" border="0">
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
                                                    <td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 70%;">
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
                                                    <td colspan="5">
                                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                                    <a id="btnChk1" class="btn_search" href="#" onclick="javascript:btnSel2();"> 외주공정 불러오기 </a>
                                                                    <a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
                                                                    <a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete()"> 삭제 </a>
                                                                    <a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
                                                                    <a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
                                                                    <c:choose>
                                                                            <c:when test="${gubun=='MODIFY'}">
                                                                                    <a id="btnChk6" class="btn_print" href="#" onclick="javascript:fn_print();"> 반출증 </a>
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
                                                    <th class="required_text">발주번호</th>
                                                    <td>
                                                        <input type="text" id="PoNo" name="PoNo" class="input_center" style="width: 97%;" value="${searchVO.OUTPONO}" readonly />
                                                    </td>
                                                    <th class="required_text">발주일</th>
                                                    <td>
		                                                    <input type="text" id="PoDate" name="PoDate" class="input_validation input_center" style="width: 97%;" maxlength="10" />
		                                                    <input type="hidden" id="PoFrom" name="PoFrom" />
		                                                    <input type="hidden" id="PoTo" name="PoTo" />
                                                    </td>
                                                    <th class="required_text">공급사</th>
                                                    <td>
		                                                    <input type="text" id="CustomerName" name="CustomerName" value="${searchVO.CUSTOMER}"  class="input_validation input_center" style="width: 98%;" />
		                                                    <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                                    </td>
                                                    <th class="required_text">발주상태</th>
                                                    <td><input type="text" id="PoStatusName" name="PoStatusName" class=" input_center" style="width: 97%;" readonly /> <input type="hidden" id="PoStatus" name="PoStatus" /></td>
<!--                                                     <td colspan="2"> -->
<!--                                                             <div class="buttons" style="float: center; margin-top: 3px;"> -->
<!--                                                                     <a id="btnChk100" class="btn_list" href="#" onclick="javascript:fn_complete();"> 완료 처리 </a> -->
<!--                                                                     <a id="btnChk101" class="btn_list" href="#" onclick="javascript:fn_cancel();"> 취소 처리 </a> -->
<!--                                                             </div> -->
<!--                                                     </td> -->
                                            </tr>
                                            <tr style="height: 34px;">
                                                    <th class="required_text">외주지시 담당자</th>
                                                    <td>
		                                                    <input type="text" id="PoPersonName" name="PoPersonName" value="${searchVO.PERSON}"  class="input_validation input_center" style="width: 97%;" />
		                                                    <input type="hidden" id="PoPerson" name="PoPerson" />
                                                    </td>
                                                    <th class="required_text">수정품(수량)</th>
                                                    <td>
                                                        <input type="text" id="ModQty" name="ModQty" class=" input_right" style="width: 97%;" />
                                                    </td>
                                                    <td></td>
                                                    <td><input type="hidden" id="StatusName" name="StatusName" /> <input type="hidden" id="Status" name="Status" /></td>
                                            </tr>
                                            <tr style="height: 34px;">
                                                    <th class="required_text">비고</th>
                                                    <td colspan="7"><textarea id="Remarks" name="Remarks"  class="input_left" style="width: 99%;"></textarea></td>
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
        <div id="gridPopup11Area" style="width: 1580px; padding-top: 0px; float: left;"></div>
        <div id="gridPopup1Area" style="width: 1541px; padding-top: 0px; float: left;"></div>

        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>