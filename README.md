# TMDB iOS Application
<img src="https://img.shields.io/badge/status-Active-green" height="20"> <img src="https://img.shields.io/github/issues/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/github/stars/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/github/license/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/badge/architecture-MVVM-yellow" height="20"> <img src="https://img.shields.io/badge/language-Swift-yellow" height="20"> 

The Movie Database (TMDb) iOS App in Swift - https://developers.themoviedb.org/3/getting-started/introduction

## Technical specs
- Language: Swift
- Networking: URLSession
- DB Store: CoreData
- Architecture: MVVM
- Pagination
- ViewModels and ViewData for storing UI state
- Protocols for Movie list views
- Swift standard coding/decoding for custom objects

## Features
- Now Playing tab
- Saved Movies tab
- Movie Detail view
- App works offline and saves previous responses in DB (using Core Data)
- Saved Movies are stored using Core Data
- Notifications on DB state change
- Recently added saved items are shown on top
- [Nuke](https://cocoapods.org/pods/Nuke) for image fetching and caching
- Search Tab - not implemented
- Deeplinks - not implemented

## Screenshots
|Now Playing|Saved Items|Movie Detail View|
|:-:|:-:|:-:|
|<img src="/Assets/NowPlaying.png" width="250"/>|<img src="/Assets/SavedItems.png" width="250"/>|<img src="/Assets/MovieDetail.png" width="250"/>|

## Steps to build and run
- Clone repo (pod files are included)
- Open `TMDB-sample-app.xcworkspace` in XCode
  - Select Target TMDB-sample-app (pre-selected)
  - Choose simulator/device of choice
- Click on Run

## Future work
- Search Tab
- Deeplinks
- ~~Add protocols for ViewController and ViewModel communication~~
- ~~NowPlayingVC, SavedItemsVC and SearchTabVC can benefit from a common super class~~
- Modularise CoreData calls
- Modularise Network calls
