public class LoginController {
    public String userName {get;set;}
    public String password {get;set;}
    public pageReference login(){
        String url= '/ibirdsCommunity/_ui/core/chatter/ui/ChatterPage';
       return Site.login(userName, password, url); 
    }
}