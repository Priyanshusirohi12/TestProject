global class TC_LeadSubmissionResponseBean {
    
    public String status;
    public String leadId;
    public List <String> messages;
    
    public TC_LeadSubmissionResponseBean () {
        status = '';
        leadId = '';
        messages = new List <String> ();
    }
    

}