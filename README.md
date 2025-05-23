# articleapp

A new Flutter project.

markdown
CopyEdit
# Flutter Article App

A Flutter app that fetches and displays a list of articles from a public
API.

## Features 
    - List of articles 
    - - Search functionality 
    - - Detail view
    - - Responsive UI

## Setup Instructions
1. Clone the repo:
   git clone https://github.com/isangeeta28/articleapp
   cd flutter_article_app

2. Install dependencies:
   flutter pub get

3. Run the app:
   flutter run

## Tech Stack -
Tech Stack

Flutter SDK: 3.19.6

State Management: BLoC – used to handle app states and business logic in a structured way

HTTP Client: http package – for making API calls to fetch articles

Persistence: shared_preferences – to locally store favorite article IDs for quick access



## State Management Explanation
I used BLoC (Business Logic Component) for state management to keep the app’s logic separate from the UI. 
It helps manage states like loading, success, and error while fetching or searching articles, 
and it also makes toggling favorites and refreshing data super clean and predictable. 
Data flows from the UI as events to the BLoC, which processes them and emits new states back to the UI to rebuild accordingly.
