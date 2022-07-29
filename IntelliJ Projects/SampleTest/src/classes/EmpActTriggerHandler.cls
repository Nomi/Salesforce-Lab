/**
 * Created by nnoman on 21.07.2022.
 */

public with sharing class EmpActTriggerHandler
{
    public static void handleBeforeInsert(List<EmployeeAction__c> newEmployeeActions){
        restrictOpenAction(newEmployeeActions);
    }
    private static void restrictOpenAction(List<EmployeeAction__c> newEmployeeActions){
        List<Id> actionIds = new List<Id>();
        for(EmployeeAction__c empAct : newEmployeeActions){
            actionIds.add(empAct.Action__c);
        }
        Map<Id, Action__c> mapIdToAction = new Map<Id, Action__c>([SELECT Id, Status__c FROM
                Action__c WHERE Id IN :actionIds]);
        for (EmployeeAction__c empAct : newEmployeeActions){
            if (mapIdToAction.get(empAct.Action__c).Status__c != 'Open Registration'){
                empAct.addError('Cannot create Employee Action for Action without Status "Open Registration"');
            }
        }
    }
}