/**
 * Created by eschneider on 9/23/20.
 */

@IsTest
private class TC_ContactTriggerHelperTest {
    @IsTest
    public static void originatorTieToAppTest(){
        Account a = new Account();
        a.Name = 'test';
        insert a;

        Contact c = new Contact();
        c.Email = 'test@test.com';
        c.AccountId = a.Id;
        c.FirstName = 'test';
        c.LastName = 'test';
        insert c;
    }
}