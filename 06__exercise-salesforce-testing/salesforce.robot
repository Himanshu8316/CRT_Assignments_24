*** Settings ***
Resource                        ../resources.robot/common.robot
Library                         QForce
Library                         QWeb
Library                         OperatingSystem
Library                         QVision
# Library                       SSHLibrary
Suite Setup                     Setup Browser
Test Teardown                   Run Keyword                 Logout
Suite Teardown                  Close All Browser Sessions

*** Variables ***
${file_to_upload}    test.pdf    # Replace 'example.pdf' with your actual file name
${upload_button_text}    Upload File    # Replace 'Upload File' with the actual text or locator of your upload button

*** Test Cases ***
Exercise 6 - Entering A Lead Tina Smith
    [tags]                      Lead                        Regression
    Appstate                    Home
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

    Picklist                    Salutation                  Ms.
    TypeText                    First Name                  Tina
    TypeText                    Last Name                   Smith
    Picklist                    Lead Status                 Working
    TypeText                    Phone                       +12234567858449             First Name
    TypeText                    Company                     Growmore                    Last Name
    TypeText                    Title                       Manager                     Address Information
    TypeText                    Email                       tina.smith@gmail.com        Rating
    TypeText                    Website                     https://www.growmore.com/

    ClickText                   Lead Source
    ClickText                   Advertisement
    ClickText                   Save                        partial_match=False
    UseModal                    Off
    Sleep                       2

    ClickText                   Details                     anchor=Activity
    VerifyText                  Ms. Tina Smith              anchor=Details
    VerifyText                  Manager                     anchor=Details
    VerifyText                  +12234567858449             anchor=Lead Status
    VerifyField                 Company                     Growmore
    VerifyField                 Website                     https://www.growmore.com/
    Log Screenshot

    ClickText                   Leads
    VerifyText                  Tina Smith
    VerifyText                  Manager
    VerifyText                  Growmore

Exercise 6 - Delete Tina Smith's Lead
    [tags]                      Lead                        Git Repo Exercise
    Appstate                    Home
    LaunchApp                   Sales
    ClickText                   Leads
    VerifyText                  Recently Viewed             timeout=120s

    Wait Until Keyword Succeeds                             1 min                       5 sec                  ClickText     Tina Smith
    ClickText                   Delete
    ClickText                   Delete
    ClickText                   Close
    Log Screenshot

Login-Logout   
    [tags]                      Exception
    Run Keyword                 Login
    Run Keyword And Ignore Error                            Verifytext                  Login
    Log To Console              Succcess

Login-Logout01                    
    [tags]                      Exception
    Run Keyword                 Login
    Run Keyword And Expect Error                            STARTS: QWebElementNotFoundError:                  Verifytext    Login

Login-Logout02                   
    [tags]                      Exception
    Run Keyword And Continue On Failure                     Fail                        This is a stupid example
    Log                         This keyword is executed

Exercise 13 - TRY / EXCEPT: Catch any exception
    [tags]                      Exception
    Run Keyword                 Login
    TRY
        Verifytext              Login
    EXCEPT
        Log                     Already Logged in
    END

Exercise 13 - TRY / EXCEPT: Catch an exception by exact message
    [tags]                      Exception
    Run Keyword                 Login
    TRY
        Verifytext              Login
    EXCEPT                      QWebElementNotFoundError: Unable to find element for locator Login in 30.0 sec
        Log To Console          Catches the exception
    END

Exercise 13 - TRY / EXCEPT: Capture the error message  
    [tags]                      Exception
    Run Keyword                 Login
    TRY
        Verifytext              Login
    EXCEPT                      AS                          ${error_message}
        Log To Console          ${error_message}
    END

Download and save SF Dasboard report02
    [Tags]                      Download
    Appstate                    Home
    ClickText                   Dashboards
    TypeText                    Search recent dashboards...                             Key Performance Indicators
    ClickText                   Key Performance Indicators                              anchor=Dashboard Name
    ClickText                   More Dashboard Actions
    ExpectFileDownload
    ClickText                   Download
    ${file_path} =              VerifyFileDownload          timeout=20s
    Log to console              File has been saved to: ${file_path}
    OpenWindow
    SwitchWindow                NEW
    Sleep                       2s
    GoTo                        file://${file_path}
    LogScreenshot
    # VerifyText                Key Performance Indicators                              timeout=2
    Move File                   ${file_path}                ${OUTPUT_DIR}
    Sleep                       2s
    @{downloads}=               List Files In Directory     ${OUTPUT_DIR}
    ${downloaded_file}=         Get From List               ${downloads}                1
    Log to console              Downloaded Filename: ${downloaded_file}
    LogScreenshot
Download and save SF Dasboard report
    [Tags]                      Download
    Appstate                    Home
    ClickText                   Dashboards
    TypeText                    Search recent dashboards...                             Key Performance Indicators
    ClickText                   Key Performance Indicators                              anchor=Dashboard Name
    ClickText                   More Dashboard Actions
    ExpectFileDownload
    ClickText                   Download
    ${file_path} =              VerifyFileDownload          timeout=20s
    Log to console              File has been saved to: ${file_path}
    IF                          "${EXECDIR}" == "/home/executor/execution"              # normal test run environment
        ${downloads_folder}=    Set Variable                /home/executor/Downloads
    ELSE                        # Live Testing environment
        ${downloads_folder}=    Set Variable                /home/services/Downloads
    END
    @{downloads}=               List Files In Directory     ${downloads_folder}
    ${downloaded_file}=         Get From List               ${downloads}                0
    Log                         Downloaded Filename: ${downloaded_file}
    OpenWindow
    SwitchWindow                NEW
    Sleep                       2s
    GoTo                        file://${EXECDIR}/../../Downloads/${downloaded_file}
    LogScreenshot
    # VerifyText                Key Performance Indicators                              timeout=2
    Move File                   ${downloads_folder}/${downloaded_file}                  ${OUTPUT_DIR}
    Sleep                       2s
    @{outputs}=                 List Files In Directory     ${OUTPUT_DIR}
    LogScreenshot

    # file:///home/services/Downloads/Key%20Performance%20Indicators.png
