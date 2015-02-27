//
//  AAAlphabetimal.h
//  Alphabetimals
//
//  Created by Mona Zhang on 2/23/15.
//  Copyright (c) 2015 Mona Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alphabetimal : NSObject

@property NSString *name;
@property NSString *emoji;

+ (instancetype)alphabetimalWithDictionary:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
