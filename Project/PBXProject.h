//
//  PBXProject.h
//  Project
//
//  Created by Peter Hosey on 2011-10-18.
//  Copyright (c) 2011 Peter Hosey. All rights reserved.
//

#import "XCObject.h"

@interface PBXProject : XCObject

@property(readonly, copy) NSArray *targets;

@end
