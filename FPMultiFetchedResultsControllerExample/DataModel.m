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
