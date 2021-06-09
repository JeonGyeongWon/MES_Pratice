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

<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload.css'/>">
<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload-ui.css'/>">

<!-- jQuery-File-Upload-9.9.3 -->
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/load-image.all.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-process.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-image.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/app.js'/>"></script>

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

    setValues_Popup1();
    setExtGrid_Popup1();

    setValues_Popup2();
    setExtGrid_Popup2();

    $("#gridPopup1Area").hide("blind", {
        direction: "up"
    }, "fast");

    $("#gridPopup2Area").hide("blind", {
        direction: "up"
    }, "fast");

    setReadOnly();
    setLovList();

    setLastInitial();
});

var global_close_yn = "N";
function setInitial() {
    // 최초 상태 설정
    gridnms["app"] = "order";

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

    fn_option_change_r('OM', 'SHIP_GUBUN', 'ShipGubun');
    $('#searchOrgId, #searchCompanyId').change(function (event) {
        fn_option_change_r('OM', 'SHIP_GUBUN', 'ShipGubun');
    });
}

function setLastInitial() {
    var tradeno = $('#TradeNo').val();
    var isCheck = tradeno.length == 0 ? false : true;
    if (isCheck) {
        fn_search();
    } else {
        $("#TradeDate").val(getToDay("${searchVO.TODAY}") + "");

        var groupid = "${searchVO.groupId}";
        switch (groupid) {
        case "ROLE_ADMIN":
            // 관리자 권한일 때 그냥 놔둠
            break;
        default:
            // 관리자 외 권한일 때 사용자명 표기
            $('#TransactionPersonName').val("${searchVO.krname}");
            $('#TransactionPerson').val("${searchVO.employeenumber}");
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

    gridnms["grid.1"] = "TransDetailRegist";

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
            type: 'number',
            name: 'CLOSINGDATE',
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'TRADENO',
        }, {
            type: 'number',
            name: 'TRADESEQ',
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
            name: 'DRAWINGNO',
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
            name: 'MATERIALTYPE',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'number',
            name: 'SHIPQTY',
        }, {
            type: 'number',
            name: 'BEFOREQTY',
        }, {
            type: 'number',
            name: 'SUMQTY',
        }, {
            type: 'number',
            name: 'TRANSACTIONQTY',
        }, {
            type: 'number',
            name: 'WEIGHT',
        }, {
            type: 'number',
            name: 'SUMWEIGHT',
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
            name: 'SHIPNO',
        }, {
            type: 'number',
            name: 'SHIPSEQ',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'number',
            name: 'SOSEQ',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, ];

    fields["columns.1"] = [
        // Display columns
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

                //          var result = record.data.TRADEYNNAME;

                //          if (result == "생성") {
                //            meta['tdCls'] = 'x-item-disabled';
                //          } else {
                meta['tdCls'] = '';
                //          }
                return new Ext.ux.CheckColumn().renderer(value);
            },
            listeners: {
                beforecheckchange: function (options, row, value, event) {

                    var record = Ext.getCmp(gridnms["views.order"]).selModel.store.data.items[row].data;
                    if (value) {
                        //                     var result = record.data.TRADEYNNAME;
                        //                     if (result == "생성") {
                        //                       extAlert("거래명세서가 생성된 경우 출하삭제가 불가능합니다.<br/>다시 한번 확인해주십시오.");
                        //                       return false;
                        //                     }
                    }
                }
            }
        }, {
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
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
                _btnText: "이월",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    //            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                    var selectedRow;

                    //            var ostype = Ext.os.deviceType;
                    //            if (ostype == "Desktop") {
                    //              // 구버전 rowindex찾기
                    //              selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getPosition().rowIdx;
                    //            } else {
                    var rn = record.data.RN * 1;
                    selectedRow = rn - 1;
                    //            }

                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                    var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                    var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                    var dummydate = (record.data.ENDDATE == null || record.data.ENDDATE == undefined) ? $('#TradeDate').val() : record.data.ENDDATE;
                    var tradedate = Ext.util.Format.date(dummydate, 'Y-m-d');
                    var cnt = isNaN(record.data.FORWARDCNT * 1) ? 1 : (record.data.FORWARDCNT * 1);

                    //            if (cnt > 0) {
                    // 마감일은 MONTH + N의 1일자로 설정
                    var change_day = new Date(tradedate);
                    change_day.setMonth(change_day.getMonth() + cnt);
                    change_day.setDate(1);
                    var enddate = Ext.Date.format(change_day, 'Y-m-d');

                    model.set("ENDDATE", enddate);
                    //            } else {
                    //              // 마감일은 발행월의 25일자로 설정
                    //              //              var closedate = ((record.data.CLOSINGDATE * 1) == 0) ? 25 : (record.data.CLOSINGDATE * 1);
                    //              var closedate = record.data.CLOSINGDATE * 1;
                    //              var change_day = new Date(tradedate);
                    //              change_day.setDate(closedate);
                    //              var enddate = Ext.Date.format(change_day, 'Y-m-d');

                    //              model.set("ENDDATE", enddate);
                    //            }
                    //                 cnt++;
                    //                 model.set("FORWARDCNT", cnt);
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'ENDDATE',
            text: '마감일자',
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
                meta.style = "background-color:rgb(253, 218, 255)";
                return Ext.util.Format.date(value, 'Y-m-d');
            },
            //      }, {
            //        dataIndex: 'SMALLNAME',
            //        text: '소분류',
            //        xtype: 'gridcolumn',
            //        width: 120,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        align: "center",
            //        renderer: function (value, meta, record) {
            //          meta.style = "background-color:rgb(234, 234, 234)";
            //          return value;
            //        },
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
            align: "center",
            summaryRenderer: function (value, meta, record) {
                value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>TOTAL</div>";
                return value;
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'CARTYPENAME',
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
            dataIndex: 'SHIPQTY',
            text: '출하수량',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
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
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'TRANSACTIONQTY',
            text: '수량',
            xtype: 'gridcolumn',
            width: 70,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
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
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var qty = field.getValue() * 1; // 출고수량

                        var unitprice = store.data.UNITPRICE; // 단가

                        var supplyprice = qty * unitprice //공급가액
                            store.set("SUPPLYPRICE", supplyprice);

                        var additionaltax = supplyprice * 0.1 // 부가세
                            store.set("ADDITIONALTAX", additionaltax);

                        var total = supplyprice + (supplyprice * 0.1) // 합계
                            store.set("TOTAL", total);

                        //중량 계산 시작
                        var weight = (store.data.WEIGHT * qty);
                        store.set("SUMWEIGHT", weight);
                        //중량 계산 끝
                    },
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'UNITPRICE',
            text: '단가',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
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
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var qty = store.data.TRANSACTIONQTY; // 출고수량

                        var unitprice = field.getValue(); // 단가

                        var supplyprice = qty * unitprice //공급가액
                            store.set("SUPPLYPRICE", supplyprice);

                        var additionaltax = supplyprice * 0.1 // 부가세
                            store.set("ADDITIONALTAX", additionaltax);

                        var total = supplyprice + (supplyprice * 0.1) // 합계
                            store.set("TOTAL", total);

                        //중량 계산 시작
                        var weight = (store.data.WEIGHT * qty);
                        store.set("SUMWEIGHT", weight);
                        //중량 계산 끝
                    },
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
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
                maxLength: '10',
                maskRe: /[0-9]/,
                selectOnFocus: true,
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var supplyprice = newValue;

                        var additionaltax = supplyprice * 0.1; // 부가세
                        store.set("ADDITIONALTAX", additionaltax);

                        var total = ((supplyprice * 1) + (supplyprice * 0.1)); // 합계
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
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
            }
        }, {
            dataIndex: 'SHIPNO',
            text: '출하번호',
            xtype: 'gridcolumn',
            width: 155,
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
            dataIndex: 'SHIPSEQ',
            text: '출하<br/>순번',
            xtype: 'gridcolumn',
            width: 60,
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
                return Ext.util.Format.number(value, '0,000');
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
            dataIndex: 'TRADESEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'SONO',
            xtype: 'hidden',
        }, {
            dataIndex: 'SOSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'FORWARDCNT',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/order/trans/TransDetailDetailList.do' />"
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

        if (btn_click) {
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

function btnDel1() {
    if ( global_close_yn == "Y" ) {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
      }
    
    var store = this.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var tradeno = $('#TradeNo').val();
    var tradeseq = "";
    var url = "<c:url value='/delete/order/trans/TransDetailDetailList.do' />";

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
                                        go_url("<c:url value='/order/trans/TransDetailRegist.do?TRADENO=' />" + tradeno + "&org=" + orgid + "&company=" + companyid);

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
                                go_url("<c:url value='/order/trans/TransDetailRegist.do?TRADENO=' />" + tradeno + "&org=" + orgid + "&company=" + companyid);
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
            MasterClick: '#MasterClick',
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
                height: 619,
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
                        trailingBufferZone: 20,
                        leadingBufferZone: 20,
                        synchronousRender: false,
                        numFromEdge: 19,
                    }
                ],
                viewConfig: {
                    itemId: 'MasterClick',
                    trackOver: true,
                    loadMask: true,
                    striptRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 120) {
                                        column.width = 120;
                                    }
                                }

                                //                  if (column.dataIndex.indexOf('CARTYPENAME') >= 0) {
                                //                    column.autoSize();
                                //                    column.width += 5;
                                //                    if (column.width < 80) {
                                //                      column.width = 80;
                                //                    }
                                //                  }
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

