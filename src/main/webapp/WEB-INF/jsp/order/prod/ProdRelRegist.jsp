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

    $("#gridPopup1Area").hide("blind", {
        direction: "up"
    }, "fast");

    setReadOnly();
    setLovList();

    setLastInitial();
});

var global_close_yn = "";
function setInitial() {
    // 최초 상태 설정
    gridnms["app"] = "order";

    calender($('#ReleaseDate'));

    $('#ReleaseDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });
}

function setLastInitial() {
    var relno = $('#RelNo').val();
    if (relno != "") {
        fn_search();
        $("#ReleaseDate").val(getToDay("${searchVO.ReleaseDate}") + "");
        $("#UseDiv").attr('disabled', true).addClass('ui-state-disabled');
    } else {
        $("#ReleaseDate").val(getToDay("${searchVO.TODAY}") + "");
        $("#UseDiv").attr('disabled', false).removeClass('ui-state-disabled');
    }

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        fn_option_change_r('MAT', 'USE_DIV', 'UseDiv');
    });

    $('#popupOrgId').val($('#searchOrgId option:selected').val());
    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());

    // 2016.10.04. 관리자 권한 외 사용자 로그인시 담당자에 이름 표기
    var groupid = "${searchVO.groupId}";
    switch (groupid) {
    case "ROLE_ADMIN":
        // 관리자 권한일 때 그냥 놔둠
        break;
    default:
        // 관리자 외 권한일 때 사용자명 표기
        $('#ReleasePersonName').val("${searchVO.krname}");
        $('#ReleasePerson').val("${searchVO.employeenumber}");
        break;
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

    gridnms["grid.1"] = "ProdRelDetail";
    gridnms["grid.2"] = "warehousingLov";

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
            name: 'RELEASENO',
        }, {
            type: 'number',
            name: 'RELEASESEQ',
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
            name: 'RELEASEQTY',
        }, {
            type: 'string',
            name: 'REMARKS',
        }, {
            type: 'string',
            name: 'WAREHOUSING',
        }, {
            type: 'string',
            name: 'WAREHOUSINGNAME',
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
            dataIndex: 'RELEASESEQ',
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
                var releaseno = record.data.RELEASENO;
                if (releaseno !== "") {
                    meta.style = "background-color:rgb(234, 234, 234)";
                }
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
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234)";
                return value;
            },
        }, {
            dataIndex: 'UOMNAME',
            text: '단위',
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
            //      }, {
            //        dataIndex: 'WAREHOUSINGNAME',
            //        text: '창고',
            //        xtype: 'gridcolumn',
            //        width: 120,
            //        hidden: false,
            //        sortable: false,
            //        align: "center",
            //        editor: {
            //          xtype: 'combobox',
            //          store: gridnms["store.2"],
            //          valueField: "LABEL",
            //          displayField: "LABEL",
            //          matchFieldWidth: true,
            //          editable: false,
            //          queryParam: 'keyword',
            //          queryMode: 'remote', // 'local',
            //          allowBlank: true,
            //          typeAhead: true,
            //          transform: 'stateSelect',
            //          forceSelection: true,
            //          listeners: {
            //            select: function (value, record, eOpts) {
            //              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

            //              model.set("WAREHOUSING", record.get("VALUE"));
            //            },
            //            specialkey: function (value, e, eOpts) {
            //              if (e.keyCode == e.TAB) {
            //                // Tab 키를 눌렀을 때 작동
            //                var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

            //                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
            //                var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

            //                var warehousing_from = value.getValue();

            //                if (warehousing_from == "") {
            //                  extAlert("창고를 입력하지 않으셨습니다.<br/>다시 확인해주십시오.");
            //                  value.setValue(null);
            //                  store.set("WAREHOUSING", null);
            //                }
            //              }
            //            },
            //          },
            //          listConfig: {
            //            loadingText: '검색 중...',
            //            emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
            //            width: 330,
            //            getInnerTpl: function () {
            //              return '<div>'
            //               + '<table>'
            //               + '<tr>'
            //               + '<td style="height: 25px; font-size: 13px;">{LABEL}</td>'
            //               + '</tr>'
            //               + '</table>'
            //               + '</div>';
            //            }
            //          },
            //        },
            //        renderer: function (value, meta, record) {
            //          meta.style = "background-color:rgb(253, 218, 255)";
            //          return value;
            //        },
        }, {
            dataIndex: 'RELEASEQTY',
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
                maskRe: /[-?0-9]/,
                selectOnFocus: true,
            },
            renderer: function (value, meta, record) {
                var releaseno = record.data.RELEASENO;
                if (releaseno !== "") {
                    meta.style = "background-color:rgb(234, 234, 234); ";
                } else {
                    meta.style = "background-color:rgb(253, 218, 255); ";
                }
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            width: 360,
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
            dataIndex: 'RELEASENO',
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
            dataIndex: 'WAREHOUSING',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/order/prod/ProdRelListDetail.do' />"
    });
    $.extend(items["api.1"], {
        destroy: "<c:url value='/delete/dist/mat/MatRelListDetail.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "제품불러오기",
        itemId: "btnSel1"
    });
    //    items["btns.1"].push({
    //      xtype: "button",
    //      text: "삭제",
    //      itemId: "btnDel1"
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
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var PorNo = $('#RelNo').val();
    var ReleaseDate = $('#ReleaseDate').val();
    var ReleasePerson = $('#ReleasePerson').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (ReleaseDate === "") {
        header.push("처리일자");
        count++;
    }
    //    if (ReleasePerson === "") {
    //      header.push("처리담당자");
    //      count++;
    //    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    // 제품 불러오기 팝업
    var width = 1610; // 가로
    var height = 640; // 세로
    var title = "제품 불러오기 Popup";

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
                            if (chk) {
                                checknum++;
                            }
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
                                    model.set("RELEASESEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

                                    // 팝업창의 체크된 항목 이동
                                    model.set("ITEMCODE", model5.data.ITEMCODE);
                                    model.set("ORDERNAME", model5.data.ORDERNAME);
                                    model.set("DRAWINGNO", model5.data.DRAWINGNO);
                                    model.set("ITEMNAME", model5.data.ITEMNAME);
                                    model.set("CARTYPE", model5.data.CARTYPE);
                                    model.set("CARTYPENAME", model5.data.CARTYPENAME);
                                    model.set("MATERIALTYPE", model5.data.MATERIALTYPE);
                                    model.set("UOM", model5.data.UOM);
                                    model.set("UOMNAME", model5.data.UOMNAME);
                                    model.set("ITEMSTANDARDDETAIL", model5.data.ITEMSTANDARDDETAIL);

                                    var qty = model5.data.BOXCNT * 1;
                                    if (qty > 0) {
                                        model.set("RELEASEQTY", qty);
                                    } else {
                                        model.set("RELEASEQTY", 1);
                                    }

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

    } else {
        extAlert("입출고 요청하실 때만 제품 불러오기가 가능합니다.");
        return;
    }
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
    };
    extGridSearch(params, gridnms["store.5"]);
}

