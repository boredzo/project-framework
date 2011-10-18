//
//  XCProject.m
//  Project
//
//  Created by Peter Hosey on 2011-10-18.
//  Copyright (c) 2011 Peter Hosey. All rights reserved.
//

#import "XCProject.h"

#import "XCObject.h"

@interface XCProject ()
@property(copy) NSDictionary *contentsDictionary;
@property(retain) NSDictionary *objectDictionariesByIdentifier;
@property(retain) NSMutableDictionary *objectsByIdentifier;
@end

#define PROJECT_FILENAME @"project.pbxproj"
#define PROJECT_KEY_OBJECTS @"objects"
#define PROJECT_KEY_ROOT @"rootObject"

@implementation XCProject

@synthesize contentsDictionary;
@synthesize objectDictionariesByIdentifier;
@synthesize objectsByIdentifier;

+ projectWithContentsOfURL:(NSURL *)URL {
	return [[[self alloc] init] autorelease];
}
- initWithContentsOfURL:(NSURL *)URL {
	if ((self = [super init])) {
		if (![[URL lastPathComponent] isEqualToString:PROJECT_FILENAME])
			URL = [URL URLByAppendingPathComponent:PROJECT_FILENAME];

		self.contentsDictionary = [NSDictionary dictionaryWithContentsOfURL:URL];
		self.objectDictionariesByIdentifier = [self.contentsDictionary objectForKey:PROJECT_KEY_OBJECTS];
		self.objectsByIdentifier = [[NSMutableDictionary alloc] init];
	}
	return self;
}

- (void) dealloc {
	[objectDictionariesByIdentifier release];
	[contentsDictionary release];
	[super dealloc];
}

- (PBXProject *) projectObject {
	return [self valueFromDictionary:self.contentsDictionary forKey:PROJECT_KEY_ROOT];
}

- (XCObject *) objectWithIdentifier:(NSString *)identifier {
	XCObject *object = [self.objectsByIdentifier objectForKey:identifier];
	if (!object) {
		object = [[[XCObject alloc] initWithIdentifier:identifier inProject:self] autorelease];
		[self.objectsByIdentifier setObject:object forKey:identifier];
	}
	return object;
}

- (NSDictionary *) dictionaryForObjectWithIdentifier:(NSString *)identifier {
	return [self.objectDictionariesByIdentifier objectForKey:identifier];
}

- (BOOL) isObjectIdentifier:(NSString *)identifier {
	return (nil != [self.objectDictionariesByIdentifier objectForKey:identifier]);
}

- (id) valueFromDictionary:(NSDictionary *)dict forKey:(NSString *)key {
	id value = [dict objectForKey:key];
	if ([value isKindOfClass:[XCObject class]]) {
		//Do nothing.
	} else if ([self isObjectIdentifier:value]) {
		return [self objectWithIdentifier:value];
	} else if ([value isKindOfClass:[NSArray class]]) {
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:[value count]];
		for (id object in value) {
			[array addObject:[self objectWithIdentifier:object]];
		}
		value = array;
	} else if ([value isKindOfClass:[NSDictionary class]]) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:[value count]];
		for (NSString *key in value) {
			[dict setObject:[self objectWithIdentifier:[dict objectForKey:key]] forKey:key];
		}
		value = dict;
	}
	return value;
}

@end
