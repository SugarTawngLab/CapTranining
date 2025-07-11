using {cuid, managed} from '@sap/cds/common';
namespace cnma.questionnaire;

entity Questionnaires : cuid, managed {
  questionnaireNo : String(20);
  version         : Integer default 1;
  name            : localized String(255);
  description     : localized String(1000) default '';
  introduction    : localized String(1000) default '';
  internalComment : localized String(1000) default '';
  type            : Integer enum {
    Normal = 10;
    Template = 20;
  } default 10;
  status          : Integer enum {
    InWork = 10;
    InApproval = 20;
    Active = 30;
    Inactive = 40;
    Obsolete = 50;
  } default 10;

  templateRef     : Association to Questionnaires;

  questions       : Composition of many Questions on questions.questionnaire = $self;
}

entity Questions : cuid, managed {
  title            : localized String(255);
  subtitle         : localized String(255);
  comment          : localized String(1000);
  hint             : localized String(500);
  type             : Integer enum {
    SingleChoice   = 10;
    MultipleChoice = 20;
    Dropdown       = 30;
    FreeText       = 40;
    Number         = 50;
    Email          = 60;
  } default 10;
  isMandatory      : Boolean default true;
  allowUpload      : Boolean default false;
  restrictionType  : Integer enum {
    Equal        = 10;
    Between      = 20;
    GreaterThan  = 30;
    LessThan     = 40;
  } default 10;
  restrictionLow   : Decimal(10, 2) default 0.00;
  restrictionHigh  : Decimal(10, 2) default 100.00;
  decimalPrecision : Integer default 0;
  unitType         : Integer enum {
    Currency       = 10;
    UnitOfMeasure  = 20;
  } default 10;
  unitValue        : String(20) default 'VND';

  answers          : Composition of many Answers on answers.question = $self;
  questionnaire    : Association to one Questionnaires;
}

entity Answers : cuid {
  score       : Integer default 0;
  sequence    : Integer default 1;

  text        : localized String(500) default '';
  comment     : localized String(500) default '';

  question    : Association to one Questions;
}
