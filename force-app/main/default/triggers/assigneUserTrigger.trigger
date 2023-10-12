trigger assigneUserTrigger on User (before insert) {
	 if(Trigger.isAfter && Trigger.isInsert){
        assigneUserTriggerHelper.toAssignCommunityUser(Trigger.new); 
        
    }
}