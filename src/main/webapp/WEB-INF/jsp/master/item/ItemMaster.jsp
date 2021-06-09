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
var groupid = "${searchVO.groupId}";
$(document).ready(function () {
  gridnms["app"] = "item";

  setValues();
  setExtGrid();

  setReadOnly();

  setLovList();

  $('#searchOrgId, #searchCompanyId').change(function (event) {
     <%--유형 option 변경--%>
    fn_option_change('CMM', 'ITEM_TYPE', 'searchItemType');
  });
});

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
  // 품목
  setValues_Item();
  // PRICE
  switch (groupid) {
  case "ROLE_ADMIN":
  case "ROLE_MANAGER":
    setValues_Price();
    break;
  default:
    setValues_PriceQ();
    break;
  }
}

var gridItemarea, gridItemPricearea, gridarea3;
function setExtGrid() {
  // 품목
  setExtGrid_Item();
  switch (groupid) {
  case "ROLE_ADMIN":
  case "ROLE_MANAGER":
    setExtGrid_Price();
    break;
  default:
    setExtGrid_PriceQ();
    break;
  }

  Ext.EventManager.onWindowResize(function (w, h) {
    gridItemarea.updateLayout();

    switch (groupid) {
    case "ROLE_ADMIN":
    case "ROLE_MANAGER":
      gridItemPricearea.updateLayout();
      break;
    default:
      gridarea3.updateLayout();
      break;
    }
  });
}

