*** Settings ***

Documentation
...    A test suite for validating Application Service Availability Query (APPSAQ) operations.

Resource    ../../../GenericKeywords.robot
Resource    environment/variables.txt
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false

Default Tags    TC_MEC_SRV_APPSAQ



*** Test Cases ***

TP_MEC_MEC011_SRV_APPSAQ_001_OK
    [Documentation]
    ...    Check that the IUT responds with a list of available MEC services
    ...    for a given application instance when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.6.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo 

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    Get a list of mecService of an application instance    ${APP_INSTANCE_ID} 
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfoList


TP_MEC_MEC011_SRV_APPSAQ_001_BR
    [Documentation]
    ...   Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.6.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES

    # Wrong query parameter name should trigger an error response.
    Get a list of mecService of an application instance with parameters    ${APP_INSTANCE_ID}    ${INSTANCE_ID}    ${FAKE_INSTANCE_ID_VALUE}
    Check HTTP Response Status Code Is    400


TP_MEC_MEC011_SRV_APPSAQ_002_OK
    [Documentation]
    ...    Check that the IUT notifies the authorised relevant (subscribed) application
    ...    instances when a new service for a given application instance is registered
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.6.3.4
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new service    ServiceInfo    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check HTTP Response Header Contains    Location
    Check Response Contains    ${response['body']}    serName    ${NEW_SERVICE_NAME}


TP_MEC_MEC011_SRV_APPSAQ_002_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.6.3.4
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new service    ServiceInfoError    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    400


TP_MEC_MEC011_SRV_APPSAQ_002_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.6.3.4
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Create new service    ServiceInfo    ${NON_EXISTENT_APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_MEC011_SRV_APPSAQ_003_OK
    [Documentation]
    ...    Check that the IUT responds with the information on a specific service
    ...    for a given application instance when queried by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.7.3.1
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check Response Contains    ${response['body']}    serInstanceId    ${SERVICE_ID}


TP_MEC_MEC011_SRV_APPSAQ_003_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.7.3.1

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Get individual service    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SERVICE_ID}
    Check HTTP Response Status Code Is    404


TP_MEC_MEC011_SRV_APPSAQ_004_OK
    [Documentation]
    ...    Check that the IUT updates a service information for a given
    ...    application instance when commanded by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.7.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update service    ${APP_INSTANCE_ID}    ${SERVICE_ID}    ServiceInfoUpdated
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is    ServiceInfo
    Check Response Contains    ${response['body']}    version    ${SVC_NEW_VERSION}


TP_MEC_MEC011_SRV_APPSAQ_004_BR
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request with incorrect parameters is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.7.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update service    ${APP_INSTANCE_ID}    ${SERVICE_ID}    ServiceInfoUpdatedError
    Check HTTP Response Status Code Is    400


TP_MEC_MEC011_SRV_APPSAQ_004_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for an unknown URI is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.7.3.2
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Update service    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SERVICE_ID}    ServiceInfoUpdated
    Check HTTP Response Status Code Is    404


TP_MEC_MEC011_SRV_APPSAQ_005_OK
    [Documentation]
    ...    Check that the IUT executes the deletion of a service 
    ...    for a given application instance when requested by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.7.3.5
    ...    OpenAPI    https://forge.etsi.org/rep/mec/gs011-app-enablement-api/blob/master/MecServiceMgmtApi.yaml#/definitions/ServiceInfo

   [Tags]    PIC_MEC_PLAT    PIC_SERVICES
   Remove individual service    ${APP_INSTANCE_ID}    ${SERVICE_ID}
    Check HTTP Response Status Code Is    204


TP_MEC_MEC011_SRV_APPSAQ_005_NF
    [Documentation]
    ...    Check that the IUT responds with an error when
    ...    a request for deletion of a unknown service is sent by a MEC Application
    ...
    ...    Reference    ETSI GS MEC 011 V2.2.1, clause 8.2.7.3.5
    [Tags]    PIC_MEC_PLAT    PIC_SERVICES
    Remove individual service    ${APP_INSTANCE_ID}    ${NON_EXISTENT_SERVICE_ID}
    Check HTTP Response Status Code Is    404



*** Keywords ***
Get a list of mecService of an application instance with parameters
    [Arguments]    ${appInstanceId}    ${key}=None    ${value}=None
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services?${key}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}

Get a list of mecService of an application instance
    [Arguments]    ${appInstanceId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Create new service
    [Arguments]    ${content}    ${appInstanceId}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    #Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Log   ${appInstanceId}
    Post    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get individual service
    [Arguments]    ${appInstanceId}    ${serviceName} 
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services/${serviceName}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}  
    
Update service    
    [Arguments]    ${appInstanceId}    ${serviceId}    ${content}
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    #Set Headers    {"Content-Type":"*/*"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    PUT    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services/${serviceId}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    

Remove individual service
    [Arguments]    ${appInstanceId}    ${serviceName} 
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Type":"*/*"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/applications/${appInstanceId}/services/${serviceName}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output} 
    

# Check Plaform IUT notifies the MEC Application instances
    # [Documentation]
    # ...    

    # [Arguments]    ${instance_id}    ${content}

    # TODO check how to send the message (isn't defined). Does it need to be tested as it's not defined?
    
    # // MEC 011, clause 6.4.2
    # the IUT entity sends a notification_message containing
    # body containing
    # notificationType set to "SerAvailabilityNotification",
    # services containing
    # serName set to SERVICE_NAME
    # _links containing
    # subscription set to MP1_SUBSCRIPTION_A
    # ;
    # ;
    # ;
    # ;
    # to the MEC_APP_Subscriber entity
