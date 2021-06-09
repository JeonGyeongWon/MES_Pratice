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

    setValues_Popup();
    setExtGrid_Popup();

    setReadOnly();

    setLovList();

    $("#gridPopup1Area").hide("blind", {
        direction: "up"
    }, "fast");

});

var global_close_yn = "N";
function setInitial() {
    calender($('#searchFrom, #searchTo, #searchTransFrom, #searchTransTo'));

    $('#searchFrom, #searchTo, #searchTransFrom, #searchTransTo').keyup(function (event) {
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

    if ("${searchVO.CustomerCode}" == "") {}
    else {
        $('#searchCustomerName').attr('disabled', true);
        $("#searchCustomerName").val("${searchVO.CustomerName}");
        $("#searchCustomerCode").val("${searchVO.CustomerCode}");
    }

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });

    gridnms["app"] = "scm";
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "OutProcOrderStateList";

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
            //      }, {
            //        type: 'string',
            //        name: 'OUTTRANSNO',
            //      }, {
            //        type: 'number',
            //        name: 'OUTTRANSSEQ',
            //      }, {
            //        type: 'date',
            //        name: 'OUTTRANSDATE',
            //        dateFormat: 'Y-m-d',
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
            type: 'date',
            name: 'STANDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'number',
            name: 'WORKORDERSEQ',
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
            name: 'ITEMNAME',
        }, {
            type: 'string',
            name: 'ORDERNAME',
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
            name: 'POSTQTY',
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
            name: 'TRANSACTIONQTY',
        }, {
            type: 'number',
            name: 'RESTQTY',
        }, {
            type: 'number',
            name: 'BEFOREQTY',
        }, {
            type: 'date',
            name: 'DUEDATE',
            dateFormat: 'Y-m-d',
            //      }, {
            //        type: 'date',
            //        name: 'SCMDUEDATE',
            //        dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'TRADENO',
        }, {
            type: 'string',
            name: 'TRADESEQ',
        }, {
            type: 'string',
            name: 'SCMINSPECTIONYN',
        }, {
            type: 'number',
            name: 'STANDUNITPRICE',
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
            name: 'UNITPRICE',
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
            renderer: function (value, meta, record, row, col) {

                return new Ext.ux.CheckColumn().renderer(value);
            },
        }, {
            dataIndex: 'OUTPONO',
            text: '외주발주번호',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'OUTPOSEQ',
            text: '외주발주<br/>순번',
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
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'OUTPODATE',
            text: '외주발주일자',
            xtype: 'datecolumn',
            width: 110,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'CUSTOMERNAME',
            text: '가공처',
            xtype: 'gridcolumn',
            width: 170,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'DUEDATE',
            text: '납기요구일',
            xtype: 'datecolumn',
            width: 95,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
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
                return value;
            },
        }, {
            dataIndex: 'CARTYPENAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            text: '타입',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '공정명',
            xtype: 'gridcolumn',
            width: 70,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'STANDUNITPRICE',
            text: '기준단가',
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
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'UNITPRICE',
            text: '단가',
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
            renderer: function (value, meta, record) {
                var standunitprice = record.data.STANDUNITPRICE;

                if (standunitprice != value) {
                    meta.style += " color: rgb(255, 0, 0);";
                }

                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'XXXXXXXXXX',
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '',
            width: 85,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "단가적용",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    Ext.MessageBox.confirm('기준단가적용 ', '기준단가를 변경 하시겠습니까?', function (btn) {
                        if (btn == 'yes') {
                            var params = [];
                            params.push(record.data);
                            fn_price(params);
                        } else {
                            Ext.Msg.alert('기준단가적용 ', '기준단가적용이 취소되었습니다.');
                            return;
                        }
                    });

                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'STANDDATE',
            text: '적용일자',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: false,
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
                return Ext.util.Format.date(value, 'Y-m-d');
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
                return value;
            },
        }, {
            dataIndex: 'OUTTRANSNO',
            text: '외주입고번호',
            xtype: 'gridcolumn',
            width: 110,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'OUTTRANSSEQ',
            text: '외주입고<br/>순번',
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
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'OUTTRANSDATE',
            text: '외주입고일자',
            xtype: 'datecolumn',
            width: 110,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            summaryRenderer: function (value, meta, record) {
                value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>TOTAL</div>";
                return value;
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
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
                return value;
            },
            //      }, {
            //        dataIndex: 'POSTQTY',
            //        text: '후공정재고',
            //        xtype: 'gridcolumn',
            //        width: 90,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        format: "0,000",
            //        summaryType: 'sum',
            //        summaryRenderer: function (value, meta, record) {
            //          var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            //          return result;
            //        },
            //        renderer: function (value, meta, record) {
            //          return Ext.util.Format.number(value, '0,000');
            //        },
        }, {
            dataIndex: 'ORDERQTY',
            text: '발주수량',
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TRANSQTY',
            text: '입고수량',
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'FAULTQTY',
            text: '불량수량',
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'BEFOREQTY',
            text: '미입고<BR/>수량',
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
            //      }, {
            //        dataIndex: 'TRANSACTIONQTY',
            //        text: '거래명세서<br/>수량',
            //        xtype: 'gridcolumn',
            //        width: 90,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        format: "0,000",
            //        summaryType: 'sum',
            //        summaryRenderer: function (value, meta, record) {
            //          var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            //          return result;
            //        },
            //        renderer: function (value, meta, record) {
            //          return Ext.util.Format.number(value, '0,000');
            //        },
            //      }, {
            //        dataIndex: 'RESTQTY',
            //        text: '거래명세서<br/>잔여수량',
            //        xtype: 'gridcolumn',
            //        width: 90,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        format: "0,000",
            //        summaryType: 'sum',
            //        summaryRenderer: function (value, meta, record) {
            //          var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            //          return result;
            //        },
            //        renderer: function (value, meta, record) {
            //          return Ext.util.Format.number(value, '0,000');
            //        },
            //      }, {
            //        dataIndex: 'SCMINSPECTIONYN',
            //        text: '검사<br/>유무',
            //        xtype: 'gridcolumn',
            //        width: 60,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "center",
            //        renderer: function (value, meta, record) {
            //          return value;
            //        },
            //      }, {
            //        dataIndex: 'CHECKQTY',
            //        text: '검사수량',
            //        xtype: 'gridcolumn',
            //        width: 90,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        format: "0,000",
            //        summaryType: 'sum',
            //        summaryRenderer: function (value, meta, record) {
            //          var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            //          return result;
            //        },
            //        renderer: function (value, meta, record) {
            //          return Ext.util.Format.number(value, '0,000');
            //        },
            //      }, {
            //        dataIndex: 'PASSQTY',
            //        text: '합격수량',
            //        xtype: 'gridcolumn',
            //        width: 90,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        format: "0,000",
            //        summaryType: 'sum',
            //        summaryRenderer: function (value, meta, record) {
            //          var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            //          return result;
            //        },
            //        renderer: function (value, meta, record) {
            //          return Ext.util.Format.number(value, '0,000');
            //        },
            //      }, {
            //        dataIndex: 'FAILQTY',
            //        text: '불합격수량',
            //        xtype: 'gridcolumn',
            //        width: 90,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        format: "0,000",
            //        summaryType: 'sum',
            //        summaryRenderer: function (value, meta, record) {
            //          var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
            //          return result;
            //        },
            //        renderer: function (value, meta, record) {
            //          return Ext.util.Format.number(value, '0,000');
            //        },
            //      }, {
            //        dataIndex: 'TRADENO',
            //        text: '거래명세서번호',
            //        xtype: 'gridcolumn',
            //        width: 110,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "center",
            //        renderer: function (value, meta, record) {
            //          return value;
            //        },
            //      }, {
            //        dataIndex: 'TRADESEQ',
            //        text: '거래명세서<br/>순번',
            //        xtype: 'gridcolumn',
            //        width: 85,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "right",
            //        cls: 'ERPQTY',
            //        //format: "0,000",
            //        renderer: function (value, meta, record) {
            //          //return Ext.util.Format.number(value, '0,000');
            //          return value;
            //        },
        }, {
            dataIndex: 'SUPPLYPRICE',
            text: '공급가액',
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'ADDITIONALTAX',
            text: '부가세',
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TOTAL',
            text: '합계',
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
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 16px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
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
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/scm/outprocess/OutProcOrderStateList.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChkd1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "단가일괄적용",
        itemId: "btnPrice1"
    });

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnChkd1": {
            click: 'btnChk1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnPrice1": {
            click: 'btnPrice1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#MasterList": {
            itemdblclick: 'MasterListClick',
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

