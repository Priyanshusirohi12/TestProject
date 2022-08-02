/**
 * Created on 2019-02-09.
 */

public with sharing class TC_GuestFileUploadEventHandler {

    public static void processResults (List <Guest_File_Upload__e> triggerNew) {

        List <ContentDocument> docsDelete = new List <ContentDocument> ();
        List <ContentDocument> docsUpdate = new List <ContentDocument> ();
        List <ContentDocumentLink> cdls = new List <ContentDocumentLink> ();


        for (Guest_File_Upload__e ev : triggerNew) {
            if (ev.Action__c == 'UPDATE') {

                cdls.add (new ContentDocumentLink(ContentDocumentId = ev.Document_Id__c, LinkedEntityId = ev.Parent_Record_Id__c, ShareType='I', Visibility='AllUsers'));
                docsUpdate.add (new ContentDocument(Id = ev.Document_Id__c, OwnerId = UserInfo.getUserId()));
            } else if (ev.Action__c == 'DELETE') {
                docsDelete.add (new ContentDocument(Id = ev.Document_Id__c));
            }
        }

        System.debug(cdls);
        System.debug(docsDelete);

        insert cdls;
        update docsUpdate;
        delete docsDelete;

    }
}