function setValues_Popup1() {
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
            name: 'CLOSINGDATE',
        }, {
            type: 'string',
            name: 'CLOSINGDATENAME',
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'ORDERNAME',
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
            name: 'ITEMSTANDARD',
        }, {
            type: 'string',
            name: 'CARTYPE',
        }, {
            type: 'string',
            name: 'CARTYPENAME',
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
            name: 'SHIPQTY',
        }, {
            type: 'number',
            name: 'BEFOREQTY',
        }, {
            type: 'number',
            name: 'QTY',
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
            name: 'SHIPNO',
        }, {
            type: 'number',
            name: 'SHIPSEQ',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'number',
            name: 'SOSEQ',
        }, {
            type: 'string',
            name: 'SHIPGUBUN',
        }, {
            type: 'string',
            name: 'SHIPGUBUNNAME',
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
            width: 110,
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
            dataIndex: 'SHIPQTY',
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
            dataIndex: 'UNITPRICE',
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
        }, {
            dataIndex: 'SHIPNO',
            text: '출하번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'SHIPSEQ',
            text: '출하<br/>순번',
            xtype: 'gridcolumn',
            width: 60,
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
            dataIndex: 'SONO',
            xtype: 'hidden',
        }, {
            dataIndex: 'SOSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'CLOSINGDATENAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'ENDDATE',
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
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMSTANDARD',
            xtype: 'hidden',
        }, {
            dataIndex: 'QTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'SHIPGUBUN',
            xtype: 'hidden',
        }, {
            dataIndex: 'SHIPGUBUNNAME',
            xtype: 'hidden',
        }, ];

    items["api.5"] = {};
    $.extend(items["api.5"], {
        read: "<c:url value='/searchTransShippingPopupList.do'/>"
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

var gridpopup1;
function setExtGrid_Popup1() {
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

//수주현황 리스트 팝업
function setValues_Popup2() {
    gridnms["models.popup2"] = [];
    gridnms["stores.popup2"] = [];
    gridnms["views.popup2"] = [];
    gridnms["controllers.popup2"] = [];

    gridnms["grid.20"] = "Popup2";
    gridnms["grid.21"] = "BigCodePopup";
    gridnms["grid.22"] = "MiddleCodePopup";
    gridnms["grid.23"] = "SmallCodePopup";

    gridnms["panel.20"] = gridnms["app"] + ".view." + gridnms["grid.20"];
    gridnms["views.popup2"].push(gridnms["panel.20"]);

    gridnms["controller.20"] = gridnms["app"] + ".controller." + gridnms["grid.20"];
    gridnms["controllers.popup2"].push(gridnms["controller.20"]);

    gridnms["model.20"] = gridnms["app"] + ".model." + gridnms["grid.20"];
    gridnms["model.21"] = gridnms["app"] + ".model." + gridnms["grid.21"];
    gridnms["model.22"] = gridnms["app"] + ".model." + gridnms["grid.22"];
    gridnms["model.23"] = gridnms["app"] + ".model." + gridnms["grid.23"];

    gridnms["store.20"] = gridnms["app"] + ".store." + gridnms["grid.20"];
    gridnms["store.21"] = gridnms["app"] + ".store." + gridnms["grid.21"];
    gridnms["store.22"] = gridnms["app"] + ".store." + gridnms["grid.22"];
    gridnms["store.23"] = gridnms["app"] + ".store." + gridnms["grid.23"];

    gridnms["models.popup2"].push(gridnms["model.20"]);
    gridnms["models.popup2"].push(gridnms["model.21"]);
    gridnms["models.popup2"].push(gridnms["model.22"]);
    gridnms["models.popup2"].push(gridnms["model.23"]);

    gridnms["stores.popup2"].push(gridnms["store.20"]);
    gridnms["stores.popup2"].push(gridnms["store.21"]);
    gridnms["stores.popup2"].push(gridnms["store.22"]);
    gridnms["stores.popup2"].push(gridnms["store.23"]);

    fields["model.20"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'string',
            name: 'CLOSINGDATE',
        }, {
            type: 'string',
            name: 'CLOSINGDATENAME',
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d',
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
            name: 'DRAWINGNO',
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
            name: 'MATERIALTYPE',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'number',
            name: 'SOSEQ',
        }, {
            type: 'number',
            name: 'SHIPQTY',
        }, {
            type: 'number',
            name: 'SOQTY',
        }, {
            type: 'number',
            name: 'BEFOREQTY',
        }, {
            type: 'number',
            name: 'QTY',
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
        }, ];

    fields["model.21"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.22"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.23"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.20"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'rownumberer',
            width: 45,
            hidden: false,
            sortable: false,
            resizable: false,
            style: 'text-align:center;',
            align: "right",
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
            dataIndex: 'DRAWINGNO',
            text: '도번',
            xtype: 'gridcolumn',
            width: 180,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
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
            width: 110,
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
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'SOQTY',
            text: '수주수량',
            xtype: 'gridcolumn',
            width: 70,
            hidden: false,
            sortable: false,
            resizable: false,
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
            width: 70,
            hidden: false,
            sortable: false,
            resizable: false,
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
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'SONO',
            text: '수주번호',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'SOSEQ',
            text: '수주내역<br/>순번',
            xtype: 'gridcolumn',
            width: 70,
            hidden: false,
            sortable: false,
            resizable: false,
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
            dataIndex: 'PRESENTINVENTORYQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'CLOSINGDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CLOSINGDATENAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'ENDDATE',
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
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, ];

    items["api.20"] = {};
    $.extend(items["api.20"], {
        read: "<c:url value='/searchSalesShippingPopupList.do'/>"
    });

    items["btns.20"] = [];

    items["btns.ctr.20"] = {};

    items["dock.paging.20"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.20"],
    };

    items["dock.btn.20"] = {
        xtype: 'toolbar',
        dock: 'top',
        displayInfo: true,
        store: gridnms["store.20"],
        items: items["btns.20"],
    };

    items["docked.20"] = [];
}

var gridpopup2;
function setExtGrid_Popup2() {
    Ext.define(gridnms["model.20"], {
        extend: Ext.data.Model,
        fields: fields["model.20"],
    });

    Ext.define(gridnms["model.21"], {
        extend: Ext.data.Model,
        fields: fields["model.21"],
    });

    Ext.define(gridnms["model.22"], {
        extend: Ext.data.Model,
        fields: fields["model.22"],
    });

    Ext.define(gridnms["model.23"], {
        extend: Ext.data.Model,
        fields: fields["model.23"],
    });

    Ext.define(gridnms["store.20"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.20"],
                        model: gridnms["model.20"],
                        autoLoad: true,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.20"],
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

    Ext.define(gridnms["store.21"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.21"],
                        model: gridnms["model.21"],
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

    Ext.define(gridnms["store.22"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.22"],
                        model: gridnms["model.22"],
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

    Ext.define(gridnms["store.23"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.23"],
                        model: gridnms["model.23"],
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

    Ext.define(gridnms["controller.20"], {
        extend: Ext.app.Controller,
        refs: {
            btnPopup2: '#btnPopup2',
        },
        stores: [gridnms["store.20"]],
    });

    Ext.define(gridnms["panel.20"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.20"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'cellmodel',
                itemId: gridnms["panel.20"],
                id: gridnms["panel.20"],
                store: gridnms["store.20"],
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
                columns: fields["columns.20"],
                viewConfig: {
                    itemId: 'btnPopup2',
                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.20"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup2"],
        stores: gridnms["stores.popup2"],
        views: gridnms["views.popup2"],
        controllers: gridnms["controller.20"],

        launch: function () {
            gridpopup2 = Ext.create(gridnms["views.popup2"], {
                renderTo: 'gridPopup2Area'
            });
        },
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
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

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력(선택)해주세요.");
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
    var tradeno = $('#TradeNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TRADENO: tradeno,
    };

    var url = "<c:url value='/select/order/trans/TransDetailMasterList.do' />";

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var tradeno = dataList.TRADENO;
            var tradedate = dataList.TRADEDATE;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var transactionpersonname = dataList.KRNAME;
            var transactionperson = dataList.TRANSACTIONPERSON;
            var shipgubun = dataList.SHIPGUBUN;
            var remarks = dataList.REMARKS;

            $("#TradeNo").val(tradeno);
            $("#TradeDate").val(tradedate);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#TransactionPersonName").val(transactionpersonname);
            $("#TransactionPerson").val(transactionperson);
            $("#ShipGubun").val(shipgubun);
            $("#ReMarks").val(remarks);

            global_close_yn = fn_monthly_close_filter_data(tradedate, 'OM');
        },
        error: ajaxError
    });
}

var global_popup_flag = false;
function btnSel1(btn) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return false;
    }

    // 출하현황 팝업
    var width = 1550; // 가로
    var height = 640; // 500; // 세로
    var title = "출하현황 Popup";
    global_popup_flag = false;

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
                width: 100,
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

                        $('#popupMiddleCode').val("");
                        $('#popupMiddleName').val("");
                        $('#popupSmallCode').val("");
                        $('#popupSmallName').val("");

                        $('input[name=searchMiddleName]').val("");
                        $('input[name=searchSmallName]').val("");
                        $('input[name=searchItemName]').val("");

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
                    change: function (value, nv, ov, e, record) {
                        var result = value.getValue();

                        //               $('#popupBigCode').val(record.data.VALUE);
                        //               $('#popupBigName').val(record.data.LABEL);

                        //               $('#popupMiddleCode').val("");
                        //               $('#popupMiddleName').val("");
                        //               $('#popupSmallCode').val("");
                        //               $('#popupSmallName').val("");

                        $('input[name=searchMiddleName]').val("");
                        $('input[name=searchSmallName]').val("");
                        $('input[name=searchItemName]').val("");

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
                            if (result === "") {
                                $('#popupBigCode').val("");
                                $('#popupBigName').val("");
                                $('#popupMiddleCode').val("");
                                $('#popupMiddleName').val("");
                                $('#popupSmallCode').val("");
                                $('#popupSmallName').val("");

                                $('input[name=searchMiddleName]').val("");
                                $('input[name=searchSmallName]').val("");
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
                width: 80,
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

                        $('#popupSmallCode').val("");
                        $('#popupSmallName').val("");

                        $('input[name=searchSmallName]').val("");

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.12"]);
                    },
                    change: function (value, nv, ov, e, record) {
                        var result = value.getValue();

                        //               $('#popupMiddleCode').val(record.data.VALUE);
                        //               $('#popupMiddleName').val(record.data.LABEL);

                        //               $('#popupSmallCode').val("");
                        //               $('#popupSmallName').val("");

                        $('input[name=searchSmallName]').val("");

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.12"]);

                        if (nv !== ov) {

                            if (result === "") {
                                $('#popupMiddleCode').val("");
                                $('#popupMiddleName').val("");
                                $('#popupSmallCode').val("");
                                $('#popupSmallName').val("");

                                $('input[name=searchSmallName]').val("");
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

                            if (result === "") {
                                $('#popupSmallCode').val("");
                                $('#popupSmallName').val("");
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
            '출하번호', {
                xtype: 'textfield',
                name: 'searchShipNo',
                clearOnReset: true,
                hideLabel: true,
                width: 130,
                editable: true,
                allowBlank: true,
                listeners: {
                    scope: this,
                    buffer: 50,
                    change: function (value, nv, ov, e) {
                        value.setValue(nv.toUpperCase());
                        var result = value.getValue();

                        $('#popupShipNo').val(result);
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

                    if (global_popup_flag) {
                        global_popup_flag = false;
                    } else {
                        global_popup_flag = true;
                    }
                    for (var i = 0; i < count5; i++) {
                        Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
                        var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];

                        var chk = model5.data.CHK;

                        if (global_popup_flag) {
                            // 체크 상태로
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
                            for (var j = 0; j < count; j++) {
                                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(j));
                                var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
                                var shipno1 = model.data.SHIPNO;
                                var shipseq1 = model.data.SHIPSEQ;
                                var shipno2 = model5.data.SHIPNO;
                                var shipseq2 = model5.data.SHIPSEQ;

                                if (shipno2 == shipno1) {
                                    if (shipseq1 == shipseq2) {
                                        extAlert("해당 데이터가 있습니다.<br/>다시 한번 확인 해주십시오.");
                                        return;
                                    }
                                }
                            }
                            checknum++;
                        }
                    }
                    console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                    if (checknum == 0) {
                        extAlert("선택 된 데이터가 없습니다.<br/>다시 한번 확인 해주십시오.");
                        return false;
                    }

                    if (count5 == 0) {
                        console.log("[적용] 출하 정보가 없습니다.");
                    } else {
                        for (var j = 0; j < count5; j++) {
                            Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
                            var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
                            var chk = model5.data.CHK;
                            if (chk === true) {
                                var model = Ext.create(gridnms["model.1"]);
                                var store = Ext.getStore(gridnms["store.1"]);

                                // 순번
                                model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);
                                model.set("TRADESEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                // 팝업창의 체크된 항목 이동
                                model.set("SMALLCODE", model5.data.SMALLCODE);
                                model.set("SMALLNAME", model5.data.SMALLNAME);
                                model.set("ITEMCODE", model5.data.ITEMCODE);
                                model.set("ORDERNAME", model5.data.ORDERNAME);
                                model.set("ITEMNAME", model5.data.ITEMNAME);
                                model.set("CARTYPE", model5.data.CARTYPE);
                                model.set("CARTYPENAME", model5.data.CARTYPENAME);
                                model.set("ITEMSTANDARDDETAIL", model5.data.ITEMSTANDARDDETAIL);
                                model.set("UOM", model5.data.UOM);
                                model.set("UOMNAME", model5.data.UOMNAME);

                                model.set("TRANSACTIONQTY", model5.data.QTY);
                                model.set("BEFOREQTY", model5.data.BEFOREQTY);
                                model.set("SHIPQTY", model5.data.SHIPQTY);
                                model.set("CLOSINGDATE", model5.data.CLOSINGDATE);

                                model.set("WEIGHT", model5.data.WEIGHT);
                                model.set("SUMWEIGHT", model5.data.SUMWEIGHT);
                                model.set("ENDDATE", model5.data.ENDDATE);

                                model.set("UNITPRICE", model5.data.UNITPRICE);
                                model.set("SUPPLYPRICE", model5.data.SUPPLYPRICE);
                                model.set("ADDITIONALTAX", model5.data.ADDITIONALTAX);
                                model.set("TOTAL", model5.data.TOTAL);
                                model.set("SHIPNO", model5.data.SHIPNO);
                                model.set("SHIPSEQ", model5.data.SHIPSEQ);
                                model.set("SONO", model5.data.SONO);
                                model.set("SOSEQ", model5.data.SOSEQ);
                                model.set("REMARKS", model5.data.ITEMSTANDARD);

                                $("#ShipGubun").val(model5.data.SHIPGUBUN);

                                // 그리드 적용 방식
                                store.add(model);

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
        SHIPNO: $('#popupShipNo').val(),
        CUSTOMERCODE: $('#CustomerCode').val(),
    };
    extGridSearch(params, gridnms["store.5"]);
}

var global_popup_flag2 = false;
function btnSel2(btn) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return false;
    }

    // 수주현황 팝업
    var width = 1420; // 가로
    var height = 640; // 500; // 세로
    var title = "수주현황 Pop up";
    global_popup_flag2 = false;

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
    Ext.getStore(gridnms['store.20']).removeAll();

    win22 = Ext.create('Ext.window.Window', {
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
                itemId: gridnms["panel.20"],
                id: gridnms["panel.20"],
                store: gridnms["store.20"],
                height: '100%',
                border: 2,
                scrollable: true,
                frameHeader: true,
                columns: fields["columns.20"],
                viewConfig: {
                    itemId: 'onMypopClick'
                },
                plugins: 'bufferedrenderer',
                dockedItems: items["docked.20"],
            }
        ],
        tbar: [
            '대분류', {
                xtype: 'combo',
                name: 'searchBigCode',
                clearOnReset: true,
                hideLabel: true,
                width: 100,
                store: gridnms["store.21"],
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

                        $('#popupMiddleCode').val("");
                        $('#popupMiddleName').val("");
                        $('#popupSmallCode').val("");
                        $('#popupSmallName').val("");

                        $('input[name=searchMiddleName]').val("");
                        $('input[name=searchSmallName]').val("");
                        $('input[name=searchItemName]').val("");

                        var sparams1 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                        };
                        extGridSearch(sparams1, gridnms["store.22"]);

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.23"]);
                    },
                    change: function (value, nv, ov, e) {
                        var result = value.getValue();

                        $('#popupBigCode').val(record.data.VALUE);
                        $('#popupBigName').val(record.data.LABEL);

                        $('#popupMiddleCode').val("");
                        $('#popupMiddleName').val("");
                        $('#popupSmallCode').val("");
                        $('#popupSmallName').val("");

                        $('input[name=searchMiddleName]').val("");
                        $('input[name=searchSmallName]').val("");
                        $('input[name=searchItemName]').val("");

                        var sparams1 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                        };
                        extGridSearch(sparams1, gridnms["store.22"]);

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.23"]);

                        if (nv !== ov) {
                            if (result === "") {
                                $('#popupBigCode').val("");
                                $('#popupBigName').val("");
                                $('#popupMiddleCode').val("");
                                $('#popupMiddleName').val("");
                                $('#popupSmallCode').val("");
                                $('#popupSmallName').val("");

                                $('input[name=searchMiddleName]').val("");
                                $('input[name=searchSmallName]').val("");
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
                width: 80,
                store: gridnms["store.22"],
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

                        $('#popupSmallCode').val("");
                        $('#popupSmallName').val("");

                        $('input[name=searchSmallName]').val("");

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.23"]);
                    },
                    change: function (value, nv, ov, e) {
                        var result = value.getValue();

                        $('#popupMiddleCode').val(record.data.VALUE);
                        $('#popupMiddleName').val(record.data.LABEL);

                        $('#popupSmallCode').val("");
                        $('#popupSmallName').val("");

                        $('input[name=searchSmallName]').val("");

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.23"]);

                        if (nv !== ov) {

                            if (result === "") {
                                $('#popupMiddleCode').val("");
                                $('#popupMiddleName').val("");
                                $('#popupSmallCode').val("");
                                $('#popupSmallName').val("");

                                $('input[name=searchSmallName]').val("");
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

                            if (result === "") {
                                $('#popupSmallCode').val("");
                                $('#popupSmallName').val("");
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
                    var count20 = Ext.getStore(gridnms["store.20"]).count();
                    var checkTrue = 0,
                    checkFalse = 0;

                    if (global_popup_flag2) {
                        global_popup_flag2 = false;
                    } else {
                        global_popup_flag2 = true;
                    }
                    for (var i = 0; i < count20; i++) {
                        Ext.getStore(gridnms["store.20"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(i));
                        var model20 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];

                        var chk = model20.data.CHK;

                        if (global_popup_flag2) {
                            // 체크 상태로
                            model20.set("CHK", true);
                            checkFalse++;
                        } else {
                            model20.set("CHK", false);
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
                    var count20 = Ext.getStore(gridnms["store.20"]).count();
                    var checknum = 0,
                    checkqty = 0,
                    checktemp = 0;
                    var qtytemp = [];

                    for (var i = 0; i < count20; i++) {
                        Ext.getStore(gridnms["store.20"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(i));
                        var model20 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
                        var chk = model20.data.CHK;
                        var sono = $('#SoNo').val();
                        if (chk == true) {
                            for (var j = 0; j < count; j++) {
                                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(j));
                                var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
                                var sono2 = model20.data.SONO;
                                var soseq2 = model20.data.SOSEQ;
                                var sono1 = model.data.SONO;
                                var soseq1 = model.data.SOSEQ;

                                if (sono1 == sono2) {
                                    if (soseq1 == soseq2) {
                                        extAlert("해당 데이터가 있습니다.<br/>다시 한번 확인해주십시오.");
                                        return;
                                    }
                                }
                            }
                            checknum++;
                        }
                    }
                    console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                    if (checknum == 0) {
                        extAlert("선택 된 데이터가 없습니다.<br/>다시 한번 확인해주십시오.");
                        return false;
                    }

                    if (count20 == 0) {
                        console.log("[적용] 수주 정보가 없습니다.");
                    } else {
                        for (var k = 0; k < count20; k++) {
                            Ext.getStore(gridnms["store.20"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(k));
                            var model20 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
                            var chk = model20.data.CHK;
                            if (chk === true) {
                                var model = Ext.create(gridnms["model.1"]);
                                var store = Ext.getStore(gridnms["store.1"]);

                                // 순번
                                model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);
                                model.set("TRADESEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                // 팝업창의 체크된 항목 이동
                                model.set("SMALLCODE", model20.data.SMALLCODE);
                                model.set("SMALLNAME", model20.data.SMALLNAME);
                                model.set("ITEMCODE", model20.data.ITEMCODE);
                                model.set("ORDERNAME", model20.data.ORDERNAME);
                                model.set("ITEMNAME", model20.data.ITEMNAME);
                                model.set("CARTYPE", model20.data.CARTYPE);
                                model.set("CARTYPENAME", model20.data.CARTYPENAME);
                                model.set("ITEMSTANDARDDETAIL", model20.data.ITEMSTANDARDDETAIL);
                                model.set("UOM", model20.data.UOM);
                                model.set("UOMNAME", model20.data.UOMNAME);
                                model.set("SOQTY", model20.data.SOQTY);
                                model.set("BEFOREQTY", model20.data.SHIPQTY);
                                model.set("UNITPRICE", model20.data.UNITPRICE);
                                model.set("SUPPLYPRICE", model20.data.SUPPLYPRICE);
                                model.set("ADDITIONALTAX", model20.data.ADDITIONALTAX);
                                model.set("TOTAL", model20.data.TOTAL);
                                model.set("SONO", model20.data.SONO);
                                model.set("SOSEQ", model20.data.SOSEQ);

                                model.set("SHIPQTY", model20.data.SOQTY);
                                model.set("BEFOREQTY", model20.data.BEFOREQTY);
                                model.set("TRANSACTIONQTY", model20.data.QTY);

                                model.set("WEIGHT", model20.data.WEIGHT);
                                model.set("SUMWEIGHT", model20.data.SUMWEIGHT);
                                model.set("ENDDATE", model20.data.ENDDATE);
                                model.set("SHIPNO", "");
                                model.set("SHIPSEQ", "");

                                // 그리드 적용 방식
                                store.add(model);

                                checktemp++;
                            };
                        }
                        Ext.getCmp(gridnms["panel.1"]).getView().refresh();

                    }

                    if (checktemp > 0) {
                        win22.close();

                        $("#gridPopup2Area").hide("blind", {
                            direction: "up"
                        }, "fast");
                    }
                }
            }
        ]
    });
    win22.show();
}

function fn_popup_search2() {
    global_popup_flag2 = false;
    var params = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        BIGCODE: $('#popupBigCode').val(),
        MIDDLECODE: $('#popupMiddleCode').val(),
        SMALLCODE: $('#popupSmallCode').val(),
        ITEMCODE: $('#popupItemCode').val(),
        ITEMNAME: $('#popupItemName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        CUSTOMERCODE: $('#CustomerCode').val(),
    };
    extGridSearch(params, gridnms["store.20"]);
}

function fn_save() {
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var tradedate = $('#TradeDate').val();
    if (tradedate === "") {
        header.push("발행일자");
        count++;
    }

    var customercode = $('#CustomerCode').val();
    if (customercode === "") {
        header.push("거래처");
        count++;
    }

    var transactionperson = $("TransactionPerson").val();
    if (transactionperson === "") {
        header.push("담당자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    // 저장시 필수값 체크
    var count10 = Ext.getStore(gridnms["store.1"]).count();
    var header = [],
    secount = 0;

    if (count10 > 0) {
        for (i = 0; i < count10; i++) {
            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
            var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

            var enddate = model1.data.ENDDATE;

            if (enddate == "" || enddate == undefined) {
                header.push("마감일자");
                secount++;
            }

            if (secount > 0) {
                extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                return;
            }
        }
    }

    // 저장
    var tradeno = $('#TradeNo').val();
    var isNew = tradeno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 거래명세서 등록 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/order/trans/TransDetailMasterList.do' />";
        url1 = "<c:url value='/insert/order/trans/TransDetailDetailList.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/order/trans/TransDetailMasterList.do' />";
        url1 = "<c:url value='/update/order/trans/TransDetailDetailList.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('거래명세서 등록 알림', '저장 하시겠습니까?', function (btn) {
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
                        var tradeno = data.Tradeno;

                        if (tradeno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("TRADENO", tradeno);
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
                                            msg = "거래명세서 등록 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/order/trans/TransDetailRegist.do?TRADENO=' />" + tradeno + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('거래명세서 등록', '거래명세서 등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('거래명세서 등록 변경 알림', '거래명세서 등록 내역을 변경하시겠습니까?', function (btn) {
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
                        var tradeno = data.TradeNo;

                        if (tradeno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("TRADENO", tradeno);
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
                                            msg = "거래명세서 등록 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/order/trans/TransDetailRegist.do?TRADENO=' />" + tradeno + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('거래명세서 등록 변경', '변경이 취소되었습니다.');
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

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var tradeno = $('#TradeNo').val();

    var count1 = Ext.getStore(gridnms["store.1"]).count();
    if (count1 > 0) {
        extAlert("[상세 데이터]<br/> 거래명세서 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return;
    }

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TRADENO: tradeno,
    };

    var url = "<c:url value='/delete/order/trans/TransDetailMasterList.do' />";

    Ext.MessageBox.confirm('삭제 알림', '삭제 하시겠습니까?', function (btn) {
        if (btn == 'yes') {

            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: sparams,
                success: function (data) {
                    var isCheck = data.success;

                    if (isCheck) {
                        extAlert(data.msg);

                        fn_list();
                    } else {
                        extAlert(data.msg);

                        return;
                    }
                },
                error: ajaxError
            });
        } else {
            Ext.Msg.alert('취소 알림', '삭제 처리가 취소되었습니다.');
            return;
        }
    });
}

function fn_print(val) {
    var orgid = $('#searchOrgId').val();
    var companyid = $('#searchCompanyId').val();
    var tradeno = $('#TradeNo').val();
    var reportsize = Math.ceil(("${searchVO.reportsize}" * 1) / 9);

    var header = [],
    count = 0;

    if (val == "A") {
        for (var i = 0; i < reportsize; i++) {
            url = "<c:url value='/report/TransactionDetailsReport.pdf?ORGID='/>" + orgid
                 + "&COMPANYID=" + companyid
                 + "&TRADENO=" + tradeno
                 + "&STARTNUM=" + (i + 1);
            window.open(url, "거래명세서" + i, "");
        }
    } else {
        var url = "<c:url value='/report/TransactionDetailsArReport.pdf?ORGID='/>" + orgid
             + "&COMPANYID=" + companyid
             + "&TRADENO=" + tradeno;
        window.open(url, "거래명세서", "");
    }
}

function fn_list() {
    go_url("<c:url value='/order/trans/TransDetailList.do'/>");
}

function fn_add() {
    go_url("<c:url value='/order/trans/TransDetailRegist.do'/>");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
    // 거래처명 lov
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
                CUSTOMERTYPE1: 'S',
                USEYN: 'Y',
            }, function (data) {
                response($.map(data.data, function (m, i) {
                        return $.extend(m, {
                            value: m.VALUE,
                            label: m.LABEL + ", " + m.CUSTOMERTYPENAME + ", " + m.ADDRESS,
                            NAME: m.LABEL,
                            ADDRESS: m.ADDRESS,
                            FREIGHT: m.FREIGHT,
                            PHONENUMBER: m.PHONENUMBER,
                            UNITPRICEDIV: m.UNITPRICEDIV,
                            UNITPRICEDIVNAME: m.UNITPRICEDIVNAME,
                            CLOSINGDATE: m.CLOSINGDATE,
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

    //  담당자 Lov
    $("#TransactionPersonName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#TransactionPerson").val("");
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
                //                 INSPECTORTYPE : '10', // 관리직만 검색
                //                 INSPECTORTYPE : '20', // 생산직만 검색
                DEPTCODE: 'A004' // 영업부만 조회
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
            $("#TransactionPerson").val(o.item.value);
            $("#TransactionPersonName").val(o.item.label);

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
														<li>거래명세서 관리</li>
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
                        <input type="hidden" id="popupGroupCode" name=popupGroupCode value="A" />
                        <input type="hidden" id="popupBigName" name="popupBigName" />
                        <input type="hidden" id="popupBigCode" name="popupBigCode" />
                        <input type="hidden" id="popupMiddleName" name="popupMiddleName" />
                        <input type="hidden" id="popupMiddleCode" name="popupMiddleCode" />
                        <input type="hidden" id="popupSmallName" name="popupSmallName" />
                        <input type="hidden" id="popupSmallCode" name="popupSmallCode" />
                        <input type="hidden" id="popupItemName" name="popupItemName" /> 
                        <input type="hidden" id="popupOrderName" name="popupOrderName" />
                        <input type="hidden" id="popupShipNo" name="popupShipNo" />
                        
                        <input type="hidden" id="popupOrgId" name="popupOrgId" />
                        <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                        <input type="hidden" id="popupCustomerCode" name="popupCustomerCode" />
                        <input type="hidden" id="itemcode" />
                        <input type="hidden" id="rowIndexVal" />
												<input type="hidden" id="OrgId" name="OrgId" value="${searchVO.ORGID }" />
                        <input type="hidden" id="ComPanyId" name="ComPanyId" value="${searchVO.COMPANYID }" />
                        <input type="hidden" id="postatus" name="postatus" />
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
																				<td colspan="6">
																						<div class="buttons" style="float: right; margin-top: 3px;">
<!-- 																						    <a id="btnChk7" class="btn_popup" href="#" onclick="javascript:btnSel2();"> 수주현황 </a> -->
																						    <a id="btnChk1" class="btn_popup" href="#" onclick="javascript:btnSel1();"> 출하현황 </a>
																								<a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
																								<a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete()"> 삭제 </a>
																								<a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
																								<a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
                                                <c:if test="${!empty searchVO.TRADENO}">
                                                    <a id="btnChk7" class="btn_print" href="#" onclick="javascript:fn_print('A');"> 거래명세서 </a>
                                                    <a id="btnChk6" class="btn_print" href="#" onclick="javascript:fn_print('B');"> 거래명세서(A4) </a>
                                                </c:if>
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
																		<th class="required_text">거래명세서번호</th>
																		<td>
																		    <input type="text" id="TradeNo" name="TradeNo" class="input_center" style="width: 97%;" value="${searchVO.TRADENO }" readonly/>
																		</td>
																		<th class="required_text">발행일자</th>
																		<td>
																		    <input type="text" id="TradeDate" name="TradeDate" class="input_validation input_center" style="width: 97%;" maxlength="10" />
																		</td>
                                    <th class="required_text">거래처</th>
                                    <td>
                                        <input type="text" id="CustomerName" name=CustomerName class="input_validation input_center" style="width: 97%;" />
                                        <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                    </td>
                                    <th class="required_text">매출구분</th>
                                    <td>
                                        <select id="ShipGubun" name="ShipGubun" class="input_center" style="width: 97%;" disabled="disabled" readonly ></select>
                                    </td>
																</tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">담당자</th>
                                    <td>
                                        <input type="text" id="TransactionPersonName" name="TransactionPersonName" class="input_validation input_center" style="width: 97%;" />
                                        <input type="hidden" id="TransactionPerson" name="TransactionPerson" />
                                    </td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
																</tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">비고</th>
                                    <td colspan="7"><textarea id="ReMarks" name=ReMarks class=" input_left" style="width: 99%;" ></textarea></td>
                                </tr>
																</table>
														</div>
												</form>
										</fieldset>
								</div>
								<!-- //검색 필드 박스 끝 -->
								<div style="width: 100%;">
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
            </div>
						<!-- //content 끝 -->
						<div id="gridPopup1Area" style="width: 1540px; padding-top: 0px; float: left;"></div>
						<div id="gridPopup2Area" style="width: 1410px; padding-top: 0px; float: left;"></div>
				</div>
				<!-- //container 끝 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>