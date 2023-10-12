public class MargeAttachmentConttroller { 
    List<Sobject> allListValue;
    MargeAttachmentWrapper attachmentWrapperObject;
    onClickPopupWrapper onClickPopupWrapperObject;
    public List<onClickPopupWrapper> onClickPopupWrapperList {get;set;}
    public String objectValue {get;set;}
    public String objectValuePopup {get;set;}
    set<Id> parentObjectsId;
    public Boolean checkAll {get;set;}
    public List<MargeAttachmentWrapper> attachmentWrapperList {get;set;}
    public Boolean showButton{get;set;}
    public Boolean displayPopup {get;set;}
    List<Attachment> checkedAttachmeunt;
    
    public MargeAttachmentConttroller(){ 
       
    }
    public void putAttachment(){
        attachmentWrapperList = new List<MargeAttachmentWrapper>();
        checkedAttachmeunt =new List<Attachment>();
         parentObjectsId = new set<Id>(); 
        if(objectValue != null){
            String query='Select Id, Name from '+objectValue; 
            allListValue=database.query(query);
            for(Sobject obj : allListValue){
                parentObjectsId.add(obj.Id); 
            }  
             
            for(Attachment attach : [SELECT Id, Name, ContentType, body, parentId FROM Attachment where ParentId =:parentObjectsId And ContentType Like '%image%']){
               attachmentWrapperObject =new MargeAttachmentWrapper();
               attachmentWrapperObject.attachment=attach;
               attachmentWrapperList.add(attachmentWrapperObject);
            }
            System.debug(attachmentWrapperList);
        } 
    }
    public void sObjectRecords(){
        //objectValue='';
    	onClickPopupWrapperList =new List<onClickPopupWrapper>();
        if(objectValuePopup != null){
        String query='Select Id, Name from '+objectValuePopup;
        database.query(query);
        for(sObject obj : database.query(query)){
            onClickPopupWrapperObject = new onClickPopupWrapper(obj);
            onClickPopupWrapperObject.sobjectRecord=obj;
            onClickPopupWrapperList.add(onClickPopupWrapperObject);
        }
        
        System.debug('@@@ ' +onClickPopupWrapperList);
        }
   }
    public void setSelectedRecord(){
        	for(MargeAttachmentWrapper mtw : attachmentWrapperList){
                if(checkAll){
              		mtw.CheckboxValue=true;
                    showButton= true;
                }
            }
            for(MargeAttachmentWrapper mtw : attachmentWrapperList){
         	    if(!checkAll){
            	  mtw.CheckboxValue=false;
                    showButton= false;
               }
            }
    }
    public void showButtonOnClick(){
        displayPopup=true;
        
    }
    public void setCheckboxValue(){
        checkAll = true;
        showButton = false;
        for(MargeAttachmentWrapper mtw : attachmentWrapperList){
            if(!mtw.CheckboxValue){
                checkAll=false;
            }else{
                showButton=true;
            }
              
        } 
    }
    public void fillsObject(){
        displayPopup=false;
        
        List <Attachment> insertAttachmentList =new List<Attachment>();
        for(onClickPopupWrapper obj : onClickPopupWrapperList){
            if(obj.checkBoxpopUp){
        	for(MargeAttachmentWrapper attach : attachmentWrapperList){
            	if(attachmentWrapperObject.CheckboxValue ||checkAll){
               		insertAttachmentList.add (new Attachment (name = attach.attachment.name, body = attach.attachment.body, parentId=obj.sobjectRecord.Id));
                }
            }
            }
         }
        insert insertAttachmentList;
    }	     
    public class MargeAttachmentWrapper{       
        public Attachment attachment {get;set;}  
        public Boolean CheckboxValue {get;set;}
        public MargeAttachmentWrapper(){   
            CheckboxValue =false;
        }    
    }
    public class onClickPopupWrapper{
        public Sobject sobjectRecord {get;set;} 
        public Boolean checkBoxpopUp {get;set;}
        public String tempValue {get;set;}
        public onClickPopupWrapper(sObject record){
            tempValue = String.valueOf(record.get('Name'));
            checkBoxpopUp =false;      
        }    
    }
}