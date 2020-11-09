# HorizontalCalendar
Horizontal week view calendar for iOS just like apple calendar

![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)
[![Version](https://img.shields.io/cocoapods/v/PaginatedTableView.svg?style=flat)](https://cocoapods.org/pods/HorizontalCalendar)
[![License](https://img.shields.io/cocoapods/l/PaginatedTableView.svg?style=flat)](https://cocoapods.org/pods/HorizontalCalendar)
[![Platform](https://img.shields.io/cocoapods/p/PaginatedTableView.svg?style=flat)](https://cocoapods.org/pods/HorizontalCalendar)
![Country](https://img.shields.io/badge/Made%20with%20%E2%9D%A4-pakistan-green.svg)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Demo

Horizontal Calendar is a great way to show schedules for mobile apps. Mobile screens are small and minimalistic and these kind of modern designs are necessary.
This calendar is endlessly swipeable keeping the performance intact. User can select any date with ease of going back to today with a single click.
Collapse view for this calendar is also very useful to save space which can be done by single tap on date or arrow.

<br>
<img height="600" src="https://github.com/salmaanahmed/HorizontalCalendar/blob/master/Calendar.png" />
<br>

## Usage

**Step 1:** Create Calendar 🚀
```swift
  // Create horizontal calendar
  let calendar = HorizontalCalendar()
``` 
  
**Step 2:** To get callbacks for changing date, register to the callback and you will be notified on every date changed. 🤯
```swift
  // Add paginated delegates only 
  calendar.onSelectionChanged = { date in
      print(date)
  }
```
  
**Step 3:** You can change the color and apply your custom theme to the `HorizonalCalendar`. You can also change the date format. 🥰
```swift
  HorizontalCalendar.dateFormat = "EEEE, MMM d"
  HorizontalCalendar.selectedColor = .red
  HorizontalCalendar.todayColor = .teal
  HorizontalCalendar.textDark = .black
  HorizontalCalendar.textLight = .gray
  HorizontalCalendar.dateColor = .black
```
  
**Step 4:** No step 4, you're done 😎
Enjoy horizontal calendar and provide your user with great user experience.

**Step 5: Enjoy**  
Yeah! Thats all. You now have weekly calendar view with infinite scroll :heart:   
Simple, isnt it? 

## Installation

HorizontalCalendar is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'HorizontalCalendar'
```

## Author

Salmaan Ahmed, salmaan.ahmed@hotmail.com

## License

HorizontalCalendar is available under the MIT license. See the LICENSE file for more info.
