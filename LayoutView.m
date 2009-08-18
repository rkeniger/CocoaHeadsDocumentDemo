//
//  ImageView.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "LayoutView.h"
#import "NSImage+Drawing.h"
#import "NSShadow+Extras.h"
#import "NSObject+MMBindings.h"

@interface LayoutView (Private)
- (void)moveLayoutObject:(id <LayoutObject>)obj toPosition:(NSPoint)aPosition;
@end


@implementation LayoutView
+ (void)initialize
{
	[self exposeBinding:@"selectedObjectIndex"];	
}

- (id)initWithFrame:(NSRect)rect
{
	self = [super initWithFrame:rect];

	if(self)
	{
		selectedObjectIndex = NSNotFound;
		currentMousePoint = NSZeroPoint;
	}
	return self;
}


- (void)drawRect:(NSRect)rect
{
	NSRect bounds = [self bounds];
	
	//draw the background color
	if([dataSource respondsToSelector:@selector(backgroundColorForImageView:)])
		[[dataSource backgroundColorForImageView:self] set];
	else
		[[NSColor grayColor] set];	
	NSRectFill(bounds);

	//draw the objects
	if([dataSource respondsToSelector:@selector(numberOfLayoutObjectsInImageView:)] &&
	   [dataSource respondsToSelector:@selector(layoutObjectAtIndex:)])
	{
		//find out how many objects we have to draw
		NSUInteger i, numObjects = [dataSource numberOfLayoutObjectsInImageView:self];

		//iterate through the objects and draw them
		for(i = 0; i < numObjects; i ++)
		{
			id <LayoutObject> currentObject = [dataSource layoutObjectAtIndex:i];

			if(i == selectedObjectIndex)
				[NSShadow setShadowWithOffset:NSZeroSize blurRadius:6.0 color:[NSColor yellowColor]];
			else
				[NSShadow setShadowWithOffset:NSZeroSize blurRadius:6.0 color:[NSColor blackColor]];
			[[currentObject image] drawAdjustedAtPoint:[currentObject position]];
		}
	}
}

- (void)mouseDown:(NSEvent*)event
{
	if([dataSource respondsToSelector:@selector(numberOfLayoutObjectsInImageView:)] &&
	   [dataSource respondsToSelector:@selector(layoutObjectAtIndex:)])
	{
		//get the point in our view coordinates
		NSPoint locationInView = [self convertPoint:[event locationInWindow] fromView:nil];
		
		//find out how many objects we have to loop through
		NSUInteger i, numObjects = [dataSource numberOfLayoutObjectsInImageView:self];

		//iterate through the objects and draw them
		for(i = numObjects; i > 0; i--)
		{
			NSUInteger index = i-1;
			id <LayoutObject> currentObject = [dataSource layoutObjectAtIndex:index];
			if([currentObject hitTest:locationInView])
			{
				self.selectedObjectIndex = index;
				currentMousePoint = locationInView;
				break;
			}
		}
	}
}

- (void)mouseUp:(NSEvent*)event
{
	currentMousePoint = NSZeroPoint;
	
	NSUndoManager* undoManager = [self undoManager];
	if([undoManager groupingLevel] != 0)
	{
		[undoManager setActionName:@"Move Object"];
		[undoManager endUndoGrouping];
	}
}

- (void)mouseDragged:(NSEvent*)event
{
	//only drag if the mouse has hit a selected object
	if(!NSEqualPoints(currentMousePoint, NSZeroPoint) && selectedObjectIndex != NSNotFound && [dataSource respondsToSelector:@selector(layoutObjectAtIndex:)])
	{
		//get the selected object
		id <LayoutObject> selectedObject = [dataSource layoutObjectAtIndex:selectedObjectIndex];
		if(!selectedObject)
			return;
		
		//calculate the offset from the last mouse position
		NSPoint currentPoint = [self convertPoint:[event locationInWindow] fromView:nil];
		CGFloat deltaX = currentPoint.x - currentMousePoint.x;
		CGFloat deltaY = currentPoint.y - currentMousePoint.y;
		
		if([[self undoManager] groupingLevel] == 0)
			[[self undoManager] beginUndoGrouping];
		
		//move the object and redisplay
		NSPoint objPosition = selectedObject.position;
		
		[[[self undoManager] prepareWithInvocationTarget:self] moveLayoutObject:selectedObject toPosition:objPosition];

		objPosition.x += deltaX;
		objPosition.y += deltaY;
		selectedObject.position = objPosition;
		currentMousePoint = currentPoint;
		[self setNeedsDisplay:YES];
	}
}

//called by undo manager
- (void)moveLayoutObject:(id <LayoutObject>)obj toPosition:(NSPoint)aPosition
{
	[[[self undoManager] prepareWithInvocationTarget:self] moveLayoutObject:obj toPosition:obj.position];
	obj.position = aPosition;
	[self setNeedsDisplay:YES];
}


//when the selection changes, we need to propagate the selection to any binding observers
- (void)setSelectedObjectIndex:(NSUInteger)index
{
	selectedObjectIndex = index;
	[self propagateValue:[NSNumber numberWithUnsignedInteger:index] forBinding:@"selectedObjectIndex"];
	[self setNeedsDisplay:YES];
}


//this improves drawing performance as there are no transparent sections
- (BOOL)isOpaque
{
	return YES;
}

//drawing coordinates start from the top left for convenience
- (BOOL)isFlipped
{
	return YES;
}

//accept a click even if the window is not active
- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent
{
	return YES;	
}

@synthesize dataSource, selectedObjectIndex;

@end
