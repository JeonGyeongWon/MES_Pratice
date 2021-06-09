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
</style>
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    // 제품선택 팝업창 추가
    setValues_Popup();
    setExtGrid_Popup();

    $("#gridPopupArea").hide("blind", {
        direction: "up"
    }, "fast");

    setReadOnly();

    setLovList();

    setLastInitial();
});

var global_close_yn = "N";
function setInitial() {
    gridnms["app"] = "scm";

    // 입고일자
    calender($('#OutTransDate'));

    $('#OutTransDate').keyup(function (event) {
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
    var transno = $('#OutTransNo').val();
    if (transno != "") {
        fn_search();
    } else {
        $("#OutTransDate").val(getToDay("${searchVO.TODAY}") + "");

        // 2016.10.04. 관리자 권한 외 사용자 로그인시 담당자에 이름 표기
        var groupid = "${searchVO.groupId}";
        switch (groupid) {
        case "ROLE_ADMIN":
            // 관리자 권한일 때 그냥 놔둠
            break;
        default:
            // 관리자 외 권한일 때 사용자명 표기
            $('#PersonName').val("${searchVO.KRNAME}");
            $('#PersonCode').val("${searchVO.EMPLOYEENUMBER}");
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

    gridnms["grid.1"] = "OutTransRegistDetail";

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
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'OUTTRANSNO',
        }, {
            type: 'string',
            name: 'OUTTRANSSEQ',
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
            name: 'ORDERQTY',
        }, {
            type: 'string',
            name: 'TRANSQTY',
        }, {
            type: 'string',
            name: 'EXTRANSQTY',
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
            name: 'OUTPONO',
        }, {
            type: 'number',
            name: 'OUTPOSEQ',
        }, {
            type: 'string',
            name: 'OUTPONOSEQ',
        }, {
            type: 'string',
            name: 'CUSTOMERLOT',
        }, {
            type: 'string',
            name: 'FINISHYN',
        }, {
            type: 'string',
            name: 'FINISHYNNAME',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'POSTATUS',
        }, {
            type: 'string',
            name: 'WORKSTATUS',
        }, {
            type: 'string',
            name: 'TRANSYN',
        }, {
            type: 'string',
            name: 'TRANSYNNAME',
        }, {
            type: 'number',
            name: 'CON1',
        }, {
            type: 'number',
            name: 'CON2',
        }, {
            type: 'number',
            name: 'CON3',
        }, {
            type: 'number',
            name: 'CON4',
        }, {
            type: 'number',
            name: 'CON5',
        }, {
            type: 'number',
            name: 'CON6',
        }, {
            type: 'number',
            name: 'CON7',
        }, {
            type: 'number',
            name: 'CON8',
        }, {
            type: 'number',
            name: 'CON9',
        }, {
            type: 'number',
            name: 'CON10',
        }, {
            type: 'number',
            name: 'CON11',
        }, {
            type: 'number',
            name: 'CON12',
        }, {
            type: 'number',
            name: 'CON13',
        }, {
            type: 'number',
            name: 'CON14',
        }, {
            type: 'number',
            name: 'CON15',
        }, {
            type: 'number',
            name: 'CON16',
        }, {
            type: 'number',
            name: 'CON17',
        }, {
            type: 'number',
            name: 'CON18',
        }, {
            type: 'number',
            name: 'CON19',
        }, {
            type: 'number',
            name: 'CON20',
        }, {
            type: 'number',
            name: 'CON21',
        }, {
            type: 'number',
            name: 'CON22',
        }, {
            type: 'number',
            name: 'CON23',
        }, {
            type: 'number',
            name: 'CON24',
        }, {
            type: 'number',
            name: 'CON25',
        }, {
            type: 'number',
            name: 'CON26',
        }, {
            type: 'number',
            name: 'CON27',
        }, {
            type: 'number',
            name: 'CON28',
        }, {
            type: 'number',
            name: 'CON29',
        }, {
            type: 'number',
            name: 'CON30',
        }, {
            type: 'number',
            name: 'CON31',
        }, {
            type: 'number',
            name: 'CON32',
        }, {
            type: 'number',
            name: 'CON33',
        }, {
            type: 'number',
            name: 'CON34',
        }, {
            type: 'number',
            name: 'CON35',
        }, {
            type: 'number',
            name: 'CON36',
        }, {
            type: 'number',
            name: 'CON37',
        }, {
            type: 'number',
            name: 'CON38',
        }, {
            type: 'number',
            name: 'CON39',
        }, {
            type: 'number',
            name: 'CON40',
        }, {
            type: 'number',
            name: 'TOTALFAULTQTY',
        }, {
            type: 'string',
            name: 'INSPECTIONPLANNO',
        }, {
            type: 'number',
            name: 'TRANSCHKQTY',
        }, ];

    fields["columns.1"] = [
        // Display Columns
        {
            dataIndex: 'OUTTRANSSEQ',
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
            dataIndex: 'XXXXXXXXXX',
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '',
            width: 75,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "확정",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    fn_trans_yn_change(record.data, 'Y');
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'XXXXXXXXXX',
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '',
            width: 75,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "취소",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    fn_trans_yn_change(record.data, 'N');
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'TRANSYNNAME',
            text: '확정여부',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234);";

                switch (value) {
                case "미확정":
                    meta.style += " color:rgb(255, 0, 0);";
                    meta.style += " font-weight: bold;";
                    break;
                case "확정":
                    break;
                default:
                    break;
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
            width: 100,
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
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TRANSQTY',
            text: '입고수량',
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
                        var transchkqty = store.data.TRANSCHKQTY * 1; // 발주수량 - (자신의 입고수량을 제외한 총 입고수량 + 자신의 불량수량을 제외한 총 불량수량)

                        var faultqty = (store.data.CON1 * 1) + (store.data.CON2 * 1) + (store.data.CON3 * 1)
                         + (store.data.CON4 * 1) + (store.data.CON5 * 1) + (store.data.CON6 * 1)
                         + (store.data.CON7 * 1) + (store.data.CON8 * 1) + (store.data.CON9 * 1)
                         + (store.data.CON10 * 1) + (store.data.CON11 * 1) + (store.data.CON12 * 1)
                         + (store.data.CON13 * 1) + (store.data.CON14 * 1) + (store.data.CON15 * 1)
                         + (store.data.CON16 * 1) + (store.data.CON17 * 1) + (store.data.CON18 * 1)
                         + (store.data.CON19 * 1) + (store.data.CON20 * 1) + (store.data.CON21 * 1)
                         + (store.data.CON22 * 1) + (store.data.CON23 * 1) + (store.data.CON24 * 1)
                         + (store.data.CON25 * 1) + (store.data.CON26 * 1) + (store.data.CON27 * 1)
                         + (store.data.CON28 * 1) + (store.data.CON29 * 1) + (store.data.CON30 * 1)
                         + (store.data.CON31 * 1) + (store.data.CON32 * 1) + (store.data.CON33 * 1)
                         + (store.data.CON34 * 1) + (store.data.CON35 * 1) + (store.data.CON36 * 1)
                         + (store.data.CON37 * 1) + (store.data.CON38 * 1) + (store.data.CON39 * 1)
                         + (store.data.CON40 * 1);

                        if (((qty * 1) + faultqty) > transchkqty) {
                            extAlert("입고예정수량이 발주수량을 초과할 수 없습니다.");
                            store.set("TRANSQTY", (transchkqty - faultqty));
                            qty = (transchkqty - faultqty);
                        }

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

                        var orderqty = store.data.ORDERQTY * 1; // 발주수량
                        var transqty = newValue * 1; // 입고수량
                        var totalfaultqty = store.data.TOTALFAULTQTY * 1; // 불량수량


                        if ((transqty + totalfaultqty) > 0) {
                            if ((transqty + totalfaultqty) >= orderqty) {
                                store.set("FINISHYN", "Y");
                                store.set("FINISHYNNAME", "완료");
                            } else {
                                store.set("FINISHYN", "N");
                                store.set("FINISHYNNAME", "미완료");
                            }
                        } else {
                            store.set("FINISHYN", "Y");
                            store.set("FINISHYNNAME", "완료");
                        }

                        //              var qty = field.getValue();
                        //              var po = store.data.ORDERQTY;
                        //              var transqty = field.getValue();
                        //              var extransqty = store.data.EXTRANSQTY;
                        //              var sumqty = ((transqty * 1) + (extransqty * 1));

                        //              if ((po * 1) > 0) {
                        //                if ((po * 1) <= (sumqty * 1)) {
                        //                  store.set("FINISHYN", "Y");
                        //                  store.set("FINISHYNNAME", "완료");
                        //                } else {
                        //                  store.set("FINISHYN", "N");
                        //                  store.set("FINISHYNNAME", "미완료");
                        //                }
                        //              } else {
                        //                store.set("FINISHYN", "Y");
                        //                store.set("FINISHYNNAME", "완료");
                        //              }
                    },
                },
            },
            renderer: function (value, meta, record) {
                var transyn = record.data.TRANSYN;

                switch (transyn) {
                case "N":
                    var finishyn = record.data.FINISHYNNAME;
                    switch (finishyn) {
                    case "미완료":
                        meta.style += " background-color:rgb(253, 218, 255);";
                        break;
                    case "완료":
                        meta.style = "background-color:rgb(234, 234, 234)";
                        break;
                    default:
                        break;
                    }
                    break;
                case "Y":
                    meta.style = "background-color:rgb(234, 234, 234)";
                    break;
                default:
                    break;
                }
                //          meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'EXTRANSQTY',
            text: '입고수량<br/>합계',
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
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTALFAULTQTY',
            text: '총불량수량',
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
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
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

                        var unitcost = field.getValue();
                        var qty = store.data.TRANSQTY;

                        var supplyprice = 0,
                        tsupplyprice = 0;
                        var addtax = 0,
                        taddtax = 0;

                        supplyprice = (qty * unitcost) * 1.0;
                        store.set("SUPPLYPRICE", supplyprice);

                        addtax = Math.round((qty * unitcost) * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        store.set("TOTAL", supplyprice * 1 + addtax * 1);

                    },
                },
            },
            renderer: function (value, meta, record) {
                var transyn = record.data.TRANSYN;

                switch (transyn) {
                case "N":
                    var finishyn = record.data.FINISHYNNAME;
                    switch (finishyn) {
                    case "미완료":
                        meta.style += " background-color:rgb(253, 218, 255);";
                        break;
                    case "완료":
                        meta.style = "background-color:rgb(234, 234, 234)";
                        break;
                    default:
                        break;
                    }
                    break;
                case "Y":
                    meta.style = "background-color:rgb(234, 234, 234)";
                    break;
                default:
                    break;
                }
                //          meta.style = "background-color:rgb(234, 234, 234)";
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

                        var supplycost = field.getValue();

                        var addtax = 0;

                        addtax = Math.round((supplycost) * 0.1);
                        store.set("ADDITIONALTAX", addtax);

                        store.set("TOTAL", supplycost * 1 + addtax * 1);

                    },
                },
            },
            renderer: function (value, meta, record) {
                var transyn = record.data.TRANSYN;

                switch (transyn) {
                case "N":
                    var finishyn = record.data.FINISHYNNAME;
                    switch (finishyn) {
                    case "미완료":
                        meta.style += " background-color:rgb(253, 218, 255);";
                        break;
                    case "완료":
                        meta.style = "background-color:rgb(234, 234, 234)";
                        break;
                    default:
                        break;
                    }
                    break;
                case "Y":
                    meta.style = "background-color:rgb(234, 234, 234)";
                    break;
                default:
                    break;
                }
                //          meta.style = "background-color:rgb(234, 234, 234)";
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

                        var add = field.getValue();
                        var supplyprice = store.data.SUPPLYPRICE;

                        var total = 0;

                        total = (supplyprice * 1 + add * 1) * 1.0;
                        store.set("TOTAL", total);

                    },
                },
            },
            renderer: function (value, meta, record) {
                var transyn = record.data.TRANSYN;

                switch (transyn) {
                case "N":
                    var finishyn = record.data.FINISHYNNAME;
                    switch (finishyn) {
                    case "미완료":
                        meta.style += " background-color:rgb(253, 218, 255);";
                        break;
                    case "완료":
                        meta.style = "background-color:rgb(234, 234, 234)";
                        break;
                    default:
                        break;
                    }
                    break;
                case "Y":
                    meta.style = "background-color:rgb(234, 234, 234)";
                    break;
                default:
                    break;
                }
                //          meta.style = "background-color:rgb(234, 234, 234)";
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
            dataIndex: 'FINISHYNNAME',
            text: '완료여부',
            xtype: 'gridcolumn',
            width: 80,
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
                            model.set("FINISHYN", "Y");
                        } else if (value.getValue() == "미완료") {
                            model.set("FINISHYN", "N");
                        }
                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        if (field.getValue() == "") {
                            model.set("FINISHYN", "N");
                        }
                    },
                },
            },
            renderer: function (value, meta, record) {
                meta.style += " background-color:rgb(253, 218, 255);";
                return value;
            },
            //      }, {
            //        dataIndex: 'REMARKS',
            //        text: '비고',
            //        xtype: 'gridcolumn',
            //        width: 160,
            //        hidden: false,
            //        sortable: false,
            //        resizable: true,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "left",
            //        editor: {
            //          xtype: 'textfield',
            //          allowBlank: true,
            //        },
            //        renderer: function (value, meta, record) {
            //          var transyn = record.data.TRANSYN;

            //          switch (transyn) {
            //          case "N":
            //            //                 meta.style += " background-color:rgb(253, 218, 255);";
            //            var finishyn = record.data.FINISHYNNAME;
            //            switch (finishyn) {
            //            case "미완료":
            //              break;
            //            case "완료":
            //              meta.style = "background-color:rgb(234, 234, 234)";
            //              break;
            //            default:
            //              break;
            //            }
            //            break;
            //          case "Y":
            //            meta.style = "background-color:rgb(234, 234, 234)";
            //            break;
            //          default:
            //            break;
            //          }
            //          //          meta.style = "background-color:rgb(234, 234, 234)";
            //          return value;
            //        },
        }, {
            dataIndex: 'WORKORDERID',
            text: '작업지시번호',
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
            width: 55,
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
            dataIndex: 'OUTPRODLOT',
            text: '외주생산LOT',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
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
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'FINISHYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'POSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'TRANSYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPECTIONPLANNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'TRANSCHKQTY',
            xtype: 'hidden',
        }, ];

    var faulttype = "${searchVO.FAULTTYPE}";
    var typecode = faulttype.split(",");
    var faulttypename = "${searchVO.FAULTTYPENAME}";
    var typename = faulttypename.split(",");
    for (var i = 0; i < typecode.length; i++) {

        fields["columns.1"].push({
            dataIndex: 'CON' + typecode[i] + "",
            text: typename[i],
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            lockable: false,
            style: 'text-align:center',
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
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        //              var total = model.data.TOTALFAULTQTY * 1;
                        //              var qty = field.getValue() * 1;
                        //              var oldqty = oldValue * 1;
                        //              if (newValue != oldValue) {
                        //                total = total + (qty - oldqty);
                        //                model.set("TOTALFAULTQTY", total);
                        //              }

                        var faultqty = ((model.data.CON1 * 1) + (model.data.CON2 * 1) + (model.data.CON3 * 1)
                             + (model.data.CON4 * 1) + (model.data.CON5 * 1) + (model.data.CON6 * 1)
                             + (model.data.CON7 * 1) + (model.data.CON8 * 1) + (model.data.CON9 * 1)
                             + (model.data.CON10 * 1) + (model.data.CON11 * 1) + (model.data.CON12 * 1)
                             + (model.data.CON13 * 1) + (model.data.CON14 * 1) + (model.data.CON15 * 1)
                             + (model.data.CON16 * 1) + (model.data.CON17 * 1) + (model.data.CON18 * 1)
                             + (model.data.CON19 * 1) + (model.data.CON20 * 1) + (model.data.CON21 * 1)
                             + (model.data.CON22 * 1) + (model.data.CON23 * 1) + (model.data.CON24 * 1)
                             + (model.data.CON25 * 1) + (model.data.CON26 * 1) + (model.data.CON27 * 1)
                             + (model.data.CON28 * 1) + (model.data.CON29 * 1) + (model.data.CON30 * 1)
                             + (model.data.CON31 * 1) + (model.data.CON32 * 1) + (model.data.CON33 * 1)
                             + (model.data.CON34 * 1) + (model.data.CON35 * 1) + (model.data.CON36 * 1)
                             + (model.data.CON37 * 1) + (model.data.CON38 * 1) + (model.data.CON39 * 1)
                             + (model.data.CON40 * 1) - (field.originalValue * 1)) + (newValue * 1);

                        model.set("TOTALFAULTQTY", faultqty);

                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var qty = model.data.TRANSQTY * 1; // 발주수량 - (자신의 입고수량을 제외한 총 입고수량 + 자신의 불량수량을 제외한 총 불량수량)
                        var transchkqty = model.data.TRANSCHKQTY * 1; // 발주수량 - (자신의 입고수량을 제외한 총 입고수량 + 자신의 불량수량을 제외한 총 불량수량)

                        var faultqty = model.data.TOTALFAULTQTY * 1;

                        if (((qty * 1) + faultqty) > transchkqty) {

                            extAlert("입고예정수량이 발주수량을 초과할 수 없습니다.");

                            setTimeout(function () {
                                model.set(field.dataIndex, 0);
                            }, 400);

                            var totalfaultqty = (model.data.CON1 * 1) + (model.data.CON2 * 1) + (model.data.CON3 * 1)
                             + (model.data.CON4 * 1) + (model.data.CON5 * 1) + (model.data.CON6 * 1)
                             + (model.data.CON7 * 1) + (model.data.CON8 * 1) + (model.data.CON9 * 1)
                             + (model.data.CON10 * 1) + (model.data.CON11 * 1) + (model.data.CON12 * 1)
                             + (model.data.CON13 * 1) + (model.data.CON14 * 1) + (model.data.CON15 * 1)
                             + (model.data.CON16 * 1) + (model.data.CON17 * 1) + (model.data.CON18 * 1)
                             + (model.data.CON19 * 1) + (model.data.CON20 * 1) + (model.data.CON21 * 1)
                             + (model.data.CON22 * 1) + (model.data.CON23 * 1) + (model.data.CON24 * 1)
                             + (model.data.CON25 * 1) + (model.data.CON26 * 1) + (model.data.CON27 * 1)
                             + (model.data.CON28 * 1) + (model.data.CON29 * 1) + (model.data.CON30 * 1)
                             + (model.data.CON31 * 1) + (model.data.CON32 * 1) + (model.data.CON33 * 1)
                             + (model.data.CON34 * 1) + (model.data.CON35 * 1) + (model.data.CON36 * 1)
                             + (model.data.CON37 * 1) + (model.data.CON38 * 1) + (model.data.CON39 * 1)
                             + (model.data.CON40 * 1);

                            model.set("TOTALFAULTQTY", totalfaultqty);
                            model.set("FINISHYN", "N");
                            if ((transqty + totalfaultqty) < orderqty) {
                                model.set("FINISHYNNAME", "미완료");
                            }
                        } else {
                            var orderqty = model.data.ORDERQTY * 1; // 발주수량
                            var transqty = model.data.TRANSQTY * 1; // 입고수량
                            var totalfaultqty = faultqty; // 불량수량


                            if ((transqty + totalfaultqty) > 0) {
                                if ((transqty + totalfaultqty) >= orderqty) {
                                    model.set("FINISHYN", "Y");
                                    model.set("FINISHYNNAME", "완료");
                                } else {
                                    model.set("FINISHYN", "N");
                                    model.set("FINISHYNNAME", "미완료");
                                }
                            } else {
                                model.set("FINISHYN", "Y");
                                model.set("FINISHYNNAME", "완료");
                            }
                        }
                    },
                },
            },
            renderer: function (value, meta, record) {
                var transyn = record.data.TRANSYN;

                switch (transyn) {
                case "N":
                    //                 meta.style += " background-color:rgb(253, 218, 255);";
                    var finishyn = record.data.FINISHYNNAME;
                    switch (finishyn) {
                    case "미완료":
                        break;
                    case "완료":
                        meta.style = "background-color:rgb(234, 234, 234)";
                        break;
                    default:
                        break;
                    }
                    break;
                case "Y":
                    meta.style = "background-color:rgb(234, 234, 234)";
                    break;
                default:
                    break;
                }
                //          meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        });
    }

    fields["columns.1"].push({
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
            var transyn = record.data.TRANSYN;

            switch (transyn) {
            case "N":
                //                 meta.style += " background-color:rgb(253, 218, 255);";
                var finishyn = record.data.FINISHYNNAME;
                switch (finishyn) {
                case "미완료":
                    break;
                case "완료":
                    meta.style = "background-color:rgb(234, 234, 234)";
                    break;
                default:
                    break;
                }
                break;
            case "Y":
                meta.style = "background-color:rgb(234, 234, 234)";
                break;
            default:
                break;
            }
            //          meta.style = "background-color:rgb(234, 234, 234)";
            return value;
        },
    });

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/scm/outprocess/OutTransRegist.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "삭제",
        itemId: "btnDel1"
    });

    items["btns.ctr.1"] = {};
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
    items["docked.1"].push(items["dock.btn.1"]);

}

