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

<!-- jQuery-File-Upload-9.9.3 -->
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/load-image.all.min.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/vendor/jquery.ui.widget.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-process.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-image.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/jquery.fileupload-angular.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/jQuery-File-Upload-9.9.3/js/app.js'/>"></script>

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
var Cnt = 0;
var selectedPrno = "";
var filetype = "quality", gubun = "ship";
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

  $('#searchOrgId, #searchCompanyId').change(function (event) {
     <%--상태 option 변경--%>
    fn_option_change('OM', 'SHIP_GUBUN', 'searchShipGubun');

  });

  gridnms["app"] = "quality";
}

function getItemFile() {
  selectedPrno = $('#shipno').val() + "-" + $('#shipseq').val();
  $("div[id^=fileBox_]").remove();
  $("#filetable").find(".cancel").click();
  $("#filetable").find("tr").remove();
  $.ajax({
    url: "<c:url value='/itemfile/select.do' />",
    type: "post",
    dataType: "json",
    data: {
      itemcd: selectedPrno,
      filetype: filetype,
      gubun: gubun
    },
    success: function (data) {
      var wth = $("#fileBox").width();
      var hgt = $("#fileBox").height();
      $.each(data, function (i, m) {
        var html = '';
        html += '<div id="fileBox_' + m.fileid + '" >';
        html += '<span style="width: 800px; height: 25px; float: left; padding-left: 7px; padding-top: 3px;"><a href="' + m.filepathview + m.filenmreal + '" download="' + m.filenmview + '">' + m.filenmview + '</a></span>';
        html += '</div>';
        $("#fileBox").append(html);
      });
      Cnt = $("div[id^=fileBox_]").length;
    },
    error: ajaxError
  });
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {

  gridnms["models.quality"] = [];
  gridnms["stores.quality"] = [];
  gridnms["views.quality"] = [];
  gridnms["controllers.quality"] = [];

  gridnms["grid.1"] = "ShipInspectionList";

  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
  gridnms["views.quality"].push(gridnms["panel.1"]);

  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
  gridnms["controllers.quality"].push(gridnms["controller.1"]);

  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

  gridnms["models.quality"].push(gridnms["model.1"]);

  gridnms["stores.quality"].push(gridnms["store.1"]);

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
      name: 'SHIPNO',
    }, {
      type: 'number',
      name: 'SHIPSEQ',
    }, {
      type: 'date',
      name: 'SHIPDATE',
      dateFormat: 'Y-m-d',
    }, {
      type: 'string',
      name: 'CUSTOMERCODE',
    }, {
      type: 'string',
      name: 'CUSTOMERNAME',
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
      name: 'UOM',
    }, {
      type: 'string',
      name: 'UOMNAME',
    }, {
      type: 'number',
      name: 'SHIPQTY',
    }, {
      type: 'number',
      name: 'SUPPLYPRICE',
    }, {
      type: 'number',
      name: 'ADDITIONALTAX',
    }, {
      type: 'number',
      name: 'TOTAL',
    }, {
      type: 'string',
      name: 'SONO',
    }, {
      type: 'number',
      name: 'SOSEQ',
    }, {
      type: 'string',
      name: 'REMARKS',
    }, {
      type: 'string',
      name: 'SAVEYN',
    }, ];

  fields["columns.1"] = [
    // Display Columns
    {
      dataIndex: 'RN',
      text: '순번',
      xtype: 'rownumberer',
      width: 55,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      cls: 'ERPQTY',
      format: "0,000",
    }, {
      dataIndex: 'SHIPNO',
      text: '출하번호',
      xtype: 'gridcolumn',
      width: 130,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
    }, {
      dataIndex: 'SHIPSEQ',
      text: '출하<br/>순번',
      xtype: 'gridcolumn',
      width: 65,
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
      dataIndex: 'SHIPDATE',
      text: '출하일자',
      xtype: 'datecolumn',
      width: 105,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
      format: 'Y-m-d',
    }, {
      dataIndex: 'CUSTOMERNAME',
      text: '거래처',
      xtype: 'gridcolumn',
      width: 160,
      hidden: false,
      sortable: true,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "left",
    }, {
      dataIndex: 'ORDERNAME',
      text: '품번',
      xtype: 'gridcolumn',
      width: 100,
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
      width: 160,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "left",
      //     }, {
      //       dataIndex: 'FILEYN',
      //       text: '첨부<br/>유무',
      //       xtype: 'gridcolumn',
      //       width: 60,
      //       hidden: false,
      //       sortable: false,
      //       resizable: false,
      //       menuDisabled: true,
      //       style: 'text-align:center;',
      //       align: "center",
      //       renderer: function (value, meta, record) {
      //         return value;
      //       },
      //     }, {
      //       dataIndex: 'XXXXXXXXXX',
      //       menuDisabled: true,
      //       sortable: false,
      //       resizable: false,
      //       xtype: 'widgetcolumn',
      //       stopSelection: true,
      //       text: '첨부',
      //       width: 65,
      //       style: 'text-align:center',
      //       align: "center",
      //       widget: {
      //         xtype: 'button',
      //         _btnText: "첨부",
      //         defaultBindProperty: null,
      //         handler: function (widgetColumn) {
      //           var record = widgetColumn.getWidgetRecord();
      //           var shipno = record.data.SHIPNO;
      //           if (shipno === "") {
      //             extAlert("출하번호가 없습니다.");
      //             return;
      //           }

      //           $('#shipno').val(shipno);
      //           $('#shipseq').val(record.data.SHIPSEQ);
      //           getItemFile();
      //         },
      //         listeners: {
      //           beforerender: function (widgetColumn) {
      //             var record = widgetColumn.getWidgetRecord();
      //             widgetColumn.setText(widgetColumn._btnText);
      //           }
      //         }
      //       }
    },
    //        {
    //          dataIndex: 'UOMNAME',
    //          text: '단위',
    //          xtype: 'gridcolumn',
    //          width: 50,
    //          hidden: false,
    //          sortable: false,
    //          align: "center",
    //        }, {
    //          dataIndex: 'SHIPQTY',
    //          text: '출하수량',
    //          xtype: 'gridcolumn',
    //          width: 75,
    //          hidden: false,
    //          sortable: false,
    //          style: 'text-align:center;',
    //          align: "right",
    //          cls: 'ERPQTY',
    //          format: "0,000",
    //          renderer: function (value, meta, record) {
    //            return Ext.util.Format.number(value, '0,000');
    //          },
    //        }, {
    //          dataIndex: 'SUPPLYPRICE',
    //          text: '공급가',
    //          xtype: 'gridcolumn',
    //          width: 95,
    //          hidden: false,
    //          sortable: false,
    //          style: 'text-align:center;',
    //          align: "right",
    //          cls: 'ERPQTY',
    //          format: "0,000",
    //          renderer: function (value, meta, record) {
    //            return Ext.util.Format.number(value, '0,000');
    //          },
    //        }, {
    //          dataIndex: 'ADDITIONALTAX',
    //          text: '부가세',
    //          xtype: 'gridcolumn',
    //          width: 95,
    //          hidden: false,
    //          sortable: false,
    //          style: 'text-align:center;',
    //          align: "right",
    //          cls: 'ERPQTY',
    //          format: "0,000",
    //          renderer: function (value, meta, record) {
    //            return Ext.util.Format.number(value, '0,000');
    //          },
    //        }, {
    //          dataIndex: 'TOTAL',
    //          text: '합계',
    //          xtype: 'gridcolumn',
    //          width: 105,
    //          hidden: false,
    //          sortable: false,
    //          style: 'text-align:center;',
    //          align: "right",
    //          cls: 'ERPQTY',
    //          format: "0,000",
    //          renderer: function (value, meta, record) {
    //            return Ext.util.Format.number(value, '0,000');
    //          },
    //        },
    {
      dataIndex: 'SONO',
      text: '수주번호',
      xtype: 'gridcolumn',
      width: 120,
      hidden: false,
      sortable: false,
      resizable: false,
      menuDisabled: true,
      style: 'text-align:center;',
      align: "center",
    }, {
      dataIndex: 'SOSEQ',
      text: '수주내역<br/>순번',
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
        return Ext.util.Format.number(value, '0,000');
      },
    }, {
      dataIndex: 'XXXXXXXXXX',
      menuDisabled: true,
      sortable: false,
      resizable: false,
      xtype: 'widgetcolumn',
      stopSelection: true,
      text: '',
      width: 120,
      style: 'text-align:center',
      align: "center",
      widget: {
        xtype: 'button',
        _btnText: "출하검사등록",
        defaultBindProperty: null, //important
        handler: function (widgetColumn) {
          var record = widgetColumn.getWidgetRecord();

          var saveyn = (record.data.SAVEYN != "N" && record.data.SAVEYN != undefined) ? true : false;
          if (saveyn) {
            var shipno = record.data.SHIPNO;
            var shipseq = record.data.SHIPSEQ;
            var itemcode = record.data.ITEMCODE;
            $('#shipno').val(shipno);
            $('#shipseq').val(shipseq);
            $('#itemcode').val(itemcode);

            var column = 'master';
            var url = "<c:url value='/quality/ship/ShipInspectionRegist.do'/>";
            var target = '_self';

            fn_popup_url(column, url, target);
          } else {
            extAlert("등록되지 않은 출하 내역입니다.<br/>저장 후 다시 확인해주세요.");
            return;
          }
        },
        listeners: {
          beforerender: function (widgetColumn) {
            var record = widgetColumn.getWidgetRecord();
            widgetColumn.setText(widgetColumn._btnText);
          }
        }
      }
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
    }, {
      dataIndex: 'ITEMCODE',
      xtype: 'hidden',
    }, {
      dataIndex: 'SUPPLYPRICE',
      xtype: 'hidden',
    }, {
      dataIndex: 'SHIPQTY',
      xtype: 'hidden',
    }, {
      dataIndex: 'ADDITIONALTAX',
      xtype: 'hidden',
    }, {
      dataIndex: 'TOTAL',
      xtype: 'hidden',
    }, {
      dataIndex: 'UOMNAME',
      xtype: 'hidden',
    }, {
      dataIndex: 'UOM',
      xtype: 'hidden',
    }, {
      dataIndex: 'REMARKS',
      xtype: 'hidden',
    }, {
      dataIndex: 'SAVEYN',
      xtype: 'hidden',
    }, ];

  items["api.1"] = {};
  $.extend(items["api.1"], {
    read: "<c:url value='/select/order/ship/ShipStatusRegist.do' />"
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

function fn_appr(val) {
  console.log("확정 메서드 시작 : " + val);
  var header = [],
  count = 0;
  var dataSuccess = 0;
  var result = null;

  if (count > 0) {
    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
    return;
  }

  var url = "",
  url1 = "",
  msgGubun = 0;
  var statuschk = true;

  var gridcount = Ext.getStore(gridnms["store.1"]).count();

  if (gridcount == 0) {
    extAlert("[확정]<br/> 확정 지시가 선택 되지 않았습니다.");
    return false;
  }

  url = "<c:url value='/appr/order/ship/ShipOrderRegist.do' />";

  var chk = val;
  var chkyn = chk.CONFIRMYN;
  var chkyn1 = chk.SHIPNO;
  if (chkyn1.length == 0) {
    Ext.Msg.alert('완료', '저장되지 않은 데이터 입니다. 저장 후 다시 처리 하세요.');
    return;
  }
  if (chkyn != "N") {
    Ext.Msg.alert('완료', '미확정 상태의 지시에 대해서만 완료 처리가 가능합니다.');
    return;
  }
  if (chkyn == "N") {

    Ext.MessageBox.confirm('완료 ', '완료 하시겠습니까?', function (btn) {
      if (btn == 'yes') {
        btnbreak = true;

        if (statuschk == true) {

          var params = [];
          $.ajax({
            url: url,
            type: "post",
            dataType: "json",
            data: val,
            success: function (data) {
              var apprid = data.SHIPNO;

              if (apprid.length == 0) {}
              else {
                var success = data.success;
                if (success == false) {
                  extAlert("관리자에게 문의하십시오.<br/>" + msgdata);
                  return;
                } else {
                  msg = "완료 처리 되었습니다.";
                  extAlert(msg);
                }
                if (success == false) {}
              }
              fn_search();
            },
            error: ajaxError
          });

        } else {
          extAlert(msg);
          return;
        }
        return;
      } else {
        Ext.Msg.alert('완료', '완료 처리가 취소되었습니다.');
        return;
      }
    });
  } else {
    Ext.Msg.alert('완료', '미완료상태의 지시에 대해서만 완료 처리가 가능합니다.');
    return;
  }
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
              extraParams: {
                ORGID: $('#searchOrgId option:selected').val(),
                COMPANYID: $('#searchCompanyId option:selected').val(),
                SHIPFROM: $('#searchShipFrom').val(),
                SHIPTO: $('#searchShipTo').val(),
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
                if (column.dataIndex.indexOf('ITEMNAME') >= 0 || column.dataIndex.indexOf('ORDERNAME') >= 0 || column.dataIndex.indexOf('CUSTOMERNAME') >= 0) {
                  column.autoSize();
                  column.width += 5;
                  if (column.width < 80) {
                    column.width = 80;
                  }
                }
              });
            },
          }
        },
        plugins: [{
            ptype: 'cellediting',
            clicksToEdit: 1,
//             listeners: {
//               "beforeedit": function (editor, ctx, eOpts) {
//                 var data = ctx.record;

//                 var editDisableCols = [];
//                 var status = data.data.CONFIRMYN;
//                 if (status != "N") {
<%--                    상태 값 완료시 입력 불가 --%>
//                   editDisableCols.push("SHIPGUBUNNAME");
//                   editDisableCols.push("CUSTOMERNAME");
//                   editDisableCols.push("ITEMCODE");
//                   editDisableCols.push("ITEMNAME");
//                   editDisableCols.push("ORDERNAME");
//                   editDisableCols.push("SHIPQTY");
//                   editDisableCols.push("SHIPDATE");
//                   editDisableCols.push("REMARKS");
//                 }

//                 var isNew = ctx.record.phantom || false;
//                 if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
//                   return false;
//                 else {
//                   return true;
//                 }
//               },
//               beforerender: function (c) {
//                 var formFields = [];
//                 //컴포넌트를 탐색하면서 field인것만 검
//                 c.cascade(function (field) {
//                   var xtypeChains = field.xtypesChain;

//                   var isField = Ext.Array.findBy(xtypeChains, function (item) {

//                       // DisplayField는 이벤트 대상에서 제외
//                       if (item == 'displayfield') {
//                         return false;
//                       }

//                       // Ext.form.field.Base를 상속받는 모든객체
//                       if (item == 'field') {
//                         return true;
//                       }
//                     });
//                   //keyup이벤트 처리를 위해 enableKeyEvent를 true로 설정해야만함...
//                   if (isField) {
//                     field.enableKeyEvents = true;
//                     field.isShiftKeyPressed = false;
//                     formFields.push(field);
//                   }
//                 });

//                 for (var i = 0; i < formFields.length - 1; i++) {
//                   var beforeField = (i == 0) ? null : formFields[i - 1];
//                   var field = formFields[i];
//                   var nextField = formFields[i + 1];

//                   field.addListener('keyup', function (thisField, e) {
//                     //Shift Key 처리방법
//                     if (e.getKey() == e.SHIFT) {
//                       thisField.isShiftKeyPressed = false;
//                       return;
//                     }
//                   });

//                   field.addListener('keydown', function (thisField, e) {
//                     if (e.getKey() == e.SHIFT) {
//                       thisField.isShiftKeyPressed = true;
//                       return;
//                     }

//                     // Shift키 안누르고 ENTER키 또는 TAB키 누를때 다음필드로 이동
//                     if (thisField.isShiftKeyPressed == false && (e.getKey() == e.ENTER || e.getKey() == e.TAB)) { // tab 이나 enter 누름 다음 field 포커싱하도록함.
//                       this.nextField.focus();
//                       e.stopEvent();
//                     }
//                     // Shift키 누른상태에서 TAB키 누를때 이전필드로 이동
//                     else if (thisField.isShiftKeyPressed == true && e.getKey() == e.TAB) {
//                       if (this.beforeField != null) {
//                         this.beforeField.focus();
//                         e.stopEvent();
//                       }
//                     }
//                   }, {
//                     nextField: nextField,
//                     beforeField: beforeField
//                   });
//                 }
//               }
//             },
          }
        ],
        dockedItems: items["docked.1"],
      }
    ],
  });

  Ext.application({
    name: gridnms["app"],
    models: gridnms["models.quality"],
    stores: gridnms["stores.quality"],
    views: gridnms["views.quality"],
    controllers: gridnms["controller.1"],

    launch: function () {
      gridarea = Ext.create(gridnms["views.quality"], {
          renderTo: 'gridQualityArea'
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
  var datefrom = $('#searchDateFrom').val();
  var dateto = $('#searchDateTo').val();
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
    header.push("출하일자 FROM");
    count++;
  }

  if (dateto === "") {
    header.push("출하일자 TO");
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
  var datefrom = $('#searchDateFrom').val();
  var dateto = $('#searchDateTo').val();
  var shipno = $('#ShipNo').val();
  var customercode = $('#CustomerCode').val();
  var itemcode = $('#searchItemcd').val();

  var sparams = {
    ORGID: orgid,
    COMPANYID: companyid,
    DATEFROM: datefrom,
    DATETO: dateto,
    SHIPNO: shipno,
    CUSTOMERCODE: customercode,
    ITEMCODE: itemcode,
  };

  extGridSearch(sparams, gridnms["store.1"]);
}

function fn_ready() {
  extAlert("준비중입니다...");
}

function setLovList() {
  // 품명 LOV
  $("#searchItemnm")
  .bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      $("#searchOrdernm").val("");
      $("#searchItemcd").val("");
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
        ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              label: m.ITEMNAME + ', ' + m.ORDERNAME,
              value: m.ITEMCODE,
              ITEMNAME: m.ITEMNAME,
              ORDERNAME: m.ORDERNAME,
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
      $("#searchItemcd").val(o.item.ITEMCODE);
      $("#searchItemnm").val(o.item.ITEMNAME);
      $("#searchOrdernm").val(o.item.ORDERNAME);
      return false;
    }
  });

  // 품번 LOV
  $("#searchOrdernm")
  .bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      $("#searchItemcd").val("");
      $("#searchItemnm").val("");
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
        ROUTING_BOM_CHECK: 'Y', // 제품,반제품,외주품
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              label: m.ORDERNAME + ', ' + m.ITEMNAME,
              value: m.ITEMCODE,
              ITEMNAME: m.ITEMNAME,
              ORDERNAME: m.ORDERNAME,
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
      $("#searchItemcd").val(o.item.ITEMCODE);
      $("#searchItemnm").val(o.item.ITEMNAME);
      $("#searchOrdernm").val(o.item.ORDERNAME);
      return false;
    }
  });

  // 출하번호 Lov
  $("#ShipNo").bind("keydown", function (e) {
    switch (e.keyCode) {
    case $.ui.keyCode.TAB:
      if ($(this).autocomplete("instance").menu.active) {
        e.preventDefault();
      }
      break;
    case $.ui.keyCode.BACKSPACE:
    case $.ui.keyCode.DELETE:
      //  $("#SalesPersonName").val("");
      //  $("#ShipNo").val("");
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
      $.getJSON("<c:url value='/searchShipNoFindLovList.do' />", {
        keyword: extractLast(request.term),
        ORGID: $('#searchOrgId option:selected').val(),
        COMPANYID: $('#searchCompanyId option:selected').val(),
      }, function (data) {
        response($.map(data.data, function (m, i) {
            return $.extend(m, {
              value: m.SHIPNO,
              label: m.SHIPNO,
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
      $("#ShipNo").val(o.item.value);

      return false;
    }
  });

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
                                <li>출하검사</li>
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
		                    <input type="hidden" id="shipqty" />
		                    <input type="hidden" id="confirmyn" />
                        <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
		                        <input type="hidden" id="shipno" name="shipno" />
		                        <input type="hidden" id="shipseq" name="shipseq" />
                            <input type="hidden" id="itemcode" name="itemcode" />
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
                                </colgroup>
                                <tr style="height: 34px;">
                                  <th class="required_text">출하일자</th>
                                  <td >
                                      <input type="text" id="searchDateFrom" name="searchDateFrom" class="input_validation input_center validate[custom[date],past[#searchShipTo]]" style="width: 90px; " maxlength="10" />
                                      &nbsp;~&nbsp;
                                      <input type="text" id="searchDateTo" name="searchDateTo" class="input_validation input_center validate[custom[date],future[#searchShipFrom]]" style="width: 90px; " maxlength="10"  />
                                  </td>
                                  <th class="required_text">출하번호</th>
                                  <td>
                                      <input type="text" id="ShipNo" name="ShipNo" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                                  </td>
                                  <td></td>
                                  <td></td>
                              </tr>
                              <tr style="height: 34px;">
                                  <th class="required_text">거래처명</th>
                                  <td>
                                        <input type="text" id="CustomerName" name="CustomerName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 94%;"/>
                                        <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                  </td>
                                  <th class="required_text">품번</th>
                                  <td>
                                        <input type="text" id="searchOrdernm" name="searchOrdernm" class="input_center" style="width: 94%;" />
                                        <input type="hidden" id="searchItemcd" name="searchItemcd" />
                                  </td>
                                  <th class="required_text">품명</th>
                                  <td>
                                        <input type="text" id="searchItemnm" name="searchItemnm" class="input_center" style="width: 94%;" />
                                  </td>
                                </tr>
                            </table>
                            </div>
                        </form>
                    </fieldset>
                    </div>
                    <!-- //검색 필드 박스 끝 -->                    
                <div style="width: 100%;">
                    <div id="gridQualityArea" style="width: 100%; margin-bottom: 5px; float: left;"></div>
                </div>

                <%-- <form id="fileform" name="fileform" method="POST" action='<c:url value="/itemfile/upload.do" />' enctype="multipart/form-data" data-ng-app="demo" data-file-upload="options" data-ng-controller="FileUploadController">
                    <div id="fileBox" style="width: 100%; border: 2px solid #81B1D5; float: left; overflow: auto;">
                        <table id="filetable" class="table table-striped files ng-cloak" style="width: 100%;">
                            <tr data-ng-repeat="file in queue" style="height: 30px !important;">
                                <td width="700px" style="vertical-align: middle;">
                                    <p class="name" data-ng-switch data-on="!!file.url">
                                        <span data-ng-switch-default>{{file.name}}</span>
                                    </p>
                                </td>
                                <td width="100px" style="vertical-align: middle;">
                                    <p class="size">{{file.size | formatFileSize}}</p>
                                </td>
                                <td style="vertical-align: middle;">
                                    <button type="button" class="btn btn-warning cancel" data-ng-click="file.$cancel()" data-ng-hide="!file.$cancel" style="font-size: 10px !important; padding-left: 7px !important; padding-top: 0px !important; padding-right: 7px; height: 18px !important;">
                                        <i class="glyphicon glyphicon-ban-circle"></i> <span>취소</span>
                                    </button>
                                    <button type="button" class="btn btn-primary start" data-ng-click="file.$submit()" data-ng-hide="!file.$submit || options.autoUpload" data-ng-disabled="file.$state() == 'pending' || file.$state() == 'rejected'" style="font-size: 10px !important; padding-left: 7px !important; padding-top: 0px !important; padding-right: 7px; height: 18px !important;">
                                        <i class="glyphicon glyphicon-upload"></i> <span>업로드</span>
                                    </button>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form> --%>
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