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
    max-height: 400px;
    overflow-y: auto;
    /* prevent horizontal scrollbar */
    overflow-x: hidden;
}
* html .ui-autocomplete {
  /* IE 6.0 */
  height: 400px;
}
</style>
<script type="text/javaScript">
$(document).ready(function() {
    setValues();
    setExtGrid();
    
    setReadOnly();
    
    setLovList();
});

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    gridnms["models.cmmbigclass"] = [];
    gridnms["stores.cmmbigclass"] = [];
    gridnms["views.cmmbigclass"] = [];
    gridnms["controllers.cmmbigclass"] = [];
    
    gridnms["app"] = "base";
    gridnms["grid.1"] = "CmmBigclass";  
    gridnms["grid.11"] = "orgLov";
    
    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.cmmbigclass"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.cmmbigclass"].push(gridnms["controller.1"]);
    
    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
 
    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];

    gridnms["models.cmmbigclass"].push(gridnms["model.1"]);
    gridnms["models.cmmbigclass"].push(gridnms["model.11"]);
 
    gridnms["stores.cmmbigclass"].push(gridnms["store.1"]);
    gridnms["stores.cmmbigclass"].push(gridnms["store.11"]);
 
    fields["model.1"] = [ {
        type : 'number',
        name : 'RNUM'   // 변수 명
    }, {
        type : 'string',
        name : 'ORGID'
    }, {
        type : 'string',
        name : 'COMPANYID'
    }, {
        type : 'string',
        name : 'COMPANYNAME',
    }, {
        type : 'string',
        name : 'REMARKS'
    },  {
        type : 'string',
        name : 'CRBY',
    }, {
        type : 'date',
        name : 'CRDATE',
        dateFormat : 'Y-m-d'
    }, {
        type : 'string',
        name : 'LUBY'
    }, {
        type : 'date',
        name : 'LUDATE',
        dateFormat : 'Y-m-d'
    },{
        type : 'date',
        name : 'EFFECTIVESTARTDATE',
        dateFormat : 'Y-m-d',
    }, {
        type : 'date',
        name : 'EFFECTIVEENDDATE',
        dateFormat : 'Y-m-d',
    },];
    
    fields["model.2"] = [{
        type : 'string',
        name : 'VALUE'
    }, {
        type : 'string',
        name : 'LABEL'
    } ];

    fields["columns.1"] = [{
        dataIndex : 'COMPANYID',
        text : '공장ID',
        xtype : 'gridcolumn',
        width : 70,
        hidden : false,  
        sortable : false,
//         resizable : false,
        align : "center",
        editor : {
            xtype: 'textfield',
            allowBlank: true,
        }
    }, {
        dataIndex : 'COMPANYNAME',
        text : '공장명',
        xtype : 'gridcolumn',
        width : 200,
        hidden : false,
        sortable : false,
//         resizable : false,
        align : "center",
        editor : {
            xtype: 'textfield',
            allowBlank: true,
        }
    }, {
        dataIndex : 'ORGNAME',
        text : '사업장명',
        xtype : 'gridcolumn',
        width : 200,
        hidden : false,
        sortable : false,
        align : "center",
        editor : {
            xtype : 'combobox',
            store : gridnms["store.11"],
            valueField: "LABEL",
            displayField: "LABEL",
            matchFieldWidth: true,
            editable: false,
            queryParam : 'keyword',
            queryMode : 'remote', // 'local',
            allowBlank: true,
            typeAhead: true,
            transform: 'stateSelect',
            forceSelection: true,
            listeners : {
                select : function(value, record, eOpts) {
                    var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.cmmbigclass"]).selModel.getSelection()[0].id);
                    
                    model.set("ORGID", record.get("VALUE"));
                },
                blur : function (field, e, eOpts) {
                    var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.cmmbigclass"]).selModel.getSelection()[0].id);
                    if ( field.getValue() == "" ) {
                        model.set("ORGID", "");
                    }
                },
            },
            listConfig : {
                loadingText : '검색 중...',
                emptyText : '데이터가 없습니다. 관리자에게 문의하십시오.',
                width : 330,
                getInnerTpl : function() {
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
    },{
        dataIndex : 'ORGID',
        xtype : 'hidden',
    }, {
        dataIndex : 'CRBY',
        xtype : 'hidden',
    }, {
        dataIndex : 'REMARKS',
        text : '비고',
        xtype : 'gridcolumn',
        width : 290,
        hidden : false,
        sortable : false,
//         resizable : false,
        align : "left",
        editor : {
            xtype: 'textfield',
            allowBlank: true,
        }
    }, {
        dataIndex : 'EFFECTIVESTARTDATE',
        text : '시작일자',
        xtype : 'datecolumn',
        width : 105,
        hidden : false,
        sortable : false,
        align : "center",
        format : 'Y-m-d',
        editor : {
            xtype : 'datefield',
            enforceMaxLength : true,
            maxLength : 10,
            allowBlank : true,
            format : 'Y-m-d',
            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
        },
    }, {
        dataIndex : 'EFFECTIVEENDDATE',
        text : '종료일자',
        xtype : 'datecolumn',
        width : 105,
        hidden : false,
        sortable : false,
        align : "center",
        format : 'Y-m-d',
        editor : {
            xtype : 'datefield',
            enforceMaxLength : true,
            maxLength : 10,
            allowBlank : true,
            format : 'Y-m-d',
            altFormats: 'Y-m-d|Ymd|Y m d|Y-m d|Y-md',
        },
    },{
        dataIndex : 'CRBY',
        xtype : 'hidden',
    }, {
        dataIndex : 'CRDATE',
        xtype : 'hidden',
    }, {
        dataIndex : 'LUBY',
        xtype : 'hidden',
    }, {
        dataIndex : 'LUDATE',
        xtype : 'hidden',
		},  ];
    
    items["api.1"] = {};
    $.extend(items["api.1"],{
        create : "<c:url value='/insert/company/CompanyRegedit.do' />"
    });
    $.extend(items["api.1"],{
        read : "<c:url value='/select/company/CompanyRegedit.do' />" 
    });
    $.extend(items["api.1"],{
        update : "<c:url value='/update/company/CompanyRegedit.do' />"
    });
    $.extend(items["api.1"],{
        destroy : "<c:url value='/delete/company/CompanyRegedit.do' />" 
    });
    
    items["btns.1"] = [];
    items["btns.1"].push({
        xtype : "button",
        text : "추가",
        itemId : "btnAdd1"
    });
    items["btns.1"].push({
        xtype : "button",
        text : "삭제",
        itemId : "btnDel1"
    });
    items["btns.1"].push({
        xtype : "button",
        text : "저장",
        itemId : "btnSav1"
    });     
    items["btns.1"].push({
        xtype : "button",
        text : "새로고침",
        itemId : "btnRef1"
    });
    
    items["btns.ctr.1"] = {};
    $.extend(items["btns.ctr.1"], {
        "#btnAdd1" : {
            click : 'btnAdd1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnDel1" : {
            click : 'btnDel1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnSav1" : {
            click : 'btnSav1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnRef1" : {
            click : 'btnRef1Click'
        }
    });

    items["dock.paging.1"] = {
        xtype : 'pagingtoolbar',
        dock : 'bottom',
        displayInfo : true,
        store : gridnms["store.1"],
    };
    
    items["dock.btn.1"] = {
        xtype : 'toolbar',
        dock : 'top',
        displayInfo : true,
        store : gridnms["store.1"],
        items : items["btns.1"],
    };
    
    items["docked.1"] = [];
    items["docked.1"].push(items["dock.btn.1"]);
}

function btnAdd1Click(o, e) {
    var model = Ext.create(gridnms["model.1"]);
    var store = this.getStore(gridnms["store.1"]);

    model.set("EFFECTIVESTARTDATE", "${searchVO.datefrom}");
    model.set("EFFECTIVEENDDATE", "4999-12-31");
    
    store.insert(Ext.getStore(gridnms["store.1"]).count() + 1, model);
 }; 
 
 function btnSav1Click(o, e) {
    var model = Ext.getStore(gridnms['store.1']).getById(Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0].id);
    var count = 0;
    
    // 미입력 사항 체크
    var check1 = model.get("ORGID")+"";
    if (check1.length == 0) {
        extAlert("사업장ID를 입력하세요.");
        count++;
    }
    
    var check = model.get("COMPANYID")+"";
    if (check.length == 0) {
        extAlert("공장 ID를 입력하세요.");
        count++;
    }
    
    // 저장
    if ( count == 0 ) {
        Ext.getStore(gridnms["store.1"]).sync({
            success : function(batch, options) {
                extAlert(msgs.noti.save, gridnms["store.1"]);
            },
            failure : function(batch, options) {
                extAlert(batch.exceptions[0].error, gridnms["store.1"]);
            },
            callback : function(batch, options) {
            },
         });
    }
};

function btnDel1Click(o, e) {
    extGridDel (gridnms["store.1"], gridnms["panel.1"]);  
};

function btnRef1Click(o, e) {
   Ext.getStore(gridnms["store.1"]).load();
};

var bigLayout;
function setExtGrid() {
    Ext.define(gridnms["model.1"], {
        extend : Ext.data.Model,
        fields : fields["model.1"]
    });

    Ext.define(gridnms["model.11"], {
        extend : Ext.data.Model,
        fields : fields["model.11"]
    });
    
    Ext.define(gridnms["store.1"], {
        extend : Ext.data.Store,
        constructor : function(cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([ Ext.apply({
                storeId : gridnms["store.1"],
                model : gridnms["model.1"],
                autoLoad : true,
                pageSize : 999999,
                proxy : {
                    type : 'ajax',
                    api : items["api.1"],
                    extraParams : {
                    },
                    reader          : gridVals.reader,
                    writer          : $.extend(gridVals.writer, {writeAllFields: true}),
                }
            }, cfg) ]);
        },
    });

    Ext.define(gridnms["store.11"], {
        extend : Ext.data.Store,
        constructor : function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                storeId : gridnms["store.11"],
                model : gridnms["model.11"],
                autoLoad : true,
                pageSize : gridVals.pageSize,
                proxy : {
                    type : 'ajax',
                    url : "<c:url value='/searchOrgLov.do' />",
                    extraParams : {
                    },
                    reader : gridVals.reader,
                }
            }, cfg)]);
        },
    });
    
    Ext.define(gridnms["controller.1"], {
        extend : Ext.app.Controller,
        refs : {
            BigclassListGrid : '#BigclassListGrid',
        },
        stores : [ gridnms["store.1"] ],
        control : items["btns.ctr.1"],
        
        btnAdd1Click : btnAdd1Click,
        btnSav1Click : btnSav1Click,
        btnDel1Click : btnDel1Click,
        btnRef1Click : btnRef1Click,
    });
    
    Ext.define(gridnms["panel.1"], {
        extend : Ext.panel.Panel,
        alias : 'widget.' + gridnms["panel.1"],
        layout : 'fit',
        header : false,
        items : [ {
            xtype : 'gridpanel',
            selType : 'cellmodel',
            itemId : gridnms["panel.1"],
            id : gridnms["panel.1"],
            store : gridnms["store.1"],
            height : 572,
            border : 2,
            scrollable : true,
            columns : fields["columns.1"],
            defaults : gridVals.defaultField,
            viewConfig : {
                itemId : 'BigclassListGrid',
                striptRows : true,
                forceFit : true,
                listeners: {
                	refresh : function ( dataView ) {
                		Ext.each(dataView.panel.columns, function ( column ) {
                			if ( column.dataIndex.indexOf( 'BIG' ) >= 0 ) {
                				column.autoSize();
                				column.width += 5;
                				if ( column.width < 80 ) {
                					column.width = 80;
                				}
                			}
                		});
                	}
                },
            },
            plugins : [ {
                ptype : 'cellediting',
                clicksToEdit : 1,
                listeners: {
                    "beforeedit": function(editor, ctx, eOpts) {
                    	  var editDisableCols = ["COMPANYID"];
                    	  
                        var isNew = ctx.record.phantom || false;
                        if(!isNew && $.inArray(ctx.field, editDisableCols) > -1 ) return false;
                        else {
                            return true;
                        }
                    }
                },
            } ],
            dockedItems : items["docked.1"],
        } ],
    });

    Ext.application({
        name : gridnms["app"],
        models : gridnms["models.cmmbigclass"],
        stores : gridnms["stores.cmmbigclass"],
        views : gridnms["panel.1"],
        controllers : gridnms["controller.1"],

        launch : function() {
            bigLayout = Ext.create(gridnms["panel.1"], {
                renderTo : 'gridCmmbigclassListArea'
            });
        },
    });
    
    Ext.EventManager.onWindowResize(function(w, h) {
        bigLayout.updateLayout();
    });
}

