# Specifications for the Sinatra Assessment

Specs:

- [x] Use Sinatra to build the app: I required the Sinatra library and used methods such as get and post to transform this Ruby application into an application that can respond to HTTP requests.
- [x] Use ActiveRecord for storing information in a database: I used ActiveRecord, an ORM framework, by creating migrations, creating models to represent those migrations, and create associations between them via belongs_to and has_many for example.
- [x] Include more than one model class (e.g. User, Post, Category): I created two models - a User model and an Entry model.
- [x] Include at least one has_many relationship on your User model (e.g. User has_many Posts): The User model has_many entries.
- [x] Include at least one belongs_to relationship on another model (e.g. Post belongs_to User): The Entry model belongs_to a user.
- [x] Include user accounts with unique login attribute (username or email):I did this using the ActiveRecord method validates_uniqueness_of with both usernames and emails in the User class.
- [x] Ensure that the belongs_to resource has routes for Creating, Reading, Updating and Destroying: I created get, post, patch, and delete requests in the entry_app_controller, which correspond with the following view files - new.erb, entries.erb, show_entry.erb, and edit_entry.erb.
- [x] Ensure that users can't modify content created by other users: In the get request for the edit form, I ensure that the current entry's user matches the current user using an if else statement. I do the same in the delete request.
- [x] Include user input validations: I do this by conditioning the params in the post and patch requests.
- [ ] BONUS - not required - Display validation failures to user with error message (example form URL e.g. /posts/new)
- [x] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code

Confirm

- [x] You have a large number of small Git commits
- [x] Your commit messages are meaningful
- [x] You made the changes in a commit that relate to the commit message
- [x] You don't include changes in a commit that aren't related to the commit message
