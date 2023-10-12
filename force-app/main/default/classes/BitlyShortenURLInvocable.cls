public class BitlyShortenURLInvocable {

    @InvocableMethod(
        label = 'shorten'
        description = 'Given case IDs then generates a bitly short url for them'
    )
    public static void shorten(List<ID> caseIds) {
        // You can't invoke http callouts from Process Builder or Flow
        // because the database transaction has not committed yet, you will get error:
        // "System.CalloutException: You have uncommitted work pending. Please commit or rollback before calling out"
        // To get around this then we'll actually make the call in a @Future method asynchronously.
        shortenAsync( caseIds );
    }
	
    @Future(callout = true)
    private static void shortenAsync(List<ID> caseIds) {

        // Fetch your data and a field where you want to store the generated short url
        List<Case> cases = new List<Case>([ SELECT Id, Short_URL__c FROM Case WHERE Id IN :caseIds ]);

        // Service to actually call out to bitly and get a shortened url
        BitlyService service = new BitlyService();

        // Bitly does not support bulk url shortening
        // so you must make each call individually.
        // Do be aware of Bitly's rate limiting if you try
        // to mass create a bunch of records in short succession
        // https://dev.bitly.com/docs/getting-started/rate-limits
        for (Case caseObj : cases) {
            // in this trivial example, we're just creating short urls to the record itself
            // https://login.salesforce.com/&#39
             caseObj.Short_URL__c = service.shorten('https://ibirds29-dev-ed.lightning.force.com/' + caseObj.id);
        }

        // update the records with their short urls
        // use workflow or trigger to fire off the short url field being populated
        // to then send email alerts, etc. including the short url
        if (cases.size() > 0) {
            update cases;
        }

    }

}