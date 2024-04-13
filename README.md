# Atmos

## Description

Atmos is a Flutter mobile and web app designed for weather forecast. Currently, it only supports live weather (can't change the time or day of the forecast) based on
the user's location and location changing. I'm using a basic API so there are unavailable locations that may appear on the search. When they do, the user is redirected
to a 404 page and instructed to try a new location. A Google sign-in option is provided to access the app, leveraging the `google_sign_in` and `firebase` packages for seamless authentication and integration with Google services.

* You can use the web version at [Vercel](https://atmos-liveweather.vercel.app)

### About

Atmos uses the [Open Weather](https://openweathermap.org/api) APIs for forecasting and reverse geocoding and the [Open-Meteo](https://open-meteo.com/) API for location searching. The code is divided into:

* **Controllers**: Handle Google sign in and sign out
* **Models**: Data serialization to get only the data needed from JSONs returned by the API fetches 
* **Pages**: The visual pages for navigation
* **Services**: Everything needed in order to get the user's permissions, location, weather and location searchings
* **Assets**: All the animations and backgrounds used in the app

> [!TIP]
> Android, iOS and Web specifics, firebase and other config files are also included 

### Getting started

Clone the repository and run
```
    flutter pub get
```
to install the requirements, followed by 
```
    flutter devices
```
for a list of all available devices an then 
```
    flutter run -d <chrome | device_id>
```
to launch the application. Remember to substitute `device_id` for the actual ID of your desired device or run `chrome` alone in case you want to open it on Google Chrome.

### Usage

* As soon as the app launches, you will see a button to perform the Google sign in. After you complete the steps, the app will ask for your location permissions. Grant them
to see the live weather of your current location
* There are two buttons on the bottom side of the application: the right one is to search a different location and the left one is to sign out of the app. 

### Test Cases

No test is implemented yet

#### Resources

* All animations are from [Lottie Files](https://lottiefiles.com) 
* The backgrounds used are from [Free Pik](https://br.freepik.com)

> [!IMPORTANT]
> This project is my first attempt to work with Flutter. I had never used this language before nor any other mobile language. 
