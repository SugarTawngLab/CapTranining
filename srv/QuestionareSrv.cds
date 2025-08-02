// srv/questionnaire-service.cds
using { cnma.questionnaire as QN } from '../db/Questionares';

@path: 'cnma/QUESTIONARE_SRV'
service QuestionnaireService {
  entity Questionnaires as projection on QN.Questionnaires;
  entity Questions       as projection on QN.Questions;
  entity Answers         as projection on QN.Answers;

  action createFromTemplate(TempID: String) returns Questionnaires;
  action copyQuestion(QuestionId: String) returns Questionnaires;
  action submitQuestionnaire(QuestionId: String) returns Questionnaires;
  action setQuestionnaireStatus(QuestionId: String, Status: Integer) returns Questionnaires;
  function getCurrentUserInfo() returns {
    firstName: String;
    lastName: String;
    email: String;
    roles: many String;
  };
}
