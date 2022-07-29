/**
 * Created by nnoman on 21.07.2022.
 */

trigger EmpActTrigger on EmployeeAction__c (before insert)
{
    if (Trigger.isBefore && Trigger.isInsert){
        EmpActTriggerHandler.handleBeforeInsert(Trigger.new);
    }
}