@IsTest global with sharing class TC_EditEquipmentTest{
    
    @testSetup static void setupData() {
        
        Account acc = new Account();
        acc.Name = 'test';
        
        insert acc;
        
        
        Opportunity opp = new Opportunity();
        opp.Name = 'test1';
        opp.CloseDate = Date.today();
        opp.StageName = 'test';
        opp.AccountId = acc.Id;
        
        insert opp;
        
        Id vendorType = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Vendor').getRecordTypeId();
        Account vendor = new Account();
        vendor.Name = 'vendor';
        vendor.RecordTypeId = vendorType;
        
        insert vendor;
        

        Equipment__c eq1 = new Equipment__c();
        eq1.Name = 'test eq 1';
        eq1.Opportunity__c = opp.Id;
        eq1.Vendor__c = vendor.Id;
        
        insert eq1;
        
        
        
    }
    
    @isTest static void test1() {
        Opportunity sourceOpp = [SELECT Id FROM Opportunity WHERE Name = 'test1'];
        ApexPages.currentPage().getParameters().put('id',sourceOpp.Id);
        
        TC_EditEquipment ctrl = new TC_EditEquipment();
          
 
        Test.startTest();        
        
        String eqGrid = ctrl.getequipment();
        ctrl.seterrRow('123');
        ctrl.getandClose();
        ctrl.seterrRow('1');
        ctrl.geterrRow();
        ctrl.getheader();
        ctrl.getId();
        ctrl.getoppName();
        ctrl.seteqData(eqGrid);
        ctrl.geteqData(); 
        ctrl.save();
        
        //ctrl.seteqData('[["","test eq 1","0.00","","1","make","model","","","","","","vendor"]]'); //bad JSON
        ctrl.setandClose(TRUE);
        ctrl.getandClose();
        ctrl.save();
        
        Test.stopTest();
    }
}