namespace cnma.questionnaire.views;

using {cnma.questionnaire as cnma} from './Questionares';

view AvailableAnswers as
    select
        ID,
        score,
        sequence,
        text,
        comment,
        question.ID as questionId
    from cnma.Answers;

view AvailableQuestions as
    select
        ID,
        title,
        subtitle,
        comment,
        hint,
        type,
        isMandatory,
        allowUpload,
        restrictionType,
        restrictionLow,
        restrictionHigh,
        decimalPrecision,
        unitType,
        unitValue,
        answers.ID as answerId,
        answers.score,
        answers.sequence,
        answers.text,
        answers.comment as answerComment
    from cnma.Questions;

view LatestVersions as
    select
        questionnaireNo,
        max(version) as version
    from cnma.Questionnaires
    group by
        questionnaireNo;

view AvailableQuestionnaires as
    select
        QN.ID,
        QN.questionnaireNo,
        QN.version,
        QN.name,
        QN.description,
        QN.introduction,
        QN.internalComment,
        QN.type,
        QN.status,
        QN.templateRef.ID as templateRefId,
        QN.questions.ID as questionId,
        QN.questions.title as questionTitle,
        QN.questions.subtitle as questionSubtitle,
        QN.questions.comment as questionComment,
        QN.questions.hint as questionHint,
        QN.questions.type as questionType,
        QN.questions.isMandatory as questionIsMandatory,
        QN.questions.allowUpload as questionAllowUpload,
        QN.questions.restrictionType as questionRestrictionType,
        QN.questions.restrictionLow as questionRestrictionLow,
        QN.questions.restrictionHigh as questionRestrictionHigh,
        QN.questions.decimalPrecision as questionDecimalPrecision,
        QN.questions.unitType as questionUnitType,
        QN.questions.unitValue as questionUnitValue
    from cnma.Questionnaires as QN
        inner join LatestVersions as LV
            on  QN.questionnaireNo = LV.questionnaireNo
            and QN.version         = LV.version