Download and save SF report
    [Tags]                      Download
    Appstate                    Home
    ClickText                   Reports
    ClickText                   Marketing Exec Leads by Source
    ClickText                   More Actions
    ClickText                   Export
    UseModal                    On
    ClickElement                //button[@title\="Export"]
    UseModal                    Off
    IF                          "${EXECDIR}" == "/home/executor/execution"              # normal test run environment
        ${downloads_folder}=    Set Variable                /home/executor/Downloads
    ELSE                        # Live Testing environment
        ${downloads_folder}=    Set Variable                /home/services/Downloads
    END
    @{downloads}=               List Files In Directory     ${downloads_folder}
    ${downloaded_file}=         Get From List               ${downloads}                0
    Log                         Downloaded Filename: ${downloaded_file}
    OpenWindow
    SwitchWindow                NEW
    Sleep                       2s
    GoTo                        file://${EXECDIR}/../../Downloads/${downloaded_file}
    Move File                   ${downloads_folder}/${downloaded_file}                  ${OUTPUT_DIR}
    Sleep                       2s
    @{outputs}=                 List Files In Directory     ${OUTPUT_DIR}
    LogScreenshot

    # /home/services/Downloads/Marketing Exec Leads by Source-2024-02-02-10-38-31.xlsx

Download and save SF report01
    [Tags]                      Download
    Appstate                    Home
    ClickText                   Reports
    ClickText                   Marketing Exec Leads by Source
    ClickText                   More Actions
    ClickText                   Export
    UseModal                    On
    ExpectFileDownload
    ClickElement                //button[@title\="Export"]
    ${file_path} =              VerifyFileDownload          timeout=20s
    Log to console              File has been saved to: ${file_path}
    UseModal                    Off
    IF                          "${EXECDIR}" == "/home/executor/execution"              # normal test run environment
        ${downloads_folder}=    Set Variable                /home/executor/Downloads
    ELSE                        # Live Testing environment
        ${downloads_folder}=    Set Variable                /home/services/Downloads
    END
    @{downloads}=               List Files In Directory     ${downloads_folder}
    ${downloaded_file}=         Get From List               ${downloads}                0
    Log                         Downloaded Filename: ${downloaded_file}
    OpenWindow
    SwitchWindow                NEW
    Sleep                       2s
    GoTo                        file:/${EXECDIR}/../../Downloads/${downloaded_file}
    Move File                   ${downloads_folder}/${downloaded_file}                  ${OUTPUT_DIR}
    Sleep                       2s
    @{outputs}=                 List Files In Directory     ${OUTPUT_DIR}
    LogScreenshot
    ${output_file}=             Get From List               ${outputs}                  1
    OpenWindow
    SwitchWindow                NEW
    Sleep                       2s
    GoTo                        file:/${OUTPUT_DIR}/${output_file}

Download and save SF report02_Latest
    Appstate                    Home
    ClickText                   Data
    ClickText                   Files
    UseTable                    SortTitle
    ClickCell                   r1c4
    ExpectFileDownload
    ClickText                   Download
    ${file_path} =              VerifyFileDownload          timeout=20s
    Log to console              File has been saved to: ${file_path}
    OpenWindow
    SwitchWindow                NEW
    GoTo                        file://${file_path}


    # IF                        "${EXECDIR}" == "/home/executor/execution"              # normal test run environment
    #                           ${downloads_folder}=        Set Variable                /home/executor/Downloads
    #                           ELSE                        # Live Testing environment
    #                           ${downloads_folder}=        Set Variable                /home/services/Downloads
    #                           END

    #                           #Get file name from download folder
    #                           @{downloads}=               List Files In Directory     ${downloads_folder}
    #                           ${pdf_file}=                Get From List               ${downloads}           0
    #                           Log                         PDF Filename: ${pdf_file}
    #                           #Verify on screen
    #                           # OpenWindow
    #                           # SwitchWindow              NEW
    #                           # GoTo                      file://${EXECDIR}/../../Downloads/${pdf_file}
    #                           # VerifyText                Eutelsat SA                 recognition_mode=Vision              timeout=2
    #                           # Presskey                  ${EMPTY}                    {DOWN}                 #To go on the next page of the PDF
    #                           # VerifyText                MHZ                         recognition_mode=Vision              timeout=2
    #                           # CloseWindow
    #                           # SwitchWindow              2
    # and then you could also do something like this to move it to output so it will be attached in the zip
    #                           #Moving file to Outpur dir so it will be attached to the run
    #                           Move File                   ${downloads_folder}/${pdf_file}                    ${OUTPUT_DIR}
    #                           Sleep                       2s
    #                           List Files In Directory     ${OUTPUT_DIR}
    #                           LogScreenshot

upload File
    Appstate                    Home
    ClickText                   Opportunities
    ClickText                   salesforce.com - 270 Widgets (Sample)
    ClickText                   Files (0)
    ClickText                   Add Files
    UseModal                    On
    UploadFile                  Upload Files                /test.pdf
    ClickText                   Upload Files
    UseModal                    Off
    UseModal                    On
    VerifyText                  Upload Files
    ClickText                   Done
    UseModal                    Off
    VerifyText                  test
    Log Variables                ${EXECDIR}
    Log Variables                ${CURDIR}