var global_popup_flag = false;
function btnSel(btn) {
    var OutTransNo = $('#OutTransNo').val();
    var TransDate = $('#TransFrom').val();
    var TransTo = $('#TransTo').val();
    var CustomerCode = $('#OrderName').val(); // 품번
    var ItemCode = $('#ItemCode').val(); // 품목코드
    var Qty = $('#Qty').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    // 외주입고 대기리스트 팝업
    var width = 1645; // 가로
    var height = 640; // 세로
    var title = "입고대기LIST(발주정보) Popup";

    var check = true;

    global_popup_flag = false;
    if (check) {
        // 완료 외 상태에서만 팝업 표시하도록 처리
        $('#popupOrgId').val($('#searchOrgId option:selected').val());
        $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
        $('#popupCustomerCode').val($('#CustomerCode option:selected').val());
        $('#popupCustomerName').val($('#CustomerName option:selected').val()); // Poup에 선택된 거래처 넘겨주는 부분

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
                        itemId: 'btnPopup11',
                    },
                    plugins: 'bufferedrenderer',
                    dockedItems: items["docked.44"],
                }
            ],
            tbar: [
                '납기일', {
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
                            $('#popupPoFrom').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
                        },
                        change: function (value, nv, ov, e) {
                            var result = value.getValue();

                            if (nv !== ov) {
                                if (result === "") {
                                    $('#popupPoFrom').val("");
                                } else {
                                    var popupDueFrom = Ext.Date.format(result, 'Y-m-d');
                                    var popupDueTo = $('#popupPoTo').val();

                                    if (popupDueTo === "") {
                                        $('#popupPoFrom').val(Ext.Date.format(result, 'Y-m-d'));
                                    } else {
                                        var diff = 0;
                                        diff = fn_calc_diff(popupDueFrom, popupDueTo);
                                        if (diff < 0) {
                                            extAlert("이전 날짜가 이후 날짜보다 큽니다.<br/>다시 한번 확인해주십시오.");
                                            value.setValue("");
                                            $('#popupPoFrom').val("");
                                            return;
                                        } else {
                                            $('#popupPoFrom').val(Ext.Date.format(result, 'Y-m-d'));
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
                            $('#popupPoTo').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
                        },
                        change: function (value, nv, ov, e) {
                            var result = value.getValue();

                            if (nv !== ov) {
                                if (result === "") {
                                    $('#popupPoTo').val("");
                                } else {
                                    var popupDueFrom = $('#popupPoFrom').val();
                                    var popupDueTo = Ext.Date.format(result, 'Y-m-d');

                                    if (popupDueFrom === "") {
                                        $('#popupPoTo').val(Ext.Date.format(result, 'Y-m-d'));
                                    } else {
                                        var diff = 0;
                                        diff = fn_calc_diff(popupDueFrom, popupDueTo);
                                        if (diff < 0) {
                                            extAlert("이후 날짜가 이전 날짜보다 작습니다.<br/>다시 한번 확인해주십시오.");
                                            value.setValue("");
                                            $('#popupPoTo').val("");
                                            return;
                                        } else {
                                            $('#popupPoTo').val(Ext.Date.format(result, 'Y-m-d'));
                                        }
                                    }
                                }
                            }
                        },
                    },
                    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
                },
                '발주번호', {
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

                            $('#popupOutTransNo').val(result);
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
                '품명', {
                    xtype: 'textfield',
                    name: 'searchItemName',
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

                            $('#popupItemName').val(result);
                        },
                    },
                },
                '기종', {
                    xtype: 'textfield',
                    name: 'searchModelName',
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

                            $('#popupModelName').val(result);
                        },
                    },
                },
                '타입', {
                    xtype: 'textfield',
                    name: 'searchItemType',
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

                            $('#popupItemType').val(result);
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
                        var count44 = Ext.getStore(gridnms["store.44"]).count();
                        var checkTrue = 0,
                        checkFalse = 0;

                        global_popup_flag = !global_popup_flag;
                        for (var i = 0; i < count44; i++) {
                            Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(i));
                            var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];

                            var chk = model44.data.CHK;

                            if (global_popup_flag) {
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
                                    model.set("OUTTRANSSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("ITEMCODE", model44.data.ITEMCODE);
                                    model.set("ITEMNAME", model44.data.ITEMNAME);
                                    model.set("ORDERNAME", model44.data.ORDERNAME);
                                    model.set("DRAWINGNO", model44.data.DRAWINGNO);
                                    model.set("UOM", model44.data.UOM);
                                    model.set("UOMNAME", model44.data.UOMNAME);
                                    model.set("MODEL", model44.data.MODEL);
                                    model.set("MODELNAME", model44.data.MODELNAME);

                                    model.set("OUTPONO", model44.data.OUTPONO);
                                    model.set("OUTPOSEQ", model44.data.OUTPOSEQ);
                                    model.set("ORDERQTY", model44.data.ORDERQTY);
                                    model.set("TRANSQTY", model44.data.EXTRANSQTY);
                                    model.set("EXTRANSQTY", model44.data.TRANSQTY);

                                    // 해당 입고예정수량을 발주수량과 비교하여 초과할 수 없도록 체크함
                                    model.set("TRANSCHKQTY", model44.data.EXTRANSQTY);

                                    model.set("UNITPRICE", model44.data.UNITPRICE); // 단가
                                    model.set("SUPPLYPRICE", model44.data.SUPPLYPRICE); // 공급가액
                                    model.set("ADDITIONALTAX", model44.data.ADDITIONALTAX); // 부가세
                                    model.set("TOTAL", model44.data.TOTAL); // 합계

                                    model.set("ROUTINGCODE", model44.data.ROUTINGCODE); // 공정
                                    model.set("ROUTINGNAME", model44.data.ROUTINGNAME); // 공정명
                                    model.set("WORKORDERID", model44.data.WORKORDERID); // 작업지시번호
                                    model.set("WORKORDERSEQ", model44.data.WORKORDERSEQ); // 작업지시번호
                                    model.set("INSPECTIONPLANNO", model44.data.INSPECTIONPLANNO);

                                    model.set("REMARKS", model44.data.REMARKS);
                                    model.set("POSTATUS", model44.data.POSTATUS);
                                    model.set("WORKSTATUS", model44.data.WORKSTATUS);

                                    var orderqty = model44.data.ORDERQTY * 1;
                                    var transqty = model44.data.EXTRANSQTY * 1;
                                    var oldqty = model44.data.TRANSQTY * 1;

                                    if (orderqty == (transqty + oldqty)) {
                                        model.set("FINISHYN", "Y");
                                        model.set("FINISHYNNAME", "완료");
                                    } else {
                                        model.set("FINISHYN", "N");
                                        model.set("FINISHYNNAME", "미완료");
                                    }
                                    model.set("TRANSYN", "Y");
                                    model.set("TRANSYNNAME", "확정");

                                    $('#CustomerCode').val(model44.data.CUSTOMERCODEOUT);
                                    $('#CustomerName').val(model44.data.CUSTOMERNAMEOUT);

                                    var qty = model44.data.EXTRANSQTY * 1;
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

                                    // 그리드 적용 방식
                                    store.add(model);

                                    checktemp++;
                                };
                            }

                            Ext.getCmp(gridnms["panel.1"]).getView().refresh();

                        }

                        if (checktemp > 0) {
                            win11.close();

                            $("#gridPopupArea").hide("blind", {
                                direction: "up"
                            }, "fast");
                        }
                    }
                }
            ]
        });

        win11.show();

        var customercode = $('#CustomerCode').val();
        if (customercode == "") {
            $('#popupCustomerCode').val("");
        } else {
            $('#popupCustomerCode').val(customercode);
        }

        fn_popup_search();

    } else {
        extAlert("입고 등록 하실 경우에만 입하대기LIST(발주정보) 불러오기가 가능합니다.");
        return;
    }
}

