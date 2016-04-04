## [Catchy Name Goes Here]
### Objective
[Catchy Name Goes Here] is an iOS app that displays the operating hours and location of all the UCLA libraries.

###Feature List
* display laptops available for rent and amenities
* determine and display number of people currently at library in real time
* room reservations

### Audience
The primary audience of this app is 18 - 22 year old UCLA students who frequent the libraries on a regular basis.

### Experience
User wants to go to a library to study, but doesn't know when their favorite library will be open. They click the [Catchy Name Goes Here] app icon on their iPhone and the app immediately shows a list of all libraries on-campus. The user takes a quick glance at the indicators on the right hand side and notices...

Scenario 1: that their favorite library is open. They verify the library hours for the day and head off to the library.

Scenario 2: that their favorite library is closing soon. They decide to stay home, but check the library hours for tomorrow by clicking on the specific library and scrolling through the library hours.

### Technical Requirements
#### APIs
UCLA provides several APIs that expose data, all responses are in JSON.

* To get library names, IDs, and codes, request the following: http://webservices.library.ucla.edu/libservices/units

* To get the library hours, use the libraries ID (retrieved from above request) and request the following: http://webservices.library.ucla.edu/libservices/hours/unit/<unitID>

* To get the number of laptops available at a location, request the following: http://webservices.library.ucla.edu/libservices/hours/unit/{unitID

####Third Party Frameworks
This project uses the Cocoapods dependency manager and has the following pods installed:

* AFNetworking (for making HTTP requests)
* SwiftyJSON (for parsing JSON)

#### Screens

* Library List: Lists all libraries, indicating current status (open, closing soon, closed)

* Library Display: displays detailed information regarding the selected library
