# Api description: An api to find movies based on criteria

## I. General description

This api will render the restaurants located around  designed city. The user must chose the maximum distance around that city, the price range and the participant(s) to the lunch. Each of the participants has specific tastes that will influence the rendering of the api.

## II. Technical description

### Current version: 

      Version 1 is actually the one in production.

### End-points: 
  
   Production: https://movie-api-finder.herokuapp.com/api/v1/finders
   
   Locally: http://localhost:3000/api/v1/lunches
 
### Installation:  

  
    1 * launch and install the rails server with the following command:
        git clone git@github.com:pcroch/
        cd lunch-picker-api 
        yarn install && bundle install
        rails db:create db:migrate db:seed
        rails s
        
### How to fetch in short (example):  

    1 * Headers:
        Content-Type    application/json
        X-User-Email    pierre@pierre.pierre
        X-User-Token    KdapjiY6vz-sBkKmNieF
        
     This is a default user to demonstration. You can of course create your own user. Please see below.
     
    2 * Body: 
            { "lunch": {
                "localisation": "Saint gilles",
                "distance": 35000,
                "price": [1,4],
                "attendees": ["Pierre"]
               }}
       
      This is an example of a  raw body request
### Body variables:
   - Localisation:
    
          *This string indicates the geographic area to be used when searching for businesses.
          *By default the city must be in Belgium
          *It must be a string: "Arlon" or "Saint Gilles"
   
   - Distance:
      
          *Distance in meters from the search location
          *Positive integer
      
   - Price:
   
          *Pricing Range to filter the search result with: 1 = $, 2 = $$, 3 = $$$, 4 = $$$$. 
          *Positive integer between 1 and 4. If the number are the same, it will be considered as Integer.
      
  - Attendees:

          *List of people for the event. 
          *The name must be the name given in the preferences but not the email adress
    
## III. HOW TO

### Session
#### Sign-up the API
  When you sin in, you **MUST** keep somewhere the authentication_token otherwise you won't be able to sign when creating new event. It will look like this *"authentication_token": "4xxvRjtXFUPPMubjs94t"*
    
  Fetch: 
  
      curl -i -X POST                                                                                                                     \
            -H 'Content-Type      application/json'                                                                                       \
            -d '{"user": {"email":"test@example.com","password":"password", "password_confirmation":"password"}}' \
            https://api-lunch-picker.herokuapp.com//api/v1/sign_up
  Render: 
      
            {
                "messages": "Sign Up Successfully",
                "is_success": true,
                "data": {
                    "user": {
                        "id": 1,
                        "email": "test@example.com",
                        "created_at": "2021-02-26T16:33:42.743Z",
                        "updated_at": "2021-02-26T16:33:42.743Z",
                        "authentication_token": "V1J27usvpS1dJN_ULYDT"
                    }
                }
            }
### Preferences           
#### Index Action: Get list of the db
  Fetch:
            
    curl -s https://api-lunch-picker.herokuapp.com/api/v1/preferences | jq
      
  Render: 
      
      [
          {
              "id": 1,
              "name": "TestUser",
              "taste": [
                  "Italian",
                  "Lebanese",
                  "Japanese",
                  "Belgian"
              ]
          }
      ]




#### Show Action: Get a specific preference on the db
  Fetch:
  
   Where id is the id of the event. It must be an integer
   
    curl -s https://api-lunch-picker.herokuapp.com/api/v1/preferences/:id | jq
        
         
 Render:  
      When :id is equal to 1
      
         {
          "id": 1,
          "name": "TestUser",
          "taste": [
              "Italian",
              "Lebanese",
              "Japanese",
              "Belgian"
          ]
      }     


#### Create Action: create new preference for a specific user.
   You need to be *authenticated* and of course have the *authorization*. It is granted when you sign up.

Fetch: 
   
    curl -i -X POST 
        -H 'Content-Type    application/json'                                                           \
        -H 'X-User-Email    test@example.come'                                                          \
        -H 'X-User-Token    V1J27usvpS1dJN_ULYDT'                                                       \
        -d '{ "preference": {"name": "TestUser","taste": ["Italian","Lebanese","Japanese","Belgian"]} }'\ 
        https://api-lunch-picker.herokuapp.com/api/v1/preferences
