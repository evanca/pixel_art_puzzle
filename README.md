# Pixel Art Puzzle

This app is my submission for a Flutter Puzzle Hack Challenge.

The app idea was inspired by pixel art and the goal of the app is to take any picture and turn it into a retro-looking pixel art image. There is an option to use a random image or to upload your own.

[![Demo](https://github.com/evanca/pixel_art_puzzle/blob/master/readme/youtube.png)](https://youtu.be/xicvqi5lfv0)

## 😸 About the project

### Features
- Turning a picture into pixel art to play with
- 4 difficulty levels: Easy, Medium, Hard and Insane
- Fetching random images from Pixabay API
- Uploading and pixelating custom image
- Colorful confetti animation on puzzle complete
- Online leaderboard featuring top 10 results
- Showing user country flag via IP geolocation
- Using back button to change username / difficulty / puzzle image

### Offline support
- When image API is not responding, user can still use custom image upload and proceed to play
- When geolocation API is not responding, a random cat emoji will be used instead of a country flag
- Should there be a problem with Realtime Database, user will see a local leaderboard

### Noteworthy technologies and packages
- Responsive design is achieved via using a combination of scrolling widgets, Expanded, FittedBox as well as ResponsiveLayoutBuilder included in the starter code.
- The pixelating logic relies on the "image" Dart library.
- The online leaderboard is built with a Firebase Realtime Database with an offline support based on "streaming_shared_preferences" - a reactive key-value store for Flutter projects.
- The confetti animation is based on [this](https://stackoverflow.com/questions/67223435/how-to-create-confetti-animation-in-flutter) Stack Overflow post
- Random image generation is implemented with the help of "pixabay_picker" package.

## 😺 What's next
### Technical dept
- Refactor legacy naming, e.g. "dashatar something" should be renamed to "pixel art something"
- Add missing code description e.g. for new classes and localization strings
- Migrate rxdart classes to flutter_bloc for state management consistency
- Detect and remove unused code
- Add Android splash screen
### Potential new features
- Add privacy notice for username and country flag with sharing opt out option
- Add settings page: credits, change username / difficulty etc.
- Add username profanity filter
- Add optional pixelating function settings: number of colors, block size

## 😻 Design
I used a custom color palette and custom made pixel art icons for this game. I went for a 12x12px icon size for a nice pixelated effect.

![Colors](https://github.com/evanca/pixel_art_puzzle/blob/master/readme/design.png)

Page design is based on combining glassmorphic background elements with pixel art assets. I feel like the glassmorphic effect harmonizes the rough edges of pixelated items creating a pleasant overall look. I also use Ubuntu and Press Start 2P Google Fonts after testing out several possible font combinations for this project. Both of these fonts are "computer" style fonts which goes well with the overall game theme and at the same time they are different enough to create a good contrast. 

![Colors](https://github.com/evanca/pixel_art_puzzle/blob/master/readme/iphone.png)

There is a confetti animation to celebrate a completed puzzle.

![Animation](https://github.com/evanca/pixel_art_puzzle/blob/master/readme/animation.gif)

### References
References
## Built with
What languages, frameworks, platforms, cloud services, databases, APIs, or other technologies did you use?
## "Try it out" links
Add links where people can try your project or see your code.
## Please provide a description of your working puzzle
Description
