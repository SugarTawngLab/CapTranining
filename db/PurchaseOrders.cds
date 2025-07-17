namespace cnma.purchaseorder;

using {
    Currency,
    Language,
    managed,
    cuid
} from '@sap/cds/common';

annotate PurchaseOrders with @assert.unique: {purchaseOrder: [erpSystemId, purchaseOrder, version]} {
    purchaseOrder @mandatory;
    language @mandatory;
    receiptDate @cds.on.insert: $now;
};

annotate PurchaseOrderItems with @assert.unique: {purchaseOrderItem: [purchaseOrderItem]}{
    purchaseOrderItem @mandatory;
};

/** Reusable indicator types */
type OrderIndicator : {
    attachment               : Boolean;
    priority                : Boolean;
    favourite               : Boolean;
    draft                   : Boolean;
    allowConfirmation       : Boolean;
    goodsReceipt            : Boolean;
    acknowledgeRequired     : Boolean;
    hasShipment             : Boolean;
    totalAmountChanged      : Boolean;
    orderDateChanged        : Boolean;
    deliveryDateChanged     : Boolean;
    acknowledgeChanged      : Boolean;
    incotermLocationChanged : Boolean;
    addressChanged          : Boolean;
    startPeriodChanged      : Boolean;
    endPeriodChanged        : Boolean;
}

type ItemIndicator : {
    confirmation             : Boolean;
    goodsReceipt             : Boolean;
    acknowledgeRequired      : Boolean;
    completelyDelivered      : Boolean;
    completelyInvoiced       : Boolean;
    sentConfirm              : Boolean default false;
    allowConfirmation        : Boolean;
    allowDelivery            : Boolean;
    quantityChanged          : Boolean;
    unitChanged              : Boolean;
    netPriceChanged          : Boolean;
    currencyChanged          : Boolean;
    deliveryDateChanged      : Boolean;
    itemAdded                : Boolean;
    itemDeleted              : Boolean;
    materialChanged          : Boolean;
    confirmationChanged      : Boolean;
    packingInstruction       : Boolean default false;
    packingMaterialType      : String(4);
    packingMaterialDesc      : String(20);
}

/** If reused across multiple purchase orders, model as entity */
type PaymentTerm : {
    code             : String(10);
    description      : String(100);
    @assert.range: [0, 999] netDays          : Integer;
    @assert.range: [0, 999] discount1Days    : Integer;
    @assert.range: [0, 100] discount1Percent : Decimal(5, 0);
    @assert.range: [0, 999] discount2Days    : Integer;
    @assert.range: [0, 100] discount2Percent : Decimal(5, 0);
}

entity ContactPersons : cuid, managed {
    name            : String(50);
    phone           : String(20);
    phoneExtension  : String(10);
    fax             : String(20);
    email           : String(100);
}

entity Addresses : cuid, managed {
    name            : String(100);
    name2           : String(100);
    fullName        : String(200);

    street1         : String(100);
    street2         : String(100);
    street3         : String(100);
    street4         : String(100);
    street5         : String(100);

    houseNumber     : String(20);
    postalCode      : String(20);
    city            : String(100);
    region          : String(10);
    country         : String(3);

    phoneNumber     : String(30);
    faxNumber       : String(30);
    timeZone        : String(10);
}

@assert.unique: {purchaseOrder: [erpSystemId, purchaseOrder, version]}
entity PurchaseOrders : cuid, managed {
    purchaseOrder           : String(10);
    version                 : Integer       default 1;
    erpSystemId             : String;
    description             : String;
    status                  : String        default '10';
    previousStatus          : String;
    statusDescription       : String;
    orderDate               : Date;
    orderType               : String;
    orderTypeDescription    : String;
    language                : Language;
    supplier                : String(10);
    supplierName            : String(35);
    totalAmount             : Decimal(16, 2) default 0;
    currency                : Currency;
    exchangeRate            : Decimal(9, 5)  default 1;
    purchasingOrg           : String;
    purchasingOrgDesc       : String;
    purchasingGroup         : String;
    purchasingGroupDesc     : String;
    receiptDate             : Timestamp;

    @Common.ValueList: {
        Label: 'Contact Person',
        CollectionPath: 'ContactPersonValueHelp',
        Parameters: [{
            $Type: 'Common.ValueListParameterOut',
            LocalDataProperty: 'contactPerson_ID',
            ValueListProperty: 'contactPersonId'
        }]
    }
    contactPerson           : Association to ContactPersons;

    companyCode             : String;
    companyCodeDesc         : String;
    confirmationNumber      : String;
    incoTermLocation1       : String(70);
    incoTermLocation2       : String(70);

    paymentTerm             : PaymentTerm;
    deliveryDate            : Date;
    startPeriod             : Date;
    endPeriod               : Date;
    addressText             : String;
    printFormId             : String;
    printFormDocId          : String;
    printFormObject         : String;
    note                    : String;
    plant                   : String;

    address                 : Association to Addresses;
    indicator               : OrderIndicator;
    items                   : Composition of many PurchaseOrderItems on items.purchaseOrder = $self;
}

@assert.unique: {purchaseOrderItem: [purchaseOrderItem]}
entity PurchaseOrderItems : cuid, managed {
    purchaseOrderItem       : Integer;
    itemText                : String;
    material                : String;
    materialDescription     : String;
    supplierMaterial        : String;
    manufacturerMaterial    : String;
    materialGroup           : String;
    materialGroupDesc       : String;
    sapMaterial             : String;
    orderQty                : Decimal(13, 3) default 0;
    unit                    : String(3);
    unitLocale              : String;
    priceUnit               : String;
    priceUnitLocale         : String;
    currency                : Currency;
    netPrice                : Decimal(16, 2) default 0;
    priceQty                : Decimal(13, 3) default 1;
    deliveryDate            : Date;
    netValue                : Decimal(16, 2) default 0;
    grossValue              : Decimal(16, 2) default 0;

    scheduleLineIndicator   : Boolean        default false;
    confirmationNumber      : String;
    confirmedQty            : Decimal(13, 3);
    confirmedPrice          : Decimal(11, 2);
    confirmedDeliveryDate   : Date;
    goodsReceiptRef         : String(25);
    unloadingPoint          : String(12);
    incoTermLocation1       : String(70);
    incoTermLocation2       : String(70);
    note                    : String;
    confirmationControlKey  : String;

    indicator               : ItemIndicator;
    previousStatus          : String;
    status                  : String         default '10';
    contract                : String;
    contractItem            : String;

    address                 : Association to Addresses;

    overConfirmedQty        : Decimal(13, 3) default 0;
    overDeliveryLimitPct    : Decimal(5, 2)  default 0;
    underDeliveryLimitPct   : Decimal(5, 2)  default 0;
    unlimitedOverdelivery   : Boolean        default false;
    batchIndicator          : Boolean        default false;
    batchNumber             : String;

    plant                   : String;
    plantDesc               : String;
    storageLocation         : String;
    openQty                 : Decimal(11, 2) default 0;
    supplier                : String(10);
    supplierName            : String(35);
    companyCode             : String;
    companyCodeDesc         : String;
    grossWeight             : Decimal(13, 3) default 0;
    netWeight               : Decimal(13, 3) default 0;
    weightUnit              : String(3);
    weightUnitLocale        : String;

    plantAddress            : Association to Addresses;
    nextDeliveryDate        : Date;
    orderedAmount           : Decimal(13, 3) default 0;
    deliveredAmount         : Decimal(13, 3) default 0;

    purchaseOrder           : Association to PurchaseOrders;
}