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
  
//   $('input[type=radio][name="searchGubun"]').on("ifChanged", function() {
// 	  var value = $(this).val();
// 	  if ( value != global_check ) {
// 		    if ( value != "" || value != undefined ) {
// 		        fn_search();
// 		      }
// 		  global_check = value;
// 	  }
//   });
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
  setTimeout(function() {
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

  gridnms["grid.1"] = "WarehousingRegist";
  gridnms["grid.5"] = "TransPersonLov";
  gridnms["grid.6"] = "faultTypeLov";

  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
  gridnms["views.list"].push(gridnms["panel.1"]);

  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
  gridnms["controllers.list"].push(gridnms["controller.1"]);

  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];

  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];

  gridnms["models.list"].push(gridnms["model.1"]);
  gridnms["models.list"].push(gridnms["model.5"]);
  gridnms["models.list"].push(gridnms["model.6"]);

  gridnms["stores.list"].push(gridnms["store.1"]);
  gridnms["stores.list"].push(gridnms["store.5"]);
  gridnms["stores.list"].push(gridnms["store.6"]);

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
      name: 'PODATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'PONO',
    }, {
      type: 'number',
      name: 'POSEQ',
    }, {
      type: 'string',
      name: 'WORKORDERID',
    }, {
      type: 'number',
      name: 'WORKORDERSEQ',
    }, {
      type: 'string',
      name: 'CUSTOMERCODE',
    }, {
      type: 'string',
      name: 'CUSTOMERNAME',
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
      type: 'number',
      name: 'ROUTINGID',
    }, {
      type: 'string',
      name: 'ROUTINGOP',
    }, {
      type: 'string',
      name: 'ROUTINGNAME',
    }, {
      type: 'number',
      name: 'ORDERQTY',
    }, {
      type: 'number',
      name: 'TRANSQTY',
    }, {
      type: 'number',
      name: 'NOWTRANSQTY',
    }, {
      type: 'number',
      name: 'REMAINQTY',
    }, {
      type: 'string',
      name: 'TRADENO',
    }, {
      type: 'string',
      name: 'TRANSPERSON',
    }, {
      type: 'string',
      name: 'TRANSPERSONNAME',
    }, ];

  fields["model.5"] = [{
      type: 'string',
      name: 'LABEL',
    }, {
      type: 'string',
      name: 'VALUE',
    }, ];

  fields["model.6"] = [{
      type: 'string',
      name: 'LABEL',
    }, {
      type: 'string',
      name: 'VALUE',
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
      dataIndex: 'CUSTOMERNAME',
      text: '거래처',
      xtype: 'gridcolumn',
      width: 350,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
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
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'DRAWINGNO',
      text: '도번',
      xtype: 'gridcolumn',
      width: 180,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
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
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'MODELNAME',
      text: '기종',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'ITEMSTANDARDDETAIL',
      text: '타입',
      xtype: 'gridcolumn',
      width: 50,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'ROUTINGOP',
      text: '공정순번',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'ROUTINGNAME',
      text: '공정명',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'ORDERQTY',
      text: '발주<br/>수량',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'TRANSQTY',
      text: '기입고<br/>수량',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'NOWTRANSQTY',
      text: '당일입고<br/>수량',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'REMAINQTY',
      text: '입고<br/>수량',
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
        height: 45,
      },
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        var qty = value * 1;
        if (qty == 0) {
          meta.style = " background-color: rgb(234, 234, 234); ";
        }
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'TRANSPERSONNAME',
      text: '입고담당자',
      xtype: 'gridcolumn',
      width: 150,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.5"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'local', // 'local',
        allowBlank: true,
        forceSelection: false,
        height: 45,
        triggerCls: 'trigger-combobox-custom',
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

            model.set("TRANSPERSON", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '<span style="height: 45px; font-size: 18px; font-weight: bold;">등록되지 않았습니다.<br/>관리자에게 문의해주세요.</span>',
          width: 600, // 330,
          getInnerTpl: function () {
            return '<div>'
             + '<table>'
             + '<colgroup>'
             + '<col width="150px">'
             + '<col>'
             + '</colgroup>'
             + '<tr>'
             + '<td style="height: 45px; font-size: 18px; font-weight: bold;">{LABEL}</td>'
             + '</tr>'
             + '</table>'
             + '</div>';
          }
        },
      },
    }, {
      dataIndex: 'CON1',
      text: '소재',
      xtype: 'gridcolumn',
      width: 50,
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
        height: 45,
      },
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        var qty = value * 1;
        if (qty == 0) {
          meta.style = " background-color: rgb(234, 234, 234); ";
        }
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'CON9',
      text: '외주',
      xtype: 'gridcolumn',
      width: 50,
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
        height: 45,
      },
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        var qty = value * 1;
        if (qty == 0) {
          meta.style = " background-color: rgb(234, 234, 234); ";
        }
        return Ext.util.Format.number(value, '0,000');
      },
    },
    {
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
              extToastView("이미 입고처리된 건입니다.<br/>다시 한번 확인해주세요.");
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
        _btnText: "입고처리",
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
      onWidgetAttach: function (col, widget, rec) {
        // 버튼 활성화/비활성화
        var qty = rec.data.REMAINQTY * 1;
        if (qty > 0) {
          widget.setDisabled(false);
        } else {
          widget.setDisabled(true);
        }
        col.mon(col.up('gridpanel').getView(), {
          itemupdate: function () {
            var qty1 = rec.data.REMAINQTY * 1;
            if (qty1 > 0) {
              widget.setDisabled(false);
            } else {
              widget.setDisabled(true);
            }
          }
        });
      },
    }, {
      dataIndex: 'PONO',
      text: '발주번호',
      xtype: 'gridcolumn',
      width: 170,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'POSEQ',
      text: '발주<br/>순번',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
        return value;
      },
    }, {
      dataIndex: 'WORKORDERID',
      text: '작지번호',
      xtype: 'gridcolumn',
      width: 170,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center',
      align: "center",
      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
        meta.style = " background-color: rgb(234, 234, 234); ";
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
      dataIndex: 'TABLEGUBUN',
      xtype: 'hidden',
    }, {
      dataIndex: 'PODATE',
      xtype: 'hidden',
    }, {
      dataIndex: 'WORKORDERSEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'CUSTOMERCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'TRADENO',
      xtype: 'hidden',
    }, {
      dataIndex: 'TRANSPERSON',
      xtype: 'hidden',
    }, {
      dataIndex: 'ROUTINGGROUP',
      xtype: 'hidden',
    }, {
      dataIndex: 'FAULTTYPE',
      xtype: 'hidden',
    },

  ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/prod/process/WarehousingRegist.do' />"
  });

  items["btns.1"] = [];

  items["btns.ctr.1"] = {};
  $.extend(items["btns.ctr.1"], {
    "#WarehousingList": {
      itemclick: 'WarehousingSelectClick'
    }
  });
  $.extend(items["btns.ctr.1"], {
    "#WarehousingList": {
      cellclick: 'WarehousingCellClick'
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

function WarehousingSelectClick(dataview, record, item, index, e, eOpts) {
  Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(index));

};

function WarehousingCellClick(grid, cell, columnIndex, record, node, rowIndex, evt) {
  var text = grid.getHeaderCt().getHeaderAtIndex(columnIndex).dataIndex;
  var gubun = global_check; // $(':radio[name="searchGubun"]:checked').val();
  var chk = record.data.CHK;

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

  Ext.define(gridnms["model.5"], {
    extend: Ext.data.Model,
    fields: fields["model.5"],
  });

  Ext.define(gridnms["model.6"], {
    extend: Ext.data.Model,
    fields: fields["model.6"],
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
              url: "<c:url value='/searchWorkerLov.do' />",
              timeout: gridVals.timeout,
              extraParams: {
                ORGID: $('#orgid').val(),
                COMPANYID: $('#companyid').val(),
                INSPECTORTYPE: '10', // 관리직 검색
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
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $('#orgid').val(),
                COMPANYID: $('#companyid').val(),
                ORGID: $('#orgid').val(),
                COMPANYID: $('#companyid').val(),
                BIGCD: 'MFG',
                MIDDLECD: 'FAULT_TYPE',
                ATTRIBUTE4: 'Y'
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.1"], {
    extend: Ext.app.Controller,
    refs: {
      WarehousingList: '#WarehousingList',
    },
    stores: [gridnms["store.1"]],
    control: items["btns.ctr.1"],

    WarehousingSelectClick: WarehousingSelectClick,
    WarehousingCellClick: WarehousingCellClick,
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
          itemId: 'WarehousingList',
          trackOver: true,
          loadMask: true,
          striptRows: true,
          forceFit: true,
          listeners: {
            refresh: function (dataView) {
              Ext.each(dataView.panel.columns, function (column) {
                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('DRAWINGNO') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 80) {
                    column.width = 80;
                  }
                }
                if (column.dataIndex.indexOf('TRANSPERSONNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 130) {
                    column.width = 130;
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

                var qty = data.data.REMAINQTY * 1;
                if (qty == 0) {
                  editDisableCols.push("REMAINQTY");
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

function fn_search() {
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var customername = $('#searchCustomerName').val();
  var gubun = global_check; // $(':radio[name="searchGubun"]:checked').val();
  var tradeno = "";

  var sparams = {
    ORGID: orgid,
    COMPANYID: companyid,
    CUSTOMERNAME: customername,
    GUBUN: gubun,
    TRADENO: tradeno,
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

  var gubun = global_check; // $(':radio[name="searchGubun"]:checked').val();
  if (gubun == "Y") {
    if (chkcount == 0) {
      if (recount > 0) {
        extToastView("이미 입고처리된 건은 선택하실 수 없습니다.<br/>다시 한번 확인해주십시오.");
      } else {
        extToastView("조회된 데이터가 없습니다.<br/>다시 한번 확인해주십시오.");
      }
    }
  }

  if (isChecked) {
    isChecked = false;
  } else {
    isChecked = true;
  }
}

function fn_save(record) {
  var orgid = record.ORGID;
  var companyid = record.COMPANYID;
  Ext.MessageBox.confirm('입고처리 알림', '입고처리하시겠습니까?', function (btn) {
    if (btn == 'yes') {

      var params = {
        ORGID: orgid,
        COMPANYID: companyid,
      };

      var url = '<c:url value="/insert/prod/process/createTransNoList.do"/>';
      $.ajax({
        url: url,
        type: 'post',
        async: false,
        data: params,
        success: function (data) {}
      }).done(function (data) {
        // 호출 성공시
        var transno = data.TRANSNO;
        var pono = record.PONO;
        var poseq = record.POSEQ;
        var transqty = record.REMAINQTY;
        var tablegubun = record.TABLEGUBUN;
        var transperson = record.TRANSPERSON;

        var params1 = {
          ORGID: orgid,
          COMPANYID: companyid,
          PONO: pono,
          POSEQ: poseq,
          TRANSNO: transno,
          TRANSQTY: transqty,
          TABLEGUBUN: tablegubun,
          TRANSPERSON: transperson,
          CON1: record.CON1,
          CON9: record.CON9,
        };

        var url1 = '<c:url value="/pkg/prod/process/WarehousingRegist.do"/>';
        $.ajax({
          url: url1,
          type: 'post',
          async: false,
          data: params1,
          success: function (data) {}
        }).done(function (data) {
          // 호출 성공시
          var rscode = data.RETURNSTATUS;
          var errmsg = data.MSGDATA;

          extToastView("[확인]<br/>" + errmsg);

          if (rscode == "S") {
            fn_search();
          }

          isChecked = true;
        });
      });

    } else {
      extToastView("입고처리가 취소되었습니다.");
      return;
    }
  });
}

function fn_save_all() {
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var count = Ext.getStore(gridnms["store.1"]).count();
  var msg_status = "",
  msg_true = "",
  msg_false = "";
  var chk_count = 0;
  Ext.MessageBox.confirm('입고처리 알림', '입고처리하시겠습니까?', function (btn) {
    if (btn == 'yes') {

      var params = {
        ORGID: orgid,
        COMPANYID: companyid,
      };

      var url = '<c:url value="/insert/prod/process/createTransNoList.do"/>';
      $.ajax({
        url: url,
        type: 'post',
        async: false,
        data: params,
        success: function (data) {}
      }).done(function (data) {
        // 호출 성공시
        var transno = data.TRANSNO;

        for (var i = 0; i < count; i++) {
          var model = Ext.getStore(gridnms["store.1"]).getAt(i);
          if (model.data.CHK) {
            var record = model.data;

            var pono = record.PONO;
            var poseq = record.POSEQ;
            var transqty = record.REMAINQTY;
            var tablegubun = record.TABLEGUBUN;

            var params1 = {
              ORGID: orgid,
              COMPANYID: companyid,
              PONO: pono,
              POSEQ: poseq,
              TRANSNO: transno,
              TRANSQTY: transqty,
              TABLEGUBUN: tablegubun,
              CON1: record.CON1,
              CON9: record.CON9,
            };

            var url1 = '<c:url value="/pkg/prod/process/WarehousingRegist.do"/>';
            $.ajax({
              url: url1,
              type: 'post',
              async: false,
              data: params1,
              success: function (data) {}
            }).done(function (data) {
              // 호출 성공시
              var rscode = data.RETURNSTATUS;
              var errmsg = data.MSGDATA;

              if (rscode == "E") {
                chk_count++;
                msg_false = errmsg;
              } else {
                msg_true = errmsg;
              }

            });

          }
        }

        if (chk_count > 0) {
          extToastView("[확인]<br/>" + msg_false);
          fn_search();
        } else {
          extToastView(msg_true);
          fn_search();
        }
      });

    } else {
      extToastView("입고처리가 취소되었습니다.");
      return;
    }
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
            fn_search();
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
                ORGID: $('#orgid option:selected').val(),
                COMPANYID: $('#companyid option:selected').val(),
                CUSTOMERTYPE2: 'O',
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
            fn_search();

            return false;
        }
    });
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
                    <input type="hidden" id="gubun" name="gubun" value="${searchVO.gubun}" />
                    <input type="hidden" id="work" name="work" value="${searchVO.work}" />
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
                                <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
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
                                <button type="button" class="white h " onclick="fn_goMovePage( 12 );" style="width: 8%; height: 63px; float: left';">
                                        외주발주<br/>( ORDER )
                                </button>
                                <button type="button" class="white_selected h " onclick="fn_goMovePage( 8 );" style="width: 8%; height: 63px; float: left';">
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
				                    <col width="200px">
                            <col width="20%">
                            <col>
                            <col>
                            <col>
                            <col width="250px">
                            <col>
                            <col>
		                    </colgroup>
		                    <tbody>
			                      <tr>
			                        <th style="color: white; font-size:30px; font-weight: bold; text-align: right;">외주가공처 :&nbsp;</th>
                              <td>
			                            <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left"  style="width: 99%; height: 50px;  font-size:25px; vertical-align: middle;" />
			                        </td>
			                        <td></td>
                              <td></td>
                              <td></td>
                              <td>
		                              <center>
                                      <input type="hidden" id="searchGubun1" value="N" />
                                      <input type="hidden" id="searchGubun2" value="Y" />
                                      <button type="button" id="btn_search_n" class="green_selected r shadow" onclick="fn_select_search('N');" style="width: calc(50% - 18px); height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">미입고</button>
                                      <button type="button" id="btn_search_y" class="green r shadow" onclick="fn_select_search('Y');" style="width: calc(50% - 18px); height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">입고</button>
                                      <!-- <label style="width:calc(50% - 18px); height: 50px; font-size: 25px; color: white; vertical-align: middle; padding-top: 8px; " >
                                          <input type="radio" id="searchGubun1" name="searchGubun" class="input_left" value="N" checked="checked" /> 미입고
                                      </label>
		                                  <label style="width:calc(50% - 18px); height: 50px; font-size: 25px; color: white; vertical-align: middle; padding-top: 8px; " >
				                                  <input type="radio" id="searchGubun2" name="searchGubun" class="input_left" value="Y"  /> 입고
		                                  </label> -->
		                              </center>
                              </td>
                              <!-- <td style="padding-left: 10px; padding-right: 5px;">
			                            <button type="button" id="btn_search" class="blue2 r shadow" onclick="fn_search();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">조회</button>
                              </td> -->
                              <td style="padding-left: 5px; padding-right: 5px;">
                                  <button type="button" id="btn_checkall" class="blue2 r shadow" onclick="fn_check_all();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">일괄선택</button>
                              </td>
                              <td style="padding-left: 5px; padding-right: 15px;">
                                  <button type="button" id="btn_save" class="blue2 r shadow" onclick="fn_save_all();" style="width: 100%; height: 50px; margin-left: 0px; margin-right: 15px; margin-top: 0px; margin-bottom: 0px; float: left;">일괄저장</button>
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