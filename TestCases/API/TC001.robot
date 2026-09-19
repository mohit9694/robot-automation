*** Settings ***
Documentation    This file contains api testcases

Library            RequestsLibrary
Library            JSONLibrary
Library            OperatingSystem
Library            Collections
Variables          ${EXECDIR}/${CRED}


*** Variables ***
${CRED}                         parameters.yaml
${url}                          ${fields.api.url}
${browser}                      ${fields.api.browser}
${username}                     ${fields.api.username}
${password}                     ${fields.api.password}
${post_json_file}               Testdata/API/Post_request.json
${booking_post_request_file}    Testdata/API/Create_booking_data.json
${post_endpoint}                auth
${booking_endpoint}             booking    
${put_value}                    new_name
${value_for_patch}              sunny


*** Test Cases ***
Verify Post Request
    [Documentation]    This test case will verify booking app auth api
    [Tags]    sanity
    Session Creation    ${EMPTY}
    ${json_file}    Load Json From File    ${post_json_file}
    ${response}    POST On Session    mysession    ${post_endpoint}       json=${json_file}
    Status Should Be    200    msg=ok
    ${cookie}    Set Variable    ${response.json()}
    Set Global Variable    ${cookie}

Verify Get Request
    [Documentation]    This test case will verify booking app all booking
    [Tags]    sanity
    Session Creation    ${EMPTY}
    ${response}    GET On Session    mysession    ${booking_endpoint}
    Status Should Be    200    msg=ok
    ${booking_ids}    Set Variable    ${response.json()}
    ${booking_id}    Get Value From Json    ${booking_ids}    $.[0].bookingid
    ${booking_id}    Set Variable    ${booking_id}[0]
    Set Global Variable    ${booking_id}

Verify Get Booking Api
    [Documentation]    This test case will verify booking by id
    [Tags]    sanity
    Session Creation    ${EMPTY}
    ${response}    GET On Session    mysession    ${booking_endpoint}/${booking_id}
    Status Should Be    200    msg=ok
    ${booking_details}    Set Variable    ${response.json()}
    Set Global Variable    ${booking_details}

Verify Post Request For Create Booking
    [Documentation]    This test case will create a booking
    [Tags]    sanity
    Session Creation    ${EMPTY}
    ${response}    POST On Session    mysession    ${booking_endpoint}    json=${booking_details}
    Status Should Be    200    msg=ok
    ${booking_confirm}    Set Variable    ${response.json()}
    Set Global Variable    ${booking_confirm}

Verify Put Request For Edit Booking Details
    [Documentation]    This test case will add a new booking details
    [Tags]    sanity
    Session Creation    ${cookie}
    ${updated_details}    Update Value To Json    ${booking_details}    json_path=$.firstname    new_value=${put_value}
    ${response}    PUT On Session    mysession    ${booking_endpoint}/${booking_id}    json=${updated_details}
    Status Should Be    200    msg=ok
    ${booking_confirm_new_value}    Set Variable    ${response.json()}
    ${change_value}    Get Value From Json    ${booking_confirm_new_value}    $.firstname
    ${change_value}    Get Variable Value    ${change_value}[0]
    Should Be Equal As Strings    ${change_value}    ${put_value}

Verify Patch Request to Update Partialy
    [Documentation]    This test case will edit a booking
    [Tags]    sanity
    Session Creation    ${cookie}
    ${updated_details}    Update Value To Json    ${booking_details}    json_path=$.firstname    new_value=${value_for_patch}
    ${response}    PATCH On Session    mysession    ${booking_endpoint}/${booking_id}    json=${updated_details}
    Status Should Be    200    msg=ok
    ${booking_confirm_new_value}    Set Variable    ${response.json()}
    ${change_value}    Get Value From Json    ${booking_confirm_new_value}    $.firstname
    ${change_value}    Get Variable Value    ${change_value}[0]
    Should Be Equal As Strings    ${change_value}    ${value_for_patch}

Verify Delete Request to Delete A Booking
    [Documentation]    This test case will delete a booking by delete api
    [Tags]    sanity
    Session Creation    ${cookie}
    ${response}    DELETE On Session    mysession    ${booking_endpoint}/${booking_id}
    Status Should Be    201    msg=created

Verify Get Request to ping health check
    [Documentation]    This test case will verify website ping helth
    [Tags]    sanity
    Session Creation    ${EMPTY}
    GET On Session    mysession    ping
    Status Should Be    201    msg=created


*** Keywords ***
Session Creation
    [Documentation]    This keyword creating a session
    [Arguments]    ${cookie}
    Create Session    mysession    ${url}    cookies=${cookie}