function MasterListClick(dataview, record, item, index, e, eOpts) {
    var dataIndex = e.position.column.dataIndex;

    switch (dataIndex) {
    case 'STANDUNITPRICE':

        btnSel1(record);
        break;
    default:
        break;
    }
}

var chkFlag = true;
function btnChk1Click() {
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var checkTrue = 0,
    checkFalse = 0;

    if (chkFlag) {
        chkFlag = false;
    } else {
        chkFlag = true;
    }

    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        if (!chkFlag) {
            // 체크 상태로
            model1.set("CHK", true);
            checkFalse++;
        } else {
            model1.set("CHK", false);
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

function btnPrice1Click(o, e) {

    Ext.MessageBox.confirm('기준단가적용 ', '기준단가를 변경 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var count1 = Ext.getStore(gridnms["store.1"]).count();
            var cnt = 0;
            var params = [];
            for (i = 0; i < count1; i++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
                var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                var standunitprice = model1.data.STANDUNITPRICE;
                var unitprice = model1.data.UNITPRICE;
                var chk = model1.data.CHK;

                if (standunitprice != unitprice && chk == true) {
                    params.push(model1.data);
                    cnt++;
                }

            }
            if (cnt > 0) {
                fn_price(params);
            }
        } else {
            Ext.Msg.alert('기준단가적용 ', '기준단가적용이 취소되었습니다.');
            return;
        }
    });
}

