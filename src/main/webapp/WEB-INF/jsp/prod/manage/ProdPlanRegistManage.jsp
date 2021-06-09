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

	  $("#searchDateFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchDateTo").val(getToDay("${searchVO.dateTo}") + "");

	  $("#WorkStartDate").val("N");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {
	     <%--상태 option 변경--%>
	    //      fn_option_change('OM', 'SHIP_GUBUN', 'searchShipGubun');

	  });

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};

	function setValues() {
	  gridnms["models.prod"] = [];
	  gridnms["stores.prod"] = [];
	  gridnms["views.prod"] = [];
	  gridnms["controllers.prod"] = [];

	  gridnms["grid.1"] = "ProdPlanRegistManage";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.prod"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.prod"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.prod"].push(gridnms["model.1"]);

	  gridnms["stores.prod"].push(gridnms["store.1"]);

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
	      name: 'WORKPLANNO',
	    }, {
	      type: 'string',
	      name: 'UPPERITEMCODE',
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
	      type: 'string',
	      name: 'CARTYPE',
	    }, {
	      type: 'string',
	      name: 'CARTYPENAME',
	    }, {
	      type: 'string',
	      name: 'MATERIALTYPE',
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
	      type: 'number',
	      name: 'WORKPLANQTY',
	    }, {
	      type: 'date',
	      name: 'DUEDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'CASTENDPLANDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'WORKENDPLANDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'date',
	      name: 'WORKSTARTDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'SONO',
	    }, {
	      type: 'number',
	      name: 'SOSEQ',
	    }, {
	      type: 'string',
	      name: 'WORKORDERYN',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
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
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'WORKPLANNO',
	      text: '생산계획번호',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'CARTYPENAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
        dataIndex: 'ITEMSTANDARDDETAIL',
        text: '타입',
        xtype: 'gridcolumn',
        width: 100,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
        renderer: function (value, meta, record) {
          var itemtype = record.data.ITEMTYPE;
          if (itemtype == "A") {
            meta.style += " font-weight: bold;";
          }
          //          meta.style = "background-color:rgb(234, 234, 234)";
          return value;
        },
      }, {
	      dataIndex: 'UOMNAME',
	      text: '단위',
	      xtype: 'gridcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'WORKPLANQTY',
	      text: '수주수량',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'DUEDATE',
	      text: '납기일자',
	      xtype: 'datecolumn',
	      width: 95,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	      //      }, {
	      //        dataIndex: 'CASTENDPLANDATE',
	      //        text: '주조완료예정일',
	      //        xtype: 'datecolumn',
	      //        width: 105,
	      //        hidden: false,
	      //        sortable: true,
	      //        align: "center",
	      //        renderer: function (value, meta, record) {
	      //          meta.style = "background-color:rgb(234, 234, 234)";
	      //          return Ext.util.Format.date(value, 'Y-m-d');
	      //        },
	      //      }, {
	      //        dataIndex: 'WORKENDPLANDATE',
	      //        text: '가공완료예정일',
	      //        xtype: 'datecolumn',
	      //        width: 105,
	      //        hidden: false,
	      //        sortable: true,
	      //        align: "center",
	      //        renderer: function (value, meta, record) {
	      //          meta.style = "background-color:rgb(234, 234, 234)";
	      //          return Ext.util.Format.date(value, 'Y-m-d');
	      //        },
	    }, {
	      dataIndex: 'WORKSTARTDATE',
	      text: '작업지시확정일',
	      xtype: 'datecolumn',
	      width: 130,
	      hidden: false,
	      sortable: true,
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
	        format: 'Y-m-d',
	        altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	      },
	      renderer: function (value, meta, record) {
	          meta.style = " background-color:rgb(253, 218, 255); ";
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'SONO',
	      text: '수주번호',
	      xtype: 'gridcolumn',
	      width: 125,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'SOSEQ',
	      text: '수주순번',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'WORKORDERYN',
	      text: '생산진행상태',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //          meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 250,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
	      },
	      renderer: function (value, meta, record) {
	        var itemtype = record.data.ITEMTYPE;
	        if (itemtype == "A") {
	          meta.style += " font-weight: bold;";
	        }
	        //            meta.style = "background-color:rgb(234, 234, 234)";
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
	      dataIndex: 'CONFIRMYNNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CASTENDPLANDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKENDPLANDATE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UPPERITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CARTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/manage/ProdPlanRegistManage.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/prod/manage/ProdPlanRegistManage.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "저장",
	    itemId: "btnSav1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "새로고침",
	    itemId: "btnRef1"
	  });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnSav1": {
	      click: 'btnSav1'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnRef1": {
	      click: 'btnRef1'
	    }
	  });
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
	  items["docked.1"].push(items["dock.btn.1"]);
	}

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
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.prod"]).getSelectionModel().select(i));
	      var model = Ext.getCmp(gridnms["views.prod"]).selModel.getSelection()[0];

	      var workstartdate = model.data.WORKSTARTDATE;

	      //          if (workstartdate == "" || workstartdate == undefined) {
	      //            header.push("작업지시확정일");
	      //            count++;
	      //          }

	      if (count > 0) {
	        extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
	        return;
	      }
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
	  }
	};

	function MasterClick(dataview, record, item, index, e, eOpts) {
	  $("#SHIPNO").val(record.data.SHIPNO);
	  $("#SHIPQTY").val(record.data.SHIPQTY);
	  $("#ORGID").val(record.data.ORGID);
	  $("#COMPANYID").val(record.data.COMPANYID);
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
	                WORKSTARTDATE: $('#WorkStartDate').val(),
	                DATEFROM: $('#searchDateFrom').val(),
	                DATETO: $('#searchDateTo').val(),
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

	    btnSav1: btnSav1,
	    btnRef1: btnRef1,
	    MasterClick: MasterClick,
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
	        height: 653,
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
	                if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 150) {
	                    column.width = 150;
	                  }
	                }

	                if (column.dataIndex.indexOf('CARTYPENAME') >= 0) {
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
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = ctx.record;

	                var editDisableCols = [];
	                var status = data.data.CONFIRMYN;
	                if (status != "N") {
	                  //                    editDisableCols.push("REMARKS");
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
	    models: gridnms["models.prod"],
	    stores: gridnms["stores.prod"],
	    views: gridnms["views.prod"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.prod"], {
	          renderTo: 'gridProdArea'
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
	  var datefrom = $('#searchDateFrom').val();
	  var dateto = $('#searchDateTo').val();
	  var itemcode = $('#searchItemcd').val();
	  var ordername = $('#searchOrdernm').val();
	  var itemname = $('#searchItemnm').val();
	  var modelname = $('#searchModelName').val();
	  var customercode = $('#CustomerCode').val();
	  var workstartdate = $('#WorkStartDate').val();
	  var workorderyn = $('#WorkOrderYn').val();
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

	  if (datefrom === "") {
	    header.push("납기일 From");
	    count++;
	  }

	  if (dateto === "") {
	    header.push("납기일 To");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return;
	  }

	  var sparams = {
	    ORGID: $('#searchOrgId option:selected').val(),
	    COMPANYID: $('#searchCompanyId option:selected').val(),
	    CUSTOMERCODE: customercode,
	    ITEMCODE: itemcode,
	    ORDERNAME: ordername,
	    ITEMNAME: itemname,
	    MODELNAME: modelname,
	    DATEFROM: datefrom,
	    DATETO: dateto,
	    WORKSTARTDATE: workstartdate,
	    WORKORDERYN: workorderyn,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  //    // 품명 LOV
	  //    $("#searchItemnm")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        $("#searchOrdernm").val("");
	  //        $("#searchItemcd").val("");
	  //        //          $("#searchItemnm").val("");
	  //        $("#searchModel").val("");
	  //        $("#searchModelName").val("");
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
	  //          GUBUN: 'ITEMNAME',
	  //          ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ITEMNAME + ', ' + m.ORDERNAME + ', ' + m.MODELNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //                MODEL: m.MODEL,
	  //                MODELNAME: m.MODELNAME,
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
	  //        $("#searchItemcd").val(o.item.ITEMCODE);
	  //        $("#searchItemnm").val(o.item.ITEMNAME);
	  //        $("#searchOrdernm").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);
	  //        return false;
	  //      }
	  //    });

	  //    // 품번 LOV
	  //    $("#searchOrdernm")
	  //    .bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        //            $("#searchOrdernm").val("");
	  //        $("#searchItemcd").val("");
	  //        $("#searchItemnm").val("");
	  //        $("#searchModel").val("");
	  //        $("#searchModelName").val("");
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
	  //          GUBUN: 'ORDERNAME',
	  //          ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                label: m.ORDERNAME + ', ' + m.ITEMNAME + ', ' + m.MODELNAME,
	  //                value: m.ITEMCODE,
	  //                ITEMNAME: m.ITEMNAME,
	  //                ORDERNAME: m.ORDERNAME,
	  //                MODEL: m.MODEL,
	  //                MODELNAME: m.MODELNAME,
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
	  //        $("#searchItemcd").val(o.item.ITEMCODE);
	  //        $("#searchItemnm").val(o.item.ITEMNAME);
	  //        $("#searchOrdernm").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);
	  //        return false;
	  //      }
	  //    });

	  // 거래처명 lov
	  $("#CustomerName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#CustomerCode").val("");

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
	        CUSTOMERTYPE1: 'S',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL + ", " + m.CUSTOMERTYPENAME + ", " + m.ADDRESS,
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
	      $("#CustomerCode").val(o.item.value);
	      $("#CustomerName").val(o.item.NAME);

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
                                <li>계획관리</li>
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
                                        <th class="required_text">납기일자</th>
                                        <td >
                                            <input type="text" id="searchDateFrom" name="searchDateFrom" class="input_validation input_center validate[custom[date],past[#searchShipTo]]" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchDateTo" name="searchDateTo" class="input_validation input_center validate[custom[date],future[#searchShipFrom]]" style="width: 90px; " maxlength="10"  />
                                        </td>
		                                    <th class="required_text">거래처명</th>
		                                    <td>
		                                          <input type="text" id="CustomerName" name="CustomerName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
		                                          <input type="hidden" id="CustomerCode" name="CustomerCode" />
		                                    </td>
		                                    <th class="required_text">생산계획여부</th>
		                                    <td>
																							<select id="WorkStartDate" name="WorkStartDate" class="imetype input_center" style="width: 94%;">
																							    <option value="">전체</option>
																							    <option value="Y">확정</option>
																							    <option value="N">미확정</option>
																							</select>
																				</td>
                                        <th class="required_text">생산진행상태</th>
                                        <td>
                                            <select id="WorkOrderYn" name="WorkOrderYn" class="input_center " style="width: 94%;">
                                                <c:if test="${empty searchVO.WORKORDERYN}">
                                                    <option value=""  >전체</option>
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByWorkOrderYn}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.WORKORDERYN}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">품번</th>
                                        <td>
                                              <input type="text" id="searchOrdernm" name="searchOrdernm" class="input_left" style="width: 94%;" />
                                              <input type="hidden" id="searchItemcd" name="searchItemcd" />
                                        </td>
		                                     <th class="required_text">품명</th>
		                                    <td>
		                                          <input type="text" id="searchItemnm" name="searchItemnm"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
		                                    </td>
			                                  <th class="required_text">기종</th>
			                                  <td >
			                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
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
                    <div id="gridProdArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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