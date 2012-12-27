//
//  FPMultiResultsController.h
//  MultiResultsController
//
//  Created by James Brotchie on 24/12/12.
//  Copyright (c) 2012 James Brotchie. All rights reserved.
//

#import <Foundation/Foundation.h>

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
