FPMultiFetchedResultsController
===============================

[FPMultiFetchedResultsController](https://github.com/brotchie/FPMultiFetchedResultsController/blob/master/MultiResultsController/FPMultiFetchedResultsController.h) is a [NSFetchedResultsController](http://developer.apple.com/library/ios/#documentation/CoreData/Reference/NSFetchedResultsController_Class/Reference/Reference.html) that supports multiple [NSFetchRequest](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/CoreDataFramework/Classes/NSFetchRequest_Class/NSFetchRequest.html) objects and correctly handles section and row mutations when transitioning between underlying fetch requests.

A FPMultiFetchedResultsController extends the NSFetchedResultsController interface. On inititialization a FPMultiFetchedResultsController accepts a dictionary of NSFetchRequest objects. Each NSFetchRequest is uniquely named by its key in this dictionary.
