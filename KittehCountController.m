//
//  KittehCountController.m
//  DocumentDemo
//
//  Created by Rob Keniger on 18/08/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import "KittehCountController.h"

@implementation KittehCountController

- (id)init
{
	self = [super initWithWindowNibName:@"KittehCountWindow"];

	if(self)
	{

	}
	return self;
}

- (void)windowDidLoad
{
	[numberField setFont:[NSFont fontWithName:@"Husky Stash" size:260.0]];
}


- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName
{
	return [displayName stringByAppendingString:@" — Kitteh Count"];
}

@end
