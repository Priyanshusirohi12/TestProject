@isTest

private class TC_DealDocumentsUploadCtrlTest {
    @testSetup
    static void setupData () {
        Account acc = new Account ();
        acc.Name = 'Main Account';
        insert acc;
        
        Opportunity opp = new Opportunity ();
        opp.Name = 'Test Opp';
        opp.CloseDate = date.newInstance(2013, 12, 1);
        opp.StageName = 'Approved';
        opp.AccountId = acc.Id;
        insert opp;
        
        
        ContentVersion c = new ContentVersion();
        c.Title = 'test.txt';          
        c.Origin = 'C';
        c.PathOnClient = 'test.txt';
        c.Description = 'test';
        c.Mark_To_Delete__c = FALSE;
        //c.TC_Origination__Parent_Id__c = opp.Id;
        c.Document_Source__c = 'Syndication Partner Upload';
        c.VersionData = Blob.valueOf('test');
        insert c;        
        
    }
    
    
    @isTest
    static void test () {
        Test.startTest();
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        
        TC_DealDocumentsUploadCtrl.getOpportunities(opp.Id);
        List <ContentVersion > files = TC_DealDocumentsUploadCtrl.getContent(opp.Id);
        
        List<Id> ids = new List<Id>();
        
        for(ContentVersion file : files){
            ids.add(file.Id);
        }
        
        TC_DealDocumentsUploadCtrl.markDeleteFiles(opp.Id, ids);
        TC_DealDocumentsUploadCtrl.unmarkDeleteFiles(opp.Id, ids);
        
        Test.stopTest();
    }
}