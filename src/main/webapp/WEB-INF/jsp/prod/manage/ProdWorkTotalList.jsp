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
	  calender($('#searchFrom, #searchTo'));

	  $('#searchFrom, #searchTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  var searchfrom = "${searchVO.searchFrom}";
	  if (searchfrom != "") {
	    $("#searchFrom").val(getToDay("${searchVO.searchFrom}") + "");
	    $("#searchTo").val(getToDay("${searchVO.searchTo}") + "");

	    $("#searchItemCode").val("${searchVO.searchItemCode}");
	    $("#searchOrderName").val("${searchVO.searchOrderName}");
	    $("#searchItemName").val("${searchVO.searchItemName}");
	    $("#searchRoutingId").val("${searchVO.searchRoutingId}");
	    $("#searchRoutingName").val("${searchVO.searchRoutingName}");
	    $("#searchModel").val("${searchVO.searchModel}");
	    $("#searchModelName").val("${searchVO.searchModelName}");
	    $("#ItemType").val("${searchVO.ItemType}");

	  } else {
	    $("#searchFrom").val(getToDay("${searchVO.DATEFROM}") + "");
	    $("#searchTo").val(getToDay("${searchVO.DATETO}") + "");
	  }

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "ProdWorkTotalList";

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
	      name: 'UPPERITEMCODE',
	    }, {
	      type: 'string',
	      name: 'UPPERITEMNAME',
	    }, {
	      type: 'string',
	      name: 'UPPERORDERNAME',
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
	      type: 'string',
	      name: 'EQUIPMENTNAME',
	    }, {
	      type: 'string',
	      name: 'WORKTYPENAME',
	    }, {
	      type: 'string',
	      name: 'ROUTINGGROUP',
	    }, {
	      type: 'string',
	      name: 'ROUTINGGROUPNAME',
	    }, {
	      type: 'string',
	      name: 'OUTSIDEORDERGUBUN',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, {
	      type: 'string',
	      name: 'WORKORDERQTY',
	    }, {
	      type: 'number',
	      name: 'PRODQTY',
	    }, {
	      type: 'string',
	      name: 'SUMPRODQTY',
	    }, {
	      type: 'string',
	      name: 'RATEQTY',
	    }, {
	      type: 'string',
	      name: 'FAULTQTY1',
	    }, {
	      type: 'string',
	      name: 'RATEFAULT1',
	    }, {
	      type: 'string',
	      name: 'PPM1',
	    }, {
	      type: 'string',
	      name: 'FAULTQTY2',
	    }, {
	      type: 'string',
	      name: 'RATEFAULT2',
	    }, {
	      type: 'string',
	      name: 'PPM2',
	    }, {
	      type: 'string',
	      name: 'FAULTTOTAL',
	    }, {
	      type: 'string',
	      name: 'FAULTRATETOTAL',
	    }, {
	      type: 'string',
	      name: 'FAULTTOTALPPM',
	    }, {
	      type: 'string',
	      name: 'MONTHPPM1',
	    }, {
	      type: 'string',
	      name: 'MONTHPPM2',
	    }, {
	      type: 'string',
	      name: 'MONTHTOTALPPM',
	    }, {
	      type: 'string',
	      name: 'STARTTIME',
	    }, {
	      type: 'string',
	      name: 'ENDTIME',
	    }, {
        type: 'string',
        name: 'WORKORDERID',
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
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: function (value, meta, record) {
	        
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
		    dataIndex: 'WORKORDERID',
		    text: '작업지시번호',
		    xtype: 'gridcolumn',
		    width: 160,
		    hidden: false,
		    sortable: false,
		    resizable: true,
		    menuDisabled: true,
		    style: 'text-align:center;',
		    align: "center",
        summaryRenderer: function (value, meta, record) {
          return ['TOTAL'].map(function (val) {
            return "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 15px;'>" + val + '</div>';
          }).join('<br />');
        },
		    renderer: function (value, meta, record) {
		      
		      return value;
		    },
		  }, {
	      dataIndex: 'ROUTINGGROUPNAME',
	      text: '공정그룹',
	      xtype: 'gridcolumn',
	      width: 160,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        
	        return value;
	      },
	    }, {
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        
	        return value;
	      },
	    }, {
	      dataIndex: 'EQUIPMENTNAME',
	      text: '설비명',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
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
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record, rowIndex, colIndex, store, view) {
	        
	        return value
	      },
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 280,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      renderer: function (value, meta, record) {
	        
	        return value;
	      },
	    }, {
	      dataIndex: 'MODELNAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
	        
	        return value;
	      },
	    }, {
        dataIndex: 'ITEMSTANDARDDETAIL',
        text: '타입',
        xtype: 'gridcolumn',
        width: 110,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        align: "center",
        renderer: function (value, meta, record) {
          
          return value;
        },
      }, {
	      dataIndex: 'STARTTIME',
	      text: '시작시간',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        
	        return value;
	      },
	    }, {
	      dataIndex: 'ENDTIME',
	      text: '종료시간',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        
	        return value;
	      },
	    }, {
	      dataIndex: 'KRNAME',
	      text: '작업자',
	      xtype: 'gridcolumn',
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      width: 80,
	      align: "center",
	      renderer: function (value, meta, record) {
	       
	        return value;
	      },
	    }, {
	      text: '생산현황',
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      columns: [{
	          dataIndex: 'WORKORDERQTY',
	          text: '목표수량',
	          xtype: 'gridcolumn',
	          width: 80,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          renderer: function (value, meta, record) {
	            
	            return Ext.util.Format.number(value, '0,000');
	          },
	        }, {
	          dataIndex: 'PRODQTY',
	          text: '실적수량',
	          xtype: 'gridcolumn',
	          width: 80,
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
	        }, {
	          dataIndex: 'SUMPRODQTY',
	          text: '누적수량',
	          xtype: 'gridcolumn',
	          width: 80,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000",
	          renderer: function (value, meta, record) {
	            
	            return Ext.util.Format.number(value, '0,000');
	          },
	        }, {
	          dataIndex: 'RATEQTY',
	          text: '달성율(%)',
	          xtype: 'gridcolumn',
	          width: 90,
	          hidden: false,
	          sortable: false,
	          resizable: true,
	          menuDisabled: true,
	          style: 'text-align:center;',
	          align: "right",
	          cls: 'ERPQTY',
	          format: "0,000.00",
	          renderer: function (value, meta, record) {
	            
	            return Ext.util.Format.number(value, '0,000.00');
	          },
	        }, ],
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UPPERITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'KRNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGOP',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/manage/ProdWorkTotalList.do' />"
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

	function fn_detail_popup(rownum) {

	  Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(rownum));
	  var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	  var orgid = model1.data.ORGID;
	  var companyid = model1.data.COMPANYID;
	  var itemcode = model1.data.ITEMCODE;
	  var ordername = model1.data.ORDERNAME;
	  var itemname = model1.data.ITEMNAME;
	  var model = model1.data.MODEL;
	  var modelname = model1.data.MODELNAME;
	  var routingid = model1.data.ROUTINGID;
	  var routingname = model1.data.ROUTINGNAME;

	  $('#orgid').val(orgid);
	  $('#companyid').val(companyid);
	  $('#itemcode').val(itemcode);
	  $('#ordername').val(ordername);
	  $('#itemname').val(itemname);
	  $('#model').val(model);
	  $('#modelname').val(modelname);
	  $('#routingid').val(routingid);
	  $('#routingname').val(routingname);

	  var column = 'master';
	  var url = "<c:url value='/prod/manage/ProdWorkTotalDetail.do'/>";
	  var target = '_self';

	  fn_popup_url(column, url, target);
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
	                SEARCHFROM: $('#searchFrom').val(),
	                SEARCHTO: $('#searchTo').val(),
	                GAGUBUN: "N",
	                ROUTINGNAME: $('#searchRoutingName').val(),
	                ORDERNAME: $('#searchOrderName').val(),
	                ITEMNAME: $('#searchItemName').val(),
	                MODELNAME: $('#searchModelName').val(),
	                ITEMTYPE: $('#ItemType').val(),
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
	      ProdWorkTotalList: '#ProdWorkTotalList',
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
	        height: 653,
	        border: 2,
          features: [{
              ftype: 'summary',
              dock: 'bottom'
            }
          ],
	        scrollable: true,
	        columns: fields["columns.1"],
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          },
	        ],
	        viewConfig: {
	          itemId: 'ProdWorkTotalList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('EQUIPMENTNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('ROUTINGGROUPNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 80) {
	                    column.width = 80;
	                  }
	                }

	                if (column.dataIndex.indexOf('MODELNAME') >= 0) {
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
	  var searchfrom = $('#searchFrom').val();
	  var searchto = $('#searchTo').val();
	  var searchitemcode = $('#searchItemCode').val();
	  var searchroutingid = $('#searchRoutingId').val();
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

	  if (searchfrom == "") {
	    header.push("일자 From");
	    count++;
	  }

	  if (searchto == "") {
	    header.push("일자 To");
	    count++;
	  }

	  //    if (searchitemcode == "") {
	  //      header.push("품번/품명");
	  //      count++;
	  //    }

	  //    if (searchroutingid == "") {
	  //      header.push("공정명");
	  //      count++;
	  //    }

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
	  var searchfrom = $('#searchFrom').val();
	  var searchto = $('#searchTo').val();
	  var searchitemcode = $('#searchItemCode').val();
	  var searchroutingid = $('#searchRoutingId').val();
	  var searchroutingname = $('#searchRoutingName').val();
	  var searchordername = $('#searchOrderName').val();
	  var searchitemname = $('#searchItemName').val();
	  var searchmodelname = $('#searchModelName').val();
	  var searchitemtype = $('#ItemType').val();
	  var searchWorker = $('#searchWorker').val();
	  var searchWrokOrderId = $('#searchWrokOrderId').val();
    var searchEquipmentName = $('#searchEquipmentName').val();
	  
	  
	  
	  //    var searchroutinggroup = $('#RoutingGroup').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    SEARCHFROM: searchfrom,
	    SEARCHTO: searchto,
	    ITEMCODE: searchitemcode,
	    ROUTINGID: searchroutingid,
	    GAGUBUN: "N",
	    ROUTINGNAME: searchroutingname,
	    ORDERNAME: searchordername,
	    ITEMNAME: searchitemname,
	    MODELNAME: searchmodelname,
	    ITEMTYPE: searchitemtype,
	    WORKER : searchWorker,
	    WORKORDERID : searchWrokOrderId,
	    EQUIPMENTNAME : searchEquipmentName,
	    //      ROUTINGGROUP: searchroutinggroup,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchfrom = $('#searchFrom').val();
	  var searchto = $('#searchTo').val();
	  var searchitemcode = $('#searchItemCode').val();
	  var searchroutingid = $('#searchRoutingId').val();
	  var searchroutingname = $('#searchRoutingName').val();
	  var searchordername = $('#searchOrderName').val();
	  var searchitemname = $('#searchItemName').val();
	  var searchmodelname = $('#searchModelName').val();
	  var searchitemtype = $('#ItemType').val();
	  //    var searchroutinggroup = $('#RoutingGroup').val();
	  var title = $('#title').val();

	  go_url("<c:url value='/prod/manage/ExcelDownload.do?GUBUN='/>" + "WORKTOTAL"
	     + "&ORGID=" + orgid + ""
	     + "&COMPANYID=" + companyid + ""
	     + "&SEARCHFROM=" + searchfrom
	     + "&SEARCHTO=" + searchto
	     + "&ITEMCODE=" + searchitemcode + ""
	     + "&ROUTINGID=" + searchroutingid + ""
	     + "&ROUTINGNAME=" + searchroutingname + ""
	     + "&ORDERNAME=" + searchordername + ""
	     + "&ITEMNAME=" + searchitemname + ""
	     + "&MODELNAME=" + searchmodelname + ""
	     + "&ITEMTYPE=" + searchitemtype + ""
	    //       + "&ROUTINGGROUP=" + searchroutinggroup + ""
	     + "&GAGUBUN=" + "N" + ""
	     + "&TITLE=" + title + "");
	}

	function fn_validation1() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchfrom = $('#searchFrom').val();
	  var searchto = $('#searchTo').val();
	  var searchitemcode = $('#searchItemCode').val();
	  var searchroutingid = $('#searchRoutingId').val();
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

	  if (searchfrom == "") {
	    header.push("일자 From");
	    count++;
	  }

	  if (searchto == "") {
	    header.push("일자 To");
	    count++;
	  }

	  if (searchitemcode == "") {
	    header.push("품번/품명");
	    count++;
	  }

	  //    if (searchroutingid == "") {
	  //      header.push("공정명");
	  //      count++;
	  //    }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    result = false;
	  }

	  return result;
	}

	function fn_print() {
	  if (!fn_validation1()) {
	    return;
	  }

	  var column = 'master';
	  var url = "<c:url value='/report/ProdWorkTotalReport.do'/>";
	  var target = '_blank';

	  fn_popup_url(column, url, target);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {

	  //    // 품번 LOV
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
	  //        //          $("#searchOrderName").val("");
	  //        $("#searchItemCode").val("");
	  //        $("#searchItemName").val("");
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
	  //        $("#searchItemCode").val(o.item.ITEMCODE);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);

	  //        return false;
	  //      }
	  //    });

	  //    // 품명 LOV
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
	  //        $("#searchOrderName").val("");
	  //        $("#searchItemCode").val("");
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
	  //        $("#searchItemCode").val(o.item.ITEMCODE);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);

	  //        return false;
	  //      }
	  //    });
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
                                <li>공정 현황</li>
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
		                        <input type="hidden" id="searchItemCode" name="searchItemCode" />
		                        <input type="hidden" id="searchRoutingId" name="searchRoutingId" />
		                        <input type="hidden" id="searchModel" name="searchModel" />
		                        <input type="hidden" id="orgid" name="orgid" />
		                        <input type="hidden" id="companyid" name="companyid" />
                            <input type="hidden" id="itemcode" name="itemcode" />
                            <input type="hidden" id="ordername" name="ordername" />
                            <input type="hidden" id="itemname" name="itemname" />
                            <input type="hidden" id="model" name="model" />
                            <input type="hidden" id="modelname" name="modelname" />
                            <input type="hidden" id="routingid" name="routingid" />
                            <input type="hidden" id="routingname" name="routingname" />
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
                                                <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();">
                                                   엑셀
                                                </a>
<!--                                                 <a id="btnChk3" class="btn_print" href="#" onclick="javascript:fn_print();"> -->
<!--                                                    생산실적현황 -->
<!--                                                 </a> -->
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
                                        <th class="required_text">일자</th>
                                        <td >
                                            <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchTo" name="searchTo" class="input_validation input_center" style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">공정명</th>
                                        <td >
                                            <input type="text" id="searchRoutingName" name="searchRoutingName" class=" input_center " style="width: 97%; " />
                                        </td>
<!--                                         <th class="required_text">품목유형</th> -->
<!--                                         <td><select id="ItemType" name="ItemType" class="input_left " style="width: 97%;"> -->
<!--                                                   <option value="">전체</option> -->
<!--                                                   <option value="Y">제품</option> -->
<!--                                                   <option value="N">반제품</option> -->
<!--                                         </select></td> -->

                                        <th class="required_text">설비명</th>
                                        <td >
                                            <input type="text" id="searchEquipmentName" name="searchWrokOrderId" class=" input_left " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">작업지시번호</th>
                                        <td >
                                            <input type="text" id="searchWrokOrderId" name="searchWrokOrderId" class=" input_left " style="width: 97%; " />
                                        </td>
                                    </tr>
                                    <tr style="height: 34px;">
                                        <th class="required_text">품번</th>
                                        <td >
                                            <input type="text" id="searchOrderName" name="searchOrderName" class=" input_left " style="width: 97%; " />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
			                                  <th class="required_text">기종</th>
			                                  <td >
			                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
			                                  </td>
                                        <th class="required_text">작업자</th>
                                        <td >
                                            <input type="text" id="searchWorker" name="searchWorker" class=" input_center " style="width: 97%; " />
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->                    
                <div style="width: 100%;">
                    <div id="gridArea" style="width: 100%; padding-bottom: 0px; margin-bottom: 5px; float: left;"></div>
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