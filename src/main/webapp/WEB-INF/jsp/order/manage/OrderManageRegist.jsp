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
  String name = loginVO.getName();
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
var authCode = "<%=authCode%>"
var autoName = "<%=name%>"
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

    $('#TaxDiv').change(function (event) {
        var count = Ext.getStore(gridnms["store.1"]).count();
        if (count > 0) {
            for (var i = 0; i < count; i++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
                var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                var qty = model1.data.SOQTY; // 수량

                var unitpricea = model1.data.UNITPRICEA; // 단가
                model1.set("UNITPRICEA", unitpricea);

                var supplyprice = qty * unitpricea; //공급가액
                model1.set("SUPPLYPRICE", supplyprice);

                var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                var additionaltax = Math.round(supplyprice * (tax_rate / 100)); // 부가세
                model1.set("ADDITIONALTAX", additionaltax);

                var total = supplyprice + additionaltax; // 합계
                model1.set("TOTAL", total);

            }
        }
    });
    
    var auth = "${param.auth}";
    
    if(auth == "Y"){
    	  $("#CustomerName").attr("readonly","readonly");
       var params = {
           ORGID : $("#searchOrgId option:selected").val(),
           COMPANYID: $("#searchCompanyId option:selected").val(),
           CUSTOMERNAME : autoName
       };
       
             $.ajax({
                 url: "<c:url value='/searchCustomernameLov.do' />",
                 type: "post",
                 dataType: "json",
                 data: params,
                 success: function (data) {
                 
                   if(data.totcnt > 0){
                        $("#CustomerName").val(data.data[0].LABEL)
                        $("#CustomerCode").val(data.data[0].VALUE);
                   }else{
                      extAlert("해당 정보가 거래처에 존재하지 않습니다. <br> 다시 확인해 주십시오")
                      return false;
                   }
                     
                   //fn_search();
                   
                
                 
                 },
                 error: ajaxError
           });
    	
    	
    }

});

