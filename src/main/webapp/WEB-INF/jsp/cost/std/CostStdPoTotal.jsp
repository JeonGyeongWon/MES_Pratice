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

	  setValues_Popup();
	  setExtGrid_Popup();

	  $("#gridPopup1Area").hide("blind", {
	    direction: "up"
	  }, "fast");

	  setReadOnly();
	});

	function setInitial() {
	  $("#searchYear").val(getToDay("${searchVO.searchYear}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "cost";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_total();
	}

	function setValues_total() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "CostStdPoTotal";

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
	      name: 'LICENSENO',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERNAME',
      }, {
	      type: 'string',
	      name: 'CUSTOMERTYPE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERTYPENAME',
	    }, {
	      type: 'string',
	      name: 'SEARCHYEAR',
	    }, {
	      type: 'string',
	      name: 'MONTH01',
	    }, {
	      type: 'string',
	      name: 'MONTH02',
	    }, {
	      type: 'string',
	      name: 'MONTH03',
	    }, {
	      type: 'string',
	      name: 'MONTH04',
	    }, {
	      type: 'string',
	      name: 'MONTH05',
	    }, {
	      type: 'string',
	      name: 'MONTH06',
	    }, {
	      type: 'string',
	      name: 'MONTH07',
	    }, {
	      type: 'string',
	      name: 'MONTH08',
	    }, {
	      type: 'string',
	      name: 'MONTH09',
	    }, {
	      type: 'string',
	      name: 'MONTH10',
	    }, {
	      type: 'string',
	      name: 'MONTH11',
	    }, {
	      type: 'string',
	      name: 'MONTH12',
	    }, {
	      type: 'string',
	      name: 'TOTALMONTH',
	    }
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
	      locked: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'LICENSENO',
	      text: '사업자번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "center",
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처',
	      xtype: 'gridcolumn',
	      width: 200,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "left",
	      summaryRenderer: function (value, meta, record) {
	        value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>TOTAL</div>";
	        return value;
	      },
	    }, {
	      dataIndex: 'MONTH01',
	      text: '1월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH01 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        //                 meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH02',
	      text: '2월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH02 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH03',
	      text: '3월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH03 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH04',
	      text: '4월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH04 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH05',
	      text: '5월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH05 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH06',
	      text: '6월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH06 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH07',
	      text: '7월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH07 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH08',
	      text: '8월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH08 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH09',
	      text: '9월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH09 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH10',
	      text: '10월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH10 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH11',
	      text: '11월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH11 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH12',
	      text: '12월',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.MONTH12 * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'TOTALMONTH',
	      text: '합계',
	      xtype: 'gridcolumn',
	      width: 130,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      summaryType: function (records, values) {
	        var i = 0,
	        length = records.length,
	        total = 0,
	        record;

	        for (; i < length; ++i) {
	          record = records[i];

	          total += (record.data.TOTALMONTH * 1);
	        }
	        return total;
	      },
	      summaryRenderer: function (value, meta, record) {
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
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

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/cost/std/CostStdPoTotal.do' />"
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
	  setExtGrid_total();
	}

	function setExtGrid_total() {
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
	                SEARCHYEAR: $("#searchYear").val() + "",
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
	      SalesTotalList: '#SalesTotalList',
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
	        height: 688,
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
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'SalesTotalList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 200) {
	                    column.width = 200;
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

	function setValues_Popup() {
	  gridnms["models.popup1"] = [];
	  gridnms["stores.popup1"] = [];
	  gridnms["views.popup1"] = [];
	  gridnms["controllers.popup1"] = [];

	  gridnms["grid.5"] = "Popup1";

	  gridnms["panel.5"] = gridnms["app"] + ".view." + gridnms["grid.5"];
	  gridnms["views.popup1"].push(gridnms["panel.5"]);

	  gridnms["controller.5"] = gridnms["app"] + ".controller." + gridnms["grid.5"];
	  gridnms["controllers.popup1"].push(gridnms["controller.5"]);

	  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];

	  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];

	  gridnms["models.popup1"].push(gridnms["model.5"]);

	  gridnms["stores.popup1"].push(gridnms["store.5"]);

	  fields["model.5"] = [{
	      type: 'number',
	      name: 'RN',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, {
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERTYPENAME',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERTYPE',
	    }, {
	      type: 'string',
	      name: 'LICENSENO',
	    }, {
	      type: 'string',
	      name: 'ADDRESS',
	    }, ];

	  fields["columns.5"] = [{
	      dataIndex: 'CHK',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 40,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "center",
	    }, {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'rownumberer',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'LABEL',
	      text: '거래처명',
	      xtype: 'gridcolumn',
	      width: 270,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'LICENSENO',
	      text: '사업자번호',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
	      align: "center",
	    }, {
	      dataIndex: 'ADDRESS',
	      text: '주소',
	      xtype: 'gridcolumn',
	      width: 450,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center',
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
	      dataIndex: 'VALUE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERTYPENAME',
	      xtype: 'hidden',
	    }, ];

	  items["api.5"] = {};
	  $.extend(items["api.5"], {
	    read: "<c:url value='/searchCustomernameLov.do'/>"
	  });

	  items["btns.5"] = [];
	  items["btns.5"].push(
	    '->' // tbar에서 오른쪽 정렬시 사용하는 옵션
	  );

	  items["btns.ctr.5"] = {};

	  items["dock.paging.5"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.5"],
	  };

	  items["dock.btn.5"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.5"],
	    items: items["btns.5"],
	  };

	  items["docked.5"] = [];
	}

	var gridpopup1;
	function setExtGrid_Popup() {
	  Ext.define(gridnms["model.5"], {
	    extend: Ext.data.Model,
	    fields: fields["model.5"],
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
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.5"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                CUSTOMERTYPE3: 'S',
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.5"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnPopup1: '#btnPopup1',
	    },
	    stores: [gridnms["store.5"]],
	  });

	  Ext.define(gridnms["panel.5"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.5"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.5"],
	        id: gridnms["panel.5"],
	        store: gridnms["store.5"],
	        height: 565,
	        border: 2,
	        scrollable: true,
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        //                 bufferedRenderer: false,
	        columns: fields["columns.5"],
	        viewConfig: {
	          itemId: 'btnPopup1',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.5"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup1"],
	    stores: gridnms["stores.popup1"],
	    views: gridnms["views.popup1"],
	    controllers: gridnms["controller.5"],

	    launch: function () {
	      gridpopup1 = Ext.create(gridnms["views.popup1"], {
	          renderTo: 'gridPopup1Area'
	        });
	    },
	  });
	}

	var popcount = 0, popupclick = 0;
	function btnSel1() {
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return false;
	  }

	  var width = 955; // 가로
	  var height = 645; // 500; // 세로
	  var title = "거래처 Pop up";
	  popupclick = 0;

	  // 완료 외 상태에서만 팝업 표시하도록 처리
	  $('#popupOrgId').val($('#searchOrgId option:selected').val());
	  $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	  $("#popupCustomerName").val("");
	  $("#searchCustomerCode").val("");
	  $("#searchCustomerName").val("");

	  Ext.getStore(gridnms['store.5']).removeAll();

	  win11 = Ext.create('Ext.window.Window', {
	      width: width,
	      height: height,
	      title: title,
	      layout: 'fit',
	      header: true,
	      draggable: true,
	      resizable: false,
	      maximizable: false,
	      closeAction: 'hide',
	      modal: true,
	      closable: true,
	      buttonAlign: 'center',
	      items: [{
	          xtype: 'gridpanel',
	          selType: 'cellmodel',
	          itemId: gridnms["panel.5"],
	          id: gridnms["panel.5"],
	          store: gridnms["store.5"],
	          height: '100%',
	          border: 2,
	          scrollable: true,
	          frameHeader: true,
	          columns: fields["columns.5"],
	          viewConfig: {
	            itemId: 'onMypopClick'
	          },
	          plugins: 'bufferedrenderer',
	          dockedItems: items["docked.5"],
	        }
	      ],
	      tbar: [
	        '거래처명', {
	          xtype: 'textfield',
	          name: 'searchCustomerName',
	          clearOnReset: true,
	          hideLabel: true,
	          width: 170,
	          editable: true,
	          allowBlank: true,
	          listeners: {
	            scope: this,
	            buffer: 50,
	            change: function (value, nv, ov, e) {
	              value.setValue(nv.toUpperCase());
	              var result = value.getValue();

	              $('#popupCustomerName').val(result);
	            },
	          },
	        }, '->', {
	          text: '조회',
	          scope: this,
	          handler: function () {
	            var sparams3 = {
	              ORGID: $('#popupOrgId').val(),
	              COMPANYID: $('#popupCompanyId').val(),
	              CUSTOMERNAME: $('#popupCustomerName').val(),
	              CUSTOMERTYPE3: 'S',
	            };

	            extGridSearch(sparams3, gridnms["store.5"]);
	          }
	        }, {
	          text: '전체선택/해제',
	          scope: this,
	          handler: function () {
	            // 전체등록 Pop up 전체선택 버튼 핸들러
	            var count5 = Ext.getStore(gridnms["store.5"]).count();
	            var checkTrue = 0,
	            checkFalse = 0;

	            if (popupclick == 0) {
	              popupclick = 1;
	            } else {
	              popupclick = 0;
	            }
	            for (var i = 0; i < count5; i++) {
	              Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
	              var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];

	              var chk = model5.data.CHK;

	              if (popupclick == 1) {
	                model5.set("CHK", true);
	                checkFalse++;
	              } else {
	                model5.set("CHK", false);
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
	        }, {
	          text: '적용',
	          scope: this,
	          handler: function () {
	            // 전체등록 Pop up 적용 버튼 핸들러
	            var count = Ext.getStore(gridnms["store.1"]).count();
	            var count5 = Ext.getStore(gridnms["store.5"]).count();
	            var checknum = 0,
	            checkqty = 0,
	            checktemp = 0;
	            var qtytemp = [];

	            for (var i = 0; i < count5; i++) {
	              Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
	              var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	              var chk = model5.get("CHK");
	              if (chk == true) {
	                checknum++;
	              }
	            }
	            console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	            if (checknum == 0) {
	              extAlert("선택 된 거래처가 없습니다.<br/>다시 한번 확인해주십시오.");
	              return false;
	            }

	            if (count5 == 0) {
	              console.log("[적용] 거래처 정보가 없습니다.");
	            } else {
	              var tempValList = "";
	              var tempLabList = "";
	              var cnt = 0;
	              for (var j = 0; j < count5; j++) {
	                Ext.getStore(gridnms["store.5"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
	                var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                var chk = model5.data.CHK;
	                if (chk === true) {
	                  // 팝업창의 체크된 항목 이동
	                  if (cnt == 0) {
	                    tempLabList += model5.data.LABEL;
	                    tempValList += "'" + model5.data.VALUE + "'";
	                  } else {
	                    tempLabList += ", " + model5.data.LABEL;
	                    tempValList += ", " + "'" + model5.data.VALUE + "'";
	                  }

	                  cnt++; // 콤마를 넣는 타이밍 체크
	                  // 그리드 적용 방식
	                  checktemp++;
	                  popcount++;
	                };
	              }
	              $("#searchCustomerCode").val(tempValList);
	              $("#searchCustomerName").val(tempLabList);
	            }

	            if (checktemp > 0) {
	              popcount = 0;
	              win11.close();
	              $("#gridPopup1Area").hide("blind", {
	                direction: "up"
	              }, "fast");
	            }
	          }
	        }
	      ]
	    });
	  win11.show();
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchYear = $("#searchYear").val();
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

	  if (searchYear == "") {
	    header.push("년도");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    result = false;
	  }

	  return result;
	}

	function delkey() {
	  $(document).keydown(function (e) {
	    if (e.keyCode === 8 || e.keyCode === 46) {
	      $("#searchCustomerCode").val("");
	      $("#searchCustomerName").val("");
	    }
	  });
	}

	function fn_search() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchYear = $("#searchYear").val();
	  var searchCustomerCode = $("#searchCustomerCode").val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHYEAR: searchYear,
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
	  var searchYear = $("#searchYear").val();
	  var searchCustomerCode = $("#searchCustomerCode").val();
	  var title = $('#title').val();

	  go_url("<c:url value='/cost/std/Pototal/ExcelDownload.do?GUBUN='/>" + "POTOTAL"
	     + "&ORGID=" + orgid + ""
	     + "&COMPANYID=" + companyid + ""
	     + "&SEARCHYEAR=" + searchYear + ""
	     + "&CUSTOMERCODE=" + searchCustomerCode + ""
	     + "&TITLE=" + title + "");
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
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
														<li>자재관리</li>
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
                            <input type="hidden" id="popupCustomerName" name="popupCustomerName" />
										        <input type="hidden" id="popupOrgId" name="popupOrgId" />
										        <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
														<div>
																<table class="tbl_type_view" border="1">
																		<colgroup>
																				<col width="120px">
																				<col width="114px">
																				<col width="120px">
																				<col width="20%">
																				<col width="120px">
																				<col>
																		</colgroup>
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
                                        <td colspan="2">
																						<div class="buttons" style="float: right; margin-top: 3px;">
																								<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
																								<a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a>
																						</div>
																				</td>
																		</tr>
																		<tr style="height: 34px;">
																				<th class="required_text">년도</th>
																				<td>
																				  <input type="text" id="searchYear" name="searchYear" class="input_validation input_center" style="width: 100px; min-width: 100px;" maxlength="7" value="${searchVO.TODAY}" />
																				</td>
                                        <th class="required_text">거래처</th>
                                        <td colspan="3">
                                          <input type="text" id="searchCustomerName" name="searchCustomerName" class="imetype input_left" onclick="javascript:btnSel1();" onkeydown="javascript:delkey();" oncontextmenu="return false"  style="width: 72%;" />
                                          <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" />
                                        </td>
                                    </tr>
																</table>
														</div>
												</form>
										</fieldset>
								</div>
                <div style="width: 100%;">
                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                </div>
            <div id="gridPopup1Area" style="width: 945px; padding-top: 0px; float: left;"></div>
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