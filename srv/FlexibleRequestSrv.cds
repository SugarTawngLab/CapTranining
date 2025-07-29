using { cnma.flexiblerequest as FL } from '../db/FlexibleRequests';

@path: 'cnma/FLEXIBLEREQUEST_SRV'
service FlexibleRequestsService {
  entity FlexibleRequests     as projection on FL.FlexibleRequests;
  entity RequestComments      as projection on FL.RequestComments;
  entity RequestApprovers     as projection on FL.RequestApprovers;
  entity Requester            as projection on FL.Requester;
  entity Approvers            as projection on FL.Approvers;
  entity ApproverTemplate     as projection on FL.ApproverTemplate;
  entity GroupApprovers       as projection on FL.GroupApprovers;

  action cloneFlexibleRequest(FR_ID: String) returns FlexibleRequests;
  action approveFlexibleRequest(FR_ID: String) returns FlexibleRequests;
  action rejectFlexibleRequest(FR_ID: String) returns FlexibleRequests;
}
