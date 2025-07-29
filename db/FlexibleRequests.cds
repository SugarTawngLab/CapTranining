using { cuid, managed } from '@sap/cds/common';

namespace cnma.flexiblerequest;

type RequestType : Integer enum {
  PurchaseOrder = 10;
  SaleOrder     = 20;
  Invoice       = 30;
} default 10;

entity FlexibleRequests : cuid, managed {
  number             : String(20);
  type               : RequestType;
  name               : String(100);
  status             : Integer enum {
    New = 10;
    InProgress = 20;
    InApproving = 30;
    Approved = 40;
    Rejected = 50;
    Deleted = 60;
  } default 10;
  priority           : Integer enum {
    Low = 10;
    Medium = 20;
    High = 30;
  } default 10;
  referenceRequest   : Association to one FlexibleRequests;
  dueDate            : Date;
  requestedDate      : Date;

  // Requestor Info
  requester          : Association to one Requester;

  department         : String(100);
  purchasingGroup    : String(50);
  supplier           : String(100);
  erpSystemId        : String(50);
  text               : String(255);
  currentSequence    : Integer;

  comments           : Composition of many RequestComments on comments.request = $self;

  approvers          : Association to many RequestApprovers on approvers.request = $self;

  approverTemplate   : Association to one ApproverTemplate;
}


entity RequestComments : cuid, managed {
  request        : Association to one FlexibleRequests;
  commenterEmail : String;
  commenterName  : String;
  comment        : String(1000);
}


entity RequestApprovers : cuid, managed {
  request: Association to one FlexibleRequests;
  approver: Association to one Approvers;
  comment        : String(1000);
  sequence : Integer;
  status   : Integer enum {
    NotOpen = 00;
    Open = 10;
    Approved = 20;
    Rejected = 30;
  } default 10;
}

entity Requester: cuid {
  name: String;
  email: String;
  requests: Association to many FlexibleRequests on requests.requester = $self;
}

entity Approvers: cuid {
  name: String;
  email: String;
  requests: Association to many RequestApprovers on requests.approver = $self;
  approverGroup: Association to one GroupApprovers;
}

entity GroupApprovers : cuid {
  template : Association to one ApproverTemplate;
  approver : Association to one Approvers;
  sequence : Integer;
}

entity ApproverTemplate : cuid, managed {
  requestType    : RequestType;
  groupApprovers : Association to many GroupApprovers on groupApprovers.template = $self;
  requests       : Association to many FlexibleRequests on requests.approverTemplate = $self;
}

view ApproverView as
  select 
     FR.ID,
    FR.number,
    FR.name,
    FR.status,
    FR.priority,
    FR.currentSequence,
    RA.approver.ID as approverID,
    RA.sequence,
    RA.status as approvalStatus
  from FlexibleRequests as FR
    join RequestApprovers as RA
    on FR.ID = RA.request.ID
  where
    RA.approver.ID = $user.id and
    RA.sequence = FR.currentSequence;

view RequestorView as
  select *
  from FlexibleRequests as FR
  where FR.requester.ID = $user.id;