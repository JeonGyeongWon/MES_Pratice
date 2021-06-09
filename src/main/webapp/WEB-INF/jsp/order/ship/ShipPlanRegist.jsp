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

	  setValues();
	  setExtGrid();

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  calender($('#searchShipFrom, #searchShipTo,#searchConfirmFrom, #searchConfirmTo'));

	  $('#searchShipFrom, #searchShipTo,#searchConfirmFrom, #searchConfirmTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchShipFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchShipTo").val(getToDay("${searchVO.dateTo}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	     <%--상태 option 변경--%>
	    fn_option_change('OM', 'SHIP_GUBUN', 'searchShipGubun');

	  });

	  gridnms["app"] = "app";

	}

	var gridnms = {};
	var fields = {};
	var items = {};

	function setValues() {
	  gridnms["models.viewer"] = [];
	  gridnms["stores.viewer"] = [];
	  gridnms["views.viewer"] = [];
	  gridnms["controllers.viewer"] = [];

	  gridnms["grid.1"] = "ShipPlanRegist";
	  gridnms["grid.11"] = "itemLov";
	  gridnms["grid.12"] = "customerLov";
	  gridnms["grid.13"] = "shipgubunLov";
	  gridnms["grid.14"] = "shippingtypeLov";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.viewer"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.viewer"].push(gridnms["controller.1"]);

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

	  gridnms["models.viewer"].push(gridnms["model.1"]);
	  gridnms["models.viewer"].push(gridnms["model.11"]);
	  gridnms["models.viewer"].push(gridnms["model.12"]);
	  gridnms["models.viewer"].push(gridnms["model.13"]);
	  gridnms["models.viewer"].push(gridnms["model.14"]);

	  gridnms["stores.viewer"].push(gridnms["store.1"]);
	  gridnms["stores.viewer"].push(gridnms["store.11"]);
	  gridnms["stores.viewer"].push(gridnms["store.12"]);
	  gridnms["stores.viewer"].push(gridnms["store.13"]);
	  gridnms["stores.viewer"].push(gridnms["store.14"]);

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
	      name: 'SHIPNO',
	    }, {
	      type: 'string',
	      name: 'OLDSHIPNO',
	    }, {
	      type: 'string',
	      name: 'CONFIRMYN',
	    }, {
	      type: 'string',
	      name: 'CONFIRMYNNAME',
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
	      type: 'number',
	      name: 'SHIPQTY',
	    }, {
	      type: 'date',
	      name: 'SHIPDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'CONFIRMDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'SHIPGUBUN',
	    }, {
	      type: 'string',
	      name: 'SHIPGUBUNNAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, ];

	  fields["model.11"] = [{
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
	    }, ];

	  fields["model.12"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    },
	  ];

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
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 45,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
        renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SHIPNO',
	      text: '출하계획번호',
	      xtype: 'gridcolumn',
	      width: 130,
	      hidden: false,
	      sortable: false,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, /* {
	    dataIndex: 'SHIPGUBUNNAME',
	    text: '출하구분',
	    xtype: 'gridcolumn',
	    width: 80,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    align: "center",
	    editor: {
	    xtype: 'combobox',
	    store: gridnms["store.13"],
	    valueField: "LABEL",
	    displayField: "LABEL",
	    matchFieldWidth: false,
	    editable: true,
	    queryParam: 'keyword',
	    queryMode: 'remote',
	    allowBlank: true,
	    listeners: {
	    select: function (value, record, eOpts) {
	    var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);

	    model.set("SHIPGUBUN", record.data.VALUE);
	    },
	    },
	    listConfig: {
	    loadingText: '검색 중...',
	    emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
	    width: 120,
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
	    meta.style = "background-color:rgb(253, 218, 255)";
	    return value;
	    },
	    },*/
	    {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 215,
	      hidden: false,
	      sortable: false,
	      align: "left",
	      hidden: false,
	      sortable: false,
	      align: "left",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.12"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: true,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'local', // 'local',
	        allowBlank: true,
	        typeAhead: true,
	        transform: 'stateSelect',
	        forceSelection: true,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);

	            model.set("CUSTOMERCODE", record.get("VALUE"));
	          },
	          blur: function (field, e, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);
	            if (field.getValue() == "") {
	              model.set("CUSTOMERCODE", "");
	            }
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
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMCODE',
	      text: '품목',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.11"],
	        valueField: "ITEMCODE",
	        displayField: "ITEMCODE",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'local', // 'local',
	        allowBlank: true,
	        typeAhead: true,
	        transform: 'stateSelect',
	        forceSelection: false,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);

	            model.set("ITEMNAME", record.get("ITEMNAME"));
	            model.set("ORDERNAME", record.get("ORDERNAME"));
	            model.set("UOM", record.get("UOM"));
	            model.set("UOMNAME", record.get("UOMNAME"));

	            var item = record.get("ITEMCODE");

	            if (item == "") {
	              model.set("ITEMNAME", "");
	              model.set("ORDERNAME", "");
	              model.set("UOM", "");
	              model.set("UOMNAME", "");
	            }
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);
	            var result = field.getValue();

	            if (ov != nv) {
	              if (!isNaN(result)) {
	                console.log("change : " + field.getValue());
	                model.set("ITEMNAME", "");
	                model.set("ORDERNAME", "");
	                model.set("UOM", "");
	                model.set("UOMNAME", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	          width: 450,
	          getInnerTpl: function () {
	            return '<div >'
	             + '<table >'
	             + '<colgroup>'
	             + '<col width="140px">'
	             + '<col width="220px">'
	             + '<col width="140px">'
	             + '<col width="50px">'
	             + '</colgroup>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; ">{ITEMCODE}</td>'
	             + '<td style="height: 25px; font-size: 13px; ">{ITEMNAME}</td>'
	             + '<td style="height: 25px; font-size: 13px; ">{ORDERNAME}</td>'
	             + '<td style="height: 25px; font-size: 13px; ">{UOMNAME}</td>'
	             + '</tr>'
	             + '</table>'
	             + '</div>';
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      align: "left",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.11"],
	        valueField: "ORDERNAME",
	        displayField: "ORDERNAME",
	        matchFieldWidth: false,
	        editable: true,
	        queryParam: 'keyword',
	        queryMode: 'local', // 'local',
	        allowBlank: true,
	        typeAhead: true,
	        transform: 'stateSelect',
	        forceSelection: false,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);

	            model.set("ITEMCODE", record.get("ITEMCODE"));
	            model.set("ITEMNAME", record.get("ITEMNAME"));
	            model.set("UOM", record.get("UOM"));
	            model.set("UOMNAME", record.get("UOMNAME"));

	            var item = record.get("ORDERNAME");

	            if (item == "") {
	              model.set("ITEMCODE", "");
	              model.set("ITEMNAME", "");
	              model.set("UOM", "");
	              model.set("UOMNAME", "");

	            }

	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);
	            var result = field.getValue();

	            if (ov != nv) {
	              if (!isNaN(result)) {
	                console.log("change : " + field.getValue());
	                model.set("ITEMCODE", "");
	                model.set("ITEMNAME", "");
	                model.set("UOM", "");
	                model.set("UOMNAME", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	          width: 450,
	          getInnerTpl: function () {
	            return '<div >'
	             + '<table >'
	             + '<colgroup>'
	             + '<col width="140px">'
	             + '<col width="140px">'
	             + '<col width="220px">'
	             + '<col width="50px">'
	             + '</colgroup>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; ">{ORDERNAME}</td>'
	             + '<td style="height: 25px; font-size: 13px; ">{ITEMCODE}</td>'
	             + '<td style="height: 25px; font-size: 13px; ">{ITEMNAME}</td>'
	             + '<td style="height: 25px; font-size: 13px; ">{UOMNAME}</td>'
	             + '</tr>'
	             + '</table>'
	             + '</div>';
	          }
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return value;
	      },
	      }, {
	          dataIndex: 'ITEMNAME',
	          text: '품명',
	          xtype: 'gridcolumn',
	          width: 220,
	          hidden: false,
	          sortable: false,
	          align: "left",
	          editor: {
	            xtype: 'combobox',
	            store: gridnms["store.11"],
	            valueField: "ITEMNAME",
	            displayField: "ITEMNAME",
	            matchFieldWidth: false,
	            editable: true,
	            queryParam: 'keyword',
	            queryMode: 'local', // 'local',
	            allowBlank: true,
	            typeAhead: true,
	            transform: 'stateSelect',
	            forceSelection: false,
	            listeners: {
	              select: function (value, record, eOpts) {
	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);

	                model.set("ITEMCODE", record.get("ITEMCODE"));
	                model.set("ORDERNAME", record.get("ORDERNAME"));
	                model.set("UOM", record.get("UOM"));
	                model.set("UOMNAME", record.get("UOMNAME"));

	                var item = record.get("ITEMNAME");

	                if (item == "") {
	                  model.set("ITEMCODE", "");
	                  model.set("ORDERNAME", "");
	                  model.set("UOM", "");
	                  model.set("UOMNAME", "");

	                }

	              },
	              change: function (field, ov, nv, eOpts) {
	                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);
	                var result = field.getValue();

	                if (ov != nv) {
	                  if (!isNaN(result)) {
	                    console.log("change : " + field.getValue());
	                    model.set("ITEMCODE", "");
	                    model.set("ORDERNAME", "");
	                    model.set("UOM", "");
	                    model.set("UOMNAME", "");
	                  }
	                }
	              },
	            },
	            listConfig: {
	              loadingText: '검색 중...',
	              emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	              width: 450,
	              getInnerTpl: function () {
	                return '<div >'
	                 + '<table >'
	                 + '<colgroup>'
	                 + '<col width="220px">'
	                 + '<col width="140px">'
	                 + '<col width="140px">'
	                 + '<col width="50px">'
	                 + '</colgroup>'
	                 + '<tr>'
	                 + '<td style="height: 25px; font-size: 13px; ">{ITEMNAME}</td>'
	                 + '<td style="height: 25px; font-size: 13px; ">{ITEMCODE}</td>'
	                 + '<td style="height: 25px; font-size: 13px; ">{ORDERNAME}</td>'
	                 + '<td style="height: 25px; font-size: 13px; ">{UOMNAME}</td>'
	                 + '</tr>'
	                 + '</table>'
	                 + '</div>';
	              }
	            },
	          },
	          renderer: function (value, meta, record) {
	            meta.style = "background-color:rgb(253, 218, 255)";
	            return value;
	          },
	    }, {
	      dataIndex: 'UOMNAME',
	      text: '단위',
	      xtype: 'gridcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'SHIPQTY',
	      text: '출하계획수량',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
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
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, /* {
	    dataIndex: 'SUMQTY',
	    text: '출하수량',
	    xtype: 'gridcolumn',
	    width: 85,
	    hidden: false,
	    sortable: false,
	    resizable: false,
	    style: 'text-align:center;',
	    align: "center",
	    cls: 'ERPQTY',
	    format: "0,000",
	    },*/
	    {
	      dataIndex: 'SHIPDATE',
	      text: '출하계획일',
	      xtype: 'datecolumn',
	      width: 130, // 85,
	      hidden: false,
	      sortable: true,
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
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'CONFIRMDATE',
	      text: '완료일',
	      xtype: 'datecolumn',
	      width: 85,
	      hidden: false,
	      sortable: false,
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      align: "center",
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
	      dataIndex: 'OLDSHIPNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SHIPGUBUN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CONFIRMYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CONFIRMYNNAME',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/order/ship/ShipPlanRegist.do' />"
	  });
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/order/ship/ShipPlanRegist.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/order/ship/ShipPlanRegist.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/order/ship/ShipPlanRegist.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.1"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef1"
	  });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnAdd1": {
	      click: 'btnAdd1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnSav1": {
	      click: 'btnSav1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnDel1": {
	      click: 'btnDel1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnRef1": {
	      click: 'btnRef1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#MasterList": {
	      itemclick: 'onShippingClick'
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

	function btnAdd1(o, e) {

	  var model = Ext.create(gridnms["model.1"]);
	  var store = this.getStore(gridnms["store.1"]);

	  // 오늘날짜 구하기
	  var date = new Date();
	  var year = date.getFullYear();
	  var month = new String(date.getMonth() + 1);
	  var day = new String(date.getDate());

	  // 한자리수일 경우 0을 채워준다.
	  if (month.length == 1) {
	    month = "0" + month;
	  }
	  if (day.length == 1) {
	    day = "0" + day;
	  }
	  // 오늘 날짜 구하기 끝

	  model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);
	  model.set("SHIPNO", $("#SHIPNO").val());
