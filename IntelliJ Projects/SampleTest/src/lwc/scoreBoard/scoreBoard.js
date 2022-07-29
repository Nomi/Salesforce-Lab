/**
 * Created by nnoman on 21.07.2022.
 */
 const columns = [
     {label: 'Name', fieldName:'name'},
     {label: 'Rank', fieldName:'rank'},
     {label: 'Total Points', fieldName:'totalPoints'},
     {label: 'Employee Count', fieldName:'empCount'},
     {type: 'button', typeAttributes: {
             label: 'View',
             name: 'View',
             title: 'View',
             disabled: false,
             value: 'View'
         }}
 ];

import { LightningElement, api, wire } from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//importing apex:
import getAllTeamsOfTypeTeam from '@salesforce/apex/TeamRankingController.getAllTeamsOfTypeTeam';
import getFilteredTeamsOfTypeTeam from '@salesforce/apex/TeamRankingController.getFilteredTeamsOfTypeTeam';


export default class ScoreBoard extends LightningElement {
    columns = columns;
    teams;
    teamsWithRanking=[];

    teamId = null;
//    @track teamsWithRanking;
    showDetails = false;
    sizes;
    searchValue = '';

    @wire(getAllTeamsOfTypeTeam)
    teamSetter({ error, data })
    {
        if (data)
        {
//            console.error('1');
//            var wte = Object.assign({ranking: 0},data);
//            for(let i =0; i< data.length; i++)
//            {
//                wte[i].ranking=i+1;
//            }
            this.teams = data;
            this.error = undefined;
//            for(let i = 0; i<this.teams.length; i++)
//            {
//                this.teamsWithRanking.add(Object.assign({Ranking: undefined}, this.teams[i]));
//            }
////            console.error(this.teams);
        } else if (error) {
            this.error = error;
            this.teams = undefined;
        }
    }


    callRowAction(event)
    {
        this.teamId = event.detail.row.Id;
//        console.error(JSON.stringify(event.detail));
        const actionName = event.detail.action.name;
//        console.log(JSON.stringify(event))
//        console.log(this.teamId)
//        console.log(this.teams)
        if (actionName == 'View')
        {
            this.showDetails = true;
        }
    }

    searchKeyword(event) {
            this.searchValue = event.target.value;
    }
    handleSearchKeyword(){
        getFilteredTeamsOfTypeTeam({searchStr: this.searchValue})
        .then(result =>{
            console.log(result);
            this.teams = result;
        }).catch(error=>{
            const toastEvent = new ShowToastEvent({
                title: 'Error',
                variant: 'error',
                message: error.body.message,
            });
            this.dispatchEvent(event);
            this.teams = null;
        });
    }
}