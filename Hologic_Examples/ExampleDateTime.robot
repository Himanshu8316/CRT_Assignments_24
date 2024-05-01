# Getting current date in the format m/d/yyyy
#     ${currentmonth}=            Get Current Date            result_format=%m
#     ${currentday}=              Get Current Date            result_format=%d
#     ${currentyear}=             Get Current Date            result_format=%Y
#     IF                          "${currentmonth}[0]"=="0"
#         set test variable       ${currentmonth}             ${currentmonth}[1]
#     END
#     Log To Console              ${currentday}
#     IF                          "${currentday}[0]"=="0"
#         set test variable       ${currentday}             ${currentday}[1]
#     END
#     ${currentdate}              Catenate                    ${currentmonth}/${currentday}/${currentyear}
# # Setting current date to orderreceivedate and datesigned
#     Set To Dictionary           ${informationdict}
#     ...                         orderreceivedate=${currentdate}
#     Set To Dictionary           ${orderLifecycleMetricsDict}
#     ...                         orderreceiveddate=${currentdate}
#     ...                         datesigned=${currentdate}