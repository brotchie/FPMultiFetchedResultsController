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
