*** Settings ***

Documentation
...    A test suite for validating Application Subscriptions (APPSUB) operations.

Resource    ../../../GenericKeywords.robot
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    


*** Test Cases ***

TP_MEC_MEC011_SRV_MSL_001_OK
    [Documentation]
    ...    Check that the IUT responds with the liveness of a MEC service instance 
    ...     when queried by a MEC Application
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.10.3.1
 
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Individual MEC service liveness  ${URL_SERVICE_MEC_LIVENESS} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceLivenessInfo



TP_MEC_MEC011_SRV_MSL_001_NF
    [Documentation]
    ...   Check that the IUT responds with an error when
    ...     a request for an URI that cannot be mapped to a valid resource URI 
    ...     is sent by a MEC Application
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.10.3.1
 
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Individual MEC service liveness  ${NOT_EXISING_URL_SERVICE_MEC_LIVENESS}
    Check HTTP Response Status Code Is    404


TP_MEC_MEC011_SRV_MSL_002_OK
    [Documentation]
    ...    Check that the IUT updates the liveness of a MEC service instance 
    ...    when requested by a MEC Application
 
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Set Headers    {"Authorization":"${TOKEN}"}
    
    ${file}=    Catenate    SEPARATOR=    jsons/    ServiceLivenessUpdate    .json
    ${body}=    Get File    ${file}
    Update MEC service liveness  ${URL_SERVICE_MEC_LIVENESS}  ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceLivenessInfo
    Check Response Contains    ${response['body']}   state    ACTIVE

TP_MEC_MEC011_SRV_MSL_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    incorrect parameters were sent by a MEC Application
 
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Set Headers    {"Authorization":"${TOKEN}"}
    
    ${file}=    Catenate    SEPARATOR=    jsons/    ServiceLivenessUpdateError    .json
    ${body}=    Get File    ${file}
    Update MEC service liveness  ${URL_SERVICE_MEC_LIVENESS}  ${body}
    Check HTTP Response Status Code Is    400
    

*** Keywords ***
Individual MEC service liveness
    [Arguments]    ${URL_MEC_SERVICE_LIVENESS}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get     ${URL_MEC_SERVICE_LIVENESS}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Update MEC service liveness
    [Arguments]    ${URL_MEC_SERVICE_LIVENESS}  ${body}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Patch     ${URL_MEC_SERVICE_LIVENESS}   ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    