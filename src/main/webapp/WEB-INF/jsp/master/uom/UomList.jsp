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
	  setValues();
	  setExtGrid();

	  setReadOnly();

	  setLovList();
	});

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.uom"] = [];
	  gridnms["stores.uom"] = [];
	  gridnms["views.uom"] = [];
	  gridnms["controllers.uom"] = [];

	  gridnms["app"] = "base";
	  gridnms["grid.1"] = "UOMGrid";
	    gridnms["grid.5"] = "UOMLov";
	    gridnms["grid.11"] = "itemLov";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.uom"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.uom"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	    gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
	    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	    gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
	    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];

	  gridnms["models.uom"].push(gridnms["model.1"]);
	  gridnms["models.uom"].push(gridnms["model.5"]);
    gridnms["models.uom"].push(gridnms["model.11"]);

    gridnms["stores.uom"].push(gridnms["store.1"]);
	  gridnms["stores.uom"].push(gridnms["store.5"]);
    gridnms["stores.uom"].push(gridnms["store.11"]);

	  fields["model.1"] = [{
      type: 'number',
      name: 'RNUM'
    }, {
      type: 'string',
      name: 'ORGID'
    }, {
      type: 'string',
      name: 'COMPANYID'
    }, {
      type: 'string',
      name: 'STDUOM'
    }, {
      type: 'string',
      name: 'STDUOMNAME'
    }, {
      type: 'string',
      name: 'CONUOM'
    }, {
      type: 'string',
      name: 'CONUOMNAME'
    }, {
      type: 'string',
      name: 'ITEMCODE'
    }, {
      type: 'string',
      name: 'ITEMNAME'
    }, {
      type: 'string',
      name: 'ORDERNAME'
    }, {
        type: 'string',
        name: 'MODEL'
    }, {
        type: 'string',
        name: 'MODELNAME'
    }, {
        type: 'string',
        name: 'CUSTOMERGUBUN'
    }, {
        type: 'string',
        name: 'CUSTOMERGUBUNNAME'
    }, {
        type: 'number',
        name: 'STDFORMULA'
    }, {
        type: 'number',
        name: 'CONFORMULA'
    }, {
      type: 'string',
      name: 'REMARKS'
    }, {
      type: 'string',
      name: 'CREATIONDATE'
    },  {
      type: 'date',
      name: 'CREATIONDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'LASTUPDATEDBY'
    }, {
      type: 'date',
      name: 'UPDATEDT',
      dateFormat: 'Y-m-d',
    } ];

	  fields["model.5"] = [{
      type: 'string',
      name: 'VALUE', // 코드
    }, {
      type: 'string',
      name: 'LABEL', // 코드명
    }, ];

	    fields["model.11"] = [{
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
	        name: 'UOM',
	      }, ];

	
	   
	  fields["columns.1"] = [
    // Display Columns
    {
      dataIndex: 'RNUM',
      text: '순번',
      xtype: 'rownumberer',
      width: 45,
      hidden: false,
      sortable: false,
      resizable: false,
      align: "center"
    }, {
        dataIndex: 'ITEMCODE',
        text: '품목',
        xtype: 'gridcolumn',
        width: 120,
        hidden: false,
        sortable: false,
        align: "center",
        editor: {
          xtype: 'combobox',
          store: gridnms["store.11"],
          valueField: "ITEMCODE",
          displayField: "ITEMCODE",
          matchFieldWidth: false,
          editable: true,
          queryParam: 'keyword',
          queryMode: 'local', // 'remote',
          allowBlank: true,
          typeAhead: true,
          transform: 'stateSelect',
          forceSelection: false,
          listeners: {
            select: function (value, record, eOpts) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.uom"]).selModel.getSelection()[0].id);

              model.set("ITEMNAME", record.get("ITEMNAME"));
              model.set("ORDERNAME", record.get("ORDERNAME"));
              //model.set("UOM", record.get("UOM"));
              //model.set("UOMNAME", record.get("UOMNAME"));
              model.set("MODEL", record.get("MODEL"));
              model.set("MODELNAME", record.get("MODELNAME"));
              model.set("CUSTOMERGUBUN", record.get("CUSTOMERGUBUN"));
              model.set("CUSTOMERGUBUNNAME", record.get("CUSTOMERGUBUNNAME"));
              model.set("CUSTOMERCODE", record.get("CUSTOMERCODE"));
              model.set("CUSTOMERNAME", record.get("CUSTOMERNAME"));

              var item = record.get("ITEMCODE");

              if (item == "") {
                model.set("ITEMNAME", "");
                model.set("ORDERNAME", "");
                //model.set("UOM", "");
                //model.set("UOMNAME", "");
                model.set("MODEL", "");
                model.set("MODELNAME", "");
                model.set("CUSTOMERGUBUN", "");
                model.set("CUSTOMERGUBUNNAME", "");
                model.set("CUSTOMERCODE", "");
                model.set("CUSTOMERNAME", "");

              } 
            },
            change: function (field, ov, nv, eOpts) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.uom"]).selModel.getSelection()[0].id);
              var result = field.getValue();

              if (ov != nv) {
                if (!isNaN(result)) {
                   <%--이전에 입력한 값이랑 다른 경우 클리어--%>
                  console.log("change : " + field.getValue());
                  model.set("ITEMNAME", "");
                  model.set("ORDERNAME", "");
                  //model.set("UOM", "");
                  //model.set("UOMNAME", "");
                  model.set("MODEL", "");
                  model.set("MODELNAME", "");
                  model.set("CUSTOMERGUBUN", "");
                  model.set("CUSTOMERGUBUNNAME", "");
                  model.set("CUSTOMERCODE", "");
                  model.set("CUSTOMERNAME", "");
                  
                }
              }
            },
          },
          listConfig: {
            loadingText: '검색 중...',
            emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
            width: 450,
            getInnerTpl: function () {
              return '<div >'
               + '<table >'
               + '<colgroup>'
               + '<col width="120px">'
               + '<col width="180px">'
               + '<col width="120px">'
               + '<col width="50px">'
               + '</colgroup>'
               + '<tr>'
               + '<td style="height: 25px; font-size: 13px; ">{ITEMCODE}</td>'
               + '<td style="height: 25px; font-size: 13px; ">{ITEMNAME}</td>'
               + '<td style="height: 25px; font-size: 13px; ">{ORDERNAME}</td>'
               + '<td style="height: 25px; font-size: 13px; ">{UOMNAME}</td>'
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
      },
      {
          dataIndex: 'ITEMNAME',
          text: '품명',
          xtype: 'gridcolumn',
          width: 180,
          hidden: false,
          sortable: false,
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
            typeAhead: true,
            transform: 'stateSelect',
            forceSelection: false,
            listeners: {
              beforequery: function(qe){
                      delete qe.combo.lastQuery;
                  },
              select: function (value, record, eOpts) {
                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.uom"]).selModel.getSelection()[0].id);

                model.set("ITEMCODE", record.get("ITEMCODE"));
                model.set("ORDERNAME", record.get("ORDERNAME"));
                //model.set("UOM", record.get("UOM"));
                //model.set("UOMNAME", record.get("UOMNAME"));
                model.set("MODEL", record.get("MODEL"));
                model.set("MODELNAME", record.get("MODELNAME"));
                model.set("CUSTOMERGUBUN", record.get("CUSTOMERGUBUN"));
                model.set("CUSTOMERGUBUNNAME", record.get("CUSTOMERGUBUNNAME"));
                model.set("CUSTOMERCODE", record.get("CUSTOMERCODE"));
                model.set("CUSTOMERNAME", record.get("CUSTOMERNAME"));

                var item = record.get("ITEMCODE");

                if (item == "") {
                  model.set("ITEMCODE", "");
                  model.set("ORDERNAME", "");
                  //model.set("UOM", "");
                  //model.set("UOMNAME", "");
                  model.set("MODEL", "");
                  model.set("MODELNAME", "");
                  model.set("CUSTOMERGUBUN", "");
                  model.set("CUSTOMERGUBUNNAME", "");
                  model.set("CUSTOMERCODE", "");
                  model.set("CUSTOMERNAME", "");

                } 
              },
              change: function (field, ov, nv, eOpts) {
                var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);
                var result = field.getValue();

                if (ov != nv) {
                  if (result  === "") {
                     <%--이전에 입력한 값이랑 다른 경우 클리어--%>
                    console.log("change : " + field.getValue());
                    model.set("ITEMCODE", "");
                    model.set("ORDERNAME", "");
                    //model.set("UOM", "");
                    //model.set("UOMNAME", "");
                    model.set("MODEL", "");
                    model.set("MODELNAME", "");
                    model.set("CUSTOMERGUBUN", "");
                    model.set("CUSTOMERGUBUNNAME", "");
                    model.set("CUSTOMERCODE", "");
                    model.set("CUSTOMERNAME", "");
                   
                  }
                }
              },
            },
            listConfig: {
              loadingText: '검색 중...',
              emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
              width: 450,
              getInnerTpl: function () {
                return '<div >'
                 + '<table >'
                 + '<colgroup>'
                 + '<col width="180px">'
                 + '<col width="120px">'
                 + '<col width="120px">'
                 + '<col width="50px">'
                 + '</colgroup>'
                 + '<tr>'
                 + '<td style="height: 25px; font-size: 13px; ">{ITEMNAME}</td>'
                   + '<td style="height: 25px; font-size: 13px; ">{ITEMCODE}</td>'
                 + '<td style="height: 25px; font-size: 13px; ">{ORDERNAME}</td>'
                 + '<td style="height: 25px; font-size: 13px; ">{UOMNAME}</td>'
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
        },
//        {
//        dataIndex: 'ITEMNAME',
//        text: '품명',
//        xtype: 'gridcolumn',
//        width: 160,
//        hidden: false,
//        sortable: false,
//        align: "center",
//        renderer: function (value, meta, record) {
//          meta.style = "background-color:rgb(234, 234, 234)";
//          return value;
//        },
//      }, 
{
        dataIndex: 'ORDERNAME',
        text: '품번',
        xtype: 'gridcolumn',
        width: 120,
        hidden: false,
        sortable: false,
        align: "center",
        editor: {
          xtype: 'combobox',
          store: gridnms["store.11"],
          valueField: "ORDERNAME",
          displayField: "ORDERNAME",
          matchFieldWidth: false,
          editable: true,
          queryParam: 'keyword',
          queryMode: 'local', // 'remote',
          allowBlank: true,
          typeAhead: true,
          transform: 'stateSelect',
          forceSelection: false,
          listeners: {
            select: function (value, record, eOpts) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.uom"]).selModel.getSelection()[0].id);

              model.set("ITEMNAME", record.get("ITEMNAME"));
              model.set("ITEMCODE", record.get("ITEMCODE"));
              //model.set("UOM", record.get("UOM"));
              //model.set("UOMNAME", record.get("UOMNAME"));
              model.set("MODEL", record.get("MODEL"));
              model.set("MODELNAME", record.get("MODELNAME"));
              model.set("CUSTOMERGUBUN", record.get("CUSTOMERGUBUN"));
              model.set("CUSTOMERGUBUNNAME", record.get("CUSTOMERGUBUNNAME"));
              model.set("CUSTOMERCODE", record.get("CUSTOMERCODE"));
              model.set("CUSTOMERNAME", record.get("CUSTOMERNAME"));

              var item = record.get("ORDERNAME");

              if (item == "") {
                model.set("ITEMNAME", "");
                model.set("ORDERNAME", "");
                //model.set("UOM", "");
                //model.set("UOMNAME", "");
                model.set("MODEL", "");
                model.set("MODELNAME", "");
                model.set("CUSTOMERGUBUN", "");
                model.set("CUSTOMERGUBUNNAME", "");
                model.set("CUSTOMERCODE", "");
                model.set("CUSTOMERNAME", "");

              }
            },
            change: function (field, ov, nv, eOpts) {
              var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.viewer"]).selModel.getSelection()[0].id);
              var result = field.getValue();

              if (ov != nv) {
                if (!isNaN(result)) {
                   <%--이전에 입력한 값이랑 다른 경우 클리어--%>
                  console.log("change : " + field.getValue());
                  model.set("ITEMNAME", "");
                  model.set("ITEMCODE", "");
                  //model.set("UOM", "");
                  //model.set("UOMNAME", "");
                  model.set("MODEL", "");
                  model.set("MODELNAME", "");
                  model.set("CUSTOMERGUBUN", "");
                  model.set("CUSTOMERGUBUNNAME", "");
                  model.set("CUSTOMERCODE", "");
                  model.set("CUSTOMERNAME", "");
                 
                }
              }
            },
          },
          listConfig: {
            loadingText: '검색 중...',
            emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
            width: 450,
            getInnerTpl: function () {
              return '<div >'
               + '<table >'
               + '<colgroup>'
               + '<col width="120px">'
               + '<col width="120px">'
               + '<col width="180px">'
               + '<col width="50px">'
               + '</colgroup>'
               + '<tr>'
               + '<td style="height: 25px; font-size: 13px; ">{ORDERNAME}</td>'
               + '<td style="height: 25px; font-size: 13px; ">{ITEMCODE}</td>'
               + '<td style="height: 25px; font-size: 13px; ">{ITEMNAME}</td>'
               + '<td style="height: 25px; font-size: 13px; ">{UOMNAME}</td>'
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
      },
      {
			  dataIndex: 'MODELNAME',
			  text: '모델',
			  xtype: 'gridcolumn',
			  width: 90,
			  hidden: false,
			  sortable: false,
			  resizable: true,
			  align: "center",
			  renderer: function (value, meta, record) {
		          meta.style = "background-color:rgb(234, 234, 234)";
		          return value;
		        },
			},
			{
			    dataIndex: 'CUSTOMERGUBUNNAME',
			    text: '계열',
			    xtype: 'gridcolumn',
			    width: 90,
			    hidden: false,
			    sortable: false,
			    resizable: true,
			    align: "center",
			    renderer: function (value, meta, record) {
		              meta.style = "background-color:rgb(234, 234, 234)";
		              return value;
		            },
			  },
			  {
			      dataIndex: 'CUSTOMERNAME',
			      text: '고객/공급업체',
			      xtype: 'gridcolumn',
			      width: 120,
			      hidden: false,
			      sortable: false,
			      resizable: true,
			      align: "left",
			      renderer: function (value, meta, record) {
		              meta.style = "background-color:rgb(234, 234, 234)";
		              return value;
		            },
			    },
// {
//        dataIndex: 'ORDERNAME',
//        text: '품번',
//        xtype: 'gridcolumn',
//        width: 100,
//        hidden: false,
//        sortable: false,
//        align: "center",
//         renderer: function (value, meta, record) {
//          meta.style = "background-color:rgb(234, 234, 234)";
//          return value;
//        },
//      }, 
      {
       dataIndex : 'STDUOMNAME',
       text : '기본단위',
       xtype : 'gridcolumn',
       width : 70,
       hidden : false,
       sortable : false,
       resizable : true,
       align : "center",
       editor : {
           xtype : 'combobox',
           store : gridnms["store.5"],
           valueField: "VALUE",
           displayField: "LABEL",
           matchFieldWidth: true,
           editable: true,
           queryParam : 'keyword',
           queryMode : 'local',
           allowBlank : true,
           listeners : {
               select : function(value, record, eOpts) {
                   var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.uom"]).selModel.getSelection()[0].id);

                   model.set("STDUOM", value.getValue());
               },
           },
       },
       //renderer : renderer4combobox,
       renderer: function (value, meta, record) {
           meta.style = "background-color:rgb(253, 218, 255)";
           return value;
         },
   }, 
   {
       dataIndex: 'STDFORMULA',
       text: '단위',
       xtype: 'gridcolumn',
       width: 70,
       hidden: false,
       sortable: false,
       resizable: true,
       align: "center",
     },
    
	    {
	        dataIndex : 'CONUOMNAME',
	        text : '변환단위',
	        xtype : 'gridcolumn',
	        width : 70,
	        hidden : false,
	        sortable : false,
	        resizable : true,
	        align : "center",
	        editor : {
	            xtype : 'combobox',
	            store : gridnms["store.5"],
	            valueField: "VALUE",
	            displayField: "LABEL",
	            matchFieldWidth: true,
	            editable: true,
	            queryParam : 'keyword',
	            queryMode : 'local',
	            allowBlank : true,
	            listeners : {
	                select : function(value, record, eOpts) {
	                    var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.uom"]).selModel.getSelection()[0].id);

	                    model.set("CONUOM", value.getValue());
	                },
	            },
	        },
	        //renderer : renderer4combobox,
	        renderer: function (value, meta, record) {
	            meta.style = "background-color:rgb(253, 218, 255)";
	            return value;
	          },
	    }, 
	    {
	        dataIndex : 'CONFORMULA',
	        text : '변환식',
	        xtype : 'gridcolumn',
	        width : 80,
	        hidden : false,
	        sortable : false,
	        resizable : true,
	        style : 'text-align:center',
	        align : "right",
	        cls : 'ERPQTY',
	        format : "0,000",
	        editor : {
	            xtype : "textfield",
	            minValue : 1,
	            format : "0,000.00",
	            enforceMaxLength: true,
	            allowBlank : true,
	            maxLength: '20', 
	            maskRe: /[0-9.]/,
	            selectOnFocus : true,
	        },
	        renderer : Ext.util.Format.numberRenderer('0,000.00')
	    },
    // Hidden Columns
    {
      dataIndex: 'ORGID',
      xtype: 'hidden',
    }, {
      dataIndex: 'COMPANYID',
      xtype: 'hidden',
    }, {
      dataIndex: 'STDUOM',
      xtype: 'hidden',
    }, {
      dataIndex: 'CONUOM',
      xtype: 'hidden',
    }, {
      dataIndex: 'CREATIONDATE',
      xtype: 'hidden',
    }, {
      dataIndex: 'CREATEDBY',
      xtype: 'hidden',
    }, {
        dataIndex: 'LASTUPDATEDBY',
        xtype: 'hidden',
    }, {
        dataIndex: 'MODEL',
        xtype: 'hidden',
    },  {
        dataIndex: 'CUSTOMERGUBUN',
        xtype: 'hidden',
    },  {
        dataIndex: 'CUSTOMERCODE',
        xtype: 'hidden',
    },  {
        dataIndex: 'STDUOM',
        xtype: 'hidden',
    },  {
        dataIndex: 'CONUOM',
        xtype: 'hidden',
    },  {
        dataIndex: 'LASTUPDATEDATE',
        xtype: 'hidden',
    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/uom/UomList.do' />"
	  });
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/uom/UomList.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/uom/UomList.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/uom/UomList.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd1"
	  });
	  items["btns.1"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel1"
	  });
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
	    "#btnAdd1": {
	      click: 'btnAdd1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnDel1": {
	      click: 'btnDel1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnSav1": {
	      click: 'btnSav1Click'
	    }
	  });
	  $.extend(items["btns.ctr.1"], {
	    "#btnRef1": {
	      click: 'btnRef1Click'
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
	  //     items["docked.1"].push(items["dock.paging.1"]);
	  items["docked.1"].push(items["dock.btn.1"]);
	}

	function btnAdd1Click(o, e) {
	  var model = Ext.create(gridnms["model.1"]);
	  var store = this.getStore(gridnms["store.1"]);

	  var seq = Ext.getStore(gridnms["store.1"]).count() + 1;
	  var rowin = Ext.getCmp(gridnms["panel.1"]).selModel.selection.rowIdx ;
	  
	  model.set("ORGID", $('#searchOrgId').val());
	  model.set("COMPANYID", $('#searchCompanyId').val());
    model.set("STDFORMULA", 1);

//      store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
    store.insert(rowin + 1 , model);
	};

	function btnSav1Click(o, e) {
	  var model = Ext.getStore(gridnms["store.1"])
	    .getById(Ext.getCmp(gridnms["views.uom"]).selModel.getSelection()[0].id);

	  var check = 0,
	  msg = null,
	  column = ['품목', '기본단위', '변환단위', '변환식'],
	  type = null,
	  header = null;

	  // 푸목코드 입력여부 확인
	  var workcentercd = model.get("ITEMCODE") + "";
	  if (workcentercd === "") {
	    if (check == 0) {
	      header = column[1];
	    } else {
	      header += ", " + column[1];
	    }

	    check++;
	    type = 2;
	  }

	  // 기본단위 입력여부 확인
	  var workcenternm = model.get("STDUOM") + "";
	  if (workcenternm === "") {
	    if (check == 0) {
	      header = column[2];
	    } else {
	      header += ", " + column[2];
	    }

	    check++;
	    type = 3;
	  }

	  // 변환단위 입력여부 확인
	  var seq = model.get("CONUOM") + "";
	  if (seq === "") {
	    if (check == 0) {
	      header = column[3];
	    } else {
	      header += ", " + column[3];
	    }

	    check++;
	    type = 4;
	  }

	  // 변환식 입력여부 확인
	  var useyn = model.get("CONFORMULA") + "";
	  if (useyn === "") {
	    if (check == 0) {
	      header = column[4];
	    } else {
	      header += ", " + column[4];
	    }

	    check++;
	    type = 5;
	  }

	  if (check == 0) {
	    // 저장
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
	  } else {
	    if (check == 5) {
	      msg = "[필수항목 미입력] " + header + "를 입력하여 주세요.";
	    } else if (check == 4 || check == 3 || check == 2 || check == 1) {
	      switch (type) {
	      case 1:
	      case 2:
	        msg = "[필수항목 미입력] " + header + "를 입력하여 주세요.";
	        break;
	      case 3:
	        msg = "[필수항목 미입력] " + header + "을 입력하여 주세요.";
	        break;
	      default:
	        break;
	      }
	    }

	    extAlert(msg);
	    return false;
	  }
	};
	
	function btnDel1Click(o, e) {
	  extGridDel(gridnms["store.1"], gridnms["panel.1"]);

	  //     var store = this.getStore(gridnms["store.1"]);
	  //     var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
	  //     if (record === undefined) {
	  //         return;
	  //     }

	  //     Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
	  //         if (btn == 'yes') {
	  //             store.remove(record);
	  //             Ext.getStore(gridnms["store.1"]).sync();

	  //             setTimeout(function () {
	  //                 Ext.getStore('setTimeout').load();
	  //             }, 200);
	  //         }
	  //     });
	};

	function btnRef1Click(o, e) {
	  Ext.getStore(gridnms["store.1"]).load();
	};

	var uom;
	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"]
	  });

	  Ext.define(gridnms["model.5"], {
	    extend: Ext.data.Model,
	    fields: fields["model.5"]
	  });

		Ext.define(gridnms["model.11"], {
		    extend: Ext.data.Model,
		    fields: fields["model.11"]
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
 	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: 'ajax',
	              api: items["api.1"],
	              extraParams: {
	                orgid: $("#searchOrgId").val(),
	                companyid: $("#searchCompanyId").val(),
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
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
	                //                         GROUPCD : "${searchVO.GROUPCODE}",
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
	                  url: "<c:url value='/searchItemNameLov.do' />",
	                  extraParams: {
	                    ORGID: $("#searchOrgId").val(),
	                    COMPANYID: $("#searchCompanyId").val(),
	                    //GUBUN : 'ITEM_CODE',  // 제품, 반제품 조회
	                  },
	                  reader: gridVals.reader,
	                }
	              }, cfg)]);
	        },
	      });


	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnLine1: '#btnLine1',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    btnAdd1Click: btnAdd1Click,
	    btnSav1Click: btnSav1Click,
	    btnDel1Click: btnDel1Click,
	    btnRef1Click: btnRef1Click,
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
	        height: 572, // 565,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
