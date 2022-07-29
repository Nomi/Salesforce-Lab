/**
 * Created by nnoman on 05.07.2022.
 */

//or without sharing for org-wide?
/**
 * A helpful class for merging duplicate records.
 */
public with sharing class RecordsMerger
{
    //Apparently, it might be good to put public methods above private methods (so that the publicly visible things are on top?).
    private class InvalidArgumentsException extends Exception {}

    /** Returns merged two records of the same type (priority given to fields from first one)
     * @param obj1 Master record
     * @param obj2 Duplicate record
     *
     * @return SObject of the merged record.
     */
    public SObject mergeTwo(SObject obj1, SObject obj2) //Merges two records of the same type (priority given to fields from first one)
    {
        if(obj1.getSObjectType()!= obj2.getSObjectType())
        {
            throw new InvalidArgumentsException('Invalid Arguments! Arguments need to be of the same type.'); //could use TypeException without creating a subclass.
        }

        SObject mergedRecord = obj1.clone(false,true,true,true);
        Map<String, Object> fieldsObj1 = obj1.getPopulatedFieldsAsMap();
        Map<String, Object> fieldsObj2 = obj2.getPopulatedFieldsAsMap();

        Set<String> obj2Keys = new Set<String>();//(fieldsObj2.keySet());
        obj2Keys.addAll(fieldsObj2.keySet());
//        //Helpful for Query in Database class (like prepare in SQLite)
//        List<String> listObj2Keys = new List<String>(obj2Keys);
//        String lol = String.join(listObj2Keys,' ');
//        System.debug(lol);
//        //The conversion to strings might not be even needed. Read more about query syntax?

        for(String fieldKey : obj2Keys)//fieldsObj2.keySet()) <-reference so don't use
        {
            if(!fieldsObj1.containsKey(fieldKey))
            {
                mergedRecord.put(fieldKey,fieldsObj2.get(fieldKey));
            }
            else if(obj1.get(fieldKey)==null)
            {
                mergedRecord.put(fieldKey,fieldsObj2.get(fieldKey));
//                mergedRecord.putSObject(fieldKey,fieldsObj2.get(fieldKey));
            }
        }

        return mergedRecord;
    }

    /**
     * @return List of picklist entries of the Accounts object.
     */
    public List<Schema.PicklistEntry> getAccountSourcePicklistEntries()
    {
        return Account.AccountSource.getDescribe().getPicklistValues();
    }
}




//////Anonymous Apex Function for Testing
//RecordsMerger mdr = new RecordsMerger();
//
//Account acc1 = [SELECT Name, Type FROM Account  ORDER BY Id ASC LIMIT 1];
//acc1.put('Name',null);
//Account acc2 = [SELECT Name, Type FROM Account  ORDER BY Id DESC LIMIT 1];
//acc2.put('Name','lol');
//Contact con = [SELECT FIELDS(STANDARD) FROM Contact  ORDER BY Id DESC LIMIT 1];
//
////mdr.mergeTwo(acc1,acc2);
//System.debug(mdr.mergeTwo(acc1,acc2));
//mdr.mergeTwo(acc1,con);