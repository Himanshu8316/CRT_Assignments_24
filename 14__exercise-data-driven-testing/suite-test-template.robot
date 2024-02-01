*** Settings ***
Resource                        ../resources/common.robot
Resource                        ../resources/leads.robot
Library                         FakerLibrary
Suite Setup                     Setup Browser
Test Setup                      Run Keywords                Home    Unique Test Data
Suite Teardown                  Close All Browser Sessions
# Test Template                   Create Verify and Delete Lead End to End

# In this exercise we use the same salesforce scenario built with exercise 6 and 12.

*** Test Cases ***
Exercise 14 - Data Driven Testing - Create Lead using Suite Test Template Unique Data 
    [Tags]    createlead        
    Create Lead    Working              ${last_name}                  ${company}       Ms.    ${first_name}

Exercise 14 - Data Driven Testing - Create Lead using Suite Test Template Fixed Data
    [Tags]    createlead
    Create Lead          Working              Smith                         Growmore       Ms.    Tina

*** Keywords ***

Create Verify and Delete Lead End to End
    [Arguments]                 ${lead_status}              ${last_name}                ${company}             ${salutation}               ${first_name}             ${phone}=${EMPTY}           ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}         ${lead_source}=${EMPTY}
    Create Lead                 ${lead_status}              ${last_name}                ${company}             ${salutation}               ${first_name}             ${phone}                    ${title}                    ${email}                    ${website}                  ${lead_source}
    Verify Lead                 ${lead_status}              ${last_name}                ${company}             ${salutation}               ${first_name}             ${phone}                    ${title}                    ${email}                    ${website}                  ${lead_source}
    Delete Lead                 ${first_name}               ${last_name}

Unique Test Data
    ${Last_Name}=               Last Name
    Set Suite Variable          ${last_name}                ${Last Name}
    ${Company}=                 Company
    Set Suite Variable          ${company}                  ${Company}
    ${First_Name}=              First Name
    Set Suite Variable          ${first_name}               ${First_Name}   