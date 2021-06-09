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
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    // 제품선택 팝업창 추가
    setValues_Popup();
    setExtGrid_Popup();

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
    gridnms["app"] = "dist";

    calender($('#InspDate'));

    $('#InspsDate').keyup(function (event) {
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

    var Inspno = $('#InspNo').val();
    if (Inspno != "") {
        fn_search();
    } else {
        $("#InspDate").val(getToDay("${searchVO.TODAY}") + "");

        // 2016.10.04. 관리자 권한 외 사용자 로그인시 담당자에 이름 표기
        var groupid = "${searchVO.groupId}";
        switch (groupid) {
        case "ROLE_ADMIN":
            // 관리자 권한일 때 그냥 놔둠
            break;
        default:
            // 관리자 외 권한일 때 사용자명 표기
            $('#KrName').val("${searchVO.KRNAME}");
            $('#PersonId').val("${searchVO.EMPLOYEENUMBER}");
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

    gridnms["grid.1"] = "MatReceiptInspDetail";
    gridnms["grid.13"] = "checkLov"; // 검사값
    gridnms["grid.14"] = "checkYnLov"; // 판정

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.detail"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.detail"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.13"] = gridnms["app"] + ".model." + gridnms["grid.13"];
    gridnms["model.14"] = gridnms["app"] + ".model." + gridnms["grid.14"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.13"] = gridnms["app"] + ".store." + gridnms["grid.13"];
    gridnms["store.14"] = gridnms["app"] + ".store." + gridnms["grid.14"];

    gridnms["models.detail"].push(gridnms["model.1"]);
    gridnms["models.detail"].push(gridnms["model.13"]);
    gridnms["models.detail"].push(gridnms["model.14"]);

    gridnms["stores.detail"].push(gridnms["store.1"]);
    gridnms["stores.detail"].push(gridnms["store.13"]);
    gridnms["stores.detail"].push(gridnms["store.14"]);

    fields["model.1"] = [{
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'INSPECTIONPLANNO',
        }, {
            type: 'string',
            name: 'INSPECTIONSEQ',
        }, {
            type: 'string',
            name: 'CHECKSEQ',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'CHECKYN',
        }, {
            type: 'string',
            name: 'CHECKYNNAME',
        }, {
            type: 'string',
            name: 'CHECKBIG',
        }, {
            type: 'string',
            name: 'CHECKBIGNAME',
        }, {
            type: 'string',
            name: 'CHECKMIDDLE',
        }, {
            type: 'string',
            name: 'CHECKMIDDLENAME',
        }, {
            type: 'string',
            name: 'CHECKSMALL',
        }, {
            type: 'string',
            name: 'CHECKSMALLNAME',
        }, {
            type: 'string',
            name: 'CHECKUOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'STANDARDVALUE',
        }, {
            type: 'string',
            name: 'MAXVALUE',
        }, {
            type: 'string',
            name: 'MINVALUE',
        }, {
            type: 'string',
            name: 'CHECKRESULT1',
        }, {
            type: 'string',
            name: 'CHECKRESULT2',
        }, {
            type: 'string',
            name: 'CHECKRESULT3',
        }, {
            type: 'string',
            name: 'CHECKRESULT4',
        }, {
            type: 'string',
            name: 'CHECKRESULT5',
        }, {
            type: 'string',
            name: 'PERSONID',
        }, {
            type: 'string',
            name: 'KRNAME',
        }, ];

    fields["model.13"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.14"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["columns.1"] = [
        // Display Columns
        {
            dataIndex: 'INSPECTIONSEQ',
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
                meta.style = "background-color:rgb(234, 234, 234);";
                return value;
            },
        }, {
            dataIndex: 'CHECKSMALLNAME',
            text: '검사항목',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234);";
                return value;
            },
        }, {
            dataIndex: 'UOMNAME',
            text: '검사단위',
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
                return value;
            },
        }, {
            dataIndex: 'STANDARDVALUE',
            text: '검사기준',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234);";
                return value;
            },
        }, {
            dataIndex: 'MINVALUE',
            text: '허용치(하한)',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234);";
                return value;
            },
        }, {
            dataIndex: 'MAXVALUE',
            text: '허용치(상한)',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234);";
                return value;
            },
        }, {
            dataIndex: 'CHECKRESULT1',
            text: 'X1',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            enableFocusableContainer: false,
            tdCls: 'x1',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.13"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: true,
                allowBlank: true,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.keyCode === 13 || e.keyCode === 9) {

                            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                            var max = model.data.MAXVALUE;
                            var min = model.data.MINVALUE;
                            var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                            var checkqty = model.data.CHECKQTY * 1; // 시료수
                            var value = field.getValue(); // X1
                            var qty_check = false; // 시료수 체크
                            var input_check = false; // 입력 / 미입력 체크
                            var msg = "",
                            result_check = false;

                            // 검사 값
                            const X1 = field.getValue(),
                            X2 = model.data.CHECKRESULT2,
                            X3 = model.data.CHECKRESULT3,
                            X4 = model.data.CHECKRESULT4,
                            X5 = model.data.CHECKRESULT5;

                            // 1. 시료수 범위 체크
                            switch (checkqty) {
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                                msg = "입력이 가능합니다.";
                                qty_check = true;
                                break;
                            default:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                                break;
                            }

                            // 2. 입력 가능 / 불가 체크
                            if (qty_check == true) {
                                // 2-1. 입력되어있는지 유무 확인
                                // 입력되어있을 경우에만 판정이 변경되도록 변경
                                if (value.length > 0) {
                                    input_check = true;
                                } else {
                                    input_check = false;
                                }

                                // 입력이 되어있으면
                                if (input_check == true) {

                                    // 리스트 생성 함수 호출
                                    var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                    if (standardvalue === "") {
                                        if (value == "OK" || value == "NG") {}
                                        else {
                                            extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                            field.setValue();
                                            return false;
                                        }
                                    } else {
                                        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                        if (!regexp.test(value)) {
                                            // 숫자가 아닌 값을 입력시
                                            extAlert("입력하신 값이 숫자가 아닙니다!");
                                            field.setValue();
                                            return false;
                                        } else {}
                                    }

                                    // 판정결과
                                    result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                    //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                    if (result_check == true) {
                                        model.set('CHECKYNNAME', 'OK');
                                        model.set('CHECKYN', 'OK');
                                    } else {
                                        model.set('CHECKYNNAME', 'NG');
                                        model.set('CHECKYN', 'NG');
                                    }

                                    fn_check_result();

                                    return true;
                                } else {
                                    // 미입력시 메시지 안띄우고 그냥 넘어감
                                    return true;
                                }
                            } else {
                                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                                extAlert(msg);
                                field.setValue();
                                return false;
                            }
                        }
                        if (e.keyCode === 38) {
                            // 위
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                        if (e.keyCode === 40) {
                            // 아래
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var max = model.data.MAXVALUE;
                        var min = model.data.MINVALUE;
                        var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                        var checkqty = model.data.CHECKQTY * 1; // 시료수
                        var value = field.getValue(); // X1
                        var qty_check = false; // 시료수 체크
                        var input_check = false; // 입력 / 미입력 체크
                        var msg = "",
                        result_check = false;

                        // 검사 값
                        const X1 = field.getValue(),
                        X2 = model.data.CHECKRESULT2,
                        X3 = model.data.CHECKRESULT3,
                        X4 = model.data.CHECKRESULT4,
                        X5 = model.data.CHECKRESULT5;

                        // 1. 시료수 범위 체크
                        switch (checkqty) {
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                        case 5:
                            msg = "입력이 가능합니다.";
                            qty_check = true;
                            break;
                        default:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                            break;
                        }

                        // 2. 입력 가능 / 불가 체크
                        if (qty_check == true) {
                            // 2-1. 입력되어있는지 유무 확인
                            // 입력되어있을 경우에만 판정이 변경되도록 변경
                            if (value.length > 0) {
                                input_check = true;
                            } else {
                                input_check = false;
                            }

                            // 입력이 되어있으면
                            if (input_check == true) {

                                // 리스트 생성 함수 호출
                                var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                if (standardvalue === "") {
                                    if (value == "OK" || value == "NG") {}
                                    else {
                                        extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                        field.setValue();
                                        return false;
                                    }
                                } else {
                                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                    if (!regexp.test(value)) {
                                        // 숫자가 아닌 값을 입력시
                                        extAlert("입력하신 값이 숫자가 아닙니다!");
                                        field.setValue();
                                        return false;
                                    } else {}
                                }

                                // 판정결과
                                result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                if (result_check == true) {
                                    model.set('CHECKYNNAME', 'OK');
                                    model.set('CHECKYN', 'OK');
                                } else {
                                    model.set('CHECKYNNAME', 'NG');
                                    model.set('CHECKYN', 'NG');
                                }

                                fn_check_result();

                                return true;
                            } else {
                                // 미입력시 메시지 안띄우고 그냥 넘어감
                                return true;
                            }
                        } else {
                            // 시료수량 미등록 또는 범위 초과시 메시지 발생
                            extAlert(msg);
                            field.setValue();
                            return false;
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
                    width: 180, // 150,
                    getInnerTpl: function () {
                        return '<div>'
                         + '<table>'
                         + '<tr>'
                         + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(250, 227, 125);";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                var max = record.data.MAXVALUE;
                var min = record.data.MINVALUE;
                var checkqty = record.data.CHECKQTY * 1; // 시료수
                var qty_check = false;

                // 1. 시료수 범위 체크
                switch (checkqty) {
                case 1:
                case 2:
                case 3:
                case 4:
                case 5:
                    qty_check = true;
                    break;
                default:
                    qty_check = false;
                    break;
                }

                if (qty_check == false) {
                    meta.style = "background-color:rgb(234,234,234);";
                    meta.style += " border-color: #5B9BD5;";
                    meta.style += " border-left-style: solid;";
                    meta.style += " border-left-width: 1px;";
                } else {
                    if (value == "NG" || value == "OK") {
                        if (value == "NG") {
                            setcolor('x1');
                            return value;
                        } else {
                            setcolor(clearInterval());
                            meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                            meta.style += " border-color: #5B9BD5;";
                            meta.style += " border-left-style: solid;";
                            meta.style += " border-left-width: 1px;";
                            return value;
                        }
                    } else {
                        var num = value * 1;

                        if (min > num) {
                            setcolor('x1');
                            return value;
                        } else {
                            if (num > max) {
                                setcolor('x1');
                                return value;
                            } else {
                                setcolor(clearInterval());
                                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                                meta.style += " border-color: #5B9BD5;";
                                meta.style += " border-left-style: solid;";
                                meta.style += " border-left-width: 1px;";
                                return value;
                            }
                        }
                    }
                }
            },
        }, {
            dataIndex: 'CHECKRESULT2',
            text: 'X2',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            enableFocusableContainer: false,
            tdCls: 'x2',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.13"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: true,
                allowBlank: true,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.keyCode === 13 || e.keyCode === 9) {
                            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                            var max = model.data.MAXVALUE;
                            var min = model.data.MINVALUE;
                            var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                            var checkqty = model.data.CHECKQTY * 1; // 시료수
                            var value = field.getValue(); // X2
                            var qty_check = false; // 시료수 체크
                            var input_check = false; // 입력 / 미입력 체크
                            var msg = "",
                            result_check = false;

                            // 검사 값
                            const X1 = model.data.CHECKRESULT1,
                            X2 = field.getValue(),
                            X3 = model.data.CHECKRESULT3,
                            X4 = model.data.CHECKRESULT4,
                            X5 = model.data.CHECKRESULT5;

                            // 1. 시료수 범위 체크
                            switch (checkqty) {
                            case 1:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                            case 2:
                            case 3:
                            case 4:
                            case 5:
                                msg = "입력이 가능합니다.";
                                qty_check = true;
                                break;
                            default:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                                break;
                            }

                            // 2. 입력 가능 / 불가 체크
                            if (qty_check == true) {
                                // 2-1. 입력되어있는지 유무 확인
                                // 입력되어있을 경우에만 판정이 변경되도록 변경
                                if (value.length > 0) {
                                    input_check = true;
                                } else {
                                    input_check = false;
                                }

                                // 입력이 되어있으면
                                if (input_check == true) {

                                    // 리스트 생성 함수 호출
                                    var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                    if (standardvalue === "") {
                                        if (value == "OK" || value == "NG") {}
                                        else {
                                            extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                            field.setValue();
                                            return false;
                                        }
                                    } else {
                                        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                        if (!regexp.test(value)) {
                                            // 숫자가 아닌 값을 입력시
                                            extAlert("입력하신 값이 숫자가 아닙니다!");
                                            field.setValue();
                                            return false;
                                        } else {}
                                    }

                                    // 판정결과
                                    result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                    //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                    if (result_check == true) {
                                        model.set('CHECKYNNAME', 'OK');
                                        model.set('CHECKYN', 'OK');
                                    } else {
                                        model.set('CHECKYNNAME', 'NG');
                                        model.set('CHECKYN', 'NG');
                                    }

                                    fn_check_result();

                                    return true;
                                } else {
                                    // 미입력시 메시지 안띄우고 그냥 넘어감
                                    return true;
                                }
                            } else {
                                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                                extAlert(msg);
                                field.setValue();
                                return false;
                            }
                        }
                        if (e.keyCode === 38) {
                            // 위
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                        if (e.keyCode === 40) {
                            // 아래
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var max = model.data.MAXVALUE;
                        var min = model.data.MINVALUE;
                        var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                        var checkqty = model.data.CHECKQTY * 1; // 시료수
                        var value = field.getValue(); // X2
                        var qty_check = false; // 시료수 체크
                        var input_check = false; // 입력 / 미입력 체크
                        var msg = "",
                        result_check = false;

                        // 검사 값
                        const X1 = model.data.CHECKRESULT1,
                        X2 = field.getValue(),
                        X3 = model.data.CHECKRESULT3,
                        X4 = model.data.CHECKRESULT4,
                        X5 = model.data.CHECKRESULT5;

                        // 1. 시료수 범위 체크
                        switch (checkqty) {
                        case 1:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                        case 2:
                        case 3:
                        case 4:
                        case 5:
                            msg = "입력이 가능합니다.";
                            qty_check = true;
                            break;
                        default:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                            break;
                        }

                        // 2. 입력 가능 / 불가 체크
                        if (qty_check == true) {
                            // 2-1. 입력되어있는지 유무 확인
                            // 입력되어있을 경우에만 판정이 변경되도록 변경
                            if (value.length > 0) {
                                input_check = true;
                            } else {
                                input_check = false;
                            }

                            // 입력이 되어있으면
                            if (input_check == true) {

                                // 리스트 생성 함수 호출
                                var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                if (standardvalue === "") {
                                    if (value == "OK" || value == "NG") {}
                                    else {
                                        extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                        field.setValue();
                                        return false;
                                    }
                                } else {
                                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                    if (!regexp.test(value)) {
                                        // 숫자가 아닌 값을 입력시
                                        extAlert("입력하신 값이 숫자가 아닙니다!");
                                        field.setValue();
                                        return false;
                                    } else {}
                                }

                                // 판정결과
                                result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                if (result_check == true) {
                                    model.set('CHECKYNNAME', 'OK');
                                    model.set('CHECKYN', 'OK');
                                } else {
                                    model.set('CHECKYNNAME', 'NG');
                                    model.set('CHECKYN', 'NG');
                                }

                                fn_check_result();

                                return true;
                            } else {
                                // 미입력시 메시지 안띄우고 그냥 넘어감
                                return true;
                            }
                        } else {
                            // 시료수량 미등록 또는 범위 초과시 메시지 발생
                            extAlert(msg);
                            field.setValue();
                            return false;
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
                    width: 180, // 150,
                    getInnerTpl: function () {
                        return '<div>'
                         + '<table>'
                         + '<tr>'
                         + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(250, 227, 125);";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                var max = record.data.MAXVALUE;
                var min = record.data.MINVALUE;
                var checkqty = record.data.CHECKQTY * 1; // 시료수
                var qty_check = false;

                // 1. 시료수 범위 체크
                switch (checkqty) {
                case 1:
                    qty_check = false;
                    break;
                case 2:
                case 3:
                case 4:
                case 5:
                    qty_check = true;
                    break;
                default:
                    qty_check = false;
                    break;
                }

                if (qty_check == false) {
                    meta.style = "background-color:rgb(234,234,234);";
                    meta.style += " border-color: #5B9BD5;";
                    meta.style += " border-left-style: solid;";
                    meta.style += " border-left-width: 1px;";
                } else {
                    if (value == "NG" || value == "OK") {
                        if (value == "NG") {
                            setcolor('x2');
                            return value;
                        } else {
                            setcolor(clearInterval());
                            meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                            meta.style += " border-color: #5B9BD5;";
                            meta.style += " border-left-style: solid;";
                            meta.style += " border-left-width: 1px;";
                            return value;
                        }
                    } else {
                        var num = value * 1;

                        if (min > num) {
                            setcolor('x2');
                            return value;
                        } else {
                            if (num > max) {
                                setcolor('x2');
                                return value;
                            } else {
                                setcolor(clearInterval());
                                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                                meta.style += " border-color: #5B9BD5;";
                                meta.style += " border-left-style: solid;";
                                meta.style += " border-left-width: 1px;";
                                return value;
                            }
                        }
                    }
                }
            },
        }, {
            dataIndex: 'CHECKRESULT3',
            text: 'X3',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            enableFocusableContainer: false,
            tdCls: 'x3',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.13"],
                valueField: "VALUE",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: true,
                allowBlank: true,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.keyCode === 13 || e.keyCode === 9) {
                            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                            var max = model.data.MAXVALUE;
                            var min = model.data.MINVALUE;
                            var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                            var checkqty = model.data.CHECKQTY * 1; // 시료수
                            var value = field.getValue(); // X3
                            var qty_check = false; // 시료수 체크
                            var input_check = false; // 입력 / 미입력 체크
                            var msg = "",
                            result_check = false;

                            // 검사 값
                            const X1 = model.data.CHECKRESULT1,
                            X2 = model.data.CHECKRESULT2,
                            X3 = field.getValue(),
                            X4 = model.data.CHECKRESULT4,
                            X5 = model.data.CHECKRESULT5;

                            // 1. 시료수 범위 체크
                            switch (checkqty) {
                            case 1:
                            case 2:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                            case 3:
                            case 4:
                            case 5:
                                msg = "입력이 가능합니다.";
                                qty_check = true;
                                break;
                            default:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                                break;
                            }

                            // 2. 입력 가능 / 불가 체크
                            if (qty_check == true) {
                                // 2-1. 입력되어있는지 유무 확인
                                // 입력되어있을 경우에만 판정이 변경되도록 변경
                                if (value.length > 0) {
                                    input_check = true;
                                } else {
                                    input_check = false;
                                }

                                // 입력이 되어있으면
                                if (input_check == true) {

                                    // 리스트 생성 함수 호출
                                    var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                    if (standardvalue === "") {
                                        if (value == "OK" || value == "NG") {}
                                        else {
                                            extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                            field.setValue();
                                            return false;
                                        }
                                    } else {
                                        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                        if (!regexp.test(value)) {
                                            // 숫자가 아닌 값을 입력시
                                            extAlert("입력하신 값이 숫자가 아닙니다!");
                                            field.setValue();
                                            return false;
                                        } else {}
                                    }

                                    // 판정결과
                                    result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                    //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                    if (result_check == true) {
                                        model.set('CHECKYNNAME', 'OK');
                                        model.set('CHECKYN', 'OK');
                                    } else {
                                        model.set('CHECKYNNAME', 'NG');
                                        model.set('CHECKYN', 'NG');
                                    }

                                    fn_check_result();

                                    return true;
                                } else {
                                    // 미입력시 메시지 안띄우고 그냥 넘어감
                                    return true;
                                }
                            } else {
                                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                                extAlert(msg);
                                field.setValue();
                                return false;
                            }
                        }
                        if (e.keyCode === 38) {
                            // 위
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                        if (e.keyCode === 40) {
                            // 아래
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var max = model.data.MAXVALUE;
                        var min = model.data.MINVALUE;
                        var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                        var checkqty = model.data.CHECKQTY * 1; // 시료수
                        var value = field.getValue(); // X3
                        var qty_check = false; // 시료수 체크
                        var input_check = false; // 입력 / 미입력 체크
                        var msg = "",
                        result_check = false;

                        // 검사 값
                        const X1 = model.data.CHECKRESULT1,
                        X2 = model.data.CHECKRESULT2,
                        X3 = field.getValue(),
                        X4 = model.data.CHECKRESULT4,
                        X5 = model.data.CHECKRESULT5;

                        // 1. 시료수 범위 체크
                        switch (checkqty) {
                        case 1:
                        case 2:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                        case 3:
                        case 4:
                        case 5:
                            msg = "입력이 가능합니다.";
                            qty_check = true;
                            break;
                        default:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                            break;
                        }

                        // 2. 입력 가능 / 불가 체크
                        if (qty_check == true) {
                            // 2-1. 입력되어있는지 유무 확인
                            // 입력되어있을 경우에만 판정이 변경되도록 변경
                            if (value.length > 0) {
                                input_check = true;
                            } else {
                                input_check = false;
                            }

                            // 입력이 되어있으면
                            if (input_check == true) {

                                // 리스트 생성 함수 호출
                                var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                if (standardvalue === "") {
                                    if (value == "OK" || value == "NG") {}
                                    else {
                                        extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                        field.setValue();
                                        return false;
                                    }
                                } else {
                                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                    if (!regexp.test(value)) {
                                        // 숫자가 아닌 값을 입력시
                                        extAlert("입력하신 값이 숫자가 아닙니다!");
                                        field.setValue();
                                        return false;
                                    } else {}
                                }

                                // 판정결과
                                result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                if (result_check == true) {
                                    model.set('CHECKYNNAME', 'OK');
                                    model.set('CHECKYN', 'OK');
                                } else {
                                    model.set('CHECKYNNAME', 'NG');
                                    model.set('CHECKYN', 'NG');
                                }

                                fn_check_result();

                                return true;
                            } else {
                                // 미입력시 메시지 안띄우고 그냥 넘어감
                                return true;
                            }
                        } else {
                            // 시료수량 미등록 또는 범위 초과시 메시지 발생
                            extAlert(msg);
                            field.setValue();
                            return false;
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
                    width: 180, // 150,
                    getInnerTpl: function () {
                        return '<div>'
                         + '<table>'
                         + '<tr>'
                         + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(250, 227, 125);";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                var max = record.data.MAXVALUE;
                var min = record.data.MINVALUE;
                var checkqty = record.data.CHECKQTY * 1; // 시료수
                var qty_check = false;

                // 1. 시료수 범위 체크
                switch (checkqty) {
                case 1:
                case 2:
                    qty_check = false;
                    break;
                case 3:
                case 4:
                case 5:
                    qty_check = true;
                    break;
                default:
                    qty_check = false;
                    break;
                }

                if (qty_check == false) {
                    meta.style = "background-color:rgb(234,234,234);";
                    meta.style += " border-color: #5B9BD5;";
                    meta.style += " border-left-style: solid;";
                    meta.style += " border-left-width: 1px;";
                } else {
                    if (value == "NG" || value == "OK") {
                        if (value == "NG") {
                            setcolor('x3');
                            return value;
                        } else {
                            setcolor(clearInterval());
                            meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                            meta.style += " border-color: #5B9BD5;";
                            meta.style += " border-left-style: solid;";
                            meta.style += " border-left-width: 1px;";
                            return value;
                        }
                    } else {
                        var num = value * 1;

                        if (min > num) {
                            setcolor('x3');
                            return value;
                        } else {
                            if (num > max) {
                                setcolor('x3');
                                return value;
                            } else {
                                setcolor(clearInterval());
                                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                                meta.style += " border-color: #5B9BD5;";
                                meta.style += " border-left-style: solid;";
                                meta.style += " border-left-width: 1px;";
                                return value;
                            }
                        }
                    }
                }
            },
        }, {
            dataIndex: 'CHECKRESULT4',
            text: 'X4',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            enableFocusableContainer: false,
            tdCls: 'x4',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.13"],
                valueField: "VALUE",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: true,
                allowBlank: true,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.keyCode === 13 || e.keyCode === 9) {
                            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                            var max = model.data.MAXVALUE;
                            var min = model.data.MINVALUE;
                            var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                            var checkqty = model.data.CHECKQTY * 1; // 시료수
                            var value = field.getValue(); // X4
                            var qty_check = false; // 시료수 체크
                            var input_check = false; // 입력 / 미입력 체크
                            var msg = "",
                            result_check = false;

                            // 검사 값
                            const X1 = model.data.CHECKRESULT1,
                            X2 = model.data.CHECKRESULT2,
                            X3 = model.data.CHECKRESULT3,
                            X4 = field.getValue(),
                            X5 = model.data.CHECKRESULT5;

                            // 1. 시료수 범위 체크
                            switch (checkqty) {
                            case 1:
                            case 2:
                            case 3:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                            case 4:
                            case 5:
                                msg = "입력이 가능합니다.";
                                qty_check = true;
                                break;
                            default:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                                break;
                            }

                            // 2. 입력 가능 / 불가 체크
                            if (qty_check == true) {
                                // 2-1. 입력되어있는지 유무 확인
                                // 입력되어있을 경우에만 판정이 변경되도록 변경
                                if (value.length > 0) {
                                    input_check = true;
                                } else {
                                    input_check = false;
                                }

                                // 입력이 되어있으면
                                if (input_check == true) {

                                    // 리스트 생성 함수 호출
                                    var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                    if (standardvalue === "") {
                                        if (value == "OK" || value == "NG") {}
                                        else {
                                            extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                            field.setValue();
                                            return false;
                                        }
                                    } else {
                                        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                        if (!regexp.test(value)) {
                                            // 숫자가 아닌 값을 입력시
                                            extAlert("입력하신 값이 숫자가 아닙니다!");
                                            field.setValue();
                                            return false;
                                        } else {}
                                    }

                                    // 판정결과
                                    result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                    //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                    if (result_check == true) {
                                        model.set('CHECKYNNAME', 'OK');
                                        model.set('CHECKYN', 'OK');
                                    } else {
                                        model.set('CHECKYNNAME', 'NG');
                                        model.set('CHECKYN', 'NG');
                                    }

                                    fn_check_result();

                                    return true;
                                } else {
                                    // 미입력시 메시지 안띄우고 그냥 넘어감
                                    return true;
                                }
                            } else {
                                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                                extAlert(msg);
                                field.setValue();
                                return false;
                            }
                        }
                        if (e.keyCode === 38) {
                            // 위
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                        if (e.keyCode === 40) {
                            // 아래
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var max = model.data.MAXVALUE;
                        var min = model.data.MINVALUE;
                        var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                        var checkqty = model.data.CHECKQTY * 1; // 시료수
                        var value = field.getValue(); // X4
                        var qty_check = false; // 시료수 체크
                        var input_check = false; // 입력 / 미입력 체크
                        var msg = "",
                        result_check = false;

                        // 검사 값
                        const X1 = model.data.CHECKRESULT1,
                        X2 = model.data.CHECKRESULT2,
                        X3 = model.data.CHECKRESULT3,
                        X4 = field.getValue(),
                        X5 = model.data.CHECKRESULT5;

                        // 1. 시료수 범위 체크
                        switch (checkqty) {
                        case 1:
                        case 2:
                        case 3:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                        case 4:
                        case 5:
                            msg = "입력이 가능합니다.";
                            qty_check = true;
                            break;
                        default:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                            break;
                        }

                        // 2. 입력 가능 / 불가 체크
                        if (qty_check == true) {
                            // 2-1. 입력되어있는지 유무 확인
                            // 입력되어있을 경우에만 판정이 변경되도록 변경
                            if (value.length > 0) {
                                input_check = true;
                            } else {
                                input_check = false;
                            }

                            // 입력이 되어있으면
                            if (input_check == true) {

                                // 리스트 생성 함수 호출
                                var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                if (standardvalue === "") {
                                    if (value == "OK" || value == "NG") {}
                                    else {
                                        extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                        field.setValue();
                                        return false;
                                    }
                                } else {
                                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                    if (!regexp.test(value)) {
                                        // 숫자가 아닌 값을 입력시
                                        extAlert("입력하신 값이 숫자가 아닙니다!");
                                        field.setValue();
                                        return false;
                                    } else {}
                                }

                                // 판정결과
                                result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                if (result_check == true) {
                                    model.set('CHECKYNNAME', 'OK');
                                    model.set('CHECKYN', 'OK');
                                } else {
                                    model.set('CHECKYNNAME', 'NG');
                                    model.set('CHECKYN', 'NG');
                                }

                                fn_check_result();

                                return true;
                            } else {
                                // 미입력시 메시지 안띄우고 그냥 넘어감
                                return true;
                            }
                        } else {
                            // 시료수량 미등록 또는 범위 초과시 메시지 발생
                            extAlert(msg);
                            field.setValue();
                            return false;
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
                    width: 180, // 150,
                    getInnerTpl: function () {
                        return '<div>'
                         + '<table>'
                         + '<tr>'
                         + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(250, 227, 125);";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                var max = record.data.MAXVALUE;
                var min = record.data.MINVALUE;
                var checkqty = record.data.CHECKQTY * 1; // 시료수
                var qty_check = false;

                // 1. 시료수 범위 체크
                switch (checkqty) {
                case 1:
                case 2:
                case 3:
                    qty_check = false;
                    break;
                case 4:
                case 5:
                    qty_check = true;
                    break;
                default:
                    qty_check = false;
                    break;
                }

                if (qty_check == false) {
                    meta.style = "background-color:rgb(234,234,234);";
                    meta.style += " border-color: #5B9BD5;";
                    meta.style += " border-left-style: solid;";
                    meta.style += " border-left-width: 1px;";
                } else {
                    if (value == "NG" || value == "OK") {
                        if (value == "NG") {
                            setcolor('x4');
                            return value;
                        } else {
                            setcolor(clearInterval());
                            meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                            meta.style += " border-color: #5B9BD5;";
                            meta.style += " border-left-style: solid;";
                            meta.style += " border-left-width: 1px;";
                            return value;
                        }
                    } else {
                        var num = value * 1;

                        if (min > num) {
                            setcolor('x4');
                            return value;
                        } else {
                            if (num > max) {
                                setcolor('x4');
                                return value;
                            } else {
                                setcolor(clearInterval());
                                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                                meta.style += " border-color: #5B9BD5;";
                                meta.style += " border-left-style: solid;";
                                meta.style += " border-left-width: 1px;";
                                return value;
                            }
                        }
                    }
                }
            },
        }, {
            dataIndex: 'CHECKRESULT5',
            text: 'X5',
            xtype: 'gridcolumn',
            width: 95,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            enableFocusableContainer: false,
            tdCls: 'x5',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.13"],
                valueField: "VALUE",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: true,
                allowBlank: true,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.keyCode === 13 || e.keyCode === 9) {
                            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                            var max = model.data.MAXVALUE;
                            var min = model.data.MINVALUE;
                            var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                            var checkqty = model.data.CHECKQTY * 1; // 시료수
                            var value = field.getValue(); // X5
                            var qty_check = false; // 시료수 체크
                            var input_check = false; // 입력 / 미입력 체크
                            var msg = "",
                            result_check = false;

                            // 검사 값
                            const X1 = model.data.CHECKRESULT1,
                            X2 = model.data.CHECKRESULT2,
                            X3 = model.data.CHECKRESULT3,
                            X4 = model.data.CHECKRESULT4,
                            X5 = field.getValue();

                            // 1. 시료수 범위 체크
                            switch (checkqty) {
                            case 1:
                            case 2:
                            case 3:
                            case 4:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                            case 5:
                                msg = "입력이 가능합니다.";
                                qty_check = true;
                                break;
                            default:
                                msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                                qty_check = false;
                                break;
                            }

                            // 2. 입력 가능 / 불가 체크
                            if (qty_check == true) {
                                // 2-1. 입력되어있는지 유무 확인
                                // 입력되어있을 경우에만 판정이 변경되도록 변경
                                if (value.length > 0) {
                                    input_check = true;
                                } else {
                                    input_check = false;
                                }

                                // 입력이 되어있으면
                                if (input_check == true) {

                                    // 리스트 생성 함수 호출
                                    var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                    if (standardvalue === "") {
                                        if (value == "OK" || value == "NG") {}
                                        else {
                                            extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                            field.setValue();
                                            return false;
                                        }
                                    } else {
                                        var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                        if (!regexp.test(value)) {
                                            // 숫자가 아닌 값을 입력시
                                            extAlert("입력하신 값이 숫자가 아닙니다!");
                                            field.setValue();
                                            return false;
                                        } else {}
                                    }

                                    // 판정결과
                                    result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                    //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                    if (result_check == true) {
                                        model.set('CHECKYNNAME', 'OK');
                                        model.set('CHECKYN', 'OK');
                                    } else {
                                        model.set('CHECKYNNAME', 'NG');
                                        model.set('CHECKYN', 'NG');
                                    }

                                    fn_check_result();

                                    return true;
                                } else {
                                    // 미입력시 메시지 안띄우고 그냥 넘어감
                                    return true;
                                }
                            } else {
                                // 시료수량 미등록 또는 범위 초과시 메시지 발생
                                extAlert(msg);
                                field.setValue();
                                return false;
                            }
                        }
                        if (e.keyCode === 38) {
                            // 위
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                        if (e.keyCode === 40) {
                            // 아래
                            var selModel = Ext.getCmp(gridnms["views.detail"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().row;
                            colIdx = selModel.getCurrentPosition().column;

                            fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.detail"], rowIdx, colIdx);
                        }
                    },
                    blur: function (field, e, eOpts) {

                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
                        var max = model.data.MAXVALUE;
                        var min = model.data.MINVALUE;
                        var standardvalue = model.data.STANDARDVALUE; // 검사기준값
                        var checkqty = model.data.CHECKQTY * 1; // 시료수
                        var value = field.getValue(); // X5
                        var qty_check = false; // 시료수 체크
                        var input_check = false; // 입력 / 미입력 체크
                        var msg = "",
                        result_check = false;

                        // 검사 값
                        const X1 = model.data.CHECKRESULT1,
                        X2 = model.data.CHECKRESULT2,
                        X3 = model.data.CHECKRESULT3,
                        X4 = model.data.CHECKRESULT4,
                        X5 = field.getValue();

                        // 1. 시료수 범위 체크
                        switch (checkqty) {
                        case 1:
                        case 2:
                        case 3:
                        case 4:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                        case 5:
                            msg = "입력이 가능합니다.";
                            qty_check = true;
                            break;
                        default:
                            msg = "검사수량이 할당되지 않아 입력하실 수 없습니다.\n다시 확인해주십시오.";
                            qty_check = false;
                            break;
                        }

                        // 2. 입력 가능 / 불가 체크
                        if (qty_check == true) {
                            // 2-1. 입력되어있는지 유무 확인
                            // 입력되어있을 경우에만 판정이 변경되도록 변경
                            if (value.length > 0) {
                                input_check = true;
                            } else {
                                input_check = false;
                            }

                            // 입력이 되어있으면
                            if (input_check == true) {

                                // 리스트 생성 함수 호출
                                var xList = fn_push_list(X1, X2, X3, X4, X5, checkqty);
                                if (standardvalue === "") {
                                    if (value == "OK" || value == "NG") {}
                                    else {
                                        extAlert("OK/NG 중에 하나를 입력해주십시오!");
                                        field.setValue();
                                        return false;
                                    }
                                } else {
                                    var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                                    if (!regexp.test(value)) {
                                        // 숫자가 아닌 값을 입력시
                                        extAlert("입력하신 값이 숫자가 아닙니다!");
                                        field.setValue();
                                        return false;
                                    } else {}
                                }

                                // 판정결과
                                result_check = fn_defact_check(xList, checkqty, max, min, standardvalue);
                                //                     console.log("판정결과 : " + ((result_check == true) ? "OK" : "NG"));

                                if (result_check == true) {
                                    model.set('CHECKYNNAME', 'OK');
                                    model.set('CHECKYN', 'OK');
                                } else {
                                    model.set('CHECKYNNAME', 'NG');
                                    model.set('CHECKYN', 'NG');
                                }

                                fn_check_result();

                                return true;
                            } else {
                                // 미입력시 메시지 안띄우고 그냥 넘어감
                                return true;
                            }
                        } else {
                            // 시료수량 미등록 또는 범위 초과시 메시지 발생
                            extAlert(msg);
                            field.setValue();
                            return false;
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">&nbsp;값을 입력해주세요.</span>',
                    width: 180, // 150,
                    getInnerTpl: function () {
                        return '<div>'
                         + '<table>'
                         + '<tr>'
                         + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(250, 227, 125);";
                meta.style += " border-color: #5B9BD5;";
                meta.style += " border-left-style: solid;";
                meta.style += " border-left-width: 1px;";
                var max = record.data.MAXVALUE;
                var min = record.data.MINVALUE;
                var checkqty = record.data.CHECKQTY * 1; // 시료수
                var qty_check = false;

                // 1. 시료수 범위 체크
                switch (checkqty) {
                case 1:
                case 2:
                case 3:
                case 4:
                    qty_check = false;
                    break;
                case 5:
                    qty_check = true;
                    break;
                default:
                    qty_check = false;
                    break;
                }

                if (qty_check == false) {
                    meta.style = "background-color:rgb(234,234,234);";
                    meta.style += " border-color: #5B9BD5;";
                    meta.style += " border-left-style: solid;";
                    meta.style += " border-left-width: 1px;";
                } else {
                    if (value == "NG" || value == "OK") {
                        if (value == "NG") {
                            setcolor('x5');
                            return value;
                        } else {
                            setcolor(clearInterval());
                            meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                            meta.style += " border-color: #5B9BD5;";
                            meta.style += " border-left-style: solid;";
                            meta.style += " border-left-width: 1px;";
                            return value;
                        }
                    } else {
                        var num = value * 1;

                        if (min > num) {
                            setcolor('x5');
                            return value;
                        } else {
                            if (num > max) {
                                setcolor('x5');
                                return value;
                            } else {
                                setcolor(clearInterval());
                                meta.style = "color:rgb(0, 0, 255); background-color:rgb(250, 227, 125); ";
                                meta.style += " border-color: #5B9BD5;";
                                meta.style += " border-left-style: solid;";
                                meta.style += " border-left-width: 1px;";
                                return value;
                            }
                        }
                    }
                }
            },
            //             }, {
            //               dataIndex: 'CHECKYNNAME',
            //               text: '판정',
            //               xtype: 'gridcolumn',
            //               width: 80,
            //               hidden: false,
            //               sortable: false,
            //               //         resizable : false,
            //               align: "center",
            //               editor: {
            //                 xtype: 'combobox',
            //                 store: gridnms["store.14"],
            //                 valueField: "LABEL",
            //                 displayField: "LABEL",
            //                 matchFieldWidth: true,
            //                 editable: false,
            //                 queryParam: 'keyword',
            //                 queryMode: 'remote', // 'local',
            //                 allowBlank: true,
            //                 typeAhead: true,
            //                 transform: 'stateSelect',
            //                 forceSelection: false,
            //                 listeners: {
            //                   select: function (value, record, eOpts) {
            //                     var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

            //                     model.set("CHECKYN", record.data.VALUE);
            //                   },
            //                 },
            //                 listConfig: {
            //                   loadingText: '검색 중...',
            //                   emptyText: '<span style="height: 45px; font-size: 28px; font-weight: bold;">&nbsp;데이터가 없습니다. 관리자에게 문의하십시오.</span>',
            //                   width: 200, // 330,
            //                   getInnerTpl: function () {
            //                     return '<div>'
            //                      + '<table>'
            //                      + '<tr>'
            //                      + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
            //                      + '</tr>'
            //                      + '</table>'
            //                      + '</div>';
            //                   }
            //                 },
            //               },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            width: 320,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
            }
        },
        // Hidden Columns
        {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPECTIONPLANNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'INSPECTIONSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKQTY',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKYN',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKYNNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'PERSONID',
            xtype: 'hidden',
        }, {
            dataIndex: 'KRNAME',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/dist/insp/MatReceiptInspRegistD.do' />"
    });
    $.extend(items["api.1"], {
        destroy: "<c:url value='/delete/dist/insp/MatReceiptInspRegistD.do' />"
    });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#inspectionRegist": {
            itemclick: 'onDetailClick'
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
}

var popcount = 0, popupclick = 0;
//   검사항목 list (미검사 입하정보)
function btnSel1(btn) {
	if (global_close_yn == "Y") {
	    extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
	    return false;
	}
	
    var InspNo = $('#InspNo').val();
    var ItemCode = $('#ItemCode').val();
    var InspDate = $('#InspDate').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (InspNo !== "") {
        header.push("검사번호");
        count++;
    }

    if (count > 0) {
        extAlert("[검색 조건 확인]<br/>" + header + "가 이미 등록 되어져 있습니다. 새로 추가 하여 등록 하시거나 기존 데이터 삭제 후 재 등록 하시기 바랍니다.");
        return false;
    }

    if (ItemCode !== "") {
        header.push(ItemCode);
        count++;
    }

    if (count > 0) {
        extAlert("[검색 조건 확인]<br/>" + header + "가 이미 등록 중입니다. 새로 추가 하여 등록 하시거나 기존 데이터 삭제 후 재 등록 하시기 바랍니다.");
        return false;
    }
    // 자재 불러오기 팝업
    var width = 1228; // 가로
    var height = 640; // 500; // 세로
    var title = "검사대기 입하 LIST";

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

    popupclick = 0;
    if (check == true) {
        // 완료 외 상태에서만 팝업 표시하도록 처리
        $('#popupOrgId').val($('#searchOrgId option:selected').val());
        $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
        $('#popupDueFrom').val("");
        $('#popupDueTo').val("");
        $('#popupTransNo').val("");
        $('#popupTransSeq').val("");
        $('#popupCheckBig').val("I");
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
                    defaults: gridVals.defaultField,
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
                    width: 110,
                    listeners: {
                        scope: this,
                        buffer: 50,
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
                    },
                    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
                }, ' ~ ', {
                    xtype: 'datefield',
                    enforceMaxLength: true,
                    maxLength: 10,
                    allowBlank: true,
                    format: 'Y-m-d',
                    altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
                    width: 110,
                    align: 'center',
                    listeners: {
                        scope: this,
                        buffer: 50,
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
                    },
                    renderer: Ext.util.Format.dateRenderer('Y-m-d'),
                },
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
                }, '->', {
                    text: '조회',
                    scope: this,
                    handler: function () {
                        fn_popup_search();
                    }
                },
            ]
        });

        win1.show();

        var sparams1 = {
            ORGID: $('#popupOrgId').val(),
            COMPANYID: $('#popupCompanyId').val(),
            BIGCD: "CMM",
            MIDDLECD: "ITEM_TYPE",
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

    } else {
        extAlert("입고 검사 등록 하실 경우에만 입하정보 불러오기가 가능합니다.");
        return;
    }
}

