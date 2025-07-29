using cnma.flexiblerequest as flexiblerequest from './FlexibleRequests';

annotate flexiblerequest.FlexibleRequests with @assert.unique: {flexibleRequest: [
    number
]}{
    name @mandatory;
    type @assert.range;
    status @assert.range;
    priority @assert.range;
}

annotate flexiblerequest.RequestApprovers with {
    status @assert.range;
};