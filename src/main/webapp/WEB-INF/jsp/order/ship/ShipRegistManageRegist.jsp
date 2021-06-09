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
    setExtGrid_popup2();

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
var global_cust_ware_code = "", global_cust_ware_name = "", global_cust_ware_yn = "";
function setInitial() {
    // 최초 상태 설정
    gridnms["app"] = "order";

    calender($('#ShipDate'));

    $('#ShipDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    var orgid = $('#searchOrgId').val();
    var companyid = $('#searchCompanyId').val();
    global_cust_ware_code = fn_option_filter_data(orgid, companyid, 'OM', 'CUSTOMER_WAREHOUSING', 'VALUE', 'LABEL');
    global_cust_ware_name = fn_option_filter_data(orgid, companyid, 'OM', 'CUSTOMER_WAREHOUSING', 'LABEL', 'LABEL');
    global_cust_ware_yn = fn_option_filter_data(orgid, companyid, 'OM', 'CUSTOMER_WAREHOUSING', 'ATTRIBUTE1', 'LABEL');
}

function setLastInitial() {

    var shipno = $('#ShipNo').val();
    var isCheck = shipno.length == 0 ? false : true;
    if (isCheck) {
        fn_search();
    } else {
        $("#ShipDate").val(getToDay("${searchVO.TODAY}") + "");
        $("#popupDueFrom").val(getToDay("${searchVO.datefrom}") + "");
        $("#popupDueTo").val(getToDay("${searchVO.dateto}") + "");

        var groupid = "${searchVO.groupId}";
        switch (groupid) {
        case "ROLE_ADMIN":
            // 관리자 권한일 때 그냥 놔둠
            break;
        default:
            // 관리자 외 권한일 때 사용자명 표기
            $('#ShipPersonName').val("${searchVO.krname}");
            $('#ShipPerson').val("${searchVO.employeenumber}");
            break;
        }
    }

    $('#TaxDiv').change(function (event) {
        var count = Ext.getStore(gridnms["store.1"]).count();
        if (count > 0) {
            for (var i = 0; i < count; i++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
                var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                var qty = model1.data.SHIPQTY; // 수량

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
}

var colIdx = 0, rowIdx = 0;
var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "ShipRegistManageRegist";
    gridnms["grid.11"] = "customerWarehousingLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];

    gridnms["models.list"].push(gridnms["model.1"]);
    gridnms["models.list"].push(gridnms["model.11"]);

    gridnms["stores.list"].push(gridnms["store.1"]);
    gridnms["stores.list"].push(gridnms["store.11"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'number',
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'SHIPNO',
        }, {
            type: 'number',
            name: 'SHIPSEQ',
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
            type: 'string',
            name: 'CARTYPE',
        }, {
            type: 'string',
            name: 'CARTYPENAME',
        }, {
            type: 'number',
            name: 'SOQTY',
        }, {
            type: 'number',
            name: 'WAREHOUSINGQTY',
        }, {
            type: 'number',
            name: 'SHIPQTY',
        }, {
            type: 'number',
            name: 'BEFOREQTY',
        }, {
            type: 'number',
            name: 'UNSOLDQTY',
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
            name: 'SONO',
        }, {
            type: 'string',
            name: 'SOSEQ',
        }, {
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'number',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'WAREHOUSINGNO',
        }, {
            type: 'string',
            name: 'SHIPMENTINSPECTIONYN',
        }, {
            type: 'string',
            name: 'SHIPCHECKSTATUS',
        }, {
            type: 'string',
            name: 'SHIPCHECKSTATUSNAME',
        }, {
            type: 'string',
            name: 'TRADEYN',
        }, {
            type: 'string',
            name: 'TRADEYNNAME',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'MFGNO',
        }, {
            type: 'string',
            name: 'SONOPOST',
        }, {
            type: 'string',
            name: 'SOSEQPOST',
        }, {
            type: 'string',
            name: 'ITEMCODEPOST',
        }, {
            type: 'string',
            name: 'LOTNOPOST',
        }, {
            type: 'string',
            name: 'CUSTOMERWAREHOUSING',
        }, {
            type: 'string',
            name: 'CUSTOMERWAREHOUSINGNAME',
        }, ];

    fields["model.11"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
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

                var result = record.data.TRADEYNNAME;

                if (result == "생성") {
//                     meta['tdCls'] = 'x-item-disabled';
                } else {
                    meta['tdCls'] = '';
                }
                return new Ext.ux.CheckColumn().renderer(value);
            },
            listeners: {
                beforecheckchange: function (options, row, value, event) {

                    var record = Ext.getCmp(gridnms["views.list"]).selModel.store.data.items[row].data;
                    if (value) {
                        var result = record.data.TRADEYNNAME;
                        if (result == "생성") {
                            extAlert("거래명세서가 생성된 경우 출하삭제가 불가능합니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }
                    }
                }
            },
        }, {
            dataIndex: 'SHIPSEQ',
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
            //        editor: {
            //          xtype: 'textfield',
            //          editable: false,
            //          enableKeyEvents: true,
            //          listeners: {
            //            specialkey: function (field, e) {
            //              if (e.keyCode === 38) {
            //                // 위
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //            },
            //          },
            //        },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
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
            //      }, {
            //        dataIndex: 'SHIPMENTINSPECTIONYN',
            //        text: '검사<br>여부',
            //        xtype: 'gridcolumn',
            //        width: 55,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "center",
            //        editor: {
            //          xtype: 'combobox',
            //          store: ['Y', 'N'],
            //          matchFieldWidth: true,
            //          editable: false,
            //          allowBlank: true,
            //          typeAhead: true,
            //          forceSelection: false,
            //          //          listeners: {
            //          //            select: function (field, record, eOpts) {
            //          //              var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //          //              rowIdx = selModel.getCurrentPosition().row;
            //          //              colIdx = selModel.getCurrentPosition().column;
            //          //              fn_grid_focus_move("RIGHT", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //          //            }
            //          //          },
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
            align: "left",
            //        editor: {
            //          xtype: 'textfield',
            //          editable: false,
            //          enableKeyEvents: true,
            //          listeners: {
            //            specialkey: function (field, e) {
            //              if (e.keyCode === 38) {
            //                // 위
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
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
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
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
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
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
            text: '수주수량',
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
            //           listeners: {
            //             specialkey: function (field, e) {
            //               if (e.keyCode === 38) {
            //                 // 위
            //                 var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                 rowIdx = selModel.getCurrentPosition().row;
            //                 colIdx = selModel.getCurrentPosition().column;

            //                 fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //               }
            //               if (e.keyCode === 40) {
            //                 // 아래
            //                 var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                 rowIdx = selModel.getCurrentPosition().row;
            //                 colIdx = selModel.getCurrentPosition().column;

            //                 fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //               }
            //             },
            //           },
            //        },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'BEFOREQTY',
            text: '기출하<br/>수량',
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
            //          listeners: {
            //            specialkey: function (field, e) {
            //              if (e.keyCode === 38) {
            //                // 위
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //            },
            //          },
            //        },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
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
                    //            specialkey: function (field, e) {
                    //              if (e.keyCode === 38) {
                    //                // 위
                    //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                    //                rowIdx = selModel.getCurrentPosition().row;
                    //                colIdx = selModel.getCurrentPosition().column;

                    //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                    //              }
                    //              if (e.keyCode === 40) {
                    //                // 아래
                    //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                    //                rowIdx = selModel.getCurrentPosition().row;
                    //                colIdx = selModel.getCurrentPosition().column;

                    //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                    //              }
                    //            },
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        var soqty = store.data.SOQTY * 1; // 수주수량
                        var wareqty = store.data.WAREHOUSINGQTY * 1; // 입고수량

                        var qty = field.getValue() * 1; // 출고수량
                        var tqty = oldValue * 1; // 출고수량

                        var beforeqty = store.data.BEFOREQTY * 1; // 기출하수량

                        //미출하잔량 계산 시작
                        var unsoldqty = (soqty - (beforeqty + qty));
                        if(unsoldqty <0) unsoldqty=0;
                        store.set("UNSOLDQTY", unsoldqty);
                        //미출하잔량 계산 끝

                        var unitprice = store.data.UNITPRICE; // 단가

                        var supplyprice = qty * unitprice; //공급가액
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
                meta.style = "background-color:rgb(253, 218, 255)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'UNSOLDQTY',
            text: '미출하<br/>잔량',
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
            //          listeners: {
            //            specialkey: function (field, e) {
            //              if (e.keyCode === 38) {
            //                // 위
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //            },
            //          },
            //        },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";

                if(value<0)
                  value=0;
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
                    //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                    //                rowIdx = selModel.getCurrentPosition().row;
                    //                colIdx = selModel.getCurrentPosition().column;

                    //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                    //              }
                    //              if (e.keyCode === 40) {
                    //                // 아래
                    //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                    //                rowIdx = selModel.getCurrentPosition().row;
                    //                colIdx = selModel.getCurrentPosition().column;

                    //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                    //              }
                    //            },
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        var soqty = store.data.SOQTY * 1; // 수주수량
                        var wareqty = store.data.WAREHOUSINGQTY * 1; // 입고수량

                        var qty = store.data.SHIPQTY * 1; // 출고수량

                        //미출고잔량 계산 시작
                        var unsoldqty = wareqty - qty;
                        store.set("UNSOLDQTY", unsoldqty);
                        //미출고잔량 계산 끝

                        var unitprice = field.getValue() * 1; // 단가

                        var supplyprice = qty * unitprice; //공급가액
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
                maxLength: '10',
                maskRe: /[0-9]/,
                selectOnFocus: true,
                listeners: {
                    //            specialkey: function (field, e) {
                    //              if (e.keyCode === 38) {
                    //                // 위
                    //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                    //                rowIdx = selModel.getCurrentPosition().row;
                    //                colIdx = selModel.getCurrentPosition().column;

                    //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                    //              }
                    //              if (e.keyCode === 40) {
                    //                // 아래
                    //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                    //                rowIdx = selModel.getCurrentPosition().row;
                    //                colIdx = selModel.getCurrentPosition().column;

                    //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                    //              }
                    //            },
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        var supplyprice = newValue * 1;

                        var tax_rate = $('#TaxDiv option:selected').attr("data-val");
                        var additionaltax = Math.round(supplyprice * (tax_rate / 100)); // 부가세
                        store.set("ADDITIONALTAX", additionaltax);

                        var total = supplyprice + additionaltax; // 합계
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
                    //            specialkey: function (field, e) {
                    //              if (e.keyCode === 38) {
                    //                // 위
                    //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                    //                rowIdx = selModel.getCurrentPosition().row;
                    //                colIdx = selModel.getCurrentPosition().column;

                    //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                    //              }
                    //              if (e.keyCode === 40) {
                    //                // 아래
                    //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                    //                rowIdx = selModel.getCurrentPosition().row;
                    //                colIdx = selModel.getCurrentPosition().column;

                    //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                    //              }
                    //            },
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

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
            //          listeners: {
            //            specialkey: function (field, e) {
            //              if (e.keyCode === 38) {
            //                // 위
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
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
            dataIndex: 'CUSTOMERWAREHOUSINGNAME',
            text: '고객사 창고',
            xtype: 'gridcolumn',
            width: 130,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.11"],
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

                        model.set("CUSTOMERWAREHOUSING", record.data.VALUE);
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
        }, {
            dataIndex: 'MFGNO',
            text: 'LOT번호',
            xtype: 'gridcolumn',
            width: 130,
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
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //            },
            //          },
            //        },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'SONO',
            text: '수주번호',
            xtype: 'gridcolumn',
            width: 130,
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
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //            },
            //          },
            //        },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'SOSEQ',
            text: '수주내역<br/>순번',
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
            //          listeners: {
            //            specialkey: function (field, e) {
            //              if (e.keyCode === 38) {
            //                // 위
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //            },
            //          },
            //        },
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
            text: '변경수주',
            width: 85,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "등록",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var rn = record.data.RN * 1;
                    var selectedRow = rn - 1;
                    $('#rowIndexVal').val(selectedRow);

                    //                  var isCheck = record.data.SONOPOST;
                    //                  if (isCheck != "") {
                    //                    extAlert("이미 변경수주를 등록하여 변경이 불가능합니다.<br/>다시 확인해주세요.");
                    //                    return;
                    //                  }
                    btnSel1();
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
            text: '변경수주',
            width: 85,
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "삭제",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var rn = record.data.RN * 1;
                    var selectedRow = rn - 1;
                    $('#rowIndexVal').val(selectedRow);

                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                    var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                    if (store.data.ITEMCODEPOST != "") {
                        store.set("SONOPOST", "");
                        store.set("SOSEQPOST", "");
                        store.set("LOTNOPOST", "");
                        store.set("ITEMCODEPOST", "");
                    }
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
        }, {
            dataIndex: 'SONOPOST',
            text: '변경<br/>수주번호',
            xtype: 'gridcolumn',
            width: 130,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            //                 editor: {
            //                   xtype: 'textfield',
            //                   editable: true,
            //                   enableKeyEvents: true,
            //                   selectOnFocus: true,
            //                   listeners: {
            //                       change: function (field, newValue, oldValue, eOpts) {
            //                           var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            //                           Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
            //                           var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

            //                           if ( newValue != oldValue ) {
            //                             if ( store.data.ITEMCODEPOST != "" ) {
            //                                   field.setValue("");
            //                                   store.set("SOSEQPOST", "");
            //                                   store.set("LOTNOPOST", "");
            //                                   store.set("ITEMCODEPOST", "");
            //                             }
            //                           }

            //                         },
            // //                      specialkey: function (field, e) {
            // //                        if (e.keyCode === 38) {
            // //                          // 위
            // //                          var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            // //                          rowIdx = selModel.getCurrentPosition().row;
            // //                          colIdx = selModel.getCurrentPosition().column;

            // //                          fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            // //                        }
            // //                        if (e.keyCode === 40) {
            // //                          // 아래
            // //                          var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            // //                          rowIdx = selModel.getCurrentPosition().row;
            // //                          colIdx = selModel.getCurrentPosition().column;

            // //                          fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            // //                        }
            // //                      },
            //                   },
            //                 },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'SOSEQPOST',
            text: '변경<br/>수주순번',
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
            //           editor: {
            //               xtype: 'textfield',
            //               editable: true,
            //               enableKeyEvents: true,
            //               selectOnFocus: true,
            //               listeners: {
            //                   change: function (field, newValue, oldValue, eOpts) {
            //                       var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

            //                       Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
            //                       var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

            //                       if ( newValue != oldValue ) {
            //                           if ( store.data.ITEMCODEPOST != "" ) {
            //                               field.setValue("");
            //                               store.set("LOTNOPOST", "");
            //                               store.set("ITEMCODEPOST", "");
            //                         }
            //                       }

            //                     },
            // //                specialkey: function (field, e) {
            // //                  if (e.keyCode === 38) {
            // //                    // 위
            // //                    var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            // //                    rowIdx = selModel.getCurrentPosition().row;
            // //                    colIdx = selModel.getCurrentPosition().column;

            // //                    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            // //                  }
            // //                  if (e.keyCode === 40) {
            // //                    // 아래
            // //                    var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            // //                    rowIdx = selModel.getCurrentPosition().row;
            // //                    colIdx = selModel.getCurrentPosition().column;

            // //                    fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            // //                  }
            // //                },
            //               },
            //             },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'LOTNOPOST',
            text: '변경 소재LOT',
            xtype: 'gridcolumn',
            width: 350,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                //                listeners: {
                //                  specialkey: function (field, e) {
                //                    if (e.keyCode === 38) {
                //                      // 위
                //                      var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                //                      rowIdx = selModel.getCurrentPosition().row;
                //                      colIdx = selModel.getCurrentPosition().column;

                //                      fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                //                    }
                //                    if (e.keyCode === 40) {
                //                      // 아래
                //                      var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                //                      rowIdx = selModel.getCurrentPosition().row;
                //                      colIdx = selModel.getCurrentPosition().column;

                //                      fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                //                    }
                //                  },
                //                },
            }
        }, {
            dataIndex: 'TRADEYNNAME',
            text: '거래명세서<br/>생성여부',
            xtype: 'gridcolumn',
            width: 90,
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
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //              if (e.keyCode === 40) {
            //                // 아래
            //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
            //                rowIdx = selModel.getCurrentPosition().row;
            //                colIdx = selModel.getCurrentPosition().column;

            //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
            //              }
            //            },
            //          },
            //        },
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
                //          listeners: {
                //            specialkey: function (field, e) {
                //              if (e.keyCode === 38) {
                //                // 위
                //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                //                rowIdx = selModel.getCurrentPosition().row;
                //                colIdx = selModel.getCurrentPosition().column;

                //                fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                //              }
                //              if (e.keyCode === 40) {
                //                // 아래
                //                var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                //                rowIdx = selModel.getCurrentPosition().row;
                //                colIdx = selModel.getCurrentPosition().column;

                //                fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                //              }
                //            },
                //          },
            }
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'WAREHOUSINGNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'WAREHOUSINGQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'OUTPOSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODEPOST',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'SMALLNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'SHIPCHECKSTATUS',
            xtype: 'hidden',
        }, {
            dataIndex: 'SHIPCHECKSTATUSNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'TRADEYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/order/ship/ShipRegistManageDetailList.do' />"
    });

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
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var tradeyn = model1.data.TRADEYNNAME;
        if (!tradeyn == "생성") {
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
    
    var shipno = $('#ShipNo').val();
    if (shipno == null || shipno == undefined) {
        extAlert("[출하 미등록]<br/>출하 내역을 저장하셔야 단가 적용이 가능합니다.<br/>다시 한번 확인해주십시오.");
        return false;
    }

    var count = Ext.getStore(gridnms["store.1"]).count();
    var check_count = 0;

    for (var i = 0; i < count; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

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
                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(j));
                    var record = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                    var chk = record.data.CHK;
                    if (chk) {
                        $.ajax({
                            url: "<c:url value='/pkg/order/ship/UnitPriceManage.do' />",
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
        extAlert("[출하 미선택]<br/>선택된 출하 내역이 없습니다.<br/>다시 한번 확인해주십시오.");
        return false;
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
    var shipno = $('#ShipNo').val();
    var shipseq = "";
    var url = "<c:url value='/delete/order/ship/ShipRegistManageDetailList.do' />";

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
    var count = 0,
    tradecount = 0;
    var tradeyn = "";
    for (var k = 0; k < gridcount; k++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(k));
        var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

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
                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
                    var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                    var tradeyn = model.data.TRADEYNNAME;
                    if (tradeyn == "생성") {
                        extAlert("거래명세서가 생성되어 삭제가 불가능합니다.<br/>다시 한번 확인해주십시오.");
                        return;
                    } else {
                        if (model.data.CHK) {
                            orgid = model.data.ORGID;
                            companyid = model.data.COMPANYID;
                            shipno = model.data.SHIPNO;
                            shipseq = model.data.SHIPSEQ;

                            if (shipno == "") {
                                // 데이터 등록되지 않은 건
                                deletecount++;
                                store.remove(model);
                            } else {
                                // 데이터 등록 건

                                var sparams = {
                                    ORGID: orgid,
                                    COMPANYID: companyid,
                                    SHIPNO: shipno,
                                    SHIPSEQ: shipseq,
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
                                            go_url("<c:url value='/order/ship/ShipRegistManageRegist.do?SHIPNO=' />" + shipno + "&org=" + orgid + "&company=" + companyid);

                                        }
                                    },
                                    error: ajaxError
                                });

                            }
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
                shipseq = record.data.SHIPSEQ;
                var tradeyn = record.data.TRADEYNNAME;

                if (tradeyn == "생성") {
                    extAlert("거래명세서가 생성되어 삭제가 불가능합니다.<br/>다시 한번 확인해주십시오.");
                    return;
                } else {

                    if (shipno == "") {
                        store.remove(model);
                    } else {

                        var sparams = {
                            ORGID: orgid,
                            COMPANYID: companyid,
                            SHIPNO: shipno,
                            SHIPSEQ: shipseq,
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
                                    go_url("<c:url value='/order/ship/ShipRegistManageRegist.do?SHIPNO=' />" + shipno + "&org=" + orgid + "&company=" + companyid);
                                }
                            },
                            error: ajaxError
                        });
                    }

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

    Ext.define(gridnms["model.11"], {
        extend: Ext.data.Model,
        fields: fields["model.11"],
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
                                SHIPNO: $('#ShipNo').val(),
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
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
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                BIGCD: 'OM',
                                MIDDLECD: 'CUSTOMER_WAREHOUSING',
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
                                //                      var inspyn = data.data.SHIPMENTINSPECTIONYN;
                                //                      if (inspyn == "Y") {
                                //                        editDisableCols.push("SHIPQTY");
                                //                        editDisableCols.push("UNITPRICE");
                                //                        editDisableCols.push("SUPPLYPRICE");
                                //                        editDisableCols.push("ADDITIONALTAX");
                                //                         editDisableCols.push("LOTNOPOST");
                                //                      }

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

function setValues_Popup1() {
    gridnms["models.popup1"] = [];
    gridnms["stores.popup1"] = [];
    gridnms["views.popup1"] = [];
    gridnms["controllers.popup1"] = [];

    gridnms["grid.4"] = "Popup1";
    gridnms["grid.41"] = "BigCodePopup";
    gridnms["grid.42"] = "MiddleCodePopup";
    gridnms["grid.43"] = "SmallCodePopup";

    gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
    gridnms["views.popup1"].push(gridnms["panel.4"]);

    gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
    gridnms["controllers.popup1"].push(gridnms["controller.4"]);

    gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
    gridnms["model.41"] = gridnms["app"] + ".model." + gridnms["grid.41"];
    gridnms["model.42"] = gridnms["app"] + ".model." + gridnms["grid.42"];
    gridnms["model.43"] = gridnms["app"] + ".model." + gridnms["grid.43"];

    gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
    gridnms["store.41"] = gridnms["app"] + ".store." + gridnms["grid.41"];
    gridnms["store.42"] = gridnms["app"] + ".store." + gridnms["grid.42"];
    gridnms["store.43"] = gridnms["app"] + ".store." + gridnms["grid.43"];

    gridnms["models.popup1"].push(gridnms["model.4"]);
    gridnms["models.popup1"].push(gridnms["model.41"]);
    gridnms["models.popup1"].push(gridnms["model.42"]);
    gridnms["models.popup1"].push(gridnms["model.43"]);

    gridnms["stores.popup1"].push(gridnms["store.4"]);
    gridnms["stores.popup1"].push(gridnms["store.41"]);
    gridnms["stores.popup1"].push(gridnms["store.42"]);
    gridnms["stores.popup1"].push(gridnms["store.43"]);

    fields["model.4"] = [{
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
            name: 'MATERIALTYPE',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'SHIPMENTINSPECTIONYN',
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
            name: 'UNSOLDQTY',
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
            name: 'TAXDIV',
        }, {
            type: 'string',
            name: 'TAXDIVNAME',
        }, {
            type: 'string',
            name: 'LOTNOPOST',
        }, ];

    fields["model.41"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.42"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.43"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.4"] = [{
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
            //       }, {
            //           dataIndex: 'BIGNAME',
            //           text: '대분류',
            //           xtype: 'gridcolumn',
            //           width: 120,
            //           hidden: false,
            //           sortable: false,
            //           resizable: false,
            //           menuDisabled: true,
            //           style: 'text-align:center;',
            //           align: "center",
            //         }, {
            //           dataIndex: 'MIDDLENAME',
            //           text: '중분류',
            //           xtype: 'gridcolumn',
            //           width: 180,
            //           hidden: false,
            //           sortable: false,
            //           resizable: false,
            //           menuDisabled: true,
            //           style: 'text-align:center;',
            //           align: "center",
            //         }, {
            //           dataIndex: 'SMALLNAME',
            //           text: '소분류',
            //           xtype: 'gridcolumn',
            //           width: 120,
            //           hidden: false,
            //           sortable: false,
            //           resizable: false,
            //           menuDisabled: true,
            //           style: 'text-align:center;',
            //           align: "center",
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
            width: 60,
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
            dataIndex: 'SOQTY',
            text: '수주<br/>수량',
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
            dataIndex: 'SHIPQTY',
            text: '기출하<br/>수량',
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
            dataIndex: 'UNSOLDQTY',
            text: '입고<br/>잔량',
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
            dataIndex: 'UNITPRICE',
            text: '단가',
            xtype: 'gridcolumn',
            width: 105,
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
            dataIndex: 'SONO',
            text: '수주번호',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'SOSEQ',
            text: '수주내역<br/>순번',
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
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            width: 70,
            text: '',
            style: 'text-align:center',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "적용",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var sono = record.data.SONO;
                    var soseq = record.data.SOSEQ;
                    var itemcode = record.data.ITEMCODE;
                    var lotno = record.data.LOTNOPOST;
                    var rowindex = $('#rowIndexVal').val();

                    var model1 = Ext.getStore(gridnms["store.1"]).getAt(rowindex);

                    model1.set("SONOPOST", sono);
                    model1.set("SOSEQPOST", soseq);
                    model1.set("ITEMCODEPOST", itemcode);
                    model1.set("LOTNOPOST", lotno);

                    win11.close();

                    $("#gridPopup1Area").hide("blind", {
                        direction: "up"
                    }, "fast");
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
            }
            //      }, {
            //        dataIndex: 'CHK',
            //        text: '',
            //        xtype: 'checkcolumn',
            //        width: 50,
            //        sortable: false,
            //        resizable: false,
            //        menuDisabled: true,
            //        style: 'text-align:center;',
            //        align: "center",
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
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
            dataIndex: 'BIGNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'MIDDLENAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'SMALLNAME',
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
            dataIndex: 'SHIPMENTINSPECTIONYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'TAXDIV',
            xtype: 'hidden',
        }, {
            dataIndex: 'TAXDIVNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'LOTNOPOST',
            xtype: 'hidden',
        }, ];

    items["api.4"] = {};
    $.extend(items["api.4"], {
        read: "<c:url value='/searchShipRegistManagePopupList.do'/>"
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
function setExtGrid_Popup1() {
    Ext.define(gridnms["model.4"], {
        extend: Ext.data.Model,
        fields: fields["model.4"],
    });

    Ext.define(gridnms["model.41"], {
        extend: Ext.data.Model,
        fields: fields["model.41"],
    });

    Ext.define(gridnms["model.42"], {
        extend: Ext.data.Model,
        fields: fields["model.42"],
    });

    Ext.define(gridnms["model.43"], {
        extend: Ext.data.Model,
        fields: fields["model.43"],
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

    Ext.define(gridnms["store.41"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.41"],
                        model: gridnms["model.41"],
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

    Ext.define(gridnms["store.42"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.42"],
                        model: gridnms["model.42"],
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

    Ext.define(gridnms["store.43"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.43"],
                        model: gridnms["model.43"],
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

function setValues_Popup2() {
    gridnms["models.popup3"] = [];
    gridnms["stores.popup3"] = [];
    gridnms["views.popup3"] = [];
    gridnms["controllers.popup3"] = [];

    gridnms["grid.5"] = "WarehousingPopup";

    gridnms["panel.5"] = gridnms["app"] + ".view." + gridnms["grid.5"];
    gridnms["views.popup3"].push(gridnms["panel.5"]);

    gridnms["controller.5"] = gridnms["app"] + ".controller." + gridnms["grid.5"];
    gridnms["controllers.popup3"].push(gridnms["controller.5"]);

    gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];

    gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];

    gridnms["models.popup3"].push(gridnms["model.5"]);

    gridnms["stores.popup3"].push(gridnms["store.5"]);

    fields["model.5"] = [{
            type: 'number',
            name: 'ORGID',
        }, {
            type: 'number',
            name: 'COMPANYID',
        }, {
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
            type: 'date',
            name: 'WORKENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'number',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'SONO',
        }, {
            type: 'number',
            name: 'SOSEQ',
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
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'number',
            name: 'SOQTY',
        }, {
            type: 'number',
            name: 'PRESHIPQTY',
        }, {
            type: 'number',
            name: 'SHIPQTY',
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
        }, {}, ];

    fields["columns.5"] = [
        // Display Columns
        {
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
            dataIndex: 'WORKENDDATE',
            text: '입고일',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
                return Ext.util.Format.date(value, 'Y-m-d');
            },
            //        }, {
            //            dataIndex: 'BIGNAME',
            //            text: '대분류',
            //            xtype: 'gridcolumn',
            //            width: 120,
            //            hidden: false,
            //            sortable: false,
            //            resizable: false,
            //            menuDisabled: true,
            //            style: 'text-align:center;',
            //            align: "center",
            //          }, {
            //            dataIndex: 'MIDDLENAME',
            //            text: '중분류',
            //            xtype: 'gridcolumn',
            //            width: 180,
            //            hidden: false,
            //            sortable: false,
            //            resizable: false,
            //            menuDisabled: true,
            //            style: 'text-align:center;',
            //            align: "center",
            //          }, {
            //            dataIndex: 'SMALLNAME',
            //            text: '소분류',
            //            xtype: 'gridcolumn',
            //            width: 120,
            //            hidden: false,
            //            sortable: false,
            //            resizable: false,
            //            menuDisabled: true,
            //            style: 'text-align:center;',
            //            align: "center",
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 430,
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
            width: 60,
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
            dataIndex: 'SOQTY',
            text: '수주<br/>수량',
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
            dataIndex: 'TRXQTY',
            text: '입고<br/>수량',
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
            dataIndex: 'PRESHIPQTY',
            text: '기출하<br/>수량',
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
            dataIndex: 'SHIPQTY',
            text: '입고<br/>잔량',
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
            //      }, {
            //        dataIndex: 'SONO',
            //        text: '수주번호',
            //        xtype: 'gridcolumn',
            //        width: 120,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        style: 'text-align:center;',
            //        align: "center",
            //      }, {
            //        dataIndex: 'SOSEQ',
            //        text: '수주내역<br/>순번',
            //        xtype: 'gridcolumn',
            //        width: 70,
            //        hidden: false,
            //        sortable: false,
            //        resizable: false,
            //        style: 'text-align:center;',
            //        align: "center",
            //        cls: 'ERPQTY',
            //        format: "0,000",
            //        renderer: function (value, meta, record) {
            //          return Ext.util.Format.number(value, '0,000');
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
            dataIndex: 'WAREHOUSINGNO',
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
            dataIndex: 'BIGNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'MIDDLENAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'SMALLNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'CARTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'SHIPQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERID',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'SONO',
            xtype: 'hidden',
        }, {
            dataIndex: 'SOSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'SHIPMENTINSPECTIONYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'TAXDIV',
            xtype: 'hidden',
        }, {
            dataIndex: 'TAXDIVNAME',
            xtype: 'hidden',
        }, ];

    items["api.5"] = {};
    $.extend(items["api.5"], {
        read: "<c:url value='/searchShipRegistManagePopup2List.do' />"
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

function setExtGrid_popup2() {
    Ext.define(gridnms["model.5"], {
        extend: Ext.data.Model,
        fields: fields["model.5"],
    });

    Ext.define(gridnms["store.5"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.5"],
                        model: gridnms["model.5"],
                        autoLoad: false,
                        pageSize: 999999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.5"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.5"], {
        extend: Ext.app.Controller,
        refs: {
            WarehousingPopup: '#WarehousingPopup',
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
                    itemId: 'WarehousingPopup',
                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.5"],
            }
        ],
    });

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup3"],
        stores: gridnms["stores.popup3"],
        views: gridnms["views.popup3"],
        controllers: gridnms["controller.5"],

        launch: function () {
            gridarea5 = Ext.create(gridnms["views.popup3"], {
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
    var shipno = $('#ShipNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SHIPNO: shipno,
    };

    var url = "<c:url value='/select/order/ship/ShipRegistManageMasterList.do' />";

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var shipno = dataList.SHIPNO;
            var shipdate = dataList.SHIPDATE;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var shipperson = dataList.SHIPPERSON;
            var shippersonname = dataList.SHIPPERSONNAME;
            var shipgubun = dataList.SHIPGUBUN;
            var shipgubunname = dataList.SHIPGUBUNNAME;
            var deliveryvan = dataList.DELIVERYVAN;
            var deliveryvanname = dataList.DELIVERYVANNAME;
            var taxdiv = dataList.TAXDIV;
            var remarks = dataList.REMARKS;

            $("#ShipNo").val(shipno);
            $("#ShipDate").val(shipdate);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#ShipPerson").val(shipperson);
            $("#ShipPersonName").val(shippersonname);
            $("#ShipGubun").val(shipgubun);
            $("#DeliveryVan").val(deliveryvan);
            $("#TaxDiv").val(taxdiv);
            $("#ReMarks").val(remarks);

            global_close_yn = fn_monthly_close_filter_data(shipdate, 'OM');
        },
        error: ajaxError
    });
}

function btnSel1() {

    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if ( global_close_yn == "Y" ) {
      extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록하실 수 없습니다.<br/>관리자에게 문의해주세요.");
      return false;
    }
    
    //     var shipdate = $('#ShipDate').val();
    //     if (shipdate === "") {
    //       header.push("출하일자");
    //       count++;
    //     }
    var customercode = $('#CustomerCode').val();
    var customername = $('#CustomerName').val();
    if (customercode === "") {
        header.push("거래처");
        count++;
    }
    //     var shipperson = $('#ShipPerson').val();
    //     if (shipperson === "") {
    //       header.push("담당자");
    //       count++;
    //     }
    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return;
    }

    // 수주현황 팝업
    var width = 1550; // 가로
    var height = 640; // 세로
    var title = "수주현황 Popup (거래처 : " + customername + ")";

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
                itemId: gridnms["panel.4"],
                id: gridnms["panel.4"],
                store: gridnms["store.4"],
                height: '100%',
                border: 2,
                scrollable: true,
                frameHeader: true,
                columns: fields["columns.4"],
                viewConfig: {
                    itemId: 'onMypopClick'
                },
                plugins: 'bufferedrenderer',
                dockedItems: items["docked.4"],
            }
        ],
        tbar: [
            '대분류', {
                xtype: 'combo',
                name: 'searchBigName',
                clearOnReset: true,
                hideLabel: true,
                width: 120,
                store: gridnms["store.41"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
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
                        $('#popupOrderName').val("");
                        $('#popupItemName').val("");

                        $('input[name=searchMiddleName]').val("");
                        $('input[name=searchSmallName]').val("");
                        $('input[name=searchOrderName]').val("");
                        $('input[name=searchItemName]').val("");

                        var sparams1 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                        };
                        extGridSearch(sparams1, gridnms["store.42"]);

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.43"]);
                    },
                }
            },
            '중분류', {
                xtype: 'combo',
                name: 'searchMiddleName',
                clearOnReset: true,
                hideLabel: true,
                width: 120,
                store: gridnms["store.42"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
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
                        $('#popupOrderName').val("");
                        $('#popupItemName').val("");

                        $('input[name=searchSmallName]').val("");
                        $('input[name=searchOrderName]').val("");
                        $('input[name=searchItemName]').val("");

                        var sparams2 = {
                            GROUPCODE: $('#popupGroupCode').val(),
                            BIGCODE: $('#popupBigCode').val(),
                            MIDDLECODE: $('#popupMiddleCode').val(),
                        };
                        extGridSearch(sparams2, gridnms["store.43"]);
                    },
                }
            },
            '소분류', {
                xtype: 'combo',
                name: 'searchSmallName',
                clearOnReset: true,
                hideLabel: true,
                width: 120,
                store: gridnms["store.43"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
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
                        $('#popupOrderName').val("");
                        $('#popupItemName').val("");

                        $('input[name=searchOrderName]').val("");
                        $('input[name=searchItemName]').val("");
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
                width: 250,
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
                    fn_popup_search();
                }
            },
        ]
    });
    win11.show();
}

function fn_popup_search() {
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
    extGridSearch(params, gridnms["store.4"]);
}

var global_popup_flag2 = false;
function btnSel2(btn) {
    var header = [],
    count = 0;

    if ( global_close_yn == "Y" ) {
      extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록하실 수 없습니다.<br/>관리자에게 문의해주세요.");
      return false;
    }
    
    //    var shipdate = $('#ShipDate').val();
    //    if (shipdate === "") {
    //      header.push("출하일자");
    //      count++;
    //    }
    //    var customercode = $('#CustomerCode').val();
    //    if (customercode === "") {
    //      header.push("거래처");
    //      count++;
    //    }
    //    var shipperson = $('#ShipPerson').val();
    //    if (shipperson === "") {
    //      header.push("담당자");
    //      count++;
    //    }
    //    if (count > 0) {
    //      extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
    //      return;
    //    }

    // 완성품 재고현황 불러오기 Pop up
    var width = 1520; // 가로
    var height = 640; // 세로
    var title = "완성품 재고현황 Popup";

    var check = true;
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
        Ext.getStore(gridnms["store.5"]).removeAll();

        win3 = Ext.create('Ext.window.Window', {
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
                        itemId: 'WarehousingPopup',
                        trackOver: true,
                        loadMask: true,
                    },
                    plugins: [{
                            ptype: 'bufferedrenderer',
                            trailingBufferZone: 20, // #1
                            leadingBufferZone: 20, // #2
                            synchronousRender: false,
                            numFromEdge: 19,
                        }
                    ],
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
                    store: gridnms["store.41"],
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
                            extGridSearch(sparams1, gridnms["store.42"]);

                            var sparams2 = {
                                GROUPCODE: $('#popupGroupCode').val(),
                                BIGCODE: $('#popupBigCode').val(),
                                MIDDLECODE: $('#popupMiddleCode').val(),
                            };
                            extGridSearch(sparams2, gridnms["store.43"]);
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
                            extGridSearch(sparams1, gridnms["store.42"]);

                            var sparams2 = {
                                GROUPCODE: $('#popupGroupCode').val(),
                                BIGCODE: $('#popupBigCode').val(),
                                MIDDLECODE: $('#popupMiddleCode').val(),
                            };
                            extGridSearch(sparams2, gridnms["store.43"]);

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
                    store: gridnms["store.42"],
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
                            extGridSearch(sparams2, gridnms["store.43"]);
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
                            extGridSearch(sparams2, gridnms["store.43"]);

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
                                extGridSearch(sparams2, gridnms["store.43"]);
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
                    store: gridnms["store.43"],
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
                    width: 250,
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
                        var count5 = Ext.getStore(gridnms["store.5"]).count();
                        var checkTrue = 0,
                        checkFalse = 0;

                        if (global_popup_flag2) {
                          global_popup_flag2 = false;
                        } else {
                          global_popup_flag2 = true;
                        }
                        for (var i = 0; i < count5; i++) {
                            Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(i));
                            var model5 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];

                            var chk = model5.data.CHK;
                            if (global_popup_flag2) {
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
                        var count4 = Ext.getStore(gridnms["store.5"]).count();
                        var checknum = 0,
                        checkqty = 0,
                        checktemp = 0;
                        var qtytemp = [];

                        for (var i = 0; i < count4; i++) {
                            Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(i));
                            var model4 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];
                            var chk = model4.data.CHK;

                            if (chk) {
                                $('#TaxDiv').val(model4.data.TAXDIV);
                                for (var j = 0; j < count; j++) {
                                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(j));
                                    var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
                                    var workorderid2 = model4.data.WORKORDERID;
                                    var workorderseq2 = model4.data.WORKORDERSEQ
                                        var workorderid1 = model.data.WORKORDERID;
                                    var workorderseq1 = model.data.WORKORDERSEQ;
                                }
                                checknum++;
                            }
                        }
                        console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                        if (checknum == 0) {
                            extAlert("제품을 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                            return false;
                        }

                        if (count4 == 0) {
                            console.log("[적용] 제품 정보가 없습니다.");
                        } else {
                            for (var j = 0; j < count4; j++) {
                                Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup3"]).getSelectionModel().select(j));
                                var model5 = Ext.getCmp(gridnms["views.popup3"]).selModel.getSelection()[0];
                                var chk = model5.data.CHK;

                                if (chk) {
                                    var model = Ext.create(gridnms["model.1"]);
                                    var store = Ext.getStore(gridnms["store.1"]);

                                    // 순번
                                    model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);
                                    model.set("SHIPSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("SMALLCODE", model5.data.SMALLCODE);
                                    model.set("SMALLNAME", model5.data.SMALLNAME);
                                    model.set("ITEMCODE", model5.data.ITEMCODE);
                                    model.set("ORDERNAME", model5.data.ORDERNAME);
                                    model.set("DRAWINGNO", model5.data.DRAWINGNO); // 도면번호
                                    model.set("ITEMNAME", model5.data.ITEMNAME);
                                    model.set("CARTYPE", model5.data.CARTYPE);
                                    model.set("CARTYPENAME", model5.data.CARTYPENAME);
                                    model.set("MATERIALTYPE", model5.data.MATERIALTYPE);
                                    model.set("UOM", model5.data.UOM);
                                    model.set("UOMNAME", model5.data.UOMNAME);
                                    model.set("SOQTY", model5.data.SOQTY);
                                    model.set("BEFOREQTY", model5.data.PRESHIPQTY);
                                    model.set("UNITPRICE", model5.data.UNITPRICE);
                                    model.set("SUPPLYPRICE", model5.data.SUPPLYPRICE);
                                    model.set("ADDITIONALTAX", model5.data.ADDITIONALTAX);
                                    model.set("TOTAL", model5.data.TOTAL);
                                    model.set("WORKORDERID", model5.data.WORKORDERID);
                                    model.set("WORKORDERSEQ", model5.data.WORKORDERSEQ);
                                    model.set("SONO", model5.data.SONO);
                                    model.set("SOSEQ", model5.data.SOSEQ);
                                    model.set("ITEMSTANDARDDETAIL", model5.data.ITEMSTANDARDDETAIL);

                                    if (global_cust_ware_code.length > 0) {
                                        for (var c = 0; c < global_cust_ware_code.length; c++) {
                                            var yn = global_cust_ware_yn[c];
                                            if (yn == "Y") {
                                                model.set("CUSTOMERWAREHOUSING", global_cust_ware_code[c]);
                                                model.set("CUSTOMERWAREHOUSINGNAME", global_cust_ware_name[c]);
                                            }
                                        }
                                    }
                                    //                      var soqty = model5.data.SOQTY; // 수주수량
                                    //                      var shipqty = model5.data.SOQTY; // 수주수량
                                    //                      var qty = model5.data.SHIPQTY; // 기출하수량

                                    //                      model.set("SHIPQTY", (soqty - qty));
                                    //                      model.set("UNSOLDQTY", soqty - (qty + (soqty - qty)));

                                    var qty = model5.data.TRXQTY;
                                    var preqty = model5.data.PRESHIPQTY;
                                    var shipqty = model5.data.SHIPQTY;
                                    model.set("WAREHOUSINGQTY", qty);
                                    model.set("SHIPQTY", shipqty);
                                    model.set("UNSOLDQTY", (qty * 1) - ((preqty * 1) + (shipqty * 1)));
                                    model.set("WAREHOUSINGNO", model5.data.WAREHOUSINGNO);

                                    //                      model.set("SHIPMENTINSPECTIONYN", model5.data.SHIPMENTINSPECTIONYN); // 검사여부 "Y"

                                    // 그리드 적용 방식
                                    store.add(model);

                                    checktemp++;
                                };
                            }
                            Ext.getCmp(gridnms["panel.1"]).getView().refresh();

                        }

                        if (checktemp > 0) {
                            win3.close();

                            $("#gridPopup2Area").hide("blind", {
                                direction: "up"
                            }, "fast");
                        }
                    }
                }
            ]
        });
        win3.show();
    }
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
    extGridSearch(params, gridnms["store.5"]);
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

    var shipdate = $('#ShipDate').val();
    if (shipdate === "") {
        header.push("출하일자");
        count++;
    }

    var customercode = $('#CustomerCode').val();
    if (customercode === "") {
        header.push("거래처");
        count++;
    }

    var shipperson = $("ShipPerson").val();
    if (shipperson === "") {
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
            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
            var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

            var unitprice = model1.data.UNITPRICE;
            var shipqty = model1.data.SHIPQTY;

            if (shipqty == "" || shipqty == undefined) {
                header.push("출고수량");
                secount++;
            }

            //       if (unitprice == "" || unitprice == undefined) {
            //         header.push("단가");
            //         secount++;
            //       }

            if (secount > 0) {
                extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                return;
            }
        }
    }

    // 저장
    var shipno = $('#ShipNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = shipno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 출하등록 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/order/ship/ShipRegistManageMasterList.do' />";
        url1 = "<c:url value='/insert/order/ship/ShipRegistManageDetailList.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/order/ship/ShipRegistManageMasterList.do' />";
        url1 = "<c:url value='/update/order/ship/ShipRegistManageDetailList.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('출하등록 알림', '저장 하시겠습니까?', function (btn) {
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
                        var shipno = data.Shipno;

                        if (shipno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("Orgid", orgid);
                                model.set("CompanyId", companyid);
                                model.set("Shipno", shipno);

                                if (model.data.Shipno != '') {
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
                                            msg = "요청한 출하 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/order/ship/ShipRegistManageRegist.do?SHIPNO=' />" + shipno + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('출하등록', '출하등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('출하등록 변경 알림', '출하등록 내역을 변경하시겠습니까?', function (btn) {
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
                        var shipno = data.ShipNo;

                        if (shipno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("Orgid", orgid);
                                model.set("CompanyId", companyid);
                                model.set("Shipno", shipno);

                                if (model.data.Shipno != '') {
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
                                            msg = "출하등록 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/order/ship/ShipRegistManageRegist.do?SHIPNO=' />" + shipno + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('출하등록 변경', '변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_delete() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var shipno = $('#ShipNo').val();

    if ( global_close_yn == "Y" ) {
      extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 삭제하실 수 없습니다.<br/>관리자에게 문의해주세요.");
      return false;
    }
    
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    if (count1 > 0) {
        extAlert("[상세 데이터 ]<br/> 출하 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return;
    }

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SHIPNO: shipno,
    };

    var url = "<c:url value='/delete/order/ship/ShipRegistManageMasterList.do' />";

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

function fn_list() {
    go_url("<c:url value='/order/ship/ShipRegistManageList.do'/>");
}

function fn_add() {
    go_url("<c:url value='/order/ship/ShipRegistManageRegist.do'/>");
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
    $("#ShipPersonName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#ShipPerson").val("");
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
            $("#ShipPerson").val(o.item.value);
            $("#ShipPersonName").val(o.item.label);

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
														<li>출하 관리</li>
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
                        <input type="hidden" id="popupOrgId" name="popupOrgId" />
                        <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                        <input type="hidden" id="popupCustomerCode" name="popupCustomerCode" />
                        <input type="hidden" id="popupWarehousingFrom" name="popupWarehousingFrom" />
                        <input type="hidden" id="popupWarehousingTo" name="popupWarehousingTo" />
												<input type="hidden" id="OrgId" name="OrgId" value="${searchVO.ORGID }" />
                        <input type="hidden" id="ComPanyId" name="ComPanyId" value="${searchVO.COMPANYID }" />
                        <input type="hidden" id="rowIndexVal" name="rowIndexVal" />
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
																						    <!-- <a id="btnChk5" class="btn_popup" href="#" onclick="javascript:btnSel1();"> 수주현황 </a> -->
																						    <a id="btnChk6" class="btn_popup" href="#" onclick="javascript:btnSel2();"> 완성품 재고현황 </a>
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
																		<th class="required_text">출하번호</th>
																		<td>
																		    <input type="text" id="ShipNo" name="ShipNo" class="input_center" style="width: 97%;" value="${searchVO.SHIPNO }" readonly/>
																		</td>
																		<th class="required_text">출하일자</th>
																		<td>
																		    <input type="text" id="ShipDate" name="ShipDate" class="input_validation input_center" style="width: 97%;" maxlength="10" />
																		</td>
                                    <th class="required_text">거래처</th>
                                    <td>
                                        <input type="text" id="CustomerName" name=CustomerName class="input_validation input_center" style="width: 97%;" />
                                        <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                    </td>
																</tr>
                                <tr style="height: 34px;">
                                    <th class="required_text">담당자</th>
                                    <td>
                                        <input type="text" id="ShipPersonName" name="ShipPersonName" class="input_validation input_center" style="width: 97%;" />
                                        <input type="hidden" id="ShipPerson" name="ShipPerson" />
                                    </td>
                                    <th class="required_text">매출구분</th>
                                    <td>
                                        <select id="ShipGubun" name="ShipGubun" class="input_center " style="width: 97%;">
                                            <c:forEach var="item" items="${labelBox.findByShipGubun}" varStatus="status">
                                                <c:choose>
                                                    <c:when test="${item.VALUE==searchVO.SHIPGUBUN}">
                                                        <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <option value="${item.VALUE}">${item.LABEL}</option>
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:forEach>
                                        </select>
                                    </td>
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
                                </tr>
                                <tr style="height: 34px;">
																		<th class="required_text">비고</th>
																		<td colspan="5"><input type="text" id="ReMarks" name=ReMarks class=" input_left" style="width: 99%;" /></td>
																</tr>
																</table>
														</div>
												</form>
										</fieldset>
								</div>
								<!-- //검색 필드 박스 끝 -->
								<div style="width: 100%;">
                    <div id="gridArea" style="width:  100%; padding-bottom: 5px; float: left;"></div>
                </div>
            </div>
						<!-- //content 끝 -->
						<div id="gridPopup1Area" style="width: 1540px; padding-top: 0px; float: left;"></div>
            <div id="gridPopup2Area" style="width: 1510px; padding-top: 0px; float: left;"></div>
				</div>
				<!-- //container 끝 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>