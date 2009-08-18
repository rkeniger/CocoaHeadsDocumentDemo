//
//  PaletteController.h
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface InspectorController : NSWindowController 
{
	__weak NSDocument* layoutDocument;
}

@property (assign) __weak NSDocument* layoutDocument;

+ (id)sharedInspector;
- (void)updateCurrentDocument;
@end
