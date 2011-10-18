//
//  LTDocument.m
//  ListTargets
//
//  Created by Peter Hosey on 2011-10-18.
//  Copyright (c) 2011 Peter Hosey. All rights reserved.
//

#import "LTDocument.h"

#import <Project/Project.h>

@interface LTDocument ()
@property(retain) XCProject *project;
@property(readwrite, copy) NSArray *targets;
@end

@implementation LTDocument

@synthesize project;
@synthesize targets;

- (NSString *) windowNibName {
	return @"LTDocument";
}

- (BOOL) readFromURL:(NSURL *)absoluteURL ofType:(NSString *)typeName error:(NSError **)outError {
	self.project = [XCProject projectWithContentsOfURL:absoluteURL];
	PBXProject *projectObject = [project projectObject];
	self.targets = [projectObject targets];

	//This log statement to be replaced with a table view when the framework code works.
	NSLog(@"Targets: %@", self.targets);

	return YES;
}

@end
