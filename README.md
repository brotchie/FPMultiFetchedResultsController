# FPMultiFetchedResultsController

[FPMultiFetchedResultsController](https://github.com/brotchie/FPMultiFetchedResultsController/blob/master/MultiResultsController/FPMultiFetchedResultsController.h) is a [NSFetchedResultsController](http://developer.apple.com/library/ios/#documentation/CoreData/Reference/NSFetchedResultsController_Class/Reference/Reference.html) that supports multiple [NSFetchRequest](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/CoreDataFramework/Classes/NSFetchRequest_Class/NSFetchRequest.html) objects and correctly handles section and row mutations when transitioning between underlying fetch requests.

A FPMultiFetchedResultsController extends the NSFetchedResultsController interface. On inititialization a FPMultiFetchedResultsController accepts a dictionary of NSFetchRequest objects. Each NSFetchRequest is uniquely named by its key in this dictionary.

## Installing
### CocoaPod
Install and configure [CocoaPods](http://cocoapods.org/).

In the root of your project create a file named `Podfile` containing

    platform :ios, '6.0'
    xcodeproj '<# YOUR PROJECT #>.xcodeproj'
    pod 'FPMultiFetchedResultsController', :git => "https://github.com/brotchie/FPMultiFetchedResultsController.git"
    
then run

    pod install
    
### Git
Clone the `FPMultiFetchedResultsController` repostiory

    git clone https://github.com/brotchie/FPMultiFetchedResultsController.git
    
then drag `FPMultiFetchedResultsController.h` and `FPMultiFetchedResultsController.m` from the `FPMultiFetchedResultsController` subdirectory into your XCode project.

### Git Submodule
From the root of your project clone the `FPMultiFetchedResultsController` repostiory into a git submodule

    git submodule add https://github.com/brotchie/FPMultiFetchedResultsController.git Submodules/FPMultiFetchedResultsController
    git submodule update --init
    
then drag `FPMultiFetchedResultsController.h` and `FPMultiFetchedResultsController.m` from the `FPMultiFetchedResultsController` subdirectory into your XCode project.
