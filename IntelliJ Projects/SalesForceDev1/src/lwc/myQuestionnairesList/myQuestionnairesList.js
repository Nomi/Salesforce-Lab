/**
 * Created by nnoman on 13.07.2022.
 */

import { LightningElement, api, wire } from 'lwc';
import getRelatedQuestionnaires from '@salesforce/apex/QuestionnaireHandler.getRelatedQuestionnaires';

const columns = [
    {label: 'Questionnaire Id', fieldName:'Id'},
    {label: 'Attendance', fieldName:'Attendance__c'},
    {label: 'Age', fieldName:'Age__c'},
    {label: 'Score', fieldName:'Score__c'},
    {label: 'Feedback', fieldName:'Feedback_Comments__c'},
    {label: 'Webinar', fieldName:'Webinar__c'},
];

export default class MyQuestionnairesList extends LightningElement {
    @api userId;
    columns = columns;

    @wire(getRelatedQuestionnaires, {userId: '$userId'})
    questionnaires;

    handleClose(event){
        const closeEvent = new CustomEvent("closebuttonclicked");
        this.dispatchEvent(closeEvent);
    }
}