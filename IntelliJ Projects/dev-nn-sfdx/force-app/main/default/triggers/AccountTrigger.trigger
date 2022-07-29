/**
 * Created by nnoman on 15.07.2022.
 */

trigger AccountTrigger on Account (after insert) //, before insert, before update, before delete, after update, after delete, after undelete
{
    if(Trigger.isAfter && Trigger.isInsert)
    {
        AccountTriggerHandler.handleAfterInsert(Trigger.newMap);
    }
}