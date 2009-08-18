//
//  MyDocument.h
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//


#import <Cocoa/Cocoa.h>

@interface TextDocument : NSDocument
{
	IBOutlet NSTextView* textView;
	NSAttributedString* rtfString;
}
@end
