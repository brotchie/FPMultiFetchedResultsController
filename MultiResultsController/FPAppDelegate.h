//
//  FPAppDelegate.h
//  MultiResultsController
//
//  Created by James Brotchie on 24/12/12.
//  Copyright (c) 2012 James Brotchie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
