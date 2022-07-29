/**
 * Created by nnoman on 12.07.2022.
 */

import { LightningElement, api } from 'lwc';

export default class AccountNameEditor extends LightningElement {
    @api recordId;
    @api objectApiName;

    handleSubmit(event){
        console.log('submitted');
    }

    handleSuccess(event){
        console.log('success');
    }
}