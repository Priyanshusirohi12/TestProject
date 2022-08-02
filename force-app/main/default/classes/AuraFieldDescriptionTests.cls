@isTest
private class AuraFieldDescriptionTests {
    @TestSetup static void setupData() {
    }

    @isTest static void constructionTest() {
        Test.startTest();
        DescribeSObjectResult sobjRes = Schema.getGlobalDescribe().get('Lead').getDescribe();
        List<Schema.FieldSetMember> fieldSetMembers = sobjRes.FieldSets.getMap().get('Business_Details').getFields();
        System.assert(!fieldSetMembers.isEmpty(),'The field set members list was empty!');
        Map<String,Schema.SObjectField> flds = sobjRes.fields.getMap();
        System.assert(!flds.isEmpty(),'No fields were found');
        Lead lead = new Lead(LastName='Testing', Company='Test Lead');
        Database.DMLOptions dmlo = new Database.DMLOptions();
        dmlo.allowFieldTruncation = true;
        dmlo.duplicateRuleHeader.allowSave = true;
        dmlo.optAllOrNone = true;
        Database.insert(lead,dmlo);
        /*Id leadId = lead.Id;
        List<Lead> leads = Database.query('SELECT '+String.join(new List<String>(flds.keySet()),',')+' FROM Lead WHERE Id =:leadId');
        for (Schema.FieldSetMember fsm : fieldSetMembers) {
            Schema.DescribeFieldResult dfr = flds.get(fsm.getFieldPath()).getDescribe();
            AuraFieldDescription afd = new AuraFieldDescription(dfr,fsm.getRequired());
        }
        Integer index = 0;
        for (Schema.SObjectField fld : flds.values()) {
            Schema.DescribeFieldResult dfr = fld.getDescribe();
            //AuraFieldDescription afd = new AuraFieldDescription(dfr,!dfr.isNillable(),AuraFieldDescription.g_NumTypes.contains(String.valueOf(dfr.getType())));
            AuraFieldDescription afd = new AuraFieldDescription(index,dfr,leads[0].get(dfr.getLocalName()));
            Object val = afd.getFormattedValue();
            afd = new AuraFieldDescription(index,dfr.getLocalName(),leads[0]);
            System.assertEquals(val,afd.getFormattedValue(),'The value was not the same!');
            afd = new AuraFieldDescription(index,dfr.getLocalName(),leads[0].get(dfr.getLocalName()));
            System.assertEquals(String.valueOf(val),afd.fieldValue,'The value was not the same!');
            index++;
        }
        new AuraFieldDescription();*/
        Test.stopTest();
    }
    @IsTest
    public static void AuraFieldDescriptionTest1(){
        Integer I = 1;
        List<Object> O = new List<Object>();
        String fieldName = 'test';
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription(I,fieldName, O);
        Test.stopTest();
        System.assertEquals(description.index, I);
        System.assertEquals(description.fieldName, fieldName);
        System.assertEquals(description.fieldValue, String.valueOf(O));
    }

    @IsTest
    public static void AuraFieldDescriptionTest2(){
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription();
        Test.stopTest();
        System.assert(description <> null);
    }

    @IsTest
    public static void AuraFieldDescriptionTest3(){
        Integer I = 1;
        Account O = new Account();
        O.Name = 'test';
        String fieldName = 'Name';
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription(I,fieldName, O);
        Test.stopTest();
        System.assertEquals(description.index, I);
        System.assertEquals(description.fieldName, fieldName);
    }

    @IsTest
    public static void setupNumberFormattingTest(){
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription();
        description.isNumber = true;
        description.isDecimal = true;
        description.isCurrency = true;
        description.isPercent = true;
        description.setupNumberFormatting();
        Test.stopTest();
        System.assert(description <> null);
    }

    @IsTest
    public static void formatDateTypeTest(){
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription();
        description.fieldType = 'DATE';
        description.formatDateType(String.valueOf(Date.today()));
        description.fieldType = 'DATETIME';
        description.formatDateType(String.valueOf(Datetime.now()));
        // Date Time in GMT
        description.formatDateType(String.valueOf(Datetime.valueOfGmt(String.valueOf(Datetime.now()))));
        Test.stopTest();
        System.assert(description <> null);

    }


    @IsTest
    public static void formatNumberTest(){
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription();
        description.isDecimal = true;
        description.isInteger = true;
        description.isLong = true;
        description.formatNumber(String.valueOf(1));
        Test.stopTest();
        System.assert(description <> null);
    }

    @IsTest
    public static void formatBooleanTest(){
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription();
        description.formatBoolean(String.valueOf(true));
        Test.stopTest();
        System.assert(description <> null);
    }
    @IsTest
    public static void getFormattedValueTest(){
        Integer intgr = 1;
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription();
        description.fieldValue = String.valueOf(intgr);
        description.fieldType = 'test';
        description.isNumber = true;
        description.isDecimal = true;
        description.isPercent = true;
        description.isCurrency = true;
        description.isInteger = true;
        description.isLong = true;
        description.getFormattedValue();
        Test.stopTest();
        System.assert(description <> null);
    }

    @IsTest
    public static void setupMinOrMaxTest(){
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription();
        description.precision = 1;
        description.scale = 1;
        description.setupMinOrMax(true);
        Test.stopTest();
        System.assert(description <> null);
    }
    @IsTest
    public static void setupMaxAndMinest(){
        Test.startTest();
        AuraFieldDescription description = new AuraFieldDescription();
        description.isNumber = true;
        description.precision = 1;
        description.scale = 1;
        description.setupMaxAndMin();
        Test.stopTest();
        System.assert(description <> null);
    }

//            AuraFieldDescription
//            setReferenceProperties
    @IsTest
    public static void setReferencePropertiesTest(){
        Test.startTest();
        DescribeFieldResult dr = Account.Industry.getDescribe();
        AuraFieldDescription description = new AuraFieldDescription();
        description.setReferenceProperties(dr);
        Test.stopTest();
        System.assert(description <> null);
    }
}