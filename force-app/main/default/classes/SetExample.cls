public class SetExample {
	public SetExample()
    {
        Set<String> SetValues=new Set<String>();
        SetValues.add('Vinod');
        SetValues.add('Fardin');
        SetValues.add('Moeen');
        System.debug('Size of the Oprater: '+SetValues.size());
        for(String values : SetValues)
        {
            System.debug(values);
        }
        Set<Integer> intValues=new Set<Integer>{1,2,3,4,5,6};
        for(Integer val : intValues)
        {
            System.debug('Integer values: '+val);
        }
            Set<String> stringValues2=new Set<String>{'Bikaner','Kota','Jothpur'};
        for(String val : stringValues2)
            {
                System.debug('String Values'+val);
            }
        Set<Object> Obj=new Set<Object>{'Bikaner','Jaipur',1,2,3};
            for(Object val : Obj)
            {
                System.debug('Object values'+val);
            }
        	stringValues2.addAll(SetValues);
        	System.debug(stringValues2);
        stringValues2.add('Bikarner');
        	System.debug(stringValues2);
    		
        
    }
}