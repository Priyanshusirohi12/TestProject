@IsTest
public with sharing class TestUtility {

    /**
     * This function will retrieve an existing community user or create a new one if none exist
     *
     * @return  A community user
     */
    public static User getCommunityUser() {
        List<User> communityUsers = [SELECT Id FROM User WHERE ContactId <> NULL];
        User comUsr;
        if (communityUsers.isEmpty()) {
            comUsr = createCommunityUser('test','testLn','testFn','test@test-email.com');
        }
        else {
            comUsr = communityUsers[0];
        }

        return comUsr;
    }

    /**
     * This function will construct an opportunity based on the data passed
     *
     * @param acctId    The account Id to associate the opportunity to
     * @param oppNm     The name of the opportunity
     * @param stageNm   The stage name to set the opportunity to
     * @param closeDate The close date to set the opportunity to
     *
     * @return          The constructed opportunity
     */
    public static Opportunity createOpportunity(Id acctId, String oppNm, String stageNm, Date closeDate) {
        return new Opportunity(
            Name = oppNm,
            StageName = stageNm,
            AccountId = acctId,
            CloseDate = closeDate
        );
    }

    /**
     * This function will create the account and contact passed
     *
     * @param accountName   The name of the account to be created
     * @param lastName      The last name of the contact to be created
     * @param firstName     The first name of the contact to be created
     * @param email         The email address of the contact to be created
     *
     * @return              The contact created
     */
    public static Contact createAccountAndContact(String accountName, String lastName, String firstName, String email) {
        Account acct = createAccount(accountName);
        insert acct;
        Contact cont = createContact(acct.Id, firstName, lastName, email);
        return cont;
    }

    /**
     * This function will create an account, contact and community user
     *
     * @param accountName   The name of the account to be created
     * @param lastName      The last name of the contact/user to be created
     * @param firstName     The first name of the contact/user to be created
     * @param email         The email address of the contact/user to be created
     *
     * @return              The community user
     */
    public static User createCommunityUser(String accountName, String lastName, String firstName, String email) {
//        User admin;
        User commUser2Disable;
        //if there is a community user present, we want to disable it so we can ensure that there's a license available
        //We also want to use the run as to disable and create the user so we don't get a mixed DML error
        User admin = [SELECT Id, IsActive FROM User WHERE Profile.Name = 'System Administrator' AND IsActive = TRUE LIMIT 1];
        List<User> users = [SELECT Id,IsActive FROM User WHERE IsActive = TRUE AND (Id = :UserInfo.getUserId() OR (AccountId <> null AND Id != :UserInfo.getUserId())) LIMIT 2];
        if (!users.isEmpty()) {
            for (User u : users) {
                if (u.Id == UserInfo.getUserId()) {
//                    admin = u;
                }
                else {
                    commUser2Disable = u;
                    commUser2Disable.IsActive = false;
                }
            }
        }
        Account acct = createAccount(accountName);
        insert acct;
        Contact cont = createContact(acct.Id, lastName, firstName, email);
        insert cont;
        List<Profile> profile = [SELECT Id FROM Profile WHERE Name = 'Vendor Community User' ORDER BY CreatedDate DESC];
        User comUsr = createUser(profile[0].Id, firstName, lastName, email);
        comUsr.ContactId = cont.Id;

        System.runAs(admin) {
            try {
                insert comUsr;
            } catch (Exception e) {
                //Likely the exception was due to lack of licenses. Trying to disable the user
                try {
                    if (commUser2Disable != null) update commUser2Disable;
                } catch (Exception e2) {
                    //May have hit a row lock issue, trying to update another record here
                    List<User> users2 = [SELECT Id, IsActive FROM User WHERE IsActive = TRUE AND AccountId <> null AND Id != :commUser2Disable.Id AND LastModifiedDate <> TODAY LIMIT 1];
                    if (!users2.isEmpty()) {
                        users2[0].IsActive = false;
                        update users2;
                    }
                }

            }


        }

        return comUsr;
    }

    /**
     * This function will construct a user based on the data passed
     *
     * @param profileId     The profile Id of the user to be created
     * @param firstName     The first name of the user to be created
     * @param lastName      The last name of the user to be created
     * @param email         The email address of the user to be created
     *
     * @return              The constructed user
     */
    public static User createUser(Id profileId, String firstName, String lastName, String email) {
        return new User(
            FirstName = firstName,
            LastName = lastName,
            Email = email,
            ProfileId = profileId,
            Username = email,
            Alias = 'alias',
            TimeZoneSidKey='America/New_York',
            EmailEncodingKey='ISO-8859-1',
            LocaleSidKey='en_US',
            LanguageLocaleKey='en_US'
        );
    }

    /**
     * This function will construct an account
     *
     * @param accountName   The name of the account to be created
     *
     * @return              The constructed account
     */
    public static Account createAccount(String accountName) {
        return new Account(
            Name = accountName
        );
    }

    /**
     * This function will construct a new contact record
     *
     * @param accountId     The account Id of the contact to be crated
     * @param lastName      The last name of the contact to be created
     * @param firstName     The first name of the contact to be created
     * @param email         The email address of the contact to be created
     *
     * @return              The constructed contact
     */
    public static Contact createContact(Id accountId, String lastName, String firstName, String email) {
        return new Contact(
            LastName = lastName,
            FirstName = firstName,
            Email = email,
            AccountId = accountId
        );
    }

    public static ContentVersion createContentVersion(String title, String path) {
        return new ContentVersion(
            VersionData = Blob.valueOf('TESTING'),
            Title= title,
            IsMajorVersion=true,
            PathOnClient=path
        );
    }

    /**
     * This function will construct a vendor program record
     *
     * @param vendorAcctId  The account Id of the vendor the vendor program should be associated with
     *
     * @return              The constructed vendor program record
     */
    /*public static Vendor_Program__c createVendorProgram(Id vendorAcctId) {
        Program_Configuration__c pc = new Program_Configuration__c();
        insert pc;
        return new Vendor_Program__c(Vendor__c = vendorAcctId, Program_Configuration__c = pc.Id, Active__c = true);
    }*/
}