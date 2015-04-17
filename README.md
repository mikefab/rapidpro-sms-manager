#Rapidpro SMS Manager#

[Rapidpro](http://www.rapidpro.io) flows can be configured with webhooks that forward the content of sms responses to a url. 

This application, developed with ruby on rails, runs separate from Rapidpro, a django app, and is designed to receive these responses. They do not need to run on the same server.

Screencast: https://youtu.be/gFLNpSZuRaM


There are two modules: 

1. A app for visualizing the results of surveys. 
   Demo: http://rapidpro-sms-manager.herokuapp.com


2. An interface for managing and responding to rumors. Demo: http://rapidpro-sms-manager.herokuapp.com/rumors


###WARNING###
- This is a prototype.
- This software was not created by the Rapidpro development team.

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

Warning: While the rumor module is password protected, the diagram module is not. I will add a password protected diagram module soon.

[Automatic graph layout with JointJS and Dagre](http://www.daviddurman.com/automatic-graph-layout-with-jointjs-and-dagre.html) was the basis for the diagram code. 

###Installation###

    git clone https://github.com/mikefab/rapidpro-sms-manager.git
    cd rapidpro-sms-manager
    bundle
    cp config/mongoid.yml.example config/mongoid.yml
    bundle exec rails s # Start the server with
    Browse to localhost:3000/users/sign_up and create a user
    bundle exec rails c
    User.first.update(role: 'admin') # User must be admin in order to see rumors
    mv .env.example .env


###Heroku###

Deployment to Heroku is free and easy:

heroku create
heroku addons:add mongolab

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
