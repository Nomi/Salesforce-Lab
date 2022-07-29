/**
 * Created by nnoman on 22.07.2022.
 */

public with sharing class BookSearchController
{
    /**
     * Wrapper class for the Order so that it can't be sent
     */
    public class OrderWrapper
    {
        @AuraEnabled
        public String id {get; set;}
        @AuraEnabled
        public String name {get; set;}
        @AuraEnabled
        public String status {get; set;}
        @AuraEnabled
        public String startDate {get; set;}
//        public Date startDate {get; set;} //maybe I could change format here in the get so lwc gets correct format and store it as a string and then compare?
        @AuraEnabled
        public Decimal quantity {get; set;}
        @AuraEnabled
        public String nameUrl {get;set;}
    }
    ///Public Methods:
    /**
     * @description
     * Get a filtered list of orders related to an account.
     * Sidenote: the apiname of Book is Product2
     *
     * @param searchStr the string a book name is supposed to contain.
     * @param accountId ID of the account whose related orders we want.
     *
     * @return list of related accounts whose related books have something that contains the search string.
     */
    @AuraEnabled(Cacheable=true)
    public static List<OrderWrapper> getFilteredRelatedOrders(String searchStr, Id accountId)
    {

        if(searchStr.length()==0)
        {
            searchStr='%';
        }
        else
        {
            searchStr='%'+String.escapeSingleQuotes(searchStr)+'%';
        }

        List<Order> relatedOrders = [
                SELECT
                        Id,
                        Name,
                        EffectiveDate,
                        Status,
                        (
                            SELECT
                                    OrderId,
                                    Quantity,
                                    PricebookEntry.Product2Id,
                                    PricebookEntry.Product2.Name

                            FROM
                                    OrderItems
                        )
                FROM
                    Order
                WHERE
                    AccountId=:accountId
                AND
                    Id IN
                    (SELECT OrderId FROM OrderItem WHERE PricebookEntry.Product2.Name LIKE :searchStr)
        ];


        List<OrderWrapper> wrappedOrders = new List<OrderWrapper>();
        for(Order order: relatedOrders)
        {
            OrderWrapper ow = new OrderWrapper();
            ow.id=order.Id;
            ow.name=order.Name;
            //ow.startDate=order.EffectiveDate;
            ow.startDate=order.EffectiveDate.year()+'-'+order.EffectiveDate.month()+'-'+order.EffectiveDate.day();
            ow.status=order.Status;
            ow.quantity = calculateOrderQuantity(order);    //makes the time complexity to something like O(n^2) (but not exactly),
                                                            //however, it shouldn't be that big of an issue as long as a significant
                                                            //portion of customers each have large numbers of orders.
            ow.nameUrl='/'+ow.Id;
            wrappedOrders.add(ow);
        }
        System.debug(wrappedOrders);
        return wrappedOrders;
    }

    ///Private Methods:
    /**
     * @description
     * Get total quantity for an order (sum of quantities of individual products).
     *
     * @param order the order whose total quantity you want to calculate
     *
     * @return sum of quantities of individual products of the order.
     */
    private static Integer calculateOrderQuantity(Order order)
    {
        Integer quantity = 0;
        for (OrderItem oi : order.OrderItems)
        {
            quantity += oi.Quantity.intValue();
        }
        return quantity;
    }
}