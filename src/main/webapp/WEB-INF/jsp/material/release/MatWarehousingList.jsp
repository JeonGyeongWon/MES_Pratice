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
.gridStyle table td {
  height : 27px;
  font-size : 13px;
}
</style>
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();

    var searchdate = $("#searchMonth").val();
    setValues(searchdate);
    setExtGrid();

    setReadOnly();

    setLovList();
});

function setInitial() {
    $('#searchMonth').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            }
        }
    });

    $("#searchMonth").val(getToDay("${searchVO.TODAY}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {
        //
    });

    gridnms["app"] = "mat";
}

var gridnms = {};
var fields = {};
var items = {};
function setValues(yyyymm) {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "MatWarehousingList";

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
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'CUSTOMERCODE',
        }, {
            type: 'string',
            name: 'CUSTOMERNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARD',
        }, {
            type: 'number',
            name: 'SOQTY',
        }, {
            type: 'number',
            name: 'SHIPQTY',
        }, {
            type: 'number',
            name: 'SHIPQTY',
        }, {
            type: 'string',
            name: 'DAY01',
        }, {
            type: 'string',
            name: 'DAY02',
        }, {
            type: 'string',
            name: 'DAY03',
        }, {
            type: 'string',
            name: 'DAY04',
        }, {
            type: 'string',
            name: 'DAY05',
        }, {
            type: 'string',
            name: 'DAY06',
        }, {
            type: 'string',
            name: 'DAY07',
        }, {
            type: 'string',
            name: 'DAY08',
        }, {
            type: 'string',
            name: 'DAY09',
        }, {
            type: 'string',
            name: 'DAY10',
        }, {
            type: 'string',
            name: 'DAY11',
        }, {
            type: 'string',
            name: 'DAY12',
        }, {
            type: 'string',
            name: 'DAY13',
        }, {
            type: 'string',
            name: 'DAY14',
        }, {
            type: 'string',
            name: 'DAY15',
        }, {
            type: 'string',
            name: 'DAY16',
        }, {
            type: 'string',
            name: 'DAY17',
        }, {
            type: 'string',
            name: 'DAY18',
        }, {
            type: 'string',
            name: 'DAY19',
        }, {
            type: 'string',
            name: 'DAY20',
        }, {
            type: 'string',
            name: 'DAY21',
        }, {
            type: 'string',
            name: 'DAY22',
        }, {
            type: 'string',
            name: 'DAY23',
        }, {
            type: 'string',
            name: 'DAY24',
        }, {
            type: 'string',
            name: 'DAY25',
        }, {
            type: 'string',
            name: 'DAY26',
        }, {
            type: 'string',
            name: 'DAY27',
        }, {
            type: 'string',
            name: 'DAY28',
        }, {
            type: 'string',
            name: 'DAY29',
        }, {
            type: 'string',
            name: 'DAY30',
        }, {
            type: 'string',
            name: 'DAY31',
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
                //          meta.style = "background-color:rgb(234, 234, 234); ";
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'CUSTOMERNAME',
            text: '공급사',
            xtype: 'gridcolumn',
            width: 235,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "left",
        }, {
            dataIndex: 'ITEMSTANDARD',
            text: '기종(규격)',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "center",
            summaryRenderer: function (value, meta, record) {
                var header1 = "합계";
                //              var header2 = "비율 (%)";
                return [header1].map(function (val) {
                    return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 13px;'>" + val + '</div>';
                }).join('<br />');
            },
        }, {
            dataIndex: 'POQTY',
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
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
                return Ext.util.Format.number(value, '0,000');
            },
        }, {
            dataIndex: 'QTY',
            text: '미입고<br/>수량',
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
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
            	 if(value*1 <=0)
            		 meta.style = " color:rgb(100, 100, 255); ";
             else
            	  meta.style = "font-weight:bold; color:rgb(255, 100, 100); ";
            		 
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
                var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                return result;
            },
            renderer: function (value, meta, record) {
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
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, ];

    var dateList = yyyymm.split("-");
    var lastday = (new Date(dateList[0], dateList[1], 0)).getDate();
    for (var i = 0; i < lastday; i++) {
        (function (x) {

            var rn = (x + 1) + "";
            var qty_index = fn_lpad(rn, 2, '0');
            var searchdate = dateList[0] + "-" + dateList[1] + "-" + rn;
            var dayname = fn_calc_day_name(searchdate);
            var colorcode = "";
            switch (dayname) {
            case "토":
                colorcode = " color: rgb(1, 0, 255); background-color:rgb(217, 229, 255); ";
                break;
            case "일":
                colorcode = " color: rgb(255, 0, 0); background-color:rgb(255, 216, 216); ";
                break;
            default:
                colorcode = " color: rgb(102, 102, 102); ";
                break;
            }
            fields["columns.1"].push({
                dataIndex: 'DAY' + qty_index,
                text: rn,
                xtype: 'gridcolumn',
                width: 60,
                hidden: false,
                sortable: false,
                resizable: true,
                menuDisabled: true,
                style: 'text-align:center; ' + colorcode,
                align: "right",
                cls: 'ERPQTY',
                format: "0,000",
                summaryType: 'sum',
                summaryRenderer: function (value, summaryData, dataIndex) {
                    var data = Ext.getStore(gridnms["store.1"]).getData().items;

                    var total = 0,
                    importqty = 0;
                    for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {
                        total += (extExtractValues(data, dataIndex)[i] * 1);
                        importqty += (extExtractValues(data, "SHIPQTY")[i] * 1);
                    }

                    //            var rate = (importqty == 0) ? 0 : (((total / importqty) * 100)).toFixed(1);
                    var result = [total].map(function (val) {
                        return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 13px;'>" + Ext.util.Format.number(val, '0,000.#') + '</div>';
                    }).join('<br />');
                    return result;
                },
                renderer: function (value, meta, record) {
                    var searchdate = dateList[0] + "-" + dateList[1] + "-" + rn;
                    var dayname = fn_calc_day_name(searchdate);
                    switch (dayname) {
                    case "토":
                        meta.style = " background-color:rgb(217, 229, 255); ";
                        break;
                    case "일":
                        meta.style = " background-color:rgb(255, 216, 216); ";
                        break;
                    default:
                        break;
                    }
                    return Ext.util.Format.number(value, '0,000');
                },
            });

        })(i);
    }

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/material/release/MatWarehousingList.do' />"
    });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#MasterList": {
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
}

