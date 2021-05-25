''[Documentation]   robot --outputdir ../../../outputs ./MultiAccessTrafficSteering.robot
...    Test Suite to validate Multi-access traffic steering API (MTS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    


##GET on ${apiRoot}/${apiName}/${apiVersion}/mts_info
*** Test Cases ***
TP_MEC_MEC015_SRV_MTS_001_OK
    [Documentation]
    ...  Check that the IUT responds with the Multi-access Traffic Steering information when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.3.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve MTS capability information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsCapabilityInfo
    

##GET on ${apiRoot}/${apiName}/${apiVersion}/mts_sessions
TP_MEC_MEC015_SRV_MTS_002_OK
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    #Retrieve MTS session list information
    Retrieve MTS session list information using filter  ${CORRECT_FILTER}   ${SESSION_ID}   
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    FOR    ${mstSessionInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${mstSessionInfo['appInsId']}    ${APP_INSTANCE_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}

TP_MEC_MEC015_SRV_MTS_002_BR
    [Documentation]
    ...  Check that the IUT responds with the list of configured Multi-access Traffic Steering when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve MTS session list information using filter  ${BAD_FILTER}   ${APP_INSTANCE_ID}   
    Check HTTP Response Status Code Is    400

TP_MEC_MEC015_SRV_MTS_002_NF
    [Documentation]
    ...  Check that the IUT responds with the list of configured Multi-access Traffic Steering when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve MTS session list information using filter  ${CORRECT_FILTER}   ${NOT_EXISTING_APP_INSTANCE_ID}   
    Check HTTP Response Status Code Is    404

    
##POST on ${apiRoot}/${apiName}/${apiVersion}/mts_sessions
TP_MEC_MEC015_SRV_MTS_003_OK_01
    [Documentation]
    ...  Check that the IUT creates a MTS session when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    ${path}    Catenate    SEPARATOR=      jsons/     MtsSessionInfoApplicationSpecific.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Register MTS session    ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${json_object['appInsId']}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${json_object['requestType']}
    Should Be Equal As Strings  ${response['body']['qosD']}    ${json_object['qosD']}
    Should Be Equal As Strings  ${response['body']['mtsMode']}    ${json_object['mtsMode']}
    Should Be Equal As Strings  ${response['body']['trafficDirection']}    ${json_object['trafficDirection']}


TP_MEC_MEC015_SRV_MTS_003_OK_02
    [Documentation]
    ...  Check that the IUT creates a MTS session when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    ${path}    Catenate    SEPARATOR=      jsons/     MtsSessionInfoSessionSpecific.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Register MTS session   ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${json_object['appInsId']}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${json_object['requestType']}
    Should Be Equal As Strings  ${response['body']['flowFilter']}    ${json_object['flowFilter']}
    Should Be Equal As Strings  ${response['body']['qosD']}    ${json_object['qosD']}
    Should Be Equal As Strings  ${response['body']['mtsMode']}    ${json_object['mtsMode']}
    Should Be Equal As Strings  ${response['body']['trafficDirection']}    ${json_object['trafficDirection']}
    

TP_MEC_MEC015_SRV_MTS_003_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    ${path}    Catenate    SEPARATOR=      jsons/     MtsSessionInfoApplicationSpecific_BR.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Register MTS session   ${body}
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${json_object['appInsId']}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${json_object['requestType']}
    Should Be Equal As Strings  ${response['body']['qosD']}    ${json_object['qosD']}
    Should Be Equal As Strings  ${response['body']['mtsMode']}    ${json_object['mtsMode']}
    Should Be Equal As Strings  ${response['body']['trafficDirection']}    ${json_object['trafficDirection']}


##GET on ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/{sessionId}
TP_MEC_MEC015_SRV_MTS_004_OK
    [Documentation]
    ...  Check that the IUT responds with a configured Multi-access Traffic Steering session when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve single MTS session   ${SESSION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}                   ${APP_INSTANCE_ID}
    Should Be Equal As Strings  ${response['body']['requestType']}             ${REQUEST_TYPE_APPLICATION}     
    Should Be Equal As Strings  ${response['body']['mtsMode']}                   ${MTS_LOW_MODE_COST} 
    Should Be Equal As Strings  ${response['body']['trafficDirection']}         ${TRAFFIC_DIRECTION_DL}   

TP_MEC_MEC015_SRV_MTS_004_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve single MTS session   ${WRONG_SESSION_ID}	
    Check HTTP Response Status Code Is    400
    
TP_MEC_MEC015_SRV_MTS_004_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve single MTS session   ${NOT_EXISTING_SESSION_ID}
    Check HTTP Response Status Code Is    404


##PUT on ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/{sessionId}
TP_MEC_MEC015_SRV_MTS_005_OK
    [Documentation]
    ...  Check that the IUT updates the information about an individual MTS session when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    ${path}    Catenate    SEPARATOR=      jsons/     MtsSessionInfoApplicationSpecificUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update requested requirements on the MTS Service    ${SESSION_ID}     ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${json_object['appInsId']}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${json_object['requestType']}
    Should Be Equal As Strings  ${response['body']['qosD']}    ${json_object['qosD']}
    Should Be Equal As Strings  ${response['body']['mtsMode']}    ${json_object['mtsMode']}
    Should Be Equal As Strings  ${response['body']['trafficDirection']}    ${json_object['trafficDirection']}    
    
TP_MEC_MEC015_SRV_MTS_005_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    ${path}    Catenate    SEPARATOR=      jsons/     MtsSessionInfoApplicationSpecificUpdate_BR.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update requested requirements on the MTS Service    ${SESSION_ID}     ${body}
    Check HTTP Response Status Code Is    400

TP_MEC_MEC015_SRV_MTS_005_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with an unknown resource URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    ${path}    Catenate    SEPARATOR=      jsons/     MtsSessionInfoApplicationSpecificUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update requested requirements on the MTS Service    ${NOT_EXISTING_SESSION_ID}     ${body}
    Check HTTP Response Status Code Is    404
             
##DELETE on ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/{sessionId}
TP_MEC_MEC015_SRV_MTS_006_OK
    [Documentation]
    ...  Check that the IUT deregisters a MTS session when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.3
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Unregister from the MTS Service   ${SESSION_ID}
    Check HTTP Response Status Code Is    204

TP_MEC_MEC015_SRV_MTS_006_NF
    [Documentation]
    ...  Check that the IUT deregisters a MTS session when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.4.3.3
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Unregister from the MTS Service   ${NOT_EXISTING_SESSION_ID}
    Check HTTP Response Status Code Is    404
   
*** Keywords ***
Retrieve MTS capability information
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/mts_info
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
  
Retrieve MTS session list information
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Retrieve MTS session list information using filter
    [Arguments]    ${filter}  ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions?${filter}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Register MTS session
    [Arguments]    ${body}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    POST    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Register MTS session wrong URI
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    #Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    POST    ${apiRoot}/${apiName}/v0/mts_sessions   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Retrieve single MTS session
    [Arguments]    ${sessionId}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/${sessionId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Update requested requirements on the MTS Service
    [Arguments]    ${sessionId}   ${body}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/${sessionId}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Unregister from the MTS Service
    [Arguments]    ${sessionId} 
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    LOG   ${sessionId} 
    DELETE    ${apiRoot}/${apiName}/${apiVersion}/mts_sessions/${sessionId} 
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}