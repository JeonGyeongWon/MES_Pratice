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

<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload.css'/>">
<link rel="stylesheet" href="<c:url value='/js/jQuery-File-Upload-9.9.3/css/jquery.fileupload-ui.css'/>">

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
</style>
<script type="text/javaScript">
var imgCnt = 0;
var selectedItemCode = "";
var filetype = "REPAIR", gubun = "Image1";
var usegroup = "${searchVO.groupId}";
$(document).ready(function () {
    setInitial();
    setValues();
    setExtGrid();
    setReadOnly();
    setLovList();
});

function setInitial() {
    searchFlag = "LIST";
    gridnms["app"] = "equipment";

    calender($('#searchFrom, #searchTo'));

    $('#searchFrom, #searchTo').keyup(function (event) {
        if (event.keyCode != '8') {
            var v = this.value;
            if (v.length === 4) {
                this.value = v + "-";
            } else if (v.length === 7) {
                this.value = v + "-";
            }
        }
    });

    $("#searchFrom").val(getToDay("${searchVO.DATEFROM}") + "");
    $("#searchTo").val(getToDay("${searchVO.DATETO}") + "");

    // 파일첨부 시작
    imgCnt = $("div[id^=fileBox_]").length;
    $("#fileform").fileupload();
    fn_fileBtnBox_display();

    $("#fileform")
    .bind('fileuploadsubmit', function (e, data) {
        data.formData = {
            itemcd: selectedItemCode,
            filetype: filetype,
            gubun: gubun,
        };
    })
    .bind('fileuploadadd', function (e, data) {
        if (selectedItemCode === "") {
            extAlert("설비를 먼저 선택해주세요.");
            return false;
        }

        if (imgCnt > 0) {
            extAlert(msgs.valid.fail.img.limitcnt);
            return false;
        }
        if (!fileValidImg(data.files))
            return false;

        imgCnt++;

        setTimeout(function () {
            getItemFile();
        }, 8000);
    })
    .bind('fileuploadstop', function (e, data) {
        getItemFile();
    })
    .bind('fileuploadfail', function (e, data) {
        imgCnt--;
        fn_fileBtnBox_display();
    });

}

function getItemFile() {
    $("div[id^=fileBox_]").remove();
    $("#filetable").find(".cancel").click();
    $("#filetable").find("tr").remove();
    $.ajax({
        url: "<c:url value='/itemfile/select.do' />",
        type: "post",
        dataType: "json",
        data: {
            itemcd: selectedItemCode,
            filetype: filetype,
            gubun: gubun
        },
        success: function (data) {
            var wth = $("#fileBox").width();
            var hgt = 651; // $("#fileBox").height();
            $.each(data, function (i, m) {
                var html = '';
                html += '<div id="fileBox_' + m.fileid + '" >';
                html += '<a href="' + m.filepathview + m.filenmreal + '" download="' + m.filenmview + '">';
                html += '<iframe alt="" src="' + m.filepathview + m.filenmreal + '" style="width: ' + wth + 'px; height: ' + (hgt - 40) + 'px; " > </iframe>';
                html += '</a>';
                if (usegroup == "ROLE_MANAGER" || usegroup == "ROLE_ADMIN") {
                    html += '<button class="btn btn-sm" href="#" onclick="javascript:fn_file_delete(\'' + m.fileid + '\'); return false;" style="background-color:#009fd6; color:white;">삭제</button>';
                }
                html += '</div>';
                $("#fileBox").append(html);
            });
            imgCnt = $("div[id^=fileBox_]").length;
            fn_fileBtnBox_display();
        },
        error: ajaxError
    });
}

function fn_file_delete(fileid) {
    if (!confirm("삭제하시겠습니까?\n삭제 시 파일은 즉시 제거됩니다."))
        return;

    $.ajax({
        url: "<c:url value='/file/delete.do' />",
        type: "post",
        dataType: "json",
        data: {
            fileid: fileid,
            itemcd: selectedItemCode,
            gubun: gubun,
        },
        success: function (data) {
            if (data.success) {
                $("#fileBox_" + fileid).remove();
                imgCnt--;
                fn_fileBtnBox_display();
            } else {
                alert("삭제 실패하였습니다.");
            }
        },
        error: ajaxError
    });
}

function fn_fileBtnBox_display() {
    if (imgCnt >= 1) {
        $("#fileBtnBox").hide();
    } else {
        $("#fileBtnBox").show();
    }
}

