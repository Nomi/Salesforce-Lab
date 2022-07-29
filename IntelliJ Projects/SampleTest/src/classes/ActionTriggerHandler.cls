/**
 * Created by nnoman on 21.07.2022.
 */

public with sharing class ActionTriggerHandler
{
//    public static void handleAfterUpdate(Set<Id> idActionsNew,Map<Id,Action__c> oldActionsMap)
//    {
//        List<Action__c> actionsNew = [SELECT Id, (SELECT Id, HiddenCalculatedPoints__c FROM EmployeeActions__r) FROM Action__c WHERE Id IN : idActionsNew];
//        refreshEmployeeActionHiddenCalculatedPointsField(actionsNew);
//    }
//
//    private static void refreshEmployeeActionHiddenCalculatedPointsField(List<Action__c> actions)
//    {
//        List<EmployeeAction__c> empActs=new List<EmployeeAction__c>();//(actions.size());
//
//        for(Action__c act: actions)
//        {
//            empActs.addAll(act.EmployeeActions__r);
//        }
//
//        for(EmployeeAction__c ea: empActs)
//        {
//            ea.HiddenCalculatedPoints__c=null;
//        }
//
//        update empActs;
//
//        return;
//    }
}