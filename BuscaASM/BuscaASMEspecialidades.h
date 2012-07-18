//
//  BuscaASMEspecialidades.h
//  BuscaASM
//
//  Created by Bruno Amaral on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BuscaASMEspecialidade ;

@interface BuscaASMEspecialidades : NSObject

+ (BuscaASMEspecialidade*) rootEspecialidade ;

@end

@interface BuscaASMEspecialidade : NSObject

- (BuscaASMEspecialidade*) initWith:(int) identifier andName:(NSString*)name ;

@property (nonatomic, readonly) int identifier ;
@property (nonatomic, strong, readonly) NSString *name ;
@property(nonatomic, strong, readonly) NSMutableArray *children ;
@property(nonatomic, strong, readonly) NSMutableSet *categories ;
@property(nonatomic, strong, readonly) BuscaASMEspecialidade* parent ;

- (void) addChildren:(BuscaASMEspecialidade*) child ;
- (void) addCategory:(NSString*) category;
- (void) addCategories:(NSArray *) categories ;

@end
