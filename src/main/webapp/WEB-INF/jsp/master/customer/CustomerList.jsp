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
	  setValues_detail();
	  setExtGrid_detail();

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  gridnms["app"] = "base";

	  $('#searchCustomerName').bind("keydown", function (e) {
	    if (e.keyCode == 13) {
	      fn_search();
	    }
	  });
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "CustomerManage";

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
	      name: 'RN'
	    }, {
	      type: 'number',
	      name: 'ORGID'
	    }, {
	      type: 'number',
	      name: 'COMPANYID'
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
	      name: 'CUSTOMERDIV',
	    }, {
	      type: 'string',
	      name: 'CUSTOMERDIVNAME'
	    }, {
	      type: 'string',
	      name: 'UNITPRICEDIV',
	    }, {
	      type: 'string',
	      name: 'UNITPRICEDIVNAME',
	    }, {
	      type: 'string',
	      name: 'LICENSENO',
	    }, {
	      type: 'string',
	      name: 'OWNER',
	    }, {
	      type: 'string',
	      name: 'PHONENUMBER'
	    }, {
	      type: 'string',
	      name: 'FAXNUMBER'
	    }, {
	      type: 'string',
	      name: 'BISSTATUS'
	    }, {
	      type: 'string',
	      name: 'BISTYPE'
	    }, {
	      type: 'string',
	      name: 'ZIPCODE'
	    }, {
	      type: 'string',
	      name: 'ADDRESS'
	    }, {
	      type: 'string',
	      name: 'PERSON'
	    }, {
	      type: 'string',
	      name: 'PERSONDEPT'
	    }, {
	      type: 'string',
	      name: 'PERSONPHONE'
	    }, {
	      type: 'string',
	      name: 'PERSONCELL'
	    }, {
	      type: 'string',
	      name: 'PERSONMAIL'
	    }, {
	      type: 'string',
	      name: 'USEYN'
	    }, {
	      type: 'string',
	      name: 'REMARKS'
	    }, {
	      type: 'string',
	      name: 'SEARCHDESC'
	    }, {
	      type: 'string',
	      name: 'CLOSINGDATENAME'
	    }
	  ];

	  fields["columns.1"] = [
	    // Display columns
	    {
	      dataIndex: "RN",
	      text: "순번",
	      xtype: "gridcolumn",
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'CUSTOMERCODE',
	      text: '거래처코드',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      text: '거래처명',
	      xtype: 'gridcolumn',
	      width: 250,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      align: "center",
	      renderer: function (value, metaData, record, rowIndex, colIndex, store, view) {
	        var result = '<div><a href="{0}">{1}</a></div>';
	        var url = "<c:url value='/customer/CustomerManage.do?code=' />" + record.data.CUSTOMERCODE + "&orgid=" + record.data.ORGID + "&companyid=" + record.data.COMPANYID;
	        return Ext.String.format(result, url, value);
	      }
	    }, {
	      dataIndex: 'CUSTOMERTYPENAME',
	      text: '거래처분류',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'CUSTOMERDIVNAME',
	      text: '거래처구분',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'UNITPRICEDIVNAME',
	      text: '단가구분',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      menuDisabled: true,
	      locked: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'LICENSENO',
	      text: '사업자번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'OWNER',
	      text: '대표자명',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'PHONENUMBER',
	      text: '전화번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'FAXNUMBER',
	      text: '팩스번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'BISSTATUS',
	      text: '업태',
	      xtype: 'gridcolumn',
	      width: 190,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'BISTYPE',
	      text: '업종',
	      xtype: 'gridcolumn',
	      width: 210,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'ZIPCODE',
	      text: '우편번호',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      menuDisabled: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'ADDRESS',
	      text: '주소',
	      xtype: 'gridcolumn',
	      width: 780,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "left",
	    }, {
	      dataIndex: 'CLOSINGDATENAME',
	      text: '마감일',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'SEARCHDESC',
	      text: '검색항목',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'USEYN',
	      text: '사용<br/>유무',
	      xtype: 'gridcolumn',
	      width: 55,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      lockable: false,
	      align: "center",
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 520,
	      hidden: false,
	      sortable: false,
	      menuDisabled: true,
	      lockable: false,
	      style: 'text-align:center',
	      align: "left",
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'CUSTOMERTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERDIV',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UNITPRICEDIV',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/customer/CustomerList.do' />"
	  });

	  items["btns.1"] = [];

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#MasterClick": {
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
	  //    items["docked.1"].push(items["dock.btn.1"]);
	}

	var gridarea;
	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"]
	  });

	  Ext.define(gridnms["store.1"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.1"],
	            model: gridnms["model.1"],
	            autoLoad: true,
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                searchCustomerCode: $("#searchCustomerCode").val(),
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      MasterClick: '#MasterClick',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    MasterClick: MasterClick,
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
	        height: 465,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        defaults: gridVals.defaultField,
	        viewConfig: {
	          itemId: 'MasterClick',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 150) {
	                    column.width = 150;
	                  }
	                }

	                if (column.dataIndex.indexOf('SEARCHDESC') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 150) {
	                    column.width = 150;
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
	    views: gridnms["panel.1"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["panel.1"], {
	          renderTo: 'gridArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function setValues_detail() {
	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.2"] = "CustomerMemberList";

	  gridnms["panel.2"] = gridnms["app"] + ".view." + gridnms["grid.2"];
	  gridnms["views.detail"].push(gridnms["panel.2"]);

	  gridnms["controller.2"] = gridnms["app"] + ".controller." + gridnms["grid.2"];
	  gridnms["controllers.detail"].push(gridnms["controller.2"]);

	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.detail"].push(gridnms["model.2"]);

	  gridnms["stores.detail"].push(gridnms["store.2"]);

	  fields["model.2"] = [{
	      type: 'number',
	      name: 'ORGID'
	    }, {
	      type: 'number',
	      name: 'COMPANYID'
	    }, {
	      type: 'string',
	      name: 'CUSTOMERCODE'
	    }, {
	      type: 'number',
	      name: 'MEMBERID',
	    }, {
	      type: 'string',
	      name: 'MEMBERNAME',
	    }, {
	      type: 'string',
	      name: 'DEPTNAME',
	    }, {
	      type: 'string',
	      name: 'POSITIONNAME',
	    }, {
	      type: 'string',
	      name: 'CELLNUMBER'
	    }, {
	      type: 'string',
	      name: 'PHONENUMBER',
	    }, {
	      type: 'string',
	      name: 'EMAIL',
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
	      name: 'REMARKS'
	    }
	  ];

	  fields["columns.2"] = [
	    // Display Columns
	    {
	      dataIndex: 'MEMBERID',
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
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'MEMBERNAME',
	      text: '담당자명',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'POSITIONNAME',
	      text: '직위',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'DEPTNAME',
	      text: '부서',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CELLNUMBER',
	      text: '담당자<br/>전화번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'PHONENUMBER',
	      text: '휴대폰<br/>번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'EMAIL',
	      text: 'E-MAIL',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'EFFECTIVESTARTDATE',
	      text: '유효<br/>시작일자',
	      xtype: 'datecolumn',
	      width: 100,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: false,
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'EFFECTIVEENDDATE',
	      text: '유효<br/>종료일자',
	      xtype: 'datecolumn',
	      width: 100,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: false,
	      filterable: true,
	      align: "center",
	      format: 'Y-m-d',
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      //        width: 235,
	      flex: 1,
	      hidden: false,
	      sortable: false,
	      resizable: true,
	      menuDisabled: true,
	      style: 'text-align:center;',
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
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/customer/CustomerMemberList.do' />"
	  });

	  items["btns.2"] = [];

	  items["btns.ctr.2"] = {};

	  items["dock.paging.2"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.2"],
	  };

	  items["dock.btn.2"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.2"],
	    items: items["btns.2"],
	  };

	  items["docked.2"] = [];
	  //      items["docked.2"].push(items["dock.btn.2"]);
	}

	var gridarea1;
	function setExtGrid_detail() {
	  Ext.define(gridnms["model.2"], {
	    extend: Ext.data.Model,
	    fields: fields["model.2"],
	  });

	  Ext.define(gridnms["store.2"], {
	    extend: Ext.data.JsonStore, // Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.2"],
	            model: gridnms["model.2"],
	            autoLoad: true,
	            isStore: false,
	            autoDestroy: true,
	            clearOnPageLoad: true,
	            clearRemovedOnLoad: true,
	            pageSize: 9999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.2"],
	              timeout: gridVals.timeout,
	              extraParams: {
	                searchCustomerCode: $("#searchCustomerCode").val(),
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
	                GUBUN: "Y",
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.2"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnDetail: '#btnDetail',
	    },
	    stores: [gridnms["store.2"]],

	  });

	  Ext.define(gridnms["panel.2"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.2"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'rowmodel',
	        itemId: gridnms["panel.2"],
	        id: gridnms["panel.2"],
	        store: gridnms["store.2"],
	        height: 200,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20, // #1
	            leadingBufferZone: 20, // #2
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'btnDetail',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('MEMBERNAME') >= 0 || column.dataIndex.indexOf('POSITIONNAME') >= 0 || column.dataIndex.indexOf('EMAIL') >= 0 || column.dataIndex.indexOf('MEMBERNAME') >= 0 || column.dataIndex.indexOf('DEPTNAME') >= 0) {
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
	        dockedItems: items["docked.2"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.detail"],
	    stores: gridnms["stores.detail"],
	    views: gridnms["views.detail"],
	    controllers: gridnms["controller.2"],

	    launch: function () {
	      gridarea1 = Ext.create(gridnms["views.detail"], {
	          renderTo: 'gridDetailArea'
	        });
	    },
	  });
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
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
	  var searchCustomerCode = $("#searchCustomerCode").val();
	  var searchCustomerName = $("#searchCustomerName").val();

	  var sparams = {
	    orgid: $("#searchOrgId").val() + "",
	    companyid: $("#searchCompanyId").val() + "",
	    searchCustomerCode: searchCustomerCode,
	    searchCustomerName: searchCustomerName,
	    GUBUN: "Y",
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.2"]);
	  }, 300);
	}

	function MasterClick(dataview, record, item, index, e, eOpts) {

	  var sparams = {
	    ORGID: record.data.ORGID,
	    COMPANYID: record.data.COMPANYID,
	    CUSTOMERCODE: record.data.CUSTOMERCODE,
	    MASTERCLICK: "Y",
	  };

	  extGridSearch(sparams, gridnms["store.2"]);
	};

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var searchCustomerCode = $("#searchCustomerCode").val();
	  var title = $('#title').val();

	  go_url("<c:url value='/customer/ExcelDownload.do?GUBUN='/>" + "CUSTOMER"
	     + "&orgid=" + orgid + ""
	     + "&companyid=" + companyid + ""
	     + "&searchCustomerCode=" + searchCustomerCode + ""
	     + "&TITLE=" + title + "");
	}

	function fn_regist(master) {
	  // 거래처 등록
	  var forms = document.getElementById(master);
	  var url = '<c:url value="/customer/CustomerManage.do" />';

	  forms.action = url;
	  forms.method = "post";
	  forms.submit();
	}

	function setLovList() {
	  // 거래처명 lov
	  //    $("#searchCustomerName").bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        //             $("#searchCustomerName").val("");
	  //        $("#searchCustomerCode").val("");

	  //        break;
	  //      case $.ui.keyCode.ENTER:
	  //        $(this).autocomplete("search", "%");
	  //        break;

	  //      default:
	  //        break;
	  //      }
	  //    }).focus(
	  //      function (e) {
	  //      $(this).autocomplete("search",
	  //        (this.value === "") ? "%" : this.value);
	  //    }).autocomplete({
	  //      source: function (request, response) {
	  //        $.getJSON("<c:url value='/searchCustomernameLov.do' />", {
	  //          keyword: extractLast(request.term),
	  //          ORGID: $('#searchOrgId option:selected').val(),
	  //          COMPANYID: $('#searchCompanyId option:selected').val(),
	  //          //          CUSTOMERTYPE: 'A',
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                value: m.VALUE,
	  //                label: m.LABEL + ", " + m.CUSTOMERTYPENAME,
	  //                NAME: m.LABEL,
	  //                ADDRESS: m.ADDRESS,
	  //                FREIGHT: m.FREIGHT,
	  //                PHONENUMBER: m.PHONENUMBER,
	  //                UNITPRICEDIV: m.UNITPRICEDIV,
	  //                UNITPRICEDIVNAME: m.UNITPRICEDIVNAME,
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
	  //        $("#searchCustomerCode").val(o.item.value);
	  //        $("#searchCustomerName").val(o.item.NAME);

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
                                                <li>기준정보</li>
                                                <li>&gt;</li>
                                                <li><strong>${pageTitle}</strong></li>
                                        </ul>
                                </div>
                        </div>
                        <!-- 검색 필드 박스 시작 -->
                        <div id="search_field" style="margin-bottom: 0px;">
                                <div id="search_field_loc">
                                        <h2>
                                                <strong>${pageTitle}</strong>
                                        </h2>
                                </div>
                                <form id="master" name="master" method="post" onkeydown="return fn_key_break(event, 13)" >
                                        <input type="hidden" id="title" name="title" value="${pageTitle}" />
                                        <fieldset>
                                                <legend>조건정보 영역</legend>
                                                <div>
                                                        <table class="tbl_type_view" border="1">
                                                                <colgroup>
                                                                        <col width="10%">
                                                                        <col width="18%">
                                                                        <col width="10%">
                                                                        <col width="18%">
                                                                        <col width="10%">
                                                                        <col width="18%">
                                                                </colgroup>
                                                                <tr style="height: 34px;">
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
                                                                        <th class="required_text">거래처명</th>
                                                                        <td><input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left" style="width: 97%;" /> <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" /></td>
                                                                        <td>
                                                                                <div class="buttons" style="float: right; margin-top: 3px;">
                                                                                        <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
                                                                                        <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a>
                                                                                        <a id="btnChk3" class="btn_add" href="#" onclick="javascript:fn_regist('master');"> 추가 </a>
                                                                                </div>
                                                                        </td>
                                                                </tr>
                                                                <!--                <tr style="height: 34px;"> -->
                                                                <!--                  <th class="required_text">거래처명</th> -->
                                                                <!--                  <td> -->
                                                                <!--                    <input type="text" id="searchCustomerName" name="searchCustomerName" class="input_left" style="width: 97%;" /> -->
                                                                <!--                    <input type="hidden" id="searchCustomerCode" name="searchCustomerCode" /> -->
                                                                <!--                  </td> -->
                                                                <!--                     <th class="required_text">사용유무</th> -->
                                                                <!--                     <td> -->
                                                                <!--                         <select id="searchUseYn" name="searchUseYn" class="input_validation input_left" style="width: 97%;"> -->
                                                                <!--                             <option value="Y" label="사용" selected/> -->
                                                                <!--                             <option value="N" label="미사용" /> -->
                                                                <!--                         </select> -->
                                                                <!--                     </td> -->
                                                                <!--                     <td> -->
                                                                <!--                     </td> -->
                                                                <!--                     <td> -->
                                                                <!--                     </td> -->
                                                                <!--                </tr> -->
                                                        </table>
                                                </div>
                                        </fieldset>
                                </form>
                        </div>
                        <!-- //검색 필드 박스 끝 -->

                        <table style="width: 100%;">
                                <tr>
                                     <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">거래처 List</div></td>
                                </tr>
                        </table>
                        <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
		                    <table style="width: 100%;">
		                        <tr>
		                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">담당자</div></td>
		                        </tr>
		                    </table>
		                    <div id="gridDetailArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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