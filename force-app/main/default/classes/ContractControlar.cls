public class ContractControlar {
	public List<IFieldSetMember> fieldmemberList;  
    //public fieldSet List<IFieldSetMember>()
    
    public void getContractFieldSet(){
        String fieldSetApiName = 'test';
        //fieldSet = SObjectType.Account.fieldsets.MyFieldSet.getFields();
        //List<FieldSetMember> contractFieldSet = new List<FieldSetMember>(); 
        //fieldSet = Schema.getGlobalDescribe().get('Contract').getDescribe().fieldSets.getMap().get(fieldSetApiName).getFields()[0];
       	fieldmemberList = new List<IFieldSetMember>(); 
        fieldmemberList = FieldSetMemberListFactory.construct(Schema.getGlobalDescribe().get('Contract').getDescribe().fieldSets
                .getMap().get(fieldSetApiName));
        
        //fieldememberList=  Schema.getGlobalDescribe().get('Contract').getDescribe().fieldSets.getMap().get(fieldSetApiName).getFields();
        
        //fieldSet.add(Schema.SObjectType.Account.fieldSets.getMap().get(fieldememberList));
        if(fieldmemberList.size() > 0){
            
            if(fieldmemberList[0] != null){
                
            }
            System.debug('field set exsist');
        }
    }
}