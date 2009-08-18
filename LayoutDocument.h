//
//  LayoutDocument.h
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LayoutView.h"

@class Kitteh;

@interface LayoutDocument : NSDocument 
{
	NSMutableArray* kittehs;
	NSColor* backgroundColor;
	id delegate;
	NSUInteger selectedIndex;
}

@property (copy) NSMutableArray* kittehs;
@property NSUInteger selectedIndex;
@property id delegate;
@property (assign) NSIndexSet* selectionIndexes;

//the imageview datasource protocol
- (NSInteger)numberOfLayoutObjectsInImageView:(LayoutView*)view;
- (id <LayoutObject>)layoutObjectAtIndex:(NSUInteger)index;
- (NSColor*)backgroundColorForImageView:(LayoutView*)view;

//indexed accessors for KVC
- (NSUInteger)countOfKittehs;
- (id)objectInKittehsAtIndex:(NSUInteger)index;
- (void)insertObject:(id)anObject inKittehsAtIndex:(NSUInteger)index;
- (void)removeObjectFromKittehsAtIndex:(NSUInteger)index;
- (void)replaceObjectInKittehsAtIndex:(NSUInteger)index withObject:(id)anObject;
@end


@interface LayoutDocument (Delegate)
- (NSArrayController*)kittehController;
@end