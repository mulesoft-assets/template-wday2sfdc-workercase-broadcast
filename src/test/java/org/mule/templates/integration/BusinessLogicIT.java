/**
 * Mule Anypoint Template
 *
 * Copyright (c) MuleSoft, Inc.  All rights reserved.  http://www.mulesoft.com
 */

package org.mule.templates.integration;

import static org.junit.Assert.assertEquals;

import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.xml.datatype.DatatypeConfigurationException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.junit.After;
import org.junit.Before;
import org.junit.BeforeClass;
import org.junit.Test;
import org.mule.MessageExchangePattern;
import org.mule.api.MuleEvent;
import org.mule.api.MuleException;
import org.mule.construct.Flow;
import org.mule.context.notification.NotificationException;
import org.mule.processor.chain.SubflowInterceptingChainLifecycleWrapper;
import org.mule.streaming.ConsumerIterator;

import com.mulesoft.module.batch.BatchTestHelper;

/**
 * The objective of this class is to validate the correct behavior of the flows
 * for this Anypoint Template that make calls to external systems.
 */
public class BusinessLogicIT extends AbstractTemplateTestCase {

	private static final long TIMEOUT_MILLIS = 30000;
	private static final long DELAY_MILLIS = 500;
	private static final String PATH_TO_TEST_PROPERTIES = "./src/test/resources/mule.test.properties";
	private static final Logger LOGGER = LogManager.getLogger(BusinessLogicIT.class);
	
	protected static final int TIMEOUT_SEC = 60;
	private BatchTestHelper helper;
	
    private String extId, familyName, email, terminationId;
	private String sfdcId, accountId, contactId;
    
    @BeforeClass
    public static void beforeTestClass() {
        System.setProperty("poll.startDelayMillis", "8000");
        System.setProperty("poll.frequencyMillis", "30000");
        Date initialDate = new Date(System.currentTimeMillis() - 1000 * 60);
        Calendar cal = Calendar.getInstance();
        cal.setTime(initialDate);
        System.setProperty(
        		"watermark.default.expression", 
        		"#[groovy: new GregorianCalendar("
        				+ cal.get(Calendar.YEAR) + ","
        				+ cal.get(Calendar.MONTH) + ","
        				+ cal.get(Calendar.DAY_OF_MONTH) + ","
        				+ cal.get(Calendar.HOUR_OF_DAY) + ","
        				+ cal.get(Calendar.MINUTE) + ","
        				+ cal.get(Calendar.SECOND) + ") ]");
    }

    @Before
    public void setUp() throws Exception {
    	final Properties props = new Properties();
    	try {
    		props.load(new FileInputStream(PATH_TO_TEST_PROPERTIES));
    	} catch (Exception e) {
    	   LOGGER.error("Error occured while reading mule.test.properties", e);
    	} 
    	terminationId = props.getProperty("test.wday.termination.id");
    	familyName = props.getProperty("test.wday.family.name");
    	email = props.getProperty("test.wday.email");
    	
    	helper = new BatchTestHelper(muleContext);
		stopFlowSchedulers(POLL_FLOW_NAME);
		registerListeners();
		
		createTestDataInSandBox();
    }

    @After
    public void tearDown() throws MuleException, Exception {
    	deleteTestDataFromSandBox();
    }
    
    private void registerListeners() throws NotificationException {
		muleContext.registerListener(pipelineListener);
	}
    
	private void createTestDataInSandBox() throws MuleException, Exception {
		Flow flow = getFlow("hireEmployee");
		LOGGER.info("Creating a workday employee...");
		try {
			MuleEvent event = flow.process(getTestEvent(MessageExchangePattern.REQUEST_RESPONSE));
			extId = event.getMessage().getPayloadAsString();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
        
    @SuppressWarnings("unchecked")
	@Test
    public void testMainFlow() throws Exception {
		Thread.sleep(10000);
		runSchedulersOnce(POLL_FLOW_NAME);
		waitForPollToRun();
		helper.awaitJobTermination(TIMEOUT_MILLIS, DELAY_MILLIS);
		helper.assertJobWasSuccessful();	

    	SubflowInterceptingChainLifecycleWrapper flow = getSubFlow("getWorkdayEmployee");
		flow.initialise();
		MuleEvent response = flow.process(getTestEvent(getEmployee(), MessageExchangePattern.REQUEST_RESPONSE));			
		Map<String, String> workerRes = (Map<String, String>) response.getMessage().getPayload();
		LOGGER.info("Worker id:" + workerRes.get("EmployeeId"));
		
    	flow = getSubFlow("retrieveCaseSFDC");
    	flow.initialise();
		
		ConsumerIterator<Map<String, Object>> iterator = (ConsumerIterator<Map<String, Object>>) flow.process(getTestEvent(workerRes.get("EmployeeId"), 
				MessageExchangePattern.REQUEST_RESPONSE)).
										getMessage().getPayload();
		Map<String, Object> caseMap = iterator.next();
		sfdcId = caseMap.get("Id").toString();
		accountId = caseMap.get("AccountId").toString();
		contactId = caseMap.get("ContactId").toString();
		assertEquals("Subject should be synced", extId + " " + familyName + " Case", 
													caseMap.get("Subject"));
		assertEquals("Email should be synced", email, caseMap.get("SuppliedEmail"));
    }
    
    private void deleteTestDataFromSandBox() throws MuleException, Exception {
		// Delete the created users in SFDC
    	LOGGER.info("Deleting test data...");
		SubflowInterceptingChainLifecycleWrapper deleteFlow = getSubFlow("deleteSFDC");
		deleteFlow.initialise();

		List<String> idList = new ArrayList<String>();
		idList.add(sfdcId);
		idList.add(accountId);
		idList.add(contactId);
		deleteFlow.process(getTestEvent(idList,
				MessageExchangePattern.REQUEST_RESPONSE));
		// Delete the created users in Workday
		SubflowInterceptingChainLifecycleWrapper flow = getSubFlow("getWorkdayEmployee");
		flow.initialise();
		
		try {
			MuleEvent response = flow.process(getTestEvent(getEmployee(), MessageExchangePattern.REQUEST_RESPONSE));
			Map<String, String> workerRes = (Map<String, String>) response.getMessage().getPayload();
			flow = getSubFlow("terminateWorkdayEmployee");
			flow.initialise();
			flow.process(getTestEvent(prepareTerminate(workerRes), MessageExchangePattern.REQUEST_RESPONSE));								
		} catch (Exception e) {
			e.printStackTrace();
		}

	}
    
    private Map<String, String> getEmployee(){
		Map<String, String> wdayEmployee = new HashMap<String, String>();
		wdayEmployee.put("systemId", "Salesforce - Chatter");
		wdayEmployee.put("value", extId);
		return wdayEmployee;
	}
	
	private Map<String, Object> prepareTerminate(Map<String, String> workerRes) throws DatatypeConfigurationException{		
		java.util.Calendar cal = java.util.Calendar.getInstance();
		cal.add(java.util.Calendar.DATE, 1);
		
		Map<String, Object> terminateEmployee = new HashMap<String, Object>();
		terminateEmployee.put("TerminationDate", cal);
		terminateEmployee.put("PrimaryReasonRefType", "WID");
		terminateEmployee.put("PrimaryReasonRefValue", terminationId);
		terminateEmployee.put("EmployeeRefType", "Employee_ID");
		terminateEmployee.put("EmployeeId", workerRes.get("EmployeeId"));
		
		return terminateEmployee;
	}
}
