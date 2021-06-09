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


    $("#gridPopup1Area").hide("blind", {
        direction: "up"
    }, "fast");

    setReadOnly();
    setLovList();

//     $('#TaxDiv').change(function (event) {
//         var count = Ext.getStore(gridnms["store.1"]).count();
//         if (count > 0) {
//             for (var i = 0; i < count; i++) {
//                 Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
//                 var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

//                 var qty = model1.data.SOQTY; // 수량

//                 var unitpricea = model1.data.UNITPRICEA; // 단가
//                 model1.set("UNITPRICEA", unitpricea);

//                 var supplyprice = qty * unitpricea; //공급가액
//                 model1.set("SUPPLYPRICE", supplyprice);

//                 var tax_rate = $('#TaxDiv option:selected').attr("data-val");
//                 var additionaltax = Math.round(supplyprice * (tax_rate / 100)); // 부가세
//                 model1.set("ADDITIONALTAX", additionaltax);

//                 var total = supplyprice + additionaltax; // 합계
//                 model1.set("TOTAL", total);

//             }
//         }
//     });

});

function setInitial() {
    // 최초 상태 설정
    gridnms["app"] = "order";

    calender($('#InvoiceDate, #DepositDate'));

    $('#InvoiceDate, #DepositDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $('#TaxDiv').val("01"); // 세액구분 부가세별도 Default

    var taxno = $('#TaxNo').val();

    if (taxno == "") {
//         $("#DepositDate").val(getToDay("${searchVO.TODAY}") + "");
        $("#InvoiceDate").val(getToDay("${searchVO.TODAY}") + "");

        var groupid = "${searchVO.groupId}";

        switch (groupid) {
        case "ROLE_ADMIN":
            // 관리자 권한일 때 그냥 놔둠
            break;
        default:
            // 관리자 외 권한일 때 사용자명 표기
            $('#SalesPersonName').val("${searchVO.krname}");
            $('#SalesPerson').val("${searchVO.employeenumber}");
            break;
        }
    }

    var isCheck = taxno.length == 0 ? false : true;
    if (isCheck) {
        fn_search();
    }
}

var colIdx = 0, rowIdx = 0;
var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    gridnms["models.detail"] = [];
    gridnms["stores.detail"] = [];
    gridnms["views.detail"] = [];
    gridnms["controllers.detail"] = [];

    gridnms["grid.1"] = "OrderDepositRegist";

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
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'TAXINVOICENO',
        }, {
            type: 'number',
            name: 'TAXINVOICESEQ',
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
            name: 'DEOPOSITDATE',
            dateFormat: 'Y-m-d',
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
            align: "center",
            editor: {
                xtype: 'checkbox',
            },
            renderer: function (value, meta, record, row, col) {

                var status = $('#SoStatus').val();
                if (status == "COMPLETE" || status == "CANCEL") {
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
                        var status = $('#SoStatus').val();
                        if (status == "COMPLETE" || status == "CANCEL") {
                            extAlert("대기 상태 외 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
                            return false;
                        }
                    }
                }
            }
        }, {
            dataIndex: 'TAXINVOICESEQ',
            text: '세금계산서<br/>순번',
            xtype: 'gridcolumn',
            width: 100,
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
            dataIndex: 'DEPOSITDATE',
            text: '입금일자',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            align: "center",
            format: 'Y-m-d',
            editor:{
            	  xtype: 'datefield',
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                    	  var value=Ext.util.Format.date(newValue, 'Y-m-d');
                        var min=$("#DepositDate").val();
                        if(min=="" || min<value)
                          min=value;
                          $("#DepositDate").val(min);
                          
                    },
                  },
            },
            renderer: function (value, meta, record) {
            	meta.style = "background-color:rgb(253, 218, 255)";
                return Ext.util.Format.date(value, 'Y-m-d');
            },
            summaryType: 'max',
            summaryRenderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";

                var value=Ext.util.Format.date(value, 'Y-m-d');
                var min=$("#DepositDate").val();
                if(min=="" || min<value)
                  min=value;
                  $("#DepositDate").val(min);
                  

                return result;
            },
        }, {
            dataIndex: 'SUPPLYPRICE',
            text: '공급가액',
            xtype: 'gridcolumn',
            width: 115,
            hidden: false,
            sortable: false,
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
                     editable: true,
//                      enableKeyEvents: true,
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
                $("#DepositPrice_f").val(Ext.util.Format.number(value, '0,000'));
                $("#DepositPrice").val(value);
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
//                   editable: false,
//                   enableKeyEvents: true,
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
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                //          listeners: {
                //            specialkey: function (field, e) {
                //              if (e.keyCode === 38) {
                //                // 위
                //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                //                rowIdx = selModel.getCurrentPosition().row;
                //                colIdx = selModel.getCurrentPosition().column;

                //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                //              }
                //              if (e.keyCode === 40) {
                //                // 아래
                //                var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                //                rowIdx = selModel.getCurrentPosition().row;
                //                colIdx = selModel.getCurrentPosition().column;

                //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                //              }
                //            },
                //          },
            },
            renderer: function (value, meta, record) {
                var status = $('#SoStatus').val();
                if (status == "COMPLETE" || status == "CANCEL") {
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
            dataIndex: 'TAXINVOICENO',
            xtype: 'hidden',
        }, {
            dataIndex: 'TAXINVOICESEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'SMALLNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERDIV',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'CASTENDPLANDATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKENDPLANDATE',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/order/deposit/OrderDepositListDetail.do' />"
    });
    $.extend(items["api.1"], {
        create: "<c:url value='/insert/order/deposit/OrderDepositRegistDetail.do' />"
    });
    $.extend(items["api.1"], {
        update: "<c:url value='/update/order/deposit/OrderDepositRegistDetail.do' />"
    });
    //    $.extend(items["api.1"], {
    //      destroy: "<c:url value='/delete/order/deposit/OrderDepositRegistDetail.do' />"
    //    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChkd1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "추가",
        itemId: "btnAdd1"
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
        "#btnAdd1": {
            click: 'btnAdd1'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnDel1": {
            click: 'btnDel1'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#MasterClick": {
            itemclick: 'MasterClick'
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

        var status = $('#SoStatus').val();
        if (status == "COMPLETE" || status == "CANCEL") {}
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
var maxseq=0;
function btnAdd1() {
	 var model = Ext.create(gridnms["model.1"]);
     var store = this.getStore(gridnms["store.1"]);
     
     
     model.set("ORGID", $('#searchOrgId').val());
     model.set("COMPANYID", $('#searchCompanyId').val());
     
     if(maxseq<store.count()+1)
    	 maxseq=store.count()+1;
     else
    	  maxseq++;
     model.set("TAXINVOICESEQ",maxseq);
     
     model.set("DEPOSITDATE",getToDay("${searchVO.TODAY}"));
     
     store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
}

function btnDel1() {
    var store = Ext.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var taxno = $('#TaxNo').val();
    var taxseq = "";
    var status = $('#SoStatus').val();
    var url = "<c:url value='/delete/order/deposit/OrderDepositRegistDetail.do' />";

    if (record === undefined) {
        extAlert("삭제하실 데이터를 선택 해 주십시오.");
        return;
    }
    var gridcount = store.count() * 1;
    if (gridcount == 0) {
        extAlert("삭제하실 데이터가 없습니다.");
        return;
    }

    if (status == "COMPLETE" || status == "CANCEL") {
        extAlert("대기상태가 아닐 경우 삭제가 불가능합니다.<br/>다시 한번 확인해주세요.");
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
                        taxno = model.data.TAXINVOICENO;
                        taxseq = model.data.TAXINVOICESEQ;

                        if (taxno == "") {
                            // 데이터 등록되지 않은 건
                            deletecount++;
                            store.remove(model);
                        } else {
                            // 데이터 등록 건

                            var sparams = {
                                ORGID: orgid,
                                COMPANYID: companyid,
                                TAXINVOICENO: taxno,
                                TAXINVOICESEQ: taxseq,
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
                                        //              setInterval(function () {
                                        go_url("<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + taxno + "&org=" + orgid + "&company=" + companyid);
                                        //              }, 1 * 0.5 * 1000);

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
                taxseq = record.data.TAXINVOICESEQ;

                if (taxno == "") {
                    store.remove(model);
                } else {

                    var sparams = {
                        ORGID: orgid,
                        COMPANYID: companyid,
                        TAXINVOICENO: taxno,
                        TAXINVOICESEQ: taxseq,
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
                                //              setInterval(function () {
                                go_url("<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + taxno + "&org=" + orgid + "&company=" + companyid);
                                //              }, 1 * 0.5 * 1000);
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

function MasterClick(dataview, record, item, index, e, eOpts) {
    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var taxno = record.data.TAXINVOICENO;
    var taxseq = record.data.TAXINVOICESEQ;
    $('#orgid').val(orgid);
    $('#companyid').val(companyid);
    $('#taxno').val(taxno);
    $('#taxseq').val(taxseq);
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
                                TAXINVOICENO: $('#TaxNo').val(),
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
        btnAdd1:btnAdd1,
        btnDel1: btnDel1,
        MasterClick: MasterClick,
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
                height: 551,
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

//                                     editDisableCols.push("DEPOSITDATE");
//                                     editDisableCols.push("SUPPLYPRICE");
                                    editDisableCols.push("ADDITIONALTAX");

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
                renderTo: 'gridOrderArea'
            });
        },
    });

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea.updateLayout();
    });
}

function fn_save() {
    // 필수 체크
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;
    var falseyn = 0;

    var sodate = $('#InvoiceDate').val();
    if (sodate === "") {
        header.push("발행일자");
        count++;
    }

    var customercode = $('#CustomerCode').val();
    if (customercode === "") {
        header.push("거래처");
        count++;
    }

    var etax = $('#ETax').val();
    if (etax === "") {
        header.push("전자세금계산서번호");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    // 저장
    var taxnofind = $('#TaxNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = taxnofind.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;
    var statuschk = true;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();

//     if (gridcount == 0) {
//         extAlert("[상세 미등록]<br/> 수금등록 상세 데이터가 등록되지 않았습니다.");
//         return false;
//     }

    if (isNew) {
        url = "<c:url value='/insert/order/deposit/OrderDepositRegistMaster.do' />";
        url1 = "<c:url value='/insert/order/deposit/OrderDepositRegistDetail.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/order/deposit/OrderDepositRegistMaster.do' />";
        url1 = "<c:url value='/update/order/deposit/OrderDepositRegistDetail.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('수금등록 알림', '저장 하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: $("#master").serialize(),
                    success: function (data) {
                        var taxno = data.TaxNo;
                        var orgid = data.searchOrgId;
                        var companyid = data.searchCompanyId;

                        if (taxno.length == 0) {
                            // 요청이 안되었을 때 로직 추가
                        } else {
                            // 요청이 정상적으로 되었으면
                            var recount = Ext.getStore(gridnms["store.1"]).count();

                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("TaxNo", taxno);
                                model.set("Orgid", orgid);
                                model.set("CompanyId", companyid);

                                if (model.get("TaxNo") != '') {
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
                                            msg = "요청한 수금 내역이 변경되었습니다.";
                                        }
                                        statuschk = true;

                                        extAlert(msg);
                                        dataSuccess = 1;

//                                         if (dataSuccess > 0) {
//                                             //                          setInterval(function () {
//                                             go_url("<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + taxno + "&org=" + orgid + "&company=" + companyid);
//                                             //                          }, 1 * 0.5 * 1000);
//                                         }
                                    },
                                    error: ajaxError
                                });
                                
                            }
                            if (dataSuccess > 0) {
                                //                          setInterval(function () {
                                go_url("<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + taxno + "&org=" + orgid + "&company=" + companyid);
                                //                          }, 1 * 0.5 * 1000);
                            }
                        }
                    },
                    error: ajaxError
                });
            } else {
                Ext.Msg.alert('수금등록', '수금등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('수금등록 변경 알림', '수금등록 내역을 변경하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                var params = [];
                $.ajax({
                    url: url,
                    type: "post",
                    dataType: "json",
                    data: $("#master").serialize(),
                    success: function (data) {
                        var taxno = data.TaxNo;
                        var orgid = data.searchOrgId;
                        var companyid = data.searchCompanyId;

                        if (taxno.length == 0) {
                            // 생성이 안되었을 때 로직 추가
                        } else {
                            // 정상적으로 생성이 되었으면
                            var recount = Ext.getStore(gridnms["store.1"]).count();

                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("TaxNo", taxno);
                                model.set("Orgid", orgid);
                                model.set("CompanyId", companyid);

                                if (model.get("TaxNo") != '') {
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
                                            msg = "수금등록 내역이 변경되었습니다.";
                                        }
                                        statuschk = true;

                                        extAlert(msg);
                                        dataSuccess = 1;

//                                         if (dataSuccess > 0) {
//                                             //                          setInterval(function () {
//                                             go_url("<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + taxno + "&org=" + orgid + "&company=" + companyid);
//                                             //                          }, 1 * 0.5 * 1000);
//                                         }
                                    },
                                    error: ajaxError
                                });
                            }
                            if (dataSuccess > 0) {
                                //                          setInterval(function () {
                                go_url("<c:url value='/order/deposit/DepositRegist.do?TAXINVOICENO=' />" + taxno + "&org=" + orgid + "&company=" + companyid);
                                //                          }, 1 * 0.5 * 1000);
                            }
                        }
                    },
                    error: ajaxError
                });
            } else {
                Ext.Msg.alert('수금관리 변경', '변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_delete() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var taxno = $('#TaxNo').val();

    var count1 = Ext.getStore(gridnms["store.1"]).count();

    if (count1 > 0) {
        extAlert("[상세 데이터 ]<br/> 수금 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return;
    }

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TAXINVOICENO: taxno,
    };

    var url = "<c:url value='/delete/order/deposit/OrderDepositRegistMaster.do' />";

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

                        //              setTimeout(function () {
                        fn_list();
                        //              }, 400);
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
    var taxno = $('#TaxNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        TAXINVOICENO: taxno,
    };

    var url = "<c:url value='/select/order/deposit/OrderDepositListMaster.do' />";

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var taxno = dataList.TAXINVOICENO;
            var invoicedate = dataList.INVOICEDATE;
            var customername = dataList.CUSTOMERNAME;
            var customercode = dataList.CUSTOMERCODE;
            var price = dataList.SUPPLYPRICE;
            var additionaltax = dataList.ADDITIONALTAX;
            var etax = dataList.ETAX;
            var depositdate = dataList.DEPOSITDATE;
            var depositprice = dataList.DEPOSITPRICE;
            var remarks = dataList.REMARKS;
            
            var direction = dataList.DIRECTION;
            var salesbuytype = dataList.SALESBUYTYPE;
            var taxtype = dataList.TAXTYPE;
            var chargetype = dataList.CHARGETYPE;
            var docunumber = dataList.DOCUNUMBER;
            var issuenumber = dataList.ISSUENUMBER;
            var serialnumber = dataList.SERIALNUMBER;
            var reportnumber = dataList.REPORTNUMBER;
            var itemname = dataList.ITEMNAME;
            
            var f_price=Ext.util.Format.number(price,"0,000");
            var f_tax=Ext.util.Format.number(additionaltax,"0,000");
            var f_deposit=Ext.util.Format.number(depositprice,"0,000");
            $("#SupplyPrice_f").val(f_price);
            $("#AdditionalTax_f").val(f_tax);
            $("#DepositPrice_f").val(f_deposit);
            
            $("#TaxNo").val(taxno);
            $("#InvoiceDate").val(invoicedate);
            $("#CustomerName").val(customername);
            $("#CustomerCode").val(customercode);
            $("#SupplyPrice").val(price);
            $("#AdditionalTax").val(additionaltax);
            $("#DepositDate").val(depositdate);
            $("#DepositPrice").val(depositprice);
            
            $("#ETax").val(etax);
//             $("#TaxDiv").val(taxdiv);

            $("#Direction").val(direction);
            $("#SalesBuyType").val(salesbuytype);
            $("#TaxType").val(taxtype);
            $("#ChargeType").val(chargetype);
            $("#DocuNumber").val(docunumber);
            $("#IssueNumber").val(issuenumber);
            $("#SerialNumber").val(serialnumber);
            $("#ReportNumber").val(reportnumber);
            $("#ItemName").val(itemname);

            $("#ReMarks").val(remarks);
        },
        error: ajaxError
    });
}

