# FPMultiFetchedResultsController

[FPMultiFetchedResultsController](https://github.com/brotchie/FPMultiFetchedResultsController/blob/master/MultiResultsController/FPMultiFetchedResultsController.h) is a [NSFetchedResultsController](http://developer.apple.com/library/ios/#documentation/CoreData/Reference/NSFetchedResultsController_Class/Reference/Reference.html) that supports multiple [NSFetchRequest](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/CoreDataFramework/Classes/NSFetchRequest_Class/NSFetchRequest.html) objects and correctly handles section and row mutations when transitioning between underlying fetch requests.

A FPMultiFetchedResultsController extends the NSFetchedResultsController interface. On inititialization a FPMultiFetchedResultsController accepts a dictionary of NSFetchRequest objects. Each NSFetchRequest is uniquely named by its key in this dictionary.
## Example
Initialise the `FPMultiFetchedResultsController` with a set of NSFetchRequest objects. Here we have a `Task` managed object with three fields: `name`, `complete`, and `ordering`.

```objc
// Task objects have an ordering field that specifies the user's custom ordering.
NSSortDescriptor *sortByOrdering = [NSSortDescriptor sortDescriptorWithKey:@"ordering" ascending:YES];

// All tasks.
NSFetchRequest *requestAll = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
requestAll.sortDescriptors = @[sortByOrdering];

// Incomplete tasks.
NSFetchRequest *requestIncomplete = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
requestIncomplete.sortDescriptors = @[sortByOrdering];
requestIncomplete.predicate = [NSPredicate predicateWithFormat:@"complete == FALSE"];

// Complete tasks.
NSFetchRequest *requestComplete = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
requestComplete.sortDescriptors = @[sortByOrdering];
requestComplete.predicate = [NSPredicate predicateWithFormat:@"complete == TRUE"];

NSDictionary *fetchRequests = @{
    @"all" : requestAll,
    @"incomplete" : requestIncomplete,
    @"complete" : requestComplete
};

FPMultiFetchedResultsController *resultsController = [[FPMultiFetchedResultsController alloc] initWithFetchRequests:fetchRequests
    initialFetchRequestName:@"incomplete"
    managedObjectContext:self.managedObjectContext
    sectionNameKeyPath:nil cacheName:nil];
```

## Limitations
- If `sectionNameKeyPath` is not `nil` then all NSFetchRequest objects passed to `initWithFetchRequests:` must have identical sort descriptors.
- Calls to delegate methods `didChangeSection` and `didChangeObject` may be computationally expensive for fetch requests with a large number of results.

## Installing
### CocoaPod
Install and configure [CocoaPods](http://cocoapods.org/).

In the root of your project create a file named `Podfile` containing

    platform :ios, '6.0'
    xcodeproj '<# YOUR PROJECT #>.xcodeproj'
    pod 'FPMultiFetchedResultsController', :git => "https://github.com/brotchie/FPMultiFetchedResultsController.git"
    
then run

    pod install
    
**Note:** After running `pod install` open `<# YOUR PROJECT #>.xcworkspace` in xcode, not `<# YOUR PROJECT #>.xcodeproj`.
    
### Git
Clone the `FPMultiFetchedResultsController` repostiory

    git clone https://github.com/brotchie/FPMultiFetchedResultsController.git
    
then drag `FPMultiFetchedResultsController.h` and `FPMultiFetchedResultsController.m` from the `FPMultiFetchedResultsController` subdirectory into your XCode project.

### Git Submodule
From the root of your project clone the `FPMultiFetchedResultsController` repostiory into a git submodule

    git submodule add https://github.com/brotchie/FPMultiFetchedResultsController.git Submodules/FPMultiFetchedResultsController
    git submodule update --init
    
then drag `FPMultiFetchedResultsController.h` and `FPMultiFetchedResultsController.m` from the `FPMultiFetchedResultsController` subdirectory into your XCode project.
