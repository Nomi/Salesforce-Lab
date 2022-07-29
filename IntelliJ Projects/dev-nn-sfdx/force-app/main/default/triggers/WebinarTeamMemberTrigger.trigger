/**
 * Created by nnoman on 06.07.2022.
 */

trigger WebinarTeamMemberTrigger on Webinar_Team_Member__c (before insert, before update, before delete, after insert, after update, after delete, after undelete)
{
    if (Trigger.isBefore && (Trigger.isUpdate || Trigger.isInsert))
    {
        WebinarTeamMemberTriggerHandler.handleBeforeUpdateOrInsert(Trigger.new);
        if (Trigger.isInsert)
        {
            WebinarTeamMemberTriggerHandler.handleBeforeInsert(Trigger.new);
        }
    }
}