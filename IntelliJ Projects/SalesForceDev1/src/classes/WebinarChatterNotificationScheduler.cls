/**
 * Created by nnoman on 14.07.2022.
 */

public with sharing class WebinarChatterNotificationScheduler implements System.Schedulable
{
    private static final String BATCH_CLASS_NAME = 'BatchWebinarChatterNotifier';
    public void execute(SchedulableContext sc)
    {
        Object batchObject = Type.forName(BATCH_CLASS_NAME).newInstance();
        if (batchObject instanceof Database.Batchable<SObject>) {
            Database.Batchable<SObject> batchClass = (Database.Batchable<SObject>) batchObject;
            Database.executeBatch(batchClass);
        }
    }
}