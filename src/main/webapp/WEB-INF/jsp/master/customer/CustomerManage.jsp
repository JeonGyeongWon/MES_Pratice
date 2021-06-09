<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
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
	LoginVO loginVO = (LoginVO) session.getAttribute("LoginVO");
	String authCode = loginVO.getAuthCode();

	/* Image Path 설정 */
	String imagePath_icon = "/images/egovframework/sym/mpm/icon/";
	String imagePath_button = "/images/egovframework/sym/mpm/button/";
%>
<c:import url="/EgovPageLink.do?link=main/inc/CommonHead" />
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="content-language" content="ko">
<link href="<c:url value='/'/>css/common.css" rel="stylesheet" type="text/css">
<script type="text/javascript" src="<c:url value='/js/common.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/EgovCalPopup.js'/>"></script>
<title>${pageTitle}</title>
<meta http-equiv="Content-Script-Type" content="text/javascript">
<meta http-equiv="Content-Style-Type" content="text/css">
<meta http-equiv="X-UA-Compatible" content="IE=8">

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

	  setLovList();
	  setReadOnly();

	  setTimeout(function () {
	    var customercode = "${searchVO.CUSTOMERCODE}";
	    var isNew = customercode.length > 0;
	    if (isNew) {
	      fn_search();
	    }

	    // 최초 실행시 첫번째 탭 활성화
	    setTimeout(function () {
	      fn_tab("1");
	    }, 300);
	  }, 100);
	});

	function setInitial() {
	  $('#CUSTOMERNAME').focus();
	}

	var gridnms = {};
	var fields = {};
	var items = {};

	function setValues() {
	  gridnms["app"] = "customer";

	  gridnms["models.list"] = [];
	  gridnms["stores.list"] = [];
	  gridnms["views.list"] = [];
	  gridnms["controllers.list"] = [];

	  gridnms["grid.1"] = "CustomerRegist";

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

	  fields["columns.1"] = [
	    // Display columns
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
	    }, {
	      dataIndex: 'MEMBERNAME',
	      text: '담당자명',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "center",
	      editor: {
	        xtype: "textfield",
	        allowBlank: true,
	      },
	      renderer: function (value, meta, record) {
	        meta.style += " background-color:rgb(253, 218, 255);";
	        return value;
	      },
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
	      editor: {
	        xtype: "textfield",
	        allowBlank: true,
	      },
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
	      editor: {
	        xtype: "textfield",
	        allowBlank: true,
	      },
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
	      editor: {
	        xtype: "textfield",
	        allowBlank: true,
	      },
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
	      editor: {
	        xtype: "textfield",
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'EMAIL',
	      text: 'E-MAIL',
	      xtype: 'gridcolumn',
	      width: 150,
	      hidden: false,
	      sortable: false,
	      resizable: false,
	      menuDisabled: true,
	      style: 'text-align:center;',
	      align: "left",
	      editor: {
	        xtype: "textfield",
	        allowBlank: true,
	      },
	    }, {
	      dataIndex: 'EFFECTIVESTARTDATE',
	      text: '유효<br/>시작일자',
	      xtype: 'datecolumn',
	      width: 115,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: false,
	      filterable: true,
	      filter: {
	        type: 'date',
	      },
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
	        meta.style = "background-color:rgb(253, 218, 255)";
	        return Ext.util.Format.date(value, 'Y-m-d');
	      },
	    }, {
	      dataIndex: 'EFFECTIVEENDDATE',
	      text: '유효<br/>종료일자',
	      xtype: 'datecolumn',
	      width: 115,
	      hidden: false,
	      sortable: true,
	      resizable: false,
	      menuDisabled: false,
	      filterable: true,
	      filter: {
	        type: 'date',
	      },
	      align: "center",
	      format: 'Y-m-d',
	      editor: {
	        xtype: 'datefield',
	        enforceMaxLength: true,
	        maxLength: 10,
	        allowBlank: true,
	        format: 'Y-m-d',
	        altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
	        listeners: {
	          select: function (value, record) {
	            var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

	            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
	            var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	            var temp = Ext.Date.format(value.getValue(), 'Y-m-d');
	            var end = Ext.Date.format('4999-12-31', 'Y-m-d');

	            if (temp != end) {
	              store.set("USEYN", "N");
	            }

	          },
	          specialkey: function (field, e, eOpts) {
	            if (e.keyCode == e.TAB) {
	              // Tab 키를 눌렀을 때 작동
	              var selectedRow = Ext.getCmp(gridnms["views.list"]).getSelectionModel().getCurrentPosition().row;

	              Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(selectedRow));
	              var store = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	              var temp = Ext.Date.format(field.getValue(), 'Y-m-d');
	              var end = Ext.Date.format('4999-12-31', 'Y-m-d');

	              if (temp != end) {
	                store.set("USEYN", "N");
	              }
	            }

	          },
	        },
	      },
	      renderer: function (value, meta, record) {
	        meta.style = "background-color:rgb(253, 218, 255)";
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
	      editor: {
	        xtype: "textfield",
	        allowBlank: true,
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
	      dataIndex: 'CUSTOMERCODE',
	      xtype: 'hidden',
	    },
	  ];

	  items["api.1"] = {};
	  $.extend(items["api.1"], {
	    create: "<c:url value='/insert/customer/CustomerMemberList.do' />"
	  });
	  $.extend(items["api.1"], {
	    update: "<c:url value='/update/customer/CustomerMemberList.do' />"
	  });
	  $.extend(items["api.1"], {
	    destroy: "<c:url value='/delete/customer/CustomerMemberList.do' />"
	  });
	  $.extend(items["api.1"], {
	    read: "<c:url value='/select/customer/CustomerMemberList.do' />"
	  });

	  items["btns.1"] = [];
	  items["btns.1"].push({
	    xtype: "button",
	    text: "추가",
	    itemId: "btnAdd1"
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
	    "#btnRef1": {
	      click: 'btnRef1Click'
	    }
	  });
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
	  items["docked.1"].push(items["dock.btn.1"]);
	}

	var gridarea;
	function setExtGrid() {
	  Ext.define(gridnms["model.1"], {
	    extend: Ext.data.Model,
	    fields: fields["model.1"]
	  });

	  Ext.define(gridnms["store.1"], {
	    extend: Ext.data.JsonStore, // Ext.data.Store,
	    constructor: function (cfg) {
	      var me = this;
	      cfg = cfg || {};
	      me.callParent([Ext.apply({
	            storeId: gridnms["store.1"],
	            model: gridnms["model.1"],
	            autoLoad: false,
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

	    btnAdd1Click: btnAdd1Click,
	    btnRef1Click: btnRef1Click,
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
	        height: 592,
	        border: 2,
	        scrollable: true,
	        columns: fields["columns.1"],
	        viewConfig: {
	          itemId: 'btnList',
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
	        bufferedRenderer: false,
	        plugins: [{
	            ptype: 'cellediting',
	            clicksToEdit: 1,
	            listeners: {
	              "beforeedit": function (editor, ctx, eOpts) {
	                var data = ctx.record;

	                var editDisableCols = [];
	                // editDisableCols.push("OUTPOSEQ");
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

	function btnAdd1Click(o, e) {
	  var model = Ext.create(gridnms["model.1"]);
	  var store = this.getStore(gridnms["store.1"]);
	  var orgid = $('#searchOrgId option:selected').val();
	  var companyid = $('#searchCompanyId option:selected').val();

	  model.set("ORGID", orgid);
	  model.set("COMPANYID", companyid);
	  model.set("MEMBERID", Ext.getStore(gridnms["store.1"]).count() + 1);
	  model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
	  model.set("EFFECTIVEENDDATE", "4999-12-31");

	  //    store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
	  var view = Ext.getCmp(gridnms['panel.1']).getView();
	  var startPoint = 0;

	  store.insert(startPoint, model);
	  fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], startPoint, 1);
	};

	function btnRef1Click(o, e) {
	  Ext.getStore(gridnms["store.1"]).load();
	};

	function MasterClick(dataview, record, item, index, e, eOpts) {
	  //
	};

	function fn_save() {
	  // 거래처 등록 버튼
	  var customercode = $('#CUSTOMERCODE').val();
	  var customername = $('#CUSTOMERNAME').val();
	  var licenseno = $('#LICENSENO').val();
	  var useyn = $('#USEYN option:selected').val();
	  var header = [],
	  count = 0;
	  var dataSuccess = 0;

	  var OrgId = $('#searchOrgId option:selected').val();
	  var CompanyId = $('#searchCompanyId option:selected').val();

	  if (customername === "") {
	    header.push("거래처명");
	    count++;
	  }
	  if (useyn === "") {
	    header.push("사용유무");
	    count++;
	  }
	  if (licenseno === "") {
	    header.push("사업자번호");
	    count++;
	  }

	  if (count > 0) {
	    extAlert("[필수항목 미입력]<br/>" + header + " 항목을 입력해주세요.");
	    return;
	  }

	  var count1 = Ext.getStore(gridnms["store.1"]).count();
	  var header = [],
	  gridcount = 0;

	  for (var i = 0; i < count1; i++) {
	    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
	    var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

	    var membername = model1.data.MEMBERNAME;
	    var effectivestartdate = model1.data.EFFECTIVESTARTDATE;
	    var effectiveenddate = model1.data.EFFECTIVEENDDATE;

	    if (membername == "" || membername == undefined) {
	      header.push("담당자명");
	      gridcount++;
	    }

	    if (effectivestartdate == "" || effectivestartdate == undefined) {
	      header.push("유효시작일자");
	      gridcount++;
	    }
	    if (effectiveenddate == "" || effectiveenddate == undefined) {
	      header.push("유효종료일자");
	      gridcount++;
	    }

	    if (gridcount > 0) {
	      extAlert("[필수항목 미입력]<br/>추가정보의 " + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
	      return;
	    }
	  }
	  var isNew = customercode.length === 0;
	  var url = "";
	  var msgGubun = "";
	  var succseeCnt = 0;

	  if (isNew) {
	    url = "<c:url value='/insert/customer/CustomerManage.do' />";
	    msgGubun = "등록";
	  } else {
	    url = "<c:url value='/update/customer/CustomerManage.do' />";
	    msgGubun = "변경";
	  }
	  var statuschk = true;

	  Ext.MessageBox.confirm('거래처 ' + msgGubun + ' 알림', msgGubun + '하시겠습니까?', function (btn) {
	    if (btn == 'yes') {
	      // 확인 버튼 눌렀을 때 부적합등록 진행
	      if (statuschk == true) {

	        var params = [];
	        //             console.log($("#master").serialize());
	        $.ajax({
	          url: url,
	          type: "post",
	          dataType: "json",
	          data: $("#master").serialize(),
	          success: function (data) {
	            //             extAlert(data.msg);
	            var isCheck = data.success;
	            var isMsg = data.msg;

	            if (isCheck == true) {
	              extAlert(isMsg);
	              succseeCnt = 1;

	              var gridcnt = Ext.getStore(gridnms["store.1"]).count();
	              for (var j = 0; j < gridcnt; j++) {
	                Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(j));
	                var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];
	                model.set("CUSTOMERCODE", data.CUSTOMERCODE);
	              }

	              Ext.getStore(gridnms["store.1"]).sync({
	                success: function (batch, options) {
	                  extAlert(msgs.noti.save, gridnms["store.1"]);
	                  succseeCnt = 1;
	                },
	                failure: function (batch, options) {
	                  succseeCnt = 0;
	                  extAlert(batch.exceptions[0].error, gridnms["store.1"]);
	                },
	                callback: function (batch, options) {},
	              });

	              if (succseeCnt > 0) {
	                go_url("<c:url value='/customer/CustomerManage.do?code=' />" + data.CUSTOMERCODE + "&org=" + OrgId + "&company=" + CompanyId);
	              }

	            } else {
	              extAlert(isMsg);
	              return;
	            }
	          },
	          error: ajaxError
	        });
	      }

	      return;
	    } else {
	      Ext.Msg.alert('거래처' + msgGubun, msgGubun + '이 취소되었습니다.');

	      return;
	    }
	  });
	}

	function fn_search() {
	  var sparams = {
	    ORGID: $('#searchOrgId').val(),
	    COMPANYID: $('#searchCompanyId').val(),
	    CUSTOMERCODE: $('#CUSTOMERCODE').val(),
	  };

	  extGridSearch(sparams, gridnms["store.1"]);
	}

	function fn_list() {
	  go_url('<c:url value="/customer/CustomerList.do" />');
	}

	function fn_add() {
	  go_url("<c:url value='//customer/CustomerManage.do' />");
	}

	function fn_tab(flag) {
	  $("#tab1, #tab2").removeClass("active");

	  switch (flag) {
	  case "1":
	    // 기본정보
	    $("#tab1").addClass("active");

	    $('#field_basic').show();
	    $('#field_add').hide();

	    break;
	  case "2":
	    // 추가정보
	    $("#tab2").addClass("active");

	    $('#field_basic').hide();
	    $('#field_add').show();

	    break;
	  default:
	    break;
	  }
	}

	function setLovList() {
	  // 은행 Lov
	  //    $("#BANKNAME").bind("keydown", function (e) {
	  //      switch (e.keyCode) {
	  //      case $.ui.keyCode.TAB:
	  //        if ($(this).autocomplete("instance").menu.active) {
	  //          e.preventDefault();
	  //        }
	  //        break;
	  //      case $.ui.keyCode.BACKSPACE:
	  //      case $.ui.keyCode.DELETE:
	  //        //             $("#BANKNAME").val("");
	  //        $("#BANKCODE").val("");
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
	  //        $.getJSON("<c:url value='/searchSmallCodeListLov.do' />", {
	  //          keyword: extractLast(request.term),
	  //          BIGCD: 'CMM',
	  //          MIDDLECD: 'BANK_CODE',
	  //        }, function (data) {
	  //          response($.map(data.data, function (m, i) {
	  //              return $.extend(m, {
	  //                value: m.VALUE,
	  //                label: m.LABEL,
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
	  //        $("#BANKCODE").val(o.item.value);
	  //        $("#BANKNAME").val(o.item.label);

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
                    <div id="content" style="padding-bottom: 5px;">
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
                                    <form id="master" name="master" method="post">
                                            <input type="hidden" id="ORGID" name="ORGID" /> <input type="hidden" id="COMPANYID" name="COMPANYID" />
                                            <fieldset>
                                                    <legend>조건정보 영역</legend>
                                                    <div>
                                                            <table class="tbl_type_view" border="1">
                                                                    <colgroup>
                                                                            <col width="120px">
                                                                            <col width="15%">
                                                                            <col width="120px">
                                                                            <col width="45%">
                                                                            <col width="120px">
                                                                            <col width="25%">
                                                                    </colgroup>
                                                                    <tr style="height: 34px;">
                                                                            <td colspan="6"><c:choose>
                                                                                            <c:when test="${searchVO.GUBUN == 'REGIST'}">
                                                                                                    <div style="vertical-align: middle; float: left; margin-top: 10px;">
                                                                                                            <span style="font-size: 15px; color: red; font-weight: bold;">※ 거래처코드는 등록시 자동채번 됩니다.</span>
                                                                                                    </div>
                                                                                            </c:when>
                                                                                            <c:when test="${searchVO.GUBUN == 'MODIFY'}">
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                            </c:otherwise>
                                                                                    </c:choose>
                                                                                    <div class="buttons" style="float: right; margin-top: 3px;">
                                                                                            <c:choose>
                                                                                                    <c:when test="${searchVO.GUBUN == 'REGIST'}">
                                                                                                            <a id="btnChk1" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
																				                                                                    <a id="btnChk2" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
																				                                                                    <a id="btnChk3" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
                                                                                                    </c:when>
                                                                                                    <c:when test="${searchVO.GUBUN == 'MODIFY'}">
                                                                                                            <a id="btnChk1" class="btn_save" href="#" onclick="javascript:fn_save();"> 변경 </a>
                                                                                                            <a id="btnChk2" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
                                                                                                            <a id="btnChk3" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                            <a id="btnChk1" class="btn_save" href="#" onclick="javascript:fn_save();"> 저장 </a>
                                                                                                            <a id="btnChk2" class="btn_list" href="#" onclick="javascript:fn_list();"> 목록 </a>
                                                                                                            <a id="btnChk3" class="btn_add" href="#" onclick="javascript:fn_add();"> 추가 </a>
                                                                                                    </c:otherwise>
                                                                                            </c:choose>
                                                                                    </div></td>
                                                                    </tr>
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
                                                                            <td colspan="3"><select id="searchCompanyId" name="searchCompanyId" class="input_left " style="width: 50%;">
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

                                                                    </tr>
                                                                    <tr style="height: 34px;">
                                                                            <th class="required_text">거래처코드</th>
                                                                            <td><input type="text" id="CUSTOMERCODE" name="CUSTOMERCODE" class="input_center" style="width: 97%;" value="${searchVO.CUSTOMERCODE}" readonly /></td>
                                                                            <th class="required_text">거래처명</th>
                                                                            <td><input type="text" id="CUSTOMERNAME" name="CUSTOMERNAME" class="input_left" style="width: 97%;" value="${searchVO.CUSTOMERNAME}" /></td>
                                                                            <th class="required_text">사용유무</th>
                                                                            <td><select id="USEYN" name="USEYN" class="input_validation input_left" style="width: 100px;">
                                                                                            <c:choose>
                                                                                                    <c:when test="${searchVO.USEYN == 'Y'}">
                                                                                                            <option value="Y" label="사용" selected />
                                                                                                            <option value="N" label="미사용" />
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                            <option value="Y" label="사용" />
                                                                                                            <option value="N" label="미사용" selected />
                                                                                                    </c:otherwise>
                                                                                            </c:choose>
                                                                            </select></td>
                                                                    </tr>
                                                                    <tr style="height: 34px;">
                                                                            <th class="required_text">비고</th>
                                                                            <td colspan="3"><input type="text" id="REMARKS" name="REMARKS" class="input_left" style="width: 97%;" value="${searchVO.REMARKS}" /></td>
                                                                            <th class="required_text">발주번호 출력여부</th>
                                                                            <td><select id="ORDERYN" name="ORDERYN" class="input_left" style="width: 100px;">
                                                                                            <c:choose>
                                                                                                    <c:when test="${searchVO.ORDERYN == 'Y'}">
                                                                                                            <option value="Y" label="출력" selected />
                                                                                                            <option value="N" label="미출력" />
                                                                                                    </c:when>
                                                                                                    <c:otherwise>
                                                                                                            <option value="Y" label="출력" />
                                                                                                            <option value="N" label="미출력" selected />
                                                                                                    </c:otherwise>
                                                                                            </c:choose>
                                                                            </select></td>
                                                                    </tr>
                                                            </table>
                                                    </div>
                                            </fieldset>
                                            <table style="width: 100%; margin-top: 15px;">
                                                    <tr style="height: 28px;">
                                                            <td style="width: 100%;">
                                                                    <div class="tab line" style="padding-bottom: 0px;">
                                                                            <ul>
                                                                                    <li id="tab1"><a href="#" onclick="javascript:fn_tab('1');" select><span>기본정보</span></a></li>
                                                                                    <li id="tab2"><a href="#" onclick="javascript:fn_tab('2');" select><span>추가정보</span></a></li>
                                                                            </ul>
                                                                    </div>
                                                            </td>
                                                    </tr>
                                            </table>

                                            <div id="field_basic">
                                                    <fieldset>
                                                            <table class="tbl_type_view" border="1">
                                                                    <colgroup>
                                                                            <col width="120px">
                                                                            <col width="15%">
                                                                            <col width="120px">
                                                                            <col width="45%">
                                                                            <col width="120px">
                                                                            <col width="25%">
                                                                    </colgroup>
                                                                    <tr style="height: 34px;">
                                                                            <th class="required_text">거래처분류</th>
                                                                            <td><select id="CUSTOMERTYPE" name="CUSTOMERTYPE" class="input_left" style="width: 97%;">
                                                                                            <c:forEach var="item" items="${labelBox.findByCustomerType}" varStatus="status">
                                                                                                    <c:choose>
                                                                                                            <c:when test="${item.VALUE==searchVO.CUSTOMERTYPE}">
                                                                                                                    <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                                                                            </c:when>
                                                                                                            <c:otherwise>
                                                                                                                    <option value="${item.VALUE}">${item.LABEL}</option>
                                                                                                            </c:otherwise>
                                                                                                    </c:choose>
                                                                                            </c:forEach>
                                                                            </select></td>
                                                                            <th class="required_text">거래처구분</th>
                                                                            <td><select id="CUSTOMERDIV" name="CUSTOMERDIV" class="input_left" style="width: 97%;">
                                                                                            <c:forEach var="item" items="${labelBox.findByCustomerDiv}" varStatus="status">
                                                                                                    <c:choose>
                                                                                                            <c:when test="${item.VALUE==searchVO.CUSTOMERDIV}">
                                                                                                                    <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                                                                            </c:when>
                                                                                                            <c:otherwise>
                                                                                                                    <option value="${item.VALUE}">${item.LABEL}</option>
                                                                                                            </c:otherwise>
                                                                                                    </c:choose>
                                                                                            </c:forEach>
                                                                            </select></td>
                                                                            <th class="required_text">단가구분</th>
                                                                            <td><select id="UNITPRICEDIV" name="UNITPRICEDIV" class="input_left" style="width: 97%;">
                                                                                            <c:forEach var="item" items="${labelBox.findByUnitDiv}" varStatus="status">
                                                                                                    <c:choose>
                                                                                                            <c:when test="${item.VALUE==searchVO.UNITPRICEDIV}">
                                                                                                                    <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                                                                            </c:when>
                                                                                                            <c:otherwise>
                                                                                                                    <option value="${item.VALUE}">${item.LABEL}</option>
                                                                                                            </c:otherwise>
                                                                                                    </c:choose>
                                                                                            </c:forEach>
                                                                            </select></td>
                                                                    </tr>
                                                                    <tr style="height: 34px;">
                                                                            <th class="required_text">대표자명</th>
                                                                            <td><input type="text" id="OWNER" name="OWNER" class="input_left" style="width: 97%;" value="${searchVO.OWNER}" /></td>
                                                                            <th class="required_text">사업자번호</th>
                                                                            <td><input type="text" id="LICENSENO" name="LICENSENO" class="input_left" style="width: 97%;" value="${searchVO.LICENSENO}" /></td>
                                                                            <th class="required_text">전화번호</th>
                                                                            <td><input type="text" id="PHONENUMBER" name="PHONENUMBER" class="input_left" style="width: 97%;" value="${searchVO.PHONENUMBER}" /></td>
                                                                    </tr>
                                                                    <tr style="height: 34px;">
                                                                            <th class="required_text">팩스번호</th>
                                                                            <td><input type="text" id="FAXNUMBER" name="FAXNUMBER" class="input_left" style="width: 97%;" value="${searchVO.FAXNUMBER}" /></td>
                                                                            <th class="required_text">업태</th>
                                                                            <td><input type="text" id="BISSTATUS" name="BISSTATUS" class="input_left" style="width: 97%;" value="${searchVO.BISSTATUS}" /></td>
                                                                            <th class="required_text">업종</th>
                                                                            <td><input type="text" id="BISTYPE" name="BISTYPE" class="input_left" style="width: 97%;" value="${searchVO.BISTYPE}" /></td>
                                                                    </tr>
                                                                    <tr style="height: 34px;">
                                                                            <th class="required_text">마감일</th>
                                                                            <td>
                                                                                <select id="CLOSINGDATE" name="CLOSINGDATE" class="input_left" style="width: 97%;" value="${searchVO.CLOSINGDATE}" >
                                                                                    <c:if test="${empty searchVO.CLOSINGDATE}">
                                                                                        <option value="" label="" />
                                                                                    </c:if>
                                                                                    <c:forEach var="item" items="${labelBox.findByClosingDate}" varStatus="status">
                                                                                        <c:choose>
                                                                                            <c:when test="${item.VALUE==searchVO.CLOSINGDATE}">
                                                                                                <option value="${item.VALUE}" selected>${item.LABEL}</option>
                                                                                            </c:when>
                                                                                            <c:otherwise>
                                                                                                <option value="${item.VALUE}">${item.LABEL}</option>
                                                                                            </c:otherwise>
                                                                                        </c:choose>
                                                                                    </c:forEach>
                                                                                </select>
                                                                            </td>
                                                                            <th class="required_text">홈페이지</th>
                                                                            <td><input type="text" id="HOMEPAGE" name="HOMEPAGE" class="input_left" style="width: 97%;" value="${searchVO.HOMEPAGE}" /></td>
                                                                            <th class="required_text">검색항목</th>
                                                                            <td><input type="text" id="SEARCHDESC" name="SEARCHDESC" class="input_left" style="width: 97%;" value="${searchVO.SEARCHDESC}" /></td>
                                                                    </tr>
                                                                    <tr style="height: 34px;">
                                                                            <th class="required_text">우편번호</th>
                                                                            <td><input type="text" id="ZIPCODE" name="ZIPCODE" class="input_left" style="width: 97%;" value="${searchVO.ZIPCODE}" /></td>
                                                                            <th class="required_text">주소</th>
                                                                            <td colspan="3"><input type="text" id="ADDRESS" name="ADDRESS" class="input_left" style="width: 99%;" value="${searchVO.ADDRESS}" /></td>
                                                                    </tr>
                                                                    <tr style="height: 412px;">
                                                                            <td colspan="6"></td>
                                                                    </tr>
                                                            </table>
                                                    </fieldset>
                                            </div>

                                            <div id="field_add">
																                    <div id="gridArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                                            </div>
                                    </form>
                            </div>
                            <!-- //검색 필드 박스 끝 -->
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