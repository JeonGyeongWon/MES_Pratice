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
<link rel="stylesheet" href="<c:url value='/css/custom_work.css'/>">

<style>
.x-column-header-inner {
    font-size: 18px;
    line-height: 110%;
    font-weight: bold;
    background-color: #5B9BD5;
    color: white;
    padding-left: 0px;
    padding-right: 0px;
}

.FML .x-grid-cell-inner {
  padding-left : 0px;
  padding-right : 0px;
}

.x-grid-cell-inner {
position: relative;
text-overflow: ellipsis;
padding-top: 10px;
padding-left : 10px;
height: 45px;
font-size: 18px !important;
font-weight: bold;
}


.x-btn {
margin-top : 2px;
height: 39px;
}

.x-btn-inner {
font-size : 14px !important;
}


#gridArea .x-form-field {
    font-size: 18px; 
    font-weight: bold;
}
</style>
  
<style>
.shadow {
	-webkit-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
	-moz-box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
	box-shadow: 2px 2px 5px 0px rgba(0, 0, 0, 0.75);
}

.h:HOVER {
	background-color: highlight;
}

.blue {
	background-color: #003399;
	color: white;
}

.blue2:HOVER {
	background-color: highlight;
  font-size: 18px;
  font-weight: bold;
}

.blue2 {
	background-color: #5B9BD5;
	color: white;
  font-size: 18px;
  font-weight: bold;
}

.blue3:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #003399;
}

.blue3 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #003399 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.gray:HOVER {
	background-color: #EAEAEA;
}

.gray {
	background-color: #BDBDBD;
	color: black;
}

.white:hover {
	background-color: #FFFFFF;
	border-bottom: 4px solid #5B9BD5;
}

.white {
	overflow: hidden;
	background-color: #FFFFFF;
	color: rgb(34, 34, 34) !important;
	font-weight: bold;
	font-size: 18px;
	margin-top: 0px;
	margin-bottom: 0px;
	cursor: pointer;
	margin-top: 0px;
	margin-bottom: 0px;
	/* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white2:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white2 {
  overflow: hidden;
  background-color: #FFFFFF;
  color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 16px;
  margin-top: 0px;
  margin-bottom: 0px;
  cursor: pointer;
  margin-top: 0px;
  margin-bottom: 0px;
  /* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.white_selected:hover {
	background-color: #FFFFFF;
	border-bottom: 4px solid #5B9BD5;
}

.white_selected {
	overflow: hidden;
	background-color: #FFFFFF;
	color: #5B9BD5 !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
	cursor: pointer;
	border-bottom: 4px solid #5B9BD5;
	margin-top: 0px;
	margin-bottom: 0px;
}

.yellow:hover {
	background-color: #FFFFFF;
	color: yellow !important;
	text-shadow: 2px 2px 5px rgb(34, 34, 34);
	border-bottom: 4px solid yellow;
}

.yellow {
	overflow: hidden;
	background-color: #FFFFFF;
	color: rgb(34, 34, 34) !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
	cursor: pointer;
	margin-top: 0px;
	margin-bottom: 0px;
	/* transition: all 0.4s cubic-bezier(0.215, 0.61, 0.355, 1) 0s; */
}

.yellow_selected:hover {
	background-color: #FFFFFF;
	border-bottom: 4px solid yellow;
}

.yellow_selected {
	overflow: hidden;
	background-color: #FFFFFF;
	color: yellow !important;
  font-weight: bold;
  font-size: 18px;
  margin-top: 0px;
  margin-bottom: 0px;
	text-shadow: 2px 2px 5px rgb(34, 34, 34);
	cursor: pointer;
	border-bottom: 4px solid yellow;
	cursor: pointer;
}

.red:HOVER {
	background-color: #FFD8D8;
}

.red {
	background-color: #FFA7A7;
	color: black;
}

.green:HOVER {
	background-color: #CEFBC9;
}

.green {
	background-color: #47C83E;
	color: black;
  font-size: 18px;
  font-weight: bold;
}

.green_selected {
  background-color: #5B9BD5;
  color: white;
  font-size: 18px;
  font-weight: bold;
  text-shadow: 2px 2px 2px rgb(34, 34, 34);
}

.r {
	border-radius: 4px 4px 4px 4px;
	-moz-border-radius: 4px 4px 4px 4px;
	-webkit-border-radius: 4px 4px 4px 4px;
	border: 0px solid #000000;
}

.ui-autocomplete {
	font-size: 33px;
	font-weight: bold;
	max-height: 400px;
	overflow-y: auto;
	/* prevent horizontal scrollbar */
	overflow-x: hidden;
}

* html .ui-autocomplete {
	/* IE 6.0 */
	height: 400px;
	font-size: 33px;
	font-weight: bold;
}

.ui-menu  .ui-menu-item {
  height: 85px;
  line-height: 40px;
  margin-top: 0px;
  padding-top: 0px;
  padding-bottom: 0px;
  display: flex;
  flex-direction: column;
  align-items: left;
  justify-content: center;
}

*::-webkit-input-placeholder {
	color: blue;
}

*:-moz-placeholder {
	/* FF 4-18 */
	color: blue;
}

*::-moz-placeholder {
	/* FF 19+ */
	color: blue;
}

*:-ms-input-placeholder {
	/* IE 10+ */
	color: blue;
}
</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
var gridnms = {};
var fields = {};
var items = {};
$(document).ready(function () {
    setInitial();

    setValues();
    setExtGrid();

    setReadOnly();

    setLovList();

    setLastInitial();
});

