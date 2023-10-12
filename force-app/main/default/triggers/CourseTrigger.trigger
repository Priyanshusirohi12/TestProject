trigger CourseTrigger on Course__c (before insert,before update) {
	integer countPriceInvalide=0;
    for(Course__c courseObject : Trigger.new)
    {
        if(courseObject.fees__c == NULL || courseObject.fees__c == 0)
        {
            courseObject.fees__c.addError('Course Fees id empty Fill it');
        }
    }
}