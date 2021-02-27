# Api description: An api to find restaurants based on criteria

## I. General description

This api will render the restaurants located around  designed city. The user must chose the maximum distance around that city, the price range and the participant(s) to the lunch. Each of the participants has specific tastes that will influence the rendering of the api.

## II. Technical description

### Current version: 

      Version 1 is actually the one in production.

### End-points: 
  
   Production: https://api-lunch-picker.herokuapp.com/api/v1/lunches
   
   Locally: http://localhost:3000/api/v1/lunches
 
### Installation:  
  
    1 * launch and install the rails server with the following command:
        git clone git@github.com:pcroch/
        cd lunch-picker-api 
        yarn install && bundle install
        rails db:drop db:create db:migrate db:seed
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
          *It must be a string like: "Arlon" or "Saint Gilles"
   
   - Distance:
      
          *MAXIMUM distance in meters from the search location.
          *if nothing is found between the maximum distance and the localisation, the distance be will be incremented by 10
           untill we will reach 10 restaurants or the distance wil be bigger than 40 km.
          *Positive integer between 1 and 39 999.
      
   - Price:
   
          *Pricing Range to filter the search result with: 1 = $, 2 = $$, 3 = $$$, 4 = $$$$. 
          *Positive integer between 1 and 4. If the number are the same, it will be considered as Integer.
      
  - Attendees:

          *List of people for the event. 
          *The name must be the name given in the preferences but not the email address
    
## III. HOW TO

### Session
#### Sign-up the API
  When you sin in, you **MUST** keep somewhere the authentication_token otherwise you won't be able to sign when creating new event. It will look like this *"authentication_token": "4xxvRjtXFUPPMubjs94t"*
    
  Fetch: 
  
      curl -i -X POST                                                                                                                     \
            -H 'Content-Type      application/json'                                                                                       \
            -d '{"user": {"email":"test@example.com","password":"password", "password_confirmation":"password"}}'                         \
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
          
                  
          ...etc...
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
          "localisation": "Arlon",
          "distance": "5",
          "price": [
              "1",
              "4"
          ],
          "restaurants": [
              {
                  "restaurant_name": "Da Franco's",
                  "restaurant_price": "€€€",
                  "restaurant_city": "Arlon",
                  "restaurant_category": "italian"
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
        -d '{ "lunch": {"localisation": "Arlon","distance": 5,"price": [1,4],"attendees": ["TestUser"]}}'\
        https://api-lunch-picker.herokuapp.com/api/v1/lunches
Render:   
         
      {
          "id": 1,
          "localisation": "Arlon",
          "distance": "5",
          "price": [
              "1",
              "4"
          ],
          "restaurants": [
              {
                  "restaurant_name": "Da Franco's",
                  "restaurant_price": "€€€",
                  "restaurant_city": "Arlon",
                  "restaurant_category": "italian"
              }
          ]
      } 
        
### B- Cross-origin resource sharing        
        
Coming soon

### C- Caching       
        
There is cache only for two actions: Index & Show as there is no need for authentication for those actions.


### D- Error rendering description:

Coming soon


## III. Testing description

### A- Run the test:

      Run: bundle exec rspec 
      Alternatively run: rake
  
      It will launch the Unit testing and Integration testing

### B- Integration Testing Description: 
      Some testing are already setup for the lubche controller and some models.
      
      More information will coming soon
      
### C- Unit Testing Description: 
      Some testing are already setup for some controllers and some models.
            
      Coming soon

## IV. What next?

### A- To do list

see wiki


