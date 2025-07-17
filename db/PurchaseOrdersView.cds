namespace cnma.purchaseorder.views;

using {cnma.purchaseorder as cnma} from './PurchaseOrders';

// Requirement 4

view ContactPersonValueHelp as
    select distinct
        cp.ID as contactPersonId,
        cp.email,
        cp.name
    from cnma.PurchaseOrders as po
    inner join cnma.ContactPersons as cp
        on cp.ID = po.contactPerson.ID;

// Requirement 5

view LatestPurchaseOrderItems as
    select
        poi.ID                as purchaseOrderItemId,
        poi.purchaseOrder.ID  as purchaseOrderId,
        po.purchaseOrder      as purchaseOrderNumber,
        po.version            as purchaseOrderVersion,
        poi.purchaseOrderItem as purchaseOrderItemNumber,
        po.status             as purchaseOrderStatus,

        cast(
            poi.address.ID != poi.plantAddress.ID as Boolean
        )                     as differentAddressIndicator,

        cast(
            poi.nextDeliveryDate <= current_date as Boolean
        )                     as expiredIndicator

    from cnma.PurchaseOrderItems as poi
    inner join cnma.PurchaseOrders as po
        on po.ID = poi.purchaseOrder.ID
    where
        not exists(
            select from cnma.PurchaseOrders as po2
            where
                    po2.purchaseOrder = po.purchaseOrder
                and po2.version       > po.version
        )
    order by
        poi.nextDeliveryDate desc;