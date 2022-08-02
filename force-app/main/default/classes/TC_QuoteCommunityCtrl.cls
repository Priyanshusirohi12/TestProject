/**
 * Created on 12/7/17.
 */

public with sharing class TC_QuoteCommunityCtrl {
    @AuraEnabled
    public static User populateUserInfo () {
        return [SELECT Id, Name, UserType FROM User WHERE Id = :UserInfo.getUserId() LIMIT 1];
    }
}