trigger TC_Account on Account (before insert, before update) {
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            TC_AccountTriggerHelper.fillRecordTypeText(Trigger.new);
        } else if (Trigger.isUpdate) {
            TC_AccountTriggerHelper.fillRecordTypeText(Trigger.new);
        }
	}

}