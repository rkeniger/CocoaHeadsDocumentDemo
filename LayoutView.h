//
//  ImageView.h
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LayoutView;

//in order for an object to be drawn, it must provide a position and an image
@protocol LayoutObject
@property NSPoint position;
- (NSImage*)image;
- (BOOL)hitTest:(NSPoint)point;
@end

@interface LayoutView : NSView 
{
	id dataSource;
	NSUInteger selectedObjectIndex;
	NSPoint currentMousePoint;
}
@property NSUInteger selectedObjectIndex;
@property IBOutlet id dataSource;
@end

//any object that want to be the source of the content needs to conform to this informal protocol
@interface LayoutView (Datasource)
- (NSUInteger)numberOfLayoutObjectsInImageView:(LayoutView*)view;
- (id <LayoutObject>)layoutObjectAtIndex:(NSUInteger)index;
- (NSColor*)backgroundColorForImageView:(LayoutView*)view;
@end
