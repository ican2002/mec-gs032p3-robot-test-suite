''[Documentation]   robot --outputdir ../../../outputs ./TrafficManagement.robot
...    Test Suite to validate Bandwidth Management API (BWA) operations.

*** Settings ***
Resource    environment/variables.txt
Resource    ../../../pics.txt
Resource    ../../../GenericKeywords.robot
Library     REST    ${SCHEMA}://${HOST}:${PORT}    ssl_verify=false
Library     OperatingSystem    


##GET on ${apiRoot}/${apiName}/${apiVersion}/bw_allocations
*** Test Cases ***
TP_MEC_MEC015_SRV_TM_001_OK
    [Documentation]
    ...  Check that the IUT responds with the list of configured bandwidth allocations when queried by a MEC Application
    ...  Reference ETSI GS MEC 015 V2.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Retrieve the list of configured bandwidth allocations
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    FOR    ${bwInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${bwInfo['appInsId']}    ${APP_INSTANCE_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}
    

TP_MEC_MEC015_SRV_TM_002_OK
    [Documentation]
    ...  Check that the IUT responds with a configured bandwidth allocation when queried by a MEC Application
    ...  Reference ETSI GS MEC 015 V2.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Retrieve the list of configured bandwidth using filter  ${CORRECT_FILTER}   ${APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    FOR    ${bwInfo}    IN    @{response['body']}
        ${passed}    Run Keyword And Return Status    Should Be Equal As Strings  ${bwInfo['appInsId']}    ${APP_INSTANCE_ID}    
        Exit For Loop If    ${passed}
    END
    Should Be True    ${passed}

TP_MEC_MEC015_SRV_TM_002_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V2.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Retrieve the list of configured bandwidth using filter  ${BAD_FILTER}   ${APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is    400

TP_MEC_MEC015_SRV_TM_002_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request with an unknown resource URI is sent by a MEC Application
    ...  Reference ETSI GS MEC 015 V2.1.1, clause 8.4.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Retrieve the list of configured bandwidth using filter  ${CORRECT_FILTER}   ${NON_EXISTENT_APP_INSTANCE_ID}  
    Check HTTP Response Status Code Is    404
 


##POST on ${apiRoot}/${apiName}/${apiVersion}/bw_allocations
TP_MEC_MEC015_SRV_TM_003_OK_01
    [Documentation]
    ...  Check that the IUT responds with a registration and initialisation approval for the requested bandwidth requirements sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Register Bandwidth Management Service Application specific  BwInfoApplicationSpecific

TP_MEC_MEC015_SRV_TM_003_OK_02
    [Documentation]
    ...  Check that the IUT responds with a registration and initialisation approval for the requested bandwidth requirements sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Register Bandwidth Management Service Session specific   BwInfoSessionSpecific
    


TP_MEC_MEC015_SRV_TM_003_BR_01
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Register Bandwidth Management Service with incorrect parameters  BwInfo_BR 
 
TP_MEC_MEC015_SRV_TM_003_BR_02
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Register Bandwidth Management Service with incorrect parameters  BwInfo_BR2
   
TP_MEC_MEC015_SRV_TM_003_BR_03
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.4.3.4
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Register Bandwidth Management Service with incorrect parameters  BwInfo_BR3
   



##GET on ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/{ALLOCATION_ID}
TP_MEC_MEC015_SRV_TM_004_OK
    [Documentation]
    ...  Check that the IUT responds with the configured bandwidth allocation when queried by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Get a bandwidth allocation   ${ALLOCATION_ID}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${APP_INSTANCE_ID}


TP_MEC_MEC015_SRV_TM_004_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.1
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    Get a bandwidth allocation   ${NON_EXISTENT_ALLOCATION_ID}
    Check HTTP Response Status Code Is    404
    

##PUT on ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/{ALLOCATION_ID}
TP_MEC_MEC015_SRV_TM_005_OK
    [Documentation]
    ...  Check that the IUT updates the requested bandwidth requirements when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    ${path}    Catenate    SEPARATOR=      jsons/     BwInfoUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update a bandwidth allocation   ${ALLOCATION_ID}    ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfo
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${json_object['appInsId']}  
    Should Be Equal As Strings  ${response['body']['fixedAllocation']}    ${json_object['fixedAllocation']}  
    Should Be Equal As Strings  ${response['body']['allocationDirection']}    ${json_object['allocationDirection']}   


TP_MEC_MEC015_SRV_TM_005_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    ${path}    Catenate    SEPARATOR=      jsons/     BwInfoUpdate_BR.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update a bandwidth allocation   ${ALLOCATION_ID}    ${body}
    Check HTTP Response Status Code Is    400


TP_MEC_MEC015_SRV_TM_005_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request sent by a MEC Application doesn't comply with a required condition
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.2
    ...  Reference https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.json
    ${path}    Catenate    SEPARATOR=      jsons/     BwInfoUpdate.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Update a bandwidth allocation   ${NON_EXISTENT_ALLOCATION_ID}    BwInfoUpdate
    Check HTTP Response Status Code Is    404


##PATCH on ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/{ALLOCATION_ID}
TP_MEC_MEC015_SRV_TM_006_OK
    [Documentation]
    ...  Check that the IUT when provided with just the changes (deltas) updates the requested bandwidth requirements when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.3
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    # Preamble
    Register Bandwidth Management Service Application specific   BwInfoApplicationSpecific
    # Test body
    ${path}    Catenate    SEPARATOR=      jsons/     BwInfoDeltas.json
    ${body}    Get File    ${path}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Request a deltas changes    ${ALLOCATION_ID}    ${body}
    Check HTTP Response Status Code Is    200
    Check HTTP Response Body Json Schema Is   BwInfoDelta
        Should Be Equal As Strings  ${response['body']['appInsId']}    ${json_object['appInsId']}  
    Should Be Equal As Strings  ${response['body']['fixedAllocation']}    ${json_object['fixedAllocation']}  
    Should Be Equal As Strings  ${response['body']['allocationDirection']}    ${json_object['allocationDirection']}   

TP_MEC_MEC015_SRV_TM_006_BR
    [Documentation]
    ...  Check that the IUT responds with an error when a request with incorrect parameters is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.3
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    # Preamble
    Register Bandwidth Management Service Application specific   BwInfoApplicationSpecific
    # Test body
    ${path}    Catenate    SEPARATOR=      jsons/     BwInfoDeltas_BR.json
    ${body}    Get File    ${path}
    Request a deltas changes    ${ALLOCATION_ID}    ${body}
    Check HTTP Response Status Code Is    400

    
TP_MEC_MEC015_SRV_TM_006_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.3
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    ${path}    Catenate    SEPARATOR=      jsons/     BwInfoDeltas_BR.json
    ${body}    Get File    ${path}
    Request a deltas changes    ${NON_EXISTENT_ALLOCATION_ID}    ${body}
    Check HTTP Response Status Code Is    400

  
##DELETE on ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/{ALLOCATION_ID}
TP_MEC_MEC015_SRV_TM_007_OK
    [Documentation]
    ...  Check that the IUT unregisters from the Bandwidth Management Service when commanded by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.5
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Unregister Bandwidth Management Service    ${ALLOCATION_ID}
    Check HTTP Response Status Code Is    204

TP_MEC_MEC015_SRV_TM_007_NF
    [Documentation]
    ...  Check that the IUT responds with an error when a request for an unknown URI is sent by a MEC Application
    ...  ETSI GS MEC 015 V2.1.1, clause 8.3.3.5
    ...  https://forge.etsi.org/rep/mec/gs015-bandwith-mgmt-api/blob/master/BwManagementApi.yaml
    Unregister Bandwidth Management Service    ${NON_EXISTENT_ALLOCATION_ID}
    Check HTTP Response Status Code Is    404
        


*** Keywords ***
Retrieve the list of configured bandwidth allocations
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    GET   ${apiRoot}/${apiName}/${apiVersion}/bw_allocations
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
   
Retrieve the list of configured bandwidth using filter
    [Arguments]    ${filter}  ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Set Headers    {"Content-Length":"0"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations?${filter}=${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
     
Retrieve a configured bandwidth allocations
    [Arguments]    ${app_instance_id}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
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
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Get    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Update a bandwidth allocation
    [Arguments]    ${allocation_id}    ${body}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Put    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Request a deltas changes
    [Arguments]    ${allocation_id}    ${body}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Patch    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${allocation_id}    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}


Register Bandwidth Management Service with incorrect parameters
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    400

Register Bandwidth Management Service Session specific
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Post    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   BwInfo
    Should Not Be Empty    ${response['headers']['Location']}
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${json_object['appInsId']}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${json_object['requestType']}
    Should Be Equal As Strings  ${response['body']['sessionFilter']}    ${json_object['sessionFilter']}
    Should Be Equal As Strings  ${response['body']['fixedAllocation']}    ${json_object['fixedAllocation']}
    Should Be Equal As Strings  ${response['body']['allocationDirection']}    ${json_object['allocationDirection']}
    
        
Register Bandwidth Management Service Application specific
    [Arguments]    ${content}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"application/json"}
    Set Headers    {"Authorization":"${TOKEN}"}
    ${file}=    Catenate    SEPARATOR=    jsons/    ${content}    .json
    ${body}=    Get File    ${file}
    Post    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations    ${body}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
    Check HTTP Response Status Code Is    201
    Check HTTP Response Body Json Schema Is   BwInfo
    ${json_object}=	Evaluate  json.loads('''${body}''')  json
    Should Not Be Empty    ${response['headers']['Location']}
    Should Be Equal As Strings  ${response['body']['appInsId']}    ${json_object['appInsId']}
    Should Be Equal As Strings  ${response['body']['requestType']}    ${json_object['requestType']}
    Should Be Equal As Strings  ${response['body']['fixedAllocation']}    ${json_object['fixedAllocation']}
    Should Be Equal As Strings  ${response['body']['allocationDirection']}    ${json_object['allocationDirection']}

   


Unregister Bandwidth Management Service
    [Arguments]    ${value}
    Should Be True    ${PIC_MEC_PLAT} == 1
    Should Be True    ${PIC_SERVICES} == 1
    Set Headers    {"Accept":"application/json"}
    Set Headers    {"Content-Type":"*/*"}
    Set Headers    {"Authorization":"${TOKEN}"}
    Delete    ${apiRoot}/${apiName}/${apiVersion}/bw_allocations/${value}
    ${output}=    Output    response
    Set Suite Variable    ${response}    ${output}
