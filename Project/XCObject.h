//
//  XCObject.h
//  Project
//
//  Created by Peter Hosey on 2011-10-18.
//  Copyright (c) 2011 Peter Hosey. All rights reserved.
//

@class XCProject;

@interface XCObject : NSObject

+ (SEL) designatedInitializer;

- (id) initWithIdentifier:(NSString *)identifier inProject:(XCProject *)project;

@end
