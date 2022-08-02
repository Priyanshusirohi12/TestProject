@isTest
private class TC_QuickAppEntryCtrlTest {
	
	@isTest static void testNewRecord() {

		Test.setCurrentPage(Page.TC_QuickAppEntry);
		Test.startTest();

		TC_QuickAppEntryCtrl ctrl = new TC_QuickAppEntryCtrl ();
		ctrl.saveDeal();

		//throws error on the page
		System.assert(ApexPages.hasMessages());


		//populate required fields and try again
		ctrl.opp.CloseDate = System.today();
		ctrl.opp.StageName = 'Pipeline';
		ctrl.opp.Name = 'Pipeline';
		ctrl.acc.Name = 'test account';

		ctrl.saveDeal();




		Test.stopTest();	

		System.assertEquals(1, [SELECT Id FROM Opportunity].size());
	}
	
	@isTest static void testExistingRecord() {
		Schema.DescribeSObjectResult d = Schema.SObjectType.Account;
        String borrowerRtId = d.getRecordTypeInfosByName().get('Borrower').getRecordTypeId();
        String  vendorRtId = d.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();

        Account borrower = new Account ();
        borrower.Name = 'borrower';
        borrower.RecordTypeId = borrowerRtId;
        insert borrower;

        Account bor2 = borrower.clone();
        bor2.Name = 'bor2';
        insert bor2;

        Account vendor = new Account ();
        vendor.RecordTypeId = vendorRtId;
        vendor.Name = 'test';
        insert vendor;

        Opportunity opp = new Opportunity ();
        opp.Name = 'test opp';
        opp.CloseDate = System.today();
        opp.StageName = 'Pipeline';
        opp.AccountId = borrower.Id;

        insert opp;

        Test.setCurrentPage(Page.TC_QuickAppEntry);
        ApexPages.currentPage().getParameters().put('id', opp.Id);

        Test.startTest();
        
        
        TC_QuickAppEntryCtrl ctrl = new TC_QuickAppEntryCtrl ();
        ctrl.selectedAccountId = bor2.Id;

        ctrl.saveDeal();


        ctrl.selectAccount();
        ctrl.selectedVendorId = vendor.Id;
        ctrl.selectVendor();
        ctrl.selectGuarantor();

        ctrl.saveDeal();

        ctrl.saveContactGuar();
        ctrl.saveReferenceRecord();
        ctrl.saveEquipment();
        TC_QuickAppEntryCtrl.doSSNSearch('test');
        TC_QuickAppEntryCtrl.doVendorSearch('test');
        TC_QuickAppEntryCtrl.doGuarSearch('test');

        Test.stopTest();

	}
	
}