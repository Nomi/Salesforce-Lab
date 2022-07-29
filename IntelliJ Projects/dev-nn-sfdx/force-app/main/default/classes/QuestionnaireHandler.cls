/**
 * Created by nnoman on 12.07.2022.
 */

public with sharing class QuestionnaireHandler
{
//    public static void createRecord(Id relWebinarId, String strAge__c, String strAttendance__c,  String strFeedback_Comments__c, String strWhy__c, String strrecommend__c, String strScore__c)
//    {
//
//    }
    @AuraEnabled(Cacheable=true)
    public static List<Questionnaire__c> getRelatedQuestionnaires(String userId)
    {
        return
        [
                SELECT Id, Attendance__c,Age__c,Score__c,Feedback_Comments__c,Webinar__c
                FROM Questionnaire__c
                WHERE OwnerId = :userId
                ORDER BY CreatedDate DESC
        ];
    }
}