/**
 * Created by nnoman on 21.07.2022.
 */

public with sharing class TeamRankingController
{
    @AuraEnabled(Cacheable=true)
    public static List<RankingWrapper> getAllTeamsOfTypeTeam()
    {
        //return [SELECT Id, Name, Total_Points__c FROM Team__c WHERE Type__c = 'Team' ORDER BY Total_Points__c DESC];
        List<Team__c> unrankedTeamList=
        [SELECT Id, Name, Total_Points__c,
                (SELECT Id,Name, Total_Points__c FROM Employees__r)
        FROM Team__c WHERE Type__c = 'Team' ORDER BY Total_Points__c DESC NULLS LAST];

        List<RankingWrapper> rankedTeamList = new List<RankingWrapper>();

        Decimal previousPoints = null;
        Integer currRank = 1;
        Boolean notReachedNulls = true;
        for(Team__c team : unrankedTeamList)
        {
            if(previousPoints == null)
            {
                previousPoints = team.Total_Points__c;
            }
            else if(previousPoints!=team.Total_Points__c && notReachedNulls)
            {
                currRank++;
                notReachedNulls = !String.isBlank(String.valueOf(team.Total_Points__c));
            }

            RankingWrapper wrappedTeam = new RankingWrapper();
            wrappedTeam.Id = Team.Id;
            wrappedTeam.totalPoints = Team.Total_Points__c;
            wrappedTeam.name = Team.Name;
            wrappedTeam.empCount = Team.Employees__r.size();
            wrappedTeam.employees = Team.Employees__r;

            wrappedTeam.rank = currRank;

            rankedTeamList.add(wrappedTeam);
        }
        return rankedTeamList;
    }

    @AuraEnabled(Cacheable=true)
    public static List<RankingWrapper> getFilteredTeamsOfTypeTeam(String searchStr)
    {
        //return [SELECT Id, Name, Total_Points__c FROM Team__c WHERE Type__c = 'Team' ORDER BY Total_Points__c DESC];
        if(searchStr.length()==0)
        {
            searchStr='%';
        }
        else
        {
            searchStr='%'+searchStr+'%';
        }


        List<Team__c> unrankedTeamList=
        [SELECT Id, Name, Total_Points__c,
        (SELECT Id,Name, Total_Points__c FROM Employees__r)
        FROM Team__c WHERE Type__c = 'Team' AND Name LIKE :searchStr
        ORDER BY Total_Points__c DESC NULLS LAST];



        List<RankingWrapper> rankedTeamList = new List<RankingWrapper>();

        Decimal previousPoints = null;
        Integer currRank = 1;
        Boolean notReachedNulls = true;
        for(Team__c team : unrankedTeamList)
        {
            if(previousPoints == null)
            {
                previousPoints = team.Total_Points__c;
            }
            else if(previousPoints!=team.Total_Points__c && notReachedNulls)
            {
                currRank++;
                notReachedNulls = !String.isBlank(String.valueOf(team.Total_Points__c));
            }

            RankingWrapper wrappedTeam = new RankingWrapper();
            wrappedTeam.Id = Team.Id;
            wrappedTeam.totalPoints = Team.Total_Points__c;
            wrappedTeam.name = Team.Name;
            wrappedTeam.empCount = Team.Employees__r.size();
            wrappedTeam.employees = Team.Employees__r;

            wrappedTeam.rank = currRank;

            rankedTeamList.add(wrappedTeam);
        }
        return rankedTeamList;
    }


    public class RankingWrapper
    {
//        public String name;
//        public Decimal rank;
//        public Decimal totalPoints;
//        public Integer empCount;
//        public List<Employee__c> employees;
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