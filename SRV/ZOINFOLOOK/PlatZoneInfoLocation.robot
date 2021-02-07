*** Settings ***

Documentation
...    A test suite for validating Radio Node Location Lookup (RLOCLOOK) operations.

Resource    ../../GenericKeywords.robot
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem 

Default Tags    TC_MEC_SRV_RLOCLOOK


*** Test Cases ***

TC_MEC_SRV_ZOINFOLOOK_001_OK
    [Documentation]
    ...    TO BE COMPLETED

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES    INCLUDE_UNDEFINED_SCHEMAS
    Get the zones info location list
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ZoneList


TC_MEC_SRV_ZOINFOLOOK_002_OK
    [Documentation]
    ...    TO BE CMPLETED

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get the zone info location        ${ZONE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ZoneInfo
    Should Be Equal As Strings    ${response['body']['zoneInfo']['zoneId']}    ${ZONE_ID}
    
TC_MEC_SRV_ZOINFOLOOK_002_NF
    [Documentation]
    ...    TO BE CMPLETED

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get the zone info location        ${NON_EXISTENT_ZONE_ID}
    Check HTTP Response Status Code Is    404

*** Keywords ***
Get the zone info location 
    [Arguments]    ${zoneId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/zones/${zoneId}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get the zones info location list
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/queries/zones
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



