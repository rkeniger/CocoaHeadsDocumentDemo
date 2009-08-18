//
//  NSImage+Drawing.m
//  DocumentDemo
//
//  Created by Rob Keniger on 17/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "NSImage+Drawing.h"

@implementation NSImage (Drawing)

- (void)drawAdjustedAtPoint:(NSPoint)point
{
	[self drawAdjustedAtPoint:point fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void)drawAdjustedInRect:(NSRect)rect
{
	[self drawAdjustedInRect:rect fromRect:NSZeroRect operation:NSCompositeSourceOver fraction:1.0];
}

- (void)drawAdjustedAtPoint:(NSPoint)aPoint fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta
{
	NSSize size = [self size];

	[self drawAdjustedInRect:NSMakeRect(aPoint.x, aPoint.y, size.width, size.height) fromRect:srcRect operation:op fraction:delta];
}

- (void)drawAdjustedInRect:(NSRect)dstRect fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta
{
	NSGraphicsContext* context;
	BOOL contextIsFlipped;

	context          = [NSGraphicsContext currentContext];
	contextIsFlipped = [context isFlipped];

	if (contextIsFlipped)
	{
		NSAffineTransform* transform;

		[context saveGraphicsState];

		// Flip the coordinate system back.
		transform = [NSAffineTransform transform];
		[transform translateXBy:0 yBy:NSMaxY(dstRect)];
		[transform scaleXBy:1 yBy:-1];
		[transform concat];

		// The transform above places the y-origin right where the image should be drawn.
		dstRect.origin.y = 0.0;
	}

	[self drawInRect:dstRect fromRect:srcRect operation:op fraction:delta];

	if (contextIsFlipped)
	{
		[context restoreGraphicsState];
	}

}

@end
