/**
 * Author: sfdc, Tamarack Consulting, Inc. 
 * Date: 2019-08-22.
 * Description: 
 */

public without sharing class TC_DocusignUtility {

    public static void testDummy() {
        Integer i = 1;
        i++;
    }
    /*public static void generatePDF(String jsonString, String fileName ,String parentId) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = Blob.valueOf(jsonString);
        cv.Title = fileName;
        cv.PathOnClient = fileName + '.json';
        insert cv;

        List<ContentVersion> cvList = Database.query(
                'SELECT ContentDocumentId ' +
                'FROM ContentVersion ' +
                'WHERE Id = \''+ cv.Id + '\'');
        ContentVersion cvDB = cvList[0];

        List<ContentDocument> cdList = Database.query(
                'SELECT Id ' +
                'FROM ContentDocument ' +
                'WHERE Id = \'' + cvDB.get('ContentDocumentId') + '\'');
        ContentDocument cd = cdList[0];

        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = cd.Id;
        cdl.LinkedEntityId = parentId;
        cdl.ShareType = 'V';
        insert cdl;
    }*/
}