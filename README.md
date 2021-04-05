# TMDB iOS Application

Sample iOS App using TMDB apis in Swift - https://developers.themoviedb.org/3/getting-started/introduction

## Features
- Now Playing tab
- Saved Movies tab
- Movie Detail view
- App works offline and saves previous responses in DB (using Core Data)
- Saved Movies are stored using Core Data
- Notifications on DB state change
- Search Tab - not implemented
- Deeplinks - not implemented

## Technical features
- Language: Swift
- Networking: URLSession (caching removed)
- DB Store: CoreData
- Architecture: MVVM
- Pagination
- ViewModels and ViewData for storing UI state
- Swift standard coding/decoding for custom objects

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
