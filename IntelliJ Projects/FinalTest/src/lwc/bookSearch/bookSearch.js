/**
 * Created by nnoman on 22.07.2022.
 */

//Config:
 const _columns = [
     {
         label: 'Name',
         fieldName: 'nameUrl',
         type: 'url',
         typeAttributes: {label: { fieldName: 'name' }, target: '_blank'},
         sortable: false
     },
     {
         label: 'Start Date',
         fieldName:'startDate',
         type: 'Text',
         sortable: true
     },
     {label: 'Status', fieldName: 'status', sortable: false},
     {label: 'Quantity', fieldName: 'quantity',sortable: false}
 ];
//startDate was type date earlier

//Imports
import { LightningElement, api, wire, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
//importing Apex:
import getFilteredRelatedOrders from '@salesforce/apex/BookSearchController.getFilteredRelatedOrders';



export default class BookSearch extends LightningElement {
    @api recordId;

    columns = _columns;

    orders=[];
    searchKeyword='';

    @track sortBy;
    @track sortDirection;

    error=undefined;
    @wire(getFilteredRelatedOrders,{searchStr: '', accountId: '$recordId'})
    teamSetter({ error, data })
    {
        if (data)
        {
            this.orders = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.orders = undefined;
        }
    };

    handleChangeSearchKeyword(e)
    {
          this.searchKeyword = e.target.value;
    }
    handleSearch(){
//        console.log('Search string was:');
//        console.log(this.searchKeyword);
        getFilteredRelatedOrders({
            searchStr: this.searchKeyword,
            accountId: this.recordId
            })
        .then(result =>{
            this.orders = result;
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

    handleSortOrderData(event) {
            this.sortBy = event.detail.fieldName;
            this.sortDirection = event.detail.sortDirection;
//            console.log('here')
            this.sortOrderData(event.detail.fieldName, event.detail.sortDirection);
        }


    sortOrderData(fieldname, direction) {
//        //should've had https://salesforce.stackexchange.com/questions/375126/how-to-sort-date-in-lwc-data-table-in-dd-mm-yyyy-format/375179#375179
//        //but turns out even that doesn't always work.

        let parseData = JSON.parse(JSON.stringify(this.orders));

        let keyValue = (a) => {
            return a[fieldname];
        };


       let isReverse = direction === 'asc' ? 1: -1;


           parseData.sort((x, y) => {
            x = keyValue(x) ? keyValue(x) : '';
            y = keyValue(y) ? keyValue(y) : '';

            return isReverse * ((x > y) - (y > x));
        });

        this.orders = parseData;

    }
}