var rowIdx = 0, colIdx = 0;
function MasterClick(dataview, record, item, index, e, eOpts) {
    rowIdx = e.position.rowIdx;
    colIdx = e.position.colIdx;

    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
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
                        pageSize: 9999,
                        proxy: {
                            type: 'ajax',
                            api: items["api.1"],
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $('#searchOrgId option:selected').val(),
                                COMPANYID: $('#searchCompanyId option:selected').val(),
                                SEARCHMONTH: $("#searchMonth").val() + "",
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

        MasterClick: MasterClick,
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
                height: 687,
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
                    trackOver: true,
                    loadMask: true,
                    striptRows: true,
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

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchMonth = $("#searchMonth").val();
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

    if (searchMonth == "") {
        header.push("년월");
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
    var searchMonth = $("#searchMonth").val(); //년월
    var searchItemStandard = $("#searchItemStandard").val(); //규격
    var customercode = $("#searchCustomerCode").val();        //공급사
    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        SEARCHMONTH: searchMonth,
        CUSTOMERCODE: customercode,
        ITEMSTANDARD: searchItemStandard,
    };
    setValues(searchMonth);
    Ext.suspendLayouts();
    Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
    Ext.resumeLayouts(true);
    extGridSearch(sparams, gridnms["store.1"]);
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
                CUSTOMERTYPE: 'A',
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
                                <li>공정관리</li>
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
                        <input type="hidden" id="itemname" name="itemname" />
                        <input type="hidden" id="cartype" name="cartype" />
                        <input type="hidden" id="cartypename" name="cartypename" />
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
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="120px">
                                        <col width="120px">
                                        <col width="120px">
                                        <col width="200px">
                                        <col width="120px">
                                        <col>
                                        <col width="120px">
                                        <col>
                                    </colgroup>
                                    
                                    <tr style="height: 34px;">
                                        <th class="required_text">년월</th>
                                        <td>
                                          <input type="text" id="searchMonth" name="searchMonth" class="input_validation input_center" style="width: 100px; min-width: 100px;" maxlength="7" value="${searchVO.TODAY}" />
                                        </td>
                                        <th class="required_text">규격</th>
                                        <td >
                                            <input type="text" id="searchItemStandard" name="searchItemStandard"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                        </td>
                                        <th class="required_text">공급사</th>
                                        <td>
                                              <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" style="width: 94%;" />
                                              <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" />
                                        </td>
                                        <td></td>
                                        <td></td>
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