var global_close_yn = "N";
function setInitial() {
    // 최초 상태 설정
    gridnms["app"] = "order";

    calender($('#SoDate, #DueDate'));

    $('#SoDate, #DueDate').keyup(function (event) {
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

    var sono = $('#SoNo').val();
    var isCheck = sono.length == 0 ? false : true;
    if (isCheck) {
        fn_search();
    } else {
        $("#DueDate").val(getToDay("${searchVO.TODAY}") + "");
        $("#SoDate").val(getToDay("${searchVO.TODAY}") + "");

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

    gridnms["grid.1"] = "OrderManageRegist";
    gridnms["grid.10"] = "WorkOrderDivLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.detail"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.detail"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.10"] = gridnms["app"] + ".model." + gridnms["grid.10"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.10"] = gridnms["app"] + ".store." + gridnms["grid.10"];

    gridnms["models.detail"].push(gridnms["model.1"]);
    gridnms["models.detail"].push(gridnms["model.10"]);

    gridnms["stores.detail"].push(gridnms["store.1"]);
    gridnms["stores.detail"].push(gridnms["store.10"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'number',
            name: 'SOSEQ',
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
            name: 'SUMWEIGHT',
        }, {
            type: 'number',
            name: 'WEIGHT',
        }, {
            type: 'number',
            name: 'SOQTY',
        }, {
            type: 'number',
            name: 'UNITPRICEA',
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
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'CUSTOMERORDER',
        }, {
            type: 'string',
            name: 'CUSTOMERORDERSEQ',
        }, {
            type: 'date',
            name: 'CASTENDPLANDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'date',
            name: 'WORKENDPLANDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'WORKORDERDIV',
        }, {
            type: 'number',
            name: 'INVENTORYQTY',
        }, {
            type: 'string',
            name: 'COMPLETEYN',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, ];

    fields["model.10"] = [{
            type: 'string',
            name: 'VALUE'
        }, {
            type: 'string',
            name: 'LABEL'
        }
    ];

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
            dataIndex: 'SOSEQ',
            text: '수주<br/>순번',
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
            //        editor: {
            //          xtype: 'textfield',
            //          editable: false,
            //          enableKeyEvents: true,
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
            //        },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'COMPLETEYN',
            text: '완료<br>여부',
            xtype: 'gridcolumn',
            width: 55,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combo',
                store: ['Y', 'N'],
                editable: false,
                listeners: {
                    select: function (field, record, eOpts) {
                        var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                        rowIdx = selModel.getCurrentPosition().row;
                        colIdx = selModel.getCurrentPosition().column;
                        var value = field.getValue();
                        var falseyn = 0;
                        var count = Ext.getStore(gridnms["store.1"]).count();

                        if (count > 0) {
                            for (i = 0; i < count; i++) {
                                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
                                var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                                if (i == rowIdx) {
                                    if (value == "N") {
                                        falseyn++;
                                    }
                                } else {
                                    var completeyn = model.data.COMPLETEYN;
                                    if (completeyn == "N") {
                                        falseyn++;
                                    }
                                }
                            }
                            if (falseyn > 0) {
                                $("#SoStatus").val("STAND BY");
                            } else {
                                $("#SoStatus").val("COMPLETE");
                            }

                            //                fn_grid_focus_move("RIGHT", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                    },
                    //            change: function (field, newValue, oldValue, eOpts) {
                    //              var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;
                    //              var checkyn = newValue;
                    //              var falseyn = 0;
                    //              var count = Ext.getStore(gridnms["store.1"]).count();

                    //              if (count > 0) {
                    //                for (i = 0; i < count; i++) {
                    //                  Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
                    //                  var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                    //                  if (i == selectedRow) {
                    //                    if (checkyn == "N") {
                    //                      falseyn++;
                    //                    }
                    //                  } else {
                    //                    var completeyn = model.data.COMPLETEYN;
                    //                    if (completeyn == "N") {
                    //                      falseyn++;
                    //                    }
                    //                  }
                    //                }
                    //                if (falseyn > 0) {
                    //                  $("#SoStatus").val("STAND BY");
                    //                } else {
                    //                  $("#SoStatus").val("COMPLETE");
                    //                }
                    //              }
                    //            },
                },
            }
            //       }, {
            //         dataIndex: 'SMALLNAME',
            //         text: '소분류',
            //         xtype: 'gridcolumn',
            //         width: 100,
            //         hidden: false,
            //         sortable: false,
            //         resizable: false,
            //         align: "center",
            //         renderer: function (value, meta, record) {
            //           meta.style = "background-color:rgb(234, 234, 234)";
            //           return value;
            //         },
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
            //        editor: {
            //          xtype: 'textfield',
            //          editable: false,
            //          enableKeyEvents: true,
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
            //        },
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
            //      }, {
            //        dataIndex: 'MATERIALTYPE',
            //        text: '재질',
            //        xtype: 'gridcolumn',
            //        width: 120,
            //         hidden: false,
            //         sortable: false,
            //         resizable: false,
            //         menuDisabled: true,
            //        align: "center",
            //        renderer: function (value, meta, record) {
            //          meta.style = "background-color:rgb(234, 234, 234)";
            //          return value;
            //        },
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
            //        editor: {
            //          xtype: 'textfield',
            //          editable: false,
            //          enableKeyEvents: true,
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
            //        },
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
            //        editor: {
            //          xtype: 'textfield',
            //          editable: false,
            //          enableKeyEvents: true,
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
            //        },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'SOQTY',
            text: '수량',
            xtype: 'gridcolumn',
            width: 70,
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
                listeners: {
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
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["order.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var qty = field.getValue(); // 수량

                        var unitpricea = store.data.UNITPRICEA; // 단가
                        store.set("UNITPRICEA", unitpricea);

                        var supplyprice = qty * unitpricea; //공급가액
                        store.set("SUPPLYPRICE", supplyprice);

                        var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                        var additionaltax = Math.round(supplyprice * (tax_rate / 100)); // 부가세
                        store.set("ADDITIONALTAX", additionaltax);

                        var total = supplyprice + additionaltax; // 합계
                        store.set("TOTAL", total);

                        //중량 계산 시작
                        var weight = (store.data.WEIGHT * qty);
                        store.set("SUMWEIGHT", weight);
                        //중량 계산 끝
                    },
                },
            },
            renderer: function (value, meta, record) {
                var status = $('#SoStatus').val();
                if (status == "COMPLETE" || status == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                } else {
                    meta.style = "background-color:rgb(253, 218, 255)";
                }
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'UNITPRICEA',
            text: '단가',
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
                listeners: {
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
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["order.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                        var qty = store.data.SOQTY; // 수량

                        var unitpricea = field.getValue(); // 단가
                        store.set("UNITPRICEA", unitpricea);

                        var supplyprice = qty * unitpricea; //공급가액
                        store.set("SUPPLYPRICE", supplyprice);

                        var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                        var additionaltax = Math.round(supplyprice * (tax_rate / 100)); // 부가세
                        store.set("ADDITIONALTAX", additionaltax);

                        var total = supplyprice + additionaltax; // 합계
                        store.set("TOTAL", total);
                    },
                },
            },
            renderer: function (value, meta, record) {
                var status = $('#SoStatus').val();
                if (status == "COMPLETE" || status == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                } else {
                    meta.style = "background-color:rgb(253, 218, 255)";
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
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            //        editor: {
            //          xtype: "textfield",
            //          minValue: 1,
            //          format: "0,000",
            //          enforceMaxLength: true,
            //          allowBlank: true,
            //          maxLength: '9',
            //          maskRe: /[0-9]/,
            //          selectOnFocus: true,
            //          editable: false,
            //          enableKeyEvents: true,
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
            //        },
            summaryType: 'sum',
            summaryRenderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255)";
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
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            //        editor: {
            //          xtype: "textfield",
            //          minValue: 1,
            //          format: "0,000",
            //          enforceMaxLength: true,
            //          allowBlank: true,
            //          maxLength: '9',
            //          maskRe: /[0-9]/,
            //          selectOnFocus: true,
            //          editable: false,
            //          enableKeyEvents: true,
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
            //        },
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
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            //        editor: {
            //          xtype: "textfield",
            //          minValue: 1,
            //          format: "0,000",
            //          enforceMaxLength: true,
            //          allowBlank: true,
            //          maxLength: '9',
            //          maskRe: /[0-9]/,
            //          selectOnFocus: true,
            //          editable: false,
            //          enableKeyEvents: true,
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
            //        },
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
            dataIndex: 'DUEDATE',
            text: '납기일자',
            xtype: 'datecolumn',
            width: 115,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            format: 'Y-m-d',
            editor: {
                xtype: 'datefield',
                enforceMaxLength: true,
                maxLength: 10,
                allowBlank: true,
                format: 'Y-m-d',
                altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
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
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'CUSTOMERORDER',
            text: '고객사 발주번호',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
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
        }, {
            dataIndex: 'CUSTOMERORDERSEQ',
            text: '고객사<br/>발주순번',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            //cls: 'ERPQTY',
            //format: "0,000",
            editor: {
                xtype: "textfield",
                // minValue: 1,
                // format: "0,000",
                // enforceMaxLength: true,
                allowBlank: true,
                // maxLength: '9',
                // maskRe: /[0-9]/,
                //  selectOnFocus: true,
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
                //          return Ext.util.Format.number(value, '0,000');
                return value;
            },
            //       }, {
            //         dataIndex: 'CASTENDPLANDATE',
            //         text: '주조완료<br/>예정일',
            //         xtype: 'datecolumn',
            //         width: 100,
            //         hidden: false,
            //         sortable: false,
            //         align: "center",
            //         format: 'Y-m-d',
            //         editor: {
            //           xtype: 'datefield',
            //           enforceMaxLength: true,
            //           maxLength: 10,
            //           allowBlank: true,
            //           format: 'Y-m-d',
            //         },
            //         renderer: function (value, meta, record) {

            //           return Ext.util.Format.date(value, 'Y-m-d');
            //         },
            //       }, {
            //         dataIndex: 'WORKENDPLANDATE',
            //         text: '가공완료<br/>예정일',
            //         xtype: 'datecolumn',
            //         width: 100,
            //         hidden: false,
            //         sortable: false,
            //         align: "center",
            //         format: 'Y-m-d',
            //         editor: {
            //           xtype: 'datefield',
            //           enforceMaxLength: true,
            //           maxLength: 10,
            //           allowBlank: true,
            //           format: 'Y-m-d',
            //         },
            //         renderer: function (value, meta, record) {

            //           return Ext.util.Format.date(value, 'Y-m-d');
            //         },
        }, {
            dataIndex: 'WORKORDERDIVNAME',
            text: '작업의뢰<br/>여부',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
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
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

                        model.set("WORKORDERDIV", record.data.VALUE);

                        //              var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                        //              rowIdx = selModel.getCurrentPosition().row;
                        //              colIdx = selModel.getCurrentPosition().column;

                        //              fn_grid_focus_move("RIGHT", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
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
                var status = $('#SoStatus').val();
                if (status == "COMPLETE" || status == "CANCEL") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
                return value;
            },
        }, {
            dataIndex: 'INVENTORYQTY',
            text: '재고',
            xtype: 'gridcolumn',
            width: 85,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            //        editor: {
            //          xtype: "textfield",
            //          minValue: 1,
            //          format: "0,000",
            //          enforceMaxLength: true,
            //          allowBlank: true,
            //          maxLength: '9',
            //          maskRe: /[0-9]/,
            //          selectOnFocus: true,
            //          editable: false,
            //          enableKeyEvents: true,
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
            //        },
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
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'SONO',
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
        read: "<c:url value='/select/order/manage/OrderManageStateListDetail.do' />"
    });
    $.extend(items["api.1"], {
        create: "<c:url value='/insert/order/manage/OrderManageRegistDetail.do' />"
    });
    $.extend(items["api.1"], {
        update: "<c:url value='/update/order/manage/OrderManageRegistDetail.do' />"
    });
    //    $.extend(items["api.1"], {
    //      destroy: "<c:url value='/delete/order/manage/OrderManageRegistDetail.do' />"
    //    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChkd1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "단가적용",
        itemId: "btnPrice1"
    });
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

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnChkd1": {
            click: 'btnChk1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnPrice1": {
            click: 'btnPrice1'
        }
    });
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