function fn_popup_search() {
    var sparams = {
        ORGID: $('#popupOrgId').val(),
        COMPANYID: $('#popupCompanyId').val(),
        TRANSFROM: $('#popupDueFrom').val(),
        TRANSTO: $('#popupDueTo').val(),
        TRANSNO: $('#popupTransNo').val(),
        ITEMCODE: $('#popupItemCode').val(),
        ITEMNAME: $('#popupItemName').val(),
        ORDERNAME: $('#popupOrderName').val(),
        MODELNAME: $('#popupModelName').val(),
        ITEMSTANDARD: $('#popupItemStandard').val(),
    };
    extGridSearch(sparams, gridnms["store.4"]);
}

function onDetailClick(dataview, record, item, index, e, eOpts) {
    var standardvalue = record.data.STANDARDVALUE;
    var sparams = {};

    if (standardvalue === "") {
        // 검사기준값이 없으면 OK / NG 표시 될 수 있도록 변경
        sparams = {
            "BIGCD": "APP" + "",
            "MIDDLECD": "유해한 결함 없을 것" + "",
        };
    } else {
        sparams = {
            "BIGCD": "APP" + "",
            "MIDDLECD": "!@#$%" + "", // OK / NG 표시되지 않는 항목은 쓰레기 값을 넣어 조회가 되지 않도록한다.
        };
    }
    extGridSearch(sparams, gridnms["store.13"]);
};

