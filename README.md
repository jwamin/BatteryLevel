# BatteryLevel
watchOS project for iPhone Battery Level as Complication.

Written in Objective-C with Swift components.

# Features
* Sends current UIDevice information to WatchKit extension for use in WatchKit App and `CLKComplicationTemplateUtilitarianSmallRingText` complication.
* Simple iPhone App to show data.
* Creates ClockKit timeline for automatic update and Time Travel Features.
* Timeline will estimate based on current status. If battery is charging, images update appearance.

## TODO
* 'Good citizen' refreshing of data through use of available background APIs and lifecycle.
* Infograph complications, more complication styles in general.
* Remove forced refresh of WC data from complication controller.
* Better UI for WatchKit App
* Remove estimation since the retirement of time travel. Simply poll the iPhone once every half hour.

### Techniques Used
* WatchConnectivity techniques to send primary `AppDelegate` data to and from the AW.
* Model to store returned WC data.
* ClockKit delegation controller to return complications and timelines.
* Bridging swift class to Obj-C
* Custom Protocol to notify Complication that data is ready. `@objc protocol BatteryLevelHelperDelegate`
* Preprocessor directives to swap debug data for live data.

#### Frameworks Used
`WatchKit`
`WatchConnectivity`
`ClockKit`
