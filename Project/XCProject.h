//
//  XCProject.h
//  Project
//
//  Created by Peter Hosey on 2011-10-18.
//  Copyright (c) 2011 Peter Hosey. All rights reserved.
//

@class PBXProject, XCObject;

@interface XCProject : NSObject

+ projectWithContentsOfURL:(NSURL *)URL;
- initWithContentsOfURL:(NSURL *)URL;

- (PBXProject *) projectObject;

@end