function fn_list() {
    go_url("<c:url value='/order/deposit/DepositList.do'/>");
}

function fn_add() {
//     go_url("<c:url value='/order/deposit/DepositRegist.do' />");
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
            //          $("#ClosingDateName").val(o.item.CLOSINGDATENAME);

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
														<li>수금관리</li>
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
												<input type="hidden" id="orgid" name="orgid" />
                        <input type="hidden" id="companyid" name="companyid" />
                        <input type="hidden" id="taxseq" name="taxseq" />
												<input type="hidden" id="ORGID" name="ORGID" value="${searchVO.ORGID }" />
                        <input type="hidden" id="COMPANYID" name="COMPANYID" value="${searchVO.COMPANYID }" />
                        <input type="hidden" id="SupplyPrice" name="SupplyPrice"/>
                        <input type="hidden" id="AdditionalTax" name="AdditionalTax"/>
                        <input type="hidden" id="DepositPrice" name="DepositPrice"/>
                        
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
																				<td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 70%; visibility: hidden;">
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
																								<a id="btnChk1" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
																								<a id="btnChk2" class="btn_delete" href="#" onclick="javascript:fn_delete()"> 삭제 </a>
																								<a id="btnChk3" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
<!-- 																								<a id="btnChk4" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a> -->
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
																		<th class="required_text">세금계산서번호</th>
																		<td>
																		    <input type="text" id="TaxNo" name="TaxNo" class="input_center" style="width: 97%;" value="${searchVO.TAXINVOICENO }" readonly/>
																		</td>
																		<th class="required_text">발행일자</th>
																		<td>
																		    <input type="text" id="InvoiceDate" name="InvoiceDate" class="input_validation input_center" style="width: 97%;" maxlength="10" />
																		</td>
                                    <th class="required_text">거래처</th>
                                    <td>
                                        <input type="text" id="CustomerName" name="CustomerName" class="input_validation input_center" style="width: 97%;" />
                                        <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                    </td>
                                    <th class="required_text">전자세금계산서번호</th>
                                    <td>
                                        <input type="text" id="ETax" name="ETax" class="input_validation input_center" style="width: 97%;" />
                                    </td>
                                </tr>
                                  <tr style="height: 34px;">
                                    <th class="required_text">입금일자</th>
                                    <td>
                                        <input type="text" id="DepositDate" name="DepositDate" class="input_center" style="width: 97%;" maxlength="10" />
                                    </td>
                                    <th class="required_text">입금액</th>
                                    <td>
                                        <input type="text" id="DepositPrice_f" name="DepositPrice_f" class=" input_center" style="width: 97%;"  />
                                    </td>
                                    
                                    <th class="required_text">공급가</th>
                                    <td>
                                        <input type="text" id="SupplyPrice_f" name="SupplyPrice_f" class="input_validation input_center" style="width: 97%;" maxlength="10" />
                                    </td>
                                    <th class="required_text">부가세</th>
                                    <td>
                                        <input type="text" id="AdditionalTax_f" name="AdditionalTax_f" class="input_validation input_center" style="width: 97%;"  />
                                    </td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">방향</th>
                                    <td >
                                    <select id="Direction" name="Direction" class="input_left " style="width: 70%; ">
                                                    <c:forEach var="item" items="${labelBox.findByDirection}" varStatus="status">
                                                        <c:choose>
                                                            <c:when test="${item.VALUE==searchVO.DIRECTIONGUBUN}">
                                                                <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${item.VALUE}">${item.LABEL}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                        </select></td>
                                    <th class="required_text">입/출구분</th>
                                    <td ><select id="SalesBuyType" name="SalesBuyType" class="input_left " style="width: 70%; ">
                                                    <c:forEach var="item" items="${labelBox.findBySalesBuyType}" varStatus="status">
                                                        <c:choose>
                                                            <c:when test="${item.VALUE==searchVO.SALESBUYGUBUN}">
                                                                <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${item.VALUE}">${item.LABEL}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                        </select></td>
                                    <th class="required_text">과세구분</th>
                                    <td ><select id="TaxType" name="TaxType" class="input_left " style="width: 70%; ">
                                                    <c:forEach var="item" items="${labelBox.findByTaxType}" varStatus="status">
                                                        <c:choose>
                                                            <c:when test="${item.VALUE==searchVO.TAXGUBUN}">
                                                                <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${item.VALUE}">${item.LABEL}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                        </select></td>
                                    <th class="required_text">영수/청구</th>
                                    <td ><select id="ChargeType" name="ChargeType" class="input_left " style="width: 70%; ">
                                                    <c:forEach var="item" items="${labelBox.findByChargeType}" varStatus="status">
                                                        <c:choose>
                                                            <c:when test="${item.VALUE==searchVO.CHARGEGUBUN}">
                                                                <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <option value="${item.VALUE}">${item.LABEL}</option>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:forEach>
                                        </select></td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">권번호</th>
                                    <td ><input type="text" id="DocuNumber" name="DocuNumber" class=" input_left" style="width: 99%;" /></td>
                                    <th class="required_text">호번호</th>
                                    <td ><input type="text" id="IssueNumber" name="IssueNumber" class=" input_left" style="width: 99%;" /></td>
                                    <th class="required_text">일련번호</th>
                                    <td ><input type="text" id="SerialNumber" name="SerialNumber" class=" input_left" style="width: 99%;" /></td>
                                    <th class="required_text">신고번호</th>
                                    <td ><input type="text" id="ReportNumber" name="ReportNumber" class=" input_left" style="width: 99%;" /></td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">대표품목</th>
                                    <td ><input type="text" id="ItemName" name="ItemName" class=" input_left" style="width: 99%;" /></td>
                                    <th class="required_text">비고</th>
                                    <td colspan="5"><input type="text" id="ReMarks" name="ReMarks" class=" input_left" style="width: 99%;" /></td>
                                </tr>
																</table>
														</div>
												</form>
										</fieldset>
								</div>
								<!-- //검색 필드 박스 끝 -->
								<div style="width: 100%;">
                    <div id="gridOrderArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
            </div>
						<!-- //content 끝 -->
						<div id="gridPopup1Area" style="width: 1571px; padding-top: 0px; float: left;"></div>
				</div>
				<!-- //container 끝 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>