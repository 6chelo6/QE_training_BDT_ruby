@items
Feature: Test todo.ly API items

  Scenario: Verify Status code 200 after getting all items for current user
    Given I have set a connection to application
    When I send a GET request to /Items.json
    Then I expect HTTP code 200

  Scenario: Verify Status code 200 after getting the root parent item
    Given I have set a connection to application
    When I send a GET request to /Items.json and keep all the items id
    And I select a random "Id" of the list as "$id"
    And I send a GET request to /Items/id/RootItem.json with "id" equal to "$id"
    Then I expect HTTP code 200

  Scenario: Verify Status code 200 after getting the root parent with /DoneRootItem as part of the endpoint
    Given I have set a connection to application
    When I send a GET request to /Items.json and keep all the items id
    And I select a random "Id" of the list as "$id"
    And I send a GET request to /Items/id/DoneRootItem.json with "id" equal to "$id"
    Then I expect HTTP code 200

  Scenario: Verify that the schema of the json response contains all keys
    Given I have set a connection to application
    When I send a GET request to /Items.json
    Then I expect HTTP code 200
    Then I expect that the json contains the following keys:
      | Id                   |
      | Content              |
      | ItemType             |
      | Checked              |
      | ProjectId            |
      | ParentId             |
      | Path                 |
      | Collapsed            |
      | DateString           |
      | DateStringPriority   |
      | DueDate              |
      | Recurrence           |
      | ItemOrder            |
      | Priority             |
      | LastSyncedDateTime   |
      | Children             |
      | DueDateTime          |
      | CreatedDate          |
      | LastCheckedDate      |
      | LastUpdatedDate      |
      | Deleted              |
      | Notes                |
      | InHistory            |
      | SyncClientCreationId |
      | DueTimeSpecified     |
      | OwnerId              |


  Scenario: Verify that an item is created with a valid json

    Given I have set a connection to application
    When I send a POST request to /Items.json with json
    """
      {
	     "Content": "New Item",
	     "ProjectId": "3644727",
	     "DueDate": ""
      }
    """
    Then I expect HTTP code 200
    And I keep the JSON response as "@last_json"
    And the JSON at "Content" should be "New Item"
    And the JSON at "ProjectId" should be 3644727
    And the JSON at "DueDate" should be ""

  Scenario: Verify that an item is returned with an existing item id
    Given I have set a connection to application
    When I send a GET request to /Items.json and keep all the items id
    And I select a random "Id" of the list as "$id"
    And I send a GET request to /Items/id/RootItem.json with "id" equal to "$id"
    Then I expect HTTP code 200

  Scenario: Verify that the name of an item is updated
    Given I have set a connection to application
    When I send a POST request to /Items.json with json
    """
      {
	     "Content": "Item to update",
	     "ProjectId": "3644727",
	     "DueDate": ""
      }
    """
    And I keep the "Id" of the response as "$id"

    And I send a PUT request to /Items/id.json with "id" equal to "$id" with a json
    """
      {
	     "Content": "Updated",
	     "ProjectId": "3644727",
	     "DueDate": ""
      }
    """
    Then I expect HTTP code 200
    And I keep the JSON response as "@last_json"
    And the JSON at "Content" should be "Updated"


  Scenario: Verify that the project id of an item is updated with method Post
    Given I have set a connection to application
    When I send a POST request to /Items.json with json
    """
      {
	     "Content": "Item to update",
	     "ProjectId": "3644727",
	     "DueDate": ""
      }
    """
    And I keep the "Id" of the response as "$id"
    And I send a POST request to /Items/id.json with "id" equal to "$id" with a json
    """
      {
	     "Content": "Item to update",
	     "ProjectId": "3644729",
	     "DueDate": ""
      }
    """
    Then I expect HTTP code 200
    And I keep the JSON response as "@last_json"
    And the JSON at "ProjectId" should be 3644729

  Scenario: Verify that an existing item is deleted
    Given I have set a connection to application
    When I send a POST request to /Items.json with json
    """
      {
	     "Content": "New Item",
	     "ProjectId": "3644727",
	     "DueDate": ""
      }
    """
    And I keep the "Id" of the response as "$id"
    And I send a DELETE request to /Items/id.json with "id" equal to "$id"
    Then I expect HTTP code 200

  Scenario Outline: Verify that a json with ErrorMessage is returned when the id is invalid
    Given I have set a connection to application
    When I send a DELETE request to /Items/id.json when "Id" is <Id>
    And I keep the JSON response as "@last_json"
    Then the JSON should be {"ErrorMessage": "Invalid Id", "ErrorCode": 301}

    Examples:
      | Id         |
      | 3030303030 |
      | 4554sdfsdf |
      | undefined  |

  Scenario: Verify that the root parent item is returned for a new item
    Given I have set a connection to application
    When I send a POST request to /Items.json with json
      """
        {
           "Content": "New Item",
           "ProjectId": "3644727",
           "DueDate": ""
        }
      """
    And I keep the "Id" of the response as "$id"
    And I send a GET request to /Items/id/RootItem.json with "id" equal to "$id"
    Then I expect HTTP code 200
