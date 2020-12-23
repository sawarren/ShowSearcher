# ShowSearcher

The application leverages MVVM, in conjunction with the coordinator pattern, 
enhancing the separation and testability of business logic.

Implementation details to note:
- requests are handled in a central location with caching (see CachedRequest.swift)
- asynchronous image loading
- view controllers are loaded from storyboards programmatically (see Storyboard.swift)
- AppCoordinator is implemented (even though there is only one screen) for extendability and clarity. 
    - In an app with multiples screens, they would delegate back to the coordinator which would control navigation

test coverage:
- Data Source + Decoding model objects from json.

If I spent more time on this, I would:
- add more tests around ShowSearchService, AppCoordinator etc.
- improve the UI of ShowInformationViewController
- add some UI tests involving / search fails & errors
