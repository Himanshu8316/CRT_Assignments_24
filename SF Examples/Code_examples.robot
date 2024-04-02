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

Enrich lead
    [Tags]                 ready
    Login
    ClickText              Leads
    VerifyText             Recently Viewed
    TypeText               Search this list...         ${last_name}\n
    ClickText              ${last_name}
    VerifyText             Lead Enrichment Status      partial_match=True
    VerifyElement          //img[@alt\="Lead Enrichement To Do"]
    ClickText              Lead Enrichment             anchor=Details
    ClickElement           //button[text()\="Enrich Lead"]
    sleep                  10s
    UseTable               Choose a Row to Select
    ${colcount}            Get Col Header Count
    @{col}                 Get Col Header
    FOR                    ${j}                        IN RANGE                 1               ${colcount}
        IF                 "${col}[${j}]"== "Provider status"
            BREAK
        END
    END
    ${row}                 Get Table Row               //last
    FOR                    ${i}                        IN RANGE                 1               ${row}
        ${cellvalue}       GetCellText                 r${i}c${j}
        IF                 "${cellvalue}"== "active"
            BREAK
        END
    END
    ${street}              GetCellText                 r${i}c${3}
    ${postal_code}         GetCellText                 r${i}c${4}
    ${city}                GetCellText                 r${i}c${5}
    ${national_id}         GetCellText                 r${i}c${8}
    ${sub_market}          GetCellText                 r${i}c${10}
    Log To Console         ${street}
    Log To Console         ${postal_code}
    Log To Console         ${city}
    Log To Console         ${national_id}
    Log To Console         ${sub_market}
    ClickCell              r${i}c1
    ClickElement           //button[text()\="Update"]
    VerifyText             Lead Enrichment
    VerifyText             You will not be able to select another record after validation. Your choice is the final selection.
    ClickElement           //button[text()\="Validate"]
    RefreshPage
    VerifyText             Lead Enrichment Status      partial_match=True
    VerifyElement          //img[@alt\="Lead Enriched"]
    Verifytext             ${sub_market}               anchor=SubMarket
    Verifytext             ${national_id}              anchor=National Id
    Verifytext             ${street}                   anchor=Address
    Verifytext             ${city}                     anchor=Address
    Verifytext             ${national_id}              anchor=Address
    VerifyElement          //*[@data-name\="Unqualified"]//a[@aria-current\="true"]
    VerifyElement          //*[@data-name\="Qualified"]//a[@aria-current\="false"]
    VerifyElement          //*[@data-name\="Waiting"]//a[@aria-current\="false"]
    VerifyElement          //*[@data-name\="Closed - Not Converted"]//a[@aria-current\="false"]
    VerifyElement          //*[@data-name\="converted"]//a[@aria-current\="false"]

