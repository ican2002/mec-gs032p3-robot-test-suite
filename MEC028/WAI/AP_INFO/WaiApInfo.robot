''[Documentation]   robot --outputdir ../../outputs ./WaiApInfo.robot
...    Test Suite to validate WLAN Information API (AP_INFO) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     String
Library     OperatingSystem
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false


*** Test Cases ***
TP_MEC_MEC028_SRV_WAI_001_OK
    [Documentation] 
    ...  Check that the IUT responds with the list of WLAN Access Point
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.3.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/ApInfo
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the access point information
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ApInfo
    ## Post condition
    FOR    ${apInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${apInfo['apId']['macId']}    ${MAC_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
   
TP_MEC_MEC028_SRV_WAI_002_OK
    [Documentation] 
    ...  Check that the IUT responds with the list of WLAN Access Point filtered by the macId provided as query parameter 
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.3.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/ApInfo
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the access point information using filters    ${filter} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ApInfo
    ## Post condition
    FOR    ${apInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${apInfo['apId']['macId']}    ${MAC_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
   

TP_MEC_MEC028_SRV_WAI_002_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application 
    ...  Reference "ETSI GS MEC 028 2.1.1, clause 7.3.3.1
    ...  https://forge.etsi.org/rep/mec/gs028-wai-api/blob/v2.1.1/WlanInformationApi.yaml#/schemas/ApInfo
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Retrieve the access point information using filters    ${bad_filter} 
    Check HTTP Response Status Code Is    400
    Check HTTP Response Body Json Schema Is   ProblemDetails 
    
  
*** Keywords ***
Retrieve the access point information
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/queries/ap/ap_information
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   
Retrieve the access point information using filters
    [Arguments]    ${filter}
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    GET     ${apiRoot}/${apiName}/${apiVersion}/queries/ap/ap_information?filter=${filter}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}