//이미지 등록 / 삭제
function fn_imageHandle(val) {
    if (selectedItemCode === "") {
        extAlert("설비수리 이력항목을 먼저 선택해주세요.");
        return false;
    }

    gubun = val;
    getItemFile();
}

var gridnms = {};
var fields = {};
var items = {};
function setValues() {
    setValues_list();
}

function setValues_list() {
    gridnms["models.list"] = [];
    gridnms["stores.list"] = [];
    gridnms["views.list"] = [];
    gridnms["controllers.list"] = [];

    gridnms["grid.1"] = "EquipmentRepairList";
    gridnms["grid.11"] = "workcenterLov";
    gridnms["grid.12"] = "NonoperTypeLov";
    gridnms["grid.13"] = "NonoperDetailLov";
    gridnms["grid.14"] = "NonoperActionLov";

    gridnms["panel.1"] = gridnms["app"] + ".view." + gridnms["grid.1"];
    gridnms["views.list"].push(gridnms["panel.1"]);

    gridnms["controller.1"] = gridnms["app"] + ".controller." + gridnms["grid.1"];
    gridnms["controllers.list"].push(gridnms["controller.1"]);

    gridnms["model.1"] = gridnms["app"] + ".model." + gridnms["grid.1"];
    gridnms["model.11"] = gridnms["app"] + ".model." + gridnms["grid.11"];
    gridnms["model.12"] = gridnms["app"] + ".model." + gridnms["grid.12"];
    gridnms["model.13"] = gridnms["app"] + ".model." + gridnms["grid.13"];
    gridnms["model.14"] = gridnms["app"] + ".model." + gridnms["grid.14"];

    gridnms["store.1"] = gridnms["app"] + ".store." + gridnms["grid.1"];
    gridnms["store.11"] = gridnms["app"] + ".store." + gridnms["grid.11"];
    gridnms["store.12"] = gridnms["app"] + ".store." + gridnms["grid.12"];
    gridnms["store.13"] = gridnms["app"] + ".store." + gridnms["grid.13"];
    gridnms["store.14"] = gridnms["app"] + ".store." + gridnms["grid.14"];

    gridnms["models.list"].push(gridnms["model.1"]);
    gridnms["models.list"].push(gridnms["model.11"]);
    gridnms["models.list"].push(gridnms["model.12"]);
    gridnms["models.list"].push(gridnms["model.13"]);
    gridnms["models.list"].push(gridnms["model.14"]);

    gridnms["stores.list"].push(gridnms["store.1"]);
    gridnms["stores.list"].push(gridnms["store.11"]);
    gridnms["stores.list"].push(gridnms["store.12"]);
    gridnms["stores.list"].push(gridnms["store.13"]);
    gridnms["stores.list"].push(gridnms["store.14"]);

    fields["model.1"] = [{
            type: 'number',
            name: 'RN'
        }, {
            type: 'string',
            name: 'ORGID'
        }, {
            type: 'string',
            name: 'COMPANYID'
        }, {
            type: 'string',
            name: 'SEQNO'
        }, {
            type: 'string',
            name: 'WORKCENTERCODE'
        }, {
            type: 'string',
            name: 'WORKCENTERNAME'
        }, {
            type: 'date',
            name: 'REPAIRDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'FILEYN'
        }, {
            type: 'string',
            name: 'REASONGUBUN'
        }, {
            type: 'string',
            name: 'REASONBUGUNNAME'
        }, {
            type: 'string',
            name: 'REASON'
        }, {
            type: 'string',
            name: 'REASONNAME'
        }, {
            type: 'string',
            name: 'DETAILREASON'
        }, {
            type: 'string',
            name: 'ACTIONCONTEXT'
        }, {
            type: 'string',
            name: 'ACTIONCONTEXTNAME'
        }, {
            type: 'string',
            name: 'ITEMCODE'
        }, {
            type: 'string',
            name: 'ITEMSTANDARD'
        }, {
            type: 'string',
            name: 'REPAIRCENTERNAME'
        }, {
            type: 'number',
            name: 'MATCOST'
        }, {
            type: 'number',
            name: 'REPAIRCOST'
        }, {
            type: 'number',
            name: 'TOTAL'
        }, {
            type: 'string',
            name: 'ACTIONRESULT'
        }, {
            type: 'string',
            name: 'FOLLOWUP'
        }, {
            type: 'date',
            name: 'ENDDATE',
            dateFormat: 'Y-m-d',
        }, {
            type: 'string',
            name: 'REMARKS'
        }
    ];

    fields["model.11"] = [{
            type: 'string',
            name: 'WORKCENTERCODE',
        }, {
            type: 'string',
            name: 'WORKCENTERNAME',
        }, ];

    fields["model.12"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.13"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

    fields["model.14"] = [{
            type: 'string',
            name: 'VALUE',
        }, {
            type: 'string',
            name: 'LABEL',
        }, ];

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
            //             locked: true,
            //             lockable: false,
            style: 'text-align:center',
            align: "center"
        }, {
            dataIndex: 'WORKCENTERNAME',
            text: '설비명',
            xtype: 'gridcolumn',
            width: 100,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            //             locked: true,
            //             lockable: false,
            style: 'text-align:center;',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.11"],
                valueField: "WORKCENTERNAME",
                displayField: "WORKCENTERNAME",
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
                        var code = record.data.WORKCENTERCODE;

                        model.set("WORKCENTERCODE", code);
                    },
                    change: function (value, nv, ov, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);

                        if (nv != ov) {
                            if (!isNaN(value.getValue())) {

                                model.set("WORKCENTERCODE", "");
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
                         + '<td style="height: 25px; font-size: 12px;">{WORKCENTERNAME}</td>'
                         + '</tr>'
                         + '</table>'
                         + '</div>';
                    }
                },
            },
            renderer: function (value, meta, record) {
                meta.style = " background-color: rgb( 258, 218, 255 ); ";
                return value;
            },
        }, {
            dataIndex: 'REPAIRDATE',
            text: '등록일자',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            //             locked: true,
            //             lockable: false,
            style: 'text-align:center',
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
                meta.style = " background-color: rgb( 258, 218, 255 ); ";
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'FILEYN',
            text: '첨부<br/>유무',
            xtype: 'gridcolumn',
            width: 60,
            hidden: false,
            sortable: false,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            renderer: function (value, meta, record) {
                if (value == "Y") {
                    meta.style = "background-color:rgb(100, 100, 234); ";
                    meta.style += "color: white; ";
                    meta.style += "font-weight: bold;";
                } else {
                    meta.style = " background-color: rgb(234, 234, 234); ";
                }
                return value;
            },
        }, {
            dataIndex: 'REASONGUBUNNAME',
            text: '현상분류',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.12"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: false,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        model.set("REASONGUBUN", record.data.VALUE);

                        var emptyValue = "";
                        var reason = model.data.REASON;
                        if (reason != "") {
                            model.set("REASONNAME", emptyValue);
                            model.set("REASON", emptyValue);
                        }

                        var actioncontext = model.data.ACTIONCONTEXT;
                        if (actioncontext != "") {
                            model.set("ACTIONCONTEXTNAME", emptyValue);
                            model.set("ACTIONCONTEXT", emptyValue);
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
        }, {
            dataIndex: 'REASONNAME',
            text: '현상',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "center",
            editor: {
                xtype: 'combobox',
                store: gridnms["store.13"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        model.set("REASON", record.data.VALUE);

                        var actioncontext = model.data.ACTIONCONTEXT;
                        if (actioncontext != "") {
                            model.set("ACTIONCONTEXTNAME", emptyValue);
                            model.set("ACTIONCONTEXT", emptyValue);
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
        }, {
            dataIndex: 'DETAILREASON',
            text: '원인',
            xtype: 'gridcolumn',
            width: 200,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textareafield',
                allowBlank: true,
                multiline: false,
                editable: true,
            }
        }, {
            dataIndex: 'ACTIONCONTEXTNAME',
            text: '조치내용',
            xtype: 'gridcolumn',
            width: 240,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                multiline: false,
                editable: true,
            },
           /*  editor: {
                xtype: 'combobox',
                store: gridnms["store.14"],
                valueField: "LABEL",
                displayField: "LABEL",
                matchFieldWidth: true,
                editable: false,
                queryParam: 'keyword',
                queryMode: 'remote',
                allowBlank: true,
                typeAhead: true,
                transform: 'stateSelect',
                forceSelection: false,
                listeners: {
                    select: function (value, record, eOpts) {
                        var model = Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0].id);
                        model.set("ACTIONCONTEXT", record.data.VALUE);
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
            }, */
        }, {
            dataIndex: 'ITEMSTANDARD',
            text: '수리부품',
            xtype: 'gridcolumn',
            width: 240,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                multiline: false,
                editable: true,
            },
        }, {
            dataIndex: 'REPAIRCENTERNAME',
            text: '수리업체',
            xtype: 'gridcolumn',
            width: 150,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textfield',
                allowBlank: true,
                multiline: false,
                editable: true,
            },
        }, {
            text: '품목정보',
            menuDisabled: true,
            columns: [{
                    dataIndex: 'MATCOST',
                    text: '부품비',
                    xtype: 'gridcolumn',
                    width: 100,
                    hidden: false,
                    sortable: false,
                    menuDisabled: true,
                    style: 'text-align:center',
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
                            change: function (value, nv, ov, e) {
                                var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];

                                var matcost = nv * 1;
                                var repaircost = record.data.REPAIRCOST * 1;
                                var total = matcost + repaircost;

                                record.set("TOTAL", total);

                            },
                        },
                    },
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'REPAIRCOST',
                    text: '수리비',
                    xtype: 'gridcolumn',
                    width: 100,
                    hidden: false,
                    sortable: false,
                    menuDisabled: true,
                    style: 'text-align:center',
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
                            change: function (value, nv, ov, e) {
                                var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];

                                var matcost = record.data.MATCOST * 1;
                                var repaircost = nv * 1;
                                var total = matcost + repaircost;

                                record.set("TOTAL", total);
                            },
                        },
                    },
                    renderer: function (value, meta, eOpts) {
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, {
                    dataIndex: 'TOTAL',
                    text: '합계',
                    xtype: 'gridcolumn',
                    width: 100,
                    hidden: false,
                    sortable: false,
                    menuDisabled: true,
                    style: 'text-align:center',
                    align: "right",
                    cls: 'ERPQTY',
                    format: "0,000",
                    editor: {
                        xtype: "textfield",
                        allowBlank: true,
                        editable: false,
                    },
                    renderer: function (value, meta, eOpts) {
                        meta.style = " background-color: rgb(234, 234, 234); ";
                        return Ext.util.Format.number(value, '0,000');
                    },
                }, ]
        }, {
            dataIndex: 'ACTIONRESULT',
            text: '조치결과',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textareafield',
                allowBlank: true,
                multiline: false,
                editable: true,
            }
        }, {
            dataIndex: 'ACTIONTIME',
            text: '정지/소요<br/>시간',
            xtype: 'gridcolumn',
            width: 90,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "right",
            editor: {
                xtype: "textfield",
                allowBlank: true,
                multiline: false,
            },
        }, {
            dataIndex: 'FOLLOWUP',
            text: '사후관리',
            xtype: 'gridcolumn',
            width: 120,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textareafield',
                allowBlank: true,
                multiline: false,
                editable: true,
            }
        }, {
            dataIndex: 'ENDDATE',
            text: '완료일',
            xtype: 'datecolumn',
            width: 105,
            hidden: false,
            sortable: true,
            resizable: false,
            menuDisabled: true,
            style: 'text-align:center',
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
                return Ext.util.Format.date(value, 'Y-m-d');
            },
        }, {
            dataIndex: 'REMARKS',
            text: '비고',
            xtype: 'gridcolumn',
            width: 240,
            hidden: false,
            sortable: false,
            menuDisabled: true,
            style: 'text-align:center',
            align: "left",
            editor: {
                xtype: 'textareafield',
                allowBlank: true,
                multiline: false,
                editable: true,
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
            dataIndex: 'SEQNO',
            xtype: 'hidden',
        }, {
            dataIndex: 'WORKCENTERCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'REASONGUBUN',
            xtype: 'hidden',
        }, {
            dataIndex: 'REASON',
            xtype: 'hidden',
        }, {
            dataIndex: 'ACTIONCONTEXT',
            xtype: 'hidden',
        }, {
            dataIndex: 'ITEMCODE',
            xtype: 'hidden',
        }, {
            dataIndex: 'SAVEYN',
            xtype: 'hidden',
        }
    ];

    items["api.1"] = {};
    $.extend(items["api.1"], {
        create: "<c:url value='/insert/equipment/manage/EquipmentRepairList.do' />"
    });
    $.extend(items["api.1"], {
        read: "<c:url value='/select/equipment/manage/EquipmentRepairList.do' />"
    });
    $.extend(items["api.1"], {
        update: "<c:url value='/update/equipment/manage/EquipmentRepairList.do' />"
    });
    $.extend(items["api.1"], {
        destroy: "<c:url value='/delete/equipment/manage/EquipmentRepairList.do' />"
    });

    items["btns.1"] = [];
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
        "#btnSav1": {
            click: 'btnSav1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnDel1": {
            click: 'btnDel1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#btnRef1": {
            click: 'btnRef1Click'
        }
    });
    $.extend(items["btns.ctr.1"], {
        "#EquipmentRepairList": {
            itemclick: 'onMasterClick'
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

function btnAdd1Click(o, e) {
    var model = Ext.create(gridnms["model.1"]);
    var store = Ext.getStore(gridnms["store.1"]);

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

    model.set("ORGID", $('#searchOrgId').val());
    model.set("COMPANYID", $('#searchCompanyId').val());
    model.set("WORKCENTERCODE", $('#searchWorkcenterCode').val());
    model.set("WORKCENTERNAME", $('#searchWorkcenterName').val());

    model.set("SAVEYN", "Y");

    var today = new Date();
    var today_c = Ext.util.Format.date(today, 'Y-m-d');
    model.set("REPAIRDATE", today_c);

    var fileyn = "N";
    model.set("FILEYN", fileyn);

    var view = Ext.getCmp(gridnms['panel.1']).getView();
    var startPoint = 0;

    store.insert(startPoint, model);
    fn_grid_focus_move("UP", gridnms["store.1"], gridnms["views.list"], startPoint, 1);
};

function btnSav1Click(o, e) {
    var count1 = Ext.getStore(gridnms["store.1"]).count();
    var header = [],
    count = 0;

    if (count1 > 0) {
        for (i = 0; i < count1; i++) {
            Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(i));
            var model1 = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

            var workcentercode = model1.data.WORKCENTERCODE;
            var repairdate = model1.data.REPAIRDATE;
            var saveyn = model1.data.SAVEYN;
            if (saveyn == "Y") {

                if (workcentercode == "" || workcentercode == undefined) {
                    header.push("설비명");
                    count++;
                }

                if (repairdate == "" || repairdate == undefined) {
                    header.push("설비 수리일자");
                    count++;
                }
            }

            if (count > 0) {
                extAlert("[생산실적등록 필수항목 미입력]<br/>" + (i + 1) + "번째 줄에 있는 " + header + " 항목을 입력해주세요.");
                return;
            }
        }
    }

    // 저장
    Ext.getStore(gridnms["store.1"]).sync({
        success: function (batch, options) {
            var reader = batch.proxy.getReader();
            extAlert(reader.rawData.msg, gridnms["store.1"]);

            fn_search();
        },
        failure: function (batch, options) {
            extAlert(batch.exceptions[0].error);
        },
        callback: function (batch, options) {},
    });
};

function btnDel1Click(o, e) {
    var store = this.getStore(gridnms["store.1"]);
    var record = Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0];

    var model = Ext.getStore(gridnms['store.1']).getById(Ext.getCmp(gridnms["panel.1"]).selModel.getSelection()[0].id);
    var count = 0;

    if (record === undefined) {
        return;
    }

    if (count == 0) {
        Ext.Msg.confirm('삭제 확인', '삭제하시겠습니까?', function (btn) {
            if (btn == 'yes') {
                store.remove(record);
                Ext.getStore(gridnms["store.1"]).sync({
                    success: function (batch, options) {
                        var reader = batch.proxy.getReader();
                        extAlert(reader.rawData.msg, gridnms["store.1"]);

                        fn_search();
                    },
                    failure: function (batch, options) {
                        msg = batch.operations[0].error;
                        extAlert(msg);
                    },
                    callback: function (batch, options) {},
                });
            }
        });
    }
};

function btnRef1Click(o, e) {
    fn_search();
};

var rowIdx = 0, colIdx = 0;
function onMasterClick(dataview, record, item, index, e, eOpts) {
    rowIdx = e.position.rowIdx;
    colIdx = e.position.colIdx;
    var columnIndex = e.position.column.dataIndex;

    if (columnIndex.indexOf("WORKCENTERNAME") >= 0) {
        // 설비명
    } else if (columnIndex.indexOf("REASONBUGUNNAME") >= 0) {
        // 현상분류

    } else if (columnIndex.indexOf("REASONNAME") >= 0) {
        // 현상
        var reasongubun = record.data.REASONGUBUN;
        if (reasongubun != "") {
            var sparams1 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                BIGCD: 'EQ',
                MIDDLECD: 'NONOPER_TYPE_DETAIL',
                ATTRIBUTE1: reasongubun,
            };
            extGridSearch(sparams1, gridnms["store.13"]);
        } else {
            Ext.getStore(gridnms["store.13"]).removeAll();
        }

    } else if (columnIndex.indexOf("ACTIONCONTEXTNAME") >= 0) {
        // 조치내용
        var reason = record.data.REASON;
        if (reason != "") {
            var sparams2 = {
                ORGID: record.data.ORGID,
                COMPANYID: record.data.COMPANYID,
                BIGCD: 'EQ',
                MIDDLECD: 'NONOPER_ACTION',
                ATTRIBUTE1: reason,
            };
            extGridSearch(sparams2, gridnms["store.14"]);
        } else {
            Ext.getStore(gridnms["store.14"]).removeAll();
        }
    }

    selectedItemCode = record.data.SEQNO;
    //     gubun = 'Image1';
    getItemFile();
}