var global_check = "N";
function setInitial() {
    gridnms["app"] = "prod";

    var today = new Date();
    var today_c = Ext.util.Format.date(today, 'Y-m-d');
    calender($('#searchOutPoDate'));

    $('#searchOutPoDate').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $("#searchOutPoDate").val(today_c);

    //     $('input[type=radio][name="searchGubun"]').on("ifChanged", function () {
    //         var value = $(this).val();
    //         if (value != global_check) {
    //             if (value != "" || value != undefined) {
    //                 fn_search();
    //             }
    //             global_check = value;
    //         }
    //     });
}

function fn_select_search(flag) {
    switch (flag) {
    case "Y":
        $('#btn_search_n').removeClass("green_selected");
        $('#btn_search_n').addClass("green");

        $('#btn_search_y').removeClass("green");
        $('#btn_search_y').addClass("green_selected");
        break;
    case "N":
        $('#btn_search_n').removeClass("green");
        $('#btn_search_n').addClass("green_selected");

        $('#btn_search_y').removeClass("green_selected");
        $('#btn_search_y').addClass("green");
        break;
    default:
        break;
    }
    global_check = flag;
    fn_search();
}

function setLastInitial() {
    setTimeout(function () {
        fn_search();
    }, 200);
}

function setValues() {
    setValues_list();
}

