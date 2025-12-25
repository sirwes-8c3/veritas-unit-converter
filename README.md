# Veritas Converter
Converter App. Currently v0.1

# v0.1
Basic converter app with 4 pre-configured conversions, primarily intended as a demo.  The view design is intended to be modular so we can add more categories of conversions in the future

## Features
The app will have several categories of conversions
* Weight conversions
    * Gram to standard ounce
* Length
    * Centimeter to (International) Inch
* Temperature
    * Celsius to Farenheit
* Volume
    * Milliliter to Fluid Ounce

There will also be a favorite category, which is selected by the user from any existing conversion from any of the existing categories

## Views
There will only be on main view, which is separated into tabs. 

Each category will have its own tab, including the Favorite category

Each view will be laid out with 3 rows of conversions
* Left side
    * Picker that allows the user to select the unit for display on the LEFT
       * The supported values will be populated at run-time
    * Below that, a field that allows the user to enter in a decimal number (double type). If the user inputs data in the RIGHT side, then this field will display the equivalent converted value based on the RIGHT to LEFT conversion. 
        * When the user puts focus on the LEFT side input field, the RIGHT side field value will be cleared
        * If the LEFT field has focus and input, when the user hits the enter button on the system keyboard, the LEFT to RIGHT conversion will occur
* Right side 
    * Picker that allows the user to select the unit for display on the RIGHT. 
        * The supported values will be populated at run-time
    * Below that, a field that allows the user to enter in a decimal number (double type). If the user inputs data in the LEFT side, then this field will display the equivalent converted value based on the LEFT to RIGHT conversion. 
       * When the user puts focus on the RIGHT side input field, the LEFT side field value will be cleared
        * If the RIGHT field has focus and input, when the user hits the enter button on the system keyboard, the RIGHT to LEFT conversion will occur

## Data Storage
In v0.1, data storage will Swift's @AppStorage framework.  Existing supported conversions that define the category, Source Unit and Target Unit conversion will be in a JSON file included with the app.

## Technical Details

* Data storage: @AppStorage
* Testing: 
    * Plan: please propose a detailed testing strategy that allows for both unit testing and integration testing
* Tools: 
* Testing Framework: XCTest for Unit and UI Tests
* iOS support: iOS 17.0 or later
* Framework: SwiftUI with Swift 6+

## Future Features
* Add FX conversion via API
* Make categories fully dynamic (JSON-driven):
    * Currently: Adding new units to existing categories (weight, length, temperature, volume) only requires JSON changes
    * Currently: Adding new categories requires code changes in ConversionCategory enum and MainTabView
    * Enhancement: Make category names, icons, and tabs fully dynamic by loading all category metadata from JSON
    * Implementation would require: Remove ConversionCategory enum, add category metadata to JSON (name, iconName), build tabs dynamically from loaded data
