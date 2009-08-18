//
//  LayoutDocument.m
//  DocumentDemo
//
//  Created by Rob Keniger on 16/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "LayoutDocument.h"
#import "Kitteh.h"
#import "LayoutWindowController.h"
#import "KittehCountController.h"

NSString* kBackgroundColorKey = @"Background Color";
NSString* kKittehsKey = @"Kittehs";

@implementation LayoutDocument

- (id)init
{
	[super init];
	{
		kittehs = [NSMutableArray array];
		selectedIndex = NSNotFound;
		backgroundColor = [NSColor grayColor];
	}
	return self;
}

//set up all the window controllers for this document
- (void)makeWindowControllers
{
	LayoutWindowController* imageWinController = [[LayoutWindowController alloc] init];
	self.delegate = imageWinController;
	[self addWindowController:imageWinController];
	
	KittehCountController* kittehCountController = [[KittehCountController alloc] init];
	[self addWindowController:kittehCountController];
}

//write the data
- (NSData*)dataOfType:(NSString*)typeName error:(NSError * *)outError
{
	NSMutableDictionary* propertyList = [NSMutableDictionary dictionary];
	//store the background color
	NSData* colorData = [NSKeyedArchiver archivedDataWithRootObject:backgroundColor];
	[propertyList setObject:colorData forKey:kBackgroundColorKey];
	
	//store the kittehs
	NSData* kittehData = [NSKeyedArchiver archivedDataWithRootObject:kittehs];
	[propertyList setObject:kittehData forKey:kKittehsKey];
	
	NSString* errorString = nil;
	NSData* plistData = [NSPropertyListSerialization dataFromPropertyList:propertyList format:NSPropertyListBinaryFormat_v1_0 errorDescription:&errorString];
	if(!plistData)
	{
		if(outError)
		{
			NSDictionary *errorUserInfo = [NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
			*outError = [NSError errorWithDomain:@"KittehErrorDomain" code:1 userInfo:errorUserInfo];
		}
		return nil;
	}
	return plistData;
}

//read the data
- (BOOL)readFromData:(NSData*)data ofType:(NSString*)typeName error:(NSError * *)outError
{

	//try to generate a property list from the data
	NSString* errorString = nil;
	NSPropertyListFormat format;
	NSDictionary* propertyList = [NSPropertyListSerialization propertyListFromData:data mutabilityOption:NSPropertyListImmutable format:&format errorDescription:&errorString];
	if(!propertyList)
	{
		if(outError)
		{
			NSDictionary *errorUserInfo = [NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
			*outError = [NSError errorWithDomain:@"KittehErrorDomain" code:69 userInfo:errorUserInfo];
		}
		return NO;
	}
	NSData* backgroundColorData = [propertyList objectForKey:kBackgroundColorKey];
	if(backgroundColorData)
		backgroundColor = [NSKeyedUnarchiver unarchiveObjectWithData:backgroundColorData];
	NSData* kittehData = [propertyList objectForKey:kKittehsKey];
	if(kittehData)
		self.kittehs = [[NSKeyedUnarchiver unarchiveObjectWithData:kittehData] mutableCopy];
	return YES;
}

#pragma mark -
#pragma mark Imageview Datasource Implementation
- (NSInteger)numberOfLayoutObjectsInImageView:(LayoutView*)view
{
	return [kittehs count];
}

- (id <LayoutObject>)layoutObjectAtIndex:(NSUInteger)index
{
	return [kittehs objectAtIndex:index];
}

- (NSColor*)backgroundColorForImageView:(LayoutView*)view
{
	return backgroundColor;	
}

#pragma mark -
#pragma mark return a selection set for the array controller

//automatically trigger KVO notifications if we change the selection index
+ (NSSet*)keyPathsForValuesAffectingSelectionIndexes
{
	return [NSSet setWithObjects:@"selectedIndex",nil];
}
- (NSIndexSet*) selectionIndexes;
{
	if(selectedIndex == NSNotFound)
		return nil;
	return [NSIndexSet indexSetWithIndex:selectedIndex];
}
- (void)setSelectionIndexes:(NSIndexSet*)indexes
{
	self.selectedIndex = [indexes firstIndex];	
}


#pragma mark -
#pragma mark accessors

@synthesize kittehs,delegate,selectedIndex;

//fulfil the copy property attribute contract
- (void)setKittehs:(NSMutableArray*)objects
{
	kittehs = [objects mutableCopy];
}


//indexed accessors for the kittehs arrah
- (NSUInteger)countOfKittehs 
{
    return [kittehs count];
}

- (id)objectInKittehsAtIndex:(NSUInteger)index 
{
    return [kittehs objectAtIndex:index];
}

- (void)insertObject:(id)anObject inKittehsAtIndex:(NSUInteger)index 
{
    [kittehs insertObject:anObject atIndex:index];
}

- (void)removeObjectFromKittehsAtIndex:(NSUInteger)index 
{
    [kittehs removeObjectAtIndex:index];
}

- (void)replaceObjectInKittehsAtIndex:(NSUInteger)index withObject:(id)anObject 
{
    [kittehs replaceObjectAtIndex:index withObject:anObject];
}

@end
