public class ListExample {
	public ListExample(){
       List<String> ListExample= new List<String>();
  		ListExample.add('Fardin');
        ListExample.add('Priyanshu');
        ListExample.add('Himanshu');
        ListExample.add('Abdul');
        ListExample.add('Vinod');
        System.debug(ListExample.size());
        System.debug(ListExample.get(0));
        System.debug(ListExample.get(1));
        System.debug(ListExample.get(2));
        System.debug(ListExample.get(3));
        System.debug(ListExample.get(4));
        List<String> copyNameList=new List<String>(ListExample);
        copyNameList.add(1,'Narandra');
        copyNameList.add(3,'Rahul');
		System.debug(copyNameList.size()); 
        System.deBug(copyNameList.contains('Vinod'));
        for(String copyValues : copyNameList)
        {
         	System.debug(copyValues);   
        }
       // System.debug(copyNameList.indexOf(4));
        System.debug(copyNameList.get(3));
        System.debug('Index of'+copyNameList.indexOf('Narandra'));
        System.debug('isEmpty'+copyNameList.isEmpty());
        System.debug('isEmpty'+copyNameList.equals(ListExample));
        
    }
}