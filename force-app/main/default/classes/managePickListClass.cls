/*global class ListViewButtonController {
    List<SObject> selectedSobjects;
    public Set<Id> recordIds{ get; set; }
    public String accIds;    
    global String evRespone { get; set; }    
    //global ListViewButtonController(ApexPages.StandardController controller) {}    
    global ListViewButtonController(ApexPages.StandardSetController controller) {
        evRespone = '';
        selectedSobjects = controller.getSelected();
        recordIds = new Set<Id>();
        for(SObject singleRec : selectedSobjects) {
            recordIds.add(singleRec.Id);
        }
        System.debug(recordIds) ;
        

    }   
}*/

global class managePickListClass{
	@InvocableMethod (label='Get PickList data' description='Use to Add some text in the String')
	public static List<Result> getAccountIds(List<Request> request) {
	String name = request.get(0).pickListValue; //'Salesforce;Google;Apple;Microsoft;Ford';
	name = name.replaceAll(';', '; ');
	System.debug('names '+name);
        Result resultWrapper = new Result();
        resultWrapper.pickListValues = name;
        return new List<Result>{resultWrapper};
   }
 
   public class Request{
        
        @InvocableVariable
        public String pickListValue;

        
    }
    
    public class result{
        
        @InvocableVariable
        public String pickListValues;

        
    }
    
}