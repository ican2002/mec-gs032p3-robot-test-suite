Y''[Documentation]   robot --outputdir ../../../outputs ./V2XInformationService.robot
...    Test Suite to validate V2X Information Service API (VIS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    

##GET on ${apiRoot}/${apiName}/${apiVersion}/queries/uu_unicast_provisioning_info
*** Test Cases ***
TP_MEC_MEC030_SRV_V2X_001_OK_01
    [Documentation]
    ...  Check that the IUT responds with a configured provisioning information over Uu unicast when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.3.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over Uu unicast using ecgi filter    ${ECGI} 	
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   UuUnicastProvisioningInfo
    
    
TP_MEC_MEC030_SRV_V2X_001_OK_02
    [Documentation]
    ...  Check that the IUT responds with a configured provisioning information over Uu unicast when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.3.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over Uu unicast using geographical filter    ${LAT_VALUE}     ${LON_VALUE}	
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   UuUnicastProvisioningInfo

TP_MEC_MEC030_SRV_V2X_001_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.3.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over Uu unicast using geographical filter wrong parameter    ${LAT_VALUE}     ${LON_VALUE}	
    Check HTTP Response Status Code Is    400
    


TP_MEC_MEC030_SRV_V2X_001_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.3.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over Uu unicast using ecgi filter    ${UNKNOWN_ECGI} 
    Check HTTP Response Status Code Is    404


   
##GET on ${apiRoot}/${apiName}/${apiVersion}/queries/uu_mbms_provisioning_info
TP_MEC_MEC030_SRV_V2X_002_OK_01
    [Documentation]
    ...  Check that the IUT responds with a configured provisioning information over Uu MBM when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.4.3.1
    Retrieve configured provisioning information over Uu MBM using ecgi filter    ${ECGI} 	
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   UuMbmsProvisioningInfo

TP_MEC_MEC030_SRV_V2X_002_OK_02
    [Documentation]
    ...  Check that the IUT responds with a configured provisioning information over Uu MBMS when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.4.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over Uu MBM using geographical filter    ${LAT_VALUE}     ${LON_VALUE}	
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   UuMbmsProvisioningInfo
    
TP_MEC_MEC030_SRV_V2X_002_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.4.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over Uu MBM using geographical filter wrong parameter    ${LAT_VALUE}     ${LON_VALUE}	
    Check HTTP Response Status Code Is    400

TP_MEC_MEC030_SRV_V2X_002_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.4.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over Uu MBM using geographical filter    ${UNKNOWN_LAT_VALUE}     ${LON_VALUE}	
    Check HTTP Response Status Code Is    404
        


##GET on ${apiRoot}/${apiName}/${apiVersion}/queries/pc5_provisioning_info
TP_MEC_MEC030_SRV_V2X_003_OK_01
    [Documentation]
    ...  Check that the IUT responds with a configured provisioning information over PC5 when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over PC5 using ecgi filter    ${ECGI} 	
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Pc5ProvisioningInfo

TP_MEC_MEC030_SRV_V2X_003_OK_02
    [Documentation]
    ...  Check that the IUT responds with a configured provisioning information over Uu MBMS when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over PC5 using geographical filter    ${LAT_VALUE}     ${LON_VALUE}	
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Pc5ProvisioningInfo

TP_MEC_MEC030_SRV_V2X_003_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over PC5 using geographical filter wrong parameter    ${LAT_VALUE}     ${LON_VALUE}	
    Check HTTP Response Status Code Is    400


TP_MEC_MEC030_SRV_V2X_003_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Retrieve configured provisioning information over PC5 using ecgi filter    ${UNKNOWN_ECGI} 
    Check HTTP Response Status Code Is    404


##POST on ${apiRoot}/${apiName}/${apiVersion}/provide_predicted_qos
TP_MEC_MEC030_SRV_V2X_004_OK
    [Documentation]
    ...  Check that the IUT sends a request about QoS information for a vehicular UE when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.6.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Request predicted QoS   PredictedQoS.json
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   PredictedQoS
    
TP_MEC_MEC030_SRV_V2X_004_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.6.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    ##Wrong parameter into JSON: locality instead of locationGranularity
    Request predicted QoS   PredictedQoS_BR.json 
    Check HTTP Response Status Code Is    400

TP_MEC_MEC030_SRV_V2X_004_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.6.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Request predicted QoS   PredictedQoS_NF.json
    Check HTTP Response Status Code Is    404
        


##POST on ${apiRoot}/${apiName}/${apiVersion}/publish_v2x_message
TP_MEC_MEC030_SRV_V2X_005_OK
    [Documentation]
    ...  Check that the IUT processes properly a request to publish a V2X message
    ...  ETSI GS MEC 030 V2.1.1, clause 7.7.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Publish V2X message   V2xMsgPublication.json
    Check HTTP Response Status Code Is    204
    
TP_MEC_MEC030_SRV_V2X_005_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.7.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Publish V2X message   V2xMsgPublication_BR.json
    Check HTTP Response Status Code Is    400    



##GET on ${apiRoot}/${apiName}/${apiVersion}/subscription    
TP_MEC_MEC030_SRV_V2X_006_OK_01
    [Documentation] 
    ...  Check that the IUT responds with the requested list of subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve subscription list information    ${SUB_TYPE_PROV_CHG_UU_UNI}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList
    FOR    ${sub}    IN    @{response['body']['_links']['subscriptions']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${sub['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_UU_UNI}   
        Exit For Loop If   ${passed}==False
    END
    Should Be True    ${passed}
    
TP_MEC_MEC030_SRV_V2X_006_OK_02
    [Documentation] 
    ...  Check that the IUT responds with the requested list of subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve subscription list information    ${SUB_TYPE_PROV_CHG_UU_MBMS}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList
    FOR    ${sub}    IN    @{response['body']['_links']['subscriptions']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${sub['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_UU_MBMS}  
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}    

TP_MEC_MEC030_SRV_V2X_006_OK_03
    [Documentation] 
    ...  Check that the IUT responds with the requested list of subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve subscription list information    ${SUB_TYPE_PROV_CHG_PC5}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList
    FOR    ${sub}    IN    @{response['body']['_links']['subscriptions']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${sub['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_PC5} 
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}

TP_MEC_MEC030_SRV_V2X_006_OK_04
    [Documentation] 
    ...  Check that the IUT responds with the requested list of subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve subscription list information    ${SUB_TYPE_V2X_MSG}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   SubscriptionLinkList
    FOR    ${sub}    IN    @{response['body']['_links']['subscriptions']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${sub['subscriptionType']}    ${SUB_TYPE_RESP_V2X_MSG} 
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}


TP_MEC_MEC030_SRV_V2X_006_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve subscription list information    ${SUB_TYPE_INVALID}
    Check HTTP Response Status Code Is    400


##Below test not done yet. See this issue: https://forge.etsi.org/rep/mec/gs032p2-test-purposes/issues/9 
#TP_MEC_MEC030_SRV_V2X_006_NF 
#    [Documentation] 
#    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
#    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.1
#    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
#        
#    Should Be True    ${PIC_MEC_SYSTEM} == 1
#    Should Be True    ${PIC_SERVICES} == 1
#    Retrieve subscription list information    ${SUB_TYPE_INVALID}
#    Check HTTP Response Status Code Is    404
                    
##POST on ${apiRoot}/${apiName}/${apiVersion}/subscription  
TP_MEC_MEC030_SRV_V2X_007_OK_01
    [Documentation] 
    ...  Check that the IUT responds with the requested to create a subscription
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgUuUniSubscription.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Send a request for creating a subscription    ${body}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   ProvChgUuUniSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_UU_UNI}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Be Equal As Strings  ${json_object['filterCriteria']}    ${response['body']['filterCriteria']}
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	

TP_MEC_MEC030_SRV_V2X_007_OK_02
    [Documentation] 
    ...  Check that the IUT responds with the requested to create a subscription
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml       
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgUuMbmsSubscription.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Send a request for creating a subscription    ${body}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    ProvChgUuMbmsSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_UU_MBMS}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Be Equal As Strings  ${json_object['filterCriteria']}    ${response['body']['filterCriteria']}
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	
 

TP_MEC_MEC030_SRV_V2X_007_OK_03
    [Documentation] 
    ...  Check that the IUT responds with the requested to create a subscription
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgPc5Subscription.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Send a request for creating a subscription   ${body}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    ProvChgPc5Subscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_PC5}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Be Equal As Strings  ${json_object['filterCriteria']}    ${response['body']['filterCriteria']}
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	

TP_MEC_MEC030_SRV_V2X_007_OK_04
    [Documentation] 
    ...  Check that the IUT responds with the requested to create a subscription
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     V2xMsgSubscription.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Send a request for creating a subscription   ${body}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    V2xMsgSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_V2X_MSG}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Be Equal As Strings  ${json_object['filterCriteria']}    ${response['body']['filterCriteria']}
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	


TP_MEC_MEC030_SRV_V2X_007_BR
    [Documentation] 
    ...  Check that the IUT responds with the requested to create a subscription
    ...  ETSI GS MEC 030 V2.1.1, clause 7.8.3.4
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml        
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgUuMbmsSubscription_BR.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Send a request for creating a subscription   ${body}
    Check HTTP Response Status Code Is    400
 
          
##GET on ${apiRoot}/${apiName}/${apiVersion}/subscriptions/{subscriptionId}
TP_MEC_MEC030_SRV_V2X_008_OK_01
    [Documentation] 
    ...  Check that the IUT responds with the requested of subscription information when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve a subscription  ${SUB_PROV_CHG_UU_UNI_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ProvChgUuUniSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_UU_UNI}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Not Be Empty  ${response['body']['filterCriteria']}	
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	

TP_MEC_MEC030_SRV_V2X_008_OK_02
    [Documentation] 
    ...  Check that the IUT responds with the requested of subscription information when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve a subscription  ${SUB_PROV_CHG_UU_MBMS_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ProvChgUuMbmsSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_UU_MBMS}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Not Be Empty  ${response['body']['filterCriteria']}	
    Should Not Be Empty  ${response['body']['_links']['self']['href']}
    

TP_MEC_MEC030_SRV_V2X_008_OK_03
    [Documentation] 
    ...  Check that the IUT responds with the requested of subscription information when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve a subscription  ${SUB_PROV_CHG_PC5_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ProvChgPc5Subscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_PC5}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Not Be Empty  ${response['body']['filterCriteria']}	
    Should Not Be Empty  ${response['body']['_links']['self']['href']}

TP_MEC_MEC030_SRV_V2X_008_OK_04
    [Documentation] 
    ...  Check that the IUT responds with the requested of subscription information when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve a subscription  ${SUB_V2X_MSG_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   V2xMsgSubscription
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_V2X_MSG}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Not Be Empty  ${response['body']['filterCriteria']}	
    Should Not Be Empty  ${response['body']['_links']['self']['href']}

TP_MEC_MEC030_SRV_V2X_008_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve a subscription     ${SUB_WRONG_PARAM}
    Check HTTP Response Status Code Is    400  
    

TP_MEC_MEC030_SRV_V2X_008_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.1
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve a subscription     ${NOT_EXISTING_SUB_ID}
    Check HTTP Response Status Code Is    404   
    
    

##PUT on ${apiRoot}/${apiName}/${apiVersion}/subscriptions/{subscriptionId}
TP_MEC_MEC030_SRV_V2X_009_OK_01
    [Documentation] 
    ...  Check that the IUT responds with the requested of updating subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.2
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgUuUniSubscriptionUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update existing subscription   ${SUB_PROV_CHG_UU_UNI_ID}  ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ProvChgUuUniSubscription    
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_UU_UNI}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	
    Should Be Equal As Strings  ${json_object['filterCriteria']}  ${response['body']['filterCriteria']}

TP_MEC_MEC030_SRV_V2X_009_OK_02
    [Documentation] 
    ...  Check that the IUT responds with the requested of updating subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.2
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgUuMbmsSubscriptionUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update existing subscription   ${SUB_PROV_CHG_UU_MBMS_ID}  ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ProvChgUuMbmsSubscription    
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_UU_MBMS}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	
    Should Be Equal As Strings  ${json_object['filterCriteria']}  ${response['body']['filterCriteria']}

TP_MEC_MEC030_SRV_V2X_009_OK_03
    [Documentation] 
    ...  Check that the IUT responds with the requested of updating subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.2
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgPc5SubscriptionUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update existing subscription   ${SUB_PROV_CHG_PC5_ID}  ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ProvChgPc5Subscription    
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_PROV_CHG_PC5}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	
    Should Be Equal As Strings  ${json_object['filterCriteria']}   ${response['body']['filterCriteria']}
 
TP_MEC_MEC030_SRV_V2X_009_OK_04
    [Documentation] 
    ...  Check that the IUT responds with the requested of updating subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.2
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     V2xMsgSubscriptionUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update existing subscription   ${SUB_V2X_MSG_ID}  ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   V2xMsgSubscription    
    Should Be Equal As Strings  ${response['body']['subscriptionType']}    ${SUB_TYPE_RESP_V2X_MSG}   
    Should Be Equal As Strings  ${response['body']['callbackReference']}    ${CALLBACK_URL}	
    Should Not Be Empty  ${response['body']['_links']['self']['href']}	
    Should Be Equal As Strings  ${json_object['filterCriteria']}   ${response['body']['filterCriteria']}
 
TP_MEC_MEC030_SRV_V2X_009_BR
    [Documentation] 
    ...  Check that the IUT responds with the requested of updating subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.2
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgUuUniSubscriptionUpdate_BR.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update existing subscription   ${SUB_PROV_CHG_UU_UNI_ID}  ${body}
    Check HTTP Response Status Code Is    400


##Below test not done yet. See issue https://forge.etsi.org/rep/mec/gs032p2-test-purposes/issues/10
#TP_MEC_MEC030_SRV_V2X_009_NF
#    [Documentation] 
#    ...  Check that the IUT responds with the requested of updating subscription when queried by a MEC Application
#    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.2
#    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
#    Should Be True    ${PIC_MEC_SYSTEM} == 1
#    Should Be True    ${PIC_SERVICES} == 1
#    ${path}    Catenate    SEPARATOR=      jsons/     ProvChgUuUniSubscriptionUpdate_NF.json
#    ${body}    Get File    ${path}
#    ${json_object}=	Evaluate  json.loads('''${body}''')  json
#    Update existing subscription   ${SUB_PROV_CHG_UU_UNI_ID}  ${body}
#    Check HTTP Response Status Code Is    404
  
##DELETE on ${apiRoot}/${apiName}/${apiVersion}/subscriptions/{subscriptionId}

##Different implementation respect to the TP. See issue: https://forge.etsi.org/rep/mec/gs032p2-test-purposes/issues/7
TP_MEC_MEC030_SRV_V2X_010_OK_01 
    [Documentation] 
    ...  Check that the IUT responds with the requested of updating subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.2
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Remove existing subscription    ${SUB_PROV_CHG_UU_UNI_ID}
    Check HTTP Response Status Code Is    204  


##Different implementation respect to the TP. See issue: https://forge.etsi.org/rep/mec/gs032p2-test-purposes/issues/7
TP_MEC_MEC030_SRV_V2X_010_NF
    [Documentation] 
    ...  Check that the IUT responds with the requested of updating subscription when queried by a MEC Application
    ...  ETSI GS MEC 030 V2.1.1, clause 7.9.3.2
    ...  https://forge.etsi.org/rep/mec/gs030-vis-api/blob/master/MEC030_V2XInformationService.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Remove existing subscription       ${NOT_EXISTING_SUB_ID}
    Check HTTP Response Status Code Is    404   

##TP_MEC_MEC030_SRV_V2X_010_OK_02, TP_MEC_MEC030_SRV_V2X_010_OK_03 and TP_MEC_MEC030_SRV_V2X_010_OK_04 are missing because issue
## https://forge.etsi.org/rep/mec/gs032p2-test-purposes/issues/7

##TP with identifier TP_MEC_MEC030_SRV_V2X_010_BR is missing because of following issue:
## https://forge.etsi.org/rep/mec/gs032p2-test-purposes/issues/8       
*** Keywords ***
Retrieve configured provisioning information over Uu unicast using ecgi filter
    [Arguments]       ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/uu_unicast_provisioning_info?location_info=ecgi,${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Retrieve configured provisioning information over Uu unicast using geographical filter
    [Arguments]     ${latitude_value}   ${longitude_value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/uu_unicast_provisioning_info?location_info=latitude,${latitude_value},longitude,${longitude_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
 Retrieve configured provisioning information over Uu unicast using geographical filter wrong parameter 
    [Arguments]    ${latitude_value}   ${longitude_value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    #wrong parameter lattitude instead of latitude
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/uu_unicast_provisioning_info?location_info=lattitude,${latitude_value},longitude,${longitude_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
  

Retrieve configured provisioning information over Uu MBM using ecgi filter
    [Arguments]       ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/uu_mbms_provisioning_info?location_info=ecgi,${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Retrieve configured provisioning information over Uu MBM using geographical filter
    [Arguments]     ${latitude_value}   ${longitude_value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/uu_mbms_provisioning_info?location_info=latitude,${latitude_value},longitude,${longitude_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

 Retrieve configured provisioning information over Uu MBM using geographical filter wrong parameter 
    [Arguments]    ${latitude_value}   ${longitude_value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    #wrong parameter: lattitude instead of latitude
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/uu_mbms_provisioning_info?location_info=lattitude,${latitude_value},longitude,${longitude_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
         

Retrieve configured provisioning information over PC5 using ecgi filter
    [Arguments]       ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/pc5_provisioning_info?location_info=ecgi,${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    
Retrieve configured provisioning information over PC5 using geographical filter
    [Arguments]     ${latitude_value}   ${longitude_value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/pc5_provisioning_info?location_info=latitude,${latitude_value},longitude,${longitude_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

 Retrieve configured provisioning information over PC5 using geographical filter wrong parameter 
    [Arguments]    ${latitude_value}   ${longitude_value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    #wrong parameter: lattitude instead of latitude
    GET   ${apiRoot}/${apiName}/${apiVersion}/queries/pc5_provisioning_info?location_info=lattitude,${latitude_value},longitude,${longitude_value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Request predicted QoS
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/provide_predicted_qos    ${body} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    


Publish V2X message
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/publish_v2x_message    ${body} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Retrieve subscription list information
    [Arguments]    ${subscription_type}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/subscriptions?subscription_type=${subscription_type}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Send a request for creating a subscription    
    [Arguments]    ${body}
    Log    Creating a new subscription
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Post    ${apiRoot}/${apiName}/${apiVersion}/subscriptions    ${body}   
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    
Retrieve a subscription    
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}  
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}   
    
Update existing subscription    
    [Arguments]    ${subscriptionId}    ${body}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}      ${body}
    Log    ${body}   
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    
Remove existing subscription    
    [Arguments]    ${subscriptionId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/subscriptions/${subscriptionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 