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
	  gridnms["app"] = "prod";

	  $("#searchYear").val(getToDay("${searchVO.DATEYEAR}") + ""); ;

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "MonthlyWorkerList";

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
	      name: 'EMPLOYEENUMBER',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, {
	      type: 'number',
	      name: 'MONTH01',
	    }, {
	      type: 'number',
	      name: 'MONTH02',
	    }, {
	      type: 'number',
	      name: 'MONTH03',
	    }, {
	      type: 'number',
	      name: 'MONTH04',
	    }, {
	      type: 'number',
	      name: 'MONTH05',
	    }, {
	      type: 'number',
	      name: 'MONTH06',
	    }, {
	      type: 'number',
	      name: 'MONTH07',
	    }, {
	      type: 'number',
	      name: 'MONTH08',
	    }, {
	      type: 'number',
	      name: 'MONTH09',
	    }, {
	      type: 'number',
	      name: 'MONTH10',
	    }, {
	      type: 'number',
	      name: 'MONTH11',
	    }, {
	      type: 'number',
	      name: 'MONTH12',
	    }, {
	      type: 'number',
	      name: 'TOTALMONTH',
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
	      locked: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'KRNAME',
	      text: '작업자',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      style: 'text-align:center;',
	      align: "center",
	      summaryRenderer: function (value, meta, record) {
	        value = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>TOTAL</div>";
	        return value;
	      },
	    }, {
	      dataIndex: 'MONTH01',
	      text: '1월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH02',
	      text: '2월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH03',
	      text: '3월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH04',
	      text: '4월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH05',
	      text: '5월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH06',
	      text: '6월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH07',
	      text: '7월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH08',
	      text: '8월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH09',
	      text: '9월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH10',
	      text: '10월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH11',
	      text: '11월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MONTH12',
	      text: '12월',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	        var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
	        return result;
	      },
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'TOTALMONTH',
	      text: '합계',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center;',
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
	      dataIndex: 'EMPLOYEENUMBER',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/manage/MonthlyWorkerList.do' />"
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
	                SEARCHYEAR: $('#searchYear').val(),
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
	      MonthlyWorkerList: '#MonthlyWorkerList',
	    },
	    stores: [gridnms["store.1"]],
	    //      control: items["btns.ctr.1"],
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
	          itemId: 'MonthlyWorkerList',
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('KRNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 150) {
	                    column.width = 150;
	                  }
	                }
	              });
	            },
	          }
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
	  var searchYear = $('#searchYear').val();
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

	  if (searchYear === "") {
	    header.push("년도");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력(선택)해주세요.");
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
	  var searchyear = $('#searchYear').val();
	  var employeenumber = $('#searchEmployeeNumber').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHYEAR: searchyear,
	    EMPLOYEENUMBER: employeenumber,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchyear = $('#searchYear').val();
	  var employeenumber = $('#searchEmployeeNumber').val();
	  var title = $('#title').val();

	  go_url("<c:url value='/prod/manage/ExcelDownload.do?GUBUN='/>" + "MONTHLYWORKER"
	     + "&ORGID=" + orgid + ""
	     + "&COMPANYID=" + companyid + ""
	     + "&SEARCHYEAR=" + searchyear
	     + "&EMPLOYEENUMBER=" + employeenumber
	     + "&TITLE=" + title + "");
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 작업자 Lov
	  $("#searchKrName")
	  .bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#searchEmployeeNumber").val("");
	      break;
	    case $.ui.keyCode.ENTER:
	      $(this).autocomplete("search", "%");
	      break;

	    default:
	      break;
	    }
	  })
	  .focus(function (e) {
	    $(this).autocomplete("search", (this.value === "") ? "%" : this.value);
	  })
	  .autocomplete({
	    source: function (request, response) {
	      $.getJSON("<c:url value='/searchMonthlyWorkerListLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        SEARCHYEAR: $('#searchYear').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL,
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
	      $("#searchKrName").val(o.item.label);
	      $("#searchEmployeeNumber").val(o.item.value);
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
                            <input type="hidden" id="title" name="title" value="${pageTitle}" />
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
                                        <td>
                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
                                                   조회
                                                </a>
                                                <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();">
                                                   엑셀
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
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">년도</th>
                                        <td>
                                            <input type="text" id="searchYear" name="searchYear" class="input_validation input_center" style="width: 90px;" maxlength="4" />
                                        </td>
                                        <th class="required_text">작업자</th>
                                        <td>
		                                        <input type="text" id="searchKrName" name="searchKrName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 72%;" />
		                                        <input type="hidden" id="searchEmployeeNumber" name="searchEmployeeNumber" />
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