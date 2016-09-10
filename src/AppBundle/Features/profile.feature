Feature: Manage User profile data via the RESTful API

  In order to allow a user to keep their profile information up to date
  As a client software developer
  I need to be able to let users read and update their profile


  Background:
    Given there are Users with the following details:
      | id | username | email          | password |
      | 1  | peter    | peter@test.com | testpass |
      | 2  | john     | john@test.org  | johnpass |
    And I am successfully logged in with username: "peter", and password: "testpass"
    And I set header "Content-Type" with value "application/json"


  Scenario: Can view own profile
    When I send a "GET" request to "/profile"
    Then the response code should be 200
     And the response should contain json:
      """
      {
        "id": "1",
        "username": "peter",
        "email": "peter@test.com"
      }
      """

  Scenario: Must supply current password when updating profile information
    When I send a "PUT" request to "/profile" with body:
      """
      {
        "email": "new_email@test.com"
      }
      """
    Then the response code should be 400

  Scenario: Can replace their own profile
    When I send a "PUT" request to "/profile" with body:
      """
      {
        "username": "peter",
        "email": "new_email@test.com",
        "current_password": "testpass"
      }
      """
    Then the response code should be 204
     And I send a "GET" request to "/profile"
     And the response should contain json:
      """
      {
        "id": "1",
        "username": "peter",
        "email": "new_email@test.com"
      }
      """

  Scenario: Can update their own profile
    When I send a "PATCH" request to "/profile" with body:
      """
      {
        "email": "different_email@test.com",
        "current_password": "testpass"
      }
      """
    Then the response code should be 204
    And I send a "GET" request to "/profile"
    And the response should contain json:
      """
      {
        "id": "1",
        "username": "peter",
        "email": "different_email@test.com"
      }
      """