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

	  setLovList();
	  setReadOnly();
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

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "material";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_Inventory();
	}

	function setValues_Inventory() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "InventoryReceiptList";

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
	      name: 'TRXMONTHS',
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
	      name: 'ITEMSTANDARD',
	    }, {
	      type: 'string',
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMTYPE',
	    }, {
	      type: 'string',
	      name: 'ITEMTYPENAME',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'string',
	      name: 'SAFETYINVENTORY',
	    }, {
	      type: 'string',
	      name: 'INQTY',
	    }, {
	      type: 'string',
	      name: 'OUTQTY',
	    }, {
	      type: 'string',
	      name: 'INVQTY',
	    },
	  ];

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
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'ITEMTYPENAME',
	      text: '유형',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
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
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      text: '규격',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'MATERIALTYPE',
	      text: '재질',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '공급사',
	      xtype: 'gridcolumn',
	      width: 300,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'SAFETYINVENTORY',
	      text: '적정재고<br/>수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'BACKQTY',
	      text: '이월수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'INQTY',
	      text: '입고수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'OUTQTY',
	      text: '출고수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'INVQTY',
	      text: '재고수량',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var invsafeqty = record.data.INVSAFEQTY * 1;
	        var presentinventoryqty = record.data.PRESENTINVENTORYQTY * 1;
	        if (presentinventoryqty < 0 || invsafeqty > presentinventoryqty) {
	          meta.style = "color:rgb(255, 0, 0) ;";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	      //        renderer: function (value, meta, record) {
	      //          var safety = record.data.SAFETYINVENTORY * 1;
	      //          var result = value * 1;

	      //          if (safety > result) {
	      //            // 안전재고 > 현재고 일 경우
	      //            meta.style = "color:rgb(255, 0, 0) ;";
	      //          }
	      //          return Ext.util.Format.number(value, '0,000');
	      //        },
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'YYYYMM',
	      xtype: 'hidden',
	    }, {
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
	      dataIndex: 'BIGNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MIDDLECODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MIDDLENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SMALLCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SMALLNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/material/release/InventoryReceiptList.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};

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

	var gridarea;
	function setExtGrid() {
	  setExtGrid_Inventory();
	}

	function setExtGrid_Inventory() {
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
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                YYYYMM: $("#searchMonth").val() + "",
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
	      inventoryList: '#inventoryList',
	    },
	    stores: [gridnms["store.1"]],
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
	        height: 654,
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
	          itemId: 'inventoryList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ITEMSTANDARD') >= 0 || column.dataIndex.indexOf('MATERIALTYPE') >= 0 || column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
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
	  var searchMonth = $("#searchMonth").val();
	  var searchItemCode = $("#searchItemCode").val();
	  var searchItemType = $("#searchItemType").val();
	  var searchOrderName = $("#searchOrderName").val();
	  var searchItemName = $("#searchItemName").val();
	  var searchItemStandard = $("#searchItemStandard").val();
	  var searchCustomerCode = $("#searchCustomerCode").val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    YYYYMM: searchMonth,
	    ITEMCODE: searchItemCode,
	    ITEMTYPE: searchItemType,
	    ORDERNAME: searchOrderName,
	    ITEMNAME: searchItemName,
	    ITEMSTANDARD: searchItemStandard,
	    CUSTOMERCODE: searchCustomerCode,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchMonth = $("#searchMonth").val();
	  var searchItemCode = $("#searchItemCode").val();
	  var searchItemType = $("#searchItemType").val();
	  var searchOrderName = $("#searchOrderName").val();
	  var searchItemName = $("#searchItemName").val();
	  var searchItemStandard = $("#searchItemStandard").val();
	  var searchCustomerCode = $("#searchCustomerCode").val();
	  var title = $('#title').val();

	  go_url("<c:url value='/material/release/ExcelDownload.do?GUBUN='/>" + "INVENTORY"
	     + "&ORGID=" + orgid + ""
	     + "&COMPANYID=" + companyid + ""
	     + "&YYYYMM=" + searchMonth + ""
	     + "&ITEMCODE=" + searchItemCode + ""
	     + "&ORDERNAME=" + searchOrderName + ""
	     + "&ITEMNAME=" + searchItemName + ""
	     + "&ITEMSTANDARD=" + searchItemStandard + ""
	     + "&ITEMTYPE=" + searchItemType + ""
	     + "&CUSTOMERCODE=" + searchCustomerCode + ""
	     + "&TITLE=" + title + "");
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  //    // 품명 Lov
	  //    $("#searchItemName")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        $("#searchItemCode").val("");
	  //        $("#searchOrderName").val("");
	  //        break;
	  //      case $.ui.keyCode.ENTER:
	  //        $(this).autocomplete("search", "%");
	  //        break;

	  //      default:
	  //        break;
	  //      }
	  //    })
	  //    .bind("keyup", function (e) {
	  //      if (this.value === "")
	  //        $(this).autocomplete("search", "%");
	  //    })
	  //    .focus(function (e) {
	  //      $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  //    })
	  //    .click(function (e) {
	  //      $(this).autocomplete("search", "%");
	  //    })
	  //    .autocomplete({
	  //      source: function (request, response) {
	  //        $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	  //          keyword: extractLast(request.term),
	  //          ORGID: $('#searchOrgId option:selected').val(),
	  //          COMPANYID: $('#searchCompanyId option:selected').val(),
	  //          MATGUBUN: 'ITEMNAME', // 제품, 반제품 조회
	  //          ITEMGROUP: 'M',
	  //          ITEMTYPE: $('#searchItemType option:selected').val(),
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ITEMNAME + ', ' + m.ORDERNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //                ITEMGUBUN: m.ITEMGUBUN,
	  //              });
	  //            }));
	  //        });
	  //      },
	  //      search: function () {
	  //        if (this.value === "")
	  //          return;

	  //        var term = extractLast(this.value);
	  //        if (term.length < 1) {
	  //          return false;
	  //        }
	  //      },
	  //      focus: function () {
	  //        return false;
	  //      },
	  //      select: function (e, o) {
	  //        $("#searchItemCode").val(o.item.value);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ITEMGUBUN);
	  //        return false;
	  //      }
	  //    });

	  //    // 품번 Lov
	  //    $("#searchOrderName")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        $("#searchItemCode").val("");
	  //        $("#searchItemName").val("");
	  //        break;
	  //      case $.ui.keyCode.ENTER:
	  //        $(this).autocomplete("search", "%");
	  //        break;

	  //      default:
	  //        break;
	  //      }
	  //    })
	  //    .bind("keyup", function (e) {
	  //      if (this.value === "")
	  //        $(this).autocomplete("search", "%");
	  //    })
	  //    .focus(function (e) {
	  //      $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  //    })
	  //    .click(function (e) {
	  //      $(this).autocomplete("search", "%");
	  //    })
	  //    .autocomplete({
	  //      source: function (request, response) {
	  //        $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	  //          keyword: extractLast(request.term),
	  //          ORGID: $('#searchOrgId option:selected').val(),
	  //          COMPANYID: $('#searchCompanyId option:selected').val(),
	  //          MATGUBUN: 'ORDERNAME', // 제품, 반제품 조회
	  //          ITEMGROUP: 'M',
	  //          ITEMTYPE: $('#searchItemType option:selected').val(),
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ORDERNAME + ', ' + m.ITEMNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //                ITEMGUBUN: m.ITEMGUBUN,
	  //              });
	  //            }));
	  //        });
	  //      },
	  //      search: function () {
	  //        if (this.value === "")
	  //          return;

	  //        var term = extractLast(this.value);
	  //        if (term.length < 1) {
	  //          return false;
	  //        }
	  //      },
	  //      focus: function () {
	  //        return false;
	  //      },
	  //      select: function (e, o) {
	  //        $("#searchItemCode").val(o.item.value);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ITEMGUBUN);
	  //        return false;
	  //      }
	  //    });

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
								<input type="hidden" id="tempMonth" value="${dateMonth}" />
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
								<div id="search_field">
										<div id="search_field_loc">
												<h2>
														<strong>${pageTitle}</strong>
												</h2>
										</div>
										<fieldset style="width: 100%;">
												<legend>조건정보 영역</legend>

												<form id="master" name="master" action="" method="post">
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
                            <input type="hidden" id="searchItemCode" name="searchItemCode" />
                            <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" />
														<div>
																<table class="tbl_type_view" border="1">
																		<colgroup>
																				<col width="120px">
																				<col width="114px">
																				<col width="120px">
                                        <col width="114px">
																				<col width="120px">
																				<col>
                                        <col width="120px">
                                        <col>
																		</colgroup>
																		<tr style="height: 34px;">
                                        <td colspan="2">
                                            <select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 75%;">
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
                                            <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 75%;">
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
                                        <td colspan="4">
																						<div class="buttons" style="float: right; margin-top: 3px;">
																								<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
																								<a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a>
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
                                        <th class="required_text">년월</th>
                                        <td>
                                          <input type="text" id="searchMonth" name="searchMonth" class="input_validation input_center" style="width: 100px; min-width: 100px;" maxlength="7" value="${searchVO.TODAY}" />
                                        </td>
                                        <th class="required_text">유형</th>
                                        <td><select id="searchItemType" name="searchItemType" class="input_left validate[required]" style="width: 97%;">
                                                        <c:if test="${empty searchVO.ITEMTYPE}">
                                                                <option value="">전체</option>
                                                        </c:if>
                                                        <c:forEach var="item" items="${labelBox.findByItemType}" varStatus="status">
                                                                <c:choose>
                                                                        <c:when test="${item.VALUE==searchVO.ITEMTYPE}">
                                                                                <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                                <option value="${item.VALUE}">${item.LABEL}</option>
                                                                        </c:otherwise>
                                                                </c:choose>
                                                        </c:forEach>
                                        </select></td>
                                        <th class="required_text">품명</th>
                                        <td>
                                          <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td>
                                          <input type="text" id="searchOrderName" name="searchOrderName" class="imetype  input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false"  style="width: 97%;"  />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">규격</th>
                                        <td >
                                            <input type="text" id="searchItemStandard" name="searchItemStandard"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                        </td>
                                        <th class="required_text">공급사</th>
                                        <td>
                                            <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                        <td></td>
                                    </tr>
                                </table>
														</div>
												</form>
										</fieldset>
								</div>
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