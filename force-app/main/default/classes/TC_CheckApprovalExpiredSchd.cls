public without sharing class TC_CheckApprovalExpiredSchd implements Schedulable {

  public void execute(SchedulableContext sc) {

    TC_CheckApprovalExpiredBatch b = new TC_CheckApprovalExpiredBatch ();
    database.executebatch(b, 200);
  }
}