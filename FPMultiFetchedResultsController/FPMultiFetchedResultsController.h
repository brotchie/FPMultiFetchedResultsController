/*
 The MIT License
 
 Copyright (c) 2012 James Brotchie <brotchie@gmail.com>
 
 Permission is hereby granted, free of charge, to any person obtaining
 a copy of this software and associated documentation files (the
 "Software"), to deal in the Software without restriction, including
 without limitation the rights to use, copy, modify, merge, publish,
 distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to
 the following conditions:
 
 The above copyright notice and this permission notice shall be
 included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
 LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
 OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
 WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/** FPMultiFetchedResultsController is a NSFetchedResultsController that 
 *  supports multiple NSFetchRequest and correctly handles section and 
 *  row mutations when transitioning between underlying fetch requests.
 * 
 *  A FPMultiFetchedResultsController extends the NSFetchedResultsController
 *  interface. On inititialization a FPMultiFetchedResultsController accepts a 
 *  dictionary of NSFetchRequest objects. Each NSFetchRequest is uniquely named
 *  by its key in this dictionary.
 *
 */
@interface FPMultiFetchedResultsController : NSObject {
@private
    NSDictionary *_controllers;
}

/** @name Initializing the FPMultiFetchedResultsController */

/** Initializes a FPMultiFetchedResultsController object with a set of NSFetchRequests.
 *
 *  @param fetchRequests A dictionary of (NSString *, NSFetchRequest *) pairs. Keys are
 *                       used as easy references to each NSFetchRequest.
 *  @param initialRequestName The name of the initial NSFetchRequest.
 *  @param managedObjectContext The NSManagedObjectContext used for all fetch requests.
 *  @param sectionNameKeyPath The property on fetched core data objects that defines
 *                            UITableView sections. This should be provided only if all
 *                            NSFetchRequests are sorted by this property, otherwise set
 *                            it to nil.
 * @param cacheName The name of the cache that underlying NSFetchedResultsController should use
 *                  to cache core data objects.
 */
- (id)initWithFetchRequests:(NSDictionary *)fetchRequests initialFetchRequestName:(NSString *)initialRequestName managedObjectContext: (NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName;

/** @name Transitioning between NSFetchRequests */
/** Transitions to another named fetch request from the active fetch request. If the delegate
 *  is set then appropriate didChangeSection and didChangeObject message will be sent to mutate
 *  sections and rows from the previous to the new fetch request.
 *
 *  @param toName The name of the new fetch requests as passed in a dictionary to init.
 *  @param error Output parameter that's filled with any error that occurs during the transition.
 *  @return YES if transition was successful, NO otherwise.
 *
 */
- (BOOL)transitionToFetchRequestByName:(NSString *)toName error:(NSError *__autoreleasing *)error;

/** The name of the active fetch request. */
@property (nonatomic, readonly) NSString *fetchRequestName;

/** @name NSFetchedResultsController Methods */

@property(nonatomic, assign) id< NSFetchedResultsControllerDelegate, NSObject> delegate;
@property (nonatomic, readonly) NSManagedObjectContext *managedObjectContext;
- (BOOL)performFetch:(NSError **)error;
@property (nonatomic, readonly) NSFetchRequest *fetchRequest;
@property (nonatomic, readonly) NSString *sectionNameKeyPath;
@property (nonatomic, readonly) NSString *cacheName;

+ (void)deleteCacheWithName:(NSString *)name;
@property  (nonatomic, readonly) NSArray *fetchedObjects;
- (id)objectAtIndexPath:(NSIndexPath *)indexPath;
-(NSIndexPath *)indexPathForObject:(id)object;
- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName;
@property (nonatomic, readonly) NSArray *sectionIndexTitles;
@property (nonatomic, readonly) NSArray *sections;
- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex;
@end
