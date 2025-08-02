package customer.captraining.handlers;

import com.sap.cds.services.handler.EventHandler;
import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;
import com.sap.cds.services.request.UserInfo;

import cds.gen.flexiblerequestsservice.FlexibleRequests;
import cds.gen.questionnaireservice.CopyQuestionContext;
import cds.gen.questionnaireservice.CreateFromTemplateContext;
import cds.gen.questionnaireservice.QuestionnaireService_;
import cds.gen.questionnaireservice.Questionnaires;
import cds.gen.questionnaireservice.Questionnaires_;
import cds.gen.questionnaireservice.SetQuestionnaireStatusContext;
import cds.gen.questionnaireservice.SubmitQuestionnaireContext;
import lombok.extern.slf4j.Slf4j;

import com.sap.cds.Result;
import com.sap.cds.Row;
import com.sap.cds.ql.CQL;
import com.sap.cds.ql.Insert;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.Update;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.ErrorStatuses;
import com.sap.cds.services.ServiceException;
import com.sap.cds.services.cds.CdsReadEventContext;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.sound.midi.MidiDevice.Info;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import static com.sap.cds.ResultBuilder.selectedRows;


@Slf4j
@Component
@ServiceName(QuestionnaireService_.CDS_NAME)
public class QuestionnaireServiceHandler implements EventHandler {
    
    @Autowired
    private PersistenceService db;

    public QuestionnaireServiceHandler(PersistenceService db) {
        this.db = db;
    }

    @On(event = CreateFromTemplateContext.CDS_NAME)
    public void createFromTemplate(CreateFromTemplateContext context){

        String TempID = context.getTempID();
        String newNo = "CTEMP-" + System.currentTimeMillis();

        Questionnaires referQuestionnaire = db.run(Select
        .from(Questionnaires_.class)
        .where(qn -> qn.ID().eq(TempID)
        )).first(Questionnaires.class).orElse(null);

        if(referQuestionnaire != null){
            referQuestionnaire.setId(UUID.randomUUID().toString());
            referQuestionnaire.setTemplateRefId(TempID);
            referQuestionnaire.setQuestionnaireNo(newNo);
            referQuestionnaire.setStatus(10);
            referQuestionnaire.setType(10);
            referQuestionnaire.setVersion(1);

            Result result = db.run(
                Insert.into(Questionnaires_.CDS_NAME)
                .entry(referQuestionnaire)
            );
            log.info("My User Info Object | Object={}", referQuestionnaire);

            if(result != null){
                context.setResult(result.first(Questionnaires.class).get()); 
            }
        }
        context.setCompleted();
    }

    @On(event = CopyQuestionContext.CDS_NAME)
    public void copyQuestion(CopyQuestionContext context){
        String referQuestionId = context.getQuestionId();
        log.info("Question Id | Object={}", referQuestionId);

        String newNo = "COPY-" + System.currentTimeMillis();

        Questionnaires referQuestionnaire = db.run(Select
        .from(Questionnaires_.class)
        .where(qn -> qn.ID().eq(referQuestionId)
        )).first(Questionnaires.class).orElse(null);

        if(referQuestionnaire != null){
            referQuestionnaire.setId(UUID.randomUUID().toString());
            referQuestionnaire.setQuestionnaireNo(newNo);
            referQuestionnaire.setStatus(10);
            referQuestionnaire.setType(10);
            referQuestionnaire.setVersion(1);
            Result result = db.run(
                Insert.into(Questionnaires_.CDS_NAME)
                .entry(referQuestionnaire)
            );
            log.info("My User Info Object | Object={}", referQuestionnaire);

            if(result != null){
                context.setResult(result.first(Questionnaires.class).get()); 
            }
        }

        context.setCompleted();
    }

    @On(event = SubmitQuestionnaireContext.CDS_NAME)
    public void submitQuestionnaire(SubmitQuestionnaireContext context){
        String referQuestionId = context.getQuestionId();
        log.info("Question Id | Object={}", referQuestionId);

        Map<String, Object> data = new HashMap<>();
        data.put("status", 20);

        Questionnaires referQuestionnaire = db.run(Select
        .from(Questionnaires_.class)
        .where(qn -> qn.ID().eq(referQuestionId)
        )).first(Questionnaires.class).orElse(null);

        if(referQuestionnaire != null){
            db.run(
                Update.entity(Questionnaires_.class)
                .where(q -> q.ID().eq(referQuestionId))
                .data(data)
            );

            Questionnaires result = db.run(Select
            .from(Questionnaires_.class)
            .where(qn -> qn.ID().eq(referQuestionId)
            )).first(Questionnaires.class).orElse(null);

            context.setResult(result);

        } else {
            throw new ServiceException(ErrorStatuses.NOT_FOUND, "Questionnaire not found with ID: " + referQuestionId);
        }
    }

    @On(event = SetQuestionnaireStatusContext.CDS_NAME)
    public void setQuestionnaireStatus(SetQuestionnaireStatusContext context){
        String referQuestionId = context.getQuestionId();
        Integer status = context.getStatus();

        Map<String, Object> data = new HashMap<>();
        data.put("status", status);

        Questionnaires referQuestionnaire = db.run(Select
        .from(Questionnaires_.class)
        .where(qn -> qn.ID().eq(referQuestionId)
        )).first(Questionnaires.class).orElse(null);

        if(referQuestionnaire != null){
            db.run(
                Update.entity(Questionnaires_.class)
                .where(q -> q.ID().eq(referQuestionId))
                .data(data)
            );

            Questionnaires result = db.run(Select
            .from(Questionnaires_.class)
            .where(qn -> qn.ID().eq(referQuestionId)
            )).first(Questionnaires.class).orElse(null);

            context.setResult(result);

        } else {
            throw new ServiceException(ErrorStatuses.NOT_FOUND, "Questionnaire not found with ID: " + referQuestionId);
        }
    }

//     @Function(name = "getCurrentUserInfo")
// public void getCurrentUserInfo(FunctionContext context) {
//     UserInfo user = context.getUserInfo();

//     Map<String, Object> result = new HashMap<>();
//     result.put("firstName", user.getFirstName());
//     result.put("lastName", user.getLastName());
//     result.put("email", user.getEmail());
//     result.put("roles", user.getRoles()); // returns List<String>

//     context.setResult(result);
// }

}