function setValues_list() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "WorkOutOrderRegist";
    gridnms["grid.11"] = "customerLov";
    gridnms["grid.12"] = "itemmodelLov";
    gridnms["grid.13"] = "itemstandardLov";
    gridnms["grid.14"] = "routingLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
    gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];
    gridnms["model.13"] = gridnms["app"] + ".model." + gridnms["grid.13"];
    gridnms["model.14"] = gridnms["app"] + ".model." + gridnms["grid.14"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
    gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];
    gridnms["store.13"] = gridnms["app"] + ".store." + gridnms["grid.13"];
    gridnms["store.14"] = gridnms["app"] + ".store." + gridnms["grid.14"];

    gridnms["models.list"].push(gridnms["model.1"]);
    gridnms["models.list"].push(gridnms["model.11"]);
    gridnms["models.list"].push(gridnms["model.12"]);
    gridnms["models.list"].push(gridnms["model.13"]);
    gridnms["models.list"].push(gridnms["model.14"]);

    gridnms["stores.list"].push(gridnms["store.1"]);
    gridnms["stores.list"].push(gridnms["store.11"]);
    gridnms["stores.list"].push(gridnms["store.12"]);
    gridnms["stores.list"].push(gridnms["store.13"]);
    gridnms["stores.list"].push(gridnms["store.14"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'RN',
        }, {
            type: 'string',
            name: 'RK',
        }, {
            type: 'string',
            name: 'ORGID',
        }, {
            type: 'string',
            name: 'COMPANYID',
        }, {
            type: 'string',
            name: 'WORKORDERID',
        }, {
            type: 'string',
            name: 'WORKORDERSEQ',
        }, {
            type: 'string',
            name: 'WORKTYPE',
        }, {
            type: 'string',
            name: 'WORKTYPENAME',
        }, {
            type: 'string',
            name: 'WORKSTATUS',
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
            name: 'MODEL',
        }, {
            type: 'string',
            name: 'MODELNAME',
        }, {
            type: 'string',
            name: 'ITEMSTANDARD',
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
            name: 'ROUTINGNO',
        }, {
            type: 'string',
            name: 'ROUTINGOP',
        }, {
            type: 'string',
            name: 'ROUTINGNAME',
        }, {
            type: 'string',
            name: 'EQUIPMENTCODE',
        }, {
            type: 'number',
            name: 'IMPORTQTY',
        }, {
            type: 'number',
            name: 'ORDERQTY',
        }, {
            type: 'number',
            name: 'REMAINQTY',
        }, {
            type: 'string',
            name: 'OUTPODATE',
        }, {
            type: 'string',
            name: 'OUTPONO',
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

    fields["columns.1"] = [{
            dataIndex: 'RN',
            text: '순<br/>번',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
        }, {
            dataIndex: 'ITEMNAME',
            text: '품명',
            xtype: 'gridcolumn',
            width: 250,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
        }, {
            dataIndex: 'MODELNAME',
            text: '기종',
            xtype: 'gridcolumn',
            width: 250,
            hidden: false,
            sortable: true,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.12"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                hideTrigger: false,
                height: 45,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("ITEMCODE", record.data.ITEMCODE);
                        model.set("ITEMNAME", record.data.ITEMNAME);
                        model.set("ORDERNAME", record.data.ORDERNAME);
                        model.set("MODEL", record.data.VALUE);

                        var emptyValue = "";
                        var itemstandard = record.data.ITEMSTANDARD;
                        if (itemstandard == "") {
                            model.set("ITEMSTANDARD", emptyValue);
                        }

                        var routing = record.data.ROUTINGCODE;
                        if (routing == "") {
                            model.set("ROUTINGCODE", emptyValue);
                            model.set("ROUTINGNO", emptyValue);
                            model.set("ROUTINGOP", emptyValue);
                            model.set("ROUTINGNAME", emptyValue);
                        }
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {}
                            var emptyValue = "";
                            model.set("ITEMCODE", emptyValue);
                            model.set("ITEMNAME", emptyValue);
                            model.set("ORDERNAME", emptyValue);
                            model.set("MODEL", emptyValue);
                            model.set("ITEMSTANDARD", emptyValue);
                            model.set("ROUTINGCODE", emptyValue);
                            model.set("ROUTINGNO", emptyValue);
                            model.set("ROUTINGOP", emptyValue);
                            model.set("ROUTINGNAME", emptyValue);
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 1200,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table style="width: 100%; ">'
                         + '<colgroup>'
                         + '<col width="40%">'
                         + '<col width="40%">'
                         + '<col width="20%">'
                         + '</colgroup>'
                         + '<tr style="height: 50px;">'
                         + '<td class="input_center" style="height: 25px; font-size: 33px; font-weight: bold; ">{LABEL}</td>'
                         + '<td class="input_left" style="height: 25px; font-size: 33px; border-left: 1px dashed gray; ">{ITEMNAME}</td>'
                         + '<td class="input_center" style="height: 25px; font-size: 33px; border-left: 1px dashed gray; ">{ORDERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ITEMSTANDARD',
            text: '타입',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: true,
            menuDisabled: true,
            resizable: false,
            style: 'text-align:center',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.13"],
                valueField: "ITEMSTANDARDDETAIL",
                displayField: "ITEMSTANDARDDETAIL",
                matchFieldWidth: false,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                hideTrigger: false,
                height: 45,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("ITEMCODE", record.data.ITEMCODE);
                        model.set("ITEMNAME", record.data.ITEMNAME);
                        model.set("ORDERNAME", record.data.ORDERNAME);

                        var routing = record.data.ROUTINGCODE;
                        if (routing == "") {
                            model.set("ROUTINGCODE", emptyValue);
                            model.set("ROUTINGNO", emptyValue);
                            model.set("ROUTINGOP", emptyValue);
                            model.set("ROUTINGNAME", emptyValue);
                        }
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                var emptyValue = "";
                                model.set("ITEMCODE", emptyValue);
                                model.set("ITEMNAME", emptyValue);
                                model.set("ORDERNAME", emptyValue);
                                model.set("MODEL", emptyValue);
                                model.set("ROUTINGCODE", emptyValue);
                                model.set("ROUTINGNO", emptyValue);
                                model.set("ROUTINGOP", emptyValue);
                                model.set("ROUTINGNAME", emptyValue);
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 850,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table style="width: 100%; ">'
                         + '<colgroup>'
                         + '<col width="10%">'
                         + '<col width="60%">'
                         + '<col width="30%">'
                         + '</colgroup>'
                         + '<tr style="height: 50px;">'
                         + '<td class="input_center" style="height: 25px; font-size: 33px; font-weight: bold; ">{ITEMSTANDARDDETAIL}</td>'
                         + '<td class="input_left" style="height: 25px; font-size: 33px; border-left: 1px dashed gray; ">{ITEMNAME}</td>'
                         + '<td class="input_center" style="height: 25px; font-size: 33px; border-left: 1px dashed gray; ">{ORDERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ROUTINGNAME',
            text: '공정명',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.14"],
                valueField: "ROUTINGNAME",
                displayField: "ROUTINGNAME",
                matchFieldWidth: false,
                editable: true,
                queryParam: 'keyword',
                queryMode: 'local', // 'remote',
                allowBlank: true,
                transform: 'stateSelect',
                forceSelection: false,
                anyMatch: true,
                hideTrigger: false,
                height: 45,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        model.set("ROUTINGCODE", record.data.ROUTINGCODE);
                        model.set("ROUTINGNO", record.data.ROUTINGNO);
                        model.set("ROUTINGOP", record.data.ROUTINGOP);
                    },
                    change: function (field, ov, nv, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        var result = field.getValue();

                        if (ov != nv) {
                            if (!isNaN(result)) {
                                var emptyValue = "";
                                model.set("ROUTINGCODE", emptyValue);
                                model.set("ROUTINGNO", emptyValue);
                                model.set("ROUTINGOP", emptyValue);
                                model.set("ROUTINGNAME", emptyValue);
                            }
                        }
                    },
                },
                listConfig: {
                    loadingText: '검색 중...',
                    emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
                    width: 600,
                    getInnerTpl: function () {
                        return '<div >'
                         + '<table style="width: 100%; ">'
                         + '<colgroup>'
                         + '<col width="70%">'
                         + '<col width="30%">'
                         + '</colgroup>'
                         + '<tr style="height: 50px;">'
                         + '<td class="input_center" style="height: 25px; font-size: 33px; font-weight: bold; ">{ROUTINGNAME}</td>'
                         + '<td class="input_center" style="height: 25px; font-size: 33px; border-left: 1px dashed gray; ">{ROUTINGOP}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                return value;
            },
        }, {
            dataIndex: 'ORDERNAME',
            text: '품번',
            xtype: 'gridcolumn',
            width: 180,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
        }, {
            dataIndex: 'WORKORDERID',
            text: '작업지시번호',
            xtype: 'gridcolumn',
            width: 180,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            align: "center",
            //     }, {
            //       dataIndex: 'CUSTOMERNAME',
            //       text: '외주가공처',
            //       xtype: 'gridcolumn',
            //       width: 180,
            //       hidden: false,
            //       sortable: false,
            //       menuDisabled: true,
            //       align: "center",
            //       editor: {
            //         xtype: 'combobox',
            //         store: gridnms["store.11"],
            //         valueField: "LABEL",
            //         displayField: "LABEL",
            //         height: 45,
            //         matchFieldWidth: true,
            //         editable: false,
            //         queryParam: 'keyword',
            //         queryMode: 'remote', // 'local',
            //         allowBlank: true,
            //         typeAhead: true,
            //         transform: 'stateSelect',
            //         forceSelection: false,
            //         listeners: {
            //           select: function (value, record, eOpts) {
            //             var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            //             model.set("CUSTOMERCODE", record.data.VALUE);
            //           },
            //           change: function (field, ov, nv, eOpts) {
            //             var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            //             var result = field.getValue();

            //             if (ov != nv) {
            //               if (!isNaN(result)) {
            //                 model.set("CUSTOMERCODE", "");
            //               }
            //             }
            //           },
            //         },
            //         listConfig: {
            //           loadingText: '검색 중...',
            //           emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
            //           width: 120,
            //           getInnerTpl: function () {
            //             return '<div >'
            //              + '<table >'
            //              + '<colgroup>'
            //              + '<col width="250px">'
            //              + '</colgroup>'
            //              + '<tr>'
            //              + '<td style="height: 40px; font-size: 17px; font-weight: bold; ">{LABEL}</td>'
            //              + '</tr>'
            //              + '</table>'
            //              + '</div>';
            //           }
            //         },
            //       },
            //       renderer: function (value, meta, record) {

            //         return value;
            //       },
        }, {
            dataIndex: 'IMPORTQTY',
            text: '생산수량',
            xtype: 'gridcolumn',
            width: 180,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'ORDERQTY',
            text: '기발주수량',
            xtype: 'gridcolumn',
            width: 180,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            renderer: Ext.util.Format.numberRenderer('0,000'),
        }, {
            dataIndex: 'REMAINQTY',
            text: '발주수량',
            xtype: 'gridcolumn',
            width: 160,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center;',
            align: "right",
            cls: 'ERPQTY',
            format: "0,000",
            editor: {
                xtype: "textfield",
                height: 45,
                minValue: 1,
                format: "0,000",
                enforceMaxLength: true,
                allowBlank: true,
                maxLength: '9',
                maskRe: /[0-9.]/,
                selectOnFocus: true,
                listeners: {
                    specialkey: function (field, e) {
                        if (e.keyCode === 38) {
                            // 위
                            var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().rowIdx;
                            colIdx = 10; // selModel.getCurrentPosition().colIdx;

                            fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                        }
                        if (e.keyCode === 40) {
                            // 아래
                            var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().rowIdx;
                            colIdx = 10; // selModel.getCurrentPosition().colIdx;

                            fn_grid_focus_move("DOWN", gridnms["store.1"], gridnms["views.list"], rowIdx, colIdx);
                        }

                        if (e.keyCode === 13) {
                            var value = field.getValue() * 1;

                            var selModel = Ext.getCmp(gridnms["views.list"]).getSelectionModel();
                            rowIdx = selModel.getCurrentPosition().rowIdx;
                            var model = Ext.getStore(gridnms["store.1"]).getAt(rowIdx);

                            var importqty = model.data.IMPORTQTY * 1;
                            var orderqty = model.data.ORDERQTY * 1;
                            var remainqty = (importqty - orderqty);

                            fn_split_value(model, rowIdx, value, remainqty);

                            field.setValue(global_remain_qty);
                            model.set("CHK", true);
                        }
                    },
                },
            },
            renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
                meta.style = " background-color: rgb(253, 218, 255); ";
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
            align: "center",
            componentCls: 'CHK',
            renderer: function (value, meta, record, row, col) {
                var qty = record.data.REMAINQTY * 1;
                if (qty > 0) {
                    meta['tdCls'] = '';
                } else {
                    meta['tdCls'] = 'x-item-disabled';
                }
                return new Ext.ux.CheckColumn().renderer(value);
            },
            listeners: {
                beforecheckchange: function (options, row, value, event) {

                    var record = Ext.getCmp(gridnms["views.list"]).selModel.store.data.items[row].data;
                    if (value) {
                        var qty = record.REMAINQTY * 1;
                        if (qty == 0) {
                            extToastView("이미 발주처리된 건입니다.<br/>다시 한번 확인해주세요.");
                            return false;
                        }
                    }
                }
            }
        }, {
            dataIndex: 'XXXXXXXXXX',
            resizable: false,
            menuDisabled: true,
            sortable: false,
            xtype: 'widgetcolumn',
            stopSelection: true,
            text: '',
            width: 130,
            style: 'text-align:center;',
            align: "center",
            widget: {
                xtype: 'button',
                _btnText: "발주처리",
                defaultBindProperty: null,
                handler: function (widgetColumn) {
                    var record = widgetColumn.getWidgetRecord();

                    fn_save(record.data);
                },
                listeners: {
                    beforerender: function (widgetColumn) {
                        var record = widgetColumn.getWidgetRecord();
                        widgetColumn.setText(widgetColumn._btnText);
                    }
                }
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
            dataIndex: 'WORKORDERSEQ',
            xtype: 'hidden',
        }, {
            dataIndex: 'ROUTINGCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'UOM',
            xtype: 'hidden',
        }, {
            dataIndex: 'MODEL',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'CUSTOMERNAME',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'OUTPODATE',
            xtype: 'hidden',
        }, {
            dataIndex: 'OUTPONO',
            xtype: 'hidden',
        },
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        read: "<c:url value='/select/prod/process/WorkOutOrderRegist.do' />"
    });

    items["btns.1"] = [];

    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#OutOrderList": {
            itemclick: 'OutOrderSelectClick',
            cellclick: 'OutOrderCellClick',
        }
    });

    // 페이징
    items["dock.paging.1"] = {
        xtype: 'pagingtoolbar',
        dock: 'bottom',
        displayInfo: true,
        store: gridnms["store.1"],
    };

    // 버튼 컨트롤
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
function OutOrderSelectClick(dataview, record, item, index, e, eOpts) {
    rowIdx = e.position.rowIdx;
    colIdx = e.position.colIdx;
    var columnIndex = e.position.column.dataIndex;

    if (record.data.SAVEFLAG == "Y") {
        switch (columnIndex) {
        case "ITEMSTANDARD":
            var params13 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                MODEL: record.data.MODEL,
                OUTORDERGUBUN: 'Y',
            };
            extGridSearch(params13, gridnms["store.13"]);
            break;
        case "ROUTINGNAME":
            var params14 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                ITEMCODE: record.data.ITEMCODE,
                OUTORDERGUBUN: 'Y',
            };
            extGridSearch(params14, gridnms["store.14"]);
            break;
        }
    }

    var orgid = record.data.ORGID;
    var companyid = record.data.COMPANYID;
    var outpono = record.data.OUTPONO;

    $('#searchOrgId').val(orgid);
    $('#searchCompanyId').val(companyid);
    $('#PoNo').val(outpono);
};

