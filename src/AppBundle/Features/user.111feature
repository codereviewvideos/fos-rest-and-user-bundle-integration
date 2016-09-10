Feature: Manage Users data via the RESTful API

  In order to offer the User resource via an hypermedia API
  As a client software developer
  I need to be able to retrieve, create, update, and delete JSON encoded User resources


  Background:
    Given there are Users with the following details:
      | id | username | email          | password |
      | 1  | peter    | peter@test.com | testpass |
      | 2  | john     | john@test.org  | johnpass |
    And I am successfully logged in with username: "peter", and password: "testpass"
    And I set header "content-type" with value "application/json"


  Scenario: User cannot GET a Collection of User objects
    When I send a "GET" request to "/login"
    Then the response code should be 405

#
#  Scenario: User can GET their personal data by their unique ID
#    When I send a "GET" request to "/users/1"
#    Then the response code should be 200
#    And the response header "Content-Type" should be equal to "application/json; charset=utf-8"
#    And the response should contain json:
#      """
#      {
#        "id": 1,
#        "email": "peter@test.com",
#        "username": "peter"
#      }
#      """
#
#
#  Scenario: User cannot GET a different User's personal data
#    When I send a "GET" request to "/users/2"
#    Then the response code should be 403
#
#
#  Scenario: User cannot determine if another User ID is active
#    When I send a "GET" request to "/users/100"
#    Then the response code should be 403
#
#
#  Scenario: User cannot POST to the Users collection
#    When I send a "POST" request to "/users"
#    Then the response code should be 405
#
#
#  Scenario: User can PATCH to update their personal data
#    When I send a "PATCH" request to "/users/1" with body:
#      """
#      {
#        "email": "peter@something-else.net",
#        "current_password": "testpass"
#      }
#      """
#    Then the response code should be 204
#    And I send a "GET" request to "/users/1"
#    And the response should contain json:
#      """
#      {
#        "id": 1,
#        "email": "peter@something-else.net",
#        "username": "peter"
#      }
#      """
#
#
#  Scenario: User cannot PATCH without a valid password
#    When I send a "PATCH" request to "/users/1" with body:
#      """
#      {
#        "email": "peter@something-else.net",
#        "current_password": "wrong-password"
#      }
#      """
#    Then the response code should be 400
#
#
#  Scenario: User cannot PATCH a different User's personal data
#    When I send a "PATCH" request to "/users/2"
#    Then the response code should be 403
#
#
#  Scenario: User cannot PATCH a none existent User
#    When I send a "PATCH" request to "/users/100"
#    Then the response code should be 403
#
#
#  Scenario: User cannot PUT to replace their personal data
#    When I send a "PUT" request to "/users/1"
#    Then the response code should be 405
#
#
#  Scenario: User cannot PUT a different User's personal data
#    When I send a "PUT" request to "/users/2"
#    Then the response code should be 405
#
#
#  Scenario: User cannot PUT a none existent User
#    When I send a "PUT" request to "/users/100"
#    Then the response code should be 405
#
#
#  Scenario: User cannot DELETE their personal data
#    When I send a "DELETE" request to "/users/1"
#    Then the response code should be 405
#
#
#  Scenario: User cannot DELETE a different User's personal data
#    When I send a "DELETE" request to "/users/2"
#    Then the response code should be 405
#
#
#  Scenario: User cannot DELETE a none existent User
#    When I send a "DELETE" request to "/users/100"
#    Then the response code should be 405