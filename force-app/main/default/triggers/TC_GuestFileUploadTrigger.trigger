trigger TC_GuestFileUploadTrigger on Guest_File_Upload__e (after insert) {
    System.debug(Trigger.new);
    TC_GuestFileUploadEventHandler.processResults (Trigger.new);
}