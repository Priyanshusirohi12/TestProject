@RestResource(urlMapping='/Accounts/')
global class NewAccountWebServices {

    @HttpGet
    global static List<Account> getAcountsRecords() {
        return [select id, Name from Account limit 10];
    }

}