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

.blue2 {
    background-color: #5B9BD5;
    color: white;
}

.gray:HOVER {
    background-color: #EAEAEA;
}

.gray {
    background-color: #BDBDBD;
    color: black;
}

.white:HOVER {
    background-color: #FFFFFF;
    color: black;
}

.white {
    background-color: #000000;
    color: white;
}

.yellow:HOVER {
    background-color: #FFFF7E;
}

.yellow {
    background-color: yellow;
    color: black;
}

.red:HOVER {
    background-color: #FFD8D8;
}

.red {
    background-color: #FFA7A7;
    color: black;
}

.r {
    border-radius: 4px 4px 4px 4px;
    -moz-border-radius: 4px 4px 4px 4px;
    -webkit-border-radius: 4px 4px 4px 4px;
    border: 0px solid #000000;
}

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

.x-column-header-inner {
    font-size: 8px;
}
</style>
<script type="text/javaScript">
$(document).ready(function () {
    setInitial();
    
    setValues();
    setExtGrid();

    setReadOnly();
});

function setInitial() {
    gridnms["app"] = "pda";
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
  gridnms["models.viewer"] = [];
  gridnms["stores.viewer"] = [];
  gridnms["views.viewer"] = [];
  gridnms["controllers.viewer"] = [];

  gridnms["grid.1"] = "PdaMatReceiveManageD";

  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
  gridnms["views.viewer"].push(gridnms["panel.1"]);

  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
  gridnms["controllers.viewer"].push(gridnms["controller.1"]);

  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

  gridnms["models.viewer"].push(gridnms["model.1"]);

  gridnms["stores.viewer"].push(gridnms["store.1"]);

  fields["model.1"] = [{
      type: 'number',
      name: 'RN',
    }, {
      type: 'string',
      name: 'ORGID',
    }, {
      type: 'string',
      name: 'COMAPNYID',
    }, {
      type: 'string',
      name: 'ORDERNAME',
    }, {
      type: 'string',
      name: 'ITEMCODE',
    }, {
      type: 'string',
      name: 'ITEMNAME',
    }, {
      type: 'string',
      name: 'DRAWINGNO',
    }, {
      type: 'string',
      name: 'MODEL',
    }, {
      type: 'string',
      name: 'MODELNAME',
    }, {
      type: 'string',
      name: 'UOM',
    }, {
      type: 'string',
      name: 'UOMNAME',
    }, {
      type: 'string',
      name: 'ROUTINGCODE',
    }, {
      type: 'string',
      name: 'ROUTINGNAME',
    }, {
      type: 'string',
      name: 'OUTPONO',
    }, {
      type: 'string',
      name: 'OUTPOSEQ',
    }, {
      type: 'number',
      name: 'PASSQTY',
    }, {
      type: 'number',
      name: 'INSPQTY',
    }, {
      type: 'number',
      name: 'ORDERQTY',
    }, {
      type: 'number',
      name: 'TRANSQTY',
    }, {
      type: 'number',
      name: 'EXTRANSQTY',
    }, {
      type: 'number',
      name: 'UNITPRICE',
    }, {
	    type: 'number',
	    name: 'QTY',
	  }, {
      type: 'string',
      name: 'CUSTOMERCODEOUT',
    }, {
      type: 'string',
      name: 'CUSTOMERNAMEOUT',
    }, {
      type: 'string',
      name: 'POSTATUS',
    }, {
      type: 'string',
      name: 'WORKSTATUS',
    }, {
      type: 'string',
      name: 'INSPECTIONPLANNO',
    }, {
	    type: 'string',
	    name: 'TRADENO',
	  }, {
      type: 'number',
      name: 'TRADESEQ',
    }, {
      type: 'number',
      name: 'SUPPLYPRICE',
    }, {
	    type: 'number',
	    name: 'ADDITIONALTAX',
	  }, {
      type: 'number',
      name: 'FAULTQTY',
    }, ];

  fields["columns.1"] = [
    // Display Columns
    {
      dataIndex: 'RN',
      text: '순번',
      xtype: 'gridcolumn',
      width: 55,
      hidden: false,
      sortable: true,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      cls: 'ERPQTY',
      format: "0,000",
      renderer: function (value, meta, record) {
        return value;
      },
    },{
	    dataIndex: 'MODELNAME',
	    text: '기종',
	    xtype: 'gridcolumn',
	    width: 100,
	    hidden: false,
	    sortable: true,
	    resizable: true,
	    menuDisabled: true,
	    style: 'text-align:center;',
	    align: "center",
	    renderer: function (value, meta, record) {
	      return value;
	    },
	  }, {
	    dataIndex: 'ITEMSTANDARDDETAIL',
	    text: '타입',
	    xtype: 'gridcolumn',
	    width: 50,
	    hidden: false,
	    sortable: true,
	    resizable: true,
	    menuDisabled: true,
	    style: 'text-align:center;',
	    align: "center",
	    renderer: function (value, meta, record) {
	      return value;
	    },
	  },{
	    dataIndex: 'ITEMNAME',
	    text: '품명',
	    xtype: 'gridcolumn',
	    width: 170,
	    hidden: false,
	    sortable: true,
	    resizable: true,
	    menuDisabled: true,
	    style: 'text-align:center;',
	    align: "left",
	    renderer: function (value, meta, record) {
	      return value;
	    },
	  }, {
      dataIndex: 'TRANSQTY',
      text: '수량',
      xtype: 'gridcolumn',
      width: 80,
      hidden: false,
      sortable: true,
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
      dataIndex: 'OUTPONO',
      text: '발주번호',
      xtype: 'gridcolumn',
      width: 110,
      hidden: false,
      sortable: true,
      resizable: true,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      renderer: function (value, meta, record) {
        return value;
      },
    }, {
      dataIndex: 'OUTPOSEQ',
      text: '발주순번',
      xtype: 'gridcolumn',
      width: 60,
      hidden: false,
      sortable: true,
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
	    width: 120,
	    hidden: false,
	    sortable: true,
	    resizable: true,
	    menuDisabled: true,
	    style: 'text-align:center;',
	    align: "center",
	    renderer: function (value, meta, record) {
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
	    dataIndex: 'UOM',
	    xtype: 'hidden',
	  }, {
	    dataIndex: 'MODEL',
	    xtype: 'hidden',
	  }, {
	    dataIndex: 'ITEMCODE',
	    xtype: 'hidden',
	  }, {
	    dataIndex: 'WORKORDERID',
	    xtype: 'hidden',
	  }, {
	    dataIndex: 'WORKORDERSEQ',
	    xtype: 'hidden',
	  }, {
      dataIndex: 'ROUTINGNO',
      xtype: 'hidden',
    }, {
	    dataIndex: 'ROUTINGNAME',
	    xtype: 'hidden',
	  }, {
      dataIndex: 'FINISHCHECK',
      xtype: 'hidden',
    }, {
	    dataIndex: 'ORDERQTY',
	    xtype: 'hidden',
	  }, {
      dataIndex: 'UNITPRICE',
      xtype: 'hidden',
    }, {
	    dataIndex: 'SUPPLYPRICE',
	    xtype: 'hidden',
	  }, {
      dataIndex: 'ADDITIONALTAX',
      xtype: 'hidden',
    }, {
	    dataIndex: 'TOTAL',
	    xtype: 'hidden',
	  }, {
      dataIndex: 'CUSTOMERCODEOUT',
      xtype: 'hidden',
    }, {
	    dataIndex: 'CUSTOMERNAMEOUT',
	    xtype: 'hidden',
	  }, {
      dataIndex: 'OUTPOPERSON',
      xtype: 'hidden',
    }, {
	    dataIndex: 'OUTPOSTATUS',
	    xtype: 'hidden',
	  }, {
      dataIndex: 'SCMINSPECTIONYN',
      xtype: 'hidden',
    }, {
	    dataIndex: 'TRADENO',
	    xtype: 'hidden',
	  }, {
      dataIndex: 'TRADESEQ',
      xtype: 'hidden',
    }, {
	    dataIndex: 'FAULTQTY',
	    xtype: 'hidden',
	  },
	  ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/pda/PdaOutTransDetailList.do' />"
  });

  items["btns.1"] = [];

  items["btns.ctr.1"] = {};
  $.extend(items["btns.ctr.1"], {
      "#btnList": {
    	  itemclick: 'DetailClick'
      }
  });
  
  items["dock.paging.1"] = {
    xtype: 'pagingtoolbar',
    dock: 'bottom',
    displayInfo: true,
    store: gridnms["store.1"],
  };

  items["dock.btn.1"] = {
    //xtype: 'toolbar',
    //dock: 'top',
    //displayInfo: true,
    //store: gridnms["store.1"],
    //items: items["btns.1"],
  };

  items["docked.1"] = [];
  items["docked.1"].push(items["dock.btn.1"]);
}

