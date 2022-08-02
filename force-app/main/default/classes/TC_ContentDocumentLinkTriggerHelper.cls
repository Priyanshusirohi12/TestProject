public class TC_ContentDocumentLinkTriggerHelper {
   
    public static void createDists (Map <Id, ContentDocumentLink> newMap) {
        
        Set <Id> cdIds = new Set <Id> ();
        
        for (ContentDocumentLink cdl : newMap.values ()) {
            cdIds.add (cdl.ContentDocumentId);
        }
        
        Map <Id, ContentDocument> cdMap = new Map <Id, ContentDocument> ([SELECT Id, LatestPublishedVersionId, Title, ContentSize FROM ContentDocument WHERE Id IN :cdIds]);
        
        Map <Id, ContentDistribution> dists = new Map <Id, ContentDistribution> ();
        Map <String, Set<Id>> contentDistributionMap = new Map<String, Set<Id>>();
        
        for (ContentDocumentLink cdl : newMap.values ()) {
            if (cdl.LinkedEntityId.getSObjectType () == Schema.Opportunity.getSObjectType ()) {
                String contentTitle = cdMap.get (cdl.ContentDocumentId).Title;
                Id contentVersionId = cdMap.get (cdl.ContentDocumentId).LatestPublishedVersionId;
                if (!contentDistributionMap.containsKey(contentTitle) ||
                        !contentDistributionMap.get(contentTitle).contains(contentVersionId)) {
                    dists.put (cdl.Id, new ContentDistribution (ContentVersionId = contentVersionId, Name = contentTitle));
                    if (!contentDistributionMap.containsKey(contentTitle)) {
                        contentDistributionMap.put(contentTitle, new Set<Id>{contentVersionId});
                    } else {
                        contentDistributionMap.get(contentTitle).add(contentVersionId);
                    }
                }

            }
            
        }
        if (dists.isEmpty ()) {
            return;
        }

        List<Database.SaveResult> results = Database.insert(dists.values(), false);
        for (Database.SaveResult sr : results) {
            if (!sr.isSuccess()) {
                for (Database.Error err : sr.getErrors()) {
                    System.debug('Error inserting Content Distribution: ' + err);
                }
            }
        }
        
        Set <Id> distIds = new Set <Id> ();
        
        for (ContentDistribution dist : dists.values ()) {
            distIds.add (dist.Id);
        }
        
        Map <Id, ContentDistribution> distsReqeuried = new Map <Id, ContentDistribution> ([SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE Id IN :distIds]);
        
        List <Content_Distribution_Wrapper__c> wrappers = new List <Content_Distribution_Wrapper__c> ();
        
        for (Id cdId : dists.keySet ()) {
            wrappers.add (new Content_Distribution_Wrapper__c (URL__c = distsReqeuried.get (dists.get (cdId).Id).DistributionPublicUrl
                                                              , Opportunity__c = newMap.get (cdId).LinkedEntityId.getSObjectType () == Schema.Opportunity.getSObjectType () ? newMap.get (cdId).LinkedEntityId : null
                                                              , Name = cdMap.get (newMap.get (cdId).ContentDocumentId).Title
                                                              , Size__c = cdMap.get (newMap.get (cdId).ContentDocumentId).ContentSize));
        }
        
        insert wrappers;
        
    }

    public static void updateAccountLogo (Map <Id, ContentDocumentLink> newMap) {
        // To be used when an image is uploaded to an Account for use as a logo on invoices and/or online applications
        Set <Id> cdIds = new Set <Id> ();

        for (ContentDocumentLink cdl : newMap.values ()) {
            if (cdl.LinkedEntityId.getSObjectType () == Schema.Account.getSObjectType ()) {
                cdIds.add (cdl.ContentDocumentId);
            }
        }

        Map <Id, ContentDocument> cdMap = new Map <Id, ContentDocument> ([SELECT Id, LatestPublishedVersionId, Title  FROM ContentDocument WHERE Id IN :cdIds AND Title='accountLogo']);
        if (cdMap.isEmpty ()) {
            return;
        }

        Map <Id, ContentDistribution> dists = new Map <Id, ContentDistribution> ();
        for (ContentDocumentLink cdl : newMap.values ()) {
            try {
                if (cdl.LinkedEntityId.getSObjectType () == Schema.Account.getSObjectType ()) {
                    dists.put (cdl.Id, new ContentDistribution (ContentVersionId = cdMap.get (cdl.ContentDocumentId).LatestPublishedVersionId
                            , Name = cdMap.get (cdl.ContentDocumentId).Title));
                }
            } catch (Exception e) {}
        }

        insert dists.values ();

        Set <Id> distIds = new Set <Id> ();
        for (ContentDistribution dist : dists.values ()) {
            distIds.add (dist.Id);
        }

        Map <Id, ContentDistribution> distsReqeuried = new Map <Id, ContentDistribution> ([SELECT Id, DistributionPublicUrl FROM ContentDistribution WHERE Id IN :distIds]);
        Map <Id, ContentVersion> cvMap = new Map <Id, ContentVersion> ([SELECT Id, ContentBodyId, ContentDocumentId FROM ContentVersion WHERE ContentDocumentId IN :cdMap.keySet()]);

        List<Account> accounts = new List<Account>();

        for (Id cdlId : dists.keySet()) {
            try {
                Id cdId = newMap.get(cdlId).ContentDocumentId;

                String orgDomainString = URL.getOrgDomainUrl().toExternalForm();
                orgDomainString = orgDomainString.replace('.my.salesforce', '--c.documentforce');

                String distributionString = distsReqeuried.get(dists.get (cdlId).Id).DistributionPublicUrl;

                String fullUrl = orgDomainString + '/sfc/dist/version/renditionDownload?rendition=PNG';
                fullUrl += '&versionId=' + cdMap.get(cdId).LatestPublishedVersionId;
                fullUrl += '&contentId=' + cvMap.get(cdMap.get(cdId).LatestPublishedVersionId).ContentBodyId;
                fullUrl += '&d=/a/' + distributionString.substringAfter('/a/');
                fullUrl += '&oid=' + UserInfo.getOrganizationId();

                Id linkedId = newMap.get(cdlId).LinkedEntityId;

                accounts.add(new Account(Id = linkedId, Logo_URL__c = fullUrl));
            } catch (Exception e) {
                // nullPointerException: ContentDocumentLink doesn't point to valid accountLogo file
            }

        }
        upsert accounts;

    }


}