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

//Takes a hex string that is an object identifier within the project. Returns nil if this project doesn't have an object with that identifier.
- (XCObject *) objectWithIdentifier:(NSString *)identifier;
- (NSDictionary *) dictionaryForObjectWithIdentifier:(NSString *)identifier;

//Replaces any object identifiers in the value with XCObjects before returning the value.
//If the value is such an object identifier, the returned value will be an XCObject.
//If the value is a collection, the returned collection will have any elements that are identifiers replaced with XCObjects. (For NSDictionaries, keys are not replaced.)
- (id) valueFromDictionary:(NSDictionary *)dict forKey:(NSString *)key;

@end