// 	  model.set("SHIPDATE", year + "-" + month + "-" + day);
    model.set("SHIPDATE", "${searchVO.dateTo}");
	  model.set("SHIPGUBUNNAME", "정상출하");
	  model.set("SHIPGUBUN", "S");
	  model.set("ORGID", $("#searchOrgId").val());
	  model.set("COMPANYID", $("#searchCompanyId").val());

	  store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
	};

	function btnRef1(o, e) {
	  Ext.getStore(gridnms["store.1"]).load();
	};

	function btnSav1(o, e) {
	  // 저장시 필수값 체크
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var header = [],
	  count = 0;

	  if (count1 > 0) {
	    for (i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).getSelectionModel().select(i));
	      var model = Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0];

	      var shipgubun = model.data.SHIPGUBUN;
	      var customercode = model.data.CUSTOMERCODE;
	      var itemcode = model.data.ITEMCODE;
	      var shipqty = model.data.SHIPQTY;
	      var shipdate = model.data.SHIPDATE;

	      //          if (shipgubun == "" || shipgubun == undefined) {
	      //            header.push("출하구분");
	      //            count++;
	      //          }

	      if (customercode == "" || customercode == undefined) {
	        header.push("거래처");
	        count++;
	      }

	      if (itemcode == "" || itemcode == undefined) {
	        header.push("품명");
	        count++;
	      }

	      if (shipqty == "" || shipqty == undefined) {
	        header.push("출하계획수량");
	        count++;
	      }

	      if (shipdate == "" || shipdate == undefined) {
	        header.push("출하계획일");
	        count++;
	      }

	      if (count > 0) {
	        extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
	        return;
	      }
	    }
	  } else {
	    extAlert("[저장] 출하지시 투입 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
	    return;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  } else {
	    Ext.getStore(gridnms["store.1"]).sync({
	      success: function (batch, options) {
	        extAlert(msgs.noti.save, gridnms["store.1"]);
	        Ext.getStore(gridnms["store.1"]).load();
	      },
	      failure: function (batch, options) {
	        extAlert(batch.exceptions[0].error, gridnms["store.1"]);
	      },
	      callback: function (batch, options) {},
	    });
	  }
	};

	function btnDel1(o, e) {

	  var store = this.getStore(gridnms["store.1"]);
	  var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
	  var count = 0;

	  var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);
	  var check2 = model.get("CONFIRMYN");
	  if (check2 == "Y") {
	    Ext.Msg.alert('삭제실패', '완료 상태의 출하계획은 삭제처리가 불가능 합니다.');
	    return;
	  }

	  var check3 = model.get("OLDSHIPNO") + "";
	  if (check3.length > 0) {
	    Ext.Msg.alert('삭제실패', '이월받은 상태의 출하계획은 삭제처리가 불가능 합니다.');
	    return;
	  }

	  url = "<c:url value='/select/order/ship/ShipOrderDetail.do' />";
	  var detailcount = 0
	    var params = {
	    SHIPNO: $("#SHIPNO").val(),
	    ORGID: $("#ORGID").val(),
	    COMPANYID: $("#COMPANYID").val()
	  };
	  $.ajax({
	    url: url,
	    type: "post",
	    dataType: "json",
	    data: params,
	    success: function (data) {
	      detailcount = data.totcnt;
	      if (detailcount != 0) {
	        // extAlert("해당 출를 삭제한 후 시도 하십시오.");
	        Ext.Msg.alert('삭제실패', '해당 출하계획의 출하지시 데이터를 삭제한 후 시도해 주십시오.');
	        return;
	      }
	    },
	    error: ajaxError
	  });

	  if (record === undefined) {
	    return;
	  }

	  // 제약조건 추가 - 상태 값이 'N' 일 경우에만 삭제 가능
	  if (count == 0) {
	    Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        store.remove(record);
	        Ext.getStore(gridnms["store.1"]).sync();

	        setTimeout(function () {
	          Ext.getStore(gridnms["store.1"]).load();
	        }, 200);
	      }
	    });
	  }
	};

	function onShippingClick(dataview, record, item, index, e, eOpts) {
	  $("#SHIPNO").val(record.get("SHIPNO"));
	  $("#SHIPQTY").val(record.get("SHIPQTY"));
	  $("#ORGID").val(record.get("ORGID"));
	  $("#COMPANYID").val(record.get("COMPANYID"));
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
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                SHIPFROM: $('#searchShipFrom').val(),
	                SHIPTO: $('#searchShipTo').val(),
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
	              url: "<c:url value='/searchItemNameLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                SHIP_GUBUN: 'A'
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
	              url: "<c:url value='/searchCustomernameLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                CUSTOMERTYPEGUBUN: 'GUBUN',
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
	            autoLoad: true,
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: "ajax",
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'OM',
	                MIDDLECD: 'SHIP_GUBUN'
	              },
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
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'OM',
	                MIDDLECD: 'SHIP_TYPE'
	              },
	              reader: gridVals.reader,
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
	    btnAdd1: btnAdd1,
	    btnSav1: btnSav1,
	    btnDel1: btnDel1,
	    btnRef1: btnRef1,
	    onShippingClick: onShippingClick,
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
	        height: 503, // 469,
	        border: 2,
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
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.autoResizeWidth)
	                  column.autoSize();
	              });
	            },
	          }
	        },
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);

	                var editDisableCols = [];
	                var status = data.data.CONFIRMYN;
	                if (status != "N") {
	                   <%--상태 값 완료시 입력 불가--%>
	                  editDisableCols.push("SHIPGUBUNNAME");
	                  editDisableCols.push("CUSTOMERNAME");
	                  editDisableCols.push("ITEMCODE");
	                  editDisableCols.push("ITEMNAME");
	                  editDisableCols.push("ORDERNAME");
	                  editDisableCols.push("SHIPQTY");
	                  editDisableCols.push("SHIPDATE");
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
	    models: gridnms["models.viewer"],
	    stores: gridnms["stores.viewer"],
	    views: gridnms["views.viewer"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.viewer"], {
	          renderTo: 'gridViewArea'
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
	  var shipfrom = $('#searchShipFrom').val();
	  var shipto = $('#searchShipTo').val();
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

	  var sparams = {
	    ORGID: $('#searchOrgId option:selected').val(),
	    COMPANYID: $('#searchCompanyId option:selected').val(),
	    SHIPFROM: $('#searchShipFrom').val(),
	    SHIPTO: $('#searchShipTo').val(),
	    CONFIRMFROM: $('#searchConfirmFrom').val(),
	    CONFIRMTO: $('#searchConfirmTo').val(),
	    CONFIRMYN: $('#searchConfirmYn option:selected').val(),
	    SHIPGUBUN: $('#searchShipGubun option:selected').val(),
	    SHIPNO: $('#searchShipNo').val(),
	    CUSTOMERCODE: $('#searchCustomerCode').val(),
	    ITEMCODE: $('#searchItemCode').val(),
	    ITEMNAME: $('#searchItemName').val(),
	    ORDERNAME: $('#searchOrderName').val(),
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	  setTimeout(function () {

	    extGridSearch(sparams, gridnms["store.11"]);
	    extGridSearch(sparams, gridnms["store.12"]);
	    extGridSearch(sparams, gridnms["store.13"]);
	  }, 200);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 출하계획번호 Lov
	  $("#searchShipNo").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchWorkNo").val("");
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
	      $.getJSON("<c:url value='/order/ship/searchShipNoListLov.do' />", {
	        keyword: extractLast(request.term),
	        SHIPFROM: $('#searchShipFrom').val(),
	        SHIPTO: $('#searchShipTo').val(),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.SHIPNO,
	              label: m.SHIPNO,
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
	      $("#searchShipNo").val(o.item.value);

	      return false;
	    }
	  });

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
	        CUSTOMERTYPEGUBUN: 'GUBUN',
	          CUSTOMERTYPE: 'A',
	        }, function (data) {
	          response($.map(data.data, function (m, i) {
	              return $.extend(m, {
	                value: m.VALUE,
	                label: m.LABEL + ", " + m.CUSTOMERTYPENAME + ", " + m.ADDRESS,
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
                                <li>출하관리</li>
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
                        <input type="hidden" id="searchGroupCode" name=searchGroupCode value="P" />
                        <input type="hidden" id="orgid" value="<c:out value='${OrgIdVal}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${CompanyIdVal}'/>" />
		                    <input type="hidden" id="SHIPNO" />
		                    <input type="hidden" id="ORGID" />
		                    <input type="hidden" id="COMPANYID" />
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
                                            </div>
                                        </td>
                                    </tr>                                 
                                </table>
                                <table class="tbl_type_view" border="1">
                                    <colgroup>
                                        <col width="12%">
                                        <col width="22%">
                                        <col width="12%">
                                        <col width="22%">
                                        <col width="12%">
                                        <col width="22%">
                                    </colgroup>
                                    
                                    <tr style="height: 34px;">
                                        <th class="required_text">출하계획일</th>
                                        <td >
                                            <input type="text" id="searchShipFrom" name="searchShipFrom" class="input_validation input_center validate[custom[date],past[#searchShipTo]]" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchShipTo" name="searchShipTo" class="input_validation input_center validate[custom[date],future[#searchShipFrom]]" style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">출하계획번호</th>
                                        <td>
                                            <input type="text" id="searchShipNo" name="searchShipNo" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">완료여부</th>
                                        <td>
                                            <select id="searchConfirmYn" name="searchConfirmYn" class="input_left validate[required]" style="width: 97%;">
                                                    <option value="" label="전체" />
                                                    <option value="Y" label="완료" />
                                                    <option value="N" label="미완료" />
                                            </select>
                                        </td>                                     
<!--                                         <th class="required_text">출하구분</th> -->
<!--                                         <td> -->
<!--                                             <select id="searchShipGubun" name="searchShipGubun" class="input_left validate[required]" style="width: 97%;"> -->
<%--                                                 <c:if test="${empty searchVO.SHIPGUBUN}"> --%>
<!--                                                     <option value="" label="전체" /> -->
<%--                                                 </c:if> --%>
<%--                                                 <c:forEach var="item" items="${labelBox.findByShipGubun}" varStatus="status"> --%>
<%--                                                     <c:choose> --%>
<%--                                                         <c:when test="${item.VALUE==searchVO.SHIPGUBUN}"> --%>
<%--                                                             <option value="${item.VALUE}" selected>${item.LABEL}</option> --%>
<%--                                                         </c:when> --%>
<%--                                                         <c:otherwise> --%>
<%--                                                             <option value="${item.VALUE}">${item.LABEL}</option> --%>
<%--                                                         </c:otherwise> --%>
<%--                                                     </c:choose> --%>
<%--                                                 </c:forEach> --%>
<!--                                             </select> -->
<!--                                         </td> -->
                                    </tr>
                                    <tr style="height: 34px;">
<!--                                         <th class="required_text">확정일</th> -->
<!--                                         <td > -->
<!--                                             <input type="text" id="searchConfirmFrom" name="searchConfirmFrom" class=" input_center validate[custom[date],past[#searchConfirmTo]]" style="width: 90px; " maxlength="10" /> -->
<!--                                             &nbsp;~&nbsp; -->
<!--                                             <input type="text" id="searchConfirmTo" name="searchConfirmTo" class=" input_center validate[custom[date],future[#searchConfirmFrom]]" style="width: 90px; " maxlength="10"  /> -->
<!--                                         </td> -->
                                        <th class="required_text">거래처</th>
                                        <td>
                                            <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left"  style="width: 97%;" />
                                            <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" class=""  />                                           
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td>
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName" class="input_left"  style="width: 97%;" />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->                    
                <div style="width: 100%;">
                    <div id="gridViewArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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