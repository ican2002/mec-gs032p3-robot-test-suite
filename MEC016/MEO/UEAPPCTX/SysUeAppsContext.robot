''[Documentation]   robot --outputdir ../../outputs ./SysUeAppContext.robot
...    Test Suite to validate Bandwidth Management API (APPCTX) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     String
Library     OperatingSystem
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false


*** Test Cases ***
TP_MEC_MEC016_MEO_UEAPPCTX_001_OK
    [Documentation] 
    ...  Check that the IUT acknowledges the creation of the application context when requested by an UE Application
    ...  Reference ETSI GS MEC 016 v2.2.1, clause 7.4.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create application context    AppContext.json
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   AppContext
    Should Be Equal As Strings   ${response['body']['appInfo']['appName']}    MyNewWornderfulApp
    Set Suite Variable    ${contextId}    ${response['body']['contextId']}


TP_MEC_MEC016_MEO_UEAPPCTX_001_BR
    [Documentation]   
    ...  Check that the IUT responds with an error when a request with incorrect URL is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 v2.2.1, clause 7.4.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create application context    AppContext_BR.json
    Check HTTP Response Status Code Is    400
    

TP_MEC_MEC016_MEO_UEAPPCTX_001_NF
    [Documentation]   
    ...  Check that the IUT responds with an error when a request with incorrect URL is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 v2.2.1, clause 7.4.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Create application context using wrong endpoint    AppContext.json
    Check HTTP Response Status Code Is    404
    

TP_MEC_MEC016_MEO_UEAPPCTX_002_OK
    [Documentation]   
    ...  Check that the IUT updates the application callback reference when commanded by an UE Application
    ...  Reference ETSI GS MEC 016 v2.2.1, clause 7.5.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    # Test Body
    Update application context        ${contextId}    UpdateAppContext.json
    Check HTTP Response Status Code Is    204
    Check HTTP Response Body Json Schema Is   AppContext
    Should Be Equal As Strings    ${response['body']['callbackReference']}    http://127.0.0.1/callbackuri 

TP_MEC_MEC016_MEO_UEAPPCTX_002_BR
    [Documentation]   
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 v2.2.1, clause 7.5.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Update application context    ${contextId}    UpdateAppContext_BR.json
    Check HTTP Response Status Code Is    400


TP_MEC_MEC016_MEO_UEAPPCTX_002_NF
    [Documentation]   
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 2.2.1, clause 7.5.3.2
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Update application context using wrong endpoint    ${contextId}    UpdateAppContext.json
    Check HTTP Response Status Code Is    404


TP_MEC_MEC016_MEO_UEAPPCTX_003_OK
    [Documentation]  
    ...  Check that the IUT deletes the application context when commanded by an UE Application
    ...  Reference ETSI GS MEC 016 2.2.1, clause 7.5.3.5
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Delete application context    ${contextId}
    Check HTTP Response Status Code Is    204


TP_MEC_MEC016_MEO_UEAPPCTX_003_NF
    [Documentation]  
    ...  Check that the IUT deletes the application context when commanded by an UE Application
    ...  Reference ETSI GS MEC 016 2.2.1, clause 7.5.3.5
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/AppContext
    # Preamble
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Delete application context    ${NON_EXISTING_CONTEXT_ID}
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404


*** Keywords ***
Create application context
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPATATOR=      jsons/     ${content}
    ${body}    Get Binary File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_contexts    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Create application context using wrong endpoint
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}    Catenate    SEPATATOR=      jsons/     ${content}
    ${body}    Get Binary File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/app_contexts_error    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update application context
    [Arguments]    ${context_id}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/app_contexts/${context_id}    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update application context using wrong endpoint
    [Arguments]    ${context_id}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/app_contexts_error/${context_id}    ${content}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Delete application context
    [Arguments]    ${context_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_contexts/${context_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Delete application context using wrong endpoint
    [Arguments]    ${context_id}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/app_contexts_error/${context_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
