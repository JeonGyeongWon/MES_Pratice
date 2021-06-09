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

    setReadOnly();
    setLovList();
});

var global_close_yn = "N";
function setInitial() {
    searchFlag = "LIST";
    gridnms["app"] = "order";

    $('#searchFrom').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            }
        }
    });
    $("#searchFrom").val(getToDay("${searchVO.dateFrom}") + "");
    global_close_yn = fn_monthly_close_filter_data($("#searchFrom").val(), 'OM');

    fn_option_change_a1('CMM', 'ITEM_TYPE', 'A', 'searchItemType');

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        fn_option_change_a1('CMM', 'ITEM_TYPE', 'A', 'searchItemType');
    });
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {

    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "ProdInvAdjustRegist";
    gridnms["grid.11"] = "gubunLov";

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
            type: 'string',
            name: 'RN',
        }, {
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
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
            name: 'ITEMNAME',
        }, {
            type: 'string',
            name: 'ORDERNAME',
        }, {
            type: 'string',
            name: 'UOM',
        }, {
            type: 'string',
            name: 'UOMNAME',
        }, {
            type: 'string',
            name: 'ITEMTYPE',
        }, {
            type: 'string',
            name: 'ITEMTYPENAME',
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
            type: 'number',
            name: 'TRXSTOCK',
        }, {
            type: 'string',
            name: 'REALQTY',
        }, {
            type: 'string',
            name: 'CHECKGUBUN',
        }, {
            type: 'string',
            name: 'CHECKGUBUNNAME',
        }, {
            type: 'date',
            name: 'CHECKDATE',
            dateFormat: 'Y-m-d',
        }
    ];

    fields["model.11"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        },
    ];

    fields["columns.1"] = [{
            dataIndex: 'RN',
            text: '순번',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            editor: {
                xtype: 'checkbox',
                cls: 'x-grid-checkheader-editor'
            }
        }, {
            dataIndex: 'BIGNAME',
            text: '대분류',
            xtype: 'gridcolumn',
            width: 100,
            hidden: true,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'MIDDLENAME',
            text: '중분류',
            xtype: 'gridcolumn',
            width: 100,
            hidden: true,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'SMALLNAME',
            text: '소분류',
            xtype: 'gridcolumn',
            width: 100,
            hidden: true,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 180,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: 'textfield',
                editable: false,
                allowBlank: true,
                selectOnFocus: true,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'MODELNAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
                allowBlank: true,
                selectOnFocus: true,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
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
            editor: {
                xtype: 'textfield',
                editable: false,
                allowBlank: true,
                selectOnFocus: true,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'ORDERNAME',
            text: '품번',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
                allowBlank: true,
                selectOnFocus: true,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'ITEMTYPENAME',
            text: '유형',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'UOMNAME',
            text: '단위',
            xtype: 'gridcolumn',
            width: 65,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return value;
            },
        }, {
            dataIndex: 'TRXSTOCK',
            text: '시스템재고',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            editor: {
                xtype: 'textfield',
                editable: false,
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return Ext.util.Format.number(value, '0,000.##');
            },
        }, {
            dataIndex: 'REALQTY',
            text: '실재고(입력)',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: true,
            resizable: true,
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
                maskRe: /[0-9.]/,
                selectOnFocus: true,
                listeners: {
                    change: function (field, newValue, oldValue, eOpts) {
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        var qty = field.getValue() * 1;
                        var po = store.data.TRXSTOCK * 1;

                        var checkqty = qty - po;
                        store.set("CHECKQTY", checkqty);
                        if (qty === "") {
                            store.set("CHK", false);
                        } else {
                            store.set("CHK", true);
                        }
                    },
                },
            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255); ";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'CHECKQTY',
            text: '차이수량',
            xtype: 'gridcolumn',
            width: 80,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(234, 234, 234); ";
                return Ext.util.Format.number(value, '0,000.##');
            },
        }, {
            dataIndex: 'CHECKGUBUNNAME',
            text: '조정사유',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: true,
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
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("CHECKGUBUN", record.data.VALUE);
                    },
                    blur: function (field, e, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        if (field.getValue() == "") {
                            model.set("CHECKGUBUN", "");
                        }
                    },

                },

            },
            renderer: function (value, meta, record) {
                meta.style = "background-color:rgb(253, 218, 255); ";
                return value;
            },
        }, {
            dataIndex: 'CHECKDATE',
            text: '조정일',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            format: 'Y-m-d',
            //             editor: {
            //                 xtype: 'datefield',
            //                 enforceMaxLength: true,
            //                 maxLength: 10,
            //                 allowBlank: true,
            //                 format: 'Y-m-d',
            //                 listeners: {
            //                     change: function (field, newValue, oldValue, eOpts) {
            //                         var count10 = Ext.getStore(gridnms["store.1"]).count();

            //                         if (field.rawValue.length == 10) {
            //                             for (i = 0; i < count10; i++) {
            //                                 Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
            //                                 var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

            //                                 var realqty = model1.data.REALQTY;

            //                                 if (realqty != "") { // 일자 수정시 실재고 data있는 column만 추가입력 and 개별수정 가능
            //                                     model1.set("CHECKDATE", newValue);
            //                                 }
            //                             }
            //                         }
            //                     },
            //                 },
            //             },
            renderer: function (value, meta, record) {
                //                 meta.style = "background-color:rgb(253, 218, 255); ";
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            // width: 120,
            flex: 1,
            hidden: false,
            sortable: true,
            resizable: true,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
            }
        }, {
            dataIndex: 'ORGID',
            xtype: 'hidden',
        }, {
            dataIndex: 'COMPANYID',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CHECKGUBUN',
            xtype: 'hidden',
        }
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/order/prod/ProdInvAdjustRegist.do' />"
    });

    items["btns.1"] = [];
    items["btns.1"].push({
        xtype: "button",
        text: "전체선택/해제",
        itemId: "btnChkd1"
    });
    items["btns.1"].push({
        xtype: "button",
        text: "재고조정 처리",
        itemId: "btnUsed1"
    });

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnChkd1": {
            click: 'btnChk1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnUsed1": {
            click: 'btnUse1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnList": {
            itemclick: 'onMasterClick'
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