function fn_popup_search() {
    global_popup_flag = false;
    var sparams4 = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        OUTPONO: $('#popupOutTransNo').val(),
        POFROM: $('#popupPoFrom').val(),
        POTO: $('#popupPoTo').val(),
        ITEMCODE: $('#popupItemCode').val(),
        ITEMNAME: $('#popupItemName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        CUSTOMERCODE: $('#popupCustomerCode').val(),
        CUSTOMERNAME: $('#popupCustomerName').val(),
        MODELNAME: $('#popupModelName').val(),
        ITEMTYPE: $('#popupItemType').val(),
    };
    extGridSearch(sparams4, gridnms["store.44"]);
}

function btnDel1(o, e) {
    var store = this.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
    var outtransno = $('#OutTransNo').val();
    var outtransseq = record.data.OUTTRANSSEQ;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    if (record === undefined) {
        return;
    }

    var transyn = record.data.TRANSYN;
    if (transyn == "Y") {
        extAlert("확정 상태의 데이터는 삭제할 수 없습니다.");
        return;
    }

    Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var url = "<c:url value='/delete/scm/outprocess/OutWarehousingRegistDetail.do' />";

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
                        go_url("<c:url value='/scm/outprocess/OutTransRegistDetail.do?no=' />" + outtransno + "&org=" + orgid + "&company=" + companyid);
                    }
                },
                error: ajaxError
            });
        }
    });
}

