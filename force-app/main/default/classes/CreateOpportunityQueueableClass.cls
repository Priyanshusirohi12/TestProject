public class CreateOpportunityQueueableClass implements Queueable {
    public void execute(QueueableContext QC){
        Opportunity opportunity = new Opportunity(Name='Amit Company',StageName ='Prospecting', CloseDate = date.parse('5/13/2021'));
    	insert opportunity;
    }	
}