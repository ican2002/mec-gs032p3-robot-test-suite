''[Documentation]   robot --outputdir ../../outputs ./SysUeApplicationsLocation.robot

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     OperatingSystem    
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false



*** Test Cases ***
TP_MEC_MEC016_MEO_UEAPPLOC_001_OK
    [Documentation] 
    ...  Check that the IUT sends the locations available for instantiation of a specific user application when requested by an UE Application
    ...  Reference ETSI GS MEC 016 2.2.1, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Obtain Application Location Availability Task     AppLocationAvailability.json
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   ApplicationLocationAvailability
    Should Be Equal As Strings   ${response['body']['appInfo']['appName']}    MyNewWornderfulApp


TP_MEC_MEC016_MEO_UEAPPLOC_001_BR
    [Documentation] 
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application  
    ...  Reference ETSI GS MEC 016 2.2.1, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Obtain Application Location Availability Task    AppLocationAvailability_BR.json
    Check HTTP Response Status Code Is    400
    

TP_MEC_MEC016_MEO_UEAPPCTX_001_NF
    [Documentation]   
    ...  Check that the IUT responds with an error when a request with incorrect URL is sent by a MEC Application
    ...  Reference ETSI GS MEC 016 2.2.1, clause 7.6.3.4
    ...  Reference https://forge.etsi.org/gitlab/mec/gs016-ue-app-api/blob/master/UEAppInterfaceApi.yaml#/definitions/ApplicationList
    Should Be True    ${PIC_MEC_SYSTEM} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Obtain Application Location Availability Task using wrong endpoint    AppLocationAvailability.json
    Check HTTP Response Status Code Is    404


*** Keywords ***
Obtain Application Location Availability Task
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}=    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/obtain_app_loc_availability    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Obtain Application Location Availability Task using wrong endpoint
    [Arguments]    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${path}=    Catenate    SEPARATOR=      jsons/     ${content}
    ${body}    Get File    ${path}
    Post    ${apiRoot}/${apiName}/${apiVersion}/obtain_app_loc_availability_error    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