// 입하대기LIST 불러오기 팝업
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
            name: 'ORDERNAME',
        }, {
            type: 'string',
            name: 'ITEMCODE',
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
            name: 'ROUTINGCODE',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'string',
            name: 'OUTPONO',
        }, {
            type: 'string',
            name: 'OUTPOSEQ',
        }, {
            type: 'number',
            name: 'PASSQTY',
        }, {
            type: 'number',
            name: 'INSPQTY',
        }, {
            type: 'number',
            name: 'ORDERQTY',
        }, {
            type: 'number',
            name: 'TRANSQTY',
        }, {
            type: 'number',
            name: 'FAULTQTY',
        }, {
            type: 'number',
            name: 'EXTRANSQTY',
        }, {
            type: 'number',
            name: 'UNITPRICE',
        }, {
            type: 'string',
            name: 'CUSTOMERCODEOUT',
        }, {
            type: 'string',
            name: 'CUSTOMERNAMEOUT',
        }, {
            type: 'string',
            name: 'POSTATUS',
        }, {
            type: 'string',
            name: 'WORKSTATUS',
        }, {
            type: 'string',
            name: 'INSPECTIONPLANNO',
        }, ];

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
            dataIndex: 'OUTPODATE',
            text: '발주일자',
            xtype: 'datecolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
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
            width: 250,
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
            width: 100,
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
            dataIndex: 'TRANSQTY',
            text: '기입고<br/>수량',
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
            dataIndex: 'PASSQTY',
            text: '검사<br/>수량',
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
            dataIndex: 'INSPQTY',
            text: '기입고<br/>검사수량',
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
            dataIndex: 'FAULTQTY',
            text: '불량<br/>수량',
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
            dataIndex: 'EXTRANSQTY',
            text: '입고예정<br/>수량',
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
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODEOUT',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERNAMEOUT',
            xtype: 'hidden',
        }, {
            dataIndex: 'POSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPECTIONPLANNO',
            xtype: 'hidden',
        }, ];

    items["api.44"] = {};
    $.extend(items["api.44"], {
        read: "<c:url value='/ScmOutprocessRegistPop.do' />"
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
                        autoLoad: true,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.44"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#popupOrgId').val(),
                                COMPANYID: $('#popupCompanyId').val(),
                                CUSTOMERCODE: $('#popupCustomerCode').val(),
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
                renderTo: 'gridPopupArea'
            });
        },
    });
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
                                OUTTRANSNO: $('#OutTransNo').val(),
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
                height: 650,
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
                    itemId: 'btnList',
                    trackOver: true,
                    loadMask: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('CON') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
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
                                var transyn = data.data.TRANSYN;
                                editDisableCols.push("OUTTRANSSEQ");
                                if (transyn == "Y") {
                                    editDisableCols.push("TRANSQTY");
                                    editDisableCols.push("UNITPRICE");
                                    editDisableCols.push("SUPPLYPRICE");
                                    editDisableCols.push("ADDITIONALTAX");
                                    editDisableCols.push("REMARKS");

                                    var faulttype = "${searchVO.FAULTTYPE}";
                                    var typecode = faulttype.split(",");
                                    var faulttypename = "${searchVO.FAULTTYPENAME}";
                                    var typename = faulttypename.split(",");
                                    for (var i = 0; i < typecode.length; i++) {
                                        editDisableCols.push("CON" + typecode[i] + "");
                                    }

                                } else {
                                    var finishyn = data.data.FINISHYN;
                                    if (finishyn == "Y") {
                                        editDisableCols.push("TRANSQTY");
                                        editDisableCols.push("UNITPRICE");
                                        editDisableCols.push("SUPPLYPRICE");
                                        editDisableCols.push("ADDITIONALTAX");
                                        editDisableCols.push("REMARKS");

                                        var faulttype = "${searchVO.FAULTTYPE}";
                                        var typecode = faulttype.split(",");
                                        var faulttypename = "${searchVO.FAULTTYPENAME}";
                                        var typename = faulttypename.split(",");
                                        for (var i = 0; i < typecode.length; i++) {
                                            editDisableCols.push("CON" + typecode[i] + "");
                                        }

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
                renderTo: 'gridArea'
            });
        },
    });

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
    });
}

