/**
 * Created by nnoman on 13.07.2022.
 */

import { LightningElement, api, wire } from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//
import createWebinar from '@salesforce/apex/WebinarCreator.createWebinar'

//
//import WEBINAR from '@salesforce/schema/Webinar__c'
import WEBINAR_NAME from '@salesforce/schema/Webinar__c.Name';
import WEBINAR_TYPE from '@salesforce/schema/Webinar__c.Type__c';
import WEBINAR_COST from '@salesforce/schema/Webinar__c.Cost__c';
import WEBINAR_PRICE from '@salesforce/schema/Webinar__c.Price_per_Currency__c';

const fields = [
    WEBINAR_NAME,
    WEBINAR_TYPE,
    WEBINAR_COST,
    WEBINAR_PRICE
];

export default class NewCloneWebinar extends NavigationMixin(LightningElement) {
    @api recordId;
    @api objectApiName;

    webinar;

    cloneWebId;

    nameVal='';
    typeVal='';
    costVal='';
    priceVal='';

//    @wire(getRecord,{recordId: '$recordId',fields: fields})
    error;
    @wire(getRecord, { recordId: '$recordId', fields: fields })
    wiredWebinar({ error, data })
     {
        if (data) {
                this.webinar = data.fields;
                this.error = undefined;
//                console.error(JSON.stringify(this.webinar.Name))
                this.nameVal=this.webinar.Name.value;
                this.typeVal=this.webinar.Type__c.value;
                this.costVal=this.webinar.Cost__c.value;
                this.priceVal=this.webinar.Price_per_Currency__c.value;
            } else if (error) {
                this.error = error;
                this.webinar = undefined;
        }
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    handleClone(event)
    {
//        //console.error(JSON.stringify(event.detail.fields));
//        let inputRecord =
//         {
//            apiName: `${questApiName}`,
//            fields: currFields
//        }
//        createWebinar(inputRecord);
        let input=
        {
            name: this.nameVal,
            type: this.typeVal,
            cost: this.costVal,
            price: this.priceVal
        }
//        console.error(JSON.stringify(input));
        createWebinar({
                          name: this.nameVal,
                          type: this.typeVal,
                          cost: this.costVal,
                          price: this.priceVal
                      }).then(data => {
              console.log('Success');
//              console.error(JSON.stringify(data));
              this.cloneWebId=data;
//              console.error(this.cloneWebId);
              this.error = null;
              this.handleLolSuccess();
            })
            .catch(error => {      this.error = error;
            });
        }


        handleLolSuccess()
        {
//                console.error('here')
             const evt = new ShowToastEvent({
                title: 'Success:',
                message: 'Cloned questionnaire (new id: '+this.cloneWebId+')',
                variant: 'success'
            });
            this.dispatchEvent(evt);

            console.error('here')
            this[NavigationMixin.Navigate]({
                type: 'standard__recordPage',
                attributes:{
                recordId: this.cloneWebId,
                actionName: 'view',
                },
            });
            console.error('here')
    }

    handleNameChange(event)
    {
        this.nameVal=event.target.value;
    }
    handleTypeChange(event)
    {
        this.typeVal=event.target.value;
    }
    handleCostChange(event)
    {
        this.costVal=event.target.value;
    }
    handlePriceChange(event)
    {
        this.priceVal=event.target.value;
    }
}