function btnPrice1(btn) {
    if ( global_close_yn == "Y" ) {
      extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
      return false;
    }
    
    var sono = $('#SoNo').val();
    if (sono == null || sono == undefined) {
        extAlert("[수주 미등록]<br/>수주 내역을 저장하셔야 단가 적용이 가능합니다.<br/>다시 한번 확인해주십시오.");
        return false;
    }

    var count = Ext.getStore(gridnms["store.1"]).count();
    var check_count = 0;

    for (var i = 0; i < count; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

        var chk = model1.data.CHK;
        if (chk) {
            check_count++;
        }
    }

    var update_count = 0;
    if (check_count > 0) {

        Ext.MessageBox.confirm("[단가적용]", '<color style="color:  red; font-weight: bold; ">※ 주의 : 저장된 내역을 기반으로 단가가 적용됩니다.</color><br/>선택하신 제품 단가를 적용하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                for (var j = 0; j < count; j++) {
                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(j));
                    var record = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                    var chk = record.data.CHK;
                    if (chk) {
                        $.ajax({
                            url: "<c:url value='/pkg/order/manage/UnitPriceManage.do' />",
                            type: "post",
                            dataType: "json",
                            async: false,
                            data: record.data,
                            success: function (data) {
                                var success = data.success;
                                var msg = data.msg;
                                if (!success) {
                                    extAlert("관리자에게 문의하십시오.<br/>" + msg);
                                    return;
                                } else {
                                    update_count++;
                                }

                                if (check_count == update_count) {
                                    extAlert(msg);
                                }
                            },
                            error: ajaxError
                        });
                    }
                }

            } else {
                Ext.Msg.alert('[단가적용 취소]', '선택하신 제품 단가 적용이 취소되었습니다.');
                return false;
            }
        });
    } else {
        extAlert("[수주 미선택]<br/>선택된 수주 내역이 없습니다.<br/>다시 한번 확인해주십시오.");
        return false;
    }
}

