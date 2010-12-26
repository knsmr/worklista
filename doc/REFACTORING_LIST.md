# worklista refactoring list
## ItemsController
Good

  There are error handling and various edge cases are considered.

Bad

- too many private methods in controller
- @user is set multiple location
- flash[:notice] for error message
DONE - @@bitly why class variable ?  => They are instantiated every time controller is hi
- return what ?
- Is current_user and @user same thing?
DONE - "then" is not necessary
