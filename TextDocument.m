//
//  MyDocument.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "TextDocument.h"

@implementation TextDocument

+ (NSArray*)readableTypes
{
	return [NSArray arrayWithObjects:@"public.rtf",@"public.plain-text",nil];
}

+ (NSArray*)writableTypes
{
	return [NSArray arrayWithObjects:@"public.rtf",@"public.plain-text",nil];
}


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

//called when the nib is loaded, outlets are guaranteed to be active at this point
- (void)windowControllerDidLoadNib:(NSWindowController*)aController
{
	[super windowControllerDidLoadNib:aController];

	//based on the file type, we pass either a plain text string or an attributed string
	if([[self fileType] isEqualToString:@"public.rtf"])
	{
		[textView setRichText:YES];
		[[textView textStorage] setAttributedString:rtfString];
	}
	else
	{
		//if it's a plain text string, we don't want the user to be able to apply attributes
		[textView setRichText:NO];
		[textView setString:[rtfString string]];
	}
}

- (BOOL)readFromURL:(NSURL*)absoluteURL ofType:(NSString*)typeName error:(NSError * *)outError
{
	//
	if([typeName isEqualToString:@"public.rtf"])
	{
		rtfString         = [[NSAttributedString alloc] initWithURL:absoluteURL
		                     options:[NSDictionary dictionaryWithObject:NSRTFTextDocumentType forKey:NSDocumentTypeDocumentOption]
		                     documentAttributes:NULL
		                     error:outError];
		plainTextEncoding = NSUTF8StringEncoding;

		if(!rtfString)
			return NO;
		return YES;
	}
	else
	if([typeName isEqualToString:@"public.plain-text"])
	{
		//this initialises the string and detects the encoding for us
		NSString* text = [NSString stringWithContentsOfURL:absoluteURL usedEncoding:&plainTextEncoding error:outError];

		if(!text)
			return NO;
		rtfString = [[NSAttributedString alloc] initWithString:text];
		return YES;
	}

	if(outError != NULL)
		*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:NULL];
	return NO;
}

- (NSData*)dataOfType:(NSString*)typeName error:(NSError * *)outError
{
	//write RTF data
	if([typeName isEqualToString:@"public.rtf"])
	{
		NSData* data = [textView RTFFromRange:NSMakeRange(0, [[textView textStorage] length])];

		if(!data)
		{
			if(outError != NULL)
				*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:NULL];
			return nil;
		}
		return data;
	}

	//write plain text data
	if([typeName isEqualToString:@"public.plain-text"])
	{
		NSData* data = [[textView string] dataUsingEncoding:plainTextEncoding];

		if(!data)
		{
			if(outError != NULL)
				*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:NULL];
			return nil;
		}
		return data;
	}
	if(outError != NULL)
		*outError = [NSError errorWithDomain:NSCocoaErrorDomain code:NSFileWriteUnknownError userInfo:NULL];
	return nil;
}

@end
