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
</style>
<script type="text/javaScript">
$(document).ready(function () {
	  setInitial();

	  setValues();
	  setExtGrid();

	  // 반출내역 팝업창 추가
	  setValues_Popup();
	  setExtGrid_Popup();

	  $("#gridPopupArea1").hide("blind", {
	    direction: "up"
	  }, "fast");

	  setReadOnly();
	  setLovList();

	  var inno = $('#InNo').val();
	  if (inno != "") {
	    fn_search();
	  }

	  $('#searchOrgId, #searchCompanyId').change(function (event) {});
	});

	function setInitial() {
	  // 최초 상태 설정
	  gridnms["app"] = "prod";

	  calender($('#InDate'));

	  $('#InDate').keyup(function (event) {
	    if (event.keyCode != '8') {
	      var v = this.value;
	      if (v.length === 4) {
	        this.value = v + "-";
	      } else if (v.length === 7) {
	        this.value = v + "-";
	      }
	    }
	  });

	  // 날짜
	  var inno = "${searchVO.INNO}";

	  if (inno == "") {
	    $("#InDate").val(getToDay("${searchVO.TODAY}") + "");
	  }

	  // 2016.10.04. 관리자 권한 외 사용자 로그인시 담당자에 이름 표기
	  var groupid = "${searchVO.groupId}";

	  switch (groupid) {
	  case "ROLE_ADMIN":
	    // 관리자 권한일 때 그냥 놔둠
	    break;
	  default:
	    // 관리자 외 권한일 때 사용자명 표기
	    $('#InKrName').val("${searchVO.KRNAME}");
	    $('#InPerson').val("${searchVO.EMPLOYEENUMBER}");
	    break;
	  }
	}

	var gridnms = {};
	var fields = {};
	var items = {};
	function setValues() {
	  gridnms["models.detail"] = [];
	  gridnms["stores.detail"] = [];
	  gridnms["views.detail"] = [];
	  gridnms["controllers.detail"] = [];

	  gridnms["grid.1"] = "ToolInDetail";
	  gridnms["grid.2"] = "ToolStatusLov";

	  gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
	  gridnms["views.detail"].push(gridnms["panel.1"]);

	  gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
	  gridnms["controllers.detail"].push(gridnms["controller.1"]);

	  gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
	  gridnms["model.2"] = gridnms["app"] + ".model." + gridnms["grid.2"];

	  gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
	  gridnms["store.2"] = gridnms["app"] + ".store." + gridnms["grid.2"];

	  gridnms["models.detail"].push(gridnms["model.1"]);
	  gridnms["models.detail"].push(gridnms["model.2"]);

	  gridnms["stores.detail"].push(gridnms["store.1"]);
	  gridnms["stores.detail"].push(gridnms["store.2"]);

	  fields["model.1"] = [{
	      type: 'number',
	      name: 'ORGID',
	    }, {
	      type: 'number',
	      name: 'COMPANYID',
	    }, {
	      type: 'string',
	      name: 'INNO',
	    }, {
	      type: 'number',
	      name: 'INSEQ',
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
	      type: 'string',
	      name: 'ITEMSTANDARD',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'number',
	      name: 'OUTQTY',
	    }, {
	      type: 'number',
	      name: 'QTY',
	    }, {
	      type: 'number',
	      name: 'PREQTY',
	    }, {
	      type: 'string',
	      name: 'TOOLSTATUS',
	    }, {
	      type: 'string',
	      name: 'TOOLSTATUSNAME',
	    }, {
	      type: 'string',
	      name: 'OUTNO',
	    }, {
	      type: 'number',
	      name: 'OUTSEQ',
	    }, {
	      type: 'string',
	      name: 'REMARKS',
	    }, ];

	  fields["model.2"] = [{
	      type: 'string',
	      name: 'VALUE',
	    }, {
	      type: 'string',
	      name: 'LABEL',
	    }, ];

	  fields["columns.1"] = [
	    // Display Columns
	    {
	      dataIndex: 'INSEQ',
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
	      editor: {
	        xtype: "textfield",
	        minValue: 1,
	        format: "0,000",
	        enforceMaxLength: true,
	        allowBlank: true,
	        maxLength: '4',
	        maskRe: /[0-9.]/,
	        selectOnFocus: true,
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return Ext.util.Format.number(value, '0,000');
	      },
	      //      }, {
	      //        dataIndex: 'ORDERNAME',
	      //        text: '품번',
	      //        xtype: 'gridcolumn',
	      //        width: 120,
	      //        hidden: false,
	      //        sortable: false,
	      //        resizable: false,
	      //        menuDisabled: true,
	      //        style: 'text-align:center;',
	      //        align: "center",
	      //        renderer: function (value, meta, record) {
	      //          meta.style = "background-color:rgb(234, 234, 234)";
	      //          return value;
	      //        },
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
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      text: '규격',
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
	        meta.style = "background-color:rgb(234, 234, 234)";
	        return value;
	      },
	    }, {
	      dataIndex: 'OUTQTY',
	      text: '반출<br/>수량',
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
	      dataIndex: 'QTY',
	      text: '수량',
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
	            var selectedRow = Ext.getCmp(gridnms["views.detail"]).getSelectionModel().getCurrentPosition().row;

	            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).getSelectionModel().select(selectedRow));
	            var store = Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0];
	            var qty = newValue;
	            var outqty = store.data.OUTQTY * 1;

	            if (outqty == qty) {
	              store.set("TOOLSTATUS", "02");
	              store.set("TOOLSTATUSNAME", "반입");
	            } else if (outqty > qty) {
	              store.set("TOOLSTATUS", "03");
	              store.set("TOOLSTATUSNAME", "부분반입");
	            }
	          },
	        },
	      },
	      renderer: function (value, meta, record) {
	        var toolstatus = record.data.TOOLSTATUS;
	        if (toolstatus == "99") {
	          meta.style = "background-color:rgb(234, 234, 234)";
	        } else {
	          meta.style += " background-color:rgb(253, 218, 255);";
	        }
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'TOOLSTATUSNAME',
	      text: '상태',
	      xtype: 'gridcolumn',
	      width: 100,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: 'combobox',
	        store: gridnms["store.2"],
	        valueField: "LABEL",
	        displayField: "LABEL",
	        matchFieldWidth: true,
	        editable: false,
	        queryParam: 'keyword',
	        queryMode: 'remote', // 'local',
	        allowBlank: true,
	        typeAhead: true,
	        transform: 'stateSelect',
	        forceSelection: false,
	        listeners: {
	          select: function (value, record, eOpts) {
	            var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);

	            model.set("TOOLSTATUS", record.data.VALUE);
	          },
	          change: function (field, ov, nv, eOpts) {
	            var model = Ext.getStore(gridnms["store.2"]).getById(Ext.getCmp(gridnms["views.detail"]).selModel.getSelection()[0].id);
	            var result = field.getValue();

	            if (ov != nv) {
	              if (!isNaN(result)) {
	                model.set("TOOLSTATUS", "");
	              }
	            }
	          },
	        },
	        listConfig: {
	          loadingText: '검색 중...',
	          emptyText: '데이터가 없습니다. 관리자에게 문의하십시오.',
	          width: 220,
	          getInnerTpl: function () {
	            return '<div >'
	             + '<table >'
	             + '<colgroup>'
	             + '<col width="100px">'
	             + '<col width="120px">'
	             + '</colgroup>'
	             + '<tr>'
	             + '<td style="height: 25px; font-size: 13px; ">{LABEL}</td>'
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
	    }, {
	      dataIndex: 'OUTNO',
	      text: '반출<br/>번호',
	      xtype: 'gridcolumn',
	      width: 120,
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
	      dataIndex: 'OUTSEQ',
	      text: '반출<br/>순번',
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
	        return value;
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
	      editor: {
	        xtype: "textfield",
	        allowBlank: true,
	      },
	      renderer: function (value, meta, record) {
	        //          var toolstatus = record.data.TOOLSTATUS;
	        //          if (toolstatus != "99") {
	        //            meta.style += " background-color:rgb(253, 218, 255);";
	        //          }
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
	      dataIndex: 'INNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORDERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'PREQTY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'TOOLSTATUS',
	      xtype: 'hidden',
	    }, ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/prod/tool/ToolInDetail.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/prod/tool/ToolInDetail.do' />"
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

	function btnDel1() {
	  // Detail 삭제
	  var store = this.getStore(gridnms["store.1"]);
	  var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];
	  var inno = $('#InNo').val();
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();

	  if (record === undefined) {
	    return;
	  }

	  Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
	      store.remove(record);
	      Ext.getStore(gridnms["store.1"]).sync();

	      extAlert("정상적으로 삭제 하였습니다.");

	      //        setInterval(function () {
	      go_url("<c:url value='/prod/tool/ToolInManage.do?no=' />" + inno + "&ORGID=" + orgid + "&COMPANYID=" + companyid);
	      //        }, 1 * 0.5 * 1000);
	    }
	  });
	}

	var gridarea;
	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"],
	  });

	  Ext.define(gridnms["model.2"], {
	    extend: Ext.data.Model,
	    fields: fields["model.2"],
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
	                ORGID: $('#searchOrgId').val(),
	                COMPANYID: $('#searchCompanyId').val(),
	                INNO: $('#InNo').val(),
	              },
	              reader: gridVals.reader,
	              writer: $.extend(gridVals.writer, {
	                writeAllFields: true
	              }),
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["store.2"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.2"],
	            model: gridnms["model.2"],
	            autoLoad: true,
	            pageSize: gridVals.pageSize,
	            proxy: {
	              type: "ajax",
	              url: "<c:url value='/searchSmallCodeListLov.do' />",
	              
	              extraParams: {
	                ORGID: $('#searchOrgId option:selected').val(),
	                COMPANYID: $('#searchCompanyId option:selected').val(),
	                BIGCD: "MFG",
	                MIDDLECD: "TOOL_STATUS",
	              },
	              reader: gridVals.reader,
	            }
	          }, cfg)]);
	    },
	  });

	  Ext.define(gridnms["controller.1"], {
	    extend: Ext.app.Controller,
	    refs: {
	      btnDetailList: '#btnDetailList',
	    },
	    stores: [gridnms["store.1"]],
	    control: items["btns.ctr.1"],

	    btnDel1: btnDel1,
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
	        height: 592,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        viewConfig: {
	          itemId: 'btnDetailList',
	          trackOver: true,
	          loadMask: true,
	          listeners: {
	            refresh: function (dataView) {
	              Ext.each(dataView.panel.columns, function (column) {
	                if (column.dataIndex.indexOf('ITEMSTANDARD') >= 0 || column.dataIndex.indexOf('ITEMNAME') >= 0) {
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
	        bufferedRenderer: false,
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = ctx.record;

	                var editDisableCols = [];
	                var toolstatus = data.data.TOOLSTATUS;
	                editDisableCols.push("INSEQ");
	                if (toolstatus == "99") {
	                  editDisableCols.push("QTY");
	                  editDisableCols.push("TOOLSTATUSNAME");
	                  editDisableCols.push("REMARKS");
	                }

	                var isNew = ctx.record.phantom || false;
	                if (!isNew && $.inArray(ctx.field, editDisableCols) > -1)
	                  return false;
	                else {
	                  return true;
	                }
	              },
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
	          renderTo: 'gridArea'
	        });
	    },
	  });

	  Ext.EventManager.onWindowResize(function (w, h) {
	    gridarea.updateLayout();
	  });
	}

	function fn_save() {
	  // 필수 체크
	  var InDate = $('#InDate').val();
	  var CustomerCode = $('#CustomerCode').val();
	  var InPerson = $('#InPerson').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;
	  var result = null;

	  if (InDate === "") {
	    header.push("반입일");
	    count++;
	  }
	  if (CustomerCode === "") {
	    header.push("반입처");
	    count++;
	  }

	  if (InPerson === "") {
	    header.push("반입담당자");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return false;
	  }

	  // 저장
	  var inno = $('#InNo').val();
	  var OrgId = $('#searchOrgId option:selected').val();
	  var CompanyId = $('#searchCompanyId option:selected').val();
	  var isNew = inno.length === 0;
	  var url = "",
	  url1 = "",
	  msgGubun = 0;

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();
	  if (gridcount == 0) {
	    extAlert("[상세 미등록]<br/> 치공구 반입 상세 데이터가 등록되지 않았습니다.");
	    return false;
	  }

	  if (isNew) {
	    url = "<c:url value='/insert/prod/tool/ToolInList.do' />";
	    url1 = "<c:url value='/insert/prod/tool/ToolInDetail.do' />";
	    msgGubun = 1;
	  } else {
	    url = "<c:url value='/update/prod/tool/ToolInList.do' />";
	    url1 = "<c:url value='/update/prod/tool/ToolInDetail.do' />";
	    msgGubun = 2;
	  }

	  if (msgGubun == 1) {
	    Ext.MessageBox.confirm('치공구 반입 알림', '저장 하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        var params = [];
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: $("#master").serialize(),
	          success: function (data) {
	            var orgid = data.searchOrgId;
	            var companyid = data.searchCompanyId;
	            var inno = data.INNO;

	            if (inno.length == 0) {
	              // 생성이 안되었을 때 로직 추가
	            } else {
	              // 생성이 정상적으로 되었으면
	              var recount = Ext.getStore(gridnms["store.1"]).count();

	              for (var i = 0; i < recount; i++) {
	                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

	                model.set("ORGID", orgid);
	                model.set("COMPANYID", companyid);
	                model.set("INNO", inno);

	                if (model.get("INNO") != '') {
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
	                      msg = "정상적으로 내역이 변경되었습니다.";
	                    }
	                    statuschk = true;

	                    extAlert(msg);
	                    dataSuccess = 1;

	                    if (dataSuccess > 0) {

	                      //                        setInterval(function () {
	                      go_url("<c:url value='/prod/tool/ToolInManage.do?no=' />" + inno + "&org=" + orgid + "&company=" + companyid);

	                      //                        }, 1 * 0.5 * 1000);
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
	        Ext.Msg.alert('치공구 반입', '등록이 취소되었습니다.');
	        return;
	      }
	    });
	  } else if (msgGubun == 2) {

	    Ext.MessageBox.confirm('치공구 반입 변경 알림', '변경하시겠습니까?', function (btn) {
	      if (btn == 'yes') {
	        var params = [];
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: $("#master").serialize(),
	          success: function (data) {
	            var inno = data.InNo;
	            var orgid = data.searchOrgId;
	            var companyid = data.searchCompanyId;

	            if (inno.length == 0) {
	              // 생성이 안되었을 때 로직 추가
	            } else {
	              // 정상적으로 생성이 되었으면
	              var recount = Ext.getStore(gridnms["store.1"]).count();

	              for (var i = 0; i < recount; i++) {
	                var model = Ext.getStore(gridnms["store.1"]).getAt(i);

	                model.set("ORGID", orgid);
	                model.set("COMPANYID", companyid);
	                model.set("INNO", inno);
	                if (model.get("INNO") != '') {
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
	                      msg = "정상적으로 내역이 변경되었습니다.";
	                    }
	                    statuschk = true;

	                    extAlert(msg);
	                    dataSuccess = 1;

	                    if (dataSuccess > 0) {
	                      //                        setInterval(function () {
	                      go_url("<c:url value='/prod/tool/ToolInManage.do?no=' />" + inno + "&org=" + orgid + "&company=" + companyid);
	                      //                        }, 1 * 0.5 * 1000);
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
	        Ext.Msg.alert('치공구 반입 변경', '변경이 취소되었습니다.');
	        return;
	      }
	    });
	  }
	}

	function fn_validation() {
	  var result = true;
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var InNo = $('#InNo').val();

	  var header = [],
	  count = 0;
	  var dataSuccess = 0;

	  if (orgid === "") {
	    header.push("사업장");
	    count++;
	  }
	  if (companyid === "") {
	    header.push("공장");
	    count++;
	  }
	  if (InNo === "") {
	    header.push("반입번호");
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
	  if (!fn_validation()) {
	    return;
	  }

	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();
	  var InNo = $('#InNo').val();

	  var sparams = {
	    ORGID: orgid,
	    COMPANYID: companyid,
	    INNO: InNo,
	    GUBUN: 'REGIST',
	  };

	  var url = "<c:url value='/select/prod/tool/ToolInList.do' />";

	  $.ajax({
	    url: url,
	    type: "post",
	    dataType: "json",
	    data: sparams,
	    success: function (data) {
	      var dataList = data.data[0];

	      var inno = dataList.INNO;
	      var indate = dataList.INDATE;
	      var customercode = dataList.CUSTOMERCODE;
	      var customername = dataList.CUSTOMERNAME;
	      var inperson = dataList.INPERSON;
	      var inkrname = dataList.INKRNAME;
	      var remarks = dataList.REMARKS;

	      $("#InNo").val(inno);
	      $("#InDate").val(indate);
	      $("#CustomerCode").val(customercode);
	      $("#CustomerName").val(customername);
	      $("#InPerson").val(inperson);
	      $("#InKrName").val(inkrname);
	      $('#Remarks').val(remarks);

	      var sparams1 = {
	        ORGID: orgid,
	        COMPANYID: companyid,
	        INNO: InNo,
	      };

	      extGridSearch(sparams1, gridnms["store.1"]);
	    },
	    error: ajaxError
	  });

	}

	function fn_delete() {
	  // 삭제
	  var OrgId = $('#searchOrgId option:selected').val();
	  var CompanyId = $('#searchCompanyId option:selected').val();
	  var inno = $('#InNo').val();
	  var url = "";

	  if (inno === "") {
	    extAlert("데이터가 등록되지 않은 상태에서 삭제하실수 없습니다.<br/>다시 한번 확인해주세요.");
	    return false;
	  }

	  var gridcount = Ext.getStore(gridnms["store.1"]).count();
	  if (!gridcount == 0) {
	    extAlert("[상세 데이터]<br/>상세 데이터가 있습니다. 상세 데이터 삭제 후 마스터 정보를 삭제해 주세요.");
	    return false;
	  }

	  url = "<c:url value='/delete/prod/tool/ToolInList.do' />";

	  Ext.MessageBox.confirm('치공구 반입 삭제 알림', '데이터를 삭제하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
	      var params = [];
	      $.ajax({
	        url: url,
	        type: "post",
	        dataType: "json",
	        data: $("#master").serialize(),
	        success: function (data) {
	          var result = data.success;
	          if (result) {
	            // 삭제 성공
	            var msg = data.msg;
	            extAlert(msg);
	            //              setInterval(function () {
	            fn_list();
	            //              }, 1 * 0.5 * 1000);
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
	      Ext.Msg.alert('치공구 반입 삭제', '삭제가 취소되었습니다.');
	      return;
	    }
	  });
	}

	function fn_list() {
	  go_url("<c:url value='/prod/tool/ToolInList.do'/>");
	}

	function fn_add() {
	  go_url("<c:url value='/prod/tool/ToolInManage.do' />");
	}

	var popcount = 0, popupclick = 0;
	function btnSel1() {
	  var InNo = $('#InNo').val();
	  var InDate = $('#InDate').val();
	  var InPerson = $('#InPerson').val();

	  // 반출내역 불러오기 팝업
	  var width = 1009; // 가로
	  var height = 640; // 세로
	  var title = "반출내역 불러오기 Popup";

	  var check = true;

	  popupclick = 0;
	  if (check == true) {
	    // 완료 외 상태에서만 팝업 표시하도록 처리
	    $('#popupOrgId').val($('#searchOrgId option:selected').val());
	    $('#popupCompanyId').val($('#searchCompanyId option:selected').val());
	    $('#popupItemName').val("");
	    $('#popupItemStandard').val("");
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
	          },
	          '규격', {
	            xtype: 'textfield',
	            name: 'searchItemStandard',
	            clearOnReset: true,
	            hideLabel: true,
	            width: 250,
	            editable: true,
	            allowBlank: true,
	            listeners: {
	              scope: this,
	              buffer: 50,
	              change: function (value, nv, ov, e) {
	                value.setValue(nv.toUpperCase());
	                var result = value.getValue();

	                $('#popupItemStandard').val(result);
	              },
	            },
	          }, '->', {
	            text: '조회',
	            scope: this,
	            handler: function () {
	              var sparams3 = {
	                ORGID: $('#popupOrgId').val(),
	                COMPANYID: $('#popupCompanyId').val(),
	                ITEMNAME: $('#popupItemName').val(),
	                ITEMSTANDARD: $('#popupItemStandard').val(),
	              };

	              extGridSearch(sparams3, gridnms["store.4"]);
	            }
	          }, {
	            text: '전체선택/해제',
	            scope: this,
	            handler: function () {
	              // 전체등록 Pop up 전체선택 버튼 핸들러
	              var count4 = Ext.getStore(gridnms["store.4"]).count();
	              var checkTrue = 0,
	              checkFalse = 0;

	              if (popupclick == 0) {
	                popupclick = 1;
	              } else {
	                popupclick = 0;
	              }
	              for (var i = 0; i < count4; i++) {
	                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
	                var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];

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
	              var count = Ext.getStore(gridnms["store.1"]).count();
	              var count4 = Ext.getStore(gridnms["store.4"]).count();
	              var checknum = 0,
	              checkqty = 0,
	              checktemp = 0;
	              var qtytemp = [];

	              for (var i = 0; i < count4; i++) {
	                Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(i));
	                var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                var chk = model4.data.CHK;

	                if (chk == true) {
	                  checknum++;
	                }
	              }
	              console.log("[적용] 선택된 항목은 총 " + checknum + "건 입니다.");

	              if (checknum == 0) {
	                extAlert("내역을 선택하지 않으셨습니다.<br/>다시 한번 확인해주십시오.");
	                return false;
	              }

	              if (count4 == 0) {
	                console.log("[적용] 반출내역 정보가 없습니다.");
	              } else {
	                for (var j = 0; j < count4; j++) {
	                  Ext.getStore(gridnms["store.4"]).getById(Ext.getCmp(gridnms["views.popup1"]).getSelectionModel().select(j));
	                  var model4 = Ext.getCmp(gridnms["views.popup1"]).selModel.getSelection()[0];
	                  var chk = model4.data.CHK;

	                  if (chk === true) {
	                    var model = Ext.create(gridnms["model.1"]);
	                    var store = Ext.getStore(gridnms["store.1"]);

	                    // 순번
	                    model.set("INSEQ", Ext.getStore(gridnms["store.1"]).count() + 1);

	                    // 팝업창의 체크된 항목 이동
	                    model.set("ITEMCODE", model4.data.ITEMCODE);
	                    model.set("ITEMNAME", model4.data.ITEMNAME);
	                    model.set("ORDERNAME", model4.data.ORDERNAME);
	                    model.set("ITEMSTANDARD", model4.data.ITEMSTANDARD);
	                    model.set("UOMNAME", model4.data.UOMNAME);
	                    model.set("OUTQTY", model4.data.QTY);
	                    model.set("PREQTY", model4.data.INQTY);
	                    model.set("QTY", model4.data.REMAINQTY);
	                    model.set("OUTNO", model4.data.OUTNO);
	                    model.set("OUTSEQ", model4.data.OUTSEQ);

	                    model.set("TOOLSTATUS", "02");
	                    model.set("TOOLSTATUSNAME", "반입");

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

	                $("#gridPopupArea1").hide("blind", {
	                  direction: "up"
	                }, "fast");
	              }
	            }
	          }
	        ]
	      });

	    win1.show();

	  } else {
	    extAlert("반입 등록하실 때만 반출내역 불러오기가 가능합니다.");
	    return;
	  }
	}

	// 반출내역 불러오기 팝업
	function setValues_Popup() {
	  gridnms["models.popup1"] = [];
	  gridnms["stores.popup1"] = [];
	  gridnms["views.popup1"] = [];
	  gridnms["controllers.popup1"] = [];

	  gridnms["grid.4"] = "Popup1";

	  gridnms["panel.4"] = gridnms["app"] + ".view." + gridnms["grid.4"];
	  gridnms["views.popup1"].push(gridnms["panel.4"]);

	  gridnms["controller.4"] = gridnms["app"] + ".controller." + gridnms["grid.4"];
	  gridnms["controllers.popup1"].push(gridnms["controller.4"]);

	  gridnms["model.4"] = gridnms["app"] + ".model." + gridnms["grid.4"];

	  gridnms["store.4"] = gridnms["app"] + ".store." + gridnms["grid.4"];

	  gridnms["models.popup1"].push(gridnms["model.4"]);

	  gridnms["stores.popup1"].push(gridnms["store.4"]);

	  fields["model.4"] = [{
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
	      name: 'OUTNO',
	    }, {
	      type: 'number',
	      name: 'OUTSEQ',
	    }, {
	      type: 'date',
	      name: 'OUTDATE',
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
	      name: 'ORDERNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMNAME',
	    }, {
	      type: 'string',
	      name: 'ITEMSTANDARD',
	    }, {
	      type: 'string',
	      name: 'UOMNAME',
	    }, {
	      type: 'number',
	      name: 'QTY',
	    }, {
	      type: 'number',
	      name: 'INQTY',
	    }, {
	      type: 'number',
	      name: 'REMAINQTY',
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
	      dataIndex: 'ITEMNAME',
	      text: '품명',
	      xtype: 'gridcolumn',
	      width: 400,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	    }, {
	      dataIndex: 'ITEMSTANDARD',
	      text: '규격',
	      xtype: 'gridcolumn',
	      width: 250,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	    }, {
	      dataIndex: 'REMAINQTY',
	      text: '수량',
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
	        return Ext.util.Format.number(value, '0,000');
	      },
	    }, {
	      dataIndex: 'OUTDATE',
	      text: '반출일자',
	      xtype: 'datecolumn',
	      width: 105,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      renderer: function (value, meta, record) {
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
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
	      dataIndex: 'OUTNO',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'OUTSEQ',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'CUSTOMERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ITEMCODE',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'ORDERNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'UOMNAME',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'QTY',
	      xtype: 'hidden',
	    }, {
	      dataIndex: 'INQTY',
	      xtype: 'hidden',
	    }, ];

	  items["api.4"] = {};
	  $.extend(items["api.4"], {
	    read: "<c:url value='/searchToolOutListLov.do' />"
	  });

	  items["btns.4"] = [];

	  items["btns.ctr.4"] = {};

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

	var gridpopup1;
	function setExtGrid_Popup() {
	  Ext.define(gridnms["model.4"], {
	    extend: Ext.data.Model,
	    fields: fields["model.4"],
	  });

	  Ext.define(gridnms["store.4"], {
	    extend: Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.4"],
	            model: gridnms["model.4"],
	            autoLoad: false,
	            pageSize: 999999,
	            proxy: {
	              type: 'ajax',
	              api: items["api.4"],
	              timeout: gridVals.timeout,
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
	          renderTo: 'gridPopupArea1'
	        });
	    },
	  });
	}

	function fn_ready() {
	  extAlert("준비중입니다...");
	}

	function setLovList() {
	  // 업체명 Lov
	  $("#CustomerName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      //             $("#CustomerName").val("");
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

	  // 반입담당자 Lov
	  $("#InKrName").bind("keydown", function (e) {
	    switch (e.keyCode) {
	    case $.ui.keyCode.TAB:
	      if ($(this).autocomplete("instance").menu.active) {
	        e.preventDefault();
	      }
	      break;
	    case $.ui.keyCode.BACKSPACE:
	    case $.ui.keyCode.DELETE:
	      $("#InPerson").val("");
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
	      $.getJSON("<c:url value='/searchWorkerLov.do' />", {
	        keyword: extractLast(request.term),
	        INSPECTORTYPE: '10', // 관리직 검색
	        //          INSPECTORTYPE2: '20', // 생산관리직 추가
	        ORGID: $('#searchOrgId option:selected').val(),
	        COMPANYID: $('#searchCompanyId option:selected').val(),
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
	      $("#InPerson").val(o.item.value);
	      $("#InKrName").val(o.item.label);

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
                            <li>치공구 관리</li>
                            <li>&gt;</li>
                            <li><strong>${pageTitle}</strong></li>
                        </ul>
                    </div>
                </div>
                <!-- 검색 필드 박스 시작 -->
                <input type="hidden" id="popupOrgId" name="popupOrgId" />
                <input type="hidden" id="popupCompanyId" name="popupCompanyId" />
                <input type="hidden" id="popupItemName" name="popupItemName" />
                <input type="hidden" id="popupItemStandard" name="popupItemStandard" />
                <div id="search_field">
                    <div id="search_field_loc">
                        <h2>
                            <strong>${pageTitle}</strong>
                        </h2>
                    </div>
                    <fieldset style="width: 100%">
                        <legend>조건정보 영역</legend>
                        <form id="master" name="master" action="" method="post">
                                <div>
                                    <table class="tbl_type_view" border="0">
                                            <colgroup>
                                                    <col width="20%">
                                                    <col width="20%">
                                                    <col width="60%">
                                            </colgroup>
                                            <tr style="height: 34px;">
                                                    <td><select id="searchOrgId" name="searchOrgId" class="input_left " style="width: 70%;">
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
                                                    <td><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 70%;">
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
                                                    <td colspan="5">
                                                            <div class="buttons" style="float: right; margin-top: 3px;">
                                                                    <a id="btnChk1" class="btn_popup" href="#" onclick="javascript:btnSel1();"> 반출내역 불러오기 </a>
                                                                    <a id="btnChk2" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
                                                                    <a id="btnChk3" class="btn_delete" href="#" onclick="javascript:fn_delete()"> 삭제 </a>
                                                                    <a id="btnChk4" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
                                                                    <a id="btnChk5" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
                                                            </div>
                                                    </td>
                                            </tr>
                                    </table>
                                    <table class="tbl_type_view" border="1">
                                            <colgroup>
                                                    <col width="12%">
                                                    <col width="22%">
                                                    <col width="12%">
                                                    <col width="22%">
                                                    <col width="12%">
                                                    <col width="22%">
<%--                                                     <col width="12%"> --%>
<%--                                                     <col width="22%"> --%>
                                            </colgroup>
                                            <tr style="height: 34px;">
                                                    <th class="required_text">반입번호</th>
                                                    <td><input type="text" id="InNo" name="InNo" class="input_center" style="width: 97%;" value="${searchVO.INNO}" readonly /></td>
                                                    <th class="required_text">반입일</th>
                                                    <td><input type="text" id="InDate" name="InDate" class="input_validation input_center" style="width: 97%;" maxlength="10" />
                                                    </td>
                                                    <th class="required_text">반입처</th>
                                                    <td>
                                                    <input type="text" id="CustomerName" name="CustomerName" class="input_validation input_center" style="width: 98%;" />
                                                    <input type="hidden" id="CustomerCode" name="CustomerCode" />
                                                    </td>
                                            </tr>
                                            <tr style="height: 34px;">
                                                    <th class="required_text">반입담당자</th>
                                                    <td><input type="text" id="InKrName" name="InKrName" class="input_validation input_center" style="width: 97%;" />
                                                    <input type="hidden" id="InPerson" name="InPerson" />
                                                    </td>
                                                    <th class="required_text"></th>
                                                    <td></td>
                                                    <th class="required_text"></th>
                                                    <td></td>
                                                    <td></td>
                                            </tr>
                                            <tr style="height: 34px;">
                                                    <th class="required_text">비고</th>
                                                    <td colspan="5"><textarea id="Remarks" name="Remarks"  class="input_left" style="width: 99%;"></textarea></td>
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
        <div id="gridPopupArea1" style="width: 1580px; padding-top: 0px; float: left;"></div>

        <!-- footer 시작 -->
        <div id="footer">
            <c:import url="/EgovPageLink.do?link=main/inc/EgovIncFooter" />
        </div>
        <!-- //footer 끝 -->
    </div>
    <!-- //전체 레이어 끝 -->
</body>
</html>