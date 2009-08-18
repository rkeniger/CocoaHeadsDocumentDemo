//
//  ImageWindowController.h
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class LayoutView;

@interface LayoutWindowController : NSWindowController 
{
	IBOutlet LayoutView* imageView;
	NSArrayController* arrayController;
	NSArray* observedKittehs;
}
@property IBOutlet NSArrayController* arrayController;
- (IBAction)showInspector:(id)sender;
- (IBAction)addKitteh:(id)sender;
- (IBAction)removeKitteh:(id)sender;
@end