var gridarea;
function setExtGrid() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"],
    });

    Ext.define(gridnms["model.13"], {
        extend: Ext.data.Model,
        fields: fields["model.13"]
    });

    Ext.define(gridnms["model.14"], {
        extend: Ext.data.Model,
        fields: fields["model.14"]
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
                                INSPECTIONPLANNO: "${searchVO.INSPECTIONPLANNO}",
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.13"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.13"],
                        model: gridnms["model.13"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchDummyOKNGLov.do' />",
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.14"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.14"],
                        model: gridnms["model.14"],
                        autoLoad: true,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                BIGCD: 'QM',
                                MIDDLECD: 'CHECK_YN',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            inspectionRegist: '#inspectionRegist',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        onDetailClick: onDetailClick,
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
                height: 524,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'inspectionRegist',
                    trackOver: true,
                    loadMask: true,
                    striptRows: true,
                    forceFit: true,
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('CHECKSMALLNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 100) {
                                        column.width = 100;
                                    }
                                }

                                if (column.dataIndex.indexOf('CHECKSTANDARD') >= 0) {
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
                bufferedRenderer: false,
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            beforeedit: function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var params = {};
                                var editDisableCols = [];

                                var checkqty = data.data.CHECKQTY * 1;

                                switch (checkqty) {
                                case 1:
                                    editDisableCols.push("CHECKRESULT2");
                                    editDisableCols.push("CHECKRESULT3");
                                    editDisableCols.push("CHECKRESULT4");
                                    editDisableCols.push("CHECKRESULT5");
                                    break;
                                case 2:
                                    editDisableCols.push("CHECKRESULT3");
                                    editDisableCols.push("CHECKRESULT4");
                                    editDisableCols.push("CHECKRESULT5");
                                    break;
                                case 3:
                                    editDisableCols.push("CHECKRESULT4");
                                    editDisableCols.push("CHECKRESULT5");
                                    break;
                                case 4:
                                    editDisableCols.push("CHECKRESULT5");
                                    break;
                                default:
                                    break;
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
                                // 컴포넌트를 탐색하면서 field인것만 검
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
                                    // keyup이벤트 처리를 위해 enableKeyEvent를 true로 설정해야만함...
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

    gridnms["models.popup2"] = [];
    gridnms["stores.popup2"] = [];
    gridnms["views.popup2"] = [];
    gridnms["controllers.popup2"] = [];

    gridnms["grid.4"] = "Popup1";
    gridnms["grid.44"] = "Popup2"; // 입고검사 세부 항목 LIST
    gridnms["grid.5"] = "SetBigCodeLov"; // 팝업 조회 대분류
    gridnms["grid.6"] = "SetMiddleCodeLov"; // 팝업 조회 중분류
    gridnms["grid.7"] = "SetSmallCodeLov"; // 팝업 조회 소분류
    gridnms["grid.8"] = "SetItemTypeLov"; // 팝업 조회 유형
    gridnms["grid.21"] = "SetItemTransNo"; // 팝업 조회 입하번호

    gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
    gridnms["views.popup1"].push(gridnms["panel.4"]);

    gridnms["panel.44"] = gridnms["app"] + ".view." + gridnms["grid.44"];
    gridnms["views.popup2"].push(gridnms["panel.44"]);

    gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
    gridnms["controllers.popup1"].push(gridnms["controller.4"]);

    gridnms["controller.44"] = gridnms["app"] + ".controller." + gridnms["grid.44"];
    gridnms["controllers.popup2"].push(gridnms["controller.44"]);

    gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
    gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
    gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
    gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];
    gridnms["model.8"] = gridnms["app"] + ".model." + gridnms["grid.8"];
    gridnms["model.21"] = gridnms["app"] + ".model." + gridnms["grid.21"];

    gridnms["model.44"] = gridnms["app"] + ".model." + gridnms["grid.44"];

    gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
    gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
    gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
    gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];
    gridnms["store.8"] = gridnms["app"] + ".store." + gridnms["grid.8"];
    gridnms["store.21"] = gridnms["app"] + ".store." + gridnms["grid.21"];

    gridnms["store.44"] = gridnms["app"] + ".store." + gridnms["grid.44"];

    gridnms["models.popup1"].push(gridnms["model.4"]);
    gridnms["models.popup1"].push(gridnms["model.5"]);
    gridnms["models.popup1"].push(gridnms["model.6"]);
    gridnms["models.popup1"].push(gridnms["model.7"]);
    gridnms["models.popup1"].push(gridnms["model.8"]);
    gridnms["models.popup1"].push(gridnms["model.21"]);

    gridnms["models.popup2"].push(gridnms["model.44"]);

    gridnms["stores.popup1"].push(gridnms["store.4"]);
    gridnms["stores.popup1"].push(gridnms["store.5"]);
    gridnms["stores.popup1"].push(gridnms["store.6"]);
    gridnms["stores.popup1"].push(gridnms["store.7"]);
    gridnms["stores.popup1"].push(gridnms["store.8"]);
    gridnms["stores.popup1"].push(gridnms["store.21"]);

    gridnms["stores.popup2"].push(gridnms["store.44"]);

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
            name: 'TRANSNO',
        }, {
            type: 'string',
            name: 'TRANSSEQ',
        }, {
            type: 'string',
            name: 'TRANSDATE',
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
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARD',
        }, {
            type: 'string',
            name: 'MATERIALTYPE',
        }, {
            type: 'string',
            name: 'MODEL',
        }, {
            type: 'string',
            name: 'MODELNAME',
        }, {
            type: 'string',
            name: 'CUSTOMERGUBUN',
        }, {
            type: 'string',
            name: 'CUSTOMERGUBUNNAME',
        }, {
            type: 'number',
            name: 'TRANSQTY',
        }, {
            type: 'number',
            name: 'CONFIRMQTY',
        }, {
            type: 'number',
            name: 'CHECKQTY',
        }, ];

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
            name: 'CHECKSEQ',
        }, {
            type: 'string',
            name: 'ITEMCODE',
        }, {
            type: 'string',
            name: 'CHECKBIG',
        }, {
            type: 'string',
            name: 'CHECKBIGNAME',
        }, {
            type: 'string',
            name: 'CHECKMIDDLE',
        }, {
            type: 'string',
            name: 'CHECKMIDDLENAME',
        }, {
            type: 'string',
            name: 'CHECKSMALL',
        }, {
            type: 'string',
            name: 'CHECKSMALLNAME',
        }, {
            type: 'string',
            name: 'CHECKUOM',
        }, {
            type: 'string',
            name: 'CHECKUOMNAME',
        }, {
            type: 'string',
            name: 'STANDARDVALUE',
        }, {
            type: 'string',
            name: 'MINVALUE',
        }, {
            type: 'string',
            name: 'MAXVALUE',
        },
    ];

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

    fields["model.21"] = [{
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
            dataIndex: 'TRANSNO',
            text: '입하번호',
            xtype: 'gridcolumn',
            width: 115,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'TRANSSEQ',
            text: '입하<br/>순번',
            xtype: 'gridcolumn',
            width: 55,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'TRANSDATE',
            text: '입하일',
            xtype: 'datecolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            format: 'Y-m-d',
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 180,
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
            width: 100,
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
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'TRANSQTY',
            text: '입하<br/>수량',
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
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'CONFIRMQTY',
            text: '기검사<br/>수량',
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
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'CHECKQTY',
            text: '검사<br/>수량',
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
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'CUSTOMERLOT',
            text: '업체 LOT',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            menuDisabled: true,
            sortable: false,
            resizable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            width: 70,
            text: '적용',
            style: 'text-align:center',
            align: "center",
            resizable: false,
            widget: {
                xtype: 'button',
                _btnText: "적용",
                defaultBindProperty: null, //important
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    var ItemCodeVal = record.data.ITEMCODE;
                    var OrgIdVal = record.data.ORGID;
                    var CompanyIdVal = record.data.COMPANYID;
                    var params = {
                        ORGID: OrgIdVal,
                        COMPANYID: CompanyIdVal,
                        ITEMCODE: ItemCodeVal,
                    };
                    extGridSearch(params, gridnms["store.44"]);

                    setTimeout(function () {

                        // 전체등록 Pop up 적용 버튼 핸들러
                        var count4 = Ext.getStore(gridnms["store.4"]).count();
                        var checknum = 0,
                        checkqty = 0,
                        checktemp = 0;
                        var qtytemp = [];

                        if (count4 == 0) {
                            console.log("[적용] 입고검사 정보가 없습니다.");
                        } else {
                            var temp_item = null,
                            temp_price = 0,
                            temp_stand = null;

                            $('#TransNo').val(record.data.TRANSNO);
                            $('#TransSeq').val(record.data.TRANSSEQ);
                            $('#TransDate').val(record.data.TRANSDATE);
                            $('#CustomerName').val(record.data.CUSTOMERNAME);
                            $('#CustomerCode').val(record.data.CUSTOMERCODE);
                            $('#ItemCode').val(record.data.ITEMCODE);
                            $('#ItemName').val(record.data.ITEMNAME);
                            $('#OrderName').val(record.data.ORDERNAME);
                            $('#TransQty').val(record.data.TRANSQTY);
                            $('#CheckQty').val(record.data.CHECKQTY);
                            $('#CustomerLot').val(record.data.CUSTOMERLOT);

                            $('#MaterialType').val(record.data.MATERIALTYPE);
                            $('#ItemStandard').val(record.data.ITEMSTANDARD);

                            checktemp++;
                            popcount++;
                            //아래 부분은 검사세부 정보 loop 형태로 변경
                            //전체등록 Pop up 적용 버튼 핸들러
                            var count = Ext.getStore(gridnms["store.1"]).count();
                            var count44 = Ext.getStore(gridnms["store.44"]).count();
                            var checknum = 0,
                            checkqty = 0,
                            checktemp = 0;
                            var qtytemp = [];

                            for (var i = 0; i < count44; i++) {
                                Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(i));
                                var model44 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
                                var chk = true;

                                if (chk) {
                                    checknum++;
                                }
                            }
                            console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

                            if (checknum == 0) {
                                extAlert("해당 품목에 대해서 품질기준 마스터가 등록 되어있지 않습니다. <br/>해당 품목의 품질기준 정보를 다시 확인해주십시오.");
                                return false;
                            }

                            if (count44 == 0) {
                                console.log("[적용] 자재 정보가 없습니다.");
                            } else {
                                for (var j = 0; j < count44; j++) {
                                    Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(j));
                                    var model44 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
                                    var chk = true; //model44.data.CHK;

                                    if (chk) {
                                        var model = Ext.create(gridnms["model.1"]);
                                        //                                         var store = this.getStore(gridnms["store.1"]);
                                        var store = Ext.getStore(gridnms["store.1"]);

                                        // 순번
                                        model.set("INSPECTIONSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                        //model.set("DUEDATE", DueDate );

                                        // 팝업창의 체크된 항목 이동
                                        model.set("CHECKSEQ", model44.data.CHECKSEQ);
                                        model.set("CHECKUOM", model44.data.CHECKUOM);
                                        model.set("UOMNAME", model44.data.CHECKUOMNAME);
                                        model.set("CHECKBIG", model44.data.CHECKBIG);
                                        model.set("CHECKBIGNAME", model44.data.CHECKBIGNAME);
                                        model.set("CHECKMIDDLE", model44.data.CHECKMIDDLE);
                                        model.set("CHECKMIDDLENAME", model44.data.CHECKMIDDLENAME);
                                        model.set("CHECKSMALL", model44.data.CHECKSMALL);
                                        model.set("CHECKSMALLNAME", model44.data.CHECKSMALLNAME);
                                        model.set("STANDARDVALUE", model44.data.STANDARDVALUE);
                                        model.set("MINVALUE", model44.data.MINVALUE);
                                        model.set("MAXVALUE", model44.data.MAXVALUE);
                                        model.set("CHECKQTY", model44.data.CHECKQTY);
                                        model.set("ITEMCODE", model44.data.ITEMCODE);

                                        var qty = model44.data.QTYDETAIL * 1;
                                        if (qty > 0) {
                                            model.set("TRANSQTY", qty);
                                        } else {
                                            model.set("TRANSQTY", 1);
                                        }

                                        // 그리드 적용 방식
                                        store.add(model);

                                        checktemp++;
                                        popcount++;
                                    };
                                }

                                Ext.getCmp(gridnms["panel.1"]).getView().refresh();
                            }

                            if (checktemp > 0) {
                                popcount = 0;
                                win1.close();

                                $("#gridPopup1Area").hide("blind", {
                                    direction: "up"
                                }, "fast");
                                $("#gridPopup2Area").hide("blind", {
                                    direction: "up"
                                }, "fast");
                            }
                            // 여기까지 부분은 검사세부 정보 loop 형태로 변경

                        }

                        if (checktemp > 0) {
                            popcount = 0;
                            win1.close();

                            $("#gridPopup1Area").hide("blind", {
                                direction: "up"
                            }, "fast");
                            $("#gridPopup2Area").hide("blind", {
                                direction: "up"
                            }, "fast");

                        }
                    }, 300);
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText); // _btnText 문구를 위젯컬럼에서 선언해주는 기능
                    }
                }
            }
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
            dataIndex: 'ITEMTYPE',
            xtype: 'hidden',
        }, {
            dataIndex: 'ORDERNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOMNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
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
            dataIndex: 'ITEMCODE',
            text: '품목',
            xtype: 'gridcolumn',
            width: 140,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'CHECKBIGNAME',
            text: '검사구분',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'CHECKMIDDLENAME',
            text: '검사분류',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'CHECKSMALLNAME',
            text: '검사항목',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'CHECKSUOMNAME',
            text: '검사단위',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'CHECKSTANDARD',
            text: '검사내용',
            xtype: 'gridcolumn',
            width: 350,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
        }, {
            dataIndex: 'STANDARDVALUE',
            text: '검사기준',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'MINVALUE',
            text: '허용치(하한)',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'MAXVALUE',
            text: '허용치(상한)',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
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
            dataIndex: 'CHECKSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKBIG',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKMIDDLE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKSMALL',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKUOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKQTY',
            xtype: 'hidden',
        }, ];

    items["api.4"] = {};
    $.extend(items["api.4"], {
        read: "<c:url value='/MatReceiptInspRegistInspPop.do' />"
    });

    items["btns.4"] = [];

    items["btns.ctr.4"] = {};
    $.extend(items["btns.ctr.4"], {
        "#btnPopup1": {
            itemclick: 'onMypopClick'
        }
    });

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

    items["api.44"] = {};
    $.extend(items["api.44"], {
        read: "<c:url value='/MatReceiptInspRegistInspPopCheck.do' />"
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

var gridpopup1;
function setExtGrid_Popup() {

    Ext.define(gridnms["model.4"], {
        extend: Ext.data.Model,
        fields: fields["model.4"],
    });

    Ext.define(gridnms["model.44"], {
        extend: Ext.data.Model,
        fields: fields["model.44"],
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

    Ext.define(gridnms["model.21"], {
        extend: Ext.data.Model,
        fields: fields["model.21"],
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
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
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
                                ITEMCODE: 'Z'
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
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $('#popupOrgId').val(),
                                COMPANYID: $('#popupCompanyId').val(),
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
        control: items["btns.ctr.4"],
        onMypopClick: onMypopClick,
    });

    Ext.define(gridnms["controller.44"], {
        extend: Ext.app.Controller,
        refs: {
            btnPopup2: '#btnPopup2',
        },
        stores: [gridnms["store.44"]],
        control: items["btns.ctr.44"],
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
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'btnPopup2',
                    trackOver: true,
                    loadMask: true,
                },
                dockedItems: items["docked.44"],
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

    Ext.application({
        name: gridnms["app"],
        models: gridnms["models.popup2"],
        stores: gridnms["stores.popup2"],
        views: gridnms["views.popup2"],
        controllers: gridnms["controller.44"],

        launch: function () {
            gridpopup2 = Ext.create(gridnms["views.popup2"], {
                renderTo: 'gridPopup2Area'
            });
        },
    });
}

// 종합판정 Function
function fn_check_result() {
    var count = Ext.getStore(gridnms["store.1"]).count();
    var chk_count = 0;

    for (var i = 0; i < count; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
        var checkyn = model1.data.CHECKYN;

        var result = true;
        var isCheck = false;

        if (checkyn != "OK") {
            chk_count++;
        }
    }

    // 판정 값 중 하나라도 NG가 있을 경우 불합격
    if (chk_count > 0) {
        var checkqty = $("#TransQty").val();
        var passqty = 0;
        var failqty = checkqty;
        $("#CheckYn").val('NG');
        $("#CheckYnName").val('NG');
        $("#CheckQty").val(checkqty);
        $("#PassQty").val(passqty);
        $("#FailQty").val(failqty);
    } else {
        var checkqty = $("#TransQty").val();
        var passqty = checkqty;
        var failqty = 0;
        $("#CheckYn").val('OK');
        $("#CheckYnName").val('OK');
        $("#CheckQty").val(checkqty);
        $("#PassQty").val(passqty);
        $("#FailQty").val(failqty);
    }
}

// 종합판정 Function
function fn_check_result2(flag) {
    // 판정 값 중 하나라도 NG가 있을 경우 불합격

    var check_yn = $("#CheckYnName").val();
    var check_qty = $("#CheckQty").val();
    if (check_yn == "OK") {
        var passqty = check_qty;
        var failqty = 0;
        $("#PassQty").val(passqty);
        $("#FailQty").val(failqty);
        $("#CheckYn").val(check_yn);
    } else {
        var passqty = 0;
        var failqty = check_qty;
        $("#PassQty").val(passqty);
        $("#FailQty").val(failqty);
        $("#CheckYn").val(check_yn);
    }
}

function onMypopClick(dataview, record, item, index, e, eOpts) {
    var params = {
        ORGID: record.data.ORGID,
        COMPANYID: record.data.COMPANYID,
        ITEMCODE: record.data.ITEMCODE,
    };
    extGridSearch(params, gridnms["store.44"]);
}

function fn_push_list(X1, X2, X3, X4, X5, qty) {
    // 리스트 생성
    var list = [];
    switch (qty) {
    case 1:
        list.push(X1);
        break;
    case 2:
        list.push(X1);
        list.push(X2);
        break;
    case 3:
        list.push(X1);
        list.push(X2);
        list.push(X3);
        break;
    case 4:
        list.push(X1);
        list.push(X2);
        list.push(X3);
        list.push(X4);
        break;
    case 5:
        list.push(X1);
        list.push(X2);
        list.push(X3);
        list.push(X4);
        list.push(X5);
        break;
    default:
        break;
    }
    return list;
}

function fn_defact_check(list, num, max, min, svalue) {
    // 합/불 판정
    var result = true,
    isCheck = false,
    count = 0;
    var max_num = max * 1;
    var min_num = min * 1;
    for (var i = 0; i < num; i++) {
        var value = list[i];
        // 입력된 값이 아니면 패스
        if (value.length > 0) {
            if (svalue == "") {
                if (value == "OK") {
                    // 합격
                    isCheck = true;
                } else if (value == "NG") {
                    // 불합격
                    isCheck = false;
                }
            } else {
                var value_num = value * 1;
                var regexp = /^[-]?\d+(?:[.]\d+)?$/;
                if (regexp.test(value)) {
                    // 합격
                    if (min_num > value_num) {
                        isCheck = false;
                    } else {
                        if (value_num > max_num) {
                            isCheck = false;
                        } else {
                            isCheck = true;
                        }
                    }
                } else {
                    // 불합격
                    isCheck = false;
                }
            }

            // 불합격 판정 받았을 경우에만 불합격 처리되도록
            if (isCheck == false) {
                result = false;
            }
            count++;
        } else {
            // 2016.03.14 검사값 입력시 불합격 표시부분 주석 처리
            //             result = true;
        }
    }

    return result;
}

function setcolor(x) {
    // 불합격 판정시 글자 깜빡임 스크립터
    var count = 1;
    if (x == 'x1') {
        setInterval(function () {
            if (count == 1) {
                $('.x1').css("color", "rgb(255,0,0)");

                count = 2
            } else {
                $('.x1').css("color", "rgb(0,0,255)");
                count = 1
            }
        }, 500);
    } else if (x == 'x2') {
        setInterval(function () {
            if (count == 1) {
                $('.x2').css("color", "rgb(255,0,0)");

                count = 2
            } else {
                $('.x2').css("color", "rgb(0,0,255)");
                count = 1
            }
        }, 500);
    } else if (x == 'x3') {
        setInterval(function () {
            if (count == 1) {
                $('.x3').css("color", "rgb(255,0,0)");

                count = 2
            } else {
                $('.x3').css("color", "rgb(0,0,255)");
                count = 1
            }
        }, 500);
    } else if (x == 'x4') {
        setInterval(function () {
            if (count == 1) {
                $('.x4').css("color", "rgb(255,0,0)");

                count = 2
            } else {
                $('.x4').css("color", "rgb(0,0,255)");
                count = 1
            }
        }, 500);
    } else if (x == 'x5') {
        setInterval(function () {
            if (count == 1) {
                $('.x5').css("color", "rgb(255,0,0)");

                count = 2
            } else {
                $('.x5').css("color", "rgb(0,0,255)");
                count = 1
            }
        }, 500);
    } else if (x == 'checkynnm') {
        setInterval(function () {
            if (count == 1) {
                $('.checkynnm').css("color", "rgb(255,0,0)");

                count = 2
            } else {
                $('.checkynnm').css("color", "rgb(0,0,255)");
                count = 1
            }
        }, 500);
    }
}

function fn_save() {
    // 필수 체크
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var InspDate = $('#InspDate').val();
    var InspStatus = $('#InspStatus').val();
    var TransNo = $('#TransNo').val();
    var TransSeq = $('#TransSeq').val();
    var CustomerCode = $('#CustomerCode').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (InspDate === "") {
        header.push("검사일");
        count++;
    }
    if (TransNo === "") {
        header.push("입하번호");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return false;
    }

    // 저장
    var inspno = $('#InspNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = inspno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 입하 등록 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/dist/insp/MatReceiptInspRegistD.do' />";
        url1 = "<c:url value='/insert/dist/insp/MatReceiptInspRegistDGrid.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/dist/insp/MatReceiptInspRegistD.do' />";
        url1 = "<c:url value='/update/dist/insp/MatReceiptInspRegistDGrid.do' />";
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
                        var inspno = data.INSPECTIONPLANNO;

                        if (inspno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();

                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("INSPECTIONPLANNO", inspno);
                                if (model.data.INSPECTIONPLANNO != '') {
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
                                            go_url("<c:url value='/dist/insp/MatReceiptInspRegistD.do?no=' />" + inspno + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('입고검사등록', '입고검사 등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('입고검사 등록 변경 알림', '입고검사 등록을 변경하시겠습니까?', function (btn) {
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
                        var inspno = data.InspNo;

                        if (inspno.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();

                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("INSPECTIONPLANNO", inspno);
                                if (model.data.INSPECTIONPLANNO != '') {
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
                                            go_url("<c:url value='/dist/insp/MatReceiptInspRegistD.do?no=' />" + inspno + "&org=" + orgid + "&company=" + companyid);
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
    var InspNo = $('#InspNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        INSPECTIONPLANNO: InspNo,
    };

    url = "<c:url value='/MatReceiptInspRegistInspNoListLovD.do' />";

    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var inspno = dataList.INSPECTIONPLANNO;
            var inspdate = dataList.INSPECTIONDATE;
            var itemcode = dataList.ITEMCODE;
            var itemname = dataList.ITEMNAME;
            var ordername = dataList.ORDERNAME;
            var transqty = dataList.TRANSQTY;
            var checkqty = dataList.CHECKQTY;
            var passqty = dataList.PASSQTY;
            var failqty = dataList.FAILQTY;
            var checkyn = dataList.CHECKYN;
            var checkynname = dataList.CHECKYNNAME;
            var returnqty = dataList.RETURNQTY;

            var transno = dataList.TRANSNO;
            var transseq = dataList.TRANSSEQ;
            var transdate = dataList.TRANSDATE;
            var tradedate = dataList.TRADEDATE;
            var transdiv = dataList.TRANSDIV;
            var customercode = dataList.CUSTOMERCODE;
            var customername = dataList.CUSTOMERNAME;
            var remarks = dataList.REMARKS;
            var customerlot = dataList.CUSTOMERLOT;

            var itemstandard = dataList.ITEMSTANDARD;
            var materialtype = dataList.MATERIALTYPE;

            var personid = dataList.PERSONID;
            var krname = dataList.KRNAME;

            $("#InspNo").val(inspno);
            $("#InspDate").val(inspdate);
            $("#ItemCode").val(itemcode);
            $("#ItemName").val(itemname);
            $("#OrderName").val(ordername);
            $("#TransQty").val(transqty);
            $("#CheckQty").val(checkqty);
            $("#PassQty").val(passqty);
            $("#FailQty").val(failqty);
            $("#CheckYn").val(checkyn);
            $("#CheckYnName").val(checkynname);
            $("#returnqty").val(returnqty);

            $("#TransNo").val(transno);
            $("#TransSeq").val(transseq);
            $("#TransDate").val(transdate);
            $("#TradeDate").val(tradedate);
            $("#TransDiv").val(transdiv);
            $("#CustomerCode").val(customercode);
            $("#CustomerName").val(customername);
            $("#Remarks").val(remarks);
            $("#CustomerLot").val(customerlot);

            $("#MaterialType").val(materialtype);
            $("#ItemStandard").val(itemstandard);

            $("#PersonId").val(personid);
            $("#KrName").val(krname);

            global_close_yn = fn_monthly_close_filter_data(inspdate, 'MAT');
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

    var inspno = $('#InspNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var returnyn = $('#ReturnYn').val(); // 반품등록 여부
    var returnqty = $('#returnqty').val() * 1; // 반품등록 수량
    var isNew = inspno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (returnqty != 0) {
        extAlert("[반품 등록 여부]<br/> 해당 입고 검사 건에 대해서 공급사 반품 등록 건이 있어서 삭제가 불가능 합니다. 공급사 반품 건 재확인 후 처리 하세요.");
        return false;
    }

    url = "<c:url value='/delete/dist/insp/MatReceiptInspRegistDM.do' />";

    Ext.MessageBox.confirm('삭제 알림', '해당 데이터를 삭제하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var params = [];
            $.ajax({
                url: url,
                type: "post",
                dataType: "json",
                data: $("#master").serialize(),
                success: function (data) {
                    // 정상적으로 생성이 되었으면
                    var result = data.success;
                    var msg = data.msg;
                    extAlert(msg);
                    if (result) {
                        // 삭제 성공
                        go_url("<c:url value='/dist/insp/MatReceiptInspRegist.do' />");
                    } else {
                        // 실패 했을 경우
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
    go_url("<c:url value='/dist/insp/MatReceiptInspRegist.do'/>");
}

function fn_add() {
    go_url("<c:url value='/dist/insp/MatReceiptInspRegistD.do' />");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function fn_emp_all() {
    // 검사자 선택시 상세 내역에 등록하는 Function
    var count1 = Ext.getStore(gridnms["store.1"]).count();

    var personid = $('#PersonId').val();
    var krname = $('#KrName').val();

    if (count1 > 0) {
        for (var i = 0; i < count1; i++) {
            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
            var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

            model1.set('PERSONID', personid);
            model1.set('KRNAME', krname);
        }
    } else {
        extToastView("검사 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
    }
}

function setLovList() {
    // 검사자 Lov
    $("#KrName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#KrName").val("");
            $("#PersonId").val("");
            fn_emp_all();
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
                //          INSPECTORTYPE2: '20', // 생산관리직 추가
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
            $("#PersonId").val(o.item.value);
            $("#KrName").val(o.item.label);
            fn_emp_all();

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
                                        <input type="hidden" id="popupItemCodeD" />
                                        <input type="hidden" id="popupCheckBig" />
                                        <input type="hidden" id="popupTransNo" />
                                        <input type="hidden" id="popupDueFrom" />
								                        <input type="hidden" id="popupDueTo" />
                                        <input type="hidden" id="popupOrgId" name="popupOrgId"  /> 
                                        <input type="hidden" id="popupCompanyId" name="popupCompanyId"  /> 
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
                                        <input type="hidden" id="popupItemType" name="popupItemType" /> 
                                        <input type="hidden" id="returnqty" name="returnqty" />
                                        <fieldset style="width: 100%">
                                                <legend>조건정보 영역</legend>
                                                <form id="master" name="master" action="" method="post">
		                                                <input type="hidden" id="ItemCode" name="ItemCode" />
		                                                <input type="hidden" id="PersonId" name="PersonId" />
                                                        <div>
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
                                                                                            <a id="btnChk1" class="btn_search" href="#" onclick="javascript:btnSel1();"> 입고검사 대기 List </a> 
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
                                                                            <col width="8%">
                                                                            <col width="17%">
                                                                            <col width="8%">
                                                                            <col width="17%">
                                                                            <col width="8%">
                                                                            <col width="17%">
                                                                            <col width="8%">
                                                                            <col width="17%">
                                                                        </colgroup>
                                                                        <tr style="height: 34px;">
                                                                                <th class="required_text">입고검사번호</th>
                                                                                <td><input type="text" id="InspNo" name="InspNo" class="input_center" style="width: 97%;" value="${searchVO.INSPECTIONPLANNO}" readonly /></td>
                                                                                <th class="required_text">검사일</th>
                                                                                <td><input type="text" id="InspDate" name="InspDate" class="input_validation input_center" style="width: 97%;" maxlength="10"  /></td>
                                                                                <th class="required_text">입하번호</th>
                                                                                <td><input type="text" id="TransNo" name="TransNo" class="input_center" style="width: 97%;" readonly />
                                                                                      <input type="hidden" id="TransSeq" name="TransSeq" class="" /></td>
                                                                                <th class="required_text">입하일</th>
                                                                                <td><input type="text" id="TransDate" name="TransDate" class=" input_center" style="width: 97%;" maxlength="10" readonly /></td>
                                                                        </tr>
                                                                        <tr style="height: 34px;">
                                                                                <th class="required_text">품명</th>
                                                                                <td><input type="text" id="ItemName" name="ItemName" class="input_center" style="width: 97%;" readonly/> 
                                                                                </td>
                                                                                <th class="required_text">품번</th>
                                                                                <td><input type="text" id="OrderName" name="OrderName" class="input_center" style="width: 97%;" readonly/> 
                                                                                </td>
                                                                                <th class="required_text">규격</th>
                                                                                <td><input type="text" id="ItemStandard" name="ItemStandard" class="input_center" style="width: 97%;" readonly/> 
                                                                                </td>
                                                                                <th class="required_text">재질</th>
                                                                                <td><input type="text" id="MaterialType" name="MaterialType" class="input_center" style="width: 97%;" readonly/> 
                                                                                </td>
                                                                        </tr>
                                                                        <tr style="height: 34px;">
                                                                                <th class="required_text">공급사</th>
                                                                                <td><input type="text" id="CustomerName" name="CustomerName" class="input_center" style="width: 97%;" readonly/> 
                                                                                      <input type="hidden" id="CustomerCode" name="CustomerCode" class="" />
                                                                                </td>
                                                                                <th class="required_text">입하수량</th>
                                                                                <td><input type="text" id="TransQty" name="TransQty" class="input_center" style="width: 97%;" readonly/> 
                                                                                </td>
                                                                                <th class="required_text">검사수량</th>
                                                                                <td>
                                                                                    <input type="text" id="CheckQty" name="CheckQty" class="input_center " style="width: 97%;" readonly /> 
                                                                                </td>
                                                                                <th class="required_text">합격수량</th>
                                                                                <td><input type="text" id="PassQty" name="PassQty" class="input_center" style="width: 97%;" readonly/> 
                                                                                </td>
                                                                        </tr>
                                                                        <tr style="height: 34px;">
                                                                                <th class="required_text">불합격수량</th>
                                                                                <td><input type="text" id="FailQty" name="FailQty" class="input_validation input_center" style="width: 97%;"/> 
                                                                                </td>
                                                                                <th class="required_text">결과</th>
                                                                                <td><input type="text" id="CheckYnName" name="CheckYnName" class="input_validation input_center" style="width: 97%; margin-top: 6px;" onkeydown="javascript:fn_check_result2();" onkeyup="javascript:fn_check_result2();" /> 
                                                                                      <input type="hidden" id="CheckYn" name="CheckYn" class="" />
                                                                                </td>
                                                                                <th class="required_text">업체 LOT</th>
                                                                                <td><input type="text" id="CustomerLot" name="CustomerLot" class="input_center" style="width: 97%; margin-top: 6px;" readonly/>
                                                                                </td>
																				                                        <th class="required_text">검사자</th>
																				                                        <td>
																				                                            <input type="text" id="KrName" name="KrName" class="input_center" style="width: 97%; "/>
																				                                        </td>
                                                                        </tr>
                                                                        <tr style="height: 34px;">
                                                                                <th class="required_text">비고</th>
                                                                                <td colspan="7"><textarea id="Remarks" name="Remarks" class="input_left" style="width: 99%;" ></textarea></td>
                                                                        </tr>
                                                                </table>
                                                        </div>
                                                </form>
                                        </fieldset>
                                </div>
                                <!-- //검색 필드 박스 끝 -->
                                <div id="gridDetailArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                        </div>
                        <!-- //content 끝 -->
                </div>
                <!-- //container 끝 -->
                <div id="gridPopup1Area" style="width: 1220px; padding-top: 0px; float: left;"></div>
                <div id="gridPopup2Area" style="width: 1200px; padding-top: 0px; float: left;"></div>

                <!-- footer 시작 -->
                <div id="footer">
                        <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
                </div>
                <!-- //footer 끝 -->
        </div>
        <!-- //전체 레이어 끝 -->
</body>
</html>