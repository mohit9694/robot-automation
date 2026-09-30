*** Settings ***
Library          Browser
Resource         ${EXECDIR}/Resources/Locators/login.resource
Resource         ${EXECDIR}/Resources/Locators/home_page.resource

*** Keywords ***
Open Website
    [Documentation]    This keyword open the website
    [Arguments]    ${browser}    ${url}
    New Browser    browser=${browser}    headless=true
    New Page    ${url}