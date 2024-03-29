*** Variables ***
${my_var}     my_value
@{my_list}    Apple    Banana    Orange
&{my_dict}    name=my_value1    password=my_value2

*** Test Cases ***
Exercise 7 - Variables Section
    [Tags]    variable
    Log    ${my_var}
    Log    ${my_list}
    Log   ${my_dict}
    FOR    ${item}    IN    @{my_list}
        Log   ${item}
    END
    Log  ${my_dict}[name]
    Log   ${my_dict}[password]
    FOR   ${key}    ${value}    IN    &{my_dict}
        Log Many    ${key}    ${value}
    END
    My Keyword
    
    Log      Suitvariable
    Log      Robotvariable
    Log      ProjectVariable      


*** Keywords ***
My Keyword
    Log Many    ${my_var}    ${my_list}    ${my_dict}