function fn_trans_yn_change(record, flag) {
    var flag_name = (flag == "Y") ? "확정" : "미확정";
    var transyn = record.TRANSYN;
    var url = "";

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[외주입고 " + flag_name + " 변경]<br/>상세데이터가 등록되지 않았습니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    if (transyn == flag) {
        extAlert("[외주입고 " + flag_name + " 변경]<br/>이미 변경된 상태입니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    url = "<c:url value='/update/scm/outprocess/OutTransDetailStatus.do' />";
    record.TRANSYN = flag;

    Ext.MessageBox.confirm('외주입고 ' + flag_name, flag_name + ' 변경 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: record,
                success: function (data) {
                    var success = data.success;
                    var msg = data.msg;
                    if (!success) {
                        extAlert("관리자에게 문의하십시오.<br/>" + msg);
                        return;
                    } else {
                        extAlert(msg);

                        go_url("<c:url value='/scm/outprocess/ScmOutTransList.do?no=' />" + record.OUTTRANSNO + "&org=" + record.ORGID + "&company=" + record.COMPANYID);
                    }
                },
                error: ajaxError
            });

        } else {
            Ext.Msg.alert('외주입고 ' + flag_name, flag_name + ' 변경이 취소되었습니다.');
            return;
        }
    });
}

function fn_search() {
    // 필수 체크
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var outtransno = $('#OutTransNo').val();

    url = "<c:url value='/select/prod/outtrans/OutTransList.do' />";

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        OUTTRANSNO: outtransno,
        GUBUN: 'REGIST',
    };

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            //          var outtransno = dataList.OUTTRANSNO;
            var outtransdate = dataList.OUTTRANSDATE;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var transperson = dataList.TRANSPERSON;
            var transpersonname = dataList.TRANSPERSONNAME;
            var remarks = dataList.REMARKS;

            //          $("#OutTransNo").val(outtransno);
            $("#OutTransDate").val(outtransdate);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#PersonCode").val(transperson);
            $("#PersonName").val(transpersonname);
            $("#Remarks").val(remarks);

            global_close_yn = fn_monthly_close_filter_data(outtransdate, 'SCM');
        },
        error: ajaxError
    });
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function fn_list() {
    go_url("<c:url value='/scm/outprocess/ScmOutTransList.do'/>");
}

