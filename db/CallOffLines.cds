using {cuid} from '@sap/cds/common';

namespace cnma.callofflines;

@assert.unique: {purchaseOrder: [
    agreement,
    agreementItem,
    callOffId,
    callOffLine
]}

entity CallOffLines : cuid {
    agreement     : String;
    agreementItem : Integer;
    callOffId     : Integer;
    callOffLine   : Integer;
    callOffDate   : Date default $now;
    callOffAmount : Decimal(13, 3) default 0;
}