function DetailClick(dataview, record, item, index, e, eOpts) {
	$('#CustomerName').val(record.data.CUSTOMERNAMEOUT);
	$('#CustomerCode').val(record.data.CUSTOMERCODEOUT);
	$('#TransDate').val(record.data.TRANSDATE);
	
	
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
            //isStore: false,
            autoDestroy: true,
            clearOnPageLoad: true,
            clearRemovedOnLoad: true,
            pageSize: 9999,
            proxy: {
              type: 'ajax',
              api: items["api.1"],
              extraParams: {
                ORGID: $('#orgid').val(),
                COMPANYID: $('#companyid').val(),
                TRADENO : "${LOTNO}",
              },
              reader: gridVals.reader,
              writer: $.extend(gridVals.writer, {
                writeAllFields: true
              }),
            },
            listeners: {
              load: function(dataStore, rows, bool) {
                if(rows.length > 0)
                {
                  DetailClick(null, rows[0], null, 0, null, null);
                }
              },
              scope: this
            },
          }, cfg)]);
    },
  });

  Ext.define(gridnms["controller.1"], {
    extend: Ext.app.Controller,
    refs: {
      btnList: '#btnList',
    },
    stores: [gridnms["store.1"]],
    control: items["btns.ctr.1"],
    
    DetailClick : DetailClick,
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
        height: 350,
        border: 2,
        scrollable: true,
        columns: fields["columns.1"],
        plugins: [{
            ptype: 'bufferedrenderer',
            trailingBufferZone: 20, // #1
            leadingBufferZone: 20, // #2
            synchronousRender: false,
            numFromEdge: 19,
          }
        ],
        viewConfig: {
          itemId: 'btnList',
          trackOver: true,
          loadMask: true,
        },
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
          renderTo: 'gridArea'
        });
    },
  });

  Ext.EventManager.onWindowResize(function (w, h) {
    gridarea.updateLayout();
  });
}

