//
//  PaletteController.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "InspectorController.h"
#import "LayoutDocument.h"

@implementation InspectorController

+ (id)sharedInspector
{
	static id sharedInspector = nil;

	if (sharedInspector == nil)
	{
		sharedInspector = [[super alloc] initWithWindowNibName:@"Inspector"];
	}
	return sharedInspector;
}

//we want to be notified when the main window changes
- (void)windowWillLoad
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidChangeState:) name:NSWindowDidBecomeMainNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(windowDidChangeState:) name:NSWindowDidResignMainNotification object:nil];
	[self updateCurrentDocument];
}

//called when the main window changes
- (void)windowDidChangeState:(NSNotification*)notification
{
	[self updateCurrentDocument];
}

//update the currently selected document in the inspector
- (void)updateCurrentDocument
{
	//if there's no main window, we don't want an inspector
	if(![NSApp mainWindow])
	{
		self.layoutDocument = nil;
		return;
	}

	//otherwise, if we have a main window, check to see if it's a layout document
	NSDocumentController* docController = [NSDocumentController sharedDocumentController];
	NSDocument* currentDocument         = [docController documentForWindow:[NSApp mainWindow]];

	if([currentDocument isKindOfClass:[LayoutDocument class]])
	{
		self.layoutDocument = currentDocument;
	}
	else
	{
		self.layoutDocument = nil;
	}
}

@synthesize layoutDocument;

@end