@isTest
public class TC_ChangeOwnerCtrlTest {
	@testSetup
    private static void testSetup(){
        Opportunity opp = new Opportunity();
        opp.Name = 'Testing';
        opp.StageName = '010 - Application Entry';
        opp.CloseDate = Date.newInstance(2019, 10, 10);
        insert opp;
        
        Account acc = new Account();
        acc.Name = 'Test Owner Change Account';
        insert acc;
        
        Contact cont = new Contact();
        cont.FirstName = 'Jane';
        cont.LastName = 'Doe';
        insert cont;
        
        Lead l = new Lead();
        l.Status = 'New';
        l.Company = 'Testing Lead Owner Change';
        l.FirstName = 'John';
        l.lastName = 'Doe';
        insert l;
        
    }
    @isTest
    static void testGetOpportunity() {
        Opportunity opp = [SELECT ID FROM Opportunity WHERE Name = 'Testing'];
        Opportunity opp2 = TC_ChangeOwnerCtrl.getOpportunity(opp.Id);
        System.assertEquals(opp.Id, opp2.Id);
        
        Opportunity opp3 = TC_ChangeOwnerCtrl.getOpportunity('000000000000000000');
        System.assertEquals(null, opp3);
    }
    @isTest
    static void testGetContact() {
        Contact cont = [SELECT ID FROM Contact WHERE Name = 'Jane Doe'];
        Contact cont2 = TC_ChangeOwnerCtrl.getContact(cont.Id);
        System.assertEquals(cont.Id, cont2.Id);
        
        Contact cont3 = TC_ChangeOwnerCtrl.getContact('000000000000000000');
        System.assertEquals(null, cont3);
    }
    @isTest
    static void testGetAccount() {
        Account acc = [SELECT ID FROM Account WHERE Name = 'Test Owner Change Account'];
        Account acc2 = TC_ChangeOwnerCtrl.getAccount(acc.Id);
        System.assertEquals(acc.Id, acc2.Id);
        
        Account acc3 = TC_ChangeOwnerCtrl.getAccount('000000000000000000');
        System.assertEquals(null, acc3);
    }
    @isTest
    static void testGetLead() {
        Lead l = [SELECT ID FROM Lead WHERE Company = 'Testing Lead Owner Change'];
        Lead l2 = TC_ChangeOwnerCtrl.getLead(l.Id);
        System.assertEquals(l.Id, l2.Id);
        
        Lead l3 = TC_ChangeOwnerCtrl.getLead('000000000000000000');
        System.assertEquals(null, l3);
    }
    @isTest
    static void testSetOwnerId() {
        User u = [SELECT Id FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = true ORDER BY LastModifiedDate LIMIT 1];
        Opportunity opp = [SELECT ID, OwnerId FROM Opportunity WHERE Name = 'Testing'];
        Contact cont = [SELECT ID, OwnerId FROM Contact WHERE Name = 'Jane Doe'];
        Account acc = [SELECT ID, OwnerId FROM Account WHERE Name = 'Test Owner Change Account'];
        Lead l = [SELECT ID, ownerId FROM Lead WHERE Company = 'Testing Lead Owner Change'];
        TC_ChangeOwnerCtrl.setOwnerId(opp.Id, u.Id);
        TC_ChangeOwnerCtrl.setOwnerId(cont.Id, u.Id);
        TC_ChangeOwnerCtrl.setOwnerId(acc.Id, u.Id);
        TC_ChangeOwnerCtrl.setOwnerId(l.Id, u.Id);
        TC_ChangeOwnerCtrl.setOwnerId('000000000000000000', u.Id);
    }
}