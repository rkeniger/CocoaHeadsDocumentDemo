//
//  NSImage+Drawing.h
//  DocumentDemo
//
//  Created by Rob Keniger on 17/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSImage (Drawing)
//draw an image adjusted for the flipped state of the current graphics context
- (void)drawAdjustedAtPoint:(NSPoint)point;
- (void)drawAdjustedInRect:(NSRect)rect;
- (void)drawAdjustedAtPoint:(NSPoint)aPoint fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta;
- (void)drawAdjustedInRect:(NSRect)dstRect fromRect:(NSRect)srcRect operation:(NSCompositingOperation)op fraction:(CGFloat)delta;
@end