function btnDel1() {
    extGridDel(gridnms["store.1"], gridnms["panel.1"]);
}

var gridarea;
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
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                RELEASENO: $('#RelNo').val(),
                                USEDIV: $('#UseDivTemp').val(),
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
                                BIGCD: 'CMM',
                                MIDDLECD: 'WAREHOUSING',
                                GUBUN: 'WAREHOUSING',
                            },
                            reader: gridVals.reader,
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
                height: 626,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                viewConfig: {
                    itemId: 'btnList',
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 150) {
                                        column.width = 150;
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
                bufferedRenderer: false,
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;

                                var editDisableCols = [];
                                var releaseno = data.data.RELEASENO;

                                if (releaseno !== "") {
                                    editDisableCols.push("RELEASESEQ");
                                    editDisableCols.push("RELEASEQTY");
                                    //                      editDisableCols.push("REMARKS");
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
            name: 'MATERIALTYPE',
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
            style: 'text-align:center',
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
            width: 110,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
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
            dataIndex: 'UNITPRICEA',
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
            width: 50,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
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
                //                 bufferedRenderer: false,
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
    var ReleaseDate = $('#ReleaseDate').val();
    var ReleasePerson = $('#ReleasePerson').val();
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (ReleaseDate === "") {
        header.push("처리일자");
        count++;
    }
    if (ReleasePerson === "") {
        header.push("처리담당자");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return false;
    }

    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 등록/변경을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    // 저장
    var relno = $('#RelNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var isNew = relno.length === 0;
    var url = "",
    url1 = "",
    msgGubun = 0;

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (gridcount == 0) {
        extAlert("[상세 미등록]<br/> 제품입출고 상세 데이터가 등록되지 않았습니다.");
        return false;
    }

    if (isNew) {
        url = "<c:url value='/insert/dist/mat/MatRelMaster.do' />";
        url1 = "<c:url value='/insert/dist/mat/MatRelDetail.do' />";
        msgGubun = 1;
    } else {
        url = "<c:url value='/update/dist/mat/MatRelMaster.do' />";
        url1 = "<c:url value='/update/dist/mat/MatRelDetail.do' />";
        msgGubun = 2;
    }

    if (msgGubun == 1) {
        Ext.MessageBox.confirm('제품입출고 알림', '저장 하시겠습니까?', function (btn) {
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
                        var pono = data.RELNO;

                        if (pono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("RELEASENO", pono);
                                if (model.data.RELEASENO != '') {
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
                                            msg = "제품입출고 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/order/prod/ProdRelManage.do?relno=' />" + pono + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('제품입출고', '제품입출고 등록이 취소되었습니다.');
                return;
            }
        });
    } else if (msgGubun == 2) {

        Ext.MessageBox.confirm('제품입출고 변경 알림', '제품입출고 내역을 변경하시겠습니까?', function (btn) {
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
                        var pono = data.RelNo;

                        if (pono.length > 0) {
                            var recount = Ext.getStore(gridnms["store.1"]).count();
                            for (var i = 0; i < recount; i++) {
                                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                                model.set("ORGID", orgid);
                                model.set("COMPANYID", companyid);
                                model.set("RELEASENO", pono);
                                if (model.data.RELEASENO != '') {
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
                                            msg = "제품입출고 내역이 변경되었습니다.";
                                        }

                                        extAlert(msg);
                                        dataSuccess = 1;

                                        if (dataSuccess > 0) {
                                            go_url("<c:url value='/order/prod/ProdRelManage.do?relno=' />" + pono + "&org=" + orgid + "&company=" + companyid);
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
                Ext.Msg.alert('제품입출고 변경', '변경이 취소되었습니다.');
                return;
            }
        });
    }
}

function fn_search() {
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var relno = $('#RelNo').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        RELEASENO: relno,
    };

    url = "<c:url value='/searchRelNoListLov.do' />";
    $.ajax({
        url: url,
        type: "post",
        dataType: "json",
        data: sparams,
        success: function (data) {
            var dataList = data.data[0];

            var relno = dataList.RELEASENO;
            var releasedate = dataList.RELEASEDATE;
            var releaseperson = dataList.RELEASEPERSON;
            var releasepersonname = dataList.RELEASEPERSONNAME;
            var usediv = dataList.USEDIV;
            var remarks = dataList.REMARKS;

            $("#RelNo").val(relno);
            $("#ReleaseDate").val(releasedate);
            $("#ReleasePerson").val(releaseperson);
            $("#ReleasePersonName").val(releasepersonname);
            $("#UseDiv").val(usediv);
            $("#UseDivTemp").val(usediv);
            $("#Remarks").val(remarks);

            global_close_yn = fn_monthly_close_filter_data(releasedate, 'OM');
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

    var relno = $('#RelNo').val();
    var OrgId = $('#searchOrgId option:selected').val();
    var CompanyId = $('#searchCompanyId option:selected').val();
    var url = "",
    msgGubun = 0;
    var header = [],
    count = 0;
    var dataSuccess = 0;
    var result = null;

    if (relno === "") {
        header.push("제품입출고번호");
        count++;
    }

    if (count > 0) {
        extAlert("등록이 완료된 건에 대해서만 삭제가 가능합니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    var gridcount = Ext.getStore(gridnms["store.1"]).count();
    if (!gridcount == 0) {
        extAlert("[상세 데이터]<br/> 제품입출고 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
        return false;
    }

    url = "<c:url value='/delete/order/prod/ProdRelManage.do' />";

    Ext.MessageBox.confirm('제품입출고 삭제 알림', '제품입출고 데이터를 삭제하시겠습니까?', function (btn) {
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
            Ext.Msg.alert('제품입출고 삭제', '제품입출고 삭제가 취소되었습니다.');
            return;
        }
    });
}

function fn_list() {
    go_url("<c:url value='/order/prod/ProdRelList.do'/>");
}

function fn_add() {
    go_url("<c:url value='/order/prod/ProdRelManage.do' />");
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
    // 담당자 Lov
    $("#ReleasePersonName").bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            //             $("#ReleasePersonName").val("");
            $("#ReleasePerson").val("");
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
            $("#ReleasePerson").val(o.item.value);
            $("#ReleasePersonName").val(o.item.label);

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
                    <input type="hidden" id="popupOrgId" name="popupOrgId"  /> 
                    <input type="hidden" id="popupCompanyId" name="popupCompanyId" /> 
                    <input type="hidden" id="popupGroupCode" name="popupGroupCode" value="A" /> 
                    <input type="hidden" id="popupItemName" name="popupItemName" />
                    <input type="hidden" id="popupOrderName" name="popupOrderName" />
                    <input type="hidden" id="usedivtemp1" name="usedivtemp1" /> 
                    <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                          <input type="hidden" id="UseDivTemp" name="UseDivTemp" value="${searchVO.USEDIV}" /> 
                          <input type="hidden" id="ReleasePerson" name="ReleasePerson"  />
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
	                                        <!-- <a id="btnChk2" class="btn_delete" href="#" onclick="javascript:fn_delete();"> 삭제 </a> --> 
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
	                                <th class="required_text">제품입출고번호</th>
	                                <td><input type="text" id="RelNo" name="RelNo" class="input_center" style="width: 97%;" value="${searchVO.RELEASENO}" readonly /></td>
	                                <th class="required_text">처리일자</th>
	                                <td><input type="text" id="ReleaseDate" name="ReleaseDate" class="input_validation input_center" style="width: 97%;" maxlength="10" /></td>
                                  <th class="required_text">처리담당자</th>
                                  <td>
                                      <input type="text" id="ReleasePersonName" name="ReleasePersonName" class="input_validation input_center" style="width: 97%;" />
                                  </td>
	                                <th class="required_text">구분</th>
	                                <td><select id="UseDiv" name="UseDiv" class=" input_validation input_left" style="width: 97%;" >
	                                        <c:forEach var="item" items="${labelBox.findByUseDiv}" varStatus="status">
	                                            <c:choose>
	                                                <c:when test="${item.VALUE==searchVO.USEDIV}">
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
	                                <th class="required_text">처리사유</th>
	                                <td colspan="7">
	                                  <textarea id="Remarks" name="Remarks" class="input_left" style="width: 99%;" ></textarea>
	                                </td>
	                            </tr>
	                        </table>
                        </form>
                    </fieldset>
                </div>
                <!-- //검색 필드 박스 끝 -->

                <div style="width: 100%;">
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
            </div>
            <!-- //content 끝 -->
        </div>
        <!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 1601px; padding-top: 0px; float: left;"></div>

        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>