#Rapidpro SMS Manager#

[Rapidpro](http://www.rapidpro.io) flows can be configured with webhooks that forward the content of sms responses to a url. 

This application runs separate from Rapidpro and is designed to receive these responses.

There are two parts: 

1. A module for visualizing the results of surveys. 
   Live demo: http://askliberia.herokuapp.com/


2. An interface for managing and responding to rumors. Live demo soon to come.


###WARNING###
This is a prototype. It is not production ready.


###The Database###

This application uses Mongodb for its database. You will need to have it installed to use it. Check out the Mongodb installation information at:

    http://docs.mongodb.org/manual/tutorial/install-mongodb-on-os-x/

###The Rumor Module###

Webhook: POST to /rumors

If you have a local instance of Rapidpro, you can test with the simulator by setting the webhook to POST to http://localhost:3000/rumors.

After logging in, visit the rumor module at /rumors (localhost:3000/rumors)

Here is a link to more about [webhooks](http://docs.rapidpro.io/#article_378174).

###Login###

This application uses Devise for a secure login to the rumor app. To create an authorized user, sign up at /users/sign_up and then use console to set the role to 'admin'.

I will probably add rails_admin for user management soon.

###The Diagram Module###
Webhook: POST to /events

Then browse to '/' to see the diagrams.

[Automatic graph layout with JointJS and Dagre](http://www.daviddurman.com/automatic-graph-layout-with-jointjs-and-dagre.html) was the basis for the diagram code. 

###Installation###

    git clone https://github.com/mikefab/rapidpro-sms-manager.git
    cd rapidpro-sms-manager
    bundle
    mv config/mongoid.yml.example config/mongoid.yml
    Start the server with: rails s
    Browse to localhost:3000/users/sign_up and create a user
    rails c
    User.first.update(role: 'admin')
    mv .env.example .env


###Heroku###

Deployment to Heroku is easy and free

Add the MongoLab Add-on.

###Tech Stack###

Rails
Mongodb
Angular.js
coffeescript & HAML


### To do###
* Tests!
* Pagination
* Rumor search
* API calls to a Rapidpro instance
* Data export
* Acts as taggable for rumors
