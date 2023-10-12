public class setEmailTemplate {
    
	public List<EmailTemplate> emailTemplateList;
	Map<String, String> mergedFields;
   	Map<String, List<String>> objectMap;
    String emailBody;
    public setEmailTemplate(){
        emailTemplateList = [Select Id, Body, HTMLValue From EmailTemplate Where Id = '00X5g000000HzBTEA0'];
        for(EmailTemplate template : emailTemplateList){
           emailBody = template.HTMLValue;
        }
        System.debug('emailBody ' + emailBody);
        mergedFields = new Map<String,String>();
        objectMap = new Map<String, List<String>>();
        for(Integer i=0; i<emailBody.length() ; i++){
            if(emailBody.substring(i,i+1) == '{'){
                System.debug('emailBody ' + emailBody.substring(i,i+1));
                Integer startPoint = i+2;
                Integer endPoint = emailBody.indexOf('}', i);
                String fullFieldName = emailBody.substring(startPoint,endPoint);
                String objectName = fullFieldName.split('\\.')[0];
                String fieldName = fullFieldName.split('\\.')[1];
                if(objectMap.containsKey(objectName)){
                    List<String> temp = objectMap.get(objectName);
                    temp.add(fieldName);
                    objectMap.put(objectName,temp);
                }else{
                    objectMap.put(objectName,new List<String>{fieldName});
                }
    		}
		}  
        System.debug('objectMap '+ objectMap);
        Map<String, List<SObject>> recordMap = new Map<String, List<SObject>>();  
        for(String objectName : objectMap.keySet()){
            String fields = ''+objectMap.get(objectName);
            fields = fields.split('\\(')[1];
            fields = fields.split('\\)')[0];
        	String query = 'SELECT '+ fields +' FROM '+objectName+' LIMIT 1';	
            System.debug('query '+ query);
            System.debug('Database.query(objectName) '+ Database.query(query));
            List<SObject> sobjectList = Database.query(query);
            recordMap.put(objectName, sobjectList);
    	}
        String fieldName;
        String htmlOutput;
        String template = emailTemplateList[0].HtmlValue;
        String htmlVar = '';
        for(String objectName : recordMap.keySet()){
            System.debug('objectName '+objectName);
       		//EmailTemplate templateVal = emailTemplateList[0]; 
           	Sobject sObjectRecord= recordMap.get(objectName)[0];
            for(String mapObj : objectMap.get(objectName)){
                fieldName = '{!'+objectName+'.'+mapObj+'}';
                if(sObjectRecord.get(mapObj) != null){
                    htmlOutput = template.replace(fieldName, (String)sObjectRecord.get(mapObj));
                    template = htmlOutput;   
                }else if(sObjectRecord.get(mapObj) == null){
                    htmlOutput = template.replace(fieldName, '');
                    template = htmlOutput;
                }
            }   	
        }
    }
}