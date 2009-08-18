//
//  ImageWindowController.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "LayoutWindowController.h"
#import "InspectorController.h"
#import "LayoutDocument.h"
#import "Kitteh.h"


#define MMRandom(x) (arc4random() % ((NSUInteger)(x) + 1))

static void* KittehContext = @"KittehContext";
static void* CuteContext   = @"CuteContext";
static void* ColorContext  = @"ColorContext";

@interface LayoutWindowController (Private)
- (void)changeKeyPath:(NSString*)keyPath ofObject:(id)obj toValue:(id)newValue;
@end


@implementation LayoutWindowController

//initializers
- (id)init
{
	self = [super initWithWindowNibName:@"LayoutDocWindow"];

	if(self)
	{
		//we want to close the document if this window is closed
		[self setShouldCloseDocument:YES];
	}
	return self;
}

- (void)windowDidLoad
{
	NSAssert(imageView != nil, @"ImageView outlet not connected");

	//we want the document to be the data source for the image view
	[imageView setDataSource:[self document]];

	//set up a few observers
	//watch for changes in the kittehs array
	[[self document] addObserver:self forKeyPath:@"kittehs" options:0 context:KittehContext];
	//the background color
	[[self document] addObserver:self forKeyPath:@"backgroundColor" options:NSKeyValueObservingOptionOld context:ColorContext];

	//watch for changes in the cuteness of the kittehs
	for(Kitteh* kitteh in [[self document] kittehs])
	{
		[kitteh addObserver:self forKeyPath:@"cuteness" options:NSKeyValueObservingOptionOld context:CuteContext];
	}
	//store the list of observed kittehs
	observedKittehs = [[[self document] kittehs] copy];

	//bind the selection of the image view to the document's selected index
	[imageView bind:@"selectedObjectIndex" toObject:[self document] withKeyPath:@"selectedIndex" options:nil];

	//we need to be notified of window closing so we can deregister observers
	[[self window] setDelegate:self];

	//refresh the view
	[imageView setNeedsDisplay:YES];
}

//handle KVO notifications
- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
	if (context == KittehContext)
	{
		[imageView setNeedsDisplay:YES];
		NSArray* kittehs               = [object valueForKeyPath:keyPath];

		//get the kittehs that have been added to the array
		NSMutableArray* newKittehs     = [kittehs mutableCopy];
		[newKittehs removeObjectsInArray:observedKittehs];

		//calculate the removed menu items
		NSMutableArray* removedKittehs = [observedKittehs mutableCopy];
		[removedKittehs removeObjectsInArray:kittehs];

		//stop observing the removed menu items
		for(Kitteh* kitteh in removedKittehs)
		{
			[kitteh removeObserver:self forKeyPath:@"cuteness"];
		}

		//start observing the new menu items
		for(Kitteh* kitteh in newKittehs)
		{
			[kitteh addObserver:self forKeyPath:@"cuteness" options:NSKeyValueObservingOptionOld context:CuteContext];
		}

		NSUndoManager* undo = [[self document] undoManager];
		[[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:observedKittehs];
		[undo setActionName:@"Modify Kittehs"];

		//store the current array of items as the old array so we can compare it next time
		observedKittehs = [kittehs copy];
	}
	else
	if (context == CuteContext)
	{
		//redraw when the cuteness changes
		NSUndoManager* undo = [[self document] undoManager];
		[[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:[change objectForKey:NSKeyValueChangeOldKey]];
		[undo setActionName:@"Change Cutez"];
		[imageView setNeedsDisplay:YES];
	}
	else
	if (context == ColorContext)
	{
		NSUndoManager* undo = [[self document] undoManager];

		//don't continuously fire for continuous controls
		if([undo groupingLevel] == 0 || [undo isUndoing] || [undo isRedoing])
		{
			[[undo prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:[change objectForKey:NSKeyValueChangeOldKey]];
			[undo setActionName:@"Change Background Color"];
		}
		[imageView setNeedsDisplay:YES];
	}
	else
	{
		[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

//when the window closes, we need to tear down our observers
- (void)windowWillClose:(NSNotification*)notification
{
	if([[notification object] isEqual:[self window]])
	{
		for(Kitteh* kitteh in observedKittehs)
		{
			[kitteh removeObserver:self forKeyPath:@"cuteness"];
		}
		[[self document] removeObserver:self forKeyPath:@"kittehs"];
		[[self document] removeObserver:self forKeyPath:@"backgroundColor"];
		[imageView unbind:@"selectedObjectIndex"];
	}
}

//called by the undo handler to set properties of objects
- (void)changeKeyPath:(NSString*)keyPath ofObject:(id)obj toValue:(id)newValue
{
	if([newValue isEqual:[NSNull null]])
		newValue = nil;
	[obj setValue:newValue forKeyPath:keyPath];
}


#pragma mark -
#pragma mark actions
// add a kitteh
- (IBAction)addKitteh:(id)sender;
{
	//create a new kitteh and give it a random position
	Kitteh* newKitteh         = [[Kitteh alloc] init];
	NSSize kittehSize         = [[newKitteh image] size];
	NSRect bounds             = [imageView bounds];
	newKitteh.position = NSMakePoint(MMRandom(NSWidth(bounds) - kittehSize.width), MMRandom(NSHeight(bounds) - kittehSize.height));

	//insert the kitteh into the document
	LayoutDocument* doc       = (LayoutDocument*)[self document];
	//make sure we use the indexed accessor so that any observers are notified of the change to the kittehs array
	NSUInteger insertionIndex = [doc countOfKittehs];
	[doc insertObject:newKitteh inKittehsAtIndex:insertionIndex];

	//select the new kitteh
	doc.selectedIndex = insertionIndex;
}

//remove a kitteh
- (IBAction)removeKitteh:(id)sender;
{
	LayoutDocument* doc = (LayoutDocument*)[self document];

	if(doc.selectedIndex == NSNotFound)
		return;
	[doc removeObjectFromKittehsAtIndex:doc.selectedIndex];
	doc.selectedIndex --;
}

//handle the inspector
- (IBAction)showInspector:(id)sender;
{
	[[InspectorController sharedInspector] showWindow:self];
}


@synthesize arrayController;

@end
