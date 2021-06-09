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

	  $("#gridPopup2Area").hide("blind", {
	    direction: "up"
	  }, "fast");

	  setReadOnly();

	  setLovList();
	});

	function setInitial() {
	  calender($('#searchNcrFrom, #searchNcrTo'));

	  $('#searchNcrFrom, #searchNcrTo').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  $("#searchNcrFrom").val(getToDay("${searchVO.dateFrom}") + "");
	  $("#searchNcrTo").val(getToDay("${searchVO.dateFrom}") + "");
	  //    $("#searchPrintMonth").val(getToDay("${searchVO.dateMonth}") + "");

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  gridnms["app"] = "prod";
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  setValues_list();
	  setValues_detail();
	  setValues_popup2(); // 제품 불러오기
	}

	function setValues_list() {
	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "ProdInsNonConfirmRegist";
	  gridnms["grid.6"] = "ncrImputeLov";
	  gridnms["grid.7"] = "ncrresultLov";
	  gridnms["grid.8"] = "workerLov";
	  gridnms["grid.11"] = 'itemLov';

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.list"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.list"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
	  gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];
	  gridnms["model.8"] = gridnms["app"] + ".model." + gridnms["grid.8"];
	  gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
	  gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];
	  gridnms["store.8"] = gridnms["app"] + ".store." + gridnms["grid.8"];
	  gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];

	  gridnms["models.list"].push(gridnms["model.1"]);
	  gridnms["models.list"].push(gridnms["model.6"]);
	  gridnms["models.list"].push(gridnms["model.7"]);
	  gridnms["models.list"].push(gridnms["model.8"]);
	  gridnms["models.list"].push(gridnms["model.11"]);

	  gridnms["stores.list"].push(gridnms["store.1"]);
	  gridnms["stores.list"].push(gridnms["store.6"]);
	  gridnms["stores.list"].push(gridnms["store.7"]);
	  gridnms["stores.list"].push(gridnms["store.8"]);
	  gridnms["stores.list"].push(gridnms["store.11"])

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
	      name: 'NCRNO',
	    }, {
	      type: 'date',
	      name: 'CREATIONDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'BIGCODE',
	    }, {
	      type: 'string',
	      name: 'BIGNAME',
	    }, {
	      type: 'string',
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
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
	      name: 'LOTNO',
	    }, {
	      type: 'string',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'EQUIPMENTNAME',
	    }, {
	      type: 'string',
	      name: 'WORKCENTERCODE',
	    }, {
	      type: 'string',
	      name: 'ROUTINGGROUP',
	    }, {
	      type: 'string',
	      name: 'NCRIMPUTE',
	    }, {
	      type: 'string',
	      name: 'NCRIMPUTENAME',
	    }, {
	      type: 'string',
	      name: 'NCRRESULT',
	    }, {
	      type: 'string',
	      name: 'NCRRESULTNAME',
	    }, {
	      type: 'string',
	      name: 'WORKEMPLOYEENAME',
	    }, {
	      type: 'string',
	      name: 'WORKEMPLOYEE',
	    }, {
	      type: 'string',
	      name: 'EMPLOYEESEQ',
	    }, {
	      type: 'number',
	      name: 'PRODQTY',
	    }, {
	      type: 'number',
	      name: 'IMPORTQTY',
	    }, {
	      type: 'number',
	      name: 'NCRQTY',
	    }, {
	      type: 'number',
	      name: 'OLDNCRQTY',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'WORKORDERID',
	    }, {
	      type: 'number',
	      name: 'WORKORDERSEQ',
	    }, {
	      type: 'string',
	      name: 'WORKORDERYN',
	    }, {
	      type: 'number',
	      name: 'NCRCOST',
	    }, {
	      type: 'number',
	      name: 'NCRPRICE',
	    }, {
	      type: 'string',
	      name: 'OUTTRANSNO',
	    }, {
	      type: 'number',
	      name: 'OUTTRANSSEQ',
	    }, ];

	  fields["model.6"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["model.7"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["model.8"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];
	  
	  fields["model.11"] = [{
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
        name: 'MODEL',
      }, {
        type: 'string',
        name: 'MODELNAME',
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
        name: 'CUSTOMERGUBUNNAME',
      }, {
        type: 'string',
        name: 'CUSTOMERGUBUN',
      }, {
        type: 'string',
        name: 'CUSTOMERCODE',
      }, {
        type: 'string',
        name: 'CUSTOMERNAME',
      }, ];

	  fields["columns.1"] = [{
	      dataIndex: 'CHK',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 35,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'checkbox',
	      },
	      renderer: function (value, meta, record, row, col) {
	        if (record.data.WORKORDERYN == "Y") {
	          meta['tdCls'] = 'x-item-disabled';
	        } else {
	          if (record.data.NCRRESULT != "A") {
	            meta['tdCls'] = 'x-item-disabled';
	          } else {
	            meta['tdCls'] = '';
	          }
	        }
	        return new Ext.ux.CheckColumn().renderer(value);
	      },
	      listeners: {
	        beforecheckchange: function (options, row, value, event) {

	          var record = Ext.getCmp(gridnms["views.list"]).selModel.store.data.items[row].data;
	          if (value) {
	            if (record.WORKORDERYN == "Y") {
	              extAlert("재작업지시가 이미 등록되어있습니다.<br/>다시 한번 확인해주세요.");
	              return false;
	            } else {

	              if (record.NCRRESULT != "A") {
	                extAlert("처리구분이 수리인 항목만 선택 가능합니다.<br/>다시 한번 확인해주세요.");
	                return false;
	              }
	            }
	          }
	        }
	      }
	    }, {
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
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'NCRNO',
	      text: '부적합번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'CREATIONDATE',
	      text: '등록일',
	      xtype: 'datecolumn',
	      width: 105,
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
	        var result = record.data.NCRNO;
	        var workorderyn = record.data.WORKORDERYN;
	        if (workorderyn == "Y") {
	          meta.style = "background-color:rgb(234, 234, 234)";
	        } else {

	          if (result != "") {

	            meta.style = "background-color:rgb(234, 234, 234)";
	          }
	        }

	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    },  {
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
        editor: {
          xtype: 'combobox',
          store: gridnms["store.11"],
          valueField: "ITEMNAME",
          displayField: "ITEMNAME",
          matchFieldWidth: false,
          editable: true,
          queryParam: 'keyword',
          queryMode: 'local', // 'remote',
          allowBlank: true,
          transform: 'stateSelect',
          forceSelection: false,
          anyMatch: true,
          hideTrigger: true,
          listeners: {
            select: function (value, record, eOpts) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

              model.set("ITEMCODE", record.data.ITEMCODE);
              model.set("ORDERNAME", record.data.ORDERNAME);
              model.set("DRAWINGNO", record.data.DRAWINGNO);
              model.set("MODEL", record.data.MODEL);
              model.set("MODELNAME", record.data.MODELNAME);
              model.set("ITEMSTANDARDDETAIL", record.data.ITEMSTANDARDDETAIL);
              //              model.set("MATERIALTYPE", record.data.MATERIALTYPE);
              model.set("UOM", record.data.UOM);
              model.set("UOMNAME", record.data.UOMNAME);
              model.set("CUSTOMERGUBUN", record.data.CUSTOMERGUBUN);
              model.set("CUSTOMERGUBUNNAME", record.data.CUSTOMERGUBUNNAME);
              
              model.set("CARTYPENAME", record.data.CARTYPENAME);
              model.set("CARTYPE", record.data.CARTYPE);

              var item = record.data.ITEMNAME;

              if (item == "") {
                model.set("ITEMCODE", "");
                model.set("ORDERNAME", "");
                model.set("DRAWINGNO", "");
                model.set("MODEL", "");
                model.set("MODELNAME", "");
                model.set("ITEMSTANDARDDETAIL", "");
                //                model.set("MATERIALTYPE", "");
                model.set("UOM", "");
                model.set("UOMNAME", "");
                model.set("CUSTOMERGUBUN", "");
                model.set("CUSTOMERGUBUNNAME", "");

              }

            },
            change: function (field, ov, nv, eOpts) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
              var result = field.getValue();

              if (ov != nv) {
                if (!isNaN(result)) {
                  model.set("ITEMCODE", "");
                  model.set("ORDERNAME", "");
                  model.set("DRAWINGNO", "");
                  model.set("MODEL", "");
                  model.set("MODELNAME", "");
                  model.set("ITEMSTANDARDDETAIL", "");
                  //                  model.set("MATERIALTYPE", "");
                  model.set("UOM", "");
                  model.set("UOMNAME", "");
                  model.set("CUSTOMERGUBUN", "");
                  model.set("CUSTOMERGUBUNNAME", "");
                  model.set("CARTYPENAME", "");
                  model.set("CARTYPE", "");
                }
              }
            },
          },
          listConfig: {
            loadingText: '검색 중...',
            emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
            width: 700,
            getInnerTpl: function () {
              return '<div >'
               + '<table >'
               + '<colgroup>'
               + '<col width="380px">'
              //               + '<col width="120px">'
               + '<col width="120px">'
               + '<col width="50px">'
              //               + '<col width="120px">'
               + '<col width="120px">'
               + '</colgroup>'
               + '<tr>'
               + '<td style="height: 25px; font-size: 13px; ">{ITEMNAME}</td>'
              //               + '<td style="height: 25px; font-size: 13px; ">{ITEMCODE}</td>'
              //               + '<td style="height: 25px; font-size: 13px; ">{ORDERNAME}</td>'
               + '<td style="height: 25px; font-size: 13px; ">{MODELNAME}</td>'
              //                 19.09.02 추가 (품명, 기종, 타입, 품번)
               + '<td style="height: 25px; font-size: 13px;">{ITEMSTANDARDDETAIL}</td>'
              //               + '<td style="height: 25px; font-size: 13px; ">{CUSTOMERGUBUNNAME}</td>'
              // + '<td style="height: 25px; font-size: 13px; ">{UOMNAME}</td>'
               + '<td style="height: 25px; font-size: 13px;">{ORDERNAME}</td>'
               + '</tr>'
               + '</table>'
               + '</div>';
            }
          },
        },
        renderer: function (value, meta, record) {
        	var ncrNo = record.data.NCRNO;
        	if (ncrNo != "") {
            meta.style = "background-color:rgb(234, 234, 234)";
          } else {
            meta.style = "background-color:rgb(253, 218, 255)";
          }
        	return value;
        },
      },  {
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
          meta.style = "background-color:rgb(234, 234, 234)";
          return value;
	     },
	    }, {
	      dataIndex: 'ITEMSTANDARDDETAIL',
	      text: '타입',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      align: "center",
	      renderer: function (value, meta, record) {
          meta.style = "background-color:rgb(234, 234, 234)";
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
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
        },
      },{
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
          
	    	  meta.style = "background-color:rgb(234, 234, 234)";
          return value;
	      },
	    }, {
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'EQUIPMENTNAME',
	      text: '설비명',
	      xtype: 'gridcolumn',
	      width: 175,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234);";
	        return value;
	      },
	    }, {
	      dataIndex: 'WORKEMPLOYEENAME',
	      text: '작업자',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.8"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: true,
	        editable: true,
	        anyMatch: true,
	        queryMode: 'local',
	        queryParam: 'keyword',
	        allowBlank: true,
	        forceSelection: false,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
	            var code = record.data.VALUE;

	            model.set("WORKEMPLOYEE", code);
	          },
	          change: function (value, nv, ov, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

	            if (nv != ov) {
	              if (!isNaN(value.getValue())) {

	                model.set("WORKEMPLOYEE", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '데이터가 없습니다.<br/>관리자에게 문의하십시오.',
	          width: 200,
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
	        var workorderyn = record.data.WORKORDERYN;
	        
	        if (workorderyn == "Y") {
	          meta.style = "background-color:rgb(234, 234, 234)";
	        } else {
	          meta.style = "background-color:rgb(253, 218, 255)";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'NCRIMPUTENAME',
	      text: '불량유형',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.6"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: true,
	        editable: false,
	        typeAhead: true,
	        queryMode: 'remote',
	        allowBlank: true,
	        forceSelection: false,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

	            model.set("NCRIMPUTE", record.data.VALUE);
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
	        var workorderyn = record.data.WORKORDERYN;
	        if (workorderyn == "Y") {
	          meta.style = "background-color:rgb(234, 234, 234)";
	        } else {

	          meta.style = "background-color:rgb(253, 218, 255)";
	        }
	        return value;
	      },
	    }, {
	      dataIndex: 'PRODQTY',
	      text: '생산수량',
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
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'IMPORTQTY',
	      text: '양품수량',
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
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'NCRQTY',
	      text: '불량수량',
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
	      editor: {
	        xtype: "textfield",
	        minValue: 1,
	        format: "0,000",
	        enforceMaxLength: true,
	        allowBlank: true,
	        maxLength: '9',
	        maskRe: /[0-9]/,
	        selectOnFocus: true,
	        listeners: {
	          change: function (field, newValue, oldValue, eOpts) {
	            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

	            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
	            var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	            var qty = newValue;

	            var sumcost = (qty * 1) * (store.data.NCRCOST * 1);

	            store.set("NCRPRICE", sumcost);
	          },
	        },
	      },
	      renderer: function (value, meta, record) {
	        var workorderyn = record.data.WORKORDERYN;
	        if (workorderyn == "Y") {
	          meta.style = "background-color:rgb(234, 234, 234)";
	        } else {

	          meta.style = "background-color:rgb(253, 218, 255)";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'NCRPRICE',
	      text: '손실비용',
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
	        var workorderyn = record.data.WORKORDERYN;
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'NCRRESULTNAME',
	      text: '처리구분',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.7"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: true,
	        editable: false,
	        allowBlank: true,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

	            var code = record.data.VALUE;
	            var chk = model.data.CHK;
	            model.set("NCRRESULT", code);

	            if (chk) {
	              if (code != "A") {
	                model.set("CHK", false);
	              }
	            }
	          },
	          change: function (value, nv, ov, e) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
	            var result = value.getValue();
	            if (nv !== ov) {
	              model.set("NCRRESULT", "");
	            }
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
	        var workorderyn = record.data.WORKORDERYN;
	        if (workorderyn == "Y") {
	          meta.style = "background-color:rgb(234, 234, 234)";
	        }
	        //          meta.style = "background-color:rgb(253, 218, 255)";
	        return value;
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 260,
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
	        var workorderyn = record.data.WORKORDERYN;
	        if (workorderyn == "Y") {
	          meta.style = "background-color:rgb(234, 234, 234)";
	        }
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
	      dataIndex: 'BIGCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODEL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'LOTNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGGROUP',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKCENTERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKEMPLOYEE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'NCRIMPUTE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'NCRRESULT',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OLDNCRQTY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'NCRCOST',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'NCRPRICE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTTRANSNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTTRANSSEQ',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/prod/insp/ProdInsNonConfirmRegist.do' />"
	  });
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/insp/ProdInsNonConfirmRegist.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/prod/insp/ProdInsNonConfirmRegist.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/prod/insp/ProdInsNonConfirmRegist.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "전체선택/해제",
	    itemId: "btnChkd1"
	  });
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
	  //    items["btns.1"].push({
	  //      xtype: "button",
	  //      text: "제품 불러오기",
	  //      itemId: "btnSel1"
	  //    });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
      "#btnAdd1": {
        click: 'btnAdd1'
      }
    });
	  $.extend(items["btns.ctr.1"], {
	    "#btnChkd1": {
	      click: 'btnChk1Click'
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
	  //    $.extend(items["btns.ctr.1"], {
	  //      "#btnSel1": {
	  //        click: 'btnSel1'
	  //      }
	  //    });
	  $.extend(items["btns.ctr.1"], {
	    "#ProdInsNonConfirmList": {
	      itemclick: 'NcrSelectClick'
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

	    //      var sortorder = Ext.getStore(gridnms["store.1"]).count() + 1;
	    var sortorder = 0;
	    var listcount = Ext.getStore(gridnms["store.1"]).count();
	    for (var i = 0; i < listcount; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
	      var dummy = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	      var dummy_sort = dummy.data.RN * 1;
	      if (sortorder < dummy_sort) {
	        sortorder = dummy_sort;
	      }
	    }
	    sortorder++;

	    model.set("RN", sortorder);

	    //    model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);
	    model.set("ORGID", $("#searchOrgId").val());
	    model.set("COMPANYID", $("#searchCompanyId").val());
	    model.set("CREATIONDATE", "${searchVO.dateSys}");
	    model.set("WORKEMPLOYEENAME", "<%=loginVO.getName()%>");
	    model.set("WORKEMPLOYEE", "<%=loginVO.getId()%>");

	    
	    //    store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
	    var view = Ext.getCmp(gridnms['panel.1']).getView();
	    var startPoint = 0;

	    store.insert(startPoint, model);
	    
	    extAlert("제일 위에 LINE이 추가 되었습니다. 스크롤을 위로 올려 작업 해주세요.");
	  };
	
	var chkclick = 0;
	function btnChk1Click() {
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var checkTrue = 0,
	  checkFalse = 0;

	  if (chkclick == 0) {
	    chkclick = 1;
	  } else {
	    chkclick = 0;
	  }

	  for (i = 0; i < count1; i++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
	    var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	    var ncrresult = model1.data.NCRRESULT;

	    if (chkclick == 1) {
	      if (ncrresult == "A") { // 구분이 수리인 것만 체크
	        // 체크 상태로
	        model1.set("CHK", true);
	        checkFalse++;
	      }
	    } else {
	      model1.set("CHK", false);
	      checkTrue++;
	    }
	    //        if (checkTrue > 0) {
	    //          console.log("[전체선택/해제] 해제된 항목은 총 " + checkTrue + "건 입니다.");
	    //        }
	    //        if (checkFalse > 0) {
	    //          console.log("[전체선택/해제] 선택된 항목은 총 " + checkFalse + "건 입니다.");
	    //        }
	  }
	}

	function btnSav1(o, e) {
	  // 저장시 필수값 체크
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var header = [],
	  count = 0;

	  if (count1 > 0) {
	    for (i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
	      var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	      var itemcode = model1.data.ITEMCODE;
	      var ncrimpute = model1.data.NCRIMPUTE;
	      var ncrresult = model1.data.NCRRESULT;
	      var ncrqty = model1.data.NCRQTY;
	      var workemployee = model1.data.WORKEMPLOYEE;
	      var outtransno = model1.data.OUTTRANSNO;
	      var outtransseq = model1.data.OUTTRANSSEQ;

	      if (itemcode == "" || itemcode == undefined) {
	        header.push("품번/품명");
	        count++;
	      }

	      if (ncrimpute == "" || ncrimpute == undefined) {
	        header.push("불량유형");
	        count++;
	      }

	      if (ncrqty == "" || ncrqty == undefined) {
	        header.push("불량수량");
	        count++;
	      }

	      //        if (ncrresult == "" || ncrresult == undefined) {
	      //          header.push("처리구분");
	      //          count++;
	      //        }

	      if (workemployee == "" || workemployee == undefined) {
	        if (outtransno == "" || outtransno == undefined) {
	          if (outtransseq == "" || outtransseq == undefined) {
	            header.push("작업자");
	            count++;
	          }
	        }
	      }

	      if (count > 0) {
	        extAlert("[필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
	        return;
	      }
	    }
	  } else {
	    extAlert("[저장] 부적합품 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
	    return;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  } else {
	    Ext.getStore(gridnms["store.1"]).sync({
	      success: function (batch, options) {
	        extAlert(msgs.noti.save, gridnms["store.1"]);

	        fn_search();
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
	  var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0]

	    var model = Ext.getStore(gridnms['store.1']).getById(Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0].id);
	  var count = 0;

	  if (record === undefined) {
	    return;
	  }

	  if (count == 0) {
	    Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        store.remove(record);
	        Ext.getStore(gridnms["store.1"]).sync();
	        extAlert("정상적으로 삭제되었습니다.");
	      }
	    });
	  }
	};

	function setValues_detail() {
	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.2"] = "ProdInsNonConfirmDetailList";

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
	      name: 'RN',
	    }, {
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'number',
	      name: 'FMLID',
	    }, {
	      type: 'number',
	      name: 'ORDERNO',
	    }, {
	      type: 'number',
	      name: 'CHECKLISTID',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'WORKORDERID',
	    }, {
	      type: 'number',
	      name: 'WORKORDERSEQ',
	    }, {
	      type: 'string',
	      name: 'CHECKBIG',
	    }, {
	      type: 'string',
	      name: 'FMLTYPE',
	    }, {
	      type: 'number',
	      name: 'EMPLOYEESEQ',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'DRAWINGNO',
	    }, {
	      type: 'string',
	      name: 'FMLTYPENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKTYPENAME',
	    }, {
	      type: 'date',
	      name: 'CHECKDATE',
	      dateFormat: 'Y-m-d',
	    }, {
	      type: 'string',
	      name: 'CHECKSTARTTIME',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME',
	    }, {
	      type: 'string',
	      name: 'STANDARDSTARTTIME',
	    }, {
	      type: 'string',
	      name: 'STANDARDENDTIME',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    }, {
	      type: 'string',
	      name: 'EQUIPMENTCODE',
	    }, {
	      type: 'string',
	      name: 'EQUIPMENTNAME',
	    }, {
	      type: 'string',
	      name: 'EMPLOYEENAME',
	    }, {
	      type: 'string',
	      name: 'EMPLOYEENUMBER',
	    }, {
	      type: 'string',
	      name: 'ROUTINGID',
	    }, {
	      type: 'string',
	      name: 'KRNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKBIGNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKMIDDLENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSMALLNAME',
	    }, {
	      type: 'string',
	      name: 'SPECIALCHECKNAME',
	    }, {
	      type: 'string',
	      name: 'CHECKSTANDARD',
	    }, {
	      type: 'string',
	      name: 'STANDARDVALUE',
	    }, {
	      type: 'string',
	      name: 'CHECKCYCLENAME',
	    }, {
	      type: 'string',
	      name: 'CHECKCYCLE',
	    }, {
	      type: 'number',
	      name: 'MAXVALUE',
	    }, {
	      type: 'number',
	      name: 'MINVALUE',
	    }, {
	      type: 'number',
	      name: 'CHECKQTY',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT1',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT2',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT3',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT4',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT5',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT6',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT7',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT8',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT9',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT10',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT11',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT12',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT13',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT14',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT15',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT16',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT17',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT18',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT19',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT20',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT21',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT22',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT23',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT24',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT25',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT26',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT27',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT28',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT29',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT30',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT31',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT32',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT33',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT34',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT35',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT36',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT37',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT38',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT39',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT40',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT41',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT42',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT43',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT44',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT45',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT46',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT47',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT48',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT49',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT50',
	    }, {
	      type: 'string',
	      name: 'CHECK1',
	    }, {
	      type: 'string',
	      name: 'CHECK2',
	    }, {
	      type: 'string',
	      name: 'CHECK3',
	    }, {
	      type: 'string',
	      name: 'CHECK4',
	    }, {
	      type: 'string',
	      name: 'CHECK5',
	    }, {
	      type: 'string',
	      name: 'CHECK6',
	    }, {
	      type: 'string',
	      name: 'CHECK7',
	    }, {
	      type: 'string',
	      name: 'CHECK8',
	    }, {
	      type: 'string',
	      name: 'CHECK9',
	    }, {
	      type: 'string',
	      name: 'CHECK10',
	    }, {
	      type: 'string',
	      name: 'CHECK11',
	    }, {
	      type: 'string',
	      name: 'CHECK12',
	    }, {
	      type: 'string',
	      name: 'CHECK13',
	    }, {
	      type: 'string',
	      name: 'CHECK14',
	    }, {
	      type: 'string',
	      name: 'CHECK15',
	    }, {
	      type: 'string',
	      name: 'CHECK16',
	    }, {
	      type: 'string',
	      name: 'CHECK17',
	    }, {
	      type: 'string',
	      name: 'CHECK18',
	    }, {
	      type: 'string',
	      name: 'CHECK19',
	    }, {
	      type: 'string',
	      name: 'CHECK20',
	    }, {
	      type: 'string',
	      name: 'CHECK21',
	    }, {
	      type: 'string',
	      name: 'CHECK22',
	    }, {
	      type: 'string',
	      name: 'CHECK23',
	    }, {
	      type: 'string',
	      name: 'CHECK24',
	    }, {
	      type: 'string',
	      name: 'CHECK25',
	    }, {
	      type: 'string',
	      name: 'CHECK26',
	    }, {
	      type: 'string',
	      name: 'CHECK27',
	    }, {
	      type: 'string',
	      name: 'CHECK28',
	    }, {
	      type: 'string',
	      name: 'CHECK29',
	    }, {
	      type: 'string',
	      name: 'CHECK30',
	    }, {
	      type: 'string',
	      name: 'CHECK31',
	    }, {
	      type: 'string',
	      name: 'CHECK32',
	    }, {
	      type: 'string',
	      name: 'CHECK33',
	    }, {
	      type: 'string',
	      name: 'CHECK34',
	    }, {
	      type: 'string',
	      name: 'CHECK35',
	    }, {
	      type: 'string',
	      name: 'CHECK36',
	    }, {
	      type: 'string',
	      name: 'CHECK37',
	    }, {
	      type: 'string',
	      name: 'CHECK38',
	    }, {
	      type: 'string',
	      name: 'CHECK39',
	    }, {
	      type: 'string',
	      name: 'CHECK40',
	    }, {
	      type: 'string',
	      name: 'CHECK41',
	    }, {
	      type: 'string',
	      name: 'CHECK42',
	    }, {
	      type: 'string',
	      name: 'CHECK43',
	    }, {
	      type: 'string',
	      name: 'CHECK44',
	    }, {
	      type: 'string',
	      name: 'CHECK45',
	    }, {
	      type: 'string',
	      name: 'CHECK46',
	    }, {
	      type: 'string',
	      name: 'CHECK47',
	    }, {
	      type: 'string',
	      name: 'CHECK48',
	    }, {
	      type: 'string',
	      name: 'CHECK49',
	    }, {
	      type: 'string',
	      name: 'CHECK50',
	    }, {
	      type: 'number',
	      name: 'TOTALQTY',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME1',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME2',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME3',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME4',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME5',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME6',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME7',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME8',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME9',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME10',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME11',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME12',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME13',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME14',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME15',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME16',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME17',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME18',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME19',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME20',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME21',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME22',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME23',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME24',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME25',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME26',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME27',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME28',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME29',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME30',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME31',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME32',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME33',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME34',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME35',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME36',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME37',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME38',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME39',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME40',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME41',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME42',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME43',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME44',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME45',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME46',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME47',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME48',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME49',
	    }, {
	      type: 'string',
	      name: 'CHECKTIME50',
	    }, {
	      type: 'string',
	      name: 'CHECKYN',
	    }, {
	      type: 'string',
	      name: 'INSPECTIONYN',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULT',
	    }, {
	      type: 'string',
	      name: 'TOTALRESULT',
	    }, {
	      type: 'string',
	      name: 'CHECKRESULTM',
	    }, {
	      type: 'string',
	      name: 'MANAGEEMPLOYEENAME',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, ];

	  fields["columns.2"] = [
	    // Display Columns
	    {
	      dataIndex: 'RN',
	      text: '순번',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: "0,000",
	    }, {
	      dataIndex: 'CHECKDATE',
	      text: '검사일자',
	      xtype: 'datecolumn',
	      width: 85,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'CHECKSTARTTIME',
	      text: '검사시작<br/>시간',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKTIME',
	      text: '검사종료<br/>시간',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      //      }, {
	      //        dataIndex: 'ORDERNAME',
	      //        text: '품번',
	      //        xtype: 'gridcolumn',
	      //        width: 130,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	      //      }, {
	      //        dataIndex: 'ITEMNAME',
	      //        text: '품명',
	      //        xtype: 'gridcolumn',
	      //        width: 280,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "left",
	      //      }, {
	      //        dataIndex: 'DRAWINGNO',
	      //        text: '도번',
	      //        xtype: 'gridcolumn',
	      //        width: 200,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "left",
	      //      }, {
	      //        dataIndex: 'EQUIPMENTNAME',
	      //        text: '설비',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	      //      }, {
	      //        dataIndex: 'ROUTINGNAME',
	      //        text: '공정명',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	    }, {
	      dataIndex: 'TOTALRESULT',
	      text: '판정',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'KRNAME',
	      text: '검사자',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKSMALLNAME',
	      text: '검사항목',
	      xtype: 'gridcolumn',
	      width: 145,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'CHECKSTANDARD',
	      text: '검사내용',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'CHECKCYCLENAME',
	      text: '검사주기',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'STANDARDVALUE',
	      text: '기준',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'MINVALUE',
	      text: '하한',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000.00",
	      renderer: Ext.util.Format.numberRenderer('0,000.00'),
	    }, {
	      dataIndex: 'MAXVALUE',
	      text: '상한',
	      xtype: 'gridcolumn',
	      width: 60,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000.00",
	      renderer: Ext.util.Format.numberRenderer('0,000.00'),
	    }, {
	      dataIndex: 'CHECK1',
	      text: 'X1',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 0 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK2',
	      text: 'X2',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 1 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK3',
	      text: 'X3',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 2 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK4',
	      text: 'X4',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 3 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK5',
	      text: 'X5',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 4 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK6',
	      text: 'X6',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 5 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK7',
	      text: 'X7',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 6 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK8',
	      text: 'X8',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 7 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK9',
	      text: 'X9',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 8 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK10',
	      text: 'X10',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 9 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK11',
	      text: 'X11',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 10 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK12',
	      text: 'X12',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 11 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK13',
	      text: 'X13',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 12 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK14',
	      text: 'X14',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 13 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK15',
	      text: 'X15',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 14 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK16',
	      text: 'X16',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 15 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK17',
	      text: 'X17',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 16 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK18',
	      text: 'X18',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 17 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK19',
	      text: 'X19',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 18 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK20',
	      text: 'X20',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 19 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK21',
	      text: 'X21',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 20 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK22',
	      text: 'X22',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 21 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK23',
	      text: 'X23',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 22 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK24',
	      text: 'X24',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 23 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK25',
	      text: 'X25',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 24 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK26',
	      text: 'X26',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 25 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK27',
	      text: 'X27',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 26 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK28',
	      text: 'X28',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 27 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK29',
	      text: 'X29',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 28 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK30',
	      text: 'X30',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 29 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK31',
	      text: 'X31',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 30 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK32',
	      text: 'X32',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 31 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK33',
	      text: 'X33',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 32 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK34',
	      text: 'X34',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 33 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK35',
	      text: 'X35',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 34 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK36',
	      text: 'X36',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 35 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK37',
	      text: 'X37',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 36 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK38',
	      text: 'X38',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 37 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK39',
	      text: 'X39',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 38 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK40',
	      text: 'X40',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 39 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK41',
	      text: 'X41',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 40 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK42',
	      text: 'X42',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 41 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK43',
	      text: 'X43',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 42 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK44',
	      text: 'X44',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 43 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK45',
	      text: 'X45',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 44 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK46',
	      text: 'X46',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 45 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK47',
	      text: 'X47',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 46 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK48',
	      text: 'X48',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 47 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK49',
	      text: 'X49',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 48 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECK50',
	      text: 'X50',
	      xtype: 'gridcolumn',
	      width: 70,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style = " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        // 1. 시료수 범위 체크
	        if (checkqty > 49 && checkqty <= 50) {
	          qty_check = true;
	        } else {
	          qty_check = false;
	        }

	        if (qty_check == false) {
	          meta.style = " border-color: #5B9BD5;";
	          meta.style += " border-left-style: solid;";
	          meta.style += " border-left-width: 1px;";
	        } else {
	          if (value == "NG" || value == "OK") {
	            if (value == "NG") {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          } else {
	            var num = value * 1;

	            if (min > num) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              if (num > max) {
	                meta.style += " color:rgb(255, 0, 0);";
	                return value;
	              } else {
	                meta.style += "color:rgb(0, 0, 255);";
	                return value;
	              }
	            }
	          }
	        }
	      },
	    }, {
	      dataIndex: 'CHECKRESULT',
	      text: '결과',
	      xtype: 'gridcolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        meta.style += " border-color: #5B9BD5;";
	        meta.style += " border-left-style: solid;";
	        meta.style += " border-left-width: 1px;";
	        var max = record.data.MAXVALUE * 1;
	        var min = record.data.MINVALUE * 1;
	        var checkqty = record.data.CHECKQTY;
	        var qty_check = false;

	        if (value == "NG" || value == "OK") {
	          if (value == "NG") {
	            meta.style += " color:rgb(255, 0, 0);";
	            return value;
	          } else {
	            meta.style += "color:rgb(0, 0, 255);";
	            return value;
	          }
	        } else {
	          var num = value * 1;

	          if (min > num) {
	            meta.style += " color:rgb(255, 0, 0);";
	            return value;
	          } else {
	            if (num > max) {
	              meta.style += " color:rgb(255, 0, 0);";
	              return value;
	            } else {
	              meta.style += "color:rgb(0, 0, 255);";
	              return value;
	            }
	          }
	        }
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
	      dataIndex: 'FMLID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'FMLTYPENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORDERNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKLISTID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTYPENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKMIDDLENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'SPECIALCHECKNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKQTY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'INSPECTIONYN',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKRESULTM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EMPLOYEENUMBER',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MANAGEEMPLOYEENAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'STANDARDSTARTTIME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'STANDARDENDTIME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKCYCLE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'WORKORDERSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EQUIPMENTCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKBIG',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'FMLTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'EMPLOYEESEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'REMARKS',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME1',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME2',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME3',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME4',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME5',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME6',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME7',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME8',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME9',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME10',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME11',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME12',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME13',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME14',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME15',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME16',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME17',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME18',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME19',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME20',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME21',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME22',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME23',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME24',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME25',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME26',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME27',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME28',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME29',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME30',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME31',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME32',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME33',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME34',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME35',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME36',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME37',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME38',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME39',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME40',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME41',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME42',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME43',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME44',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME45',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME46',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME47',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME48',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME49',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CHECKTIME50',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'TOTALQTY',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.2"] = {};
	  $.extend(items["api.2"], {
	    read: "<c:url value='/select/prod/insp/ProdInsNonConfirmDetailRegist.do' />"
	  });

	  items["btns.2"] = [];
	  items["btns.2"].push({
	    xtype: "button",
	    text: "전체선택/해제",
	    itemId: "btnChkd1"
	  });

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
	  // items["docked.2"].push(items["dock.btn.2"]);
	}

	var popcount = 0, popupclick = 0;
	function btnSel1(btn) {
	  // 제품 불러오기 팝업
	  var width = 1208; // 가로
	  var height = 640; // 세로
	  var title = "제품불러오기 Pop up";

	  var check = true;
	  popupclick = 0;

	  if (check == true) {
	    // 완료 외 상태에서만 팝업 표시하도록 처리
	    $('#popupOrgId').val($('#searchOrgId option:selected').val());
	    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	    $('#popupItemName').val("");
	    $('#popupOrderName').val("");
	    Ext.getStore(gridnms["store.12"]).removeAll();

	    win2 = Ext.create('Ext.window.Window', {
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
	            itemId: gridnms["panel.12"],
	            id: gridnms["panel.12"],
	            store: gridnms["store.12"],
	            height: '100%',
	            border: 2,
	            scrollable: true,
	            frameHeader: true,
	            columns: fields["columns.12"],
	            viewConfig: {
	              itemId: 'ProdPopup',
	              trackOver: true,
	              loadMask: true,
	            },
	            plugins: [{
	                ptype: 'bufferedrenderer',
	                trailingBufferZone: 20, // #1
	                leadingBufferZone: 20, // #2
	                synchronousRender: false,
	                numFromEdge: 19,
	              }
	            ],
	            dockedItems: items["docked.12"],
	          }
	        ],
	        tbar: [
	          '품번', {
	            xtype: 'textfield',
	            name: 'searchOrderName1',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 150,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                $('#popupOrderName').val(result);
	              },
	            },
	          },
	          '품명', {
	            xtype: 'textfield',
	            name: 'searchItemName1',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 250,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                $('#popupItemName').val(result);
	              },
	            },
	          },
	          '->', {
	            text: '조회',
	            scope: this,
	            handler: function () {
	              var sparams3 = {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                GROUPCODE: $('#searchGroupCode').val(),
	                ITEMNAME: $('#popupItemName').val(),
	                ORDERNAME: $('#popupOrderName').val(),
	              };

	              extGridSearch(sparams3, gridnms["store.12"]);
	            }
	          }, {
	            text: '전체선택/해제',
	            scope: this,
	            handler: function () {
	              // 전체등록 Pop up 전체선택 버튼 핸들러
	              var count4 = Ext.getStore(gridnms["store.12"]).count();
	              var checkTrue = 0,
	              checkFalse = 0;

	              if (popupclick == 0) {
	                popupclick = 1;
	              } else {
	                popupclick = 0;
	              }
	              for (var i = 0; i < count4; i++) {
	                Ext.getStore(gridnms["store.12"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(i));
	                var model4 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];

	                var chk = model4.data.CHK;

	                if (popupclick == 1) {
	                  // 체크 상태로
	                  model4.set("CHK", true);
	                  checkFalse++;
	                } else {
	                  model4.set("CHK", false);
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
	              var count = Ext.getStore(gridnms["store.2"]).count();
	              var count4 = Ext.getStore(gridnms["store.12"]).count();
	              var checknum = 0,
	              checkqty = 0,
	              checktemp = 0;
	              var qtytemp = [];

	              for (var i = 0; i < count4; i++) {
	                Ext.getStore(gridnms["store.12"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(i));
	                var model4 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
	                var chk = model4.get("CHK");

	                if (chk == true) {
	                  checknum++;
	                }
	              }
	              console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	              if (checknum == 0) {
	                extAlert("제품을 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
	                return false;
	              }

	              if (count4 == 0) {
	                console.log("[적용] 제품 정보가 없습니다.");
	              } else {
	                for (var j = 0; j < count4; j++) {
	                  Ext.getStore(gridnms["store.12"]).getById(Ext.getCmp(gridnms["views.popup2"]).getSelectionModel().select(j));
	                  var model4 = Ext.getCmp(gridnms["views.popup2"]).selModel.getSelection()[0];
	                  var chk = model4.data.CHK;

	                  if (chk === true) {
	                    var model = Ext.create(gridnms["model.1"]);
	                    var store = Ext.getStore(gridnms["store.1"]);

	                    // 순번
	                    model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);

	                    // 팝업창의 체크된 항목 이동
	                    model.set("ITEMCODE", model4.data.ITEMCODE);
	                    model.set("ITEMNAME", model4.data.ITEMNAME);
	                    model.set("ORDERNAME", model4.data.ORDERNAME);
	                    model.set("UOM", model4.data.UOM);
	                    model.set("UOMNAME", model4.data.UOMNAME);
	                    model.set("ROUTINGGROUP", model4.data.ROUTINGGROUP);

	                    var today = Ext.util.Format.date("${searchVO.dateSys}", 'Y-m-d');
	                    model.set("CREATIONDATE", today);

	                    var orgid = $('#searchOrgId').val();
	                    var companyid = $('#searchCompanyId').val();

	                    model.set("ORGID", orgid);
	                    model.set("COMPANYID", companyid);

	                    // 그리드 적용 방식
	                    store.add(model);

	                    checktemp++;
	                    popcount++;
	                  };
	                }

	                Ext.getCmp(gridnms["panel.1"]).getView().refresh();

	              }

	              if (checktemp > 0) {
	                popcount = 0;
	                win2.close();

	                $("#gridPopup2Area").hide("blind", {
	                  direction: "up"
	                }, "fast");
	              }
	            }
	          }
	        ]
	      });

	    win2.show();

	  } else {
	    extAlert("부적합품 등록 하실 경우에만 제품 불러오기가 가능합니다.");
	    return;
	  }
	}

	function NcrSelectClick(dataview, record, item, index, e, eOpts) {
	  var orgid = record.data.ORGID;
	  var companyid = record.data.COMPANYID;
	  var workorderid = record.data.WORKORDERID;
	  var workorderseq = record.data.WORKORDERSEQ;
	  var employeeseq = record.data.EMPLOYEESEQ;
	  var routinggroup = record.data.ROUTINGGROUP;
	  var workcentercode = record.data.WORKCENTERCODE;

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    WORKORDERID: workorderid,
	    WORKORDERSEQ: workorderseq,
	    EMPLOYEESEQ: employeeseq,
	    MASTERCLICK: "Y",
	  };

	  extGridSearch(sparams, gridnms["store.2"]);

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    BIGCD: 'MFG',
	    MIDDLECD: 'FAULT_TYPE',
	    GUBUN: 'FAULT_TYPE',
	    keyword: routinggroup,
	  };

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.6"]);
	  }, 300);

	  var sparams2 = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    WORKCENTERCODE: workcentercode,
	  };

	  setTimeout(function () {
	    extGridSearch(sparams2, gridnms["store.8"]);
	  }, 500);
	}

	function setValues_popup2() {
	  gridnms["models.popup2"] = [];
	  gridnms["stores.popup2"] = [];
	  gridnms["views.popup2"] = [];
	  gridnms["controllers.popup2"] = [];

	  gridnms["grid.12"] = "ProdPopup";

	  gridnms["panel.12"] = gridnms["app"] + ".view." + gridnms["grid.12"];
	  gridnms["views.popup2"].push(gridnms["panel.12"]);

	  gridnms["controller.12"] = gridnms["app"] + ".controller." + gridnms["grid.12"];
	  gridnms["controllers.popup2"].push(gridnms["controller.12"]);

	  gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];

	  gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];

	  gridnms["models.popup2"].push(gridnms["model.12"]);

	  gridnms["stores.popup2"].push(gridnms["store.12"]);

	  fields["model.12"] = [{
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'number',
	      name: 'RN',
	    }, {
	      type: 'string',
	      name: 'ITEMTYPE',
	    }, {
	      type: 'string',
	      name: 'ITEMTYPENAME',
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
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'string',
	      name: 'ROUTINGGROUP',
	    }, ];

	  fields["columns.12"] = [
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
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'MODELNAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ORDERNAME',
	      text: '품번',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 235,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
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
	    }, {
	      dataIndex: 'CHK',
	      text: '',
	      xtype: 'checkcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPENAME',
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
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ROUTINGGROUP',
	      xtype: 'hidden',
	    }, ];

	  items["api.12"] = {};
	  $.extend(items["api.12"], {
	    read: "<c:url value='/searchItemCodeOrderLov.do' />"
	  });

	  items["btns.12"] = [];

	  items["btns.ctr.12"] = {};

	  items["dock.paging.12"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.12"],
	  };

	  items["dock.btn.12"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.12"],
	    items: items["btns.12"],
	  };

	  items["docked.12"] = [];
	}

	var gridarea, griddetailarea;
	function setExtGrid() {
	  setExtGrid_list();
	  setExtGrid_detail();
	  setExtGrid_popup2(); // 제품 불러오기

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	    griddetailarea.updateLayout();
	  });
	}

	function setExtGrid_list() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
	  });

	  Ext.define(gridnms["model.6"], {
	    extend: Ext.data.Model,
	    fields: fields["model.6"],
	  });

	  Ext.define(gridnms["model.7"], {
	    extend: Ext.data.Model,
	    fields: fields["model.7"],
	  });

	  Ext.define(gridnms["model.8"], {
	    extend: Ext.data.Model,
	    fields: fields["model.8"],
	  });
	  
	  Ext.define(gridnms["model.11"], {
	      extend: Ext.data.Model,
	      fields: fields["model.11"],
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
	                NCRFROM: $('#searchNcrFrom').val(),
	                NCRTO: $('#searchNcrTo').val(),
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
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
	              type: "ajax",
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'MFG',
	                MIDDLECD: 'FAULT_TYPE',
	                GUBUN: 'FAULT_TYPE',
	                keyword: '%',
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
	              type: "ajax",
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                BIGCD: 'QM',
	                MIDDLECD: 'NCR_RESULT',
	                //                   GUBUN: 'NCR_RESULT',
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
	              type: "ajax",
	              url: "<c:url value='/searchAllEmployeeLov.do' />",
	              timeout: gridVals.timeout,
	              extraParams: {
	            	
	              },
	              reader: gridVals.reader,
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
	                url: "/FNC/searchItemNameLov.do",
	                extraParams: {
	                  ORGID: $("#searchOrgId").val(),
	                  COMPANYID: $("#searchCompanyId").val(),
	                  GUBUN: 'A',
	                  //                  ROUTING_BOM_GUBUN : 'Y' ,
	                },
	                reader: gridVals.reader,
	              }
	            }, cfg)]);
	      },
	    });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      ProdInsNonConfirmList: '#ProdInsNonConfirmList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],
	    btnChk1Click: btnChk1Click,
	    btnAdd1: btnAdd1,
	    btnSav1: btnSav1,
	    btnDel1: btnDel1,
	    btnSel1: btnSel1,
	    NcrSelectClick: NcrSelectClick,
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
	          height: 250,
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
	            itemId: 'ProdInsNonConfirmList',
	            trackOver: true,
	            loadMask: true,
	            striptRows: true,
	            forceFit: true,
	            listeners: {
	              refresh: function (dataView) {
	                Ext.each(dataView.panel.columns, function (column) {
	                  if (column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('EQUIPMENTNAME') >= 0) {
	                    column.autoSize();
	                    column.width += 5;
	                    if (column.width < 80) {
	                      column.width = 80;
	                    }
	                  }

	                  if (column.dataIndex.indexOf('CARTYPENAME') >= 0) {
	                    column.autoSize();
	                    column.width += 5;
	                    if (column.width < 80) {
	                      column.width = 80;
	                    }
	                  }

	                  if (column.dataIndex.indexOf('ITEMNAME') >= 0 ) {
	                      column.autoSize();
	                      column.width += 5;
	                      if (column.width < 220) {
	                        column.width = 220;
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

	                  editDisableCols.push("CREATIONDATE");

	                  var workorderyn = data.data.WORKORDERYN;
	                  var ncrNo = data.data.NCRNO;
	                  if (workorderyn == "Y") {
	                    editDisableCols.push("WORKEMPLOYEENAME");
	                    editDisableCols.push("NCRIMPUTENAME");
	                    editDisableCols.push("NCRQTY");
	                    editDisableCols.push("NCRRESULTNAME");
	                    editDisableCols.push("REMARKS");
	                  }
	                  
	                  if(ncrNo != ""){
	                	  editDisableCols.push("ITEMNAME");
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
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                NCRFROM: $('#searchNcrFrom').val(),
	                NCRTO: $('#searchNcrTo').val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.2"], {
	    extend: Ext.app.Controller,
	    refs: {
	      ProdInsNonConfirmDetailList: '#ProdInsNonConfirmDetailList',
	    },
	    stores: [gridnms["store.2"]],
	    control: items["btns.ctr.2"],

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
	        height: 354,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.2"],
	        plugins: [{
	            ptype: 'bufferedrenderer',
	            trailingBufferZone: 20,
	            leadingBufferZone: 20,
	            synchronousRender: false,
	            numFromEdge: 19,
	          }
	        ],
	        viewConfig: {
	          itemId: 'ProdInsNonConfirmDetailList',
	          trackOver: true,
	          loadMask: true,
	          striptRows: true,
	          forceFit: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (/*column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('EQUIPMENTNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0 ||*/ column.dataIndex.indexOf('CHECKSMALLNAME') >= 0 || column.dataIndex.indexOf('CHECKSTANDARD') >= 0) {
	                  column.autoSize();
	                  column.width += 5;
	                  if (column.width < 110) {
	                    column.width = 110;
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
	      griddetailarea = Ext.create(gridnms["views.detail"], {
	          renderTo: 'gridDetailArea'
	        });
	    },
	  });
	}

	function setExtGrid_popup2() {
	  Ext.define(gridnms["model.12"], {
	    extend: Ext.data.Model,
	    fields: fields["model.12"],
	  });
	  Ext.define(gridnms["model.13"], {
	    extend: Ext.data.Model,
	    fields: fields["model.13"],
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
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.12"],
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
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
	              url: "<c:url value='/searchBigClassListLov.do' />",
	              extraParams: {
	                ORGID: $("#searchOrgId").val(),
	                COMPANYID: $("#searchCompanyId").val(),
	                GROUPCODE: $('#searchGroupCode').val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.12"], {
	    extend: Ext.app.Controller,
	    refs: {
	      ProdPopup: '#ProdPopup',
	    },
	    stores: [gridnms["store.12"]],
	  });

	  Ext.define(gridnms["panel.12"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.12"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.12"],
	        id: gridnms["panel.12"],
	        store: gridnms["store.12"],
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
	        columns: fields["columns.12"],
	        viewConfig: {
	          itemId: 'ProdPopup',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.12"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup2"],
	    stores: gridnms["stores.popup2"],
	    views: gridnms["views.popup2"],
	    controllers: gridnms["controller.12"],

	    launch: function () {
	      gridarea4 = Ext.create(gridnms["views.popup2"], {
	          renderTo: 'gridPopup2Area'
	        });
	    },
	  });
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var ncrfrom = $('#searchNcrFrom').val();
	  var ncrto = $('#searchNcrTo').val();
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

	  if (ncrfrom == "") {
	    header.push("등록일From");
	    count++;
	  }

	  if (ncrto == "") {
	    header.push("등록일To");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    result = false;
	  }

	  return result;
	}

	function fn_validation1() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var printmonth = $('#searchPrintMonth').val();
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

	  if (printmonth == "") {
	    header.push("출력년월");
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
	  var ncrfrom = $('#searchNcrFrom').val();
	  var ncrto = $('#searchNcrTo').val();
	  var ncrno = $('#searchNcrNo').val();
	  var itemcode = $('#searchItemCode').val();
	  var ordername = $('#searchOrderName').val();
	  var itemname = $('#searchItemName').val();
	  var modelname = $('#searchModelName').val();
	  var ncrresult = $('#searchNcrResult option:selected').val();
	  var faulttype = $('#searchFaultType').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    NCRFROM: ncrfrom,
	    NCRTO: ncrto,
	    NCRNO: ncrno,
	    ITEMCODE: itemcode,
	    ORDERNAME: ordername,
	    ITEMNAME: itemname,
	    MODELNAME: modelname,
	    NCRRESULT: ncrresult,
	    FAULTTYPE: faulttype,
	  };

	  extGridSearch(sparams, gridnms["store.1"]);

	  setTimeout(function () {
	    extGridSearch(sparams, gridnms["store.2"]);
	  }, 200);
	}

	function fn_excel_download() {
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var ncrfrom = $('#searchNcrFrom').val();
	  var ncrto = $('#searchNcrTo').val();
	  var ncrno = $('#searchNcrNo').val();
	  var itemcode = $('#searchItemCode').val();
	  var ordername = $('#searchOrderName').val();
	  var itemname = $('#searchItemName').val();
	  var modelname = $('#searchModelName').val();
	  var ncrresult = $('#searchNcrResult option:selected').val();
	  var faulttype = $('#searchFaultType').val();

	  go_url("<c:url value='/prod/insp/ExcelDownload.do?GUBUN='/>" + "NONCONFIRM"
	     + "&ORGID=" + orgid + ""
	     + "&COMPANYID=" + companyid + ""
	     + "&NCRFROM=" + ncrfrom + ""
	     + "&NCRTO=" + ncrto + ""
	     + "&NCRNO=" + ncrno + ""
	     + "&ITEMCODE=" + itemcode + ""
	     + "&ORDERNAME=" + ordername + ""
	     + "&ITEMNAME=" + itemname + ""
	     + "&MODELNAME=" + modelname + ""
	     + "&NCRRESULT=" + ncrresult + ""
	     + "&FAULTTYPE=" + faulttype + "");
	}

	function fn_print(flag) {
	  if (!fn_validation1()) {
	    return;
	  }

	  var url = "",
	  msg = "";
	  var column = 'master';
	  var target = '_blank';
	  switch (flag) {
	  case "1":
	    url = "<c:url value='/report/FaultTypeReport.pdf'/>";

	    fn_popup_url(column, url, target);

	    break;
	  case "2":
	    url = "<c:url value='/report/RoutingGroupReport.pdf'/>";

	    fn_popup_url(column, url, target);

	    break;
	  default:
	    break;
	  }
	}

	function fn_rework_create() {
	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var count = 0;
	  var msg_title = "작업지시 재생성";

	  if (count1 > 0) {
	    for (i = 0; i < count1; i++) {
	      Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
	      var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	      var chk = model1.data.CHK;

	      if (chk) {
	        count++;
	      }
	    }
	  } else {
	    extAlert("[" + msg_title + "] 부적합품 데이터가 없습니다.<br/>다시 한번 확인해주세요.");
	    return;
	  }

	  if (count == 0) {
	    extAlert("[" + msg_title + "]<br/> " + msg_title + " 하실 항목을 선택해주세요.");
	    return;
	  } else {

	    Ext.MessageBox.confirm(msg_title, msg_title + ' 처리를 하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        var url = "";
	        url = "<c:url value='/call/prod/insp/ReWorkOrderCreate.do' />";

	        Ext.getStore(gridnms["store.1"]).sync({
	          success: function (batch, options) {

	            $.ajax({
	              url: url,
	              type: "post",
	              dataType: "json",
	              data: "",
	              success: function (data) {
	                var success = data.success;
	                var msgdata = data.RETURNSTATUS;

	                if (success == false) {
	                  extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
	                  return;
	                } else {
	                  extAlert("[" + msg_title + "]<br/>" + "선택하신 항목이 " + msgs.noti.recreate, gridnms["store.1"]);

	                  fn_search();
	                }
	              },
	              error: ajaxError
	            });

	          },
	          failure: function (batch, options) {
	            extAlert(batch.exceptions[0].error, gridnms["store.1"]);
	          },
	          callback: function (batch, options) {},
	        });

	        return;
	      } else {
	        Ext.Msg.alert(msg_title + ' 취소', msg_title + ' 취소 처리가 취소되었습니다.');
	        return;
	      }
	    });
	  }
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 부적합품번호 Lov
	  $("#searchNcrNo").bind("keydown", function (e) {
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
	      $.getJSON("<c:url value='/prod/insp/searchNcrNoLov.do' />", {
	        keyword: extractLast(request.term),
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
	        SEARCHFROM: $('#searchNcrFrom').val(),
	        SEARCHTO: $('#searchNcrTo').val(),
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.NCRNO,
	              label: m.NCRNO,
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
	      $("#searchNcrNo").val(o.item.value);

	      return false;
	    }
	  });

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
	  //          GUBUN: 'ORDERNAME', // 제품, 반제품 조회
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
	  //        $("#searchItemCode").val(o.item.value);
	  //        $("#searchItemName").val(o.item.ITEMNAME);
	  //        $("#searchOrderName").val(o.item.ORDERNAME);
	  //        $("#searchModel").val(o.item.MODEL);
	  //        $("#searchModelName").val(o.item.MODELNAME);

	  //        return false;
	  //      }
	  //    });

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
	  //          GUBUN: 'ITEMNAME', // 제품, 반제품 조회
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
	  //        $("#searchItemCode").val(o.item.value);
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
                                <li>품질관리</li>
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
                        <input type="hidden" id="searchGroupCode" name="searchGroupCode" value="A" />
                        <input type="hidden" id="popupOrgId" name="popupOrgId" />
                        <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                        <input type="hidden" id="popupItemName" name="popupItemName" />
                        <input type="hidden" id="popupOrderName" name="popupOrderName" />
                        <input type="hidden" id="orgid" value="<c:out value='${OrgIdVal}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${CompanyIdVal}'/>" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
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
                                                <a id="btnChk2" class="btn_download" href="#" onclick="javascript:fn_excel_download();">
                                                   엑셀
                                                </a>
                                                <!-- <a id="btnChk3" class="btn_print" href="#" onclick="javascript:fn_print('1');">
                                                   불량유형현황
                                                </a>
                                                <a id="btnChk4" class="btn_print" href="#" onclick="javascript:fn_print('2');">
                                                   공정유형현황
                                                </a> -->
                                                <a id="btnChk5" class="btn_create" href="#" onclick="javascript:fn_rework_create();">
                                                   작업지시 재생성
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
                                        <th class="required_text">등록일</th>
                                        <td >
                                            <input type="text" id="searchNcrFrom" name="searchNcrFrom" class="input_validation input_center validate[custom[date],past[#searchNcrTo]]" style="width: 90px; " maxlength="10" />
                                            &nbsp;~&nbsp;
                                            <input type="text" id="searchNcrTo" name="searchNcrTo" class="input_validation input_center validate[custom[date],future[#searchNcrFrom]]" style="width: 90px; " maxlength="10"  />
                                        </td>
                                        <th class="required_text">부적합품번호</th>
                                        <td>
                                            <input type="text" id="searchNcrNo" name="searchNcrNo" class="input_left"  style="width: 97%;" />
                                        </td>
                                        <th class="required_text">처리구분</th>
                                        <td>
                                            <select id="searchNcrResult" name="searchNcrResult" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.NCRRESULT}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByNcrResult}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.NCRRESULT}">
                                                            <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <option value="${item.VALUE}">${item.LABEL}</option>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </c:forEach>
                                            </select>
                                        </td>
                                        <th class="required_text">불량유형</th>
                                        <td>
                                            <select id="searchFaultType" name="searchFaultType" class="input_left validate[required]" style="width: 97%;">
                                                <c:if test="${empty searchVO.FAULTTYPE}">
                                                    <option value="" label="전체" />
                                                </c:if>
                                                <c:forEach var="item" items="${labelBox.findByFaultType}" varStatus="status">
                                                    <c:choose>
                                                        <c:when test="${item.VALUE==searchVO.FAULTTYPE}">
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
                                            <input type="text" id="searchOrderName" name="searchOrderName" class="input_left"  style="width: 97%;" />
                                        </td>                               
                                        <th class="required_text">품명</th>
                                        <td >
                                            <input type="text" id="searchItemName" name="searchItemName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;"/>
                                        </td>
			                                  <th class="required_text">기종</th>
			                                  <td >
			                                      <input type="text" id="searchModelName" name="searchModelName"  class="input_left" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" />
			                                  </td>
			                                  <td></td>
			                                  <td></td>
                                        <!-- <th class="required_text">출력년월</th>
                                        <td >
                                            <input type="text" id="searchPrintMonth" name="searchPrintMonth" class="input_validation input_center" style="width: 90px; " maxlength="7" />
                                        </td> -->
                                    </tr>
                                </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->
		                <div style="width: 100%;">
		                    <table style="width: 100%;">
		                        <tr>
		                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 0px;">기본 정보</div></td>
		                        </tr>
		                    </table>
		                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
		                    <table style="width: 100%;">
		                        <tr>
		                            <td style="width: 100%;"><div class="subConTit3" style="margin-top: 10px;">상세 정보</div></td>
		                        </tr>
		                    </table>
		                    <div id="gridDetailArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
		                </div>
            </div>
            <!-- //content 끝 -->
        <div id="gridPopup2Area" style="width: 1200px; padding-top: 0px; float: left;"></div>
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