Render:   
         
      {
          "id": 1,
          "name": "TestUser",
          "taste": [
              "Italian",
              "Lebanese",
              "Japanese",
              "Belgian"
          ]
      }
        
### Lunch
#### Index Action: Get of the db
  Fetch:
            
    curl -s https://api-lunch-picker.herokuapp.com/api/v1/lunches | jq
      
  Render: 
      
        {
          "id": 2,
          "localisation": "Arlon",
          "distance": 5,
          "price": [
              "1",
              "4"
          ],
          "restaurants": [
              {
                  "restaurant_name": "Da Franco's",
                  "restaurant_price": "€€€",
                  "restaurant_city": "Arlon",
                  "restaurant_category": "italian",
                  "restaurant_distance": 1826
              }
          ]
      }




#### Show Action: Get a specific event on the db
  Fetch:
  
   Where id is the id of the event. It must be an integer
   
    curl -s https://api-lunch-picker.herokuapp.com/api/v1/lunches/:id | jq
        
         
 Render:  
      
    if id: 1
    
    {
    "id": 1,
    "release": "1990",
    "movies": [
        {
            "title": "The Lord of the Rings: The Return of the King",
            "overview": "Aragorn is revealed as the heir to the ancient kings as he, Gandalf and the other members of the broken fellowship struggle to save Gondor from Sauron's forces. Meanwhile, Frodo and Sam take the ring closer to the heart of Mordor, the dark lord's realm.",
            "vote_average": "8.5"
        },
        {
            "title": "The Lord of the Rings: The Two Towers",
            "overview": "Frodo and Sam are trekking to Mordor to destroy the One Ring of Power while Gimli, Legolas and Aragorn search for the orc-captured Merry and Pippin. All along, nefarious wizard Saruman awaits the Fellowship members at the Orthanc Tower in Isengard.",
            "vote_average": "8.3"
        }
    ]
}
    

#### Create Action: create an event via a post request
   You need to be *authenticated* and of course have the *authorization*. It is granted when you sign up.

Fetch: 
   
    curl -i -X POST 
        -H 'Content-Type    application/json'                                                           \
        -H 'X-User-Email    pierre@pierre.pierre'                                                       \
        -H 'X-User-Token    KdapjiY6vz-sBkKmNieF'                                                       \
        -d '{ "finder": {"release": 2020,"duration": 190,"attendees": ["Bob"],"rating": [0,1,3, 1] } }' \
        https://movie-api-finder.herokuapp.com/api/v1/finders 
Render:   
         
         {
          "id": 200,
          "release": "2020",
          "movies": [
              {
                  "title": "Possessor Uncut",
                  "overview": "Tasya Vos, an elite corporate assassin, uses brain-implant technology to take control of other people’s bodies to terminate high profile targets. As she sinks deeper into her latest assignment, Vos becomes trapped inside a mind that threatens to obliterate her.",
                  "vote_average": "6.6"
              }
          ]
      } 
        
### B- Cross-origin resource sharing        
        
(CORS) is already setup and so the api is ready to be used in production.

### C- Caching       
        
There is cache only for two actions: Index & Show as there is no need for authentication for those actions.

The index action has a cache of 3 minutes and the Show action has a cache of 1 minute. Which means that you have to wait a while to see the change actually being seen on the json reponse.

### D- Error rendering description:

Coming soon



## III. Testing description

### A- Run the test:

      Run: bundle exec rspec 
      Alternatively run: rake
  
      It will launch the Unit testing and Integration testing

### B- Integration Testing Description
      Some testing are already setup for the finders controller and some models.
      
      More information will coming soon
      
### C- Unit Testing Description
      Some testing are already setup for some controllers and some models.
            
      Coming soon

## IV. What next?

### A- To do list

- [ ] adding an event name and searching via the name
- [ ] end descripton of test case
- [ ] creating an admin with full right to delete
- [ ] Cors testing the setup
- [ ] validation of data for duration and attendees
- [ ] Improving the rendering in index, show and create


