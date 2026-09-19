*** Variables ***
${username_field}               //input[@id="user-name"]

${password_field}               //input[@id="password"]

${login_button}                 //input[@id="login-button"]

${login_error_msg}              //h3[text()='Epic sadface: Username and password do not match any user in this service']

${login_error_msg_cross_btn}    //button[@data-test="error-button"]