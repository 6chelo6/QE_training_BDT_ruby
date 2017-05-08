# Author : Igor Santa Cruz

@user
Feature: Test API user service

@smoke
Scenario: Verify if the user service is working

Given I have set a connection to application
When I send a GET request to "/user.json"
Then I expect HTTP code 200

@CRUD
Scenario: Create, Edit, Delete User
Given I have set a connection to application
When I send a POST request without Autentication to /user.json with json
"""
    {
    "Email": "testuser@emailclass.com",
    "FullName": "Test User",
    "Password": "pASswoRd123"
    }
"""

Then I expect HTTP code 200
And I expect the next fields and values on response:
"""
    {
    "Email": "testuser@emailclass.com",
    "Password": null,
    "FullName": "Test User",
    "TimeZone": 0,
    "IsProUser": false,
    "AddItemMoreExpanded": false,
    "EditDueDateMoreExpanded": false,
    "ListSortType": 0,
    "FirstDayOfWeek": 0,
    "NewTaskDueDate": -1,
    "TimeZoneId": "Pacific Standard Time"
    }
"""

Given I have the next user to use in the Authentication
    | Email                  |Password    |
    |testuser@emailclass.com | pASswoRd123|
When I send a GET request with last user credentials to "/user.json"
Then I expect HTTP code 200
And I expect the next fields and values on response:
"""
    {
    "Email": "testuser@emailclass.com",
    "Password": null,
    "FullName": "Test User",
    "TimeZone": 0,
    "IsProUser": false,
    "AddItemMoreExpanded": false,
    "EditDueDateMoreExpanded": false,
    "ListSortType": 0,
    "FirstDayOfWeek": 0,
    "NewTaskDueDate": -1,
    "TimeZoneId": "Pacific Standard Time"
    }
"""

When I send a PUT request with last user credentials to /user/0.json with json
"""
    {
    "FirstDayOfWeek": 1,
    "FullName": "Test Edited User",
    }
"""
Then I expect HTTP code 200
And I expect the next fields and values on response:
"""
    {
    "Email": "testuser@emailclass.com",
    "Password": null,
    "FullName": "Test Edited User",
    "TimeZone": 0,
    "IsProUser": false,
    "AddItemMoreExpanded": false,
    "EditDueDateMoreExpanded": false,
    "ListSortType": 0,
    "FirstDayOfWeek": 1,
    "NewTaskDueDate": -1,
    "TimeZoneId": "Pacific Standard Time"
    }
"""

When I send a DELETE request with last user credentials to "/user/0.json"
Then I expect HTTP code 200
And I expect the next fields and values on response:
"""
    {
    "Email": "testuser@emailclass.com",
    "Password": null,
    "FullName": "Test Edited User",
    "TimeZone": 0,
    "IsProUser": false,
    "AddItemMoreExpanded": false,
    "EditDueDateMoreExpanded": false,
    "ListSortType": 0,
    "FirstDayOfWeek": 1,
    "NewTaskDueDate": -1,
    "TimeZoneId": "Pacific Standard Time"
    }
"""

When I send a GET request with last user credentials to "/user.json"
Then I expect HTTP code 200
And I expect JSON equal to
    """
    {
    "ErrorMessage": "Account doesn't exist",
    "ErrorCode": 105
    }
    """

Scenario Outline: User Service Negative Testing

Given I have set a connection to application
When I send a POST request without Autentication to /user.json with json
"""
    {
    "Email": "<email>",
    "FullName": "<full_name>",
    "Password": "<password>"
    }
"""

Then I expect HTTP code <code>
And I expect JSON equal to
    """
    {
    "ErrorMessage": "<ErrorMessage>",
    "ErrorCode": <ErrorCode>
    }
    """
Examples:
    | email             | full_name  |password| code|ErrorCode|ErrorMessage|
    |                   |Not Required|12345   | 200 |307      |Invalid Email Address|
    |invalidmail@notmail|Not Required|12345   | 200 |307      |Invalid Email Address|
    |testmail@mymail.com|            |123     | 200 |306      |Invalid FullName|
    |testmail@mymail.com|User1       |        | 200 |202      |Password too short|
    |user@emailclass.com|User2       |12345   | 200 |201      |Account with this email address already exists|

Scenario: Issue when try a Full Name bigger than 100 characters

Given I have set a connection to application
When I send a POST request without Autentication to /user.json with json
"""
    {
    "Email": "testuser1@emailclass.com",
    "FullName": "01234567891123456789212345678931234567894123456789512345678961234567897123456789812345678991234567891",
    "Password": "pASswoRd123"
    }
"""

Then I expect HTTP code 200
And I expect the next fields and values on response:
    """
    {
      "ErrorMessage": "Invalid input Data",
      "ErrorCode": 302
    }
    """

Given I have the next user to use in the Authentication
    | Email                  |Password    |
    |testuser1@emailclass.com | pASswoRd123|

When I send a GET request with last user credentials to "/user.json"
Then I expect HTTP code 200
And I expect JSON equal to
    """
    {
    "ErrorMessage": "Account doesn't exist",
    "ErrorCode": 105
    }
    """
