//
//  HTMLDocument.h
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface HTMLDocument : NSDocument 
{
	IBOutlet WebView* webView;
}

@end
