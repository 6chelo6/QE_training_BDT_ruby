@api_test
Feature: Test API create user

Scenario: Try to create a user with existing mail
	Given I have set a connection to application
	When I send a POST request to /user.json with json
	"""
	    {
	    	"Email": "use123r@email.com",
	    	"FullName": "Joe Blow",
	    	"Password": "pASswoRd"
		}
	"""
	Then I expect HTTP code 200

Scenario: Create a user with in-existing mail
	Given I have set a connection to application
	When I send a POST request to /user.json with json
	"""
	    {
	    	"Email": "tester123@email.com",
	    	"FullName": "Joe Blow",
	    	"Password": "pASswoRd"
		}
	"""
	Then I expect HTTP code 200
		And I expect JSON equal to
		"""
		{
			"ErrorMessage": "Account with this email address already exists",
			"ErrorCode": 201
			}
		""" 

Scenario: Get
	Given I have set a connection to application
	When I send a GET request to /user.json
	Then I expect HTTP code 200
