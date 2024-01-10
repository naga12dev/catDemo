# Intuit Cat Craft Demo

Intuit has started an ambitious new project: writing an app that appeals to cat lovers.

Despite being new to the team, the app is just in the beginning stages and there are a lot of different ways to contribute.  The sprint has just started so take a moment to read through this document.  Then, 

* Clone the repository
* Run the app to see how it works
* Pick a [user story](../USER_STORIES.md) and start working to make the app pur-fect.


## Technical Specs

The app uses a MVVM pattern and a single table view to show data.

A list of cat breeds is retrieved using the [Cat API](https://documenter.getpostman.com/view/5578104/RWgqUxxh) and stored in a data model, [CatModels](Cat-Demo/Data%20Models/CatModels.swift).

The [ViewModel](Cat-Demo/User%20Interface/ViewModel.swift) contains a `CatModel` and provides a delegate protocol for the [ViewController](Cat-Demo/User%20Interface/ViewController.swift) that renders the data.

When a user taps on one of the cat breeds, a pop-up window shows a image of it.

The [Networking](Cat-Demo/Networking/IntuitNetwork.swift) provides two methods:

* `fetchCatBreeds` makes a call to retrieve an array of cat breeds.
* `fetchCatDetails` uses the BreedId to retrieve an image. 
