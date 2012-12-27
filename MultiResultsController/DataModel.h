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
@property NSManagedObjectContext *managedObjectContext;
+ (DataModel *)main;
- (Task *)taskWithName:(NSString *)name complete:(BOOL)complete ordering:(NSInteger)ordering;
@end
