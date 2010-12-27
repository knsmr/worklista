# worklista refactoring list
## ItemsController
Good

  There are error handling and various edge cases are considered.

Bad

- too many private methods in controller
DONE - @user is set multiple location
- flash[:notice] for error message
DONE - @@bitly why class variable ?  => They are instantiated every time controller is hi
- return what ?
DONE - "then" is not necessary
- No validation on item url uniqueness
- @item = Item.find(params[:id]) is duplicate
- pupulate_hatena and pupulate_retweet are not catching timeout