//
//  DemoDocumentController.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "DemoDocumentController.h"

@implementation DemoDocumentController


//the default document type that appears when we do File > New
- (NSString *)defaultType
{
	return @"public.rtf";
}


//for other document types we have to do a bit more manual labour
- (IBAction)newLayoutDocument:(id)sender
{
	NSError* error = nil;
	NSDocument* newDocument = [self makeUntitledDocumentOfType:@"LayoutDocumentType" error:&error];
	if(!newDocument)
	{
		if(error)
			[self presentError:error];
	}
	[self addDocument:newDocument];
	[newDocument makeWindowControllers];
	[newDocument showWindows];
}

//for new layout documents, just create new document of the default type
- (IBAction)newTextDocument:(id)sender
{
	NSError* error = nil;
	if(![self openUntitledDocumentAndDisplay:YES error:&error])
	{
		if(error)
			[self presentError:error];
	}
}


@end
