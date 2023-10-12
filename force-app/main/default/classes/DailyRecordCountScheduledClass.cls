public class DailyRecordCountScheduledClass implements Schedulable {
    public String test;
    public DailyRecordCountScheduledClass(String test){
    	this.test = test;   
    }
    
    public void execute(SchedulableContext SC){
        System.debug('testing data '+test);
        DailyRecordCountClass dailyRecordCountClass= new DailyRecordCountClass();
        dailyRecordCountClass.sendEmail();
    }
}