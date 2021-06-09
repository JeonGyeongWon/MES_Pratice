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
    gridnms["app"] = "scm";

    // 입고일자
    calender($('#searchPoFrom, #searchPoTo'));

    $('#searchPoFrom, #searchPoTo').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $("#searchPoFrom").val(getToDay("${searchVO.dateFrom}") + "");
    $("#searchPoTo").val(getToDay("${searchVO.dateTo}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
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

    gridnms["grid.1"] = "ScmOutTransMaster";

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
            name: 'EXTRANSQTY2',
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
        }, {
            type: 'string',
            name: 'OUTPOPERSON',
        }, ];

    fields["columns.1"] = [{
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
            width: 235,
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
            width: 60,
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
            dataIndex: 'DUEDATE',
            text: '납기일',
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
            text: '입고<br/>수량',
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
                        var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;
                        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
                        var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                        if (newValue * 1 > store.data.EXTRANSQTY2 * 1) {
                            extAlert("입고예정수량이 발주수량을 초과할 수 없습니다.");
                            store.set("EXTRANSQTY", store.data.EXTRANSQTY2);
                            return;
                        }

                    },
                },
            },
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'TRANSDATE',
            text: '입고일자',
            xtype: 'datecolumn',
            width: 140,
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
            dataIndex: 'EXTRANSQTY2',
            xtype: 'hidden',
        }, {
            dataIndex: 'OUTPOPERSON',
            xtype: 'hidden',
        }, ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/ScmOutprocessRegistPop.do' />"
    });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnList": {
            cellclick: 'onMasterClick'
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

function onMasterClick(grid, cell, columnIndex, record, node, rowIndex, evt) {

    var text = grid.getHeaderCt().getHeaderAtIndex(columnIndex).dataIndex;
    var transdate = record.data.TRANSDATE;
    var chk = record.data.CHK;
    if (text == "CHK") {
        if (chk) {
            if (transdate == null) {
                record.set("TRANSDATE", getToDay("${searchVO.dateTo}") + "");
            }
        }
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
                        pageSize: 9999, // gridVals.pageSize, // 20,
                        proxy: {
                            type: 'ajax',
                            api: items["api.1"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#searchOrgId').val(),
                                COMPANYID: $('#searchCompanyId').val(),
                                POFROM: '${searchVO.dateFrom}',
                                POTO: '${searchVO.dateTo}',
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
                height: 666,
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
                                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
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

function fn_search() {
    // 필수 체크
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var transfrom = $('#searchPoFrom').val();
    var transto = $('#searchPoTo').val();
    var transyn = $('#TransYn').val();
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

    if (transfrom === "") {
        header.push("기간 From");
        count++;
    }

    if (transto === "") {
        header.push("기간 To");
        count++;
    }

    if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
        return;
    }

    var sparams = {
        ORGID: $('#searchOrgId').val(),
        COMPANYID: $('#searchCompanyId').val(),
        POFROM: $('#searchPoFrom').val(),
        POTO: $('#searchPoTo').val(),
        OUTPONO: $('#searchOutPoNo').val(),
        ORDERNAME: $('#searchOrderName').val(),
        ITEMNAME: $('#searchItemName').val(),
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

function fn_ready() {
    extAlert("준비중입니다...");
}

function fn_save() {

    Ext.MessageBox.confirm('저장 알림', '저장하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var count = Ext.getStore(gridnms["store.1"]).count();
            var params = [];
            for (var i = 0; i < count; i++) {
                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                if (model.data.CHK) {
                    var outpodate = Ext.util.Format.date(model.data.OUTPODATE, 'Y-m-d');
                    global_close_yn = fn_monthly_close_filter_data(outpodate, 'SCM');
                    if (global_close_yn == "Y") {
                        extAlert("[마감 알림]<br/>선택하신 데이터는 마감처리되어서 기능을 사용하실 수 없습니다.<br/>관리자에게 문의해주세요.");
                        return false;
                    }

                    if (model.data.TRANSDATE + "" == "") {
                        extAlert("입고일자를 입력해주세요.");
                        return;
                    } else if (model.data.EXTRANSQTY + "" == "") {
                        extAlert("입고수량 입력해주세요.");
                        return;
                    }

                    params.push(model.data);
                }
            }

            var url = '<c:url value="/insert/scm/outprocess/ScmOutTransWaitList.do"/>';
            if (params.length > 0) {
                Ext.Ajax.request({
                    url: url,
                    method: 'POST',
                    async: false,
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    jsonData: {
                        data: params
                    },
                    success: function (conn, response, options, eOpts) {

                        var jsonResp = Ext.JSON.decode(conn.responseText);
                        if (jsonResp.result.success) {
                            extAlert(" 완료되었습니다.");
                            dataSuccess = 1;

                            fn_search();
                        }

                    },
                    failure: function (conn, response, options, eOpts) {},
                    error: ajaxError
                });
            }

        } else {
            extToastView("저장이 취소되었습니다.");
            return;
        }
    });

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
                        <input type="hidden" id="orgid" value="<c:out value='${OrgIdVal}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${CompanyIdVal}'/>" />
                        <input type="hidden" id="transno" value="<c:out value='${TransNoVal}'/>" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                        <input type="hidden" id="searchItemCode" name="searchItemCode" />
                            <div>
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
                                                <a id="btnChk1" class="btn_save" href="#" onclick="javascript:fn_save();">
                                                   저장
                                                </a>
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="120px">
                                        <col width="280px">
                                        <col width="120px">
                                        <col width="150px">
                                        <col width="120px">
                                        <col width="280px">
                                        <col width="120px">
                                        <col width="280px">
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">납기일</th>
                                        <td >
                                            <input type="text" id="searchPoFrom" name="searchPoFrom" class="input_validation input_center " style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchPoTo" name="searchPoTo" class="input_validation input_center " style="width: 90px; " maxlength="10"  />
                                        </td>        
                                        <th class="required_text">발주번호</th>
                                        <td>
                                            <input type="text" id="searchOutPoNo" name="searchOutPoNo" class="input_left"  style="width: 97%;" />
                                        </td> 
                                        <th class="required_text">품명</th>
                                        <td>
                                            <input type="text" id="searchItemName" name="searchItemName" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->
                    
                <div style="width: 100%;">
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">기본 정보</div></td>
                        </tr>
                    </table>
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
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