// 	        defaults : gridVals.defaultField,
	        viewConfig: {
	          itemId: 'btnLine1',
	        },
// 	        bufferedrenderer : false,
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var editDisableCols = ["WORKCD"];
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
	        dockedItems: items["docked.1"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.uom"],
	    stores: gridnms["stores.uom"],
	    views: gridnms["views.uom"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      uom = Ext.create(gridnms["views.uom"], {
	          renderTo: 'gridWorkMaArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    uom.updateLayout();
	  });
	}

	function fn_search() {
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var header = [],
	  count = 0;

	  if (isNaN(orgid)) {
	    header.push("사업장");
	    count++;
	  }

	  //     if (companyid === "") {
	  if (isNaN(companyid)) {
	    header.push("공장");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return;
	  }

	  var sparams = {
	    "ITEMCODE": $("#searchItemcd").val() + "",
	    "ITEMNAME": $("#searchItemnm").val() + "",
      "ORDERNAME": $("#searchOrdernm").val() + "",
	    "orgid": $("#searchOrgId").val() + "",
	    "companyid": $("#searchCompanyId").val() + ""
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
// 	  setTimeout(function () {

//         extGridSearch(sparams, gridnms["store.5"]);
//         extGridSearch(sparams, gridnms["store.6"]);
// 	  }, 200);

	}

	function fn_itemSave() {
	  extGridSave(storenm)
	}

	function fn_itemDel() {
	  extGridDel(storenm, viewnm)
	}

	function setLovList() {

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
										<div id="search_field">
												<div id="search_field_loc">
														<h2>
																<strong>${pageTitle}</strong>
														</h2>
												</div>
												<fieldset>
														<legend>조건정보 영역</legend>
														<div>
																<input type="hidden" id="routingtypeVal" value="" />
																<table class="tbl_type_view" border="1">
																		<colgroup>
																				<col width="10%">
																				<col width="20%">
																				<col width="10%">
																				<col width="20%">
																				<col width="10%">
																				<col width="20%">
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
																				
																				<td colspan ="2">
																						<div class="buttons" style="float: right; margin-top: 3px;">
																								<div class="buttons" style="float: right;">
																										<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
																								</div>
																						</div>
																				</td>
																		</tr>
																		<tr>
                                        <th class="required_text">품목</th>
                                        <td>
                                          <input type="text" id="searchItemcd" name="searchItemcd" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" value="" />
                                        </td>
                                        <th class="required_text">품명</th>
                                        <td>
                                          <input type="text" id="searchItemnm" name="searchItemnm" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" value="" />
                                        </td>
                                        <th class="required_text">품번</th>
                                        <td>
                                          <input type="text" id="searchOrdernm" name="searchOrdernm" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" value="" />
                                        </td>
                                        
                                    </tr>
																</table>
														</div>
												</fieldset>
										</div>
										<!-- //검색 필드 박스 끝 -->

										<div id="gridWorkMaArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
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