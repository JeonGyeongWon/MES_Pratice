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

	  setTimeout(function () {

	    setValues();
	    setExtGrid();

	  }, 200);

	  setReadOnly();

	  setLovList();
	});

	var routingdata = {};
	function setInitial() {
	  $('#searchMonth').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchMonth").val(getToDay("${searchVO.dateMonth}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_list();
	}

	function setValues_list() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "ProdStatusList";

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
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
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
	      type: 'date',
	      name: 'SEARCHDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'number',
	      name: 'MATERIALQTY',
	    }, {
	      type: 'number',
	      name: 'ROUT01',
	    }, {
	      type: 'number',
	      name: 'ROUT02',
	    }, {
	      type: 'number',
	      name: 'ROUT03',
	    }, {
	      type: 'number',
	      name: 'ROUT04',
	    }, {
	      type: 'number',
	      name: 'ROUT05',
	    }, {
	      type: 'number',
	      name: 'ROUT06',
	    }, {
	      type: 'number',
	      name: 'ROUT07',
	    }, {
	      type: 'number',
	      name: 'ROUT08',
	    }, {
	      type: 'number',
	      name: 'ROUT09',
	    }, {
	      type: 'number',
	      name: 'ROUT10',
	    }, {
	      type: 'number',
	      name: 'ROUT11',
	    }, {
	      type: 'number',
	      name: 'ROUT12',
	    }, {
	      type: 'number',
	      name: 'ROUT13',
	    }, {
	      type: 'number',
	      name: 'ROUT14',
	    }, {
	      type: 'number',
	      name: 'ROUT15',
	    }, {
	      type: 'number',
	      name: 'ROUT16',
	    }, {
	      type: 'number',
	      name: 'ROUT17',
	    }, {
	      type: 'number',
	      name: 'ROUT18',
	    }, {
	      type: 'number',
	      name: 'ROUT19',
	    }, {
	      type: 'number',
	      name: 'ROUT20',
	    }, {
	      type: 'number',
	      name: 'ROUT21',
	    }, {
	      type: 'number',
	      name: 'ROUT22',
	    }, {
	      type: 'number',
	      name: 'ROUT23',
	    }, {
	      type: 'number',
	      name: 'ROUT24',
	    }, {
	      type: 'number',
	      name: 'ROUT25',
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
	      style: 'text-align:center; ',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'SEARCHDATE',
	      text: '일자',
	      xtype: 'datecolumn',
	      width: 95,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	      summaryRenderer: function (value, meta, record) {
	        return ['총합계'].map(function (val) {
	          return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + val + '</div>';
	        }).join('<br />');
	      },
	      renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	    }, {
	      dataIndex: 'MATERIALQTY',
	      text: '소재',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: true,
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
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT01',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT02',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT03',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT04',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT05',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT06',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT07',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT08',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT09',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT10',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT11',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT12',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT13',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT14',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT15',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT16',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT17',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT18',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT19',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT20',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT21',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT22',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT23',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT24',
	      //        xtype: 'hidden',
	      //      }, {
	      //        dataIndex: 'ROUT25',
	      //        xtype: 'hidden',
	    },
	  ];

	  var orgid = $('#searchOrgId').val();
	  var companyid = $('#searchCompanyId').val();
	  var itemcode = $('#searchItemCode').val();

	  if (itemcode != "") {

	    var routingcount = routingdata.label.length;
	    (function (i) {
	      for (var i = 0; i < routingcount; i++) {

	        fields["columns.1"].push({
	          dataIndex: 'ROUT' + fn_lpad(routingdata.value[i] + "", 2, '0'),
	          text: routingdata.label[i].replace(/ /gi, "<br/>"),
	          xtype: 'gridcolumn',
	          width: 75,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center; font-size: 8pt !important;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          summaryType: 'sum',
	          summaryRenderer: function (value, summaryData, dataIndex) {
	            var data = Ext.getStore(gridnms["store.1"]).getData().items;
	            var values = extExtractValues(data, dataIndex);
	            var total = value;

	            var result = [total].map(function (val) {
	              return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(val, '0,000') + '</div>';
	            }).join('<br />');
	            return result;
	          },
	          renderer: Ext.util.Format.numberRenderer('0,000'),
	        });
	      }
	    })(i);
	  }

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/manage/ProdStatusList.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};

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

	var gridarea;
	function setExtGrid() {
	  setExtGrid_list();

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function setExtGrid_list() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
	  });

	  Ext.define(gridnms["store.1"], {
	    extend: Ext.data.JsonStore,
	    constructor: function (cfg) {
	      var me = this;
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
	                SEARCHMONTH: $('#searchMonth').val(),
	              },
	              reader: gridVals.reader,
	              //               writer: $.extend(gridVals.writer, {
	              //                 writeAllFields: true
	              //               }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      ProdStatusList: '#ProdStatusList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	  });

	  Ext.define(gridnms["panel.1"], {
	    extend: Ext.panel.Panel,
	    //         requires: [
	    //           'Ext.grid.selection.SpreadsheetModel',
	    //           'Ext.grid.plugin.Clipboard',
	    //         ],
	    alias: 'widget.' + gridnms["panel.1"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel', // 'spreadsheet',
	        //         allowDeselect: true,
	        //         mode: "SINGLE", // "MULTI",
	        //         cellSelect: true,
	        //         dragSelect: true,
	        //         ignoreRightMouseSelection: true,
	        //         columnSelect: true,
	        //         pruneRemoved: false,
	        //         rowSelect: false,
	        itemId: gridnms["panel.1"],
	        id: gridnms["panel.1"],
	        store: gridnms["store.1"],
	        height: 597,
	        border: 2,
	        features: [{
	            ftype: 'summary',
	            dock: 'bottom'
	          }
	        ],
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        //                 selModel: {
	        //                   type: 'spreadsheet',
	        //                   rowNumbererHeaderWidth: 0,
	        //                 },
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	            //                       }, {
	            //                         // CTRL+C/X/V 활성화
	            //                         ptype: 'clipboard',
	          },
	        ],
	        viewConfig: {
	          itemId: 'ProdStatusList',

	          trackOver: true,
	          loadMask: true,
	        },
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
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchMonth = $('#searchMonth').val();
	  var searchItemCode = $('#searchItemCode').val();
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

	  if (searchItemCode == "") {
	    header.push("품번/품명");
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
	  var searchMonth = $('#searchMonth').val();
	  var searchItemCode = $('#searchItemCode').val();
	  var searchOrderName = $('#searchOrderName').val();
	  var searchItemName = $('#searchItemName').val();
	  var searchModel = $('#searchModel').val();
	  var searchModelName = $('#searchModelName').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHMONTH: searchMonth,
	    ITEMCODE: searchItemCode,
	    ORDERNAME: searchOrderName,
	    ITEMNAME: searchItemName,
	    MODEL: searchModel,
	    MODELNAME: searchModelName,
	  };

	  var url_t = "<c:url value='/select/prod/manage/ProdStatusTotalList.do'/>";
	  $.ajax({
	    url: url_t,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {
	      var dataList = data.data[0];

	      var workorderqty = dataList.WORKORDERQTY;
	      var shipqty = dataList.SHIPQTY;
	      var bomqty = dataList.BOMQTY;
	      var ncrqty = dataList.NCRQTY;

	      setTimeout(function () {

	        $("#WORKORDERQTY").val(Ext.util.Format.number(workorderqty, '0,000'));
	        $("#SHIPQTY").val(Ext.util.Format.number(shipqty, '0,000'));
	        $("#BOMQTY").val(Ext.util.Format.number(bomqty, '0,000'));
	        $("#NCRQTY").val(Ext.util.Format.number(ncrqty, '0,000'));
	      }, 800);
	    },
	    error: ajaxError
	  });

	  setValues_list();
	  Ext.suspendLayouts();
	  Ext.getCmp(gridnms["panel.1"]).reconfigure(gridnms["store.1"], fields["columns.1"]);
	  Ext.resumeLayouts(true);
	  extGridSearch(sparams, gridnms["store.1"]);
	  //       extSpreadSearch(sparams, gridnms["store.1"], gridnms["panel.1"]);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {

	  // 품번 LOV
	  $("#searchOrderName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //          $("#searchOrderName").val("");
	      $("#searchItemCode").val("");
	      $("#searchItemName").val("");
	      $("#searchModel").val("");
	      $("#searchModelName").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })
	  .bind("keyup", function (e) {
	    if (this.value === "")
	      $(this).autocomplete("search", "%");
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .click(function (e) {
	    $(this).autocomplete("search", "%");
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GUBUN: 'ORDERNAME',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.ORDERNAME + ', ' + m.ITEMNAME + ', ' + m.MODELNAME,
	              value: m.ITEMCODE,
	              ITEMNAME: m.ITEMNAME,
	              ORDERNAME: m.ORDERNAME,
	              MODEL: m.MODEL,
	              MODELNAME: m.MODELNAME,
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
	      $("#searchItemCode").val(o.item.ITEMCODE);
	      $("#searchItemName").val(o.item.ITEMNAME);
	      $("#searchOrderName").val(o.item.ORDERNAME);
	      $("#searchModel").val(o.item.MODEL);
	      $("#searchModelName").val(o.item.MODELNAME);

	      var orgid = $('#searchOrgId').val();
	      var companyid = $('#searchCompanyId').val();
	      var itemcode = $('#searchItemCode').val();
	      if (itemcode != "") {
	        var searchdate = $('#searchMonth').val();
	        routingdata.label = fn_option_routing_data(orgid, companyid, itemcode, searchdate, 'LABEL');
	        routingdata.value = fn_option_routing_data(orgid, companyid, itemcode, searchdate, 'VALUE');
	      }

	      return false;
	    }
	  });

	  // 품명 LOV
	  $("#searchItemName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchOrderName").val("");
	      $("#searchItemCode").val("");
	      $("#searchModel").val("");
	      $("#searchModelName").val("");

	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })
	  .bind("keyup", function (e) {
	    if (this.value === "")
	      $(this).autocomplete("search", "%");
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .click(function (e) {
	    $(this).autocomplete("search", "%");
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchItemNameLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        GUBUN: 'ITEMNAME',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              label: m.ITEMNAME + ', ' + m.ORDERNAME + ', ' + m.MODELNAME,
	              value: m.ITEMCODE,
	              ITEMNAME: m.ITEMNAME,
	              ORDERNAME: m.ORDERNAME,
	              MODEL: m.MODEL,
	              MODELNAME: m.MODELNAME,
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
	      $("#searchItemCode").val(o.item.ITEMCODE);
	      $("#searchItemName").val(o.item.ITEMNAME);
	      $("#searchOrderName").val(o.item.ORDERNAME);
	      $("#searchModel").val(o.item.MODEL);
	      $("#searchModelName").val(o.item.MODELNAME);

	      var orgid = $('#searchOrgId').val();
	      var companyid = $('#searchCompanyId').val();
	      var itemcode = $('#searchItemCode').val();
	      if (itemcode != "") {
	        var searchdate = $('#searchMonth').val();
	        routingdata.label = fn_option_routing_data(orgid, companyid, itemcode, searchdate, 'LABEL');
	        routingdata.value = fn_option_routing_data(orgid, companyid, itemcode, searchdate, 'VALUE');
	      }

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
	                        <li>공정현황</li>
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
                      <input type="hidden" id="title" name="title" value="${pageTitle}"/>
                      <input type="hidden" id="searchItemCode" name="searchItemCode" />
                      <input type="hidden" id="searchModel" name="searchModel" />
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
                                  <td >
                                      <input type="text" id="searchMonth" name="searchMonth" class="input_validation input_center " style="width: 90px; " maxlength="8" />
                                  </td>
                                  <th class="required_text">품번</th>
                                  <td>
                                      <input type="text" id="searchOrderName" name="searchOrderName" class="input_validation input_left"  onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                  </td>
                                  <th class="required_text">품명</th>
                                  <td >
                                      <input type="text" id="searchItemName" name="searchItemName"  class="input_validation input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
                                  </td>
                                  <th class="required_text">기종</th>
                                  <td >
                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" readonly />
                                  </td>
	                            </tr>
                              <tr style="height: 34px;">
		                              <td></td>
		                              <td></td>
		                              <td></td>
		                              <td></td>
		                              <td></td>
		                              <td></td>
		                              <td></td>
		                              <td></td>
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
                                  <th class="required_text">작지수량</th>
                                  <td >
                                      <input type="text" id="WORKORDERQTY" name="WORKORDERQTY" class="input_right " style="width: 97%; " readonly />
                                  </td>
                                  <th class="required_text">출하수량</th>
                                  <td>
                                      <input type="text" id="SHIPQTY" name="SHIPQTY" class="input_right " style="width: 97%; " readonly />
                                  </td>
                                  <th class="required_text">소재수량</th>
                                  <td >
                                      <input type="text" id="BOMQTY" name="BOMQTY" class="input_right " style="width: 97%; " readonly />
                                  </td>
                                  <th class="required_text">불량수량</th>
                                  <td >
                                      <input type="text" id="NCRQTY" name="NCRQTY" class="input_right " style="width: 97%; " readonly />
                                  </td>
                              </tr>
                          </table>
	                    </div>
	                </form>
	            </fieldset>
	            </div>
	            <!-- //검색 필드 박스 끝 -->
	            
              <table style="width: 100%;">
                  <tr>
                      <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">진행현황</div></td>
                  </tr>
              </table>
              <div id="gridArea" style="width: 100%; margin-top: 0px; padding-bottom: 5px; float: left;"></div>
	        </div>
	        <!-- //content 끝 -->
	    </div>
	    <!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 2645px; padding-top: 0px; float: left;"></div>
	    <!-- footer 시작 -->
	    <div id="footer">
	        <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
	    </div>
	    <!-- //footer 끝 -->
	</div>
	<!-- //전체 레이어 끝 -->
</body>
</html>