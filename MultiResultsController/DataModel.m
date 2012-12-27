//
//  DataModel.m
//  MultiResultsController
//
//  Created by James Brotchie on 24/12/12.
//  Copyright (c) 2012 James Brotchie. All rights reserved.
//

#import "DataModel.h"

static DataModel *_instance;

@implementation DataModel
@synthesize managedObjectContext = _moc;

+ (DataModel *)main {
    if (!_instance) {
        _instance = [[DataModel alloc] init];
    }
    return _instance;
}

- (Task *)taskWithName:(NSString *)name complete:(BOOL)complete ordering:(NSInteger)ordering {
    Task *task = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:_moc];
    task.name = name;
    task.complete = [NSNumber numberWithBool:complete];
    task.ordering = [NSNumber numberWithInteger:ordering];
    
    return task;
}
@end
