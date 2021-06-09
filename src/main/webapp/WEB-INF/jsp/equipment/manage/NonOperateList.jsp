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

.ResultTable th {
  font-size: 22px;
  font-weight: bold;
  background-color: #5B9BD5;
  color: white;
  border-bottom: 1px solid white;
}

.ResultTable td {
  font-size: 22px;
  color: black;
  text-align: center;
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
//     calender($('#searchFrom, #searchTo'));

    $('#searchFrom, #searchTo').keyup(function (event) {
      if (event.keyCode != '8') {
        var v = this.value;
        if (v.length === 4) {
          this.value = v + "-";
        }
      }
    });

    $("#searchFrom").val(getToDay("${searchVO.dateFrom}") + "");
    $("#searchTo").val(getToDay("${searchVO.dateTo}") + "");

    $('#searchOrgId, #searchCompanyId').change(function (event) {
    });

    gridnms["app"] = "Equipment";
  }

  var gridnms = {};
  var fields = {};
  var items = {};
  function setValues() {
    gridnms["models.viewer"] = [];
    gridnms["stores.viewer"] = [];
    gridnms["views.viewer"] = [];
    gridnms["controllers.viewer"] = [];

    gridnms["grid.1"] = "NonOperateList";

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
        type: 'number',
        name: 'ORGID',
      }, {
        type: 'number',
        name: 'COMPANYID',
      }, {
        type: 'string',
        name: 'WORKCENTERNAME',
      }, {
	      type: 'string',
	      name: 'OPERATENAME',
	    }, {
        type: 'number',
        name: 'COUNT1',
      }, {
	      type: 'number',
	      name: 'TIME1',
	    }, {
        type: 'number',
        name: 'COUNT2',
      }, {
        type: 'number',
        name: 'TIME2',
      }, {
          type: 'number',
          name: 'COUNT3',
        }, {
          type: 'number',
          name: 'TIME3',
        }, {
          type: 'number',
          name: 'COUNT4',
        }, {
          type: 'number',
          name: 'TIME4',
        }, {
            type: 'number',
            name: 'COUNT5',
          }, {
            type: 'number',
            name: 'TIME5',
          }, {
            type: 'number',
            name: 'STOPTIME',
          }, {
            type: 'number',
            name: 'OVERTIME',
          }, {
              type: 'number',
              name: 'OPERRATE',
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
        width: 60,
        hidden: false,
        sortable: false,
        resizable: false,
        menuDisabled: true,
        style: 'text-align:center;',
        align: "center",
        format: "0,000",
      }, /* {
          dataIndex: 'WORKCENTERNAME',
          text: '설비명',
          xtype: 'gridcolumn',
          width: 100,
          hidden: false,
          sortable: false,
          resizable: false,
          menuDisabled: true,
          style: 'text-align:center',
          align: "center",
      }, {
          dataIndex: 'OPERATENAME',
          text: '비가동유형',
          xtype: 'gridcolumn',
          width: 100,
          hidden: false,
          sortable: false,
          resizable: false,
          menuDisabled: true,
          style: 'text-align:center',
          align: "center",
      },  */{
          dataIndex: 'STANDARDDATE',
          text: '등록일자',
          xtype: 'gridcolumn',
          width: 105,
          hidden: false,
          sortable: true,
          resizable: false,
          menuDisabled: true,
          style: 'text-align:center',
          align: "center",
//           format: 'Y-m-d',
//           renderer: function (value, meta, record) {
//               return Ext.util.Format.date(value, 'Y-m-d');
//           },
          summaryRenderer: function (value, meta, record) {
              var header1 = "합계";
              var header2 = "비율 (%)";
              return [header1, header2].map(function (val) {
                  return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 13px;'>" + val + '</div>';
              }).join('<br />');
          },
      }, {
          text: '장비고장',
          menuDisabled: true,
          columns: [{
                  dataIndex: 'COUNT1',
                  text: '건수',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, meta, record) {
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                      return result;
                    },
              }, {
                  dataIndex: 'TIME1',
                  text: '시간',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000.00",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000.00');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, summaryData, dataIndex) {
                      var data = Ext.getStore(gridnms["store.1"]).getData().items;

                      var total = 0;
                      var rate = 0;
                      for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {


                          total += (extExtractValues(data, dataIndex)[i] * 1);
                          rate += (extExtractValues(data, 'STOPTIME')[i] * 1);
                      }
                      rate=total/rate*100;
                      

                      var result = "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(total, '0,000.00') + '</div>';
                      result +="<br /><div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(rate, '0,000.0') + '</div>';
                      return result;
                  },
              }, ]
      }, {
          text: '기종교환',
          menuDisabled: true,
          columns: [{
                  dataIndex: 'COUNT2',
                  text: '건수',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, meta, record) {
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                      return result;
                    },
              }, {
                  dataIndex: 'TIME2',
                  text: '시간',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000.00');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, summaryData, dataIndex) {
                      var data = Ext.getStore(gridnms["store.1"]).getData().items;

                      var total = 0;
                      var rate = 0;
                      for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {


                          total += (extExtractValues(data, dataIndex)[i] * 1);
                          rate += (extExtractValues(data, 'STOPTIME')[i] * 1);
                      }
                      rate=total/rate*100;
                      

                      var result = "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(total, '0,000.00') + '</div>';
                      result +="<br /><div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(rate, '0,000.0') + '</div>';
                      return result;
                  },
              }, ]
      }, {
          text: '측정대기',
          menuDisabled: true,
          columns: [{
                  dataIndex: 'COUNT3',
                  text: '건수',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, meta, record) {
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                      return result;
                    },
              }, {
                  dataIndex: 'TIME3',
                  text: '시간',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000.00');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, summaryData, dataIndex) {
                      var data = Ext.getStore(gridnms["store.1"]).getData().items;

                      var total = 0;
                      var rate = 0;
                      for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {


                          total += (extExtractValues(data, dataIndex)[i] * 1);
                          rate += (extExtractValues(data, 'STOPTIME')[i] * 1);
                      }
                      rate=total/rate*100;
                      

                      var result = "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(total, '0,000.00') + '</div>';
                      result +="<br /><div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(rate, '0,000.0') + '</div>';
                      return result;
                  },
              }, ]
      }, {
          text: '공구교환',
          menuDisabled: true,
          columns: [{
                  dataIndex: 'COUNT4',
                  text: '건수',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, meta, record) {
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                      return result;
                    },
              }, {
                  dataIndex: 'TIME4',
                  text: '시간',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000.00');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, summaryData, dataIndex) {
                      var data = Ext.getStore(gridnms["store.1"]).getData().items;

                      var total = 0;
                      var rate = 0;
                      for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {


                          total += (extExtractValues(data, dataIndex)[i] * 1);
                          rate += (extExtractValues(data, 'STOPTIME')[i] * 1);
                      }
                      rate=total/rate*100;
                      

                      var result = "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(total, '0,000.00') + '</div>';
                      result +="<br /><div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(rate, '0,000.0') + '</div>';
                      return result;
                  },
              }, ]
      }, {
          text: '인원문제',
          menuDisabled: true,
          columns: [{
                  dataIndex: 'ABSENT',
                  text: '결근',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, meta, record) {
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                      return result;
                    },
              }, {
                  dataIndex: 'LATE',
                  text: '지각',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, meta, record) {
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                      return result;
                    },
              }, {
                  dataIndex: 'LEAVE',
                  text: '조퇴',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, meta, record) {
                      var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
                      return result;
                    },
              }, {
                  dataIndex: 'TIME5',
                  text: '시간',
                  xtype: 'gridcolumn',
                  width: 80,
                  hidden: false,
                  sortable: false,
                  menuDisabled: true,
                  style: 'text-align:center',
                  align: "right",
                  cls: 'ERPQTY',
                  format: "0,000",
                  renderer: function (value, meta, eOpts) {
                      return Ext.util.Format.number(value, '0,000.00');
                  },
                  summaryType: 'sum',
                  summaryRenderer: function (value, summaryData, dataIndex) {
                      var data = Ext.getStore(gridnms["store.1"]).getData().items;

                      var total = 0;
                      var rate = 0;
                      for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {


                          total += (extExtractValues(data, dataIndex)[i] * 1);
                          rate += (extExtractValues(data, 'STOPTIME')[i] * 1);
                      }
                      rate=total/rate*100;
                      
//                       var result = [total, rate].map(function (val) {
//                           return "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(val, '0,000.00') + '</div>';
//                       }).join('<br />');
                      var result = "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(total, '0,000.00') + '</div>';
                      result +="<br /><div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(rate, '0,000.0') + '</div>';
                      return result;
                  },
              }, ]
      }, {
          dataIndex: 'STOPTIME',
          text: '정지시간<br/>(Hr)',
          xtype: 'gridcolumn',
          width: 100,
          hidden: false,
          sortable: false,
          menuDisabled: true,
          style: 'text-align:center',
          align: "right",
          cls: 'ERPQTY',
          format: "0,000.00",
          renderer: function (value, meta, eOpts) {
              return Ext.util.Format.number(value, '0,000.00');
          },
          summaryType: 'sum',
          summaryRenderer: function (value, summaryData, dataIndex) {
              var data = Ext.getStore(gridnms["store.1"]).getData().items;

              var total = 0;
              var rate = 0;
              for (var i = 0; i < extExtractValues(data, dataIndex).length; i++) {


                  total += (extExtractValues(data, dataIndex)[i] * 1);
                  rate += (extExtractValues(data, 'STOPTIME')[i] * 1);
              }
              rate=total/rate*100;
              

              var result = "<div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(total, '0,000.00') + '</div>';
              result +="<br /><div style='padding-top: 2px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(rate, '0,000') + '</div>';
              return result;
          },
      }, {
          dataIndex: 'OVERTIME',
          text: '부하시간<BR/>(Hr)',
          xtype: 'gridcolumn',
          width: 100,
          hidden: false,
          sortable: false,
          menuDisabled: true,
          style: 'text-align:center',
          align: "right",
          cls: 'ERPQTY',
          format: "0,000",
          renderer: function (value, meta, eOpts) {
              return Ext.util.Format.number(value, '0,000');
          },
          summaryType: 'sum',
          summaryRenderer: function (value, meta, record) {
              var result = "<div style='padding-top: 4px; font-weight: bold; text-align: right; font-size: 18px;'>" + Ext.util.Format.number(value, '0,000') + "</div>";
              return result;
            },
      }, {
          dataIndex: 'OPERRATE',
          text: '가동율<br/>(%)',
          xtype: 'gridcolumn',
          width: 100,
          hidden: false,
          sortable: false,
          menuDisabled: true,
          style: 'text-align:center',
          align: "right",
          cls: 'ERPQTY',
          format: "0,000",
          renderer: function (value, meta, eOpts) {
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
      }, 
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
      read: "<c:url value='/select/equipment/manage/NonOperateList.do' />"
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
//     items["docked.1"].push(items["dock.btn.1"]);
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
                },
                reader: gridVals.reader,
              }
            }, cfg)]);
      },
    });

    Ext.define(gridnms["controller.1"], {
      extend: Ext.app.Controller,
      refs: {
        workHistoryList: '#workHistoryList',
      },
      stores: [gridnms["store.1"]],
      control: items["btns.ctr.1"],

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
          features: [{
              ftype: 'summary',
              dock: 'bottom'
            }
          ],
          border: 2,
          scrollable: true,
          columns: fields["columns.1"],
          plugins: [{
              ptype: 'bufferedrenderer',
              trailingBufferZone: 20,
              leadingBufferZone: 20,
              synchronousRender: false,
              numFromEdge: 19,
            }
          ],
          viewConfig: {
            itemId: 'workHistoryList',
            trackOver: true,
            loadMask: true,
            striptRows: true,
            forceFit: true,
            listeners: {
              refresh: function (dataView) {
                Ext.each(dataView.panel.columns, function (column) {
                  if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('EQUIPMENTNAME') >= 0 || column.dataIndex.indexOf('ROUTINGNAME') >= 0 || column.dataIndex.indexOf('CHECKSMALLNAME') >= 0 || column.dataIndex.indexOf('CHECKSTANDARD') >= 0) {
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

  function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchFrom = $('#searchFrom').val();
    var searchTo = $('#searchTo').val();
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

    if (searchFrom == "") {
      header.push("일자From");
      count++;
    }

    if (searchTo == "") {
      header.push("일자To");
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
    var searchFrom = $('#searchFrom').val();
    var searchTo = $('#searchTo').val();
    var searchcheck = $('#searchCheck option:selected').val();
    var searchcheckbig = $('#searchCheckBig option:selected').val();
    var itemcode = $('#searchItemCode').val();
    var routingid = $('#searchRoutingId').val();
    var employeenumber = $('#searchEmployeeNumber').val();
    var equipmentcode = $('#searchEquipmentCode').val();

    var sparams = {
      ORGID: orgid,
      COMPANYID: companyid,
      SEARCHFROM: searchFrom,
      SEARCHTO: searchTo,
      CHECKBIG: searchcheckbig,
      TOTALRESULT: searchcheck,
      ITEMCODE: itemcode,
      ROUTINGID: routingid,
      EMPLOYEENUMBER: employeenumber,
      EQUIPMENTCODE: equipmentcode,
    };

    extGridSearch(sparams, gridnms["store.1"]);

    popupclick = 0;
  }


  function fn_ready() {
    extAlert("준비중입니다...");
  }

  function setLovList() {
	//설비명 Lov
	    $("#searchWorkcenterName")
	    .bind("keydown", function (e) {
	        switch (e.keyCode) {
	        case $.ui.keyCode.TAB:
	            if ($(this).autocomplete("instance").menu.active) {
	                e.preventDefault();
	            }
	            break;
	        case $.ui.keyCode.BACKSPACE:
	        case $.ui.keyCode.DELETE:
	            $("#searchWorkcenterCode").val("");
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
	            $.getJSON("<c:url value='/select/master/workcenter/WorkCenterMa.do' />", {
	                keyword: extractLast(request.term),
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val()
	            }, function (data) {
	                response($.map(data.data, function (m, i) {
	                        return $.extend(m, {
	                            value: m.WORKCENTERCODE,
	                            label: m.WORKCENTERNAME,
	                            name: m.WORKCENTERNAME,
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
	            $("#searchWorkcenterName").val(o.item.name);
	            $("#searchWorkcenterCode").val(o.item.value);
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
                                <li>설비관리</li>
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
                        <input type="hidden" id="orgid" value="<c:out value='${searchVO.ORGID}'/>" />
                        <input type="hidden" id="companyid" value="<c:out value='${searchVO.COMPANYID}'/>" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                            <input type="hidden" id="searchWorkcenterCode" name="searchWorkcenterCode" />
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
                                            <select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 50%; visibility: hidden;">
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
                                        <col >
                                        <col width="120px">
                                        <col>
                                        <col width="120px">
                                        <col>
                                    </colgroup>
                                    <tr style="height: 34px;">
                                        <th class="required_text">년월</th>
                                        <td>
                                            <input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center" style="width: 97%;" maxlength="7" />
                                        </td>
<!--                                         <th class="required_text">설비명</th> -->
<!--                                         <td><input type="text" id="searchWorkcenterName" name="searchWorkcenterName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" /></td> -->
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
                                        <td>
                                        </td>
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