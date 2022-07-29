/**
 * Created by nnoman on 05.07.2022.
 */

//or without sharing for org-wide?
public class merger
{
    private class invalidArgumentsException extends Exception {}

    public SObject mergeTwo(SObject obj1, SObject obj2) //Merges two records of the same type (priority given to fields from first one)
    {
        if(obj1.getSObjectType()!= obj2.getSObjectType())
        {
            throw new invalidArgumentsException('Invalid Arguments! Arguments need to be of the same type.');
        }

        SObject mergedRecord = obj1.clone(false,true,true,true);
        Map<String, Object> fieldsObj1 = obj1.getPopulatedFieldsAsMap();
        Map<String, Object> fieldsObj2 = obj2.getPopulatedFieldsAsMap();

        for(String fieldKey : fieldsObj2.keySet())
        {
            if(!fieldsObj1.containsKey(fieldKey))
            {
                System.debug(fieldKey);
                System.debug(fieldsObj2.get(fieldKey));
                mergedRecord.put(fieldKey,fieldsObj2.get(fieldKey));
            }
            else if(fieldsObj1.get(fieldKey)==null && fieldsObj2.get(fieldKey)!=null)
            {
                System.debug(fieldKey);
                System.debug(fieldsObj2.get(fieldKey));
                mergedRecord.put(fieldKey,fieldsObj2.get(fieldKey));
//                mergedRecord.putSObject(fieldKey,fieldsObj2.get(fieldKey));
            }
        }

        return mergedRecord;
    }


}