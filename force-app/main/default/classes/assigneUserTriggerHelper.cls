public class assigneUserTriggerHelper {
    public static void toAssignCommunityUser(List<User> userList){
        Set<Id> profileIdSetId = new Set<Id>();
        Map<Id,Profile> profileMap;
        List<PermissionSetAssignment> permissionSetAssignmentList = new List<PermissionSetAssignment>();
        for(User user : userList){
        	profileIdSetId.add(user.ProfileId);
        }
        profileMap = new Map<Id,Profile>([SELECT Id, Name FROM Profile WHERE ID in : profileIdSetId]);
        PermissionSet permissionSet = [SELECT Id, Name, Profile.Name 
                                       FROM PermissionSet 
                                       where Profile.Name = 'Customer Community Login User' Limit 1];
        for(User user : userList){
            if(profileMap.containsKey(user.ProfileId)){
                Profile profileObject = profileMap.get(user.ProfileId);
            	if(profileObject.Name.equals('Customer Community Login User') && user.isActive == true){
                	PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permissionSet.Id, AssigneeId = user.Id);    
            		permissionSetAssignmentList.add(psa);    
                }         
          	}
		}
        if(permissionSetAssignmentList.size()>0){
            insert permissionSetAssignmentList;
        }
		
	}
}