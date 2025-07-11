using cnma.questionnaire as questionnaire from './Questionares';

annotate questionnaire.Questionnaires with @assert.unique: {questionare: [
    questionnaireNo,
    version
]} {
    name   @mandatory;
    type   @assert.range;
    status @assert.range;
};

annotate questionnaire.Questions with {
    title           @mandatory;
    subtitle        @mandatory;
    comment         @mandatory;
    hint            @mandatory;
    type            @assert.range;
    restrictionType @assert.range;
    unitType        @assert.range;
};
