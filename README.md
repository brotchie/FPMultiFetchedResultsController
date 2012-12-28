# FPMultiFetchedResultsController

[FPMultiFetchedResultsController](https://github.com/brotchie/FPMultiFetchedResultsController/blob/master/MultiResultsController/FPMultiFetchedResultsController.h) is a [NSFetchedResultsController](http://developer.apple.com/library/ios/#documentation/CoreData/Reference/NSFetchedResultsController_Class/Reference/Reference.html) that supports multiple [NSFetchRequest](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/CoreDataFramework/Classes/NSFetchRequest_Class/NSFetchRequest.html) objects and correctly handles section and row mutations when transitioning between underlying fetch requests.

A FPMultiFetchedResultsController extends the NSFetchedResultsController interface. On inititialization a FPMultiFetchedResultsController accepts a dictionary of NSFetchRequest objects. Each NSFetchRequest is uniquely named by its key in this dictionary.
## Example
Consider a `Task` `NSManagedObject` with three fields: `name`, `complete`, and `ordering`.

![TaskModel](https://raw.github.com/brotchie/FPMultiFetchedResultsController/master/img/task.png)

We will initialise a `FPMultiFetchedResultsController` with a dictionary of NSString => NSFetchRequest pairs containing distinct fetch requests for all, complete, and incomplete tasks.
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

_resultsController = [[FPMultiFetchedResultsController alloc] initWithFetchRequests:fetchRequests
    initialFetchRequestName:@"incomplete"
    managedObjectContext:self.managedObjectContext
    sectionNameKeyPath:nil cacheName:nil];
_resultsController.delegate = self;
```

After implementing the delegate methods detailed below you can animation transitions between fetch requests.

```objc
// Show all tasks.
[_resultController transitionToFetchRequestByName:@"all" error:nil];

// Show only complete tasks.
[_resultController transitionToFetchRequestByName:@"complete" error:nil];
```

During the transition the `controllerWillChangeContent:`, `controller:didChangeSection:`, `controller:didChangeObject:`, and `controllerDidChangeContent:` [NSFetchedResultsControllerDelegate](http://developer.apple.com/library/ios/#documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/Reference/Reference.html) delegate methods are called.

### NSTableViewDataSource Delegate
In your [UITableViewController](http://developer.apple.com/library/ios/#documentation/uikit/reference/UITableViewController_Class/Reference/Reference.html) subclass implement the [NSTableViewDataSource](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ApplicationKit/Protocols/NSTableDataSource_Protocol/Reference/Reference.html) interface

```objc
@implementation ExampleTableViewController {
    FPMultiFetchedResultsController *_resultsController;
}

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _resultsController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_resultsController.sections[section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"cell"];
    }
    
    Task *task = [_resultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = task.name;
    return cell;
}
```

### NSFetchedResultsController Delegate
To handle transitions between fetch requests you must implement the [NSFetchedResultsControllerDelegate](http://developer.apple.com/library/ios/#documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/Reference/Reference.html) interface in your view controller

```objc
#pragma mark - NSFetchedResultsController delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
        didChangeObject:(id)anObject
        atIndexPath:(NSIndexPath *)indexPath 
        forChangeType:(NSFetchedResultsChangeType)type
        newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath]
                            withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath
                            toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            // Do nothing when non-sorting related properties change.
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
        didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo
        atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                            withRowAnimation:UITableViewRowAnimationLeft];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}
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
    
then drag `FPMultiFetchedResultsController.h` and `FPMultiFetchedResultsController.m` from the `Submodules/FPMultiFetchedResultsController/FPMultiFetchedResultsController` subdirectory into your XCode project.
