namespace cnma.questionnaire.views;

using {cnma.questionnaire as cnma} from './Questionares';

view Answers_View as
    select
        ID,
        score,
        sequence,
        text,
        comment,
        question
    from cnma.Answers;

view Questions_View as
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
        questionnaire,
        createdBy,
        createdAt,
        modifiedBy,
        modifiedAt,
        answers : redirected to Answers_View
    from cnma.Questions;

view LatestVersions as
    select
        questionnaireNo,
        max(version) as version
    from cnma.Questionnaires
    group by
        questionnaireNo;

view Questionnaires_View as
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
        QN.createdBy,
        QN.createdAt,
        QN.modifiedBy,
        QN.modifiedAt,
        QN.questions : redirected to Questions_View
    from cnma.Questionnaires as QN
    inner join LatestVersions as LV
        on  QN.questionnaireNo = LV.questionnaireNo
        and QN.version         = LV.version
