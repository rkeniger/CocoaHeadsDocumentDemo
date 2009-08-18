//
//  NSShadow+Extras.h
//
//  Created by Rob Keniger on 13/03/07.
//  Copyright 2007 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface NSShadow (Extras)
+(NSShadow*)shadowWithOffset:(NSSize)offset blurRadius:(CGFloat)blurRadius color:(NSColor*)color;
+(void)setShadowWithOffset:(NSSize)offset blurRadius:(CGFloat)blurRadius color:(NSColor*)color;

//draw the shadow using the bezier path but do not draw the bezier path
- (void)drawUsingBezierPath:(NSBezierPath*) path alpha:(CGFloat) alpha;
@end
