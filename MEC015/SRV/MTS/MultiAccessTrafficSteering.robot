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
    ...  Check that the IUT responds with the list of configured Multi-access Traffic Steering when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve MTS session list information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    FOR    ${mstSessionInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${mstSessionInfo['appInsId']}    ${APP_INSTANCE_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}


TP_MEC_MEC015_SRV_MTS_003_OK
    [Documentation]
    ...  Check that the IUT responds with a configured Multi-access Traffic Steering when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve MTS session list information using filter  ${CORRECT_FILTER}   ${APP_INSTANCE_ID}   
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    FOR    ${mstSessionInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${mstSessionInfo['appInsId']}    ${APP_INSTANCE_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
    


TP_MEC_MEC015_SRV_MTS_003_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve MTS session list information using filter  ${BAD_FILTER}   ${APP_INSTANCE_ID}   
    Check HTTP Response Status Code Is    400
    

TP_MEC_MEC015_SRV_MTS_003_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with an unknown resource URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.1
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Retrieve MTS session list information using filter  ${CORRECT_FILTER}   ${NOT_EXISTING_APP_INSTANCE_ID}   
    Check HTTP Response Status Code Is    404

    
##POST on ${apiRoot}/${apiName}/${apiVersion}/mts_sessions
TP_MEC_MEC015_SRV_MTS_004_OK_01
    [Documentation]
    ...  Check that the IUT responds with a registration and initialisation approval for the requested MTS session requirements sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Register MTS session   MtsSessionInfoApplicationSpecific.json
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${APP_INSTANCE_ID}
    
TP_MEC_MEC015_SRV_MTS_004_OK_02
    [Documentation]
    ...  Check that the IUT responds with a registration and initialisation approval for the requested MTS session requirements sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Register MTS session   MtsSessionInfoSessionSpecific.json
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   MtsSessionInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${APP_INSTANCE_ID}
    
TP_MEC_MEC015_SRV_MTS_004_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 9.5.3.2
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Register MTS session wrong URI   MtsSessionInfoSessionSpecific.json
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
    Get    ${apiRoot}/${apiName}/${apiVersion}/mts_session
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
    Get    ${apiRoot}/${apiName}/${apiVersion}/mts_session?${filter}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Register MTS session
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    ${path}    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    POST    ${apiRoot}/${apiName}/${apiVersion}/mts_session   ${body}
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
    POST    ${apiRoot}/${apiName}/v0/mts_session   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}