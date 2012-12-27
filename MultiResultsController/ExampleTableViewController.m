//
//  ExampleTableViewController.m
//  MultiResultsController
//
//  Created by James Brotchie on 27/12/12.
//  Copyright (c) 2012 James Brotchie. All rights reserved.
//

#import "ExampleTableViewController.h"
#import "DataModel.h"
#import "FPMultiFetchedResultsController.h"
#import "Task.h"

@interface ExampleTableViewController (private)
- (void)userDidEdit;
@end

@implementation ExampleTableViewController {
    FPMultiFetchedResultsController *_resultController;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        NSFetchRequest *complete = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
        complete.predicate = [NSPredicate predicateWithFormat:@"complete == TRUE"];
        complete.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"ordering" ascending:YES]];
        
        NSFetchRequest *all = [complete copy];
        all.predicate = nil;
        all.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"ordering" ascending:NO]];
        
        NSDictionary *fetchRequests = @{
            @"complete" : complete,
            @"all" : all
        };
        
        _resultController = [[FPMultiFetchedResultsController alloc] initWithFetchRequests:fetchRequests initialFetchRequestName:@"all" managedObjectContext:[DataModel main].managedObjectContext sectionNameKeyPath:@"complete" cacheName:nil];
        _resultController.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(userDidEdit)];
    self.tableView.dataSource = self;
    
    [_resultController performFetch:nil];
}

- (void)userDidEdit {
    if ([_resultController.fetchRequestName isEqualToString:@"complete"]) {
        [_resultController transitionToFetchRequestByName:@"all" error:nil];
    } else {
        [_resultController transitionToFetchRequestByName:@"complete" error:nil];
    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITableViewDataSource delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _resultController.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [_resultController.sections[section] name];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_resultController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    Task *task = [_resultController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = task.name;
    return cell;
}

#pragma mark - NSFetchedResultsController delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    switch (type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id<NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationLeft];
            break;
    }
}

@end