var global_popup_flag = false;
function btnSel1(btn) {
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if ( global_close_yn == "Y" ) {
      extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록하실 수 없습니다.<br/>관리자에게 문의해주세요.");
      return false;
    }
    
    //    if (TransDate === "") {
    //      header.push("요청일");
    //      count++;
    //    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    var width = 1580; // 가로
    var height = 640; // 세로
    var title = "제품 불러오기 Popup";
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
                    change: function (value, nv, ov, e) {
                        var result = value.getValue();

                        $('#popupMiddleCode').val(record.get("VALUE"));
                        $('#popupMiddleName').val(record.get("LABEL"));

                        $('#popupSmallCode').val("");
                        $('#popupSmallName').val("");

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
                    //              buffer: 50,
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
                    //              buffer: 50,
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
                    //               buffer: 50,
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
                width: 150,
                editable: true,
                allowBlank: true,
                listeners: {
                    scope: this,
                    //                buffer: 50,
                    change: function (value, nv, ov, e) {
                        value.setValue(nv.toUpperCase());
                        var result = value.getValue();

                        $('#popupItemStandardD').val(result);
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
                        var sono = $('#SoNo').val();
                        if (chk) {
                            checknum++;
                        }
                    }

                    var countTemp = Ext.getStore(gridnms["store.1"]).count();
                    var soseqTemp = 1;
                    if (countTemp > 0) {
                        for (var r = 0; r < countTemp; r++) {
                            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(r));
                            var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                            soseqCheck1 = model1.data.SOSEQ;
                            for (var s = 0; s < countTemp; s++) {
                                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(s));
                                var model2 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

                                soseqCheck2 = model2.data.SOSEQ;
                                if (soseqCheck1 <= soseqCheck2) {
                                    soseqTemp = (soseqCheck2 * 1) + 1;
                                } else {
                                    soseqTemp = (soseqCheck1 * 1) + 1;
                                }
                            }
                        }
                    } else {
                        soseqTemp = 1;
                    }
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
                                model.set("SOSEQ", soseqTemp);

                                // 팝업창의 체크된 항목 이동
                                model.set("SMALLCODE", model5.data.SMALLCODE);
                                model.set("SMALLNAME", model5.data.SMALLNAME);
                                model.set("ITEMCODE", model5.data.ITEMCODE);
                                model.set("ORDERNAME", model5.data.ORDERNAME);
                                model.set("DRAWINGNO", model5.data.DRAWINGNO);
                                model.set("ITEMNAME", model5.data.ITEMNAME);
                                model.set("CARTYPE", model5.data.CARTYPE);
                                model.set("CARTYPENAME", model5.data.CARTYPENAME);
                                model.set("MATERIALTYPE", model5.data.MATERIALTYPE);
                                model.set("UOM", model5.data.UOM);
                                model.set("UOMNAME", model5.data.UOMNAME);
                                model.set("ITEMSTANDARD", model5.data.ITEMSTANDARD);
                                model.set("ITEMSTANDARDDETAIL", model5.data.ITEMSTANDARDDETAIL);

                                model.set("INVENTORYQTY", model5.data.PRESENTINVENTORYQTY);
                                model.set("WORKORDERDIVNAME", "작업의뢰");
                                model.set("WORKORDERDIV", "Y");
                                model.set("COMPLETEYN", "N");
                                model.set("DUEDATE", $('#DueDate').val());
                                model.set("SONO", sono);

                                model.set("WEIGHT", model5.data.WEIGHT); //단중
                                model.set("SUMWEIGHT", model5.data.WEIGHT); //중량

                                model.set("UNITPRICEA", model5.data.UNITPRICEA); // 단가
                                model.set("SUPPLYPRICE", model5.data.UNITPRICEA); // 공급가액
                                model.set("SOQTY", 1); // 수량

                                var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                                var tax = Math.round((model5.data.UNITPRICEA) * (tax_rate / 100));
                                model.set("ADDITIONALTAX", tax); // 부가세
                                var total = model5.data.UNITPRICEA + tax;
                                model.set("TOTAL", total); // 토탈


                                // 그리드 적용 방식
                                store.add(model);

                                soseqTemp++; // 수주순번 증가;
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
            ITEMSTANDARDDETAIL: $('#popupItemStandardD').val(),
    };
    extGridSearch(params, gridnms["store.5"]);
}

