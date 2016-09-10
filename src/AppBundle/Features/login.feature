Feature: Manage Users data via the RESTful API

  In order to allow a user to authenticate with the API
  As a client software developer
  I need to be able to let users log in and out


  Background:
    Given there are Users with the following details:
      | id | username | email          | password |
      | 1  | peter    | peter@test.com | testpass |
      | 2  | john     | john@test.org  | johnpass |
      | 3  | tim      | tim@blah.net   | timpass  |
    And I set header "Content-Type" with value "application/json"



  Scenario: Cannot GET Login
    When I send a "GET" request to "/login"
    Then the response code should be 405

  Scenario: User cannot Login with bad credentials
    When I send a "POST" request to "/login" with body:
      """
      {
        "username": "jimmy",
        "password": "badpass"
      }
      """
    Then the response code should be 401

  Scenario: User can Login with good credentials (username)
    When I send a "POST" request to "/login" with body:
      """
      {
        "username": "peter",
        "password": "testpass"
      }
      """
    Then the response code should be 200
     And the response should contain "token"

  Scenario: User can Login with good credentials (email)
    When I send a "POST" request to "/login" with body:
      """
      {
        "username": "peter@test.com",
        "password": "testpass"
      }
      """
    Then the response code should be 200
     And the response should contain "token"

     @tags @pending
  Scenario: User can Logout
    When I am successfully logged in with username: "peter", and password: "testpass"
     And I send a "GET" request to "/profile"
    Then the response code should be 200
    When I send a "GET" request to "/logout"
    Then the response code should be 200
    When I send a "GET" request to "/profile"
     And the response code should be 401
