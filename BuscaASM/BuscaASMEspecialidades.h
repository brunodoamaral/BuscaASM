//
//  BuscaASMEspecialidades.h
//  BuscaASM
//
//  Created by Bruno Amaral on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuscaASMEspecialidades : NSObject

@property (weak, nonatomic, readonly) NSArray* especialidades ;
- (BuscaASMEspecialidades*) initWithJsonString:(NSString*) jsonString;

@end
