@isTest
public class ContractControlarTest {
	@isTest
    static void testGetContractFieldSet(){  
        FieldSetMemberListFactory.setMock(
    	new List<SObjectField> { Contract.Name, Contract.Description });  
        
		String fieldSetApiName = 'credit_package_dnb';
        ContractControlar contractCntl = new ContractControlar();
        contractCntl.fieldmemberList = FieldSetMemberListFactory.construct(
     	Schema.SObjectType.Contract.fieldSets.getMap().get(fieldSetApiName));
        contractCntl.getContractFieldSet();
    }
}