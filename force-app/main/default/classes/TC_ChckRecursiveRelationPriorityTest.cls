@IsTest
public with sharing class TC_ChckRecursiveRelationPriorityTest {
    @IsTest
    public static void TC_CheckRecursiveRelationshipPriorityTest(){
        Test.startTest();
        System.assert(TC_CheckRecursiveRelationshipPriority.runOnce());
        System.assert(!TC_CheckRecursiveRelationshipPriority.runOnce());
        Test.stopTest();
    }
}