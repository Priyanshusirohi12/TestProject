public class formPage {
    public String City {get;set;}
    public List<String> nameList{get;set;}
    public String Name {get;set;}
    public formPage()
    {
        nameList =new List<String>();
        nameList.add('Priyanshu');
        nameList.add('Rahul');
        nameList.add('Pradeep');
        nameList.add('Pankaj');
        nameList.add('Tarun');
        City='Jaipur';
    }
    public void setCity()
    {
        System.debug('@@'+ City);
    }
    public void setName()
    {
        System.debug(Name);
    }
    public List<SelectOption> getsetName()
    {
       List<SelectOption>addNameList = new List<SelectOption>();
       for(String Name : nameList){
           addNameList.add(new SelectOption(Name,Name));
       }
   		return addNameList;
    }
}