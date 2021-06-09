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
	���� ���� ū ������ Group���� ���� �����Ƿ� Group�� �������� 
	��ü Data�� ���� �� �� �ִ�.
	XML ������ �����͸� Tree���·� Parsing �ϴ� parserXmlNodeData()�� Call�Ѵ�.
********************************************************************/
function refreshTreeData(xmlData) {
	var xmlGroups = null;
	if (xmlData.getElementsByTagName("Reload").length == 0 ) {
		xmlGroups = xmlData.getElementsByTagName("ROW");
		parserXmlNodeData(xmlGroups);
		return;
	}	else {
		alert('���� Group �Ǵ� BIZ�� ���� ������ ���� �ش� �������� ReLoad �˴ϴ�.');
		self.clearInterval(reCall);
		var frm = document.reLoad;
		frm.submit();
		
	}
}


/********************************************************************
	XML ������ �����͸� Tree ���·� Parsing �Ѵ�.
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
