//
//  DBManager.h
//  currency-rates
//
//  Created by Adina Abilda on 06.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDatabase.h>

@interface DBManager : NSObject

+ (FMDatabase *)getDatabase;

@end
