*** Settings ***
Documentation    This is the basic ui testcase file

Library          Browser
Resource         ${EXECDIR}/Resources/Locators/login.resource
Resource         ${EXECDIR}/Resources/Locators/home_page.resource
Variables        ${EXECDIR}/${CRED}
Test Setup      Open Website
Test Teardown   Close Browser


*** Variables ***
${CRED}                parameters.yaml
${url}                 ${fields.ui.url}
${browser}             ${fields.ui.browser}
${username}            ${fields.ui.username}
${password}            ${fields.ui.password}
${invalid_username}    name_new
${invalid_password}    123445


*** Test Cases ***
Login User With Valid Credentials
    [Documentation]    This test case will login the web with valid username and password
    [Tags]    sanity
    Fill Text    ${username_field}    ${username}
    Fill Text    ${password_field}    ${password}
    Click    ${login_button}
    Take Screenshot
    Get Element States    ${home_page_title}    contains    visible    enabled
    Get Element States    ${home_page_sort_by_dropdown}    contains    visible    enabled

Login User With Invalid Username And Password
    [Documentation]    This test case will verify login page with invalid credentials
    [Tags]    sanity
    Fill Text    ${username_field}    ${invalid_username}
    Fill Text    ${password_field}    ${invalid_password}
    Click    ${login_button}
    Get Element States    ${login_error_msg}    contains    visible
    Get Element States    ${login_error_msg_cross_btn}    contains    visible    enabled
    Click    ${login_error_msg_cross_btn}


*** Keywords ***
Open Website
    [Documentation]    This keyword open the website
    New Browser    browser=${browser}    headless=true
    New Page    ${url}
