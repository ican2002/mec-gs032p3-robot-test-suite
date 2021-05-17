''[Documentation]   robot --outputdir ../../outputs ./RnisNotifications_BV.robot
...    Test Suite to validate RNIS/Notification (RNIS) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Resource    resources/RadioNetworkInformationAPI.robot
Library     REST    ${MEC-APP_SCHEMA}://${MEC-APP_HOST}:${MEC-APP_PORT}    ssl_verify=false
Library     BuiltIn
Library     OperatingSystem
Library     MockServerLibrary
Suite Setup    Create Mock Session    ${callback_uri}:${callback_port}
Test Teardown  Reset All Requests

*** Test Cases ***
TC_MEC_MEC012_SRV_RNIS_001_OK
    [Documentation]   Cell change notification
    ...  Check that the RNIS service sends an RNIS notification about cell change if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.2
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/CellChangeNotification.schema.json
    Log  Creating mock request and response to handle Cell change notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=&{appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


TC_MEC_MEC012_SRV_RNIS_002_OK
    [Documentation]   RAB Establishment notification
    ...  Check that the RNIS service sends an RNIS notification about RAB establishment if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.3
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RabEstNotification.schema.json
    Log  Creating mock request and response to handle RAB establishment notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/rab_est    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=${appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


TC_MEC_MEC012_SRV_RNIS_003_OK
    [Documentation]   RAB modification notification
    ...  Check that the RNIS service sends an RNIS notification about RAB modification if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.4
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RabModNotification.schema.json
    Log  Creating mock request and response to handle RAB modification notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/rab_mod    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=${appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


TC_MEC_MEC012_SRV_RNIS_004_OK
    [Documentation]   RAB release notification
    ...  Check that the RNIS service sends an RNIS notification about RAB release if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.5
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/RabRelNotification.schema.json
    Log  Creating mock request and response to handle RAB release notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/rab_rel    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=${appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


TC_MEC_MEC012_SRV_RNIS_005_OK
    [Documentation]   UE measurement notification
    ...  Check that the RNIS service sends an RNIS notification about UE measurement report  if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.6
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/MeasRepUeNotification.schema.json
    Log  Creating mock request and response to handle UE measurement notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/MeasRepUeNotification    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=${appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


TC_MEC_MEC012_SRV_RNIS_006_OK
    [Documentation]   UE timing advance notification
    ...  Check that the RNIS service sends an RNIS notification about UE timing advance if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.7
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/MeasTaSubscription.schema.json
    Log  Creating mock request and response to handle UE timing advance notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/MeasTaNotification    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=${appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


TC_MEC_MEC012_SRV_RNIS_007_OK
    [Documentation]   UE carrier aggregation reconfiguration notification
    ...  Check that the RNIS service sends an RNIS notification about UE carrier aggregation reconfiguration if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.8
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/CaReconfSubscription.schema.json
    Log  Creating mock request and response to handle UE carrier aggregation reconfiguration notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/CaReconfSubscription    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=${appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


TC_MEC_MEC012_SRV_RNIS_008_OK
    [Documentation]   S1-U bearer notification
    ...  Check that the RNIS service sends an RNIS notification about S1-U bearer if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.9
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/S1BearerSubscription.schema.json
    Log  Creating mock request and response to handle S1-U bearer notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/S1BearerSubscription    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=${appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


TC_MEC_SRV_RNIS_009_OK
    [Documentation]   TC_MEC_SRV_RNIS_009_OK
    ...  Check that the RNIS service sends an RNIS notification about 5G NR UE measurement report if the RNIS service has an associated subscription and the event is generated
    ...  ETSI GS MEC 012 2.1.1, clause 6.4.11
    ...  Reference https://forge.etsi.org/rep/mec/gs012-rnis-api/blob/automatic_generation/RniAPI.yaml
    Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    ${json}=    Get File    schemas/NrMeasRepUeSubscription.schema.json
    Log  Creating mock request and response to handle UE Measurement notification
    &{req}=    Create Mock Request Matcher    POST    ${callback_endpoint}/meas_rep_ue    body_type="JSON_SCHEMA"    body=${json}
    &{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    &{rsp}=    Create Mock Response    headers=&{appjson_hdrs}    status_code=204
    Create Mock Expectation    ${req}    ${rsp}
    Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    Log  Verifying results
    Verify Mock Expectation    ${req}
    Log  Cleaning the endpoint
    Clear Requests    ${callback_endpoint}


# TC_MEC_SRV_RNIS_010_OK
    # [Documentation]   TC_MEC_SRV_RNIS_010_OK
    # ...  Check that the RNIS service sends an RNIS notification on subscription expiration if the RNIS service has an associated subscription and the event is generated
    # ...  ETSI GS MEC 012 2.0.4, clause 6.4.9
    # ...  Reference https://forge.etsi.org/gitlab/mec/gs012-rnis-api/blob/master/RniAPI.yaml
    # Should Be True    ${PIC_RNIS_NOTIFICATIONS} == 1
    # ${json}=    Get File    schemas/RadioNetworkInformationAPI.schema.json
    # Log  Creating mock request and response to handle UE Measurement notification
    # &{req}=    Create Mock Request Matcher    POST    ${callback_uri}${callback_endpoint}    body_type="JSON_SCHEMA"    body=${json}
    #&{appjson_hdrs}=    Create Dictionary    Content-type=application/json
    # &{rsp}=    Create Mock Response    &{appjson_hdrs}    status_code=204
    # Create Mock Expectation    ${req}    ${rsp}
    # Wait Until Keyword Succeeds    ${total_polling_time}    ${polling_interval}    Verify Mock Expectation    ${req}
    # Log  Verifying results
    # Verify Mock Expectation    ${req}
    # Log  Cleaning the endpoint
    # Clear Requests    ${callback_endpoint}

