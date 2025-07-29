package customer.captraining.handlers;
import java.math.BigDecimal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.sap.cds.services.cds.CqnService;
import com.sap.cds.services.handler.EventHandler;
import com.sap.cds.services.handler.annotations.After;
import com.sap.cds.services.handler.annotations.On;
import com.sap.cds.services.handler.annotations.ServiceName;
import com.sap.cds.services.persistence.PersistenceService;
import com.sap.cds.Result;
import com.sap.cds.Row;
import com.sap.cds.ql.CQL;
import com.sap.cds.ql.Insert;
import com.sap.cds.ql.Select;
import com.sap.cds.ql.Update;
import com.sap.cds.ql.cqn.CqnSelect;
import com.sap.cds.services.cds.CdsReadEventContext;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import javax.sound.midi.MidiDevice.Info;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import lombok.extern.slf4j.Slf4j;
import cds.gen.flexiblerequestsservice.ApproveFlexibleRequestContext;
import cds.gen.flexiblerequestsservice.CloneFlexibleRequestContext;
import cds.gen.flexiblerequestsservice.FlexibleRequests;
import cds.gen.flexiblerequestsservice.FlexibleRequestsService_;
import cds.gen.flexiblerequestsservice.FlexibleRequests_;
import cds.gen.flexiblerequestsservice.RejectFlexibleRequestContext;

import static com.sap.cds.ResultBuilder.selectedRows;

@Slf4j
@Component
@ServiceName(FlexibleRequestsService_.CDS_NAME)
public class FlexibleRequestsServiceHandler implements EventHandler {

    @Autowired
    private PersistenceService db;

    public FlexibleRequestsServiceHandler(PersistenceService db) {
        this.db = db;
    }

    @On(event = CloneFlexibleRequestContext.CDS_NAME)
    public void cloneFlexibleRequest(CloneFlexibleRequestContext context){
        log.info("My User Info Object | Object={}", context);
        String referenceId = context.getFrId();

        // Build and run the SELECT query
        FlexibleRequests referFlexibleRequest = db.run(Select
        .from(FlexibleRequests_.class)
        .where(fr -> fr.ID().eq(referenceId)
        )).first(FlexibleRequests.class).orElse(null);


        if (referFlexibleRequest != null){
            referFlexibleRequest.setId(UUID.randomUUID().toString());

            Result result = db.run(
                Insert.into(FlexibleRequests_.CDS_NAME)
                .entry(referFlexibleRequest)
                );
            log.info("My User Info Object | Object={}", referFlexibleRequest);
        
            if (result != null){
                context.setResult(result.first(FlexibleRequests.class).get());
            }
        }

        context.setCompleted();
    }

    @On(event = ApproveFlexibleRequestContext.CDS_NAME)
    public void approveFlexibleRequest(ApproveFlexibleRequestContext context){
        String requestId = context.getFrId();

        // Build and run the SELECT query
        FlexibleRequests approvRequest = db.run(Select
        .from(FlexibleRequests_.class)
        .where(fr -> fr.ID().eq(requestId)
        )).first(FlexibleRequests.class).orElse(null);

        if(approvRequest!=null){
            approvRequest.setStatus(20);
            Result result = db.run(
                Update.entity(FlexibleRequests_.CDS_NAME)
                .entry(approvRequest)
            );

            if(result != null){
                context.setResult(result.first(FlexibleRequests.class).get());
            }
        }

        context.setCompleted();
    }

    @On(event = RejectFlexibleRequestContext.CDS_NAME)
    public void rejectFlexibleRequest(RejectFlexibleRequestContext context){
        String requestId = context.getFrId();

        // Build and run the SELECT query
        FlexibleRequests rejectRequest = db.run(Select
        .from(FlexibleRequests_.class)
        .where(fr -> fr.ID().eq(requestId)
        )).first(FlexibleRequests.class).orElse(null);

        if(rejectRequest!=null){
            rejectRequest.setStatus(50);
            Result result = db.run(
                Update.entity(FlexibleRequests_.CDS_NAME)
                .entry(rejectRequest)
            );

            if(result != null){
                context.setResult(result.first(FlexibleRequests.class).get());
            }
        }

        context.setCompleted();
    }
}