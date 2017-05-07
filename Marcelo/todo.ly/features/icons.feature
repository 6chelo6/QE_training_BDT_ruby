@icons
Feature: Test todo.ly API icons

  Scenario: Verify Status code 200 after getting the icon objects
    Given I have set a connection to application
    And I pick a random "Id" between 0 and 15 as "$id"
    And I send a GET request to /icons/id.json with "id" equal to "$id"
    Then I expect HTTP code 200
