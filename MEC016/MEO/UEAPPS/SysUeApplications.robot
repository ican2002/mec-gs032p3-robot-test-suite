''[Documentation]   robot --outputdir ../../outputs ./SysUeApplications.robot
...    Test Suite to validate Bandwidth Management API (APPCTX) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot

Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
TP_MEC_MEC016_MEO_UEAPPS_001_OK
    [Documentation] 
    ...  Check that the IUT responds with the list of user applications available when requested by an UE Application
    ...  Reference ETSI GS MEC 016 v2.2.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the application contexts list
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ApplicationList
    FOR    ${appInfo}    IN    @{response['body']['appList']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${appInfo['appInfo']['appName']}    ${APP_NAME}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
    
TP_MEC_MEC016_MEO_UEAPPS_001_NF
    [Documentation] 
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 v2.2.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the application contexts list using wrong endpoint
    Check HTTP Response Status Code Is    404


TP_MEC_MEC016_MEO_UEAPPS_002_OK
    [Documentation] 
    ...  Check that the IUT responds with the list of user applications available when requested by an UE Application
    ...  Reference ETSI GS MEC 016 2.2.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the application contexts list using filters    ${filter} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ApplicationList
    FOR    ${appInfo}    IN    @{response['body']['appList']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${appInfo['appInfo']['appName']}    ${APP_NAME}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
    
TP_MEC_MEC016_MEO_UEAPPS_002_BR
    [Documentation] 
    ...  Check that the IUT responds with the list of user applications available when requested by an UE Application
    ...  Reference ETSI GS MEC 016 2.2.1, clause 7.3.3.1
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the application contexts list using filters    ${bad_filter} 
    Check HTTP Response Status Code Is    400



*** Keywords ***
Retrieve the application contexts list
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/app_list
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    
Retrieve the application contexts list using wrong endpoint
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/app_list_error
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Retrieve the application contexts list using filters
    [Arguments]    ${filter}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/app_list?${filter}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

