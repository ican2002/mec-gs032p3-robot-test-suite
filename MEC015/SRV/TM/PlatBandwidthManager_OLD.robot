''[Documentation]   robot --outputdir ../../outputs ./PlatBandwidthManager.robot
...    Test Suite to validate Bandwidth Management API (BWA) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../pics.txt
Resource    ../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    


*** Test Cases ***
Request the list of configured bandwidth allocations
    [Documentation]   TC_MEC_SRV_BWA_001_OK
    ...  Check that the IUT responds with the list of configured bandwidth allocations when queried by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Retrieve the list of configured bandwidth allocations    ${APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}


Request the list of configured bandwidth allocations with wrong app instance id
    [Documentation]   TC_MEC_SRV_BWA_001_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Retrieve the list of configured bandwidth allocations    ${NON_EXISTENT_APP_INSTANCE_ID}
    Check HTTP Response Status Code Is    400
    #Check ProblemDetails    400


Request to register Bandwidth Management Services
    [Documentation]   TC_MEC_SRV_BWA_002_OK
    ...  Check that the IUT responds with a registration and initialisation approval for the requested bandwidth requirements sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Registration for bandwidth services    ${APP_INSTANCE_ID}    BwInfo
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}


Request to register Bandwidth Management Services using wrong parameters
    [Documentation]   TC_MEC_SRV_BWA_002_BR
    ...  Check that the IUT responds with a registration and initialisation approval for the requested bandwidth requirements sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Registration for bandwidth services    ${APP_INSTANCE_ID}    BwInfoError
    Check HTTP Response Status Code Is    400


Request for a bandwidth allocation
    [Documentation]   TC_MEC_SRV_BWA_003_OK
    ...  Check that the IUT responds with the configured bandwidth allocation when queried by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Get a bandwidth allocation    ${ALLOCATION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}


Request for a bandwidth allocation using wrong parameters
    [Documentation]   TC_MEC_SRV_BWA_003_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Get a bandwidth allocation    ${NON_EXISTENT_ALLOCATION_ID}
    Check HTTP Response Status Code Is    404


Updates the requested bandwidth requirements
    [Documentation]   TC_MEC_SRV_BWA_004_OK
    ...  Check that the IUT updates the requested bandwidth requirements when commanded by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # Preamble
    Register Bandwidth Management Service    BwInfo
    # Test body
    Update a bandwidth allocation    ${ALLOCATION_ID}    BwInfoUpdate
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}
    # Postamble
    Unregister Bandwidth Management Service    ${ALLOCATION_ID}

Updates the requested bandwidth requirements using wrong allocationDirection
    [Documentation]   TC_MEC_SRV_BWA_004_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # Preamble
    Register Bandwidth Management Service    BwInfo
    # Test body
    Update a bandwidth allocation    ${ALLOCATION_ID}    BwInfoError
    Check HTTP Response Status Code Is    400
    # Postamble
    Unregister Bandwidth Management Service    ${ALLOCATION_ID}


Updates the requested bandwidth requirements using wrong allocationId
    [Documentation]   TC_MEC_SRV_BWA_004_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Update a bandwidth allocation    ${NON_EXISTENT_ALLOCATION_ID}   BwInfoUpdate
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404


Updates the requested bandwidth requirements using wrong parameters
    [Documentation]   TC_MEC_SRV_BWA_004_PF
    ...  Check that the IUT responds with an error when a request sent by a MEC Application doesn't comply with a required condition
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # TODO Application doesn't comply with a required condition???
    # Preamble
    Register Bandwidth Management Service    BwInfo
    # Test body
    Update a bandwidth allocation with invalid ETAG    ${ALLOCATION_ID}    BwInfoUpdate
    Check HTTP Response Status Code Is    412
    # Postamble
    Unregister Bandwidth Management Service     ${ALLOCATION_ID}
    



Request for deltas changes
    [Documentation]   TC_MEC_SRV_BWA_005_OK
    ...  Check that the IUT when provided with just the changes (deltas) updates the requested bandwidth requirements when commanded by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.3
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # Preamble
    Register Bandwidth Management Service    BwInfo
    # Test body
    Request a deltas changes    ${ALLOCATION_ID}    BwInfoUpdateDelta
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   bwInfo
    Check AppInstanceId    ${APP_INSTANCE_ID}
    # Postamble
    Unregister Bandwidth Management Service    ${ALLOCATION_ID}