function OutOrderCellClick(grid, cell, columnIndex, record, node, rowIndex, evt) {
    var text = grid.getHeaderCt().getHeaderAtIndex(columnIndex).dataIndex;
    var gubun = global_check; // $(':radio[name="searchGubun"]:checked').val();
    var chk = record.data.CHK;
    var emptyValue = "";

    if (text != "CHK") {
        if (gubun == "N") {
            if (chk) {
                record.set("CHK", false);
            } else {
                record.set("CHK", true);
            }
        }
    }
}

var global_equals_row = [];
var global_remain_qty = 0;
function fn_split_value(rec, rownum, val, fqty) {
    var itemcode = rec.data.ITEMCODE;
    var workorderid = rec.data.WORKORDERID;
    var total = (val * 1);
    global_remain_qty = 0;

    global_equals_row = [];
    var count = Ext.getStore(gridnms["store.1"]).count();
    if (count > 0) {
        for (var i = 0; i < count; i++) {
            var model = Ext.getStore(gridnms["store.1"]).getAt(i);
            var itemcode_temp = model.data.ITEMCODE;
            var workorderid_temp = model.data.WORKORDERID;

            if (itemcode == itemcode_temp) {
                if (workorderid != workorderid_temp) {
                    global_equals_row.push(i);
                }
            }
        }

        if (global_equals_row.length > 0) {
            for (var g = 0; g < global_equals_row.length; g++) {
                var row_num = global_equals_row[g];
                var model = Ext.getStore(gridnms["store.1"]).getAt(row_num);

                var importqty = model.data.IMPORTQTY * 1;
                var orderqty = model.data.ORDERQTY * 1;
                var remainqty = (importqty - orderqty);

                if (row_num != rownum) {
                    if (total - remainqty > 0) {
                        total -= remainqty;
                        model.set("REMAINQTY", remainqty);
                        model.set("CHK", true);
                    } else {
                        model.set("REMAINQTY", 0);
                        model.set("CHK", false);
                    }
                }
            }
            //      } else {
            //          extToastView("[자동나눔 오류]<br/>다른 작업지시정보가 없습니다.<br/>다시한번 확인해주세요.");
            //          return false;
        }
    } else {
        extToastView("[자동나눔 오류]<br/>조회된 외주발주 내역이 없습니다.<br/>다시한번 확인해주세요.");
        return false;
    }
    global_remain_qty = total;
}

