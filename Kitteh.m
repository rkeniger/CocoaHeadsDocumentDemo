//
//  LayoutObject.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "Kitteh.h"

@implementation Kitteh

- (id)init;
{
	self = [super init];

	if(self)
	{
		cuteness = 0;
	}
	return self;
}

#pragma mark -
#pragma mark NSCoding
- (id)initWithCoder:(NSCoder*)coder
{
	self = [super init];
	if(self)
	{
		cuteness 	= [coder decodeIntegerForKey:@"cuteness"];
		position    = [coder decodePointForKey:@"position"];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder*)coder
{
	[coder encodeInteger:cuteness forKey:@"cuteness"];
	[coder encodePoint:position forKey:@"position"];
}

#pragma mark -
#pragma mark accessors
- (NSImage*)image
{
	switch(cuteness)
	{
		case Cute:
			return [NSImage imageNamed:@"kitteh1"];
			break;
		case Cuter:
			return [NSImage imageNamed:@"kitteh4"];
			break;
		case ReallyCute:
			return [NSImage imageNamed:@"kitteh2"];
			break;
		case SuperCute:
			return [NSImage imageNamed:@"kitteh3"];
			break;
	}
	return nil;
}

- (BOOL)hitTest:(NSPoint)point
{
	NSImage* image = [self image];
	
	NSSize size = [image size];
	NSInteger i = (NSInteger)(point.x - position.x);
	NSInteger j = (NSInteger)(point.y - position.y);
	
	//make sure we hit inside the rect
	if(i > size.width || j > size.height || i < 0 || j < 0)
		return NO;

	//check to see we've hit a region with image content
	NSBitmapImageRep* imageRep = (NSBitmapImageRep*)[image bestRepresentationForDevice:nil];
	NSUInteger pixelData[[imageRep samplesPerPixel]];
	[imageRep getPixel:pixelData atX:i y:j];
	NSUInteger alpha = pixelData[[imageRep samplesPerPixel] - 1];
	if(alpha != 0)
	{
		return YES;
	}
	return NO;
}



@synthesize cuteness;
@synthesize position;
@end
