# alphabetimals
How to build a tableview that takes keyboard input and displays an autocomplete list

This is a companion demo to the blog post: http://eskimona.com/objective-c/2015/03/28/autocomplete-tableview.html
and demonstrates that `reloadData` will ask the cells and their UIResponders to resign first responder.

If you subclass the related responder (in this case a UITextField) to override `resignFirstResponder`, the necessary
tableview under the hood methods will not get called and `reloadData` will not behave as expected.

There are three stages to this demo project.

# Default: tableview calls reloadData but textfield resigns first responder before any text is updated.
## Expected behavior: type one character, loads N cells, keyboard is dismissed without updating with character
![](http://eskimona.com/assets/autocomplete-reload.png)

# Click to Type: after tapping the click to type button, the `UITextField` will return `YES` instead of calling 
`resignFirstResponder`.
## Expected behavior: type as many characters as you like, loads no cells
![](http://eskimona.com/assets/autocomplete-textfield.png)

# Click on Solution: textfield is no longer in a cell in the tableview
## Expected behavior: type and see the textfield and tableview being updated
![](http://eskimona.com/assets/autocomplete-solution.png)
