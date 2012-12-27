//
//  DataModel.h
//  MultiResultsController
//
//  Created by James Brotchie on 24/12/12.
//  Copyright (c) 2012 James Brotchie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Task.h"

@interface DataModel : NSObject

/** The data model's managed object context. This must be set when the
 *  DataModel is created.
 */
@property NSManagedObjectContext *managedObjectContext;

/** The singleton "main" data model */
+ (DataModel *)main;

/** Creates a new Task object within the DataModel's managed object context.
 *
 *  @param name Task name
 *  @param complete TRUE if task is complete, FALSE otherwise
 *  @param ordering An integer that generates a total ordering of tasks
 *
 *  @return A new managed Task object.
 *
 */
- (Task *)taskWithName:(NSString *)name complete:(BOOL)complete ordering:(NSInteger)ordering;
@end
