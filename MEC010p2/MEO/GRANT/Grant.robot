''[Documentation]   robot --outputdir ./outputs ./SRV/UETAG/PlatUeIdentity.robot
...    Test Suite to validate UE Identity Tag (UETAG) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${MEO_SCHEMA}://${MEO_HOST}:${MEO_PORT}    ssl_verify=false
Library     OperatingSystem




*** Test Cases ***
TC_MEC_MEC010p2_MEO_GRANT_001_OK
    [Documentation]  
    ...  Check that MEO sends a synchronous grant response when a grant request is requested
    ...  ETSI GS MEC 010-2 2.0.10, clause 7.6.1.3.1
    ...  ETSI GS MEC 010-2 2.0.10, Table 6.2.4.2.2-1 (GrantRequest)
    ...  ETSI GS MEC 010-2 2.0.10, Table 6.2.4.4.2-1 (Grant)
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Create a GRANT request    grantRequest
    Check HTTP Response Status Code Is    201
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body Json Schema Is   Grant



TC_MEC_MEC010p2_MEO_GRANT_001_BR
    [Documentation]   TP_MEC_MEO_GRANT_001_BR
    ...  Check that MEO responds with an error when it receives a malformed request when a new grant request is performed
    ...  ETSI GS MEC 010-2 2.0.10, clause 7.6.1.3.2
    ...  ETSI GS MEC 010-2 2.0.10, Table 6.2.4.4.2-1 (Grant)
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Create a GRANT request    grantRejectedRequest
    Check HTTP Response Status Code Is    400



TC_MEC_MEC010p2_MEO_GRANT_002_OK
    [Documentation]   TP_MEC_MEO_GRANT_002_OK
    ...  Check that MEO sends a asynchronous grant response when a grant request is requested
    ...  ETSI GS MEC 010-2 2.0.10, clause 7.6.1.3.1
    ...  ETSI GS MEC 010-2 2.0.10, Table 6.2.4.4.2-1 (Grant)
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Create a GRANT request    grantRequest
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body is Empty


TC_MEC_MEC010p2_MEO_GRANT_003_OK
    [Documentation]    TP_MEC_MEO_GRANT_003_OK
    ...  Check that MEO sends the status of a grant request when a query on a granting ID is performed.
    ...  The process of creating the grant is ongoing, no grant is available yet 
    ...  ETSI GS MEC 010-2 2.0.10, clause 7.6.1.3.2
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an individual grant    ${grantId}
    Check HTTP Response Status Code Is    202
    Check HTTP Response Header Contains    Location
    Check HTTP Response Body is Empty
    
    
    
TC_MEC_MEC010p2_MEO_GRANT_003_NF
    [Documentation]    TP_MEC_MEO_GRANT_003_NF
    ...    Check that MEO responds with an error when it receives a request for returning a grant referred with a wrong ID
    ...    ETSI GS MEC 010-2 2.0.10, clause 7.6.1.3.2
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS
    Get an individual grant    ${non_existant_grant_id}
    Check HTTP Response Status Code Is    404
    
    

TC_MEC_MEC010p2_MEO_GRANT_004_OK
    [Documentation]    TP_MEC_MEO_GRANT_004_OK
    ...  Check that MEO sends the status of a grant request when a query on a granting ID is performed 
    ...  ETSI GS MEC 010-2 2.0.10, clause 7.6.1.3.2
    ...  ETSI GS MEC 010-2 2.0.10, Table 6.2.4.4.2-1
    [Tags]    PIC_GRANTS_MANAGEMENT    INCLUDE_UNDEFINED_SCHEMAS 
    Get an individual grant    ${grantId}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   Grant    



*** Keywords ***
Create a GRANT request
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/grants    ${body}    allow_redirects=false
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get an individual grant
    [Arguments]    ${grantId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/grants/${grantId}    allow_redirects=false
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


    