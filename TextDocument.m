//
//  MyDocument.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "TextDocument.h"

@implementation TextDocument

- (id)init
{
	self = [super init];

	if (self)
	{
		rtfString = [[NSAttributedString alloc] initWithString:@""];
	}
	return self;
}

- (NSString*)windowNibName
{
	// Override returning the nib file name of the document
	// If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
	return @"TextDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController*)aController
{
	[super windowControllerDidLoadNib:aController];
	[[textView textStorage] setAttributedString:rtfString];
}

- (BOOL)readFromData:(NSData*)data ofType:(NSString*)typeName error:(NSError * *)outError
{
	rtfString = [[NSAttributedString alloc] initWithRTF:data documentAttributes:NULL];

	if(!rtfString)
	{
		if ( outError != NULL )
		{
			*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileReadUnknownError userInfo:NULL];
		}
		return NO;
	}
	return YES;
}

- (NSData*)dataOfType:(NSString*)typeName error:(NSError * *)outError
{
	NSData* data = [textView RTFFromRange:NSMakeRange(0, [[textView textStorage] length])];

	if(!data)
	{
		if ( outError != NULL )
		{
			*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:NULL];
		}
		return nil;
	}
	return data;
}

@end
