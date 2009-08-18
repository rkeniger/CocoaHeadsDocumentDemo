//
//  LayoutObject.h
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LayoutView.h"

typedef enum
{
	Cute = 0,
	Cuter,
	ReallyCute,
	SuperCute
} KittehCuteness;
	


@interface Kitteh : NSObject <NSCoding,LayoutObject>
{
	KittehCuteness cuteness;
	NSPoint position;
}

@property KittehCuteness cuteness;

//returns the image of the kitteh based on cuteness
@property (readonly) NSImage* image;

//the location of the kitteh
@property NSPoint position;


- (NSImage*)image;
- (BOOL)hitTest:(NSPoint)point;

@end
