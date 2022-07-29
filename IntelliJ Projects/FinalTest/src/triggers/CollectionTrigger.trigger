/**
 * Created by nnoman on 22.07.2022.
 */

trigger CollectionTrigger on Collection__c (after insert, after update)
{
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            CollectionTriggerHandler.handleAfterInsert(Trigger.new);
        }
        else if (Trigger.isUpdate)
        {
            CollectionTriggerHandler.handleAfterInsert(Trigger.new);
        }
    }
}