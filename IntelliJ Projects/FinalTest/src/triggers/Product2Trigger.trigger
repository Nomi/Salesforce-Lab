/**
 * Created by nnoman on 22.07.2022.
 */

trigger Product2Trigger on Product2 (after update)
{
    if(Trigger.isAfter && Trigger.isUpdate)
    {
        ProductTriggerHandler.handleAfterUpdate(Trigger.oldMap);
    }
}