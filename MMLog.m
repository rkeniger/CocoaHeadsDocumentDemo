//
//  MMLog.m
//  MenuMachine
//
//  Created by Rob Keniger on 9/11/07.
//  Copyright 2007 Big Bang Software Pty Ltd. All rights reserved.
//

#import "MMLog.h"


@implementation MMLogObject

+ (void) logFile: (char *) sourceFile lineNumber: (NSInteger) lineNumber format: (NSString *) format, ...;
{
#ifndef DEBUG	
	return;
#endif	
	va_list ap;
	NSString *print, *file;
	va_start(ap, format);
	file = [NSString stringWithCString:sourceFile encoding:NSUTF8StringEncoding];
	print = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	
	fprintf(stderr, "%s\n", [[NSString stringWithFormat:@"%s:%d %@", [[file lastPathComponent] UTF8String], lineNumber, print] cStringUsingEncoding:NSUTF8StringEncoding]);
	//NSLog(@"%s:%d %@", [[file lastPathComponent] UTF8String], lineNumber, print);
	[print release];
}

+ (void) logFile: (char *) sourceFile lineNumber: (NSInteger) lineNumber function: (char *) functionName format: (NSString *) format, ...;
{
#ifndef DEBUG	
	return;
#endif	
	va_list ap;
	NSString *print, *file, *function;
	va_start(ap,format);
	file = [NSString stringWithCString:sourceFile encoding:NSUTF8StringEncoding];
	function = [NSString stringWithCString:functionName encoding:NSUTF8StringEncoding];
	print = [[NSString alloc] initWithFormat:format arguments:ap];
	va_end(ap);
	NSLog(@"%s:%d in %@ %@", [[file lastPathComponent] UTF8String], lineNumber, function, print);
	[print release];
}

@end