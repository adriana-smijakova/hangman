hangman
=======
Simple hangman web application.
To run it in your local computer you need:
Ruby  >= 1.9.3
Ruby on Rails >= 4.0.2

Next step is type these commands in directory where you have hangman 
(you can get it throughtfrom this https://github.com/adriana-smijakova/hangman/tree/fccf3260d8bc152b0df704dd96b1b8c9f6dc660c - newer version is modified for heroku):

bundle install

rake db:migrate

rake db:seed

rails server

If everything ran correctly you should be able to acces hangman website by typing
"http://localhost:3000" into your web browser.

Admin account has username (login email): "admin" and password "admin". You can change
it in application.

 


