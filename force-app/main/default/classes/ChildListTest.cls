@isTest public class ChildListTest {

    @testSetup static void setupChildList () {
        
        List <Child_List_Field__c> clfList = new List <Child_List_Field__c> {
            new Child_List_Field__c (Child_Field_Set_API_Name__c = 'test_class'
                                                        , Child_Lookup_Field_API_Name__c = 'AccountId'
                                                        , Child_Object_API_Name__c = 'Opportunity'
                                                        , Display_Actions__c = true
                                                        , Hex_Background_Color__c = '4286f4'
                                                        , Is_Active__c = true
                                                        , List_Type__c = 'Bulleted List'
                                                        , Parent_Object_API_Name__c = 'Account'
                                                        , Parent_Rich_Text_Area_API_Name__c = 'Quote_Options__c')
                                                        
             , new Child_List_Field__c (Child_Field_Set_API_Name__c = 'test_class'
                                                        , Child_Lookup_Field_API_Name__c = 'AccountId'
                                                        , Child_Object_API_Name__c = 'Opportunity'
                                                        , Display_Actions__c = true
                                                        , Hex_Background_Color__c = '4286f4'
                                                        , Is_Active__c = true
                                                        , List_Type__c = 'HTML Table'
                                                        , Parent_Object_API_Name__c = 'Account'
                                                        , Parent_Rich_Text_Area_API_Name__c = 'Quote_Options__c')};
        insert clfList;
        
        Account acc = new Account (Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity (Name = 'test child list', StageName = 'test', CloseDate = Date.today () + 10, AccountId = acc.Id);
        insert opp;
    
    }
    
    @isTest static void testProcessBuilder () {
        ChildListProcessBuilderUtil.generateTable (new List <Id> {[SELECT Id FROM Opportunity WHERE Name = 'test child list'][0].Id});
    }

}