function fn_price(record) {
	var standarddate = Ext.util.Format.date(record.STANDDATE, 'Y-m-d');
	global_close_yn = fn_monthly_close_filter_data(standarddate, 'SCM');
	if (global_close_yn == "Y") {
	    extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
	    return false;
	}

    Ext.Ajax.request({
        url: "<c:url value='/insert/scm/outprocess/OutProcOrderStateList.do' />",
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        jsonData: {
            data: record
        },
        success: function (conn, response, options, eOpts) {
            Ext.getStore(gridnms["store.1"]).load();
        },
        error: ajaxError
    });
}

function setValues_Popup() {
    gridnms["models.popup1"] = [];
    gridnms["stores.popup1"] = [];
    gridnms["views.popup1"] = [];
    gridnms["controllers.popup1"] = [];

    gridnms["grid.2"] = "Popup1";

    gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
    gridnms["views.popup1"].push(gridnms["panel.2"]);

    gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
    gridnms["controllers.popup1"].push(gridnms["controller.2"]);

    gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

    gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

    gridnms["models.popup1"].push(gridnms["model.2"]);

    gridnms["stores.popup1"].push(gridnms["store.2"]);

    fields["model.2"] = [{
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
            name: 'ITEMCODE',
        }, {
            type: 'number',
            name: 'PRICESEQ',
        }, {
            type: 'string',
            name: 'ROUTINGID',
        }, {
            type: 'number',
            name: 'UNITPRICEA',
        }, {
            type: 'date',
            name: 'EFFECTIVESTARTDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'EFFECTIVEENDDATE',
            dateFormat: 'Y-m-d',
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
            style: 'text-align:center;',
            align: "center",
            cls: 'ERPQTY',
            format: "0,000",
        }, {
            dataIndex: 'UNITPRICEA',
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
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'EFFECTIVESTARTDATE',
            text: '유효시작일',
            xtype: 'datecolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'EFFECTIVEENDDATE',
            text: '유효종료일',
            xtype: 'datecolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                return Ext.util.Format.date(value, 'Y-m-d');
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
            dataIndex: 'ROUTINGID',
            xtype: 'hidden',
        }, ];

    items["api.2"] = {};
    $.extend(items["api.2"], {
        read: "<c:url value='/select/routing/SalesPriceRouting.do' />"
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

var gridarea, gridpopup1;
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
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            api: items["api.1"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                DATEFROM: $('#searchFrom').val(),
                                DATETO: $('#searchTo').val(),
                                CUSTOMERCODE: $('#searchCustomerCode').val(),
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
            MasterList: '#MasterList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        btnChk1Click: btnChk1Click,
        btnPrice1Click: btnPrice1Click,
        MasterListClick: MasterListClick,
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
                height: 653,
                border: 2,
                features: [{
                        ftype: 'summary',
                        dock: 'bottom'
                    }
                ],
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        ptype: 'bufferedrenderer',
                        trailingBufferZone: 20, // #1
                        leadingBufferZone: 20, // #2
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'MasterList',
                    striptRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMSTANDARDDETAIL') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('CARTYPENAME') >= 0) {
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

function setExtGrid_Popup() {
    Ext.define(gridnms["model.2"], {
        extend: Ext.data.Model,
        fields: fields["model.2"],
    });

    Ext.define(gridnms["store.2"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.2"],
                        model: gridnms["model.2"],
                        autoLoad: false,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.2"],
                            timeout: gridVals.timeout,
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.2"], {
        extend: Ext.app.Controller,
        refs: {
            btnPopup1: '#btnPopup1',
        },
        stores: [gridnms["store.2"]],
        control: items["btns.ctr.1"],

    });

    Ext.define(gridnms["panel.2"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.2"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.2"],
                id: gridnms["panel.2"],
                store: gridnms["store.2"],
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
                columns: fields["columns.2"],
                viewConfig: {
                    itemId: 'btnPopup1',
                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.2"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup1"],
        stores: gridnms["stores.popup1"],
        views: gridnms["views.popup1"],
        controllers: gridnms["controller.2"],

        launch: function () {
            gridpopup1 = Ext.create(gridnms["views.popup1"], {
                renderTo: 'gridPopup1Area'
            });
        },
    });

    Ext.EventManager.onWindowResize(function (w, h) {
        gridpopup1.updateLayout();
    });
}

var win1 = "";
function btnSel1(record) {
    // 생산계획 팝업
    var width = 380; // 가로
    var height = 605; // 세로
    var title = "외주가공비 단가";

    popup_flag = false;

    win1 = "";
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
                itemId: gridnms["panel.2"],
                id: gridnms["panel.2"],
                store: gridnms["store.2"],
                height: '100%',
                border: 2,
                scrollable: true,
                frameHeader: true,
                columns: fields["columns.2"],
                viewConfig: {
                    itemId: 'btnPopup1'
                },
                plugins: 'bufferedrenderer',
                dockedItems: items["docked.2"],
            }
        ],
    });
    win1.show();

    var sparams = {
        ORGID: record.data.ORGID,
        COMPANYID: record.data.COMPANYID,
        ITEMCODE: record.data.ITEMCODE,
        ROUTINGID: record.data.ROUTINGNO,
    };
    extGridSearch(sparams, gridnms["store.2"]);
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchFrom = $('#searchFrom').val();
    var searchTo = $('#searchTo').val();
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

    if (searchFrom === "") {
        header.push("발주일자 From");
        count++;
    }

    if (searchTo === "") {
        header.push("발주일자 To");
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

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var datefrom = $('#searchFrom').val();
    var dateto = $('#searchTo').val();
    var transfrom = $('#searchTransFrom').val();
    var transto = $('#searchTransTo').val();
    var searchCustomerCode = $('#searchCustomerCode').val();
    var searchCompleteYn = $('#searchCompleteYn').val();
    var itemname = $('#searchItemName').val();
    var ordername = $('#searchOrderName').val();
    var cartypename = $('#searchCarTypeName').val();

    var sparams = {
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
        DATEFROM: datefrom,
        DATETO: dateto,
        TRANSFROM: transfrom,
        TRANSTO: transto,
        CUSTOMERCODE: searchCustomerCode,
        COMPLETEYN: searchCompleteYn,
        ITEMNAME: itemname,
        ORDERNAME: ordername,
        CARTYPENAME: cartypename,
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_excel_download() {
    if (!fn_validation()) {
        return;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var datefrom = $('#searchFrom').val();
    var dateto = $('#searchTo').val();
    var transfrom = $('#searchTransFrom').val();
    var transto = $('#searchTransTo').val();
    var searchCustomerCode = $('#searchCustomerCode').val();
    var searchCompleteYn = $('#searchCompleteYn').val();
    var itemname = $('#searchItemName').val();
    var ordername = $('#searchOrderName').val();
    var cartypename = $('#searchCarTypeName').val();

    go_url("<c:url value='/scm/outprocess/ExcelDownload.do?ORGID='/>" + orgid
         + "&COMPANYID=" + companyid + ""
         + "&DATEFROM=" + datefrom + ""
         + "&DATETO=" + dateto + ""
         + "&TRANSFROM=" + transfrom + ""
         + "&TRANSTO=" + transto + ""
         + "&CUSTOMERCODE=" + searchCustomerCode + ""
         + "&COMPLETEYN=" + searchCompleteYn + ""
         + "&ITEMNAME=" + itemname + ""
         + "&ORDERNAME=" + ordername + ""
         + "&CARTYPENAME=" + cartypename + ""
         + "&TITLE=" + "${pageTitle}" + "");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
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
                                        <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center " style="width: 90px; " maxlength="10" />
                                        &nbsp;~&nbsp;
                                        <input type="text" id="searchTo" name="searchTo" class="input_validation input_center " style="width: 90px; " maxlength="10"  />
                                    </td>
                                    <th class="required_text">입고일자</th>
                                    <td >
                                        <input type="text" id="searchTransFrom" name="searchTransFrom" class="input_center " style="width: 90px; " maxlength="10" />
                                        &nbsp;~&nbsp;
                                        <input type="text" id="searchTransTo" name="searchTransTo" class="input_center " style="width: 90px; " maxlength="10"  />
                                    </td>
                                    <th class="required_text">가공처</th>
                                    <td>
                                          <input type="text" id="searchCustomerName" name="searchCustomerName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                    </td>
                                    <th class="required_text">완료여부</th>
                                    <td>
                                       <select id="searchCompleteYn" name="searchCompleteYn" style="width: 70%; ">
                                           <option value="">전체</option>
                                           <option value="Y">완료</option>
                                           <option value="N">미완료</option>
                                       </select>
                                    </td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">품번</th>
                                    <td >
                                        <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                    </td>
                                    <th class="required_text">품명</th>
                                    <td >
                                        <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                    </td>
                                    <th class="required_text">기종</th>
                                    <td >
                                        <input type="text" id="searchCarTypeName" name="searchCarTypeName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                    </td>
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
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 380px; padding-top: 0px; float: left;"></div>
        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>