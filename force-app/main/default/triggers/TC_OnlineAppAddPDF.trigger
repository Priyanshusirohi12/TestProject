trigger TC_OnlineAppAddPDF on Online_Application_Add_PDF__e (after insert) {
	TC_OnlineAppAddPDFHandler.linkOnlineAppPDF (Trigger.newMap);
}