function fn_search() {
  var orgid = $('#orgid').val();
  var companyid = $('#companyid').val();
  var ponoseq = $('#ponoseq').val();

  var sparams = {
    ORGID: orgid,
    COMPANYID: companyid,
    SEARCHPONO: ponoseq,
  };
  extGridSearch(sparams, gridnms["store.1"]);
  $("#lotno").focus();
}

function fn_back() {
  go_url('<c:url value="/pda/PdaOutTransBarcode.do" />');
}

function fn_save() {
	var params = [];
	var url = "<c:url value='/insert/pda/pda/PdaOutTransDetailList.do' />";
	
	Ext.MessageBox.confirm('알림', '저장 하시겠습니까?', function (btn) {
    if (btn == 'yes') {
			var recount = Ext.getStore(gridnms["store.1"]).count();
			for (var i = 0; i < recount; i++) {
			  var model = Ext.getStore(gridnms["store.1"]).getAt(i);
			
			
			    params.push(model.data);
			  
			}
			
			Ext.Ajax.request({
		    url: url,
		    method: 'POST',
		    headers: {
		      'Content-Type': 'application/json'
		    },
		    jsonData: {
		      data: params
		    },
		    success: function (conn, response, options, eOpts) {
		     
		
		      extAlert("저장되었습니다.");
		      fn_back();
		    },
		    error: ajaxError
		  });
    } else {
	    Ext.Msg.alert('입고등록', '입고등록이 취소되었습니다.');
	    $('#Status').val($('#StatusTemp').val());
	    return;
	  }
	});
}

function setReadOnly() {
  $("[readonly]").addClass("ui-state-disabled");
}
</script>
</head>
<body oncontextmenu="return false" onselectstart="return false" ondragstart="return false">
		<form id="master" name="master" action="" method="post">
				<h3 class="shadow" style="height: 35px; font-size: 20px; background-color: rgb(149, 179, 215); font-weight: bold; margin-top: 0px; text-align: center; display: -webkit-flex; display: flex; -webkit-align-items: center; align-items: center; -webkit-justify-content: center; justify-content: center;">${pageTitle}</h3>
				<input type="hidden" id="orgid" name="orgid" />
				<input type="hidden" id="companyid" name="companyid" />
				<table style="width: 100%; margin: 0px; height: 14%">
						<colgroup>
								<col style="width: 30%;">
								<col style="width: 70%;">
						</colgroup>
            <tr style="height: 10px;">
                <td colspan="2"></td>
            </tr>
						<tr style="height: 21px;">
								<th class="required_text" style="font-size: 17px;">가공처</th>
								<td>
										<input type="text" id="CustomerName" name="CustomerName" class="input_center" style="width: 94%;" readonly />
										<input type="hidden" id="CustomerCode" name="CustomerCode" />
								</td>
						</tr>
            <tr style="height: 10px;">
                <td colspan="2"></td>
            </tr>
						<tr style="height: 21px;">
								<th class="required_text" style="font-size: 17px;">입고일</th>
								<td><input type="text" id="TransDate" name="TransDate" class="input_center" style="width: 94%;" readonly /></td>
						</tr>
            <tr style="height: 10px;">
                <td colspan="2"></td>
            </tr>
				</table>
		</form>
		<div style="width: 100%; height: 21%; margin: 0px;">
				<div id="gridArea" style="width: 100%; margin-bottom: 15px; float: left;"></div>
		</div>
    <table style="width: 100%; height: 10%; margin: 0px;">
        <colgroup>
            <col width="1%">
            <col>
            <col width="1%">
            <col>
            <col width="1%">
        </colgroup>
        <tr style="height: 21px;">
            <td></td>
            <td>
                <button type="button" class="blue2 h r shadow" onclick="fn_back();" style="width: 100%; height: 100%; font-size: 20px; font-weight: bold; color: #fff; margin: 0px;">이전화면</button>
            </td>
            <td></td>
            <td>
                <button type="button" class="blue2 h r shadow" onclick="fn_save();" style="width: 100%; height: 100%; font-size: 20px; font-weight: bold; color: #fff; margin: 0px;;">저장</button>
            </td>
            <td></td>
        </tr>
    </table>
</body>
</html>