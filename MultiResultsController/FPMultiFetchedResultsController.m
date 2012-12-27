//
//  FPMultiResultsController.m
//  MultiResultsController
//
//  Created by James Brotchie on 24/12/12.
//  Copyright (c) 2012 James Brotchie. All rights reserved.
//

#import "FPMultiFetchedResultsController.h"

@interface FPMultiFetchedResultsController ()
- (NSFetchedResultsController *)activeController;
- (void)notifyDelegateOfSectionChanges:(NSFetchedResultsController *)from to:(NSFetchedResultsController *)to;
- (void)notifyDelegateOfRowChanges:(NSFetchedResultsController *)to from:(NSFetchedResultsController *)from;
@end

@implementation FPMultiFetchedResultsController

@synthesize fetchRequestName = _fetchRequestName;
@synthesize managedObjectContext = _moc;
@synthesize sectionNameKeyPath = _sectionNameKeyPath;
@synthesize cacheName = _cacheName;
@synthesize delegate = _delegate;

- (id)initWithFetchRequests:(NSDictionary *)fetchRequests initialFetchRequestName:(NSString *)initalRequestName managedObjectContext:(NSManagedObjectContext *)context sectionNameKeyPath:(NSString *)sectionNameKeyPath cacheName:(NSString *)cacheName {
    
    self = [super init];
    if (self) {
        _fetchRequestName = initalRequestName;
        _moc = context;
        _sectionNameKeyPath = sectionNameKeyPath;
        _cacheName = cacheName;
        
        NSMutableDictionary *controllers = [NSMutableDictionary dictionaryWithCapacity:fetchRequests.count];
        [fetchRequests enumerateKeysAndObjectsUsingBlock:^(NSString *name, NSFetchRequest *request, BOOL *stop) {
            controllers[name] = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:_moc sectionNameKeyPath:_sectionNameKeyPath cacheName:_cacheName];
        }];
        _controllers = [NSDictionary dictionaryWithDictionary:controllers];
    }
    return self;
}

- (void)notifyDelegateOfSectionChanges:(NSFetchedResultsController *)from to:(NSFetchedResultsController *)to {
    NSArray *fromSectionNames = [from.sections valueForKey:@"name"];
    NSArray *toSectionNames = [to.sections valueForKey:@"name"];
    NSSet *allSections = [[NSMutableSet setWithArray:fromSectionNames] setByAddingObjectsFromArray:toSectionNames];
    
    [allSections enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSUInteger fromIdx = [fromSectionNames indexOfObject:obj];
        NSUInteger toIdx = [toSectionNames indexOfObject:obj];
        if (fromIdx == NSNotFound && toIdx != NSNotFound) {
            [_delegate controller:to didChangeSection:[to.sections objectAtIndex:toIdx] atIndex:toIdx forChangeType:NSFetchedResultsChangeInsert];
        } else if (fromIdx != NSNotFound && toIdx == NSNotFound) {
            [_delegate controller:to didChangeSection:[from.sections objectAtIndex:fromIdx] atIndex:fromIdx forChangeType:NSFetchedResultsChangeDelete];
        }
    }];
}

- (void)notifyDelegateOfRowChanges:(NSFetchedResultsController *)to from:(NSFetchedResultsController *)from {
    NSSet *allItems = [[NSMutableSet setWithArray:from.fetchedObjects] setByAddingObjectsFromArray:to.fetchedObjects];
    [allItems enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        NSIndexPath *fromIdx = [from indexPathForObject:obj];
        NSIndexPath *toIdx = [to indexPathForObject:obj];
        
        if (fromIdx && toIdx && ![fromIdx isEqual:toIdx]) {
            // Move
            [_delegate controller:to didChangeObject:obj atIndexPath:fromIdx forChangeType:NSFetchedResultsChangeMove newIndexPath:toIdx];
        } else if(fromIdx && !toIdx) {
            // Delete
            [_delegate controller:to didChangeObject:obj atIndexPath:fromIdx forChangeType:NSFetchedResultsChangeDelete newIndexPath:toIdx];
        } else if(!fromIdx && toIdx) {
            // Insert
            [_delegate controller:to didChangeObject:obj atIndexPath:fromIdx forChangeType:NSFetchedResultsChangeInsert newIndexPath:toIdx];
        } else {
            // Unchanged
        }
    }];
}

- (BOOL)transitionToFetchRequestByName:(NSString *)toName error:(NSError *__autoreleasing *)error{
    NSAssert(_controllers[toName], @"Unknown fetch request name %@.", toName);
    
    NSFetchedResultsController *from = self.activeController;
    NSFetchedResultsController *to = _controllers[toName];
    _fetchRequestName = toName;
    
    // Switch the delegate from the old to the new fetched results controller.
    from.delegate = nil;
    to.delegate = _delegate;

    [to performFetch:error];
    
    if (error) {
        return NO;
    }
    
    if (_delegate ) {
        if([_delegate respondsToSelector:@selector(controllerWillChangeContent:)])
            [_delegate controllerWillChangeContent:self.activeController];
        
        if ([_delegate respondsToSelector:@selector(controller:didChangeSection:atIndex:forChangeType:)])
            [self notifyDelegateOfSectionChanges:from to:to];
        
        if ([_delegate respondsToSelector:@selector(controller:didChangeObject:atIndexPath:forChangeType:newIndexPath:)])
            [self notifyDelegateOfRowChanges:to from:from];
        
        if ([_delegate respondsToSelector:@selector(controllerDidChangeContent:)])
            [_delegate controllerDidChangeContent:self.activeController];
    }
    return YES;
}
#pragma mark - Private Methods
- (NSFetchedResultsController *)activeController {
    return _controllers[_fetchRequestName];
}

#pragma mark - NSFetchedResultsController interface

- (void)setDelegate:(id<NSFetchedResultsControllerDelegate, NSObject>)delegate {
    _delegate = delegate;
    [self.activeController setDelegate:_delegate];
}

- (BOOL)performFetch:(NSError *__autoreleasing *)error {
    return [self.activeController performFetch:error];
}

- (NSFetchRequest *)fetchRequest {
    return self.activeController.fetchRequest;
}

+ (void)deleteCacheWithName:(NSString *)name {
    [NSFetchedResultsController deleteCacheWithName:name];
}

- (NSArray *)fetchedObjects {
    return self.activeController.fetchedObjects;
}

- (id)objectAtIndexPath:(NSIndexPath *)indexPath {
    return [self.activeController objectAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForObject:(id)object {
    return [self.activeController indexPathForObject:object];
}

- (NSString *)sectionIndexTitleForSectionName:(NSString *)sectionName {
    return [self.activeController sectionIndexTitleForSectionName:sectionName];
}

- (NSArray *)sectionIndexTitles {
    return [self.activeController sectionIndexTitles];
}

- (NSArray *)sections {
    return [self.activeController sections];
}

- (NSInteger)sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)sectionIndex {
    return [self.activeController sectionForSectionIndexTitle:title atIndex:sectionIndex];
}

@end