var check_flag = false;
function btnChk1Click() {
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var checkTrue = 0,
    checkFalse = 0;

    if (check_flag) {
        check_flag = false;
    } else {
        check_flag = true;
    }

    for (i = 0; i < count1; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        if (check_flag) {
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

function btnUse1Click(o, e) {
    if (global_close_yn == "Y") {
        extAlert("[마감 알림]<br/>등록된 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
        return false;
    }

    var grid_count = Ext.getStore(gridnms["store.1"]).count();
    var check_count = 0;
    var update_count = 0;
    if (grid_count == 0) {
        extAlert("[재고조정]<br/>재고조정 데이터가 선택되지 않았습니다.");
        return false;
    }

    Ext.MessageBox.confirm('재고조정 ', '재고조정 처리를 하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var count = 0;
            var header = [];
            for (var i = 0; i < grid_count; i++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
                var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
                var chk = model1.data.CHK;
                var realqty = model1.data.REALQTY;
                var checkgubunname = model1.data.CHECKGUBUNNAME;
                var checkdate = Ext.util.Format.date(model1.data.CHECKDATE, 'Y-m-d');

                if (chk) {
                    check_count++;
                    if (realqty == undefined || realqty == "") {
                        header.push("실재고");
                        count++;
                    }
                    if (checkgubunname == undefined || checkgubunname == "") {
                        header.push("조정사유");
                        count++;
                    }
                    if (checkdate == undefined || checkdate == "") {
                        header.push("조정일");
                        count++;
                    }

                }
            }
            if (count > 0) {
                extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력/선택해주세요.");
                return;
            }
            if (check_count == 0) {
                extAlert("목록을 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
                return;
            }

            for (var j = 0; j < grid_count; j++) {
                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(j));
                var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
                var chk = model1.data.CHK;
                var qty = model1.data.CHECKQTY;

                if (chk) {
                    if (qty != null && qty != 0) {
                        var model = Ext.create(gridnms["model.1"]);
                        var store = Ext.getStore(gridnms["store.1"]);

                        var url = "";

                        url = "<c:url value='/pkg/order/prod/ProdInvAdjustRegist.do' />";

                        var record = model1.data;
                        var checkdate = Ext.util.Format.date(record.CHECKDATE, 'Y-m-d');
                        record.CHECKDATE = checkdate;
                        var params = [];
                        $.ajax({
                            url: url,
                            type: "post",
                            dataType: "json",
                            async: false,
                            data: record,
                            success: function (data) {

                                var checkno = data.CHECKNO + "";
                                if (checkno.length > 0) {
                                    var success = data.success;
                                    if (!success) {
                                        extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                                        return;
                                    } else {
                                        update_count++;
                                    }
                                }

                                if (check_count == update_count) {
                                    msg = "재고조정 처리를 하였습니다.";
                                    extAlert(msg);
                                    fn_search();
                                }
                            },
                            error: ajaxError
                        });
                    }

                }
            }
        } else {
            Ext.Msg.alert('재고조정', '재고조정 처리가 취소되었습니다.');
            return;
        }
    });
}

function onMasterClick(dataview, record, item, index, e, eOpts) {
    var orgid = record.data.ORGID;
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
            var login = "<%=loginVO.getId()%>";
            var loginS = "<%=loginVO.getAuthCode()%>";

            if (loginS === "ROLE_ADMIN") {
                login = "";
            }
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.1"],
                        model: gridnms["model.1"],
                        autoLoad: false,
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
                                ITEMTYPE: $("#searchItemType").val(),
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
                                BIGCD: 'MAT',
                                MIDDLECD: 'CHECK_GUBUN'
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

        btnChk1Click: btnChk1Click,
        btnUse1Click: btnUse1Click,
        onMasterClick: onMasterClick,
    });

    Ext.define(gridnms["panel.1"], {
        extend: Ext.panel.Panel,
        alias: 'widget.' + gridnms["panel.1"],
        layout: 'fit',
        header: false,
        items: [{
                xtype: 'gridpanel',
                selType: 'rowmodel',
                itemId: gridnms["panel.1"],
                id: gridnms["panel.1"],
                store: gridnms["store.1"],
                height: 688,
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
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('MODELNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 180) {
                                        column.width = 180;
                                    }
                                }

                                if (column.dataIndex.indexOf('ORDERNAME') >= 0) {
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

function fn_search() {
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
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return;
    }

    check_flag = false;
    var searchModelName = $("#searchModelName").val();

    var sparams = {
        ORGID: $('#searchOrgId').val(),
        COMPANYID: $('#searchCompanyId').val(),
        FROMDATE: $("#searchFrom").val(),
        ITEMNAME: $("#searchItemName").val(),
        ORDERNAME: $("#searchOrderName").val(),
        ITEMTYPE: $("#searchItemType").val(),
        MODELNAME: searchModelName,
    };
    extGridSearch(sparams, gridnms["store.1"]);
    global_close_yn = fn_monthly_close_filter_data($("#searchFrom").val(), 'OM');
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function setLovList() {
    //
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
												<table class="tbl_type_view" border="0">
														<colgroup>
                            <col width="120px">
                            <col>
                            <col width="120px">
                            <col>
                            <col width="120px">
                            <col>
                            <col width="120px">
                            <col>
                            <col width="120px">
                            <col>
														</colgroup>
														<form id="master" name="master" action="" method="post">
														<tr style="height: 34px;">
                                    <td colspan="2">
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
                                    <td colspan="2">
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
                                    <td colspan="6">
																				<div class="buttons" style="float: right; margin-top: 3px;">
																						<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
																				</div>
																</td>
														</tr>
														<tr style="height: 34px;">
															    <th class="required_text">기준월</th>
	                                <td>
	                                    <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 150px;" maxlength="7" />
	                                </td>
																	<th class="required_text">품번</th>
																	<td><input type="text" id="searchOrderName" name="searchOrderName" class="input_center" style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" /></td>
																	<th class="required_text">품명</th>
																	<td><input type="text" id="searchItemName" name="searchItemName" class="input_center" style="width: 97%;" onKeyUp="javascript:this.value=this.value.toUpperCase();" /></td>
	                                <th class="required_text">기종</th>
	                                <td >
	                                    <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
	                                </td>
																	<th class="required_text">유형</th>
                                <td>
                                    <select id="searchItemType" name="searchItemType" class="input_left " style="width: 97%;">
                                    </select>
                                </td>
														</tr>
														</form>
												</table>
										</fieldset>
								</div>

								<!-- //검색 필드 박스 끝 -->
								<div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
						</div>
						<!-- //content 끝 -->
				</div>
				<!-- //container 끝 -->
				<!-- footer 시작 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
				<!-- //footer 끝 -->
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>