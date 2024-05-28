# Rick and Morty

This iOS application allows users to browse characters from the "Rick and Morty" series.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- macOS Sonoma or later
- Xcode 14.0 or later
- Swift 5.0 or later
- An active iOS device or simulator running iOS 17.4 or later

### Installation

1. **Clone the repository**
git clone https://github.com/iOSVlady/RickAndMorty.git

2. **Open the project in Xcode**

  - Open RickAndMorty.xcodeproj

3. **Run Application!**

https://github.com/iOSVlady/RickAndMorty/assets/46273878/144fcbb5-cf4c-4efc-ac8f-2fe6fac97a7d


## Assumptions and Decisions

- **Data Handling:** The application assumes a stable internet connection for fetching character data. Local caching mechanisms were not implemented to keep the focus on UI responsiveness and pagination logic.

- **Pagination:** The app uses a simple numbered page system to manage data loading. This decision was made to simplify the backend requirements and focus on front-end logic.


## Challenges and Solutions

- **Navigation with Custom Coordinator:** To manage the application's flow and navigation effectively, I implemented a custom Coordinator.

- **Pagination Logic:** Implementing seamless pagination (loading data as the user scrolls) without affecting user experience was challenging. I addressed this by refining the data fetching logic and ensuring that the `UICollectionView` updates are batched and smooth.

- **Asynchronous Data Fetching:** Handling asynchronous data updates and ensuring UI consistency was challenging. I used Combine for reactive updates, which helped in maintaining a robust and responsive application.

- **Error Handling:** Initially, error scenarios were not gracefully handled. I introduced error handling mechanisms that alert the user to issues with data fetching or network problems, improving overall app robustness.

## Future Improvements

- **Caching:** Implement local data caching to enhance performance and reduce dependency on network availability.

- **Extended Filtering:** Enhance the character filter options to include more attributes, improving user search capabilities.

- **Unit and UI Testing:** Increase test coverage to include both logic testing and user interface workflows to ensure app reliability.




