*** Settings ***
Library                         QWeb
Library                         QForce
Library                         String
Library                         Collections


*** Variables ***
${browser}                      chrome
${username}                     hsharma+125-hvga@force.com
${login_url}                    https://ruby-dream-6262.my.salesforce.com                    # Salesforce instance. NOTE: Should be overwritten in CRT variables
${home_url}                     ${login_url}/lightning/page/home

*** Keywords ***
Setup Browser
    Set Library Search Order    QWeb                        QForce
    Open Browser                about:blank                 ${browser}
    SetConfig                   LineBreak                   ${EMPTY}                    #\ue000
    SetConfig                   DefaultTimeout              30s                         #sometimes salesforce is slow


Close All Browser Sessions
    Close All Browsers


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

# Logout
#     [Documentation]             Logout sessions
#     ClickText     View profile
#     ClickText     Log out                     partial_match=False
#     VerifyText    Username
#     VerifyText    Password
#     VerifyText    Forgot Your Password?
    
Logout
    [Documentation]             Logout sessions
     ${loggedIn}=                isText                      View profile
    IF                          ${loggedIn}
        ClickText               View profile
        ClickText               Log Out                     partial_match=False 
        VerifyText              Log In
    END
Home
    [Documentation]             Navigate to homepage, login if needed
    GoTo                        ${home_url}
    ${login_status} =           IsText                      To access this page, you have to log in to Salesforce.                  2
    Run Keyword If              ${login_status}             Login                   
    ClickText                   Home
    VerifyTitle                 Home | Salesforce

Sales
    [Documentation]             Navigate to homepage, login if needed
    LaunchApp                   Sales
    VerifyText                  Sales


Custom Login
    [Arguments]           	${loginUrl}=${EMPTY}  ${BROWSER}=chrome  ${ORG_USERNAME}=${EMPTY}  ${ORG_PASSWORD}=${EMPTY}  ${MFA_SECRET}=${EMPTY}
    [Documentation]         This generic login keyword can be used to login from within test files. Mainly for test files to determine how to login for a specific test scenario.
    ...                     - option1: CI/CD: login directly using loginUrl of the source/destination org using sysadmin credential. Ideal for deployment tasks and login as persona.  
    ...                     - option2: CI/CD: login using loginUrl of the source/destination org but using any orgUsername, orgPassword, mfa_secret (not using sysadmin credential)
    ...                     - option3: CRT: login with local loginUrl, orgUsername and orgPassword for any user
    ${DYNAMIC_LOGIN}=       Get Variable Value          ${loginUrl}                 NoValuePassed
    IF                      '${DYNAMIC_LOGIN}' != 'NoValuePassed'
        IF    "${orgUsername}" == "${EMPTY}" and "${orgPassword}" == "${EMPTY}"
            # option 1
            Open Browser                ${DYNAMIC_LOGIN}                ${BROWSER}
        ELSE
            # option 2
            ${parts}=                   Split String      ${DYNAMIC_LOGIN}          # e.g. ${DYNAMIC_LOGIN} = 'https://xxxxx.sandbox.xxx.xxxxx.com/more/more/token
            ${base_url}=                Set Variable      ${parts[0]}//${parts[2]}  # e.g. ${parts} = ['https:', '', 'xxxxx.sandbox.xxx.xxxxx.com', 'more', 'more', '']
            Open Browser                ${base_url}       ${BROWSER}
            TypeText                    Username                    ${ORG_USERNAME}
            TypeSecret                  Password                    ${ORG_PASSWORD}
            ClickText                   Log In        
            ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}         ${MY_SECRET}
            IF                          ${MFA_needed}
                ${mfa_code}=            GetOTP                      ${username}                 ${MY_SECRET}
                TypeSecret              Verification Code           ${mfa_code}
                ClickText               Verify
            END               
        END
    ELSE
        # option3
        Open Browser                ${base_url}       ${BROWSER}
        TypeText                    Username                    ${ORG_USERNAME}
            TypeSecret                  Password                    ${ORG_PASSWORD}
            ClickText                   Log In        
            ${MFA_needed}=              Run Keyword And Return Status                           Should Not Be Equal         ${None}         ${MY_SECRET}
            IF                          ${MFA_needed}
                ${mfa_code}=            GetOTP                      ${username}                 ${MY_SECRET}
                TypeSecret              Verification Code           ${mfa_code}
                ClickText               Verify
            END               
    END

Login and Verify Code
    [Documentation]             Login to Salesforce instance
    GoTo                        ${login_url}
    TypeText                    Username                    ${username}                 delay=1
    TypeText                    Password                    ${password}
    ClickText                   Log In

    ${code_needed}=            IsText                      Verify Your Identity

    IF                         '${code_needed}' == 'True'
        Log to Console         Verify Identify Screen appeared, get email verification code and enter it
        Open Window
        Switch Window          NEW
        GoTo                   ${mailinator_url}
        ${email_count}=        Get Text Count              Verify your identity in Salesforce
        Log to Console         ${email_count}
        ClickText              Verify your identity in Salesforce                       delay=5s
        Log Screenshot
        ${email_body}=         Get Text                    //body[@marginheight\='0']
        ${code} =              Get Regexp Matches          ${email_body}           Verification Code: (......)                    1
        Log to Console         ${code}
        Switch Window          1
        Type Text              Verification Code           ${code}[0]
        Log Screenshot
        Click Text             Verify                      anchor=again
    ELSE
        Log to Console         Verify Identify Screen did not appear, continue set password
    END

    SwitchWindow                1

Login As
    [Documentation]       Login As different persona. User needs to be logged into Salesforce with Admin rights
    ...                   before calling this keyword to change persona.
    ...                   Example:
    ...                   LoginAs    Chatter Expert
    [Arguments]           ${persona}
    ClickText             Setup
    ClickText             Setup for current app
    SwitchWindow          NEW
    TypeText              Search Setup                ${persona}             delay=2
    ClickText             User                        anchor=${persona}      delay=3    # wait for list to populate, then click
    VerifyText            Freeze                      
    ClickText             Login                       anchor=Freeze          delay=1      

Logout As
    [Documentation]             Logout as specific user and closing second tab and switching to first tab.
    ${loggedIn}=                isText                      Log out as
    IF                          ${loggedIn}
        ClickText               Log out as
        VerifyText              New User
        CloseWindow
        Switchwindow            1
    END
