/**
 * Created by nnoman on 12.07.2022.
 */

///Config:
const questApiName = 'Questionnaire__c';
const formInitialTitle = 'Fill out survey:'
const recommendFieldName = 'recommend__c'
const recommendFalseOptionName = 'No';
const completedStatusOptionValue = 'Completed';
const noRecommendOptionString = 'No';

///Imports
import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue, createRecord } from 'lightning/uiRecordApi';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';


///Field Imports:
import USER_ID from '@salesforce/user/Id';
import USER_NAME from '@salesforce/schema/User.Name';
import WEBINAR_STATUS from '@salesforce/schema/Webinar__c.Status__c';
import QUESTIONNAIRE from '@salesforce/schema/Questionnaire__c';

///Class
export default class WebinarQuestionnaire extends NavigationMixin(LightningElement) {
        @api recordId;//webinar Id
        @api objectApiName;//Webinar api name
        @api userId = USER_ID;

        @api successMessage;

        title = formInitialTitle;

        questionnaireId;
        questionnaire = {};
        wouldRecommendNo=false;
        error;
        isLoading = false;
        showUserQuestionnaires=false;

        @wire(getRecord, { recordId: '$recordId', fields: [WEBINAR_STATUS] })
        webinar;

        get isCompleted(){
//                return this.webinar.data.fields.recommend__c.value;
                return getFieldValue(this.webinar.data, WEBINAR_STATUS) === completedStatusOptionValue;
            }

        @wire(getRecord, {recordId : USER_ID, fields : [USER_NAME]})
            userData({error, data}) {
                if (error){
                    this.error = error;
                } else if (data) {
//                    this.title = 'Hi ' + data.fields.Name.value + '! Share your feedback with us!';
                      this.title = 'Hi ' + getFieldValue(data, USER_NAME) + '! Share your feedback with us!';
                }
            }

//        ageF='';
//        attF='';
//        fbF='';
//        rsnF='';
//        rcF='';
//        scrF='';

        questionnaireApiName=questApiName;
        isStatusCompleted=true;


    handleFieldChanges(event)
    {
        this.questionnaire[event.currentTarget.fieldName] = event.target.value;
    }

    handleRecommendFieldChange(event){
            this.wouldRecommendNo = (event.detail.value === noRecommendOptionString);
            this.questionnaire[event.currentTarget.fieldName] = event.target.value;
        }

    handleQuestionnaireSubmission(event)
    {
        //event.preventDefault(); //prevent default blackmagic-ish auto submit.
        this.isLoading = true;
        this.createQuestionnaire();
        return false;
    }

    handleSuccess(event)
    {
//        this.isLoading=false;
            console.error('here')
//        this.questionnaireId = event.detail.id;

         const evt = new ShowToastEvent({
            title: 'Thank you!',
            message: this.successMessage+' '+'(Created questionnaire with id: '+this.questionnaireId+')',
            variant: 'success'
        });
        this.dispatchEvent(evt);
        this.isLoading = false;
        //this.resetAll();


        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes:{
            recordId: this.questionnaireId,
            actionName: 'view',
            },
        });
    }

    createQuestionnaire()
    {
            this.questionnaire['Webinar__c'] = this.recordId;
            let questionnaireFields = this.questionnaire;
            var objRecordInput = {apiName : questApiName, fields : questionnaireFields};
//            console.error(JSON.stringify(this.questionnaire))
//            console.error(JSON.stringify(questApiName))
            let wasSuccess=false;
            createRecord(objRecordInput).then(response => {
                this.questionnaireId = response.id;
                this.handleLolSuccess();
//                const customSuccessEvent = new CustomEvent("customsuccess");
//                this.dispatchEvent(customSuccessEvent);
            }).catch(error => {
                alert('Error: ' +JSON.stringify(error));
            })
        }

    handleLolSuccess()
    {
         const evt = new ShowToastEvent({
            title: 'Thank you!',
            message: this.successMessage+' '+'(Created questionnaire with id: '+this.questionnaireId+')',
            variant: 'success'
        });
        this.dispatchEvent(evt);
        this.isLoading = false;
    //            this.resetAll();


        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes:{
            recordId: this.questionnaireId,
            actionName: 'view',
            },
        });
    }

    handleError(event)
    {
        this.isLoading=false;
    }

    handleClose(event){
        this.showUserQuestionnaires = false;
    }

    handleShowClick(event)
    {
        this.showUserQuestionnaires=true;
    }

    handleAllFormFieldChanges(e)
    {
//        console.error(JSON.stringify(e.currentTarget));
////        this.questionnaire[e.currentTarget.fieldName] = e.target.value;
////        if(e.currentTarget.fieldName == recommendFieldName)
////        {
////            if (e.detail.value == recommendFalseOptionName)
////            {
////                this.wouldRecommendNo = true;
////            }else {
////                this.wouldRecommendNo = false;
////            }
////        }
////
////        console.log(JSON.stringify(this.questionnaire));
    }

    resetAll()
    {
        this.template.querySelectorAll('lightning-input-field').forEach(element=>{
            if (element.type === 'checkbox'){
                element.checked = false;
            } else{
                element.value = null;
            }
        })
    }


}