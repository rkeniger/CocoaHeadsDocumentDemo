//
//  NSObject+MMBindings.h
//  SteamEngine
//
//  Created by Rob Keniger on 31/07/09.
//  Copyright 2009 Big Bang Software Pty Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//Mad props to http://www.tomdalling.com/cocoa/implementing-your-own-cocoa-bindings

@interface NSObject (MMBindings)
- (void)propagateValue:(id)value forBinding:(NSString*)binding;
@end