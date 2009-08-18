//
//  DemoDocumentAppDelegate.m
//  DocumentDemo
//
//  Created by Rob Keniger on 18/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "DemoDocumentAppDelegate.h"

@implementation DemoDocumentAppDelegate

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
	return NO;	
}

@end
