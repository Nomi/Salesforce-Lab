/**
 * Created by nnoman on 21.07.2022.
 */

public with sharing class EmployeeTriggerHandler
{
    public static void handleAfterInsert(List<Employee__c> employees){
        calculateTeamTotalPoints(employees);
    }

    public static void handleAfterUpdate(List<Employee__c> employees){
        calculateTeamTotalPoints(employees);
    }

    // *** Logic ***
    private static void calculateTeamTotalPoints(List<Employee__c> employees){
        List<Id> teamIds = new List<Id>();
        for(Employee__c employee : employees){
            teamIds.add(employee.Related_Team__c);
        }

        List<Team__c> teams = [SELECT Id, Type__c, Total_Points__c FROM Team__c WHERE Id IN :teamIds];
        for(Team__c team : teams){
            team.Total_Points__c = 0;
            if (team.Type__c == 'Team'){
                calculateTotalPointsTypeTeam(team);
            }else if (team.Type__c == 'Office'){
                calculateTotalPointsTypeOffice(team);
            }else if (team.Type__c == 'Country'){
                calculateTotalPointsTypeCountry(team);
            }
        }
    }

    private static void calculateTotalPointsTypeTeam(Team__c team){
        List<Employee__c> teamEmployees = [SELECT Total_Points__c FROM
                Employee__c WHERE Related_Team__c = :team.Id];
        for(Employee__c employee : teamEmployees){
            team.Total_Points__c += employee.Total_Points__c;
        }

        update team;
    }

    private static void calculateTotalPointsTypeOffice(Team__c team){
        List<Team__c> teamRelatedTeams = [SELECT Total_Points__c FROM
                Team__c WHERE Parent_Team__c =: team.Id AND Type__c = 'Team'];
        for (Team__c teamRelatedTeam : teamRelatedTeams){
            team.Total_Points__c += teamRelatedTeam.Total_Points__c;
        }

        update team;
    }

    private static void calculateTotalPointsTypeCountry(Team__c team){
        List<Team__c> teamRelatedTeams = [SELECT Total_Points__c FROM
                Team__c WHERE Parent_Team__c =: team.Id AND Type__c = 'Office'];
        for (Team__c teamRelatedTeam : teamRelatedTeams){
            team.Total_Points__c += teamRelatedTeam.Total_Points__c;
        }

        update team;
    }
}