function btnDel1() {
    var store = Ext.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var sono = $('#SoNo').val();
    var soseq = "";
    var status = $('#SoStatus').val();
    var url = "<c:url value='/delete/order/manage/OrderManageRegistDetail.do' />";

    if ( global_close_yn == "Y" ) {
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
                        sono = model.data.SONO;
                        soseq = model.data.SOSEQ;

                        if (sono == "") {
                            // 데이터 등록되지 않은 건
                            deletecount++;
                            store.remove(model);
                        } else {
                            // 데이터 등록 건
                            var sparams = {
                                ORGID: orgid,
                                COMPANYID: companyid,
                                SONO: sono,
                                SOSEQ: soseq,
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
                                        go_url("<c:url value='/order/manage/OrderManageRegist.do?SONO=' />" + sono + "&org=" + orgid + "&company=" + companyid);

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
                soseq = record.data.SOSEQ;

                if (sono == "") {
                    store.remove(model);
                } else {

                    var sparams = {
                        ORGID: orgid,
                        COMPANYID: companyid,
                        SONO: sono,
                        SOSEQ: soseq,
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
                                go_url("<c:url value='/order/manage/OrderManageRegist.do?SONO=' />" + sono + "&org=" + orgid + "&company=" + companyid);
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
    var sono = record.data.SONO;
    var soseq = record.data.SOSEQ;
    $('#orgid').val(orgid);
    $('#companyid').val(companyid);
    $('#sono').val(sono);
    $('#soseq').val(soseq);
}

var gridarea;
function setExtGrid() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"],
    });

    Ext.define(gridnms["model.10"], {
        extend: Ext.data.Model,
        fields: fields["model.10"]
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
                                SONO: $('#SoNo').val(),
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
                                BIGCD: 'OM',
                                MIDDLECD: 'WORK_ORDER_DIV',
                            },
                            reader: gridVals.reader,
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
        btnPrice1: btnPrice1,
        btnSel1: btnSel1,
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
                height: 585,
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
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = [];

                                var status = $('#SoStatus').val();
                                if (status == "COMPLETE" || status == "CANCEL") {
                                    editDisableCols.push("SOQTY");
                                    editDisableCols.push("UNITPRICEA");
                                    editDisableCols.push("DUEDATE");
                                    editDisableCols.push("CUSTOMERORDER");
                                    editDisableCols.push("WORKORDERDIVNAME");
                                    editDisableCols.push("REMARKS");
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
                renderTo: 'gridOrderArea'
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
            name: 'ITEMSTANDARDDETAIL',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARD',
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
            width: 180,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            //      }, {
            //        dataIndex: 'MATERIALTYPE',
            //        text: '재질',
            //        xtype: 'gridcolumn',
            //        width: 120,
            //         hidden: false,
            //         sortable: false,
            //         resizable: false,
            //         menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "center",
        }, {
            dataIndex: 'ITEMSTANDARDDETAIL',
            text: '타입',
            xtype: 'gridcolumn',
            width: 90,
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
            width: 140,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'UNITPRICEA',
            text: '단가',
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
        }, {
            dataIndex: 'MATERIALTYPE',
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

var gridpopup1;
function setExtGrid_Popup() {
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
    if ( global_close_yn == "Y" ) {
      extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경하실 수 없습니다.<br/>관리자에게 문의해주세요.");
      return false;
    }

    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;
    var falseyn = 0;

    var sodate = $('#SoDate').val();
    if (sodate === "") {
        header.push("수주일자");
        count++;
    }

    var customercode = $('#CustomerCode').val();
    if (customercode === "") {
        header.push("거래처");
        count++;
    }

    var salesperson = $('#SalesPerson').val();
    if (salesperson === "") {
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

            var soqty = model1.data.SOQTY;
            var unitpricea = model1.data.UNITPRICEA;
            var completeyn = model1.data.COMPLETEYN;

            if (soqty == "" || soqty == undefined) {
                header.push("수량");
                secount++;
            }

            if (completeyn == "" || completeyn == undefined) {
                header.push("완료여부");
                secount++;
            }

            if (secount > 0) {
                extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                return;
            }
        }
    }

    // 저장
    var sonofind = $('#SoNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = sonofind.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 수주등록 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/order/manage/OrderManageRegistMaster.do' />";
        url1 = "<c:url value='/insert/order/manage/OrderManageRegistDetail.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/order/manage/OrderManageRegistMaster.do' />";
        url1 = "<c:url value='/update/order/manage/OrderManageRegistDetail.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('수주등록 알림', '저장 하시겠습니까?', function (btn) {
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
                        var sono = data.SoNo;

                        if (sono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("Orgid", orgid);
                                model.set("CompanyId", companyid);
                                model.set("SoNo", sono);

                                if (model.data.SoNo != '') {
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
                                            go_url("<c:url value='/order/manage/OrderManageRegist.do?SONO=' />" + sono + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('수주등록', '수주등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('수주등록 변경 알림', '수주등록 내역을 변경하시겠습니까?', function (btn) {
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
                        var sono = data.SoNo;

                        if (sono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("Orgid", orgid);
                                model.set("CompanyId", companyid);
                                model.set("SoNo", sono);

                                if (model.data.SoNo != '') {
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
                                            msg = "수주등록 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/order/manage/OrderManageRegist.do?SONO=' />" + sono + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('수주관리 변경', '변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_delete() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var sono = $('#SoNo').val();

    if ( global_close_yn == "Y" ) {
    	extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
    	return false;
    }
    
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    if (count1 > 0) {
        extAlert("[상세 데이터]<br/>수주 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return;
    }

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SONO: sono,
    };

    var url = "<c:url value='/delete/order/manage/OrderManageRegistMaster.do' />";

    Ext.MessageBox.confirm('삭제 알림', '삭제 하시겠습니까?', function (btn) {
        if (btn == 'yes') {

            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: sparams,
                success: function (data) {
                    var isCheck = data.success;
                    extAlert(data.msg);

                    if (isCheck) {
                        fn_list();
                    } else {
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
    var sono = $('#SoNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SONO: sono,
    };

    var url = "<c:url value='/select/order/manage/OrderManageStateListMaster.do' />";

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var sono = dataList.SONO;
            var sodate = dataList.SODATE;
            var sostatus = dataList.SOSTATUS;
            var customername = dataList.CUSTOMERNAME;
            var customercode = dataList.CUSTOMERCODE;
            var salesperson = dataList.SALESPERSON;
            var salespersonname = dataList.SALESPERSONNAME;
            var duedate = dataList.DUEDATE;
            var taxdiv = dataList.TAXDIV;
            var paymentterms = dataList.PAYMENTTERMS;
            //       var closingdate = dataList.CLOSINGDATE;
            //       var closingdatename = dataList.CLOSINGDATENAME;
            var sotype = dataList.SOTYPE;
            var remarks = dataList.REMARKS;

            $("#SoNo").val(sono);
            $("#SoDate").val(sodate);
            $("#SoStatus").val(sostatus);
            $("#CustomerName").val(customername);
            $("#CustomerCode").val(customercode);
            $("#SalesPersonName").val(salespersonname);
            $("#SalesPerson").val(salesperson);
            $("#DueDate").val(duedate);
            $("#TaxDiv").val(taxdiv);
            $("#PaymentTerms").val(paymentterms);
            //       $("#ClosingDate").val(closingdate);
            //       $("#ClosingDateName").val(closingdatename);
            $("#SoType").val(sotype);
            $("#ReMarks").val(remarks);

            global_close_yn = fn_monthly_close_filter_data(sodate, 'OM');
        },
        error: ajaxError
    });
}

function fn_list() {
    go_url("<c:url value='/order/manage/OrderManageStateList.do'/>");
}

function fn_add() {
    go_url("<c:url value='/order/manage/OrderManageRegist.do' />");
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

    // 담당자 Lov
    $("#SalesPersonName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#SalesPersonName").val("");
            $("#SalesPerson").val("");
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
                INSPECTORTYPE: '10', // 관리직만 검색
                //                 DEPTCODE : 'A004' // 영업부만 조회
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
            $("#SalesPerson").val(o.item.value);
            $("#SalesPersonName").val(o.item.label);

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
														<li>수주관리</li>
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
                        <input type="hidden" id="sono" name="sono" />
                        <input type="hidden" id="soseq" name="soseq" />
												<input type="hidden" id="popupGroupCode" name=popupGroupCode value="A" />
												<input type="hidden" id="popupBigName" name="popupBigName" />
												<input type="hidden" id="popupBigCode" name="popupBigCode" />
												<input type="hidden" id="popupMiddleName" name="popupMiddleName" />
												<input type="hidden" id="popupMiddleCode" name="popupMiddleCode" />
												<input type="hidden" id="popupSmallName" name="popupSmallName" />
												<input type="hidden" id="popupSmallCode" name="popupSmallCode" />
												<input type="hidden" id="popupItemName" name="popupItemName" /> 
												<input type="hidden" id="popupOrderName" name="popupOrderName" />
                        <input type="hidden" id="popupItemType" name="popupItemType" value="A" />
												<input type="hidden" id="popupCarTypeName" name="popupCarTypeName" />
                        <input type="hidden" id="popupItemStandardD" name="popupItemStandardD" />
												<input type="hidden" id="ORGID" name="ORGID" value="${searchVO.ORGID }" />
                        <input type="hidden" id="COMPANYID" name="COMPANYID" value="${searchVO.COMPANYID }" />
                        
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
																								<a id="btnChk1" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
																								<a id="btnChk2" class="btn_delete" href="#" onclick="javascript:fn_delete()"> 삭제 </a>
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
																</colgroup>
																<tr style="height: 34px;">
																		<th class="required_text">수주번호</th>
																		<td>
																		    <input type="text" id="SoNo" name="SoNo" class="input_center" style="width: 97%;" value="${searchVO.SONO }" readonly/>
																		</td>
																		<th class="required_text">수주일자</th>
																		<td>
																		    <input type="text" id="SoDate" name="SoDate" class="input_validation input_center" style="width: 97%;" maxlength="10" />
																		</td>
																		<th class="required_text">수주구분</th>
                                    <td><select id="SoType" name="SoType" class="input_left " style="width: 97%;">
                                                <c:forEach var="item" items="${labelBox.findBySoTypeGubun}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.SOTYPE}">
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
                                    <th class="required_text">거래처</th>
                                    <td>
                                        <input type="text" id="CustomerName" name=CustomerName class="input_validation input_center" style="width: 97%;" />
                                        <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                    </td>
                                    <th class="required_text">담당자</th>
                                    <td>
                                        <input type="text" id="SalesPersonName" name="SalesPersonName" class="input_validation input_center" style="width: 97%;" />
                                        <input type="hidden" id="SalesPerson" name="SalesPerson" />
                                    </td>
                                    <th class="required_text">납기일자</th>
                                    <td>
                                        <input type="text" id="DueDate" name="DueDate" class="input_center" style="width: 97%;" maxlength="10" />
                                    </td>
                                </tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">세액구분</th>
                                    <td><select id="TaxDiv" name="TaxDiv" class="input_left " style="width: 97%;">
                                                <c:forEach var="item" items="${labelBox.findByTaxDivGubun}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.TAXDIV}">
                                                            <option value="${item.VALUE}" data-val="${item.ATTRIBUTE1}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}" data-val="${item.ATTRIBUTE1}" >${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                    </select></td>
                                    <th class="required_text">결제조건</th>
                                    <td><select id="PaymentTerms" name="PaymentTerms" class="input_left " style="width: 97%;">
                                                <c:forEach var="item" items="${labelBox.findByPaymentTermsGubun}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.PAYMENTTERMS}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                    </select></td>
                                    <!-- <th class="required_text">마감일</th>
                                    <td>
                                        <input type="text" id="ClosingDateName" name="ClosingDateName" class="input_center" style="width: 97%;" maxlength="10" readonly/>
                                        <input type="hidden" id="ClosingDate" name="ClosingDate"/>
                                    </td> -->
                                    <td></td>
                                    <td></td>
                                </tr>
																<tr style="height: 34px;">
                                    <th class="required_text">수주상태</th>
                                    <td><select id="SoStatus" name="SoStatus" class="input_left " style="width: 97%;">
                                                <c:forEach var="item" items="${labelBox.findBySoStatusGubun}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.SOSTATUS}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                    </select></td>
																		<th class="required_text">비고</th>
																		<td colspan="3"><input type="text" id="ReMarks" name=ReMarks class=" input_left" style="width: 99%;" /></td>
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