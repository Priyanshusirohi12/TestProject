public class InlineAddContactController {
    public Attachment attachment {get;set;}
    public List<Attachment> attachmentList {get;set;}
    public InlineAddContactController(ApexPages.StandardController controller){
        //contact =new Contact();
        attachment =new Attachment();
        attachment.ParentId=controller.getId();
        //System.debug('@@'+attachment.ParentId);
         attachmentList = [Select Id, Name,ContentType  from Attachment where ParentId =: attachment.ParentId And ContentType Like '%image%'];
        //System.debug(attachmentList);
        
    }
}