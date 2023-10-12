/*
	Created by : Syed mehdi
	Created Date : May-19-2023
	Purpose :  To Execute/Run ReminderDateNotificationBatch batch class 
*/

public class ReminderDateNotificationBatchScheduler implements Schedulable {
	 public void execute(SchedulableContext sc) {
        //Execture batch
     	Database.executebatch(new ReminderDateNotificationBatch()); 
        
   }
}