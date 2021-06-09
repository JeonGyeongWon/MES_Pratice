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

.x-form-field {
	font-size: 10px;
}

.ERPQTY  .x-column-header-text {
	margin-right: 0px;
}

#gridPopup1Area .x-form-field {
    ime-mode:disabled;
    text-transform:uppercase;
}
#gridPopup11Area .x-form-field {
    ime-mode:disabled;
    text-transform:uppercase;
}

</style>
<script type="text/javaScript">
$(document).ready(function () {
	  setInitial();

	  setValues();
	  setExtGrid();

	  // LOT 발행 예정 LIST(사출품) 팝업창 추가
	  setValues_Popup();
	  setExtGrid_Popup();

	  // LOT 발행 예정 LIST(도료품) 팝업창 추가
	  setValues_Popup1();
	  setExtGrid_Popup1();

	  $("#gridPopup1Area").hide("blind", {
	    direction: "up"
	  }, "fast");

	  $("#gridPopup11Area").hide("blind", {
	    direction: "up"
	  }, "fast");

	  setReadOnly();
	  setLovList();

	  var Lotno = $('#LotNo').val();
	  if (Lotno != "") {
	    fn_search();
	  } else {
	    $("#LotDate").val(getToDay("${searchVO.TODAY}") + "");
	  }

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});

	  if ("${searchVO.CustomerCode}" == "") {}
	  else {
	    $('#CustomerName').attr('disabled', true);
	    $("#CustomerName").val("${searchVO.CustomerName}");
	    $("#CustomerCode").val("${searchVO.CustomerCode}");
	  }
	});

	function setInitial() {
	  gridnms["app"] = "scm";

	  calender($('#LotDate'));

	  $('#LotDate').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.1"] = "OutProcLotRegistD";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.detail"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.detail"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];

	  gridnms["models.detail"].push(gridnms["model.1"]);

	  gridnms["stores.detail"].push(gridnms["store.1"]);

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
	      name: 'LOTNO',
	    }, {
	      type: 'number',
	      name: 'LOTSEQ',
	    }, {
	      type: 'string',
	      name: 'OUTTRANSNO',
	    }, {
	      type: 'string',
	      name: 'OUTTRANSSEQ',
	    }, {
	      type: 'number',
	      name: 'TRANSQTY',
	    }, {
	      type: 'string',
	      name: 'ITEMCODE',
	    }, {
	      type: 'string',
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'number',
	      name: 'PASSQTY',
	    }, {
	      type: 'number',
	      name: 'LOTQTY',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, {
	      type: 'string',
	      name: 'ROUTINGNAME',
	    },
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
	      style: 'text-align:center;',
	      align: "center",
	      cls: 'ERPQTY',
	      format: "0,000",
	    }, {
	      dataIndex: 'OUTTRANSNO',
	      text: '입고번호',
	      xtype: 'gridcolumn',
	      width: 180,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'OUTTRANSSEQ',
	      text: '입고순번',
	      xtype: 'gridcolumn',
	      width: 80,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
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
	    }, {
	      dataIndex: 'TRANSQTY',
	      text: '입고수량',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'PASSQTY',
	      text: '합격수량',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'LOTQTY',
	      text: '바코드생성량',
	      xtype: 'gridcolumn',
	      width: 100,
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
	        maskRe: /[0-9.]/,
	        selectOnFocus: true,
	        listeners: {
	          change: function (field, newValue, oldValue, eOpts) {
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;
	            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
	            var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

	            var qty = field.getValue();
	            var tqty = oldValue;

	            var pass = store.data.PASSQTY;
	            var lotqty = (qty) * 1.0;
	            var tlotqty = (tqty) * 1.0;
	            var tparam1 = $('#temp1').val() * 1;

	            if (lotqty > pass) {
	              extAlert("바코드생성량이 합격량보다 큽니다.");

	              store.set("LOTQTY", pass);
	              tparam1 += (pass * 1) - tlotqty;
	            } else {
	              tparam1 += (lotqty * 1) - tlotqty;
	            }

	            $('#LotQty').val(tparam1);
	            $('#temp1').val(tparam1);

	            $('#InputQty').val(tparam1);
	            fn_qty_change();
	          },
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'REMARKS',
	      text: '비고',
	      xtype: 'gridcolumn',
	      width: 500,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      editor: {
	        xtype: 'textfield',
	        allowBlank: true,
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
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOMNAME',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/scm/outprocess/OutProcLotRegistD.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/scm/outprocess/OutProcLotRegistD.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "삭제",
	    itemId: "btnDel1"
	  });

	  items["btns.ctr.1"] = {};
	  $.extend(items["btns.ctr.1"], {
	    "#btnDel1": {
	      click: 'btnDel1'
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

	//   LOT 발행 list (미발행 입하정보)
	var popcount = 0, popupclick = 0;
	function btnSel1(btn) {
	  var LotNo = $('#LotNo').val();
	  var LotDate = $('#LotDate').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (LotNo !== "") {
	    header.push("외주공정 Lot 번호");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[검색 조건 확인]<br/>" + header + "가 이미 등록 되어져 있습니다.<br/>새로 추가 하여 등록 하시거나 기존 데이터 삭제 후 재 등록 하시기 바랍니다.");
	    return false;
	  }

	  // 외주공정 Lot 발행 예정 List 팝업
	  var width = 1308; // 가로
	  var height = 640; // 세로
	  var title = "Lot 발행 예정 List";

	  var status = $('#Status').val();
	  var check = false;

	  if (status === "") {
	    // 제품선택 팝업표시 여부
	    check = true;
	  } else if (status == "STAND_BY") {
	    // 제품선택 팝업표시 여부
	    check = true;
	  } else if (status == "COMPLETE") {
	    // 완료시 팝업표시 여부
	    check = false;
	  } else {
	    check = true;
	  }

	  popupclick = 0;
	  if (check == true) {
	    // 완료 외 상태에서만 팝업 표시하도록 처리
	    $('#popupOrgId').val($('#searchOrgId option:selected').val());
	    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	    $('#popupTransFrom').val("");
	    $('#popupTransTo').val("");
	    $('#popupTransNo').val("");
	    $('#popupTransSeq').val("");
	    $('#popupItemCode').val("");
	    $('#popupCheckBig').val("I");
	    Ext.getStore(gridnms['store.4']).removeAll();

	    win1 = Ext.create('Ext.window.Window', {
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
	            itemId: gridnms["panel.4"],
	            id: gridnms["panel.4"],
	            store: gridnms["store.4"],
	            height: '100%',
	            border: 2,
	            scrollable: true,
	            frameHeader: true,
	            columns: fields["columns.4"],
	            viewConfig: {
	              itemId: 'btnPopup1'
	            },
	            plugins: 'bufferedrenderer',
	            dockedItems: items["docked.4"],
	          }
	        ],
	        tbar: [
	          '입고일', {
	            xtype: 'datefield',
	            enforceMaxLength: true,
	            maxLength: 10,
	            allowBlank: true,
	            format: 'Y-m-d',
	            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	            align: 'center',
	            width: 100,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              select: function (value, record) {
	                $('#popupTransFrom').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
	              },
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                if (nv !== ov) {
	                  if (result === "") {
	                    $('#popupTransFrom').val("");
	                  } else {
	                    var popupTransFrom = Ext.Date.format(result, 'Y-m-d');
	                    var popupTransTo = $('#popupTransTo').val();

	                    if (popupTransTo === "") {
	                      $('#popupTransFrom').val(Ext.Date.format(result, 'Y-m-d'));
	                    } else {
	                      var diff = 0;
	                      diff = fn_calc_diff(popupTransFrom, popupTransTo);
	                      if (diff < 0) {
	                        extAlert("이전 날짜가 이후 날짜보다 큽니다.<br/>다시 한번 확인해주십시오.");
	                        value.setValue("");
	                        $('#popupTransFrom').val("");
	                        return;
	                      } else {
	                        $('#popupTransFrom').val(Ext.Date.format(result, 'Y-m-d'));
	                      }
	                    }
	                  }
	                }
	              },
	            },
	            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	          }, ' ~ ', {
	            xtype: 'datefield',
	            enforceMaxLength: true,
	            maxLength: 10,
	            allowBlank: true,
	            format: 'Y-m-d',
	            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	            width: 100,
	            align: 'center',
	            listeners: {
	              scope: this,
	              buffer: 50,
	              select: function (value, record) {
	                $('#popupTransTo').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
	              },
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                if (nv !== ov) {
	                  if (result === "") {
	                    $('#popupTransTo').val("");
	                  } else {
	                    var popupTransFrom = $('#popupTransFrom').val();
	                    var popupTransTo = Ext.Date.format(result, 'Y-m-d');

	                    if (popupTransFrom === "") {
	                      $('#popupTransTo').val(Ext.Date.format(result, 'Y-m-d'));
	                    } else {
	                      var diff = 0;
	                      diff = fn_calc_diff(popupTransFrom, popupTransTo);
	                      if (diff < 0) {
	                        extAlert("이후 날짜가 이전 날짜보다 작습니다.<br/>다시 한번 확인해주십시오.");
	                        value.setValue("");
	                        $('#popupTransTo').val("");
	                        return;
	                      } else {
	                        $('#popupTransTo').val(Ext.Date.format(result, 'Y-m-d'));
	                      }
	                    }
	                  }
	                }
	              },
	            },
	            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	          },
	          '품번', {
	            xtype: 'textfield',
	            name: 'searchOrderName',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 120,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              change: function (value, nv, ov, e) {
	                value.setValue(nv.toUpperCase());
	                var result = value.getValue();

	                $('#popupOrderName').val(result);
	              },
	            },
	          },
	          '품명', {
	            xtype: 'textfield',
	            name: 'searchItemName',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 200,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              change: function (value, nv, ov, e) {
	                value.setValue(nv.toUpperCase());
	                var result = value.getValue();

	                $('#popupItemName').val(result);
	              },
	            },
	          }, '->', {
	            text: '조회',
	            scope: this,
	            handler: function () {
	              var sparams3 = {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                TRANSFROM: $('#popupTransFrom').val(),
	                TRANSTO: $('#popupTransTo').val(),
	                ITEMNAME: $('#popupItemName').val(),
	                ORDERNAME: $('#popupOrderName').val(),
	                CUSTOMERCODE: $('#CustomerCode').val(),
	              };

	              extGridSearch(sparams3, gridnms["store.4"]);
	            }
	          }, {
	            text: '전체선택/해제',
	            scope: this,
	            handler: function () {
	              // 전체등록 Pop up 전체선택 버튼 핸들러
	              var count5 = Ext.getStore(gridnms["store.4"]).count();
	              var checkTrue = 0,
	              checkFalse = 0;

	              if (popupclick == 0) {
	                popupclick = 1;
	              } else {
	                popupclick = 0;
	              }
	              for (var i = 0; i < count5; i++) {
	                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
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
	              var count5 = Ext.getStore(gridnms["store.4"]).count();
	              var checknum = 0,
	              checkqty = 0,
	              checktemp = 0
	                notCnt = 0,
	              outTransCnt = 0;
	              var qtytemp = [];

	              for (var i = 0; i < count5; i++) {
	                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
	                var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                var chk = model5.data.CHK;
	                if (chk == true) {
	                  checknum++;
	                }
	              }

	              if (checknum != 1) {
	                for (var k = 1; k < count5; k++) {
	                  Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(k));
	                  var model5 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                  var chk5 = model5.data.CHK;
	                  var itemcode5 = model5.data.ITEMCODE;
	                  var postqty5 = model5.data.POSTQTY;

	                  if (chk5 == true) {
	                    for (var j = 0; j < k; j++) {
	                      Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
	                      var model55 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                      var chk55 = model55.data.CHK;
	                      var itemcode55 = model55.data.ITEMCODE;
	                      var postqty55 = model55.data.POSTQTY;

	                      if (chk55 == true) {
	                        if (itemcode5 == itemcode55) {
	                          if (postqty5 == postqty55) {}
	                          else {
	                            notCnt++;
	                          }
	                        } else {
	                          notCnt++;
	                        }
	                      }

	                      if (chk == true) {
	                        checknum++;
	                      }
	                    }
	                  }
	                }
	              }

	              var itemCode = $('#ItemCode').val();
	              var lotQty = $('#LotQty').val();

	              if (itemCode != "") {
	                for (var m = 0; m < count5; m++) {
	                  Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(m));
	                  var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                  var chk = model4.data.CHK;
	                  var itemcode4 = model4.data.ITEMCODE;
	                  var postqty4 = model4.data.POSTQTY;

	                  if (chk == true) {
	                    if (itemcode4 == itemCode) {
	                      if (postqty4 == lotQty) {}
	                      else {
	                        notCnt++;
	                      }
	                    } else {
	                      notCnt++;
	                    }
	                  }
	                }
	              }

	              if (notCnt > 0) {
	                extAlert("같은 제품의 같은 생산수량의 데이터만 적용할 수 있습니다.<br/>다시 한번 확인해주십시오.");
	                return false;
	              }

	              if (count > 0) {
	                for (var o = 0; o < count; o++) {
	                  Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(o));
	                  var model1 = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
	                  var outtransno1 = model1.data.OUTTRANSNO;
	                  var outtransseq1 = model1.data.OUTTRANSSEQ;

	                  for (var p = 0; p < count5; p++) {
	                    Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(p));
	                    var model55 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                    var chk55 = model55.data.CHK;
	                    if (chk55 == true) {
	                      var outtransno55 = model55.data.OUTTRANSNO;
	                      var outtransseq55 = model55.data.OUTTRANSSEQ;
	                      if (outtransno1 == outtransno55) {
	                        if (outtransseq1 == outtransseq55) {
	                          outTransCnt++;
	                        }
	                      }
	                    }
	                  }
	                }
	              }

	              if (outTransCnt > 0) {
	                extAlert("해당 입고번호의 중복된 입고순번이 이미 존재합니다.<br/>다시 한번 확인해주십시오.");
	                return false;
	              }

	              console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	              if (checknum == 0) {
	                extAlert("선택 된 제품이 없습니다.<br/>다시 한번 확인해주십시오.");
	                return false;
	              }

	              if (count5 == 0) {
	                console.log("[적용] 제품 정보가 없습니다.");
	              } else {
	                for (var j = 0; j < count5; j++) {
	                  Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
	                  var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                  var chk = model4.data.CHK;
	                  if (chk === true) {
	                    var model = Ext.create(gridnms["model.1"]);
	                    var store = Ext.getStore(gridnms["store.1"]);

	                    // 순번
	                    model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);
	                    model.set("LOTSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

	                    // 팝업창의 체크된 항목 이동
	                    model.set("ITEMCODE", model4.data.ITEMCODE);
	                    model.set("OUTTRANSNO", model4.data.OUTTRANSNO);
	                    model.set("OUTTRANSSEQ", model4.data.OUTTRANSSEQ);
	                    model.set("ROUTINGNAME", model4.data.ROUTINGNAME);
	                    model.set("TRANSQTY", model4.data.TRANSQTY);
	                    model.set("PASSQTY", model4.data.POSTQTY);
	                    model.set("LOTQTY", model4.data.POSTQTY);
	                    $('#CustomerCode').val(model4.data.CUSTOMERCODE);
	                    $('#CustomerName').val(model4.data.CUSTOMERNAME);
	                    $('#ItemCode').val(model4.data.ITEMCODE);
	                    $('#ItemName').val(model4.data.ITEMNAME);
	                    $('#OrderName').val(model4.data.ORDERNAME);
	                    $('#UomName').val(model4.data.UOMNAME);
	                    $('#Uom').val(model4.data.UOM);
	                    $('#ItemStandard').val(model4.data.ITEMSTANDARD);
	                    $('#MaterialType').val(model4.data.MATERIALTYPE);
	                    var oldqty = 0; //$('#LotQty').val();
	                    var newqty = model4.data.POSTQTY;
	                    var lotqty = oldqty * 1 + newqty * 1;
	                    $('#LotQty').val(lotqty);
	                    $('#temp1').val(lotqty);
	                    $('#InputQty').val(lotqty);

	                    fn_qty_change();

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
	                win1.close();

	                $("#gridPopup1Area").hide("blind", {
	                  direction: "up"
	                }, "fast");
	              }
	            }
	          }
	        ]
	      });

	    win1.show();

	    var sparams1 = {
	      ORGID: $('#popupOrgId').val(),
	      COMPANYID: $('#popupCompanyId').val(),
	      BIGCD: "CMM",
	      MIDDLECD: "ITEM_TYPE",
	    };

	  } else {
	    extAlert("입고 검사 등록 하실 경우에만 입하정보 불러오기가 가능합니다.");
	    return;
	  }
	}

	//   LOT 발행 list (미발행 입하정보) 도료품
	function btnSel11(btn) {
	  var LotNo = $('#LotNo').val();
	  var LotDate = $('#LotDate').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (LotNo !== "") {
	    header.push("외주공정 Lot 번호");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[검색 조건 확인]<br/>" + header + "가 이미 등록 되어져 있습니다.<br/>새로 추가 하여 등록 하시거나 기존 데이터 삭제 후 재 등록 하시기 바랍니다.");
	    return false;
	  }

	  // 팝업
	  var width = 1208; // 가로
	  var height = 640; // 500; // 세로
	  var title = "Lot 발행 예정 LIST(도료)";

	  var status = $('#Status').val();
	  var check = false;

	  if (status === "") {
	    // 제품선택 팝업표시 여부
	    check = true;
	  } else if (status == "STAND_BY") {
	    // 제품선택 팝업표시 여부
	    check = true;
	  } else if (status == "COMPLETE") {
	    // 완료시 팝업표시 여부
	    check = false;
	  } else {
	    check = true;
	  }

	  popupclick = 0;
	  if (check == true) {
	    // 완료 외 상태에서만 팝업 표시하도록 처리
	    $('#popupOrgId').val($('#searchOrgId option:selected').val());
	    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	    $('#popupTransFrom').val("");
	    $('#popupTransTo').val("");
	    $('#popupTransNo').val("");
	    $('#popupTransSeq').val("");
	    $('#popupItemCode').val("");
	    $('#popupCheckBig').val("I");
	    Ext.getStore(gridnms['store.44']).removeAll();

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
	            itemId: gridnms["panel.44"],
	            id: gridnms["panel.44"],
	            store: gridnms["store.44"],
	            height: '100%',
	            border: 2,
	            scrollable: true,
	            frameHeader: true,
	            columns: fields["columns.44"],
	            viewConfig: {
	              itemId: 'btnPopup11'
	            },
	            plugins: 'bufferedrenderer',
	            dockedItems: items["docked.44"],
	          }
	        ],
	        tbar: [
	          '기간', {
	            xtype: 'datefield',
	            enforceMaxLength: true,
	            maxLength: 10,
	            allowBlank: true,
	            format: 'Y-m-d',
	            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	            align: 'center',
	            width: 100,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              select: function (value, record) {
	                $('#popupTransFrom').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
	              },
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                if (nv !== ov) {
	                  if (result === "") {
	                    $('#popupTransFrom').val("");
	                  } else {
	                    var popupTransFrom = Ext.Date.format(result, 'Y-m-d');
	                    var popupTransTo = $('#popupTransTo').val();

	                    if (popupTransTo === "") {
	                      $('#popupTransFrom').val(Ext.Date.format(result, 'Y-m-d'));
	                    } else {
	                      var diff = 0;
	                      diff = fn_calc_diff(popupTransFrom, popupTransTo);
	                      if (diff < 0) {
	                        extAlert("이전 날짜가 이후 날짜보다 큽니다.<br/>다시 한번 확인해주십시오.");
	                        value.setValue("");
	                        $('#popupTransFrom').val("");
	                        return;
	                      } else {
	                        $('#popupTransFrom').val(Ext.Date.format(result, 'Y-m-d'));
	                      }
	                    }
	                  }
	                }
	              },
	            },
	            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	          }, ' ~ ', {
	            xtype: 'datefield',
	            enforceMaxLength: true,
	            maxLength: 10,
	            allowBlank: true,
	            format: 'Y-m-d',
	            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	            width: 100,
	            align: 'center',
	            listeners: {
	              scope: this,
	              buffer: 50,
	              select: function (value, record) {
	                $('#popupTransTo').val(Ext.Date.format(value.getValue(), 'Y-m-d'));
	              },
	              change: function (value, nv, ov, e) {
	                var result = value.getValue();

	                if (nv !== ov) {
	                  if (result === "") {
	                    $('#popupTransTo').val("");
	                  } else {
	                    var popupTransFrom = $('#popupTransFrom').val();
	                    var popupTransTo = Ext.Date.format(result, 'Y-m-d');

	                    if (popupTransFrom === "") {
	                      $('#popupTransTo').val(Ext.Date.format(result, 'Y-m-d'));
	                    } else {
	                      var diff = 0;
	                      diff = fn_calc_diff(popupTransFrom, popupTransTo);
	                      if (diff < 0) {
	                        extAlert("이후 날짜가 이전 날짜보다 작습니다.<br/>다시 한번 확인해주십시오.");
	                        value.setValue("");
	                        $('#popupTransTo').val("");
	                        return;
	                      } else {
	                        $('#popupTransTo').val(Ext.Date.format(result, 'Y-m-d'));
	                      }
	                    }
	                  }
	                }
	              },
	            },
	            renderer: Ext.util.Format.dateRenderer('Y-m-d'),
	          },
	          '품번', {
	            xtype: 'textfield',
	            name: 'searchOrderName1',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 100,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              change: function (value, nv, ov, e) {
	                value.setValue(nv.toUpperCase());
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
	            width: 140,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              change: function (value, nv, ov, e) {
	                value.setValue(nv.toUpperCase());
	                var result = value.getValue();

	                $('#popupItemName').val(result);
	              },
	            },
	          }, '->', {
	            text: '조회',
	            scope: this,
	            handler: function () {
	              var sparams33 = {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                TRANSFROM: $('#popupTransFrom').val(),
	                TRANSTO: $('#popupTransTo').val(),
	                TRANSNO: $('#popupTransNo').val(),
	                ITEMCODE: $('#popupItemCode').val(),
	                ITEMNAME: $('#popupItemName').val(),
	                ORDERNAME: $('#popupOrderName').val(),
	                MODELNAME: $('#popupModelName').val(),

	              };

	              extGridSearch(sparams33, gridnms["store.44"]);
	            }
	          }, {
	            text: '적용',
	            scope: this,
	            handler: function () {
	              // 전체등록 Pop up 적용 버튼 핸들러
	              var count = Ext.getStore(gridnms["store.1"]).count();
	              var count44 = Ext.getStore(gridnms["store.44"]).count();
	              var checknum = 0,
	              checkqty = 0,
	              checktemp = 0;
	              var qtytemp = [];

	              for (var i = 0; i < count44; i++) {
	                Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(i));
	                var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];
	                var chk = model44.get("CHK");

	                if (chk == true) {
	                  checknum++;
	                }
	              }
	              console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	              if (checknum == 0) {
	                extAlert("입하정보를 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
	                return false;
	              }

	              if (count44 == 0) {
	                console.log("[적용] 입하정보가 없습니다.");
	              } else {

	                $('#LotQty').val(0); // 최초 값 설정
	                for (var j = 0; j < count44; j++) {
	                  Ext.getStore(gridnms["store.44"]).getById(Ext.getCmp(gridnms["views.popup11"]).getSelectionModel().select(j));
	                  var model44 = Ext.getCmp(gridnms["views.popup11"]).selModel.getSelection()[0];
	                  var chk = model44.data.CHK;

	                  if (chk === true) {
	                    var model = Ext.create(gridnms["model.1"]);
	                    var store = Ext.getStore(gridnms["store.1"]);

	                    // 순번
	                    model.set("LOTSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

	                    // 팝업창의 체크된 항목 이동
	                    model.set("ITEMCODE", model44.data.ITEMCODE);
	                    model.set("TRANSNO", model44.data.TRANSNO);
	                    model.set("TRANSSEQ", model44.data.TRANSSEQ);
	                    model.set("TRANSQTY", model44.data.TRANSQTY);
	                    model.set("PASSQTY", model44.data.PASSQTY);
	                    model.set("LOTQTY", model44.data.LOTQTY);
	                    $('#ItemCode').val(model44.data.ITEMCODE);
	                    $('#ItemName').val(model44.data.ITEMNAME);
	                    $('#OrderName').val(model44.data.ORDERNAME);
	                    $('#UomName').val(model44.data.UOMNAME);
	                    $('#Uom').val(model44.data.UOM);
	                    $('#ItemStandard').val(model44.data.ITEMSTANDARD);
	                    $('#MaterialType').val(model44.data.MATERIALTYPE);
	                    var oldqty = $('#LotQty').val();
	                    var newqty = model44.data.LOTQTY;
	                    var lotqty = oldqty * 1 + newqty * 1;
	                    $('#LotQty').val(lotqty);
	                    $('#temp1').val(lotqty)

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
	                win11.close();

	                $("#gridPopup11Area").hide("blind", {
	                  direction: "up"
	                }, "fast");
	              }
	            }
	          }
	        ]
	      });

	    win11.show();

	    var sparams11 = {
	      ORGID: $('#popupOrgId').val(),
	      COMPANYID: $('#popupCompanyId').val(),
	      BIGCD: "CMM",
	      MIDDLECD: "ITEM_TYPE",
	    };

	  } else {
	    extAlert("입고 검사 등록 하실 경우에만 입하정보 불러오기가 가능합니다.");
	    return;
	  }
	}

	function btnDel1() {
	  var store = this.getStore(gridnms["store.1"]);
	  var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
	  var lotno = $('#LotNo').val();
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();

	  if (record === undefined) {
	    return;
	  }

	  Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
// 	      store.remove(record);
// 	      Ext.getStore(gridnms["store.1"]).sync();

// 	      extAlert("정상적으로 삭제 하였습니다.");

        var url = "<c:url value='/delete/scm/outprocess/OutProcLotRegistD.do' />";

				$.ajax({
				  url: url,
				  type: "post",
				  dataType: "json",
				  data: record.data,
				  success: function (data) {
				    var msg = data.masage;
				    extAlert(msg);
				
				    var returnstatus = data.success;
				    if (returnstatus) {
					    setInterval(function () {
					      go_url("<c:url value='/scm/outprocess/OutProcLotRegistD.do?no=' />" + lotno + "&org=" + orgid + "&company=" + companyid);
					    }, 1 * 0.3 * 1000);
				    }
				  },
				  error: ajaxError
				});
	    }
	  });
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
	              extraParams: {
	                LOTNO: "${searchVO.LOTNO}",
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
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
	      btnList: '#btnList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    // 2016.07.27 추가 제외, 제품선택 (팝업창) 추가
	    btnDel1: btnDel1,
	    btnSel1: btnSel1,
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
	        height: 558,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        viewConfig: {
	          itemId: 'btnList',
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ROUTINGNAME') >= 0) {
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
	        bufferedRenderer: false,
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = ctx.record;

	                var editDisableCols = [];
	                var status = data.data.LOTNNO;
	                if (status != "") {
	                  editDisableCols.push("LOTQTY");
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
	    models: gridnms["models.detail"],
	    stores: gridnms["stores.detail"],
	    views: gridnms["views.detail"],
	    controllers: gridnms["controller.1"],

	    launch: function () {
	      gridarea = Ext.create(gridnms["views.detail"], {
	          renderTo: 'gridDetailArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	// 팝업
	function setValues_Popup() {
	  gridnms["models.popup1"] = [];
	  gridnms["stores.popup1"] = [];
	  gridnms["views.popup1"] = [];
	  gridnms["controllers.popup1"] = [];

	  gridnms["grid.4"] = "Popup1";
	  gridnms["grid.5"] = "SetBigCodeLov"; // 팝업 조회 대분류
	  gridnms["grid.6"] = "SetMiddleCodeLov"; // 팝업 조회 중분류
	  gridnms["grid.7"] = "SetSmallCodeLov"; // 팝업 조회 소분류
	  gridnms["grid.8"] = "SetItemTypeLov"; // 팝업 조회 유형
	  gridnms["grid.21"] = "SetItemTransNo"; // 팝업 조회 입하번호

	  gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
	  gridnms["views.popup1"].push(gridnms["panel.4"]);

	  gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
	  gridnms["controllers.popup1"].push(gridnms["controller.4"]);

	  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];
	  gridnms["model.5"] = gridnms["app"] + ".model." + gridnms["grid.5"];
	  gridnms["model.6"] = gridnms["app"] + ".model." + gridnms["grid.6"];
	  gridnms["model.7"] = gridnms["app"] + ".model." + gridnms["grid.7"];
	  gridnms["model.8"] = gridnms["app"] + ".model." + gridnms["grid.8"];
	  gridnms["model.21"] = gridnms["app"] + ".model." + gridnms["grid.21"];

	  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];
	  gridnms["store.5"] = gridnms["app"] + ".store." + gridnms["grid.5"];
	  gridnms["store.6"] = gridnms["app"] + ".store." + gridnms["grid.6"];
	  gridnms["store.7"] = gridnms["app"] + ".store." + gridnms["grid.7"];
	  gridnms["store.8"] = gridnms["app"] + ".store." + gridnms["grid.8"];
	  gridnms["store.21"] = gridnms["app"] + ".store." + gridnms["grid.21"];

	  gridnms["models.popup1"].push(gridnms["model.4"]);
	  gridnms["models.popup1"].push(gridnms["model.5"]);
	  gridnms["models.popup1"].push(gridnms["model.6"]);
	  gridnms["models.popup1"].push(gridnms["model.7"]);
	  gridnms["models.popup1"].push(gridnms["model.8"]);
	  gridnms["models.popup1"].push(gridnms["model.21"]);

	  gridnms["stores.popup1"].push(gridnms["store.4"]);
	  gridnms["stores.popup1"].push(gridnms["store.5"]);
	  gridnms["stores.popup1"].push(gridnms["store.6"]);
	  gridnms["stores.popup1"].push(gridnms["store.7"]);
	  gridnms["stores.popup1"].push(gridnms["store.8"]);
	  gridnms["stores.popup1"].push(gridnms["store.21"]);

	  fields["model.4"] = [{
	      type: 'number',
	      name: 'RN',
	    }, {
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMAPNYID',
	    }, {
	      type: 'string',
	      name: 'OUTTRANSNO',
	    }, {
	      type: 'number',
	      name: 'OUTTRANSSEQ',
	    }, {
	      type: 'date',
	      name: 'OUTTRANSDATE',
	      dateFormat: 'Y-m-d'
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
	      name: 'ITEMSTANDARD',
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
	      type: 'number',
	      name: 'ORDERQTY',
	    }, {
	      type: 'number',
	      name: 'TRANSQTY',
	    }, {
	      type: 'number',
	      name: 'AFTERQTY',
	    }, {
	      type: 'number',
	      name: 'POSTQTY',
	    }, {
	      type: 'number',
	      name: 'TRANSUNITPRICE',
	    }, {
	      type: 'number',
	      name: 'SUPPLYPRICE',
	    }, {
	      type: 'number',
	      name: 'ADDITIONALTAX',
	    }, {
	      type: 'number',
	      name: 'TOTAL',
	    },
	  ];

	  fields["model.5"] = [{
	      type: 'string',
	      name: 'ID',
	    }, {
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["model.6"] = [{
	      type: 'string',
	      name: 'ID',
	    }, {
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["model.7"] = [{
	      type: 'string',
	      name: 'ID',
	    }, {
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["model.8"] = [{
	      type: 'string',
	      name: 'ID',
	    }, {
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["model.21"] = [{
	      type: 'string',
	      name: 'ID',
	    }, {
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["columns.4"] = [{
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
	    }, {
	      dataIndex: 'OUTTRANSNO',
	      text: '입고번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'OUTTRANSSEQ',
	      text: '입고<br/>순번',
	      xtype: 'gridcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'OUTTRANSDATE',
	      text: '입고일',
	      xtype: 'datecolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
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
	      width: 280,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'ROUTINGNAME',
	      text: '공정명',
	      xtype: 'gridcolumn',
	      width: 140,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'ORDERQTY',
	      text: '발주수량',
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
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'TRANSQTY',
	      text: '입고수량',
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
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'AFTERQTY',
	      text: '기생산수량',
	      xtype: 'gridcolumn',
	      width: 110,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'POSTQTY',
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
	      renderer: Ext.util.Format.numberRenderer('0,000'),
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
	    //      }, {
	    //        menuDisabled: true,
	    //        sortable: false,
	    //        resizable: false,
	    //        xtype: 'widgetcolumn',
	    //        stopSelection: true,
	    //        width: 70,
	    //        text: '적용',
	    //        style: 'text-align:center',
	    //        align: "center",
	    //        resizable: false,
	    //        widget: {
	    //          xtype: 'button',
	    //          _btnText: "적용",
	    //          defaultBindProperty: null, //important
	    //          handler: function (widgetColumn) {
	    //            var record = widgetColumn.getWidgetRecord();

	    //            var count = Ext.getStore(gridnms["store.1"]).count();
	    //            var count4 = Ext.getStore(gridnms["store.4"]).count();
	    //            var checknum = 0,
	    //            checkqty = 0,
	    //            checktemp = 0;
	    //            var qtytemp = [];

	    //            if (count4 == 0) {
	    //              console.log("[적용] 입하정보가 없습니다.");
	    //            } else {

	    //              $('#LotQty').val(0); // 최초 값 설정
	    //              var chk = true;

	    //              if (chk === true) {
	    //                var model = Ext.create(gridnms["model.1"]);
	    //                var store = Ext.getStore(gridnms["store.1"]);

	    //                // 순번
	    //                model.set("RN", Ext.getStore(gridnms["store.1"]).count() + 1);
	    //                model.set("LOTSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

	    //                // 팝업창의 체크된 항목 이동
	    //                model.set("ITEMCODE", record.data.ITEMCODE);
	    //                model.set("OUTTRANSNO", record.data.OUTTRANSNO);
	    //                model.set("OUTTRANSSEQ", record.data.OUTTRANSSEQ);
	    //                model.set("ROUTINGNAME", record.data.ROUTINGNAME);
	    //                model.set("TRANSQTY", record.data.TRANSQTY);
	    //                model.set("PASSQTY", record.data.POSTQTY);
	    //                model.set("LOTQTY", record.data.POSTQTY);
	    //                $('#CustomerCode').val(record.data.CUSTOMERCODE);
	    //                $('#CustomerName').val(record.data.CUSTOMERNAME);
	    //                $('#ItemCode').val(record.data.ITEMCODE);
	    //                $('#ItemName').val(record.data.ITEMNAME);
	    //                $('#OrderName').val(record.data.ORDERNAME);
	    //                $('#UomName').val(record.data.UOMNAME);
	    //                $('#Uom').val(record.data.UOM);
	    //                $('#ItemStandard').val(record.data.ITEMSTANDARD);
	    //                $('#MaterialType').val(record.data.MATERIALTYPE);
	    //                var oldqty = $('#LotQty').val();
	    //                var newqty = record.data.POSTQTY;
	    //                var lotqty = oldqty * 1 + newqty * 1;
	    //                $('#LotQty').val(lotqty);
	    //                $('#temp1').val(lotqty);

	    //                $('#InputQty').val(lotqty);

	    //                fn_qty_change();

	    //                // 그리드 적용 방식
	    //                store.add(model);

	    //                checktemp++;
	    //                popcount++;
	    //              };

	    //              Ext.getCmp(gridnms["panel.1"]).getView().refresh();

	    //            }

	    //            if (checktemp > 0) {
	    //              popcount = 0;
	    //              win1.close();

	    //              $("#gridPopup1Area").hide("blind", {
	    //                direction: "up"
	    //              }, "fast");
	    //            }
	    //          },
	    //          listeners: {
	    //            beforerender: function (widgetColumn) {
	    //              var record = widgetColumn.getWidgetRecord();
	    //              widgetColumn.setText(widgetColumn._btnText); // _btnText 문구를 위젯컬럼에서 선언해주는 기능
	    //            }
	    //          }
	    //        }
	    //      },
	    // Hidden Columns
	    {
	      dataIndex: 'ORGID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'COMPANYID',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MATERIALTYPE',
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
	      dataIndex: 'UOMNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, ];

	  items["api.4"] = {};
	  $.extend(items["api.4"], {
	    read: "<c:url value='/ListPop/scm/outprocess/OutProcLotRegist.do' />"
	  });

	  items["btns.4"] = [];

	  items["btns.ctr.4"] = {};
	  //    $.extend(items["btns.ctr.4"], {
	  //      "#btnPopup1": {
	  //        itemclick: 'onMypopClick'
	  //      }
	  //    });

	  items["dock.paging.4"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.4"],
	  };

	  items["dock.btn.4"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.4"],
	    items: items["btns.4"],
	  };

	  items["docked.4"] = [];

	}

	// LOT 발행예정 리스트(도료)
	function setValues_Popup1() {
	  gridnms["models.popup11"] = [];
	  gridnms["stores.popup11"] = [];
	  gridnms["views.popup11"] = [];
	  gridnms["controllers.popup11"] = [];

	  gridnms["grid.44"] = "Popup11";

	  gridnms["panel.44"] = gridnms["app"] + ".view." + gridnms["grid.44"];
	  gridnms["views.popup11"].push(gridnms["panel.44"]);

	  gridnms["controller.44"] = gridnms["app"] + ".controller." + gridnms["grid.44"];
	  gridnms["controllers.popup11"].push(gridnms["controller.44"]);

	  gridnms["model.44"] = gridnms["app"] + ".model." + gridnms["grid.44"];
	  gridnms["store.44"] = gridnms["app"] + ".store." + gridnms["grid.44"];

	  gridnms["models.popup11"].push(gridnms["model.44"]);

	  gridnms["stores.popup11"].push(gridnms["store.44"]);

	  fields["model.44"] = [{
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
	      name: 'TRANSNO',
	    }, {
	      type: 'string',
	      name: 'TRANSSEQ',
	    }, {
	      type: 'string',
	      name: 'TRANSDATE',
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
	      name: 'ITEMTYPE',
	    }, {
	      type: 'string',
	      name: 'UOM',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'string',
	      name: 'MODEL',
	    }, {
	      type: 'string',
	      name: 'MODELNAME',
	    }, {
	      type: 'number',
	      name: 'TRANSQTY',
	    }, {
	      type: 'number',
	      name: 'PASSQTY',
	    }, {
	      type: 'number',
	      name: 'CHKQTY',
	    }, {
	      type: 'number',
	      name: 'LOTQTY',
	    },
	  ];

	  fields["columns.44"] = [{
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
	    }, {
	      dataIndex: 'TRANSNO',
	      text: '입하번호',
	      xtype: 'gridcolumn',
	      width: 120,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'TRANSSEQ',
	      text: '입하<br/>순번',
	      xtype: 'gridcolumn',
	      width: 50,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'TRANSDATE',
	      text: '입하일',
	      xtype: 'datecolumn',
	      width: 90,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      format: 'Y-m-d',
	    }, {
	      dataIndex: 'MODELNAME',
	      text: '기종',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
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
	      align: "left",
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
	      dataIndex: 'TRANSQTY',
	      text: '입하수량',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'CHKQTY',
	      text: '기투입수량',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
	    }, {
	      dataIndex: 'LOTQTY',
	      text: '투입수량',
	      xtype: 'gridcolumn',
	      width: 75,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "right",
	      cls: 'ERPQTY',
	      format: "0,000",
	      renderer: Ext.util.Format.numberRenderer('0,000'),
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
	      dataIndex: 'UOM',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'MODEL',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMTYPE',
	      xtype: 'hidden',
	    }, ];

	  items["api.44"] = {};
	  $.extend(items["api.44"], {
	    read: "<c:url value='/MatReceiveLotRegistLotPop1.do' />"
	  });

	  items["btns.44"] = [];

	  items["btns.ctr.44"] = {};
	  //    $.extend(items["btns.ctr.44"], {
	  //      "#btnPopup11": {
	  //        itemclick: 'onMypopClick1'
	  //      }
	  //    });

	  items["dock.paging.44"] = {
	    xtype: 'pagingtoolbar',
	    dock: 'bottom',
	    displayInfo: true,
	    store: gridnms["store.44"],
	  };

	  items["dock.btn.44"] = {
	    xtype: 'toolbar',
	    dock: 'top',
	    displayInfo: true,
	    store: gridnms["store.44"],
	    items: items["btns.44"],
	  };

	  items["docked.44"] = [];

	}

	var gridpopup1, gridpopup11;
	function setExtGrid_Popup() {

	  Ext.define(gridnms["model.4"], {
	    extend: Ext.data.Model,
	    fields: fields["model.4"],
	  });

	  Ext.define(gridnms["model.5"], {
	    extend: Ext.data.Model,
	    fields: fields["model.5"],
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

	  Ext.define(gridnms["model.21"], {
	    extend: Ext.data.Model,
	    fields: fields["model.21"],
	  });

	  Ext.define(gridnms["store.4"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.4"],
	            model: gridnms["model.4"],
	            autoLoad: true,
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.4"],
	              extraParams: {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	              },
	              reader: gridVals.reader,
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
	              type: "ajax",
	              url: "<c:url value='/searchBigClassListLov.do' />",
	              extraParams: {
	                GROUPCODE: $('#popupGroupCode').val(),
	                GUBUN: 'BIG_CODE',
	              },
	              reader: gridVals.reader,
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
	              url: "<c:url value='/searchMiddleClassListLov.do' />",
	              extraParams: {
	                GROUPCODE: $('#popupGroupCode').val(),
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
	              url: "<c:url value='/searchSmallClassListLov.do' />",
	              extraParams: {
	                GROUPCODE: $('#popupGroupCode').val(),
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
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                BIGCD: "CMM",
	                MIDDLECD: "ITEM_TYPE"
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["store.21"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.21"],
	            model: gridnms["model.21"],
	            autoLoad: true,
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: "ajax",
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              extraParams: {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.4"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnPopup1: '#btnPopup1',
	    },
	    stores: [gridnms["store.4"]],
	    control: items["btns.ctr.4"],
	  });

	  Ext.define(gridnms["panel.4"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.4"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.4"],
	        id: gridnms["panel.4"],
	        store: gridnms["store.4"],
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
	        columns: fields["columns.4"],
	        viewConfig: {
	          itemId: 'btnPopup1',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.4"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup1"],
	    stores: gridnms["stores.popup1"],
	    views: gridnms["views.popup1"],
	    controllers: gridnms["controller.4"],

	    launch: function () {
	      gridpopup1 = Ext.create(gridnms["views.popup1"], {
	          renderTo: 'gridPopup1Area'
	        });
	    },
	  });

	}

	function setExtGrid_Popup1() {

	  Ext.define(gridnms["model.44"], {
	    extend: Ext.data.Model,
	    fields: fields["model.44"],
	  });

	  Ext.define(gridnms["store.44"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.44"],
	            model: gridnms["model.44"],
	            autoLoad: true,
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.44"],
	              extraParams: {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.44"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnPopup1: '#btnPopup11',
	    },
	    stores: [gridnms["store.44"]],
	    control: items["btns.ctr.44"],
	  });

	  Ext.define(gridnms["panel.44"], {
	    extend: Ext.panel.Panel,
	    alias: 'widget.' + gridnms["panel.44"],
	    layout: 'fit',
	    header: false,
	    items: [{
	        xtype: 'gridpanel',
	        selType: 'cellmodel',
	        itemId: gridnms["panel.44"],
	        id: gridnms["panel.44"],
	        store: gridnms["store.44"],
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
	        columns: fields["columns.44"],
	        viewConfig: {
	          itemId: 'btnPopup11',
	          trackOver: true,
	          loadMask: true,
	        },
	        dockedItems: items["docked.44"],
	      }
	    ],
	  });

	  Ext.application({
	    name: gridnms["app"],
	    models: gridnms["models.popup11"],
	    stores: gridnms["stores.popup11"],
	    views: gridnms["views.popup11"],
	    controllers: gridnms["controller.44"],

	    launch: function () {
	      gridpopup1 = Ext.create(gridnms["views.popup11"], {
	          renderTo: 'gridPopup11Area'
	        });
	    },
	  });

	}

	function fn_save() {
	  // 필수 체크
	  var LotDate = $('#LotDate').val();
	  var ItemCode = $('#ItemCode').val();
	  var customercode = $('#CustomerCode').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (LotDate === "") {
	    header.push("생성일");
	    count++;
	  }
	  if (ItemCode === "") {
	    header.push("품명");
	    count++;
	  }
	  if (customercode === "") {
	    header.push("가공처");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return false;
	  }

	  // 저장
	  var lotno = $('#LotNo').val();
	  var OrgId = $('#searchOrgId option:selected').val();
	  var CompanyId = $('#searchCompanyId option:selected').val();
	  var isNew = lotno.length === 0;
	  var url = "",
	  url1 = "",
	  msgGubun = 0;
	  var statuschk = true;

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();

	  if (gridcount == 0) {
	    extAlert("[상세 미등록]<br/> 상세 데이터가 등록되지 않았습니다.");
	    return false;
	  }

	  if (isNew) {
	    url = "<c:url value='/insert/scm/outprocess/OutProcLotRegist.do' />";
	    url1 = "<c:url value='/insert/scm/outprocess/OutProcLotRegistD.do' />";
	    msgGubun = 1;
	  } else {
	    url = "<c:url value='/update/scm/outprocess/OutProcLotRegist.do' />";
	    url1 = "<c:url value='/update/scm/outprocess/OutProcLotRegistD.do' />";
	    msgGubun = 2;
	  }

	  if (msgGubun == 1) {
	    Ext.MessageBox.confirm('알림', '저장 하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        var params = [];
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: $("#master").serialize(),
	          success: function (data) {
	            var lotno = data.LOTNO;
	            var orgid = data.searchOrgId;
	            var companyid = data.searchCompanyId;

	            if (lotno.length == 0) {
	              //   안되었을 때 로직 추가
	            } else {
	              //   정상적으로 되었으면
	              var recount = Ext.getStore(gridnms["store.1"]).count();

	              for (var i = 0; i < recount; i++) {
	                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

	                model.set("LOTNO", lotno);
	                model.set("ORGID", orgid);
	                model.set("COMPANYID", companyid);

	                if (model.get("LOTNO") != '') {
	                  params.push(model.data);
	                }
	              }
	              dataSuccess = 1;

	              if (params.length > 0) {
	                Ext.Ajax.request({
	                  url: url1,
	                  method: 'POST',
	                  headers: {
	                    'Content-Type': 'application/json'
	                  },
	                  jsonData: {
	                    data: params
	                  },
	                  success: function (conn, response, options, eOpts) {
	                    if (msgGubun == 1) {
	                      msg = "정상적으로 저장 하였습니다.";
	                    } else if (msgGubun == 2) {
	                      msg = "내역이 변경되었습니다.";
	                    }
	                    statuschk = true;

	                    extAlert(msg);
	                    dataSuccess = 1;

	                    if (dataSuccess > 0) {
	                      //                          setInterval(function () {
	                      go_url("<c:url value='/scm/outprocess/OutProcLotRegistD.do?no=' />" + lotno + "&org=" + orgid + "&company=" + companyid);
	                      //                          }, 1 * 0.5 * 1000);
	                    }
	                  },
	                  error: ajaxError
	                });
	              }
	            }
	          },
	          error: ajaxError
	        });
	      } else {
	        Ext.Msg.alert('외주공정 lot 바코드 생성', '외주공정 lot 바코드 생성이 취소되었습니다.');
	        $('#Status').val($('#StatusTemp').val());
	        return;
	      }
	    });
	  } else if (msgGubun == 2) {

	    Ext.MessageBox.confirm('외주공정 lot 바코드 생성 변경 알림', '외주공정 lot 바코드 생성을 변경하시겠습니까?', function (btn) {
	      if (btn == 'yes') {

	        var params = [];
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: $("#master").serialize(),
	          success: function (data) {
	            var lotno = data.LotNo;
	            var orgid = data.searchOrgId;
	            var companyid = data.searchCompanyId;

	            if (lotno.length == 0) {
	              //  생성이 안되었을 때 로직 추가
	            } else {
	              //  정상적으로 생성이 되었으면
	              var recount = Ext.getStore(gridnms["store.1"]).count();

	              for (var i = 0; i < recount; i++) {
	                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

	                model.set("LOTNO", lotno);
	                model.set("ORGID", orgid);
	                model.set("COMPANYID", companyid);
	                if (model.get("LOTNO") != '') {
	                  params.push(model.data);

	                }
	              }
	              dataSuccess = 1;

	              if (params.length > 0) {
	                Ext.Ajax.request({
	                  url: url1,
	                  method: 'POST',
	                  headers: {
	                    'Content-Type': 'application/json'
	                  },
	                  jsonData: {
	                    data: params
	                  },
	                  success: function (conn, response, options, eOpts) {
	                    if (msgGubun == 1) {
	                      msg = "정상적으로 저장 하였습니다.";
	                    } else if (msgGubun == 2) {
	                      msg = "내역이 변경되었습니다.";
	                    }
	                    statuschk = true;

	                    extAlert(msg);
	                    dataSuccess = 1;

	                    if (dataSuccess > 0) {
	                      //                          setInterval(function () {
	                      go_url("<c:url value='/scm/outprocess/OutProcLotRegistD.do?no=' />" + lotno + "&org=" + orgid + "&company=" + companyid);
	                      //                          }, 1 * 0.5 * 1000);
	                    }
	                  },
	                  error: ajaxError
	                });
	              }
	            }
	          },
	          error: ajaxError
	        });
	      } else {
	        Ext.Msg.alert('변경', '변경이 취소되었습니다.');
	        return;
	      }
	    });
	  }
	}
	function fn_create() {
	  // 필수 체크
	  var LotDate = $('#LotDate').val();
	  var ItemCode = $('#ItemCode').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (LotDate === "") {
	    header.push("생성일");
	    count++;
	  }
	  if (ItemCode === "") {
	    header.push("품명");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + "을 입력해주세요.");
	    return false;
	  }

	  // 저장
	  var lotno = $('#LotNo').val();
	  var OrgId = $('#searchOrgId option:selected').val();
	  var CompanyId = $('#searchCompanyId option:selected').val();
	  var isNew = lotno.length === 0;
	  var url = "",
	  url1 = "",
	  msgGubun = 0;
	  var statuschk = true;

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();

	  if (gridcount == 0) {
	    extAlert("[상세 미등록]<br/> 상세 데이터가 등록되지 않았습니다.");
	    return false;
	  }

	  if (isNew) {
	    url = "<c:url value='/insert/scm/outprocess/OutProcLotRegist.do' />";
	    url1 = "<c:url value='/insert/scm/outprocess/OutProcLotRegistD.do' />";
	    msgGubun = 1;
	  } else {
	    extAlert("[바코드 생성]<br/> 이미 외주공정 LOT 가 생성 되어져 있습니다.");
	    return false;
	  }

	  if (msgGubun == 1) {
	    Ext.MessageBox.confirm('알림', '외주공정 LOT 바코드를 생성 하시겠습니까?', function (btn) {
	      if (btn == 'yes') {

	        var params = [];
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: $("#master").serialize(),
	          success: function (data) {
	            var lotno = data.LOTNO;
	            var orgid = data.searchOrgId;
	            var companyid = data.searchCompanyId;

	            if (lotno.length == 0) {
	              //   안되었을 때 로직 추가
	            } else {
	              //   정상적으로 되었으면
	              var recount = Ext.getStore(gridnms["store.1"]).count();

	              for (var i = 0; i < recount; i++) {
	                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

	                model.set("LOTNO", lotno);
	                model.set("ORGID", orgid);
	                model.set("COMPANYID", companyid);

	                if (model.get("LOTNO") != '') {
	                  params.push(model.data);
	                }
	              }
	              dataSuccess = 1;

	              if (params.length > 0) {
	                Ext.Ajax.request({
	                  url: url1,
	                  method: 'POST',
	                  headers: {
	                    'Content-Type': 'application/json'
	                  },
	                  jsonData: {
	                    data: params
	                  },
	                  success: function (conn, response, options, eOpts) {
	                    if (msgGubun == 1) {
	                      msg = "정상적으로 생성 하였습니다.";
	                    } else if (msgGubun == 2) {
	                      msg = "내역이 변경되었습니다.";
	                    }
	                    statuschk = true;

	                    extAlert(msg);
	                    dataSuccess = 1;

	                    if (dataSuccess > 0) {
	                      //                          setInterval(function () {
	                      go_url("<c:url value='/scm/outprocess/OutProcLotRegistD.do?no=' />" + lotno + "&org=" + orgid + "&company=" + companyid);
	                      //                          }, 1 * 0.5 * 1000);
	                    }
	                  },
	                  error: ajaxError
	                });
	              }
	            }
	          },
	          error: ajaxError
	        });
	      } else {
	        Ext.Msg.alert('외주공정 lot 바코드 생성', '외주공정 lot 바코드 생성이 취소되었습니다.');
	        $('#Status').val($('#StatusTemp').val());
	        return;
	      }
	    });
	  } else if (msgGubun == 2) {
	    extAlert("[바코드 생성]<br/> 이미 외주공정 LOT 가 생성 되어져 있습니다.");
	    return false;

	  }
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var LotNo = $('#LotNo').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;

	  if (LotNo === "") {
	    header.push("외주공정 LOT 번호");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    result = false;
	    return result;
	  }

	  return result;
	}

	function fn_search() {
	  if (!fn_validation())
	    return;

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var LotNo = $('#LotNo').val();
	  var sparams = {
	    LOTNO: LotNo,
	    ORGID: orgid,
	    COMPANYID: companyid,
	  };

	  url = "<c:url value='/select/scm/outprocess/OutProcLotRegist.do' />";

	  $.ajax({
	    url: url,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {
	      var dataList = data.data[0];

	      var lotno = dataList.LOTNO;
	      var lotdate = dataList.LOTDATE;
	      var customercode = dataList.CUSTOMERCODE;
	      var customername = dataList.CUSTOMERNAME;
	      var itemcode = dataList.ITEMCODE;
	      var itemname = dataList.ITEMNAME;
	      var ordername = dataList.ORDERNAME;
	      var lotqty = dataList.LOTQTY;
	      var inputqty = dataList.INPUTQTY;
	      var intqty = dataList.INTQTY;
	      var restqty = dataList.RESTQTY;
	      var lotcnt = dataList.LOTCNT;
	      var remarks = dataList.REMARKS;
	      var uom = dataList.UOM;
	      var uomname = dataList.UOMNAME;
	      var itemstandard = dataList.ITEMSTANDARD;
	      var materialtype = dataList.MATERIALTYPE;

	      $("#LotNo").val(lotno);
	      $("#LotDate").val(lotdate);
	      $("#CustomerCode").val(customercode);
	      $("#CustomerName").val(customername);
	      $("#ItemCode").val(itemcode);
	      $("#ItemName").val(itemname);
	      $("#OrderName").val(ordername);
	      $("#LotQty").val(lotqty);
	      $("#InputQty").val(inputqty);
	      $("#IntQty").val(intqty);
	      $("#RestQty").val(restqty);
	      $("#LotCnt").val(lotcnt);
	      $("#Remarks").val(remarks);
	      $("#Uom").val(uom);
	      $("#UomName").val(uomname);
	      $("#ItemStandard").val(itemstandard);
	      $("#MaterialType").val(materialtype);

	      extGridSearch(sparams, gridnms["store.1"]);
	    },
	    error: ajaxError
	  });
	}

	function fn_total_check() {
	  var totCount = Ext.getStore(gridnms["store.1"]).count();
	  var totSum = 0;

	  for (var i = 0; i < totCount; i++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(i));
	    var model = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];

	    var lotqty = model.data.LOTQTY;
	    totSum += lotqty;
	  }

	  setTimeout(function () {
	    $('#LotQty').val(numeral(totSum).format('0,0'));
	  }, 500);
	}
	function fn_delete() {
	  // 삭제
	  var lotno = $('#LotNo').val();
	  var OrgId = $('#searchOrgId option:selected').val();
	  var CompanyId = $('#searchCompanyId option:selected').val();
	  var chkyn = $('#ChkYn').val(); // 출고 투입 여부
	  var chkqty = $('#Chkqty').val() * 1; // 출고 투입 수량
	  var isNew = lotno.length === 0;
	  var url = "",
	  url1 = "",
	  msgGubun = 0;
	  var statuschk = true;

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();

	  if (!gridcount == 0) {
	    extAlert("[상세 데이터 ]<br/> 상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
	    return false;
	  }

	  url = "<c:url value='/delete/scm/outprocess/OutProcLotRegist.do' />";

	  Ext.MessageBox.confirm('삭제 알림', '해당 데이터를 삭제하시겠습니까?', function (btn) {
	    if (btn == 'yes') {

	      var params = [];
	      $.ajax({
	        url: url,
	        type: "post",
	        dataType: "json",
	        data: $("#master").serialize(),
	        success: function (data) {
	          extAlert(data.msg);

	          //   정상적으로 생성이 되었으면
	          var result = data.success;

	          if (result) {
	            // 삭제 성공
	            var msg = data.msg;
	            extAlert(msg);
	            //                setInterval(function () {
	            go_url("<c:url value='/scm/outprocess/OutProcLotRegist.do' />");
	            //                }, 1 * 0.5 * 1000);
	          } else {
	            // 실패 했을 경우
	            var msg = data.msg;
	            extAlert(msg);
	            return;
	          }

	        },
	        error: ajaxError
	      });
	    } else {
	      Ext.Msg.alert('삭제', '해당 데이터 삭제가 취소되었습니다.');
	      return;
	    }
	  });
	}

	function fn_list() {
	  go_url("<c:url value='/scm/outprocess/OutProcLotRegist.do'/>");
	}

	function fn_add() {
	  go_url("<c:url value='/scm/outprocess/OutProcLotRegistD.do' />");
	}

	function fn_print() {
	  if (!fn_validation())
	    return;

	  var column = 'master';
	  var url = "<c:url value='/report/OutProcLotReport.pdf'/>";
	  var target = '_blank';

	  fn_popup_url(column, url, target);
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function fn_qty_change() {
	  var qty = $('#InputQty').val() * 1; // 박스당 수량
	  var passqty = $('#LotQty').val(); // LOT량
	  var intqty = (qty == 0) ? 0 : Math.ceil(((passqty * 1) / (qty * 1))); // LOT 량 / 박스당수량
	  var restqty = (qty == 0) ? 0 : ((passqty * 1.0) % (qty * 1.0));

	  if (qty > passqty) {
	    extAlert("박스당 수량은 Lot량 보다 클 수 없습니다.");
	    $('#InputQty').val(0);
	    $('#IntQty').val(0);
	    $('#RestQty').val(0);
	    $('#LotCnt').val(0);
	    return;
	  }
	  $('#IntQty').val(intqty);
	  $('#RestQty').val(restqty);
	  $('#LotCnt').val(0);
	  if (restqty > 0) {
	    // $('#LotCnt').val(qty + 1);

	    // 무조건 묶음수와 바코드 매수 같음.
	    $('#LotCnt').val(intqty);
	  } else {
	    $('#LotCnt').val(intqty);
	  }
	}

	function setLovList() {
	  // 가공처명 Lov
	  $("#CustomerName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#searchCustomerName").val("");
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
	        CUSTOMERTYPE2: 'O',
	      }, function (data) {
	        response($.map(data.data, function (m, i) {
	            return $.extend(m, {
	              value: m.VALUE,
	              label: m.LABEL + ", " + m.CUSTOMERTYPENAME,
	              NAME: m.LABEL,
	              ADDRESS: m.ADDRESS,
	              FREIGHT: m.FREIGHT,
	              PHONENUMBER: m.PHONENUMBER,
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
														<li>외주공정관리</li>
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
										<input type="hidden" id="popupCheckBig" />
										<input type="hidden" id="popupTransNo" />
										<input type="hidden" id="popupTransFrom" />
										<input type="hidden" id="popupTransTo" />
										<input type="hidden" id="searchGroupCode" name=searchGroupCode value="M" />
										<input type="hidden" id="popupOrgId" name=popupOrgId />
										<input type="hidden" id="popupCompanyId" name=popupCompanyId />
										<input type="hidden" id="popupGroupCode" name=popupGroupCode value="M" />
										<input type="hidden" id="popupBigCode" name="popupBigCode" />
										<input type="hidden" id="popupBigName" name="popupBigName" />
										<input type="hidden" id="popupMiddleCode" name="popupMiddleCode" />
										<input type="hidden" id="popupMiddleName" name="popupMiddleName" />
										<input type="hidden" id="popupSmallCode" name="popupSmallCode" />
										<input type="hidden" id="popupSmallName" name="popupSmallName" />
										<input type="hidden" id="popupItemCode" name="popupItemCode" />
										<input type="hidden" id="popupItemName" name="popupItemName" />
                    <input type="hidden" id="popupOrderName" name="popupOrderName" />
                    <input type="hidden" id="popupModelName" name="popupModelName" />
										<input type="hidden" id="popupItemType" name="popupItemType" />
										<input type="hidden" id="usedivtemp" name="usedivtemp" />
										<input type="hidden" id="usedivtemp1" name="usedivtemp1" />
										<input type="hidden" id="temp1" name="temp1" />
										<input type="hidden" id="temp2" name="temp2" />
										<input type="hidden" id="temp3" name="temp3" />
										<input type="hidden" id="OldQty" name="OldQty" />
										<input type="hidden" id="returnqty" name="returnqty" />
										<fieldset style="width: 100%">
												<legend>조건정보 영역</legend>
												<form id="master" name="master" action="" method="post">
                        <input type="hidden" id="Model" name="Model" />
												<input type="hidden" id="ItemCode" name="ItemCode" />
                        <input type="hidden" id="ItemStandard" name="ItemStandard" />
                        <input type="hidden" id="MaterialType" name="MaterialType" />                                        
														<div>
																<table class="tbl_type_view" border="0">
																		<colgroup>
																						<col width="18%">
																						<col width="18%">
																						<col width="64%">
																		</colgroup>
																		<tr style="height: 34px;">
																						<td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 90%;">
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
																						<td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 90%;">
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
																						<td>
																										<div class="buttons" style="float: right; margin-top: 3px;">
																														<a id="btnChk1" class="btn_search" href="#" onclick="javascript:btnSel1();"> Lot 발행 예정 List </a>
                                                            <a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
																														<a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete();"> 삭제 </a>
																														<a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
																														<a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
																														<a id="btnChk6" class="btn_print" href="#" onclick="javascript:fn_print();"> 외주공정 LOT 바코드 출력 </a>
 																													<!--	<a id="btnChk22" class="btn_create" href="#" onclick="javascript:fn_create();"> 외주공정 LOT 바코드 생성 </a> -->
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
                                        <th class="required_text">외주공정 LOT 번호</th>
                                        <td><input type="text" id="LotNo" name="LotNo" class="input_center" style="width: 97%;" value="${searchVO.LOTNO}" readonly /></td>
																				<th class="required_text">생성일</th>
																				<td><input type="text" id="LotDate" name="LotDate" class="input_validation input_center" style="width: 97%;" maxlength="10" /></td>
                                        <th class="required_text">가공처</th>
                                        <td><input type="text" id="CustomerName" name="CustomerName" class="input_validation input_center" style="width: 97%;"/> 
                                              <input type="hidden" id="CustomerCode" name="CustomerCode" class="" />
                                        </td>
																		</tr>
																		<tr style="height: 34px;">
                                        <th class="required_text">품번</th>
                                        <td><input type="text" id="OrderName" name="OrderName" class="input_center" style="width: 97%;" readonly /></td>
                                        <th class="required_text">품명</th>
                                        <td><input type="text" id="ItemName" name="ItemName" class="input_center" style="width: 97%;" readonly /></td>
                                        <td></td>
                                        <td></td>
                                    <tr style="height: 34px;">
                                        <th class="required_text">LOT량</th>
                                        <td><input type="text" id="LotQty" name="LotQty" class="input_center input_validation" style="width: 97%;" readonly /></td>
                                        <th class="required_text">박스당 수량</th>
                                        <td>
                                            <input type="text" id="InputQty" name="InputQty" class="input_center input_validation" style="width: 97%;" onchange="javascript:fn_qty_change();" />
                                            <input type="hidden" id="IntQty" name="IntQty" />
                                            <input type="hidden" id="RestQty" name="RestQty" />
                                        </td>
                                       <th class="required_text">바코드매수</th>
                                       <td><input type="text" id="LotCnt" name="LotCnt" class="input_center" style="width: 97%;" readonly /></td>
                                    </tr>
																		<tr style="height: 34px;">
																				<th  class="required_text">비고</th>
																				<td colspan = "5"><textarea id="Remarks" name="Remarks" class="input_left" style="width: 99%;" ></textarea></td>
																		</tr>
																</table>
														</div>
												</form>
										</fieldset>
								</div>
								<!-- //검색 필드 박스 끝 -->

								<div style="width: 100%;">
										<div id="gridDetailArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
								</div>
						</div>
						<!-- //content 끝 -->
				</div>
				<!-- //container 끝 -->
        <div id="gridPopup1Area" style="width: 1300px; padding-top: 0px; float: left;"></div>
        <div id="gridPopup11Area" style="width: 1200px; padding-top: 0px; float: left;"></div>

				<!-- footer 시작 -->
				<div id="footer">
						<c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
				</div>
				<!-- //footer 끝 -->
		</div>
		<!-- //전체 레이어 끝 -->
</body>
</html>