function fn_search() {
    if(!valid_chk("search")) return;
    var sparams = {
        "searchParam1" : $("#searchParam1").val()+"",
        "searchParam2" : $("#searchParam2").val()+"",
        "orgid" : $("#searchOrgId").val()+"",
        "companyid" : $("#searchCompanyId").val()+""
    };
    
    extGridSearch(sparams, gridnms["store.1"]);
}

function setLovList() {
    $("#searchParam1")
    .bind( "keydown", function( e ) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ( $( this ).autocomplete( "instance" ).menu.active ) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#searchParam1").val("");
            $("#searchParam2").val("");
            break;
        case $.ui.keyCode.ENTER:
            $(this).autocomplete("search", "%");
            break;

        default : break;
        }
    })
    
    .focus(function(e){
        $(this).autocomplete("search", ( this.value === "" )?"%":this.value);
    })
    .autocomplete({
        source : function(request, response) {
            $.getJSON("<c:url value='/cmmclass/searchlov.do' />", {
                keyword : extractLast(request.term)
            }, function(data) {
                response($.map(data.data, function(m, i) {
                    return $.extend(m, {
                        label : m.LABEL,
                        value : m.VALUE
                    });
                }));
            });
        },
        search : function() {
            if(this.value === "") return;
            
            var term = extractLast(this.value);
            if (term.length < 1) {
                return false;
            }
        },
        focus : function() {
            return false;
        },
        select : function(e, o) {
            $("#searchParam2").val(o.item.value);
            $("#searchParam1").val(o.item.label);
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
            <div id="content" >
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
                    <div id="search_field" style="margin-bottom:10px;">
                        <div id="search_field_loc">
                            <h2>
                                <strong>${pageTitle}</strong>
                            </h2>
                        </div>
                        <input type="hidden" id="OrgidVal" value="<c:out value='${OrgidVal}'/>" />
                        <input type="hidden" id="CompanyidVal" value="<c:out value='${CompanyidVal}'/>" />
                        <input type="hidden" id="BigcdVal" value="<c:out value='${BigcdVal}'/>" />
                        <input type="hidden" id="MiddlecdVal" value="<c:out value='${MiddlecdVal}'/>" />
                            <fieldset>
                                <legend>조건정보 영역</legend>
                                <div>
                                    <table class="tbl_type_view" border="1">
                                        <colgroup>
                                            <col width="100%">
                                            
                                            <col>
                                        </colgroup>
                                        <tr>
                                                                             
                                            <td>
                                                <div class="buttons" style="float: right; margin-top: 3px;">
	                                                <div class="buttons" style="float: right;">
		                                                <a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();">
		                                                   조회
		                                                </a>
	                                                </div>
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </fieldset>
                        </div>
                        <!-- //검색 필드 박스 끝 -->
                        <div id="gridCmmbigclassListArea" style="width: 100%; padding-bottom: 5px; float: left;"></div>
                    </div>
            </div>
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