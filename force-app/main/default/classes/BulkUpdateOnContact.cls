public class BulkUpdateOnContact {
   public List<Contact> contactList{set;get;}
   public BulkUpdateOnContact(){
        contactList =new List<Contact>();
		contactList=[SELECT Id, FirstName, LastName, AccountId FROM Contact];
    }
    public PageReference updateRecords(){
        Upsert contactList;
        PageReference pgUpdateRecords= new PageReference('https://ibirds29-dev-ed.my.salesforce.com/003/o');
        pgUpdateRecords.setRedirect(true);
        return pgUpdateRecords;
    }
    public PageReference cancelRecords(){
        PageReference pgCancelRecords= new PageReference('https://ibirds29-dev-ed.my.salesforce.com/003/o');
        pgCancelRecords.setRedirect(true);
        return pgCancelRecords;  
        }
    }