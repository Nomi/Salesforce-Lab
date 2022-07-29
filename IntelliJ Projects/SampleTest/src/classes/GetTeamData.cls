/**
 * Created by nnoman on 21.07.2022.
 */

public with sharing class GetTeamData
{
    @AuraEnabled (Cacheable = true)
    public static List<Object> getTeams(String nameVal){
////        return [SELECT Name, Total_Points__c, COUNT(Employees__r) FROM
////                Team__c ORDER BY Total_Points__c DESC];
//
//        return [SELECT Related_Team__c, Count(Id) NumberOfEmployees, Related_Team__r.Name, MAX(Related_Team__r.Total_Points__c)
//                TotalPoints FROM Employee__c WHERE Related_Team__r.Type__c = 'Team' GROUP BY Related_Team__c, Related_Team__r.Name];
        if (nameVal == null || nameVal == '') {
            return [SELECT Related_Team__c, Count(Id) NumberOfEmployees, Related_Team__r.Name, MAX(Related_Team__r.Total_Points__c)
                    TotalPoints
                    FROM Employee__c WHERE Related_Team__r.Type__c = 'Team'
                    GROUP BY Related_Team__c, Related_Team__r.Name];
            }else{
            String nameValString = '%' + nameVal + '%';
            return [SELECT Related_Team__c, Count(Id) NumberOfEmployees, Related_Team__r.Name, MAX(Related_Team__r.Total_Points__c)
                    TotalPoints
                    FROM Employee__c
                    WHERE Related_Team__r.Type__c = 'Team' AND Related_Team__r.Name LIKE :nameValString
                    GROUP BY Related_Team__c, Related_Team__r.Name
            ];
        }
    }
    @AuraEnabled (Cacheable = true)
    public static List<Employee__c> getTeamById(Id id){
        return [SELECT First_Name__c, Last_Name__c, Total_Points__c FROM Employee__c WHERE Related_Team__c = :id];
    }

    public class RankingWrapper
    {
        @AuraEnabled
        public String Id {get; set;}
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public Decimal rank{get; set;}
        @AuraEnabled
        public Decimal totalPoints{get; set;}
        @AuraEnabled
        public Integer empCount{get; set;}
        @AuraEnabled
        public List<Employee__c> employees{get; set;}
    }
}