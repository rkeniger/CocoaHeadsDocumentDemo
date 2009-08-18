//
//  HTMLDocument.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "HTMLDocument.h"

@implementation HTMLDocument

- (NSString*)windowNibName
{
	// Implement this to return a nib to load OR implement -makeWindowControllers to manually create your controllers.
	return @"HTMLDocument";
}

- (BOOL)readFromURL:(NSURL*)absoluteURL ofType:(NSString*)typeName error:(NSError * *)outError
{
	//we aren't doing any actual loading of data
	//the document architecture automatically records the file URL
	//so just return YES
	return YES;
}

- (BOOL)writeToURL:(NSURL*)absoluteURL ofType:(NSString*)typeName error:(NSError * *)outError
{
	//we don't allow saving, so just return NO
	return NO;
}


- (void)windowControllerDidLoadNib:(NSWindowController*)windowController
{
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[self fileURL]]];
}

+ (NSArray*)readableTypes
{
	return [NSArray arrayWithObject:@"public.html"];
}

+ (NSArray*)writableTypes
{
	return nil;
}

//we don't want to allow saving, so disable an UI items that try to call the save methods
- (BOOL)validateUserInterfaceItem:(id < NSValidatedUserInterfaceItem >)anItem
{
	SEL action = [anItem action];

	if(action == @selector(saveDocument:)   ||
	   action == @selector(saveDocumentAs:) ||
	   action == @selector(saveDocumentTo:) ||
	   action == @selector(revertDocumentToSaved:))
		return NO;
	return YES;
}

//handle basic printing
- (void)printDocument:(id)sender
{
	NSPrintOperation* op = [NSPrintOperation printOperationWithView:webView printInfo:[self printInfo]];
	[op runOperationModalForWindow:[webView window] delegate:self didRunSelector:NULL contextInfo:NULL];
}

@end
