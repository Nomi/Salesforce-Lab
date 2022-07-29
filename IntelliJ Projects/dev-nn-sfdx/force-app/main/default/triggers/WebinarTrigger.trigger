/**
 * Created by nnoman on 06.07.2022.
 */

trigger WebinarTrigger on Webinar__c (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate))
    {
        WebinarTriggerHandler.handleBeforeInsertOrUpdate(Trigger.new);
        if (Trigger.isUpdate)
        {
            WebinarTriggerHandler.handleBeforeUpdateWithOldMap(Trigger.new, Trigger.oldMap);
            WebinarTriggerHandler.handleBeforeUpdate(Trigger.new);
        }
    }
    else if(Trigger.isAfter && (Trigger.isInsert||Trigger.isUpdate))
    {
        if(Trigger.isInsert)
        {
            WebinarTriggerHandler.handleAfterInsert(Trigger.new);
        }
    }
}