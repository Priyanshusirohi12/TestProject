/*
* @author : sfdcdev, Tamarack Consulting, Inc.
* @date : 03/01/2018
* @description: Invocable process to call from a process builder, to auto-approve approval process
*
* © Copyright 2003 - 2018 Tamarack Consulting, Inc.  All Rights Reserved.
*
*/
public class TC_AutoApproval {
       
    @InvocableMethod(label='Run Auto Approval Process' description='Run Auto Approval Process')
    public static void run (List <Id> ids) {
    
        if (!ids.isEmpty ()) {
            TC_AutoApproval.run (ids[0]);
        }
    }
    
    
    public static void run(Id oppId) {
               
        Id userId = UserInfo.getUserId();
        
        TC_AutoApprovalUtility auto = new TC_AutoApprovalUtility();
        //auto.submitComment = 'custom comment';
        auto.submitToProcess('Auto_Approval_Process', oppId, userId);

        if(auto.status == 'SUCCESS'){ //meets entry criteria, so auto approve
            
            //auto.approveComment = 'looks okay. I approve';
            auto.approveProcess(userId);
            
        }else{  //no auto approval, submit to manual approval
            
            // Create an approval request for manual approval
        	TC_AutoApprovalUtility manual = new TC_AutoApprovalUtility();
        	manual.submitComment = 'AUTO Submitting for manual approval';
        	manual.submitToProcess('Manual_Approval_Process', oppId, userId);
                   
            
        }
        
    }
}