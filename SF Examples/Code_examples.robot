*** Settings ***
Library                    QVision
Library                    QForce
Library                    QWeb
Resource                   resources/common.robot
Resource                   resources/lead.robot
Suite Setup                Setup Browser
Suite Teardown             CloseAllBrowsers

*** Variables ***
# ${national_id}           343637760000
# ${street}                Stadionweg 163 3
# ${postal_code}           1076 NN
# ${city}                  AMSTERDAM
# ${sub_market}            Offices

*** Test Cases ***
 File upload
    Login
    ClickText              Opportunities
    ClickText              2024/3 - test
    #                      ClickText                   Show All
    ClickText              Files
    ClickText              Upload Files
    QVision.DoubleClick    execution
    QVision.DoubleClick    suite
    QVision.DoubleClick    regression tests
    QVision.DoubleClick    Files
    QVision.DoubleClick    testupload.pdf
    VerifyText             Upload Files
    VerifyText             1 of 1 file uploaded
    ClickText              Done