function fn_add() {
    go_url("<c:url value='/scm/outprocess/OutTransRegistDetail.do' />");
}

function fn_save() {
    // 필수 체크
    var TransDate = $('#OutTransDate').val(); // 입고일
    var CustomerCode = $('#CustomerCode').val(); // 가공처
    var PersonCode = $('#PersonCode').val(); // 입고담당자
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    if (TransDate === "") {
        header.push("입고일");
        count++;
    }
    if (CustomerCode === "") {
        header.push("가공처");
        count++;
    }
    if (PersonCode === "") {
        header.push("입고담당자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return false;
    }

    // 저장
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var outtransno = $('#OutTransNo').val();
    var isNew = outtransno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 입고 등록 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/scm/outprocess/OutWarehousingRegist.do' />";
        url1 = "<c:url value='/insert/scm/outprocess/OutWarehousingRegistGrid.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/scm/outprocess/OutWarehousingRegist.do' />";
        url1 = "<c:url value='/update/scm/outprocess/OutWarehousingRegistGrid.do' />";
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
                        var outtransno = data.OUTTRANSNO;

                        if (outtransno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("OUTTRANSNO", outtransno);
                                if (model.data.OUTTRANSNO != '') {
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
                                            go_url("<c:url value='/scm/outprocess/ScmOutTransList.do?no=' />" + outtransno + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('입고등록', '입고등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) { // UPDATE

        Ext.MessageBox.confirm('입고등록 변경 알림', '입고등록을 변경하시겠습니까?', function (btn) {
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
                        var outtransno = data.OutTransNo;

                        if (outtransno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("OUTTRANSNO", outtransno);
                                if (model.data.OUTTRANSNO != '') {
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
                                            go_url("<c:url value='/scm/outprocess/ScmOutTransList.do?no=' />" + outtransno + "&org=" + orgid + "&company=" + companyid);
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

function fn_delete() {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var transno = $('#OutTransNo').val();
    var url = "";

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (!gridcount == 0) {
        extAlert("[상세 데이터]<br/>상세 데이터가 있습니다.<br/>상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return false;
    }

    url = "<c:url value='/delete/scm/outprocess/OutWarehousingRegistHeader.do' />";

    Ext.MessageBox.confirm('삭제 알림', '해당 데이터를 삭제하시겠습니까?', function (btn) {
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
                        go_url("<c:url value='/scm/outprocess/ScmOutTransList.do' />");
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

function setLovList() {
    //    요청자 Lov
    $("#PersonName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#PersonCode").val("");
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
            $("#PersonCode").val(o.item.value);
            $("#PersonName").val(o.item.label);

            return false;
        }
    });

    // 거래처명 Lov
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
										<input type="hidden" id="popupPoFrom" />
										<input type="hidden" id="popupPoTo" />
										<input type="hidden" id="popupItemCode" name="popupItemCode" />
										<input type="hidden" id="popupItemName" name="popupItemName" />
										<input type="hidden" id="popupOrderName" name="popupOrderName" />
										<input type="hidden" id="popupModelName" name="popupModelName" />
										<input type="hidden" id="popupItemType" name="popupItemType" />
										<input type="hidden" id="popupCustomerCode" name="popupCustomerCode" />
										<input type="hidden" id="popupCustomerName" name="popupCustomerName" />
										<input type="hidden" id="popupOutTransNo" name="popupOutTransNo" />
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
																						<div class="buttons" style="float: right; margin-top: 3px;">
																								<a id="btnChk1" class="btn_search" href="#" onclick="javascript:btnSel();"> 입고대기 LIST </a>
																								<a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
																								<a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete();"> 삭제 </a>
																								<a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
																								<a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
																						</div>
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
																</colgroup>
																<tr style="height: 34px;">
																		<th class="required_text">입고번호</th>
																		<td><input type="text" id="OutTransNo" name="OutTransNo" class="input_center" value="${searchVO.OUTTRANSNO}" readonly style="width: 97%;" /></td>
																		<th class="required_text">입고일</th>
																		<td><input type="text" id="OutTransDate" name="OutTransDate" class="input_validation input_center " style="width: 97%;" maxlength="10" /></td>
																		<th class="required_text">가공처</th>
																		<td>
																				<input type="text" id="CustomerName" name="CustomerName" class="input_left input_validation" style="width: 97%;" />
																				<input type="hidden" id="CustomerCode" name="CustomerCode" />
																		</td>
																</tr>
																<tr style="height: 34px;">
																		<th class="required_text">입고담당자</th>
																		<td>
																				<input type="text" id="PersonName" name="PersonName" class="input_left input_validation" style="width: 97%;" />
																				<input type="hidden" id="PersonCode" name="PersonCode" />
																		</td>
																		<th class="required_text">비고</th>
																		<td colspan="3"><input type="text" id="Remarks" name="Remarks" class="input_left" style="width: 99%;" /></td>
																</tr>
														</table>
												</form>
										</fieldset>
								</div>
								<!-- //검색 필드 박스 끝 -->

								<div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
						</div>
						<!-- //content 끝 -->
				</div>
				<!-- //container 끝 -->
				<div id="gridPopupArea" style="width: 1635px; padding-top: 0px; float: left;"></div>
				<!-- footer 시작 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
				<!-- //footer 끝 -->
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>