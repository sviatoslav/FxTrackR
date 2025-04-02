#  FxTrackR

## Basic Info
- Language: Swift 6  
- UI Framework: SwiftUI  
- Unit tests: Swift Testing  
- Caching/Offline: URLCache & UserDefaults  
- OS Version: iOS 15 and above  
- API: [https://openexchangerates.org](https://openexchangerates.org)

## Setup Instructions
1. Create Config.xcconfig file in repository root, use Config-example.xcconfig as a reference.
2. Update Config.xcconfig file with valid API key value for key `OPEN_EXCHANGE_RATES_API_KEY`.

## App Structure
As per requirements, the app has two screens:

### 1. Home Screen
The screen shows a list of selected assets with their currencies. The base currency is always USD.
<img src="Screenshots/1.png" width="375">  

If no assets are selected, an empty state screen is displayed.  
<img src="Screenshots/2.png" width="375">

Users can delete assets using swipe-to-delete.  
<img src="Screenshots/3.png" width="375">

As an alternative option, users can enable edit mode.  
<img src="Screenshots/4.png" width="375">

Edit mode also supports asset reordering.  
<img src="Screenshots/5.png" width="375">

### 2. Add Assets Screen
The screen displays a list of available assets. Users can add multiple assets to their list.  
<img src="Screenshots/6.png" width="375">

During loading, the app displays a loading view.  
<img src="Screenshots/7.png" width="375">

In case of a request failure, the app displays a failed state screen.  
<img src="Screenshots/8.png" width="375">

Users can use the search bar to filter assets by name or code.  
<img src="Screenshots/9.png" width="375">