function setValues_Item() {
  gridnms["models.item"] = [];
  gridnms["stores.item"] = [];
  gridnms["views.item"] = [];
  gridnms["controllers.item"] = [];

  gridnms["grid.4"] = "ItemMaster";
  gridnms["grid.5"] = "uomLov";
  gridnms["grid.6"] = "itemTypeLov";
  gridnms["grid.7"] = "modelLov";
  gridnms["grid.8"] = "CustomerLov";

  gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
  gridnms["views.item"].push(gridnms["panel.4"]);

  gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
  gridnms["controllers.item"].push(gridnms["controller.4"]);

  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
  gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];
  gridnms["model.8"] = gridnms["app"] + ".model." + gridnms["grid.8"];

  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
  gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];
  gridnms["store.8"] = gridnms["app"] + ".store." + gridnms["grid.8"];

  gridnms["models.item"].push(gridnms["model.4"]);
  gridnms["models.item"].push(gridnms["model.5"]);
  gridnms["models.item"].push(gridnms["model.6"]);
  gridnms["models.item"].push(gridnms["model.7"]);
  gridnms["models.item"].push(gridnms["model.8"]);

  gridnms["stores.item"].push(gridnms["store.4"]);
  gridnms["stores.item"].push(gridnms["store.5"]);
  gridnms["stores.item"].push(gridnms["store.6"]);
  gridnms["stores.item"].push(gridnms["store.7"]);
  gridnms["stores.item"].push(gridnms["store.8"]);

  fields["model.4"] = [{
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
      name: 'GROUPCODE',
    }, {
      type: 'string',
      name: 'BIGCODE',
    }, {
      type: 'string',
      name: 'MIDDLECODE',
    }, {
      type: 'string',
      name: 'SMALLCODE',
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
      type: 'number',
      name: 'SALESPRICE',
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
      name: 'CUSTOMERCODE',
    }, {
      type: 'string',
      name: 'CUSTOMERNAME',
    }, {
      type: 'date',
      name: 'EFFECTIVESTARTDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'date',
      name: 'EFFECTIVEENDDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'REMARKS',
    }, {
      type: 'string',
      name: 'ORDERINSPECTIONYN',
    }, {
      type: 'string',
      name: 'INVENTORYMANAGEYN',
    }, {
      type: 'number',
      name: 'SAFETYINVENTORY',
    }, {
      type: 'string',
      name: 'USEYN',
    },
  ];

  fields["model.5"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.6"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["model.7"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];
  fields["model.8"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

  fields["columns.4"] = [
    // Display Columns
    {
      dataIndex: 'RN',
      text: '순번',
      xtype: 'rownumberer',
      width: 45,
      hidden: false,
      sortable: false,
      resizable: false,
      align: "center",
    }, {
      dataIndex: 'ORDERNAME',
      text: '품번',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      resizable: false,
      align: "center",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      },
    }, {
      dataIndex: 'ITEMNAME',
      text: '품명',
      xtype: 'gridcolumn',
      width: 235,
      hidden: false,
      sortable: false,
      resizable: false,
      align: "left",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
      },
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(253, 218, 255)";
        return value;
      },
    }, {
      dataIndex: 'SALESPRICE',
      text: '단가',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: true,
      style: 'text-align:center',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000",
      renderer: function (value, meta, record) {
        meta.style = "background-color:rgb(234, 234, 234)";
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'UOMNAME',
      text: '단위',
      xtype: 'gridcolumn',
      width: 70,
      hidden: false,
      sortable: false,
      resizable: false,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.5"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);

            model.set("UOM", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 250,
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
      dataIndex: 'ITEMTYPENAME',
      text: '유형',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      resizable: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.6"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);

            model.set("ITEMTYPE", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 250,
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
        var itemcode = record.data.ITEMCODE;

        if (itemcode != "") {
          meta.style = "background-color:rgb(234, 234, 234)";
        } else {
          meta.style = "background-color:rgb(253, 218, 255)";
        }
        return value;
      },
    }, {
      dataIndex: 'MODELNAME',
      text: '모델명',
      xtype: 'gridcolumn',
      width: 90,
      hidden: false,
      sortable: false,
      resizable: true,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.7"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: true,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);

            model.set("MODEL", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 250,
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
      dataIndex: 'CUSTOMERNAME',
      text: '거래처',
      xtype: 'gridcolumn',
      width: 250,
      hidden: false,
      sortable: false,
      resizable: false,
      align: "center",
      editor: {
        xtype: 'combobox',
        store: gridnms["store.8"],
        valueField: "LABEL",
        displayField: "LABEL",
        matchFieldWidth: false,
        editable: false,
        queryParam: 'keyword',
        queryMode: 'remote',
        allowBlank: true,
        listeners: {
          select: function (value, record, eOpts) {
            var model = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);

            model.set("CUSTOMERCODE", record.data.VALUE);
          },
        },
        listConfig: {
          loadingText: '검색 중...',
          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
          width: 250,
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
      dataIndex: 'ORDERINSPECTIONYN',
      text: '수입검사<br>유무',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: true,
      align: "center",
      editor: {
        xtype: 'combo',
        store: ['Y', 'N'],
      },
      renderer: function (value, meta, record) {
        var itemtype = record.data.ITEMTYPE;

        if (itemtype != "M") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        return value;
      },
    }, {
      dataIndex: 'INVENTORYMANAGEYN',
      text: '재고관리<br>유무',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: true,
      align: "center",
      editor: {
        xtype: 'combo',
        store: ['Y', 'N'],
      },
      renderer: function (value, meta, record) {
        var itemtype = record.data.ITEMTYPE;

        if (itemtype != "M") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        return value;
      },
    }, {
      dataIndex: 'SAFETYINVENTORY',
      text: '안전재고',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: false,
      resizable: true,
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
        maxLength: '20',
        maskRe: /[0-9]/,
        selectOnFocus: true,
      },
      renderer: function (value, meta, record) {
        var itemtype = record.data.ITEMTYPE;

        if (itemtype != "M") {
          meta.style = "background-color:rgb(234, 234, 234)";
        }
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'EFFECTIVESTARTDATE',
      text: '시작일자',
      xtype: 'datecolumn',
      width: 130,
      hidden: false,
      sortable: false,
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
      dataIndex: 'EFFECTIVEENDDATE',
      text: '종료일자',
      xtype: 'datecolumn',
      width: 130,
      hidden: false,
      sortable: false,
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
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 160,
      hidden: false,
      sortable: false,
      resizable: true,
      align: "left",
      editor: {
        xtype: 'textfield',
        allowBlank: true,
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
      dataIndex: 'GROUPCODE',
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
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'UOM',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMTYPE',
      xtype: 'hidden',
    }, {
      dataIndex: 'MODEL',
      xtype: 'hidden',
    }, {
      dataIndex: 'CUSTOMERCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'USEYN',
      xtype: 'hidden',
    }, ];

  items["api.4"] = {};
  $.extend(items["api.4"], {
    create: "<c:url value='/insert/item/ItemMaster.do' />"
  });
  $.extend(items["api.4"], {
    read: "<c:url value='/select/item/ItemMaster.do' />"
  });
  $.extend(items["api.4"], {
    update: "<c:url value='/update/item/ItemMaster.do' />"
  });
  $.extend(items["api.4"], {
    destroy: "<c:url value='/delete/item/ItemMaster.do' />"
  });

  items["btns.4"] = [];
  items["btns.4"].push({
    xtype: "button",
    text: "추가",
    itemId: "btnAdd4"
  });
  items["btns.4"].push({
    xtype: "button",
    text: "저장",
    itemId: "btnSav4"
  });
  items["btns.4"].push({
    xtype: "button",
    text: "삭제",
    itemId: "btnDel4"
  });
  items["btns.4"].push({
    xtype: "button",
    text: "새로고침",
    itemId: "btnRef4"
  });

  items["btns.ctr.4"] = {};
  $.extend(items["btns.ctr.4"], {
    "#btnAdd4": {
      click: 'btnAdd4Click'
    }
  });
  $.extend(items["btns.ctr.4"], {
    "#btnSav4": {
      click: 'btnSav4Click'
    }
  });
  $.extend(items["btns.ctr.4"], {
    "#btnDel4": {
      click: 'btnDel4Click'
    }
  });
  $.extend(items["btns.ctr.4"], {
    "#btnRef4": {
      click: 'btnRef4Click'
    }
  });
  $.extend(items["btns.ctr.4"], {
    "#itemGrid": {
      itemclick: 'onMyviewItemClick'
    }
  });

  items["dock.btn.4"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.4"],
    items: items["btns.4"],
  };

  items["docked.4"] = [];
  items["docked.4"].push(items["dock.btn.4"]);
}

function btnAdd4Click(o, e) {
  var model = Ext.create(gridnms["model.4"]);
  var store = this.getStore(gridnms["store.4"]);

  model.set("ORGID", $('#searchOrgId').val());
  model.set("COMPANYID", $('#searchCompanyId').val());
  model.set("USEYN", "Y");
  model.set("ORDERINSPECTIONYN", "N");
  model.set("INVENTORYMANAGEYN", "N");

  var startdate = Ext.util.Format.date("${searchVO.TODAY}", 'Y-m-d');
  var enddate = Ext.util.Format.date("4999-12-31", 'Y-m-d');
  model.set("EFFECTIVESTARTDATE", startdate);
  model.set("EFFECTIVEENDDATE", enddate);

  store.insert(Ext.getStore(gridnms["store.4"]).count() + 1, model);
};

function btnSav4Click(button, e, eOpts) {
  var count = 0,
  msg = null;
  var mcount3 = Ext.getStore(gridnms["store.4"]).count();

  for (var k = 0; k < mcount3; k++) {
    var model = Ext.getStore(gridnms["store.4"]).data.items[k].data;
    var header = [],
    gubun = null;

    // 미입력 사항 체크
    //     var itemcode = model.ITEMCODE + "";
    //     if (itemcode.length == 0) {
    //       header.push("품목코드");
    //       count++;
    //     }

    var itemname = model.ITEMNAME + "";
    if (itemname.length == 0) {
      header.push("품명");
      count++;
    }

    var uom = model.UOM + "";
    if (uom.length == 0) {
      header.push("단위");
      count++;
    }

    var type = model.ITEMTYPE + "";
    if (type.length == 0) {
      header.push("유형");
      count++;
    }

    var startdate = model.EFFECTIVESTARTDATE + "";
    if (startdate.length == 0) {
      header.push("유효시작일자");
      count++;
    }

    var enddate = model.EFFECTIVEENDDATE + "";
    if (enddate.length == 0) {
      header.push("유효종료일자");
      count++;
    }

    if (count > 0) {
      extAlert("[필수항목 미입력]<br/>" + (k + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
      return;
    }
  }

  if (count == 0) {
    // 저장
    Ext.getStore(gridnms["store.4"]).sync({
      success: function (batch, options) {
        extAlert(msgs.noti.save, gridnms["store.4"]);

        Ext.getStore(gridnms["store.4"]).load();
      },
      failure: function (batch, options) {
        extAlert(batch.exceptions[0].error, gridnms["store.4"]);
      },
      callback: function (batch, options) {},
    });
  }
};

function btnDel4Click(o, e) {
  extGridDel(gridnms["store.4"], gridnms["panel.4"]);
};

function btnRef4Click(o, e) {
  Ext.getStore(gridnms["store.4"]).load();
};

function onMyviewItemClick(dataview, record, item, index, e, eOpts) {
  $("#OrgidVal").val(record.data.ORGID);
  $("#CompanyidVal").val(record.data.COMPANYID);
  $("#ItemCodeVal").val(record.data.ITEMCODE);
  var OrgidVal = $('#OrgidVal').val();
  var CompanyidVal = $('#CompanyidVal').val();
  var ItemCodeVal = $('#ItemCodeVal').val();

  switch (groupid) {
  case "ROLE_ADMIN":
  case "ROLE_MANAGER":
    Ext.getStore(gridnms["store.40"]).proxy.setExtraParam('ITEMCODE', ItemCodeVal);
    Ext.getStore(gridnms["store.40"]).proxy.setExtraParam('ORGID', OrgidVal);
    Ext.getStore(gridnms["store.40"]).proxy.setExtraParam('COMPANYID', CompanyidVal);
    Ext.getStore(gridnms["store.40"]).load();
    break;
  default:
    Ext.getStore(gridnms["store.50"]).proxy.setExtraParam('ITEMCODE', ItemCodeVal);
    Ext.getStore(gridnms["store.50"]).proxy.setExtraParam('ORGID', OrgidVal);
    Ext.getStore(gridnms["store.50"]).proxy.setExtraParam('COMPANYID', CompanyidVal);
    Ext.getStore(gridnms["store.50"]).load();

    break;
  }
};

function setValues_Price() {
  gridnms["models.price"] = [];
  gridnms["stores.price"] = [];
  gridnms["views.price"] = [];
  gridnms["controllers.price"] = [];

  gridnms["grid.40"] = "priceMaster";

  gridnms["panel.40"] = gridnms["app"] + ".view." + gridnms["grid.40"];
  gridnms["views.price"].push(gridnms["panel.40"]);

  gridnms["controller.40"] = gridnms["app"] + ".controller." + gridnms["grid.40"];
  gridnms["controllers.price"].push(gridnms["controller.40"]);

  gridnms["model.40"] = gridnms["app"] + ".model." + gridnms["grid.40"];

  gridnms["store.40"] = gridnms["app"] + ".store." + gridnms["grid.40"];

  gridnms["models.price"].push(gridnms["model.40"]);

  gridnms["stores.price"].push(gridnms["store.40"]);

  fields["model.40"] = [{
      type: 'number',
      name: 'RN',
    }, {
      type: 'number',
      name: 'ORGID',
    }, {
      type: 'number',
      name: 'COMPANYID',
    }, {
      type: 'number',
      name: 'PRICESEQ',
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
      name: 'UOM'
    }, {
      type: 'string',
      name: 'UOMNAME',
    }, {
      type: 'number',
      name: 'UNITPRICEA',
    }, {
      type: 'string',
      name: 'CURRENCYCODE'
    }, {
      type: 'string',
      name: 'CURRENCYCODENAME',
    }, {
      type: 'date',
      name: 'EFFECTIVESTARTDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'date',
      name: 'EFFECTIVEENDDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'REMARKS',
    }, ];

  fields["columns.40"] = [
    // Display columns
    {
      dataIndex: 'RN',
      text: '순번',
      xtype: 'rownumberer',
      width: 45,
      hidden: false,
      sortable: false,
      resizable: false,
      align: "center",
    }, {
      dataIndex: 'UNITPRICEA',
      text: '단가',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000.00",
      editor: {
        xtype: 'textfield',
        minValue: 1,
        format: "0,000.00",
        enforceMaxLength: true,
        allowBlank: true,
        maxLength: 10,
        maskRe: /[0-9.]/,
        selectOnFocus: true,
      },
      renderer: Ext.util.Format.numberRenderer('0,000.00'),
    }, {
      dataIndex: 'EFFECTIVESTARTDATE',
      text: '유효<br/>시작일자',
      xtype: 'datecolumn',
      width: 105,
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
    }, {
      dataIndex: 'EFFECTIVEENDDATE',
      text: '유효<br/>종료일자',
      xtype: 'datecolumn',
      width: 105,
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
    }, {
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 180,
      hidden: false,
      sortable: false,
      align: "left",
      editor: {
        allowBlank: true,
        xtype: "textfield",
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
      dataIndex: 'PRICESEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, ];

  items["api.40"] = {};
  $.extend(items["api.40"], {
    create: "<c:url value='/insert/item/ItemMasterPrice.do' />"
  });
  $.extend(items["api.40"], {
    read: "<c:url value='/select/item/ItemMasterPrice.do' />"
  });
  $.extend(items["api.40"], {
    update: "<c:url value='/update/item/ItemMasterPrice.do' />"
  });
  $.extend(items["api.40"], {
    destroy: "<c:url value='/delete/item/ItemMasterPrice.do' />"
  });

  items["btns.40"] = [];
  items["btns.40"].push({
    xtype: "button",
    text: "추가",
    itemId: "btnAdd40"
  });
  items["btns.40"].push({
    xtype: "button",
    text: "저장",
    itemId: "btnSav40"
  });
  items["btns.40"].push({
    xtype: "button",
    text: "삭제",
    itemId: "btnDel40"
  });
  items["btns.40"].push({
    xtype: "button",
    text: "새로고침",
    itemId: "btnRef40"
  });

  items["btns.ctr.40"] = {};
  $.extend(items["btns.ctr.40"], {
    "#btnAdd40": {
      click: 'btnAdd40Click'
    }
  });
  $.extend(items["btns.ctr.40"], {
    "#btnSav40": {
      click: 'btnSav40Click'
    }
  });
  $.extend(items["btns.ctr.40"], {
    "#btnDel40": {
      click: 'btnDel40Click'
    }
  });
  $.extend(items["btns.ctr.40"], {
    "#btnRef40": {
      click: 'btnRef40Click'
    }
  });

  items["dock.btn.40"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.40"],
    items: items["btns.40"],
  };

  items["docked.40"] = [];
  items["docked.40"].push(items["dock.btn.40"]);
}

function btnAdd40Click(o, e) {
  var model = Ext.create(gridnms["model.40"]);
  var store = this.getStore(gridnms["store.40"]);

  model.set("ORGID", $('#searchOrgId').val());
  model.set("COMPANYID", $('#searchCompanyId').val());
  model.set("ITEMCODE", $('#ItemCodeVal').val());
  model.set("EFFECTIVESTARTDATE", "${searchVO.TODAY}");
  model.set("EFFECTIVEENDDATE", "4999-12-31");

  store.insert(Ext.getStore(gridnms["store.40"]).count() + 1, model);
};

function btnSav40Click(button, e, eOpts) {
  var count = 0,
  msg = null;
  var mcount3 = Ext.getStore(gridnms["store.40"]).count();

  for (var k = 0; k < mcount3; k++) {
    var model = Ext.getStore(gridnms["store.40"]).data.items[k].data;
    var header = [],
    gubun = null;

    // 미입력 사항 체크
    var itemcode = model.UNITPRICEA + "";
    if (itemcode.length == 0) {
      header.push("단가");
      count++;
    }

    var itemname = model.EFFECTIVESTARTDATE + "";
    if (itemname.length == 0) {
      header.push("시작일자");
      count++;
    }

    var useyn = model.EFFECTIVEENDDATE + "";
    if (useyn.length == 0) {
      header.push("종료일자");
      count++;
    }

    if (count > 0) {
      extAlert("[필수항목 미입력]<br/>" + (k + 1) + "번째에서 " + header + " 항목이 누락되었습니다.");
      return;
    }
  }

  if (count == 0) {
    // 저장
    Ext.getStore(gridnms["store.40"]).sync({
      success: function (batch, options) {
        extAlert(msgs.noti.save, gridnms["store.40"]);

        Ext.getStore(gridnms["store.40"]).load();
      },
      failure: function (batch, options) {
        extAlert(batch.exceptions[0].error, gridnms["store.40"]);
      },
      callback: function (batch, options) {},
    });
  }
};

function btnDel40Click(o, e) {
  extGridDel(gridnms["store.40"], gridnms["panel.40"]);
};

function btnRef40Click(button, e, eOpts) {
  Ext.getStore(gridnms["store.40"]).load();
};

function setValues_PriceQ() {
  gridnms["models.priceq"] = [];
  gridnms["stores.priceq"] = [];
  gridnms["views.priceq"] = [];
  gridnms["controllers.priceq"] = [];

  gridnms["grid.50"] = "priceMasterq";

  gridnms["panel.50"] = gridnms["app"] + ".view." + gridnms["grid.50"];
  gridnms["views.priceq"].push(gridnms["panel.50"]);

  gridnms["controller.50"] = gridnms["app"] + ".controller." + gridnms["grid.50"];
  gridnms["controllers.priceq"].push(gridnms["controller.50"]);

  gridnms["model.50"] = gridnms["app"] + ".model." + gridnms["grid.50"];

  gridnms["store.50"] = gridnms["app"] + ".store." + gridnms["grid.50"];

  gridnms["models.priceq"].push(gridnms["model.50"]);

  gridnms["stores.priceq"].push(gridnms["store.50"]);

  fields["model.50"] = [{
      type: 'number',
      name: 'RN',
    }, {
      type: 'number',
      name: 'ORGID',
    }, {
      type: 'number',
      name: 'COMPANYID',
    }, {
      type: 'number',
      name: 'PRICESEQ',
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
      name: 'UOM'
    }, {
      type: 'string',
      name: 'UOMNAME',
    }, {
      type: 'number',
      name: 'UNITPRICEA',
    }, {
      type: 'string',
      name: 'CURRENCYCODE'
    }, {
      type: 'string',
      name: 'CURRENCYCODENAME',
    }, {
      type: 'date',
      name: 'EFFECTIVESTARTDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'date',
      name: 'EFFECTIVEENDDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'REMARKS',
    }, ];

  fields["columns.50"] = [
    // Display columns
    {
      dataIndex: 'RN',
      text: '순번',
      xtype: 'rownumberer',
      width: 45,
      hidden: false,
      sortable: false,
      resizable: false,
      align: "center",
    }, {
      dataIndex: 'UNITPRICEA',
      text: '단가',
      xtype: 'gridcolumn',
      width: 100,
      hidden: false,
      sortable: false,
      resizable: false,
      style: 'text-align:center;',
      align: "right",
      cls: 'ERPQTY',
      format: "0,000.00",

      renderer: Ext.util.Format.numberRenderer('0,000.00'),
    }, {
      dataIndex: 'EFFECTIVESTARTDATE',
      text: '유효<br/>시작일자',
      xtype: 'datecolumn',
      width: 105,
      hidden: false,
      sortable: true,
      align: "center",
      format: 'Y-m-d',

    }, {
      dataIndex: 'EFFECTIVEENDDATE',
      text: '유효<br/>종료일자',
      xtype: 'datecolumn',
      width: 105,
      hidden: false,
      sortable: true,
      align: "center",
      format: 'Y-m-d',

    }, {
      dataIndex: 'REMARKS',
      text: '비고',
      xtype: 'gridcolumn',
      width: 180,
      hidden: false,
      sortable: false,
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
      dataIndex: 'PRICESEQ',
      xtype: 'hidden',
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, ];

  items["api.50"] = {};
  $.extend(items["api.50"], {
    read: "<c:url value='/select/item/ItemMasterPrice.do' />"
  });

  items["btns.50"] = [];

  items["btns.ctr.50"] = {};

  items["dock.btn.50"] = {
    xtype: 'toolbar',
    dock: 'top',
    displayInfo: true,
    store: gridnms["store.50"],
    items: items["btns.50"],
  };

  items["docked.50"] = [];
}

function setExtGrid_Item() {
  Ext.define(gridnms["model.4"], {
    extend: Ext.data.Model,
    fields: fields["model.4"]
  });

  Ext.define(gridnms["model.5"], {
    extend: Ext.data.Model,
    fields: fields["model.5"]
  });

  Ext.define(gridnms["model.6"], {
    extend: Ext.data.Model,
    fields: fields["model.6"]
  });

  Ext.define(gridnms["model.7"], {
    extend: Ext.data.Model,
    fields: fields["model.7"]
  });
  Ext.define(gridnms["model.8"], {
    extend: Ext.data.Model,
    fields: fields["model.8"]
  });

  Ext.define(gridnms["store.4"], {
    extend: Ext.data.Store, // Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.4"],
            model: gridnms["model.4"],
            autoLoad: true,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.4"],
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                ITEMTYPE : $('#searchItemType option:selected').val(),
              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            },
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
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'UOM',
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
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'ITEM_TYPE',
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
              type: 'ajax',
              url: "<c:url value='/searchSmallCodeListLov.do' />",
              extraParams: {
                ORGID: $("#searchOrgId").val(),
                COMPANYID: $("#searchCompanyId").val(),
                BIGCD: 'CMM',
                MIDDLECD: 'MODEL',
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
              type: 'ajax',
              url: "<c:url value='/searchCustomernameLov.do' />",
              extraParams: {
                  ORGID: $('#searchOrgId option:selected').val(),
                  COMPANYID: $('#searchCompanyId option:selected').val(),
                  CUSTOMERTYPE: 'A',
              },
              reader: gridVals.reader,
            }
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.4"], {
    extend: Ext.app.Controller,
    refs: {
      itemGrid: '#itemGrid',
    },
    stores: [gridnms["store.4"]],
    control: items["btns.ctr.4"],

    btnAdd4Click: btnAdd4Click,
    btnDel4Click: btnDel4Click,
    btnSav4Click: btnSav4Click,
    btnRef4Click: btnRef4Click,
    onMyviewItemClick: onMyviewItemClick,

  });

  Ext.define(gridnms["panel.4"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.4"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'rowmodel',
        mode: 'SINGLE',
        ignoreRightMouseSelection: false,
        allowDeselect: false,
        toggleOnClick: false,
        itemId: gridnms["panel.4"],
        id: gridnms["panel.4"],
        store: gridnms["store.4"],
        height: 303, // 400,
        border: 2,
        scrollable: true,
        columns: fields["columns.4"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'itemGrid',
          trackOver: true,
          loadMask: true,
          listeners: {
            refresh: function (dataView) {
              Ext.each(dataView.panel.columns, function (column) {
                if (column.dataIndex.indexOf('ITEMNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 150) {
                    column.width = 150;
                  }
                }

                if (column.dataIndex.indexOf('MODELNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 80) {
                    column.width = 80;
                  }
                }

                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 150) {
                    column.width = 150;
                  }
                }

                //                 if (column.dataIndex.indexOf('REMARKS') >= 0) {
                //                   column.autoSize();
                //                   column.width += 5;
                //                   if (column.width < 160) {
                //                     column.width = 160;
                //                   }
                //                 }
              });
            }
          },
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
            listeners: {
              "beforeedit": function (editor, ctx, eOpts) {
                var data = Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.item"]).selModel.getSelection()[0].id);

                var editDisableCols = [];

                var itemtype = data.data.ITEMTYPE;

                editDisableCols.push("SALESPRICE");
                editDisableCols.push("ITEMTYPENAME");

                if (itemtype != "M") {
                  editDisableCols.push("ORDERINSPECTIONYN");
                  editDisableCols.push("INVENTORYMANAGEYN");
                  editDisableCols.push("SAFETYINVENTORY");
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
        dockedItems: items["docked.4"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.item"],
    stores: gridnms["stores.item"],
    views: gridnms["panel.4"],
    controllers: gridnms["controller.4"],

    launch: function () {
      gridItemarea = Ext.create(gridnms["panel.4"], {
          renderTo: 'gridItemArea'
        });
    },
  });
}

function setExtGrid_Price() {
  Ext.define(gridnms["model.40"], {
    extend: Ext.data.Model,
    fields: fields["model.40"]
  });

  Ext.define(gridnms["store.40"], {
    extend: Ext.data.Store, // Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.40"],
            model: gridnms["model.40"],
            autoLoad: false,
            pageSize: gridVals.pageSize,
            proxy: {
              type: 'ajax',
              api: items["api.40"],
              extraParams: {
                orgid: $("#searchOrgId").val(),
                companyid: $("#searchCompanyId").val(),

              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            },
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.40"], {
    extend: Ext.app.Controller,
    refs: {
      priceGrid: '#priceGrid',
    },
    stores: [gridnms["store.40"]],
    control: items["btns.ctr.40"],

    btnAdd40Click: btnAdd40Click,
    btnDel40Click: btnDel40Click,
    btnSav40Click: btnSav40Click,
    btnRef40Click: btnRef40Click,
  });

  Ext.define(gridnms["panel.40"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.40"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'rowmodel',
        itemId: gridnms["panel.40"],
        id: gridnms["panel.40"],
        store: gridnms["store.40"],
        height: 145, // 250,
        border: 2,
        scrollable: true,
        columns: fields["columns.40"],
        defaults: gridVals.defaultField,
        viewConfig: {
          itemId: 'priceGrid',
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
            listeners: {
              "beforeedit": function (editor, ctx, eOpts) {
                var editDisableCols = [];
                editDisableCols.push("UNITPRICEA");

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
        dockedItems: items["docked.40"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.price"],
    stores: gridnms["stores.price"],
    views: gridnms["panel.40"],
    controllers: gridnms["controller.40"],

    launch: function () {
      gridItemPricearea = Ext.create(gridnms["panel.40"], {
          renderTo: 'gridItemPriceArea'
        });
    },
  });
}

function setExtGrid_PriceQ() {
  Ext.define(gridnms["model.50"], {
    extend: Ext.data.Model,
    fields: fields["model.50"]
  });

  Ext.define(gridnms["store.50"], {
    extend: Ext.data.JsonStore, // Ext.data.Store,
    constructor: function (cfg) {
      var me = this;
      cfg = cfg || {};
      me.callParent([Ext.apply({
            storeId: gridnms["store.50"],
            model: gridnms["model.50"],
            autoLoad: false,
            isStore: false,
            autoDestroy: true,
            clearOnPageLoad: true,
            clearRemovedOnLoad: true,
            pageSize: 9999,
            proxy: {
              type: 'ajax',
              api: items["api.50"],
              extraParams: {
                orgid: $("#searchOrgId").val(),
                companyid: $("#searchCompanyId").val(),

              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            },
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.50"], {
    extend: Ext.app.Controller,
    refs: {
      priceGridList: '#priceGridList',
    },
    stores: [gridnms["store.50"]],

  });

  Ext.define(gridnms["panel.50"], {
    extend: Ext.panel.Panel,
    alias: 'widget.' + gridnms["panel.50"],
    layout: 'fit',
    header: false,
    items: [{
        xtype: 'gridpanel',
        selType: 'rowmodel',
        itemId: gridnms["panel.50"],
        id: gridnms["panel.50"],
        store: gridnms["store.50"],
        height: 145, // 250,
        border: 2,
        scrollable: true,
        columns: fields["columns.50"],
        viewConfig: {
          itemId: 'priceGridList',
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
          }
        ],
        dockedItems: items["docked.50"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.priceq"],
    stores: gridnms["stores.priceq"],
    views: gridnms["panel.50"],
    controllers: gridnms["controller.50"],

    launch: function () {
      gridarea3 = Ext.create(gridnms["panel.50"], {
          renderTo: 'gridItemPriceAreaList'
        });
    },
  });
}

function fn_search() {
  // 필수 체크
  var orgid = $('#searchOrgId option:selected').val();
  var companyid = $('#searchCompanyId option:selected').val();
  var itemtype = $('#searchItemType option:selected').val();
  var itemcode = $('#searchItemCode').val();
  var itemname = $('#searchItemName').val();
  var ordername = $('#searchOrderName').val();
  var model = $('#searchModelName option:selected').val();
  var customercode = $('#searchCustomerCode').val();
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
    ORGID: orgid,
    COMPANYID: companyid,
    ITEMTYPE: itemtype,
    ITEMCODE: itemcode,
    ITEMNAME: itemname,
    ORDERNAME: ordername,
    MODEL: model,
    CUSTOMERCODE: customercode,
  };

  extGridSearch(sparams, gridnms["store.4"]);

  switch (groupid) {
  case "ROLE_ADMIN":
  case "ROLE_MANAGER":
    Ext.getStore(gridnms["store.40"]).removeAll();
    break;
  default:
    Ext.getStore(gridnms["store.50"]).removeAll();
    break;
  }
}

function setLovList() {
  // 거래처명 lov
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
              UNITPRICEDIV: m.UNITPRICEDIV,
              UNITPRICEDIVNAME: m.UNITPRICEDIVNAME,
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
            <div id="content" >
                <div id="cur_loc">
                    <div id="cur_loc_align">
                        <ul>
                            <li>HOME</li>
                            <li>&gt;</li>
                            <li>기준정보</li>
                            <li>&gt;</li>
                            <li><strong>${pageTitle}</strong></li>
                        </ul>
                    </div>
                </div>
                <!-- 검색 필드 박스 시작 -->
                <div id="search_field" style="margin-bottom:0px;">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                    <input type="hidden" id="OrgidVal" value="<c:out value='${OrgidVal}'/>" />
                    <input type="hidden" id="CompanyidVal" value="<c:out value='${CompanyidVal}'/>" />
                    <input type="hidden" id="ItemCodeVal" value="<c:out value='${ItemCodeVal}'/>" />
                    <input type="hidden" id="BigcdVal" value="<c:out value='${BigcdVal}'/>" />
                    <input type="hidden" id="MiddlecdVal" value="<c:out value='${MiddlecdVal}'/>" />
                        <fieldset>
                            <legend>조건정보 영역</legend>
                            <div>
                                <table class="tbl_type_view" border="1">
										                <colgroup>
										                        <col width="120px">
										                        <col width="20%">
										                        <col width="120px">
										                        <col width="20%">
										                        <col width="120px">
										                        <col width="20%">
										                        <col>
										                </colgroup>
										                <tr>
										                        <th class="required_text">사업장</th>
										                        <td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 80%;">
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
										                        <th class="required_text">공장</th>
										                        <td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 80%;">
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
										                        <th class="required_text">유형</th>
										                        <td><select id="searchItemType" name="searchItemType" class="input_left validate[required]" style="width: 97%;">
										                                        <c:if test="${empty searchVO.STATUS}">
										                                                <option value="">전체</option>
										                                        </c:if>
										                                        <c:forEach var="item" items="${labelBox.findByItemType}" varStatus="status">
										                                                <c:choose>
										                                                        <c:when test="${item.VALUE==searchVO.STATUS}">
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
										                                        <div class="buttons" style="float: right;">
										                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
										                                        </div>
										                                </div>
										                        </td>
										                </tr>
										                <tr style="height: 34px;">
                                            <th class="required_text">품번</th>
                                            <td>
                                                <input type="text" id="searchOrderName" name="searchOrderName" class="input_left" style="width: 97%;" />
                                            </td>
										                        <th class="required_text">품명</th>
										                        <td>
												                        <input type="text" id="searchItemName" name="searchItemName" class="input_left" style="width: 97%;" />
												                        <input type="hidden" id="searchItemCode" name="searchItemCode" />
										                        </td>
										                        <th class="required_text">모델명</th>
										                        <td><select id="searchModelName" name="searchModelName" class="input_left validate[required]" style="width: 97%;">
										                                        <c:if test="${empty searchVO.STATUS}">
										                                                <option value="">전체</option>
										                                        </c:if>
										                                        <c:forEach var="item" items="${labelBox.findByModelType}" varStatus="status">
										                                                <c:choose>
										                                                        <c:when test="${item.VALUE==searchVO.STATUS}">
										                                                                <option value="${item.VALUE}" selected>${item.LABEL}</option>
										                                                        </c:when>
										                                                        <c:otherwise>
										                                                                <option value="${item.VALUE}">${item.LABEL}</option>
										                                                        </c:otherwise>
										                                                </c:choose>
										                                        </c:forEach>
										                        </select></td>
										                        <td></td>
										                </tr>
										                <tr>
										                        <th class="required_text">거래처</th>
										                        <td>
												                        <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left" style="width: 97%;" />
												                        <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" />
										                        </td>
										                        <td colspan="5"></td>
										                </tr>
										        </table>
                            </div>
                        </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->
                <div>
                    <table style="width: 100%;">
                        <tr>
                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">품목마스터</div></td>
                        </tr>
                    </table>
                    <div id="gridItemArea" style="width: 100%; padding-bottom: 15px; float: left;"></div>
                   
<!--                     <br>&nbsp; -->
                    <sec:authorize ifAnyGranted="ROLE_ADMIN, ROLE_MANAGER">
	                    <div>
		                    <table style="width: 100%">
		                      <tr>
		                        <td style="width: 48%;"><div class="subConTit2">단가 List 관리</div></td>
		                      </tr>
		                    </table>
		                    <div id="gridItemPriceArea" style="width: 48%; padding-bottom: 5px; padding-top: 5px; float: left;"></div>
		                  </div>
                    </sec:authorize>                
                    <sec:authorize ifNotGranted="ROLE_ADMIN, ROLE_MANAGER">
                      <div>
                        <table style="width: 100%">
                          <tr>
                            <td style="width: 48%;"><div class="subConTit2">단가 List 조회</div></td>
                          </tr>
                        </table>
                        <div id="gridItemPriceAreaList" style="width: 48%; padding-bottom: 5px; padding-top: 5px; float: left;"></div>
                      </div>
                    </sec:authorize>                
                </div>
            </div>
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