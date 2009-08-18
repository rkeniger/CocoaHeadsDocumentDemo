//
//  MMLog.h
//  MenuMachine
//
//  Created by Rob Keniger on 9/11/07.
//  Copyright 2007 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <execinfo.h>



#define MMLog(s,...) [MMLogObject logFile:__FILE__ lineNumber:__LINE__ format:(s),##__VA_ARGS__]
#define MMFLog(s,...) [MMLogObject logFile:__FILE__ lineNumber:__LINE__ function:(char*)__FUNCTION__ format:(s),##__VA_ARGS__]

#ifdef DEBUG
#define Debug(format, ...)  MMLog(@"<Debug>: " format, ##__VA_ARGS__)
#else
#define Debug(format, ...)
#endif

#define Warn(format, ...)  MMLog(@"<Warning>: " format, ##__VA_ARGS__)
#define Error(format, ...)  MMLog(@"<Error>: " format, ##__VA_ARGS__)


@interface MMLogObject : NSObject 
{
}

+ (void) logFile: (char *) sourceFile lineNumber: (NSInteger) lineNumber format: (NSString *) format, ...;
+ (void) logFile: (char *) sourceFile lineNumber: (NSInteger) lineNumber function: (char *) functionName format: (NSString *) format, ...;

@end