var gridarea1;
function setExtGrid() {
    setExtGrid_list();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea1.updateLayout();
    });
}

function setExtGrid_list() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"],
    });

    Ext.define(gridnms["model.11"], {
        extend: Ext.data.Model,
        fields: fields["model.11"],
    });

    Ext.define(gridnms["model.12"], {
        extend: Ext.data.Model,
        fields: fields["model.12"],
    });

    Ext.define(gridnms["model.13"], {
        extend: Ext.data.Model,
        fields: fields["model.13"],
    });

    Ext.define(gridnms["model.14"], {
        extend: Ext.data.Model,
        fields: fields["model.14"],
    });

    Ext.define(gridnms["store.1"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.1"],
                        model: gridnms["model.1"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            api: items["api.1"],
                            timeout: gridVals.timeout,
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
                            type: 'ajax',
                            url: "<c:url value='/searchCustomernameLov.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: '${searchVO.ORGID}',
                                COMPANYID: '${searchVO.COMPANYID}',
                                CUSTOMERTYPE2: 'O',
                                USEYN: 'Y',
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
                            type: 'ajax',
                            url: "<c:url value='/searchWorkModelList.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: '${searchVO.ORGID}',
                                COMPANYID: '${searchVO.COMPANYID}',
                                OUTORDERGUBUN: 'Y',
                            },
                            reader: gridVals.reader,
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
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchWorkItemStandardDList.do' />",
                            timeout: gridVals.timeout,
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
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: 'ajax',
                            url: "<c:url value='/searchRoutingItemLov.do' />",
                            timeout: gridVals.timeout,
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            OutOrderList: '#OutOrderList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        OutOrderSelectClick: OutOrderSelectClick,
        OutOrderCellClick: OutOrderCellClick,
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
                height: 787,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'OutOrderList',
                    listeners: {
                        refresh: function (dataView) {
                            Ext.each(dataView.panel.columns, function (column) {
                                if (column.dataIndex.indexOf('ITEMNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 220) {
                                        column.width = 220;
                                    }
                                }
                                if (column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
                                    column.autoSize();
                                    column.width += 5;
                                    if (column.width < 130) {
                                        column.width = 130;
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
                                var record = ctx.record;
                                var editDisableCols = [];

                                var saveflag = record.SAVEFLAG;
                                if (saveflag != "Y") {
                                    editDisableCols.push("MODELNAME");
                                    editDisableCols.push("ITEMSTANDARD");
                                    editDisableCols.push("ROUTINGNAME");
                                }

                                var qty = record.REMAINQTY;
                                if ((qty === 0)) {
                                    editDisableCols.push("REMAINQTY");
                                }

                                var isNew = ctx.record.phantom || false;
                                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
                                    return false;
                                else {
                                    return true;
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
            gridarea1 = Ext.create(gridnms["views.list"], {
                renderTo: 'gridArea'
            });
        },
    });
}

function fn_goHome() {
    go_url('<c:url value="/prod/process/ProcessStart.do" />');
}

function fn_goMovePage(flag) {
    var equipmentcode = $('#equipmentcode').val();

    if (flag === 8) {
        go_url('<c:url value="/prod/process/WarehousingRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 10) {
        go_url('<c:url value="/prod/process/selectWorkOrderNewRegist.do?type="/>' + flag + "&work=" + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 11) {
        go_url('<c:url value="/prod/process/WorkgroupChangeRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 12) {
        go_url('<c:url value="/prod/process/WorkOutOrderRegist.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else if (flag === 13) {
        go_url('<c:url value="/prod/process/WorkOrderInOut.do?work="/>' + $('#work').val() + "&gubun=" + $('#gubun').val());
    } else {
        go_url('<c:url value="/prod/process/selectWorkOrderRegist.do?type="/>' + flag + "&gubun=" + $('#gubun').val() + "&work=" + $('#work').val());
    }
}

function fn_search_clear() {
    var emptyValue = "";
    $('#searchCustomerCode').val(emptyValue);
    $('#searchCustomerName').val(emptyValue);
    $('#searchModQty').val(emptyValue);
}

function fn_search() {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var gubun = global_check; // $(':radio[name="searchGubun"]:checked').val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        GUBUN: gubun,
    };
    extGridSearch(sparams, gridnms["store.1"]);
}

var isChecked = true;
function fn_check_all(o, e) {
    var recount = Ext.getStore(gridnms["store.1"]).count();
    var chkcount = 0;
    var emptyValue = "";
    for (var i = 0; i < recount; i++) {
        var model = Ext.getStore(gridnms["store.1"]).getAt(i);

        var qty = model.data.REMAINQTY * 1;
        if (qty > 0) {
            if (isChecked) {
                model.set("CHK", true);
                chkcount++;
            } else {
                model.set("CHK", false);
            }
        }
    }

    if (isChecked) {
        isChecked = false;
    } else {
        isChecked = true;
    }
}

function fn_save_all() {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();

    var count = Ext.getStore(gridnms["store.1"]).count();
    var msg_status = "",
    msg_true = "",
    msg_false = "";
    var chk_count = 0;
    var params = [];
    var header = [];

    Ext.MessageBox.confirm('발주처리 알림', '발주처리하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var recount = Ext.getStore(gridnms["store.1"]).count();
            var chknum = 0;
            for (var i = 0; i < recount; i++) {
                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

                var check = model.data.CHK;
                var customercode = $('#searchCustomerCode').val();
                if (customercode == "" || customercode == undefined) {
                    header.push("외주가공처");
                    chk_count++;
                }

                if ( check ) {
                    var orderqty = model.data.REMAINQTY;
                    if (orderqty == "" || orderqty == undefined) {
                        header.push("발주수량");
                        chk_count++;
                    }
                }

                if (chk_count > 0) {
                    extToastView("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                    return false;
                }

                if (check) {
                    var modqty = $('#searchModQty').val();
                    model.data.CUSTOMERCODE = customercode;
                    model.data.MODQTY = modqty;
                    var outpodate = $('#searchOutPoDate').val();
                    model.data.OUTPODATE = Ext.util.Format.date(outpodate, 'Y-m-d');
                    if (chknum > 0) {
                        model.data.FLAG = 'N';
                    } else {
                        model.data.FLAG = 'Y';
                    }
                    chknum++;

                    params.push(model.data);
                }
            }

            var url = '<c:url value="/update/prod/process/WorkOutOrderRegist.do"/>';
            if (params.length > 0) {
                Ext.Ajax.request({
                    url: url,
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    jsonData: {
                        data: params
                    },
                    success: function (conn, response, options, eOpts) {
                        var obj = JSON.parse(conn.responseText);
                        var rscode = obj.result.success;
                        var msgdata = obj.result.MSGDATA;
                        var orgid = $('#orgid').val();
                        var companyid = $('#companyid').val();
                        var outpono = obj.result.data[0].OUTPONO;
                        $('#searchOrgId').val(orgid);
                        $('#searchCompanyId').val(companyid);
                        $('#PoNo').val(outpono);
                        var msg = obj.result.msg;

                        if (rscode == "E") {
                            extToastView("관리자에게 문의하십시오.<br/>" + msgdata);
                            return;
                        } else {
                            extToastView(msg);
                            fn_search_clear();
                            fn_search();
                            fn_print();
                        }
                    },
                    error: ajaxError
                });
            }

        } else {
            extToastView("발주처리가 취소되었습니다.");
            return;
        }
    });
}

function fn_save(data) {
    var orgid = $('#orgid').val();
    var companyid = $('#companyid').val();
    var header = [];
    var chk_count = 0;
    var outpodate = $('#searchOutPoDate').val();
    if (outpodate == "" || outpodate == undefined) {
        header.push("발주일자");
        chk_count++;
    }

    var customercode = $('#searchCustomerCode').val();
    if (customercode == "" || customercode == undefined) {
        header.push("외주가공처");
        chk_count++;
    }

    var orderqty = data.REMAINQTY;
    if (orderqty == "" || orderqty == undefined) {
        header.push("발주수량");
        chk_count++;
    }

    if (chk_count > 0) {
        extToastView("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
        return;
    }

    var modqty = $('#searchModQty').val();
    var params = [];
    data.CUSTOMERCODE = customercode;
    data.MODQTY = modqty;
    data.OUTPODATE = Ext.util.Format.date(outpodate, 'Y-m-d');
    data.FLAG = 'Y';
    Ext.MessageBox.confirm('발주처리 알림', '발주처리하시겠습니까?', function (btn) {
        if (btn == 'yes') {
            var url = '<c:url value="/update/prod/process/WorkOutOrderRegist.do"/>';
            params.push(data);
            if (params.length > 0) {
                Ext.Ajax.request({
                    url: url,
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    jsonData: {
                        data: params
                    },
                    success: function (conn, response, options, eOpts) {
                        var obj = JSON.parse(conn.responseText);
                        var rscode = obj.result.success;
                        var msgdata = obj.result.MSGDATA;
                        var orgid = $('#orgid').val();
                        var companyid = $('#companyid').val();
                        var outpono = obj.result.data[0].OUTPONO;
                        $('#searchOrgId').val(orgid);
                        $('#searchCompanyId').val(companyid);
                        $('#PoNo').val(outpono);
                        var msg = obj.result.msg;

                        if (rscode == "E") {
                            extToastView("관리자에게 문의하십시오.<br/>" + msgdata);
                            return;
                        } else {
                            extToastView(msg);
                            fn_search_clear();
                            fn_search();
                            fn_print();
                        }
                    },
                    error: ajaxError
                });
            }

        } else {
            extToastView("발주처리가 취소되었습니다.");
            return;
        }
    });
}

function fn_print() {
    var outpono = $('#PoNo').val();
    if (outpono == "" || outpono == undefined) {
        extToastView("선택하신 항목에 발주정보가 없거나, 선택하신 항목이 없습니다.<br/>다시 한번 확인해주세요.");
        return false;
    }

    var column = 'master';
    var url = null;
    var target = '_blank';

    url = "<c:url value='/report/OutOrderReport.pdf'/>";

    fn_popup_url(column, url, target);
}

function fn_add() {
    var model = Ext.create(gridnms["model.1"]);
    var store = Ext.getStore(gridnms["store.1"]);

    var sortorder = 0;
    var listcount = Ext.getStore(gridnms["store.1"]).count();
    for (var i = 0; i < listcount; i++) {
        Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
        var dummy = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

        var dummy_sort = dummy.data.RN * 1;
        if (sortorder < dummy_sort) {
            sortorder = dummy_sort;
        }
    }
    sortorder++;

    model.set("RN", sortorder);

    model.set("ORGID", $("#orgid").val());
    model.set("COMPANYID", $("#companyid").val());
    model.set("SAVEFLAG", "Y");

    var view = Ext.getCmp(gridnms['panel.1']).getView();
    var startPoint = 0;

    store.insert(startPoint, model);
    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], startPoint, 2);
}

function fn_ready() {
    extToastView("준비중입니다...");
    return;
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
            var emptyValue = "";
            //             $("#searchCustomerName").val(emptyValue);
            $("#searchCustomerCode").val(emptyValue);
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
                ORGID: $('#orgid').val(),
                COMPANYID: $('#companyid').val(),
                CUSTOMERTYPE2: 'O',
                CUSTOMERDIV: 'B',
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

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
        <!-- 현재위치 네비게이션 시작 -->
        <div style="margin-top: 0px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
            <div id="" style="width: 100%; padding-left: 0px; ">
                <form id="master" name="master" method="post" onkeydown="return fn_key_break(event, 13)" >
                    <input type="hidden" id="searchOrgId" name="searchOrgId" />
                    <input type="hidden" id="searchCompanyId" name="searchCompanyId" />
                    <input type="hidden" id="PoNo" name="PoNo" />
                    <input type="hidden" id="type" name="type" value="${searchVO.type}" />
                    <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
                    <input type="hidden" id="workdept" name="workdept" value="${searchVO.WORKDEPT}" />
                    <input type="hidden" id="workdeptname" name="workdeptname" value="${pageTitle}" />
                    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
                    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
                    <input type="hidden" id="equipmentcode" name="equipmentcode" value="${EQUIPMENTCODE}"/>
                    <input type="hidden" id="equipmentname" name="equipmentname" value="${EQUIPMENTNAME}" />
                    <input type="hidden" id="worker" name="worker" value="${WORKER}" />
                    <input type="hidden" id="workername" name="workername" value="${WORKERNAME}" />
                    <input type="hidden" id="worker2" name="worker2" value="${WORKER2}" />
                    <input type="hidden" id="worker2name" name="worker2name" value="${WORKER2NAME}" />
                    <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" />
										<c:choose>
                        <c:when test="${searchVO.work == 'Y'}">
                            <div style="width: calc(100% - 200px); height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
<!--                                 <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                         생산실적<br/>( TOUCH ) -->
<!--                                 </button> -->
                                <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                        생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                        래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                        자주검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                        공구변경<br/>( TOOL CHANGE )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                        외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                        반입반출<br/>( STORED & RELEASED )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                        설비변경<br/>( FACILITIES )
                                </button>
                            </div>
                            <div style="width: 200px; height: 65px; margin-top: 0px; margin-right: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: right;">
                                <button type="button" class="yellow " onclick="fn_logout();" style="width: 185px; height: 63px; float: right';">
                                        나가기<br/>( LOGOUT )
                                </button>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="width: 100%; height: 65px; margin-top: 0px; margin-bottom: 15px; background-color: white; border-bottom: 1px solid rgb(225, 227, 233); float: left;">
                                <button type="button" class="btn_work_prev blue3 h " onclick="fn_goHome( );" style="width: 8%; height: 63px; float: left';">
                                        이전화면<br/>( BACK )
                                </button>
<!--                                 <button type="button" class="white h " onclick="fn_goMovePage( 15 );" style="width: 8%; height: 63px; float: left';"> -->
<!--                                         생산실적<br/>( TOUCH ) -->
<!--                                 </button> -->
                                <button type="button" class="white h " onclick="fn_goMovePage( 14 );" style="width: 8%; height: 63px; float: left';">
                                        생산실적<br/>( TOUCH )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 1 );" style="width: 8%; height: 63px; float: left';">
                                        래핑/연마입력<br/>( RESULT )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 10 );" style="width: 10%; height: 63px; float: left';">
                                        자주검사<br/>( CHECK SHEET )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 7 );" style="width: 10%; height: 63px; float: left';">
                                        공구변경<br/>( TOOL CHANGE )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                        외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="white2 h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
                                        반입반출<br/>( STORED & RELEASED )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 11 );" style="width: 8%; height: 63px; float: left';">
                                        설비변경<br/>( FACILITIES )
                                </button>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <table class="blue" style="width: 100%; height:70px; margin-top: 0px; ">
                        <colgroup>
                            <col width="170px">
                            <col width="200px">
                            <col width="210px">
                            <col width="200px">
                            <col width="210px">
                            <col width="200px">
                            <col>
                            <col width="250px">
                            <col>
                            <col>
                            <col>
                            <col>
                        </colgroup>
                        <tbody>
                            <tr>
                              <th style="color: white; font-size:30px; font-weight: bold; text-align: right;">발주일자 :&nbsp;</th>
                              <td>
                                  <input type="text" id="searchOutPoDate" name="searchOutPoDate" class="input_validation input_center"  style="width: 99%; height: 50px;  font-size:25px; vertical-align: middle;" maxlength="10" />
                              </td>
                              <th style="color: white; font-size:30px; font-weight: bold; text-align: right;">외주가공처 :&nbsp;</th>
                              <td>
                                  <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_validation input_left"  style="width: 99%; height: 50px;  font-size:25px; vertical-align: middle;" />
                              </td>
                              <th style="color: white; font-size:30px; font-weight: bold; text-align: right;">수정품(수량) :&nbsp;</th>
                              <td>
                                  <input type="text" id="searchModQty" name="searchModQty" class="input_right"  style="width: 99%; height: 50px;  font-size:25px; vertical-align: middle;" />
                              </td>
                              <td></td>
                              <td>
                                  <center>
		                                  <input type="hidden" id="searchGubun1" value="N" />
		                                  <input type="hidden" id="searchGubun2" value="Y" />
		                                  <button type="button" id="btn_search_n" class="green_selected r shadow" onclick="fn_select_search('N');" style="width: calc(50% - 18px); height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">미발주</button>
		                                  <button type="button" id="btn_search_y" class="green r shadow" onclick="fn_select_search('Y');" style="width: calc(50% - 18px); height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">발주</button>
                                      <!-- <label style="width:calc(50% - 18px); height: 50px; font-size: 25px; color: white; vertical-align: middle; padding-top: 8px; " >
                                          <input type="radio" id="searchGubun1" name="searchGubun" class="input_left" value="N" checked="checked" /> 미발주
                                      </label>
                                      <label style="width:calc(50% - 18px); height: 50px; font-size: 25px; color: white; vertical-align: middle; padding-top: 8px; " >
                                          <input type="radio" id="searchGubun2" name="searchGubun" class="input_left" value="Y"  /> 발주
                                      </label> -->
                                  </center>
                              </td>
                              <!-- <td style="padding-left: 10px; padding-right: 5px;">
                                  <button type="button" id="btn_search" class="blue2 r shadow" onclick="fn_search();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">조회</button>
                              </td> -->
                              <td style="padding-left: 5px; padding-right: 5px;">
                                  <button type="button" id="btn_checkall" class="blue2 r shadow" onclick="fn_check_all();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">일괄선택</button>
                              </td>
                              <td style="padding-left: 5px; padding-right: 5px;">
                                  <button type="button" id="btn_save" class="blue2 r shadow" onclick="fn_save_all();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">일괄저장</button>
                              </td>
                              <td style="padding-left: 5px; padding-right: 5px;">
                                  <button type="button" id="btn_add" class="blue2 r shadow" onclick="fn_add();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">추가</button>
                              </td>
                              <td style="padding-left: 5px; padding-right: 15px;">
                                  <button type="button" id="btn_pdf" class="blue2 r shadow" onclick="fn_print();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">반출증</button>
                              </td>
                            </tr>
                        </tbody>
                    </table>
                    <div id="gridArea" style="width: 100%; margin-top: 0px; margin-bottom: 0px; float: left;"></div>
								</form>
            </div>
        </div>
        <!-- //content 끝 -->
    <!-- //전체 레이어 끝 -->
<div id="loadingBar" style="display: none;">
    <img src='<c:url value="/images/spinner.gif"></c:url>' alt="Loading"/>
</div>
</body>
</html>