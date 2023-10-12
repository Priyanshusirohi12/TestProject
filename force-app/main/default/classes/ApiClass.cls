@RestResource(urlMapping ='/LeadCreate/')
global class ApiClass {
	@HTTPPost
    global static String doPost(){
        String fieldValue;
        String fieldName;
        String fName;
        String lName;
        String comp;
        
        //List<String> leadList = new String[3];
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        
		System.debug('Param is: '+req.params);
        System.debug('Param is: '+req.requestBody);
    
        String arr = req.requestBody.toString();
        
        JSONParser parser =JSON.createParser(arr);
       	
        While(parser.nextToken() != null){
            if(parser.getCurrentToken() != JSONToken.END_OBJECT)
            {
                parser.nextValue();
                fieldName = parser.getCurrentName();
                fieldValue = parser.getText();
                if(fieldName == 'First Name'){
                    fName = parser.getText();
                }
                else if(fieldName == 'Last Name'){
                    lName = parser.getText();
                }else if(fieldName == 'Company'){
                    comp = parser.getText();
                }
            }
        }
		Lead lc = new Lead(FirstName = fName, lastName = lName, company = comp);
        insert lc;
        return lc.ID;
    }
}