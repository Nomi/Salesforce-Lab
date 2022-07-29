/**
 * Created by nnoman on 21.07.2022.
 */

trigger ActionTrigger on Action__c(before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    if(Trigger.isAfter && Trigger.isUpdate)
    {
//        ActionTriggerHandler.handleAfterUpdate(Trigger.newMap.keySet(),Trigger.oldMap);
    }
}