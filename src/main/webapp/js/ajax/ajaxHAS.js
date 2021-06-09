/**
    Created by: Byoung Su Lee
    on: 05/23/2006
*/

function fnRefreshData() {
	var xmlHttp = newXMLHttpRequest();
	xmlHttp.onreadystatechange = getReadyStateHandler(xmlHttp, setRefreshData);
	xmlHttp.open("POST", "/VIStatusManagerServlet", true);
	xmlHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
	xmlHttp.send("type=has&mode=AJAX");
}


function setRefreshData(xmlData){
	refreshTreeData(xmlData);
//	refreshDocumentElement();
}

/********************************************************************
	현재 가장 큰 단위를 Group으로 묶여 있으므로 Group을 가져오면 
	전체 Data를 가져 올 수 있다.
	XML 형식의 데이터를 Tree형태로 Parsing 하는 parserXmlNodeData()를 Call한다.
********************************************************************/
function refreshTreeData(xmlData) {
	var xmlGroups = null;
	if (xmlData.getElementsByTagName("Reload").length == 0 ) {
		xmlGroups = xmlData.getElementsByTagName("ROW");
		parserXmlNodeData(xmlGroups);
		return;
	}	else {
		alert('현재 Group 또는 BIZ에 변경 사항이 생겨 해당 페이지가 ReLoad 됩니다.');
		self.clearInterval(reCall);
		var frm = document.reLoad;
		frm.submit();
		
	}
}


/********************************************************************
	XML 형태의 데이터를 Tree 형태로 Parsing 한다.
*********************************************************************/
function parserXmlNodeData(xmlGroups) {
    var rowXML = null;
	var gNode = null;
	var rData = new Array();
	var colXML = null;

    for(var i = 0; i < xmlGroups.length; i++) {
        rowXML = xmlGroups[i];
		var rRow = new Array();
		for ( var k=0; k < rowXML.childNodes.length; k++)	{
			colXML = rowXML.childNodes[k];
			if (k == 2 || k == 3 || k == 4 || k == 5 || k == 6 || k == 9 || k == 21 || k == 22 || k == 23 || k == 24 || k == 25 || k == 26 )	{
				rRow[k] = "'"+colXML.childNodes[0].nodeValue +"'";
			}	else {
				rRow[k] = colXML.childNodes[0].nodeValue;
			}
			
		}
		rData[i] = rRow;
	}

	data = rData;
	diagram();
}
