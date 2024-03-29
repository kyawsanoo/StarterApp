# flutter starter project using bloc

This project is a bloc project using flutter_bloc package. 

## Screenshot
slide menu dark|posts with dark theme |posts with light theme
:--:|:--:|:--:
<img src="images/menu_dark.jpg" width="250px" />|<img src="images/post_list_dark.jpg" width="250px" />|<img src="images/post_list_light.jpg" width="250px"/>
 
## The app include 
- ThemeBloc for switching the entire app's theme Light or Dark
- Locale Bloc for the entire app's translation English or Myanmar
- Login Bloc for user login
- Sign Up Bloc for user sign up
- Post List Cubit for getting user post
- Post Detail Cubit for getting user post detail 
- Navigation Drawer Bloc
- NotificationBloc for Inbox message using firebase FCM 
- Sqlite for inbox message offline storage
- Form validation
- Controls http success and error response
- Store theme info, user data, language in preference


### The app use the test Apis for backend
- For Authorization, [reqres.in] (https://reqres.in/)
- For getting posts, [jsonplaceholder] (https://jsonplaceholder.typicode.com/)


#### Packages usaged
- [flutter_bloc package](https://pub.dev/packages/flutter_bloc) for state management
- [http](https://pub.dev/packages/http) for http calls
- [formz](https://pub.dev/packages/formz) for form validations
- [equatable](https://pub.dev/packages/equatable) for comparing objects
- [shared_preferences](https://pub.dev/packages/shared_preferences) for user session preference


