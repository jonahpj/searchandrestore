Feature: Create Show
  As an admin
  In order to present information about an artist
  I should be able to create an artist

  Background:
    Given I am logged in as an admin user
    And a venue exists
    And an artist exists
    And an instrument exists
    When I go to the new admin show page

  Scenario: Admin creates show
    Given I fill in the new show form with valid attributes
    And I press "Create Show"
    Then I should see "Show was successfully created"

  Scenario: Admin creates search and restore show
    Given I fill in the new show form with valid attributes
    And I check "Search and restore"
    And I press "Create Show"
    Then I should see "Show was successfully created"
    And the show should be a search and restore show

  Scenario: Admin creates featured show
    Given I fill in the new show form with valid attributes
    And I check "Featured"
    And I press "Create Show"
    Then I should see "Show was successfully created"
    And the show should be featured

  Scenario: Admin creates show with performance by existing artist with existing instrument
    Given I fill in the new show form with valid attributes
    And I select the artist name from "Artist"
    And I select the instrument name from "Instrument"
    And I press "Create Show"
    Then I should see "Show was successfully created"
    And the show should have one performance for the artist and the instrument

  Scenario: Admin creates show with performance by new artist with existing instrument
    Given I fill in the new show form with valid attributes
    And I fill in "Add a New Artist" with "Frank Zappa"
    And I select the instrument name from "Instrument"
    And I press "Create Show"
    Then I should see "Show was successfully created"
    And the show should have one performance for the artist "Frank Zappa" and the instrument

  Scenario: Admin creates show with performance by existing artist with new instrument
    Given I fill in the new show form with valid attributes
    And I select the artist name from "Artist"
    And I fill in "Add a New Instrument" with "Trombone" within "#show_performances_attributes_0_instrument_attributes_name_input"
    And I press "Create Show"
    Then I should see "Show was successfully created"
    And the show should have one performance for the artist and the instrument "trombone"

  Scenario: Admin creates show with performance by new artist with new instrument
    Given I fill in the new show form with valid attributes
    And I fill in "Add a New Artist" with "Frank Zappa"
    And I fill in "Add a New Instrument" with "Trombone" within "#show_performances_attributes_0_instrument_attributes_name_input"
    And I press "Create Show"
    Then I should see "Show was successfully created"
    And the show should have one performance for the artist "Frank Zappa" and the instrument "trombone"

