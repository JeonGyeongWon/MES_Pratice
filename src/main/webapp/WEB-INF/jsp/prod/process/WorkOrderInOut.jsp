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

.x-column-header-text {
	padding-top: 5px;
	padding-bottom: 5px;
}

.ERPQTY  .x-column-header-text {
	margin-right: 0px;
}

.FML .x-grid-cell-inner {
	padding-left: 0px;
	padding-right: 0px;
}

.x-grid-cell-inner {
	position: relative;
	text-overflow: ellipsis;
	padding-top: 8px;
	padding-left: 10px;
	height: 45px;
	font-size: 18px !important;
	font-weight: bold;
}

.x-btn {
	margin-top: 2px;
	height: 39px;
}

.btn_mid {
	vertical-align: middle;
	text-align: center;
}

.x-btn-inner {
	font-size: 14px !important;
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

.white_selected:hover {
  background-color: #FFFFFF;
  border-bottom: 4px solid #5B9BD5;
}

.white_selected {
  overflow: hidden;
  background-color: #FFFFFF;
  color: #5B9BD5 !important;
  font-weight: bold;
  font-size: 16px;
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

.gray:HOVER {
	background-color: #d8d8d8;
}

.gray {
	background-color: #e1e1e1;
	color: black;
}

.green:HOVER {
	background-color: #CEFBC9;
}

.green {
	background-color: #B7F0B1;
	color: black;
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

.F1 a:link {
	color: white;
	text-decoration: none;
}

.F1 a:visited {
	color: black;
	text-decoration: none;
}

.F1 a:hover {
	color: white;
	text-decoration: underline;
}
</style>
<script type="text/javaScript">
var groupid = "${searchVO.groupId}";
var gridnms = {};
var fields = {};
var items = {};
var btnCnt = true;
$(document).ready(function () {
  setInitial();

  setValues();
  setExtGrid();

  $("#tradeLot").focus();

  setReadOnly();

  setLovList();
});

function setInitial() {
  gridnms["app"] = "prod";

  calender($('#searchDateFrom, #searchDateTo'));

  $('#searchDateFrom, #searchDateTo').keyup(function (event) {
    if (event.keyCode != '8') {
      var v = this.value;
      if (v.length === 4) {
        this.value = v + "-";
      } else if (v.length === 7) {
        this.value = v + "-";
      }
    }
  });

  $("#searchDateFrom").val(getToDay("${searchVO.datesys}") + "");
  $("#searchDateTo").val(getToDay("${searchVO.datesys}") + "");

  var workdept = "${searchVO.workdept}";
  var groupid = "${searchVO.groupId}";
  if (groupid != "ROLE_ADMIN") {
    if (workdept == "12") {
      $('#searchGubun').val("OUT");
      $("#searchGubun").attr("disabled", true);
      $('#btn_checkall').hide();
    } else if (workdept == "3") {

      $("#searchDateFrom").val(getToDay("${searchVO.dateFrom}") + "");
      $("#searchDateTo").val(getToDay("${searchVO.datesys}") + "");
      $('#searchGubun').val("IN");
      $("#searchGubun").attr("disabled", true);
      $('#btn_add').hide();
    } else {
      $('#searchGubun').val("");
      $("#searchGubun").attr("disabled", true);
      $('#btn_add').hide();
      $('#btn_checkall').hide();
      $('#btn_save').hide();
    }
  }
}

function setValues() {
  setValues_list();
}

function setValues_list() {

  gridnms["models.list"] = [];
  gridnms["stores.list"] = [];
  gridnms["views.list"] = [];
  gridnms["controllers.list"] = [];

  gridnms["grid.1"] = "WarehousingRegist";
  gridnms["grid.2"] = "modelLov";
  gridnms["grid.3"] = "outTypeLov";
  gridnms["grid.4"] = "itemstandarddetailLov";

  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
  gridnms["views.list"].push(gridnms["panel.1"]);

  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
  gridnms["controllers.list"].push(gridnms["controller.1"]);

  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];
  gridnms["model.3"] = gridnms["app"] + ".model." + gridnms["grid.3"];
  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];

  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];
  gridnms["store.3"] = gridnms["app"] + ".store." + gridnms["grid.3"];
  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];

  gridnms["models.list"].push(gridnms["model.1"]);
  gridnms["models.list"].push(gridnms["model.2"]);
  gridnms["models.list"].push(gridnms["model.3"]);
  gridnms["models.list"].push(gridnms["model.4"]);

  gridnms["stores.list"].push(gridnms["store.1"]);
  gridnms["stores.list"].push(gridnms["store.2"]);
  gridnms["stores.list"].push(gridnms["store.3"]);
  gridnms["stores.list"].push(gridnms["store.4"]);

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
      type: 'date',
      name: 'OUTDATE',
      dateFormat: 'Y-m-d',
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
      name: 'OUTTYPE',
    }, {
      type: 'string',
      name: 'OUTTYPENAME',
    }, {
      type: 'number',
      name: 'OUTQTY',
    }, {
      type: 'number',
      name: 'INQTY',
    }, {
      type: 'date',
      name: 'INDATE',
      dateFormat: 'Y-m-d',
    }, ];

  fields["columns.1"] = [{
      dataIndex: 'RN',
      text: '순번',
      xtype: 'gridcolumn',
      width: 60,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'OUTDATE',
      text: '반출일자',
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
        height: 40,
        format: 'Y-m-d',
        altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
      },
      renderer: function (value, meta, record) {

        return Ext.util.Format.date(value, 'Y-m-d');
      },
    }, {
      dataIndex: 'ITEMNAME',
      text: '품명',
      xtype: 'gridcolumn',
      width: 300,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "left",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
        height: 40,
      }
    }, {
      dataIndex: 'ORDERNAME',
      text: '품번',
      xtype: 'gridcolumn',
      width: 205,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
    }, {
      dataIndex: 'MODELNAME',
      text: '기종',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.2"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 40,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            model.set("MODEL", record.data.VALUE);

            var sparams = {
              ORGID: model.data.ORGID,
              COMPANYID: model.data.COMPANYID,
              MODEL: record.data.VALUE,
              ITEMNAME: model.data.ITEMNAME,
            };

            extGridSearch(sparams, gridnms["store.4"]);

          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 180, // 250,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 40px; font-size: 13px;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
    }, {
      dataIndex: 'ITEMSTANDARDDETAIL',
      text: '타입',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.4"],
        valueField: "VALUE",
        displayField: "VALUE",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 40,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 180, // 250,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 40px; font-size: 13px;">{VALUE}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
    }, {
      dataIndex: 'OUTTYPENAME',
      text: '유형',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.3"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        transform: 'stateSelect',
        height: 40,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            model.set("OUTTYPE", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 150, // 250,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<tr>'
             + '<td style="height: 40px; font-size: 13px;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
    }, {
      dataIndex: 'OUTQTY',
      text: '반출수량',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      editor: {
        xtype: "textfield",
        format: "0,000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '9',
        maskRe: /[0-9]/,
        selectOnFocus: true,
        height: 40,
      },
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {

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
      dataIndex: 'MODEL',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMTYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKINID',
      xtype: 'hidden',
    }, ];

  var workdept = "${searchVO.workdept}";
  var groupid = "${searchVO.groupId}";

  if (workdept == "3" || groupid == "ROLE_ADMIN") {
    fields["columns.1"].push({
      dataIndex: 'INDATE',
      text: '반입일자',
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
        height: 40,
        format: 'Y-m-d',
        altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
      },
      renderer: function (value, meta, record) {

        return Ext.util.Format.date(value, 'Y-m-d');
      },
    }, {
      dataIndex: 'INQTY',
      text: '반입수량',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      editor: {
        xtype: "textfield",
        format: "0,000",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: '9',
        maskRe: /[0-9]/,
        selectOnFocus: true,
        height: 40,
      },
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {

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
        var itemcode = record.data.ITEMCODE;
        var workinid = record.data.WORKINID + "";
        if (itemcode != "" && workinid == "null") {
          meta['tdCls'] = '';
        } else {
          meta['tdCls'] = 'x-item-disabled';
        }
        return new Ext.ux.CheckColumn().renderer(value);
      },
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
        _btnText: "반입처리",
        defaultBindProperty: null,
        handler: function (widgetColumn) {
          var record = widgetColumn.getWidgetRecord();

          fn_save_in(record.data);
        },
        listeners: {
          beforerender: function (widgetColumn) {
            var record = widgetColumn.getWidgetRecord();
            widgetColumn.setText(widgetColumn._btnText);
          }
        }
      },
      onWidgetAttach: function (col, widget, rec) {
        // 버튼 활성화/비활성화
        var itemcode = rec.data.ITEMCODE;
        var workinid = rec.data.WORKINID + "";

        if (itemcode != "" && workinid == "null") {
          widget.setDisabled(false);
        } else {
          widget.setDisabled(true);
        }
        col.mon(col.up('gridpanel').getView(), {
          itemupdate: function () {
            var itemcode = rec.data.ITEMCODE;
            var workinid = rec.data.WORKINID + "";
            if (itemcode != "" && workinid == "null") {
              widget.setDisabled(false);
            } else {
              widget.setDisabled(true);
            }
          }
        });
      },
    })
  }

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/prod/process/WorkOrderInOut.do' />"
  });
  $.extend(items["api.1"], {
    create: "<c:url value='/insert/prod/process/WorkOrderInOut.do' />"
  });
  $.extend(items["api.1"], {
    update: "<c:url value='/update/prod/process/WorkOrderInOut.do' />"
  });

  items["btns.1"] = [];

  items["btns.ctr.1"] = {};
  $.extend(items["btns.ctr.1"], {
    "#WorkOrderInOutList": {
      cellclick: 'InOutListSelectClick'
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

var gridarea1;
function setExtGrid() {
  setExtGrid_list();

  Ext.EventManager.onWindowResize(function (w, h) {
    gridarea1.updateLayout();
  });
}

function InOutListSelectClick(grid, cell, columnIndex, record, node, rowIndex, evt) {
  var text = grid.getHeaderCt().getHeaderAtIndex(columnIndex).dataIndex;

  var chk = record.data.CHK;
  var gubun = $('#searchGubun').val();
  var itemcode = record.data.ITEMCODE;
  var qty = record.data.INQTY;
  var indate = record.data.INDATE;
  var workinid = record.data.WORKINID + "";

  var sparams = {
    ORGID: record.data.ORGID,
    COMPANYID: record.data.COMPANYID,
    MODEL: record.data.MODEL,
    ITEMNAME: record.data.ITEMNAME,
  };

  extGridSearch(sparams, gridnms["store.4"]);

  if (text == "CHK") {
    if (itemcode != "" && workinid == "null") {
      if (chk) {
        if (qty == 0) {
          record.set("INQTY", record.data.OUTQTY);
        }
        if (indate == null) {
          record.set("INDATE", getToDay("${searchVO.datesys}") + "");
        }
      } else {
        record.set("INQTY", "");
        record.set("INDATE", "");
      }

    }
  }

}

function setExtGrid_list() {

  Ext.define(gridnms["model.1"], {
    extend: Ext.data.Model,
    fields: fields["model.1"],
  });
  Ext.define(gridnms["model.2"], {
    extend: Ext.data.Model,
    fields: fields["model.2"],
  });
  Ext.define(gridnms["model.3"], {
    extend: Ext.data.Model,
    fields: fields["model.3"],
  });
  Ext.define(gridnms["model.4"], {
    extend: Ext.data.Model,
    fields: fields["model.4"],
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
                ORGID: $("#orgid").val(),
                COMPANYID: $("#companyid").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'MODEL',
                ATTRIBUTE1: 'Y',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["store.3"], {
    extend: Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.3"],
            model: gridnms["model.3"],
            autoLoad: false,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#orgid").val(),
                COMPANYID: $("#companyid").val(),
                BIGCD: 'MFG',
                MIDDLECD: 'OUT_TYPE',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
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
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              url: "<c:url value='/searchItemstandarddetailLov.do' />",
              extraParams: {
                ORGID: $("#orgid").val(),
                COMPANYID: $("#companyid").val(),

              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.1"], {
    extend: Ext.app.Controller,
    refs: {
      WorkOrderInOutList: '#WorkOrderInOutList',
    },
    stores: [gridnms["store.1"]],
    control: items["btns.ctr.1"],

    InOutListSelectClick: InOutListSelectClick,
  });

  Ext.define(
    gridnms["panel.1"], {
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
        height: 787,
        border: 2,
        scrollable: true,
        columns: fields["columns.1"],
        defaults: gridVals.defaultField,
        plugins: [{
            ptype: 'bufferedrenderer',
            trailingBufferZone: 20, // #1
            leadingBufferZone: 20, // #2
            synchronousRender: false,
            numFromEdge: 19,
          }
        ],
        viewConfig: {
          itemId: 'WorkOrderInOutList',
          trackOver: true,
          loadMask: true,
          striptRows: true,
          forceFit: true,
          listeners: {
            refresh: function (dataView) {}
          },
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
            listeners: {
              "beforeedit": function (editor, ctx, eOpts) {
                var data = ctx.record;

                var editDisableCols = [];
                var itemcode = data.data.ITEMCODE;
                var workinid = data.data.WORKINID;
                if (itemcode != "") {
                  editDisableCols.push("ITEMNAME");
                  editDisableCols.push("MODELNAME");
                  editDisableCols.push("ITEMSTANDARDDETAIL");
                  editDisableCols.push("OUTTYPENAME");
                  editDisableCols.push("OUTDATE");
                  //editDisableCols.push("OUTQTY");
                }
                if (workinid != null) {
                  editDisableCols.push("INDATE");
                  editDisableCols.push("INQTY");
                }

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
      gridarea1 = Ext.create(gridnms["views.list"], {
          renderTo: 'gridArea'
        });
    },
  });
}

function fn_add() {

  var gubun = $('#searchGubun').val();
  if (gubun == "IN") {
    return;
  }

  var model = Ext.create(gridnms["model.1"]);
  var store = Ext.getStore(gridnms["store.1"]);

  model.set("RN", 0);
  model.set("ORGID", $("#orgid").val());
  model.set("COMPANYID", $("#companyid").val());
  model.set("ITEMNAME", "SWASH PLATE");
  model.set("OUTDATE", getToDay("${searchVO.datesys}") + "");

  store.insert(0, model);
}

function fn_search() {
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var searchGubun = $('#searchGubun').val();
  var searchDateFrom = $('#searchDateFrom').val();
  var searchDateTo = $('#searchDateTo').val();

  var searchModelName = $('#searchModelName').val();
  var searchItemstandarddetail = $('#searchItemstandarddetail').val();

  var sparams = {
    ORGID: orgid,
    COMPANYID: companyid,
    OUTFROM: searchDateFrom,
    OUTTO: searchDateTo,
    MODELNAME: searchModelName,
    ITEMSTANDARDDETAIL: searchItemstandarddetail,
    GUBUN: searchGubun,
  };

  extGridSearch(sparams, gridnms["store.1"]);
  isChecked = true;
}

var isChecked = true;
function fn_check_all(o, e) {

  var recount = Ext.getStore(gridnms["store.1"]).count();
  var chkcount = 0;
  for (var i = 0; i < recount; i++) {
    var model = Ext.getStore(gridnms["store.1"]).getAt(i);

    var itemcode = model.data.ITEMCODE;
    var qty = model.data.INQTY;
    var indate = model.data.INDATE;
    var workinid = model.data.WORKINID + "";

    if (itemcode != "" && workinid == "null") {
      if (isChecked) {
        model.set("CHK", true);
        if (qty == 0) {
          model.set("INQTY", model.data.OUTQTY);
        }
        if (indate == null) {
          model.set("INDATE", getToDay("${searchVO.datesys}") + "");
        }
        chkcount++;
      } else {
        model.set("CHK", false);
        model.set("INQTY", "");
        model.set("INDATE", "");
      }
    }
  }

  if (isChecked) {
    isChecked = false;
  } else {
    isChecked = true;
  }
}

function fn_save_in(record) {
  var orgid = record.ORGID;
  var companyid = record.COMPANYID;
  var indate = record.INDATE + "";
  var inqty = record.INQTY + "";
  var count = 0;
  var header = [];

  Ext.MessageBox.confirm('반입처리 알림', '반입처리하시겠습니까?', function (btn) {
    if (btn == 'yes') {

      if (inqty.length == 0 || inqty == "0") {
        header.push("반입수량");
        count++;
      }
      if (indate.length == 0) {
        header.push("반출일자");
        count++;
      }
      if (count > 0) {
        extAlert("[필수항목 미입력]<br/>" + header + " 항목이 누락되었습니다.");
        return;
      }

      var url = '<c:url value="/insert/prod/process/WorkOrderInOut.do"/>';
      var params = [];
      params.push(record);

      Ext.Ajax.request({
        url: url,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        jsonData: {
          data: params
        },
        success: function (batch, options) {

          extAlert("반입 완료되었습니다.");
          dataSuccess = 1;

          if (dataSuccess > 0) {
            fn_search();
          }
        },
        failure: function (conn, response, options, eOpts) {
          extAlert("해당하는 품목이 없습니다.");
        },
        error: ajaxError
      });

    } else {
      extToastView("취소되었습니다.");
      return;
    }
  });
}

function fn_save_all() {
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var count = Ext.getStore(gridnms["store.1"]).count();

  Ext.MessageBox.confirm('저장 알림', '저장하시겠습니까?', function (btn) {
    if (btn == 'yes') {

      var recount = Ext.getStore(gridnms["store.1"]).count();
      var url = '<c:url value="/insert/prod/process/WorkOrderInOut.do"/>';
      var params = [];
      for (var i = 0; i < recount; i++) {
        var model = Ext.getStore(gridnms["store.1"]).getAt(i);

        if (model.get("RN") == 0) {
          if (model.data.ITEMNAME + "" == "") {
            extAlert("품명을 입력해주세요.");
            return;
          } else if (model.data.MODEL + "" == "") {
            extAlert("기종을 입력해주세요.");
            return;
          } else if (model.data.ITEMSTANDARDDETAIL + "" == "") {
            extAlert("타입을 입력해주세요.");
            return;
          } else if (model.data.OUTTYPE + "" == "") {
            extAlert("유형을 입력해주세요.");
            return;
          } else if (model.data.OUTDATE + "" == "") {
            extAlert("반출일자를 입력해주세요.");
            return;
          } else if (model.data.OUTQTY + "" == "") {
            extAlert("반출수량을 입력해주세요.");
            return;
          }
        } else {
          if (model.data.OUTQTY + "" == "") {
            extAlert("반출수량을 입력해주세요.");
            return;
          }
        }

        if (model.get("RN") == 0 || model.get("CHK") == true) {
          params.push(model.data);
        }
      }
      dataSuccess = 1;

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

            var jsonResp = Ext.JSON.decode(conn.responseText);
              if (jsonResp.result.success) {
                extAlert(" 완료되었습니다.");
                dataSuccess = 1;

                fn_search();
              } else {
                extAlert("해당하는 품목이 없습니다.");
              }

          },
          failure: function (conn, response, options, eOpts) {
            extAlert("해당하는 품목이 없습니다.");
          },
          error: ajaxError
        });
      }

    } else {
      extToastView("저장이 취소되었습니다.");
      return;
    }
  });
}

function fn_save() {
  Ext.getStore(gridnms["store.1"]).sync({
    success: function (batch, options) {

      Ext.getStore(gridnms['store.1']).load();

    },
    failure: function (batch, options) {
      extToastView(batch.exceptions[0].error);
    },
    callback: function (batch, options) {},
  });
}

function fn_goHome() {
  go_url('<c:url value="/prod/process/ProcessStart.do" />');
}

function fn_logout() {
    localStorage.clear();
    go_url('<c:url value="/uat/uia/actionLogout.do" />');
}

function fn_ready() {
  extToastView("준비중입니다...");
  return;
}

function setLovList() {
  //
}

function setReadOnly() {
  $("[readonly]").addClass("ui-state-disabled");
}

function fn_goMovePage(flag) {
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
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false" style="height: auto;" auto-config="true" use-expressions="true">
    <!-- 전체 레이어 시작 -->
        <!-- 현재위치 네비게이션 시작 -->
        <div style="margin-top: 0px; float: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">
            <div style="width: 100%; padding-left: 0px; ">
                <form id="master" name="master" method="post" onkeydown="return fn_key_break(event, 13)" >
                    <input type="hidden" id="orgid" name="orgid" value="${searchVO.ORGID}" />
                    <input type="hidden" id="companyid" name="companyid" value="${searchVO.COMPANYID}" />
                    <input type="hidden" id="workdept" name="workdept" value="${searchVO.workdept}" />
                    <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
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
                                <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                        외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
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
                                <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
                                        외주입고<br/>( REGISTER )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 13 );" style="width: 11%; height: 63px; float: left';">
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
				                    <col width="160px">
                            <col width="425px">
				                    <col width="100px">
                            <col width="160px">
				                    <col width="100px">
                            <col width="140px">
                            <col width="100px">
                            <col width="120px">
                            <col>
                            <col>
                            <col>
                            <col>
                            <col>
		                    </colgroup>
		                    <tbody>
			                      <tr>
			                        <th style="color: white; font-size:30px; font-weight: bold; text-align: right;">반출일자 :&nbsp;</th>
                              <td>
                                  <input type="text" id="searchDateFrom" name="searchDateFrom" class="input_center" style="width:180px; height: 50px; font-size: 25px; margin-left: 0px; margin-right: 0px; margin-top: 0px; margin-bottom: 0px;" />
                                 <a style="color: white; font-size: 30px; font-weight: bold; vertical-align: middle;">&nbsp;~&nbsp;</a>
                                  <input type="text" id="searchDateTo" name="searchDateTo" class="input_center" style="width: 180px; height: 50px; font-size: 25px;  margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; "  />
			                        </td>
			                        <th style="color: white; font-size:30px; font-weight: bold; text-align: right;">기종 :&nbsp;</th>
                              <td>
			                            <input type="text" id="searchModelName" name="searchModelName" class="input_left"  style="width: 99%; height: 50px; font-size:25px; vertical-align: middle;" />
			                        </td>
                              <th style="color: white; font-size:30px; font-weight: bold; text-align: right;">타입 :&nbsp;</th>
                              <td>
                                  <input type="text" id="searchItemstandarddetail" name="searchItemstandarddetail" class="input_left"  style="width: 99%; height: 50px; font-size:25px; vertical-align: middle;" />
                              </td>
			                        <th style="color: white; font-size:30px; font-weight: bold; text-align: right;">구분 :&nbsp;</th>
                              <td>
			                            <select id="searchGubun" name="searchGubun" class="input_left " style="width:99%; height: 50px; font-size: 25px; vertical-align: middle;" readonly>
                                      <option value="OUT" >반출</option>
		                                  <option value="IN">반입</option>
                                  </select>
			                        </td>
                              <td style="padding-left: 10px; padding-right: 5px;">
                                  <button type="button" id="btn_add" class="blue2 r shadow" onclick="fn_add();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">추가</button>
                              </td>
                              <td style="padding-left: 10px; padding-right: 0px;">
			                            <button type="button" id="btn_search" class="blue2 r shadow" onclick="fn_search();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">조회</button>
                              </td>
                              <td style="padding-left: 10px; padding-right: 0px;">
                                  <button type="button" id="btn_checkall" class="blue2 r shadow" onclick="fn_check_all();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">일괄선택</button>
                              </td>
                              <td style="padding-left: 10px; padding-right: 0px;">
                                  <button type="button" id="btn_save" class="blue2 r shadow" onclick="fn_save_all();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">일괄저장</button>
                              </td>
                              <td style="padding-left: 10px; padding-right: 10px;">
                                  <button type="button" id="btn_checkall" class="blue2 r shadow" onclick="fn_save();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">수정</button>
                              </td>
			                      </tr>
		                    </tbody>
                    </table>
                    </center>
                    <div id="gridArea" style="width: 100%; padding-bottom: 0px; padding-top: 0px; float: left;"></div>
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