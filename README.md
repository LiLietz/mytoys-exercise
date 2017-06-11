A small try to reproduce the MyToys iOS App

# My Approach:

At first I thought about what I need for the solution:

- A Model that describes the objects, that will be shown in the menu table view.
  All 3 cases (Sections, Nodes and Links) are similar, that's why I wrote a single Model Struct, where "url", and "children" are optionals because links have no children and sections and nodes have no url.
  For the type I wrote an enumeration to keep the code clean.
  "Children" will be an array of Models, so the initializer of the Model Struct is recursiv.

- The initial view controller, which just needs a web view and a navigation bar. I put a view under the navigation bar to hide the navigation bar in the web content.
  The web view loads the "currentUrl" each time the view loads, which is the home page url of the mytoys website at the beginning, while, if a link was tapped, it is the url of the tapped link.
  The "Menu" button in the navigation bar is connected to the "tappedMenuButton" which presents a navigation controller modally.
  
- A navigation controller, which presents a new MenuTVC as root view controller and every time a node was tapped.
  The navigation bar of the navigation controller also has a "Close" button which dismisses the current view controller, so the HomePage view appears.

- The MenuTVC, which is programatically initialized and setup. If the current one is the first view controller in the "viewControllers" array of the navigation controller, the API request will be done. If it was successful, the JSON object is parsed in swift code, and converted in an array of Models which is saved as property. As the whole JSON is parsed the content of the current table view is reloaded.
  If the current MenuTVC isn't the first one, it gets an array of models as its "objects" so I just have to change the navigation item title. 

- Unit Tests for the parsing of the JSON object and most of the methods in the MenuTVC.
  I didn't write one for the "didSelectRowInSection" method because it has more to do with the UI, so maybe UITests would have more sense.

 
