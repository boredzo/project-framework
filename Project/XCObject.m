//
//  XCObject.m
//  Project
//
//  Created by Peter Hosey on 2011-10-18.
//  Copyright (c) 2011 Peter Hosey. All rights reserved.
//

#import "XCObject.h"

#import <objc/runtime.h>

#import "XCProject.h"

@interface XCObject ()
@property(copy) NSString *identifier;
@property(assign) XCProject *project;
@end

@interface XCBlankObject : XCObject
@end
#define OBJECT_CLASS_NAME @"isa"

@implementation XCObject

@synthesize identifier;
@synthesize project;

+ (SEL) designatedInitializer {
	return NULL;
}

+ (id) allocWithZone:(NSZone *)zone {
	if (self == [XCObject class])
		return [XCBlankObject allocWithZone:zone];
	else
		return [super allocWithZone:zone];
}
+ (id) alloc {
	return [self allocWithZone:nil];
}

- (id) initWithIdentifier:(NSString *)newIdentifier inProject:(XCProject *)newProject {
	if ((self = [super init])) {
		NSParameterAssert(newIdentifier != nil);
		NSParameterAssert(newProject != nil);
		identifier = [newIdentifier copy];
		project = [newProject retain];
	}
	return self;
}

- (void) dealloc {
	[project release];
	[identifier release];
	[super dealloc];
}

- (NSString *) classNameForRealObject {
	NSDictionary *dict = [self.project dictionaryForObjectWithIdentifier:self.identifier];
	NSString *name = [dict objectForKey:OBJECT_CLASS_NAME];
	return name;
}

@end

@implementation XCBlankObject
{
@private
	//Should be enough for any instance variables any other, real subclass of XCObject may add.
	id blank[64];
}

- (NSSet *) keysInObjectDictionary:(NSDictionary *)dict {
	if (!dict)
		dict = [self.project dictionaryForObjectWithIdentifier:self.identifier];
	return [NSSet setWithArray:[dict allKeys]];
}
- (NSSet *) propertyNamesFromClass:(Class)class {
	NSSet *result = nil;

	unsigned int numProperties = 0;
	objc_property_t *properties = class_copyPropertyList(class, &numProperties);
	if (properties) {
		NSMutableSet *names = [NSMutableSet setWithCapacity:numProperties];
		for (unsigned i = 0; i < numProperties; ++i) {
			[names addObject:[NSString stringWithUTF8String:property_getName(properties[i])]];
		}

		free(properties);
		result = names;
	}

	return result;
}

- (id) resolveSelf {
	Class class = NSClassFromString([self classNameForRealObject]);
	if (!class)
		self = nil;
	else {
		NSDictionary *dict = [self.project dictionaryForObjectWithIdentifier:self.identifier];
		NSMutableSet *properties = [[[self propertyNamesFromClass:class] mutableCopy] autorelease];
		[properties intersectSet:[self keysInObjectDictionary:dict]];

		object_setClass(self, class);
		self = [self init];

		for (NSString *key in properties) {
			[self setValue:[self.project valueFromDictionary:dict forKey:key] forKey:key];
		}
	}
	return self;
}

- (id) forwardingTargetForSelector:(SEL)selector {
	id object = [self resolveSelf];
	if (!object)
		object = [super forwardingTargetForSelector:selector];
	return object;
}

- (NSString *) description {
	return [NSString stringWithFormat:@"<%@ (someday a real %@) %p>", [self class], [self classNameForRealObject], self];
}

@end
