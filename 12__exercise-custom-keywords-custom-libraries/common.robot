*** Settings ***
Library                         QWeb
Library                         QForce
Library                         String
Library                         Collections

*** Variables ***
${browser}                      chrome
${username}                     hsharma+122-fglu@force.com
${login_url}                    https://efficiency-innovation-9486.my.salesforce.com                    # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}                     ${login_url}/lightning/page/home

*** Keywords ***

##############################################################################################################################
# Step 1 - Group keywords in Custom Keywords
##############################################################################################################################

Home
    [Documentation]             Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                  2
    Run Keyword If              ${login_status}             Login                   
    ClickText                   Home
    VerifyTitle                 Home | Salesforce

Login
    [Documentation]             Login to Salesforce instance
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}                 delay=1
    TypeText                    Password                    ${password}
    Log To Console              ${password}
    ClickText                   Log In
    
    # Uncommment with Exercise 8 MFA
    # MFA is only required for unknown devices or browsers, once verified it is not asked for. 
    # To enforce MFA in your SF trial, Setup -> Identity -> Identity Verification -> Require MFA for all direct UI logins to your Salesforce org
    
    ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}         ${MY_SECRET}
    Log To Console              ${MFA_needed} # When given ${MFA_needed} is true, see Log to Console keyword result
    
    IF                          ${MFA_needed}
        ${mfa_code}=            GetOTP                      ${username}                 ${MY_SECRET}
        TypeSecret              Verification Code           ${mfa_code}
        ClickText               Verify
    END

Logout
    [Documentation]             Logout sessions
     ${loggedIn}=                isText                      View profile
    IF                          ${loggedIn}
        ClickText               View profile
        ClickText               Log Out                     partial_match=False 
        VerifyText              Log In
    END
Create Lead Step 1 Grouping
    Launch App                  Sales
    ClickText                   Leads
    ${standard_active}=         IsText                      Recently Viewed             timeout=5s             delay=2s
    IF                          "${standard_active}"=="False"
        ClickText               List View
    END
    VerifyText                  Recently Viewed             timeout=120s
    ClickText                   New                         anchor=Import
    VerifyText                  Lead Information
    UseModal                    On                          # Only find fields from open modal dialog
    Picklist                    Salutation                  Ms.                         #optional
    TypeText                    First Name                  Tina                        #optional
    TypeText                    Last Name                   Smith                       #mandatory
    Picklist                    Lead Status                 Working                     #mandatory
    TypeText                    Phone                       +12234567858449             First Name             #optional
    TypeText                    Company                     Growmore                    Industry               #mandatory
    TypeText                    Title                       Manager                     Address Information    #optional
    TypeText                    Email                       tina.smith@gmail.com        Rating                 #optional
    TypeText                    Website                     https://www.growmore.com/                          #optional
    Picklist                    Lead Source                 Advertisement               #optional
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       2

Verify Lead Step 1 Grouping
    Launch App                  Sales
    ClickText                   Leads
    ${standard_active}=         IsText                      Recently Viewed             timeout=5s             delay=2s
    IF                          "${standard_active}"=="False"
        ClickText               List View
    END
    VerifyText                  Recently Viewed             timeout=120s
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   Tina Smith 
    ClickText                   Details                     anchor=Activity
    VerifyText                  Ms. Tina Smith              anchor=Details
    VerifyText                  Manager                     anchor=Details
    VerifyText                  +12234567858449             anchor=Lead Status
    VerifyField                 Company                     Growmore
    VerifyField                 Website                     https://www.growmore.com/
    Log Screenshot

Delete Lead Step 1 Grouping
    Launch App                  Sales
    ClickText                   Leads
    ${standard_active}=         IsText                      Recently Viewed             timeout=5s             delay=2s
    IF                          "${standard_active}"=="False"
        ClickText               List View
    END
    VerifyText                  Recently Viewed             timeout=120s  
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   Tina Smith
    ClickText                   Delete
    ClickText                   Delete
    ClickText                   Close
    Log Screenshot

##############################################################################################################################
# Step 2 - Update Custom Keywords with arguments, making them generic for different test data, re-usable keywords
##############################################################################################################################

Create Lead Step 2 Replace values with arguments 
    [Arguments]                 ${lead_status}              ${last_name}                ${company}             ${salutation}=${EMPTY}      ${first_name}=${EMPTY}    ${phone}=${EMPTY}        ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}         ${lead_source}=${EMPTY}
    Launch App                  Sales
    ClickText                   Leads
    ${standard_active}=         IsText                      Recently Viewed             timeout=5s             delay=2s
    IF                          "${standard_active}"=="False"
        ClickText               List View
    END
    VerifyText                  Recently Viewed             timeout=120s
    ClickText                   New                         anchor=Import
    VerifyText                  Lead Information
    UseModal                    On                          # Only find fields from open modal dialog
    Run Keyword If              '${salutation}'!='${EMPTY}'                             Picklist               Salutation                  ${salutation}                       #optional
    Run Keyword If              '${first_name}'!='${EMPTY}'                             TypeText               First Name                  ${first_name}                      #optional
    TypeText                    Last Name                   ${last_name}                #mandatory
    Picklist                    Lead Status                 ${lead_status}              #mandatory
    Run Keyword If              '${phone}'!='${EMPTY}'      TypeText                    Phone                  ${phone}             First Name                #optional
    TypeText                    Company                     ${company}                  Last Name              #mandatory
    Run Keyword If              '${title}'!='${EMPTY}'      TypeText                    Title                  ${title}                     Address Information       #optional
    Run Keyword If              '${email}'!='${EMPTY}'      TypeText                    Email                  tina.smith@gmail.com        Rating                    #optional
    Run Keyword If              '${website}'!='${EMPTY}'    TypeText                    Website                https://www.growmore.com/                             #optional
    Run Keyword If              '${lead_source}'!='${EMPTY}'                            Picklist               Lead Source                 Advertisement             #optional
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       2

Verify Lead Step 2 Replace values with arguments
    [Arguments]                 ${lead_status}=${EMPTY}     ${last_name}=${EMPTY}       ${company}=${EMPTY}    ${salutation}=${EMPTY}      ${first_name}=${EMPTY}    ${phone}=${EMPTY}        ${title}=${EMPTY}           ${email}=${EMPTY}           ${website}=${EMPTY}         ${lead_source}=${EMPTY}
    Launch App                  Sales
    ClickText                   Leads
    ${standard_active}=         IsText                      Recently Viewed             timeout=5s             delay=2s
    IF                          "${standard_active}"=="False"
        ClickText               List View
    END
    VerifyText                  Recently Viewed             timeout=120s
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   ${first_name} ${last_name}
    ClickText                   Details                     anchor=Activity
    ${full_name}=               Catenate                    ${salutation}               ${first_name}          ${last_name}
    VerifyText                  ${full_name}                anchor=Details
    VerifyText                  ${title}                    anchor=Details
    VerifyText                  ${phone}                    anchor=Lead Status
    VerifyField                 Company                     ${company}
    VerifyField                 Website                     ${website}
    Log Screenshot

Delete Lead Step 2 Replace values with arguments
    [Arguments]                 ${first_name}               ${last_name}
    Launch App                  Sales
    ClickText                   Leads
    ${standard_active}=         IsText                      Recently Viewed             timeout=5s             delay=2s
    IF                          "${standard_active}"=="False"
        ClickText               List View
    END
    VerifyText                  Recently Viewed             timeout=120s
    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText                   ${first_name} ${last_name}
    ClickText                   Delete
    ClickText                   Delete
    ClickText                   Close
    Log Screenshot