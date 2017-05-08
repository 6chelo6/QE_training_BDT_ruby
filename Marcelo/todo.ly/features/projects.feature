# Author : Jhasmany Quiroz

@api_test @projects
Feature: Test todo.ly API Projects

Scenario: Get all projects for current user.
	Given I have set a connection to application
	When I send a GET request to /projects.json
	Then I expect HTTP code 200

Scenario: Verify that a Project is created with a valid json.
  Given I have set a connection to application
  When I send a POST request to /projects.json with json
  """
    {
     "Content": "Project Created by API",
     "Icon": "1"
    }
  """
  Then I expect HTTP code 200
  And I keep the JSON response as "@last_json"
  And the JSON at "Content" should be "Project Created by API"
  And the JSON at "Icon" should be 1
  And the JSON at "ItemsCount" should be 0

Scenario: Verify that a Project is returned with an existing project id.
  Given I have set a connection to application
  And I send a POST request to /projects.json with json
  """
    {
     "Content": "Project Created by API",
     "Icon": "3"
    }
  """
  And I keep the "Id" of the response as "$id"
  When I send a GET request to /projects/id.json with "id" equal to "$id"
  Then I expect HTTP code 200
  And I keep the JSON response as "@last_json"
  And the JSON at "Content" should be "Project Created by API"
  And the JSON at "Icon" should be 3
  And the JSON at "ItemsCount" should be 0

Scenario: Verify that the name of an project is updated
  Given I have set a connection to application
  And I send a POST request to /projects.json with json
  """
    {
     "Content": "Project Created by API",
     "Icon": "5"
    }
  """
  And I keep the "Id" of the response as "$id"
  When I send a PUT request to /projects/id.json with "id" equal to "$id" with a json
  """
    {
     "Content": "Project Updated by API",
     "Icon": "6"
    }
  """
  Then I expect HTTP code 200
  And I keep the JSON response as "@last_json"
  And the JSON at "Content" should be "Project Updated by API"
  And the JSON at "Icon" should be 6
  And the JSON at "ItemsCount" should be 0

Scenario: Verify that an existing project is deleted
  Given I have set a connection to application
  And I send a POST request to /projects.json with json
  """
    {
     "Content": "Project Deleted by API",
     "Icon": "7"
    }
  """
  And I keep the "Id" of the response as "$id"
  When I send a DELETE request to /projects/id.json with "id" equal to "$id"
  Then I expect HTTP code 200
  And I keep the JSON response as "@last_json"
  And the JSON at "Content" should be "Project Deleted by API"
  And the JSON at "Icon" should be 7
  And the JSON at "ItemsCount" should be 0

@ShowItems
Scenario: Verify that Item's list of Project is returned.
  Given I have set a connection to application
  And I send a POST request to /projects.json with json
  """
    {
     "Content": "Project Created by API",
     "Icon": "9"
    }
  """
  And I keep the "Id" of the response as "$id"
  And I send a POST request to /Items.json changing the "ProjectId" of json with "$id"
  """
    {
     "Content": "Item Created by API",
     "ProjectId": id,
     "DueDate": ""
    }
  """
  When I send a GET request to /projects/id/items.json with "id" equal to "$id"
  Then I expect HTTP code 200
  And the JSON should be an array
  And the JSON should have 1 entry
  And the JSON at "0/Content" should be "Item Created by API"
  And the JSON at "0/Checked" should be false
  And the JSON at "0/ItemType" should be 1
  And the JSON at "0/ItemOrder" should be 1

@ShowDoneItems
Scenario: Verify that list of Done items that belongs to a Project is returned.
  Given I have set a connection to application
  And I send a POST request to /projects.json with json
  """
    {
     "Content": "Project Created by API",
     "Icon": "11"
    }
  """
  And I keep the "Id" of the response as "$id"
  And I send a POST request to /Items.json changing the "ProjectId" of json with "$id"
  """
    {
     "Content": "Item Created by API",
     "ProjectId": id
    }
  """
  And I keep the "Id" of the response as "$id"
  And I send a PUT request to /Items/id.json with "id" equal to "$id" with a json
  """
    {
     "Content": "Item Updated by API",
     "Checked": "true"
    }
  """
  And I set the "project_id"
  When I send a GET request to /projects/id/doneitems.json with "id" equal to "$id"
  Then I expect HTTP code 200
  And the JSON should be an array
  And the JSON should have 1 entry
  And the JSON at "0/Content" should be "Item Updated by API"
  And the JSON at "0/Checked" should be true
  And the JSON at "0/ItemOrder" should be 1