var gridarea1;
function setExtGrid() {
    setExtGrid_list();

    Ext.EventManager.onWindowResize(function (w, h) {
        gridarea1.updateLayout();
    });
}

function setExtGrid_list() {
    Ext.define(gridnms["model.1"], {
        extend: Ext.data.Model,
        fields: fields["model.1"]
    });

    Ext.define(gridnms["model.11"], {
        extend: Ext.data.Model,
        fields: fields["model.11"]
    });

    Ext.define(gridnms["model.12"], {
        extend: Ext.data.Model,
        fields: fields["model.12"]
    });

    Ext.define(gridnms["model.13"], {
        extend: Ext.data.Model,
        fields: fields["model.13"]
    });

    Ext.define(gridnms["model.14"], {
        extend: Ext.data.Model,
        fields: fields["model.14"]
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
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                DATEFROM: $("#searchFrom").val(),
                                DATETO: $("#searchTo").val(),
                                GUBUN: 'REGIST',
                            },
                            reader: gridVals.reader,
                            writer: $.extend(gridVals.writer, {
                                writeAllFields: true
                            }),
                        },
                        listeners: {
                            load: function (dataStore, rows, bool) {
                                var cnt = rows.length;
                                if (cnt > 0) {
                                    Ext.getStore(gridnms["store.1"]).getById(Ext.getCmp(gridnms["views.list"]).getSelectionModel().select(0));
                                    var model = Ext.getCmp(gridnms["views.list"]).selModel.getSelection()[0];

                                    selectedItemCode = model.data.SEQNO;
                                    getItemFile();
                                } else {

                                    selectedItemCode = "";
                                    getItemFile();

                                }
                            },
                            scope: this
                        },
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
                            url: "<c:url value='/select/master/workcenter/WorkCenterMa.do' />",
                            timeout: gridVals.timeout,
                            extraParams: {
                                ORGID: $("#searchOrgId option:selected").val(),
                                COMPANYID: $("#searchCompanyId option:selected").val(),
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
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
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'EQ',
                                MIDDLECD: 'NONOPER_TYPE',
                                ATTRIBUTE1: 'Y',
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
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'EQ',
                                MIDDLECD: 'NONOPER_TYPE_DETAIL',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["store.14"], {
        extend: Ext.data.Store,
        constructor: function (cfg) {
            var me = this;
            cfg = cfg || {};
            me.callParent([Ext.apply({
                        storeId: gridnms["store.14"],
                        model: gridnms["model.14"],
                        autoLoad: false,
                        pageSize: gridVals.pageSize,
                        proxy: {
                            type: "ajax",
                            url: "<c:url value='/searchSmallCodeListLov.do' />",
                            extraParams: {
                                ORGID: $("#searchOrgId").val(),
                                COMPANYID: $("#searchCompanyId").val(),
                                BIGCD: 'EQ',
                                MIDDLECD: 'NONOPER_ACTION',
                            },
                            reader: gridVals.reader,
                        }
                    }, cfg)]);
        },
    });

    Ext.define(gridnms["controller.1"], {
        extend: Ext.app.Controller,
        refs: {
            EquipmentRepairList: '#EquipmentRepairList',
        },
        stores: [gridnms["store.1"]],
        control: items["btns.ctr.1"],

        btnAdd1Click: btnAdd1Click,
        btnSav1Click: btnSav1Click,
        btnDel1Click: btnDel1Click,
        btnRef1Click: btnRef1Click,
        onMasterClick: onMasterClick,
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
                height: 651,
                border: 2,
                scrollable: true,
                columns: fields["columns.1"],
                defaults: gridVals.defaultField,
                viewConfig: {
                    itemId: 'EquipmentRepairList',
                    striptRows: true,
                    forceFit: true,
                    //                     listeners: {
                    //                         refresh: function (dataView) {
                    //                             Ext.each(dataView.panel.columns, function (column) {
                    //                                 if (column.dataIndex.indexOf('WORKCENTERNAME') >= 0) {
                    //                                     column.autoSize();
                    //                                     column.width += 5;
                    //                                     if (column.width < 120) {
                    //                                         column.width = 120;
                    //                                     }
                    //                                 }
                    //                             });
                    //                         },
                    //                     }
                },
                plugins: [{
                        ptype: 'cellediting',
                        clicksToEdit: 1,
                        listeners: {
                            "beforeedit": function (editor, ctx, eOpts) {
                                var data = ctx.record;
                                var editDisableCols = [];

                                var workcentercode = data.data.WORKCENTERCODE;
                                if (workcentercode != "") {
                                    editDisableCols.push("WORKCENTERNAME");
                                }

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
        models: gridnms["models.list"],
        stores: gridnms["stores.list"],
        views: gridnms["views.list"],
        controllers: gridnms["controller.1"],

        launch: function () {
            gridarea1 = Ext.create(gridnms["views.list"], {
                renderTo: 'gridArea'
            });
        },
    });
}

function fn_validation() {
    var result = true;
    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var searchFrom = $("#searchFrom").val();
    var searchTo = $("#searchTo").val();
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
        header.push("수리일자 From");
        count++;
    }

    if (searchTo == "") {
        header.push("수리일자 To");
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
    var dateFrom = $("#searchFrom").val();
    var dateTo = $("#searchTo").val();
    var searchWorkcenterName = $("#searchWorkcenterName").val();
    var searchWorkcenterCode = $("#searchWorkcenterCode").val();

    var sparams = {
        ORGID: orgid,
        COMPANYID: companyid,
        DATEFROM: dateFrom,
        DATETO: dateTo,
        WORKCENTERCODE: searchWorkcenterCode,
        WORKCENTERNAME: searchWorkcenterName,
        GUBUN: 'REGIST',
    };
    extGridSearch(sparams, gridnms["store.1"]);

    selectedItemCode = "";
    gubun = 'Image1';
    getItemFile();
}

function fn_excel_download() {
    if (!fn_validation()) {
        return;
    }

    var orgid = $('#searchOrgId option:selected').val();
    var companyid = $('#searchCompanyId option:selected').val();
    var dateFrom = $("#searchFrom").val();
    var dateTo = $("#searchTo").val();
    var searchWorkcenterName = $("#searchWorkcenterName").val();
    var searchWorkcenterCode = $("#searchWorkcenterCode").val();
    var title = $('#title').val();

    go_url("<c:url value='/equipment/manage/ExcelDownload.do?GUBUN=' />" + "REPAIR"
         + "&ORGID=" + orgid + ""
         + "&COMPANYID=" + companyid + ""
         + "&DATEFROM=" + dateFrom + ""
         + "&DATETO=" + dateTo + ""
         + "&WORKCENTERCODE=" + searchWorkcenterCode + ""
         + "&WORKCENTERNAME=" + searchWorkcenterName + ""
         + "&GUBUN=" + "REGIST"
         + "&TITLE=" + title + "");
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

    //설비번호 Lov
    $("#searchWorkcenterCode")
    .bind("keydown", function (e) {
        switch (e.keyCode) {
        case $.ui.keyCode.TAB:
            if ($(this).autocomplete("instance").menu.active) {
                e.preventDefault();
            }
            break;
        case $.ui.keyCode.BACKSPACE:
        case $.ui.keyCode.DELETE:
            $("#searchWorkcenterName").val("");
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
                            label: m.WORKCENTERCODE,
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
										<fieldset style="width: 100%;">
												<legend>조건정보 영역</legend>
												<form id="master" name="master" action="" method="post" onkeydown="return fn_key_break(event, 13)" >
														<input type="hidden" id="title" name="title" value="${pageTitle}" />
														<table class="tbl_type_view" border="1">
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
																		<td>
																				<div class="buttons" style="float: right; margin-top: 3px;">
																						<a id="btnChk1" class="btn_search" href="#" onclick="javascript:fn_search();"> 조회 </a>
<!-- 																						<a id="btnChk2" class="btn_excel" href="#" onclick="javascript:fn_excel_download();"> 엑셀 </a> -->
																				</div>
																		</td>
																</tr>
														</table>
														<input type="hidden" id="orgid" name="orgid" /> <input type="hidden" id="companyid" name="companyid" />
														<table class="tbl_type_view" border="1">
																<colgroup>
																		<col width="120px">
																		<col width="22%">
																		<col width="120px">
																		<col>
																		<col width="120px">
																		<col>
																		<col width="120px">
																		<col>
																</colgroup>
																<tr style="height: 34px;">
																		<th class="required_text">수리일자</th>
																		<td><input type="text" id="searchFrom" name="searchFrom" class="input_validation input_center " style="width: 46%;" maxlength="10" /> &nbsp;~&nbsp; <input type="text" id="searchTo" name="searchTo" class="input_validation input_center " style="width: 46%;" maxlength="10" /></td>
																		<th class="required_text">설비명</th>
																		<td><input type="text" id="searchWorkcenterName" name="searchWorkcenterName" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" /></td>
																		<th class="required_text">설비번호</th>
																		<td><input type="text" id="searchWorkcenterCode" name="searchWorkcenterCode" class="imetype input_center" onKeyUp="javascript:this.value=this.value.toUpperCase();" oncontextmenu="return false" style="width: 97%;" /></td>
																		<td></td>
																		<td></td>
																</tr>
														</table>
												</form>
										</fieldset>
								</div>
								<!-- //검색 필드 박스 끝 -->
								<table style="width: 100%;">
										<colgroup>
												<col width="66%">
												<col width="1%">
												<col width="5%">
												<col width="28%">
										</colgroup>
										<tbody>
												<tr>
														<td>
																<div class="subConTit3" style="margin-top: 14px; ">수리내역 LIST</div>
														</td>
														<td></td>
														<td>
																<div class="subConTit3" style="margin-top: 14px; ">이미지</div>
														</td>
														<td>
																<div class="buttons" style="float: left; margin-top: 3px; margin-bottom: 3px;">
																		<a id="btnChk3" class="btn_search" href="#" onclick="javascript:fn_imageHandle('Image1');" style="margin-bottom: 3px;">개선전후</a>
																		<a id="btnChk4" class="btn_search" href="#" onclick="javascript:fn_imageHandle('Image2');">보고서</a>
																</div>
														</td>
												</tr>
										</tbody>
								</table>
								<div id="gridArea" style="width: 66%; padding-bottom: 5px; float: left;"></div>

								<div style="width: 33%; height: 651px; border: 2px solid #81B1D5; float: left; margin-left: 1%; margin-bottom: 4px;">
										<form id="fileform" name="fileform" data-upload-template-id="fileform" class="fileupload" method="POST" action='<c:url value="/itemfile/upload.do" />' enctype="multipart/form-data" data-file-upload="options" data-ng-controller="FileUploadController">
												<div id="fileBox" style="height: auto; width: 100%;">
														<div id="fileBtnBox" style="width: 100%; height: auto;">
																<div class="row" style="margin-top: 320px; text-align: center;">
																		<span class="btn btn-success fileinput-button"> <span>파일추가</span> <input type="file" name="FILE" class="multi with-preview" accept="gif|jpg|png" />
																		</span>
																</div>
														</div>
														<table id="filetable" class="table table-striped files ng-cloak" style="width: 100%;">
																<tr data-ng-repeat="file in queue">
																		<td data-ng-switch data-on="!!file.thumbnailUrl" width="100px" style="vertical-align: middle;">
																				<div class="preview" data-ng-switch-when="true">
																						<a data-ng-href="{{file.url}}" title="{{file.name}}" download="{{file.name}}" data-gallery><img data-ng-src="{{file.thumbnailUrl}}" alt=""></a>
																				</div>
																				<div class="preview" data-ng-switch-default data-file-upload-preview="file"></div>
																		</td>
																		<td width="30%" style="vertical-align: middle;">
																				<p class="name" data-ng-switch data-on="!!file.url">
																						<span data-ng-switch-default>{{file.name}}</span>
																				</p>
																				<p class="size">{{file.size | formatFileSize}}</p>
																		</td>
																		<td style="vertical-align: middle;">
																				<button type="button" class="btn_cancel" data-ng-click="file.$cancel()" data-ng-hide="!file.$cancel" style="margin-bottom: 5px;">취&nbsp;&nbsp;소</button>
																				<button type="button" class="btn_upload" data-ng-click="file.$submit()" data-ng-hide="!file.$submit || options.autoUpload" data-ng-disabled="file.$state() == 'pending' || file.$state() == 'rejected'">업로드</button>
																		</td>
																</tr>
														</table>
												</div>
										</form>
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