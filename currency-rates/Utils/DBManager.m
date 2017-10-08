//
//  DBManager.m
//  currency-rates
//
//  Created by Adina Abilda on 06.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import "DBManager.h"

@interface DBManager ()

+ (BOOL)createCurrencyRateTableWithDatabase:(FMDatabase *)database;

@end

@implementation DBManager

+ (FMDatabase *)getDatabase {
    static NSString *databaseName = @"currency-rate.db";
    
    NSString *databasePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    BOOL create = FALSE;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath]) {
        create = TRUE;
    }
    
    FMDatabase *database = [FMDatabase databaseWithPath:databasePath];
    
    if (![database open]) {
        return nil;
    }
    
    if (create) {
        [DBManager createCurrencyRateTableWithDatabase:database];
    }
    
    return database;
}

+ (BOOL)createCurrencyRateTableWithDatabase:(FMDatabase *)database {
    NSString *query = @"CREATE TABLE currencyrate ("
                       "    name text primary key,"
                       "    rate numeric,"
                       "    ts text"
                       ");";
    
    return [database executeUpdate:query];
}

@end
