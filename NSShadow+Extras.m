//
//  NSShadow+Extras.m
//
//  Created by Rob Keniger on 13/03/07.
//  Copyright 2007 Big Bang Software Pty Ltd. All rights reserved.
//

#import "NSShadow+Extras.h"

@implementation NSShadow (Extras)
+(NSShadow*)shadowWithOffset:(NSSize)offset blurRadius:(CGFloat)blurRadius color:(NSColor*)color;
{
	NSShadow* shadow=[[NSShadow alloc] init];
	[shadow setShadowOffset:offset];
	[shadow setShadowColor:color];
	[shadow setShadowBlurRadius:blurRadius];
	return shadow;
}
+(void)setShadowWithOffset:(NSSize)offset blurRadius:(CGFloat)blurRadius color:(NSColor*)color
{
	[[NSShadow shadowWithOffset:offset blurRadius:blurRadius color:color] set];
}


//draw the shadow using the bezier path but do not draw the bezier path
- (void)drawUsingBezierPath:(NSBezierPath*) path alpha:(CGFloat) alpha
{
	[NSGraphicsContext saveGraphicsState];
	//get the bounds of the path
	NSRect bounds = [path bounds];
	
	//create a rectangle that outsets the size of the path bounds by the blur radius amount
	CGFloat blurRadius = [self shadowBlurRadius];
	NSRect shadowBounds = NSInsetRect(bounds, -blurRadius, -blurRadius);
	
	//create an image to hold the shadow
	NSImage* shadowImage = [[NSImage alloc] initWithSize:shadowBounds.size];
	
	//make a copy of the shadow and set its offset so that when the path is drawn, the shadow is drawn in the middle of the image
	NSShadow* shadow = [self copy];
	[shadow setShadowOffset:NSMakeSize(0, -NSHeight(shadowBounds))];

	//lock focus on the image
	[shadowImage lockFocus];
	
	//we want to draw the path directly above the shadow image and offset the shadow so it is drawn in the image rect
	//to do this we must translate the drawing into the correct location
	NSAffineTransform* transform=[NSAffineTransform transform];
	//first get it to the zero point
	[transform translateXBy:-shadowBounds.origin.x yBy:-shadowBounds.origin.y];
	
	//now translate it by the height of the image so that it draws outside the image bounds
	[transform translateXBy:0.0 yBy:NSHeight(shadowBounds)];
	NSBezierPath* translatedPath = [transform transformBezierPath:path];
	
	//apply the shadow
	[shadow set];
	
	//fill the path with an arbitrary black color
	[[NSColor blackColor] set];
	[translatedPath fill];
	
	[shadowImage unlockFocus];
	
	//draw the image at the correct location relative to the original path
	NSPoint imageOrigin = bounds.origin;
	imageOrigin.x = (imageOrigin.x - blurRadius) + [self shadowOffset].width;
	imageOrigin.y = (imageOrigin.y - blurRadius) - [self shadowOffset].height;
	
	[shadowImage drawAtPoint:imageOrigin fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:alpha];
	[NSGraphicsContext restoreGraphicsState];
}



@end