Request for deltas changes using invalid requestType
    [Documentation]   TC_MEC_SRV_BWA_005_BR
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.3
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # Preamble
    Register Bandwidth Management Service    BwInfo
    # Test body
    Request a deltas changes    ${ALLOCATION_ID}    BwInfoUpdateDeltaError
    Check HTTP Response Status Code Is    400
    # Postamble
    Unregister Bandwidth Management Service    ${ALLOCATION_ID}


Request for deltas changes using an unknown URI
    [Documentation]   TC_MEC_SRV_BWA_005_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.3
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Request a deltas changes    ${NON_EXISTENT_ALLOCATION_ID}    BwInfoUpdateDelta
    Check HTTP Response Status Code Is    404


Request for deltas changes using wrong parameters
    [Documentation]   TC_MEC_SRV_BWA_005_PF
    ...  Check that the IUT responds with an error when a request sent by a MEC Application doesn't comply with a required condition
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.3
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # Preamble
    Register Bandwidth Management Service    BwInfo
    # Test body
    Request a deltas changes with invalid ETAG    ${ALLOCATION_ID}    BwInfoUpdateDelta
    Check HTTP Response Status Code Is    412
    # Postamble
    Unregister Bandwidth Management Service    ${ALLOCATION_ID}


Request to unregister bandwidth Management Service
    [Documentation]   TC_MEC_SRV_BWA_006_OK
    ...  Check that the IUT unregisters from the Bandwidth Management Service when commanded by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.5
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # Preamble
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Register Bandwidth Management Service    BwInfo
    # Test body
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${ALLOCATION_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    204


Request to unregister bandwidth Management Service with wrong parameters
    [Documentation]   TC_MEC_SRV_BWA_006_NF
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V1.1.1, clause 8.3.3.5
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    # Preamble
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    # Test body
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${NON_EXISTENT_ALLOCATION_ID}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    404
    Check ProblemDetails    404


*** Keywords ***
Retrieve the list of configured bandwidth allocations
    [Arguments]    ${app_instance_id}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${app_instance_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Registration for bandwidth services
    [Arguments]    ${app_instance_id}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post     ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${app_instance_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Get a bandwidth allocation
    [Arguments]    ${allocation_id}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update a bandwidth allocation
    [Arguments]    ${allocation_id}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"If-Match":"${ETAG_VALUE}"}
    Set Headers    {"Content-Length":"0"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update a bandwidth allocation with invalid ETAG
    [Arguments]    ${allocation_id}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"If-Match":"${INVALID_ETAG}"}
    Set Headers    {"Content-Length":"0"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Put    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Request a deltas changes
    [Arguments]    ${allocation_id}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"If-Match":"${ETAG}"}
    Set Headers    {"Content-Length":"0"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Request a deltas changes with invalid ETAG
    [Arguments]    ${allocation_id}    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"If-Match":"${INVALID_ETAG}"}
    Set Headers    {"Content-Length":"0"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}



Register Bandwidth Management Service
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   BwInfo
    # Extract ETAG_VALUE
    Set Suite Variable    ${ETAG_VALUE}     ${response['status']['ETag']}
    Should Not Be Empty    ${ETAG_VALUE}
    # TODO Extract allocationId not possible, information is missing in the standard doc
    Set Suite Variable    ${ALLOCATION_ID}    ${response['body']['bwInfo']['allocationId']}
    Should Not Be Empty    ${ALLOCATION_ID}


Unregister Bandwidth Management Service
    [Arguments]    ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    204


Check AppInstanceId
    [Arguments]    ${value}
    Log    Check AppInstanceId for bwInfo element
    Should be Equal    ${response['body']['bwInfo']['appInsId']}    ${value}
    Log    AppInstanceId OK


Check AllocationId
    [Arguments]    ${value}
    Log    Check AllocationId for bwInfo element
    Should be Equal    ${response['body']['bwInfo']['fixedAllocation']}    ${value}
    Log    AllocationId OK
