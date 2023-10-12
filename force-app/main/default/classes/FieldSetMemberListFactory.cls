public class FieldSetMemberListFactory
{

     private static List<IFieldSetMember> s_mockFieldSetMemberList;

     /** 
      * Constructs a IFieldSetMember list based on the given field set
  IFieldSetMember    **/
     public static List<IFieldSetMember> construct(Schema.FieldSet fieldSet)
     {
          // Return the mock response?
         if(Test.isRunningTest() && s_mockFieldSetMemberList!=null){
              return s_mockFieldSetMemberList;
         }

          // Return the actual response from an actual FieldSet resolved at runtime
          List<IFieldSetMember> fieldSetMemberList = new List<IFieldSetMember>();
         for(Schema.FieldSetMember member : fieldSet.getFields()){
              fieldSetMemberList.add(new RuntimeContextImpl(member));
         }
         return fieldSetMemberList;
     }

     /**
      * Provides a mock response to the 'construct' method during a test context
      **/
     @TestVisible
     private static void setMock(List<SObjectField> mockFields)
     {
          // Mocks the list of fields via a list of SObjectField's
     	s_mockFieldSetMemberList = new List<IFieldSetMember>();
        for(SObjectField field : mockFields){
        	s_mockFieldSetMemberList.add(new TestContextImpl(field));
        }	
     }

     private class RuntimeContextImpl implements IFieldSetMember
     {
         public Schema.FieldSetMember  member;
         public RuntimeContextImpl(Schema.FieldSetMember member){
          	this.member = member;   
         }
         public Schema.DisplayType getType(){
         	return Schema.getGlobalDescribe().get('Contract').getDescribe().fields.getMap().get('testFieldSet').getDescribe().getType();
         }
         public Schema.FieldSetMember getFieldSetMember(){
             return Schema.getGlobalDescribe().get('Contract').getDescribe().fieldSets
                .getMap().get('testName').getFields()[0];
         }
     }

     private class TestContextImpl implements IFieldSetMember
     {
         public SObjectField field;
         public TestContextImpl(SObjectField field){
             this.field = field;
             Schema.DisplayType getValue =  getType();
             Schema.FieldSetMember fieldSetMember = getFieldSetMember();
         }
      
         public Schema.DisplayType getType(){
            //return Schema.getGlobalDescribe().get('Contract').getDescribe().fields.getMap().get('testFieldSet').getDescribe().getType();
         	return null;
         }
         public Schema.FieldSetMember getFieldSetMember(){
         	//return Schema.SObjectType.Contract.fieldSets.getMap().get('testFieldSet').getFields()[0];   
         	return null;
         }
          // Implement the constructor and methods by delegating to SObjectField.getDescribe result
     }
}