/**
 * Created by nnoman on 21.07.2022.
 */

trigger EmployeeTrigger on Employee__c (after insert, after update)
{
    if (Trigger.isAfter && Trigger.isInsert){
        EmployeeTriggerHandler.handleAfterInsert(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate){
        EmployeeTriggerHandler.handleAfterUpdate(Trigger.new);
    }
}