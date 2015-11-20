# alphabetimals
How to build a tableview that takes keyboard input and displays an autocomplete list

This is a companion demo to the blog post: http://eskimona.com/objective-c/2015/03/28/autocomplete-tableview.html
and demonstrates that `reloadData` will ask the cells and their UIResponders to resign first responder.

If you subclass the related responder (in this case a UITextField) to override `resignFirstResponder`, the necessary
tableview under the hood methods will not get called and `reloadData` will not behave as expected.

There are three stages to this demo project.

# Initial: `-[UITableView reloadData]` called, `-[UITextField resignFirstResponder]` called by system
## Expected behavior: user types a character into the textfield, related alphabetimal cells are loaded but the keyboard will be dismissed without updating the character in the textfield
![](http://eskimona.com/assets/autocomplete-reload.png)

# Click to Type: the `UITextField` is overriden to return `YES` instead of calling 
`resignFirstResponder`.
## Expected behavior: user types as many characters as she like, the cells will not be updated from whatever their previous state was.
![](http://eskimona.com/assets/autocomplete-textfield.png)

# Click on Solution: `UITableView` no longer contains `UITextField` in one of its cells
## Expected behavior: user types characters; the textfield will be updated with those characters and the tableview will be updated with appropriate alphabetimals that match that string
![](http://eskimona.com/assets/autocomplete-solution.png)
