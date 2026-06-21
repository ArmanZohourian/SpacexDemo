# SpacexDemo
// SpaceX SwiftUI App

/*
 A modern iOS app built with SwiftUI to explore SpaceX launches, mission details, and more.
 
 Features:
 - Browse Launches: View upcoming and past SpaceX launches with detailed info and images.
 - Detail View: Each launch includes mission description, date, status, images, and resource links.
 - Bookmarks: Save launches to revisit them quickly via the Bookmarks tab.
 - Search: Instantly filter launches by name.
 - Snappy Images: Efficient, smooth image loading using a custom SwiftUI caching system.
 
 Technical Highlights:
 - Modern Networking (Swift Concurrency)
   - Generic RequestManager for all API calls, using Swift's async/await for safe concurrency.
   - Decodable, type-safe requests.
   - Clean separation between networking, data parsing, and view models.
 
 - Custom SwiftUI Image Caching
   - CachedImage view provides asynchronous image loading and caching for performance.
   - Prevents redundant network requests, supports offline images, and smooth scrolling.
 
 - Architecture
   - MVVM pattern with observable view models and Combine for reactive updates.
   - Modular code: separate files for models, networking, caching, and UI.
   - Fully integrated protocol-oriented design that improves separation of concerns and follows Clean Architecture principles.
   - Data access is encapsulated behind a repository layer, keeping API and persistence concerns out of the UI and view models.
   - View models and repositories are defined through protocols, making dependencies easier to replace, mock, and test.
   - This structure makes the project more scalable, maintainable, and testable as features grow.
 
 Technologies Used:
 - SwiftUI
 - Swift Concurrency (async/await)
 - Combine
 - Custom caching for images
 - Modular, testable view models
 
 Getting Started:
 1. Clone this repository.
 2. Open in Xcode 13 or newer.
 3. Build and run on iOS 15 or later simulator or device.
 
 Credits:
 - Data provided by SpaceX public APIs.
 - Created by Arman Zohourian.
 Feel free to submit issues or contribute improvements!
 */
