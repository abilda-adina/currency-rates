//
//  CurrencyRate.m
//  currency-rates
//
//  Created by Adina Abilda on 07.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import "APIClient.h"
#import "DBManager.h"
#import "CurrencyRate.h"

@implementation CurrencyRate

+ (instancetype)initWithName:(NSString *)name WithRate:(double)rate WithTS:(NSDate *)ts {
    CurrencyRate *currencyRate = [[CurrencyRate alloc] init];
    
    currencyRate.name = name;
    currencyRate.rate = rate;
    currencyRate.ts = ts;
    
    return currencyRate;
}

+ (NSArray *)getAllCurrencyRates {
    NSMutableArray *result = [NSMutableArray array];
    FMDatabase *database = [DBManager getDatabase];
    NSString *query = @"SELECT * FROM currencyrate;";
    
    FMResultSet *resultSet = [database executeQuery:query];
    
    while ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"name"];
        double rate = [resultSet doubleForColumn:@"rate"];
        NSDate *ts = [resultSet dateForColumn:@"ts"];
        
        CurrencyRate *currencyRate = [CurrencyRate initWithName:name WithRate:rate WithTS:ts];
        
        [result addObject:currencyRate];
    }
    
    return [NSArray arrayWithArray:result];
}

+(CurrencyRate *)getCurrencyRateWithName:(NSString *)name {
    FMDatabase *database = [DBManager getDatabase];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM currencyrate WHERE name = '%@';", name];
    
    FMResultSet *resultSet = [database executeQuery:query];
    
    if ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"name"];
        double rate = [resultSet doubleForColumn:@"rate"];
        NSDate *ts = [resultSet dateForColumn:@"ts"];
        
        return [CurrencyRate initWithName:name WithRate:rate WithTS:ts];
    }
    
    return nil;
}

+ (BOOL)addOrUpdateWithArray:(NSArray *)currencyRates {
    FMDatabase *database = [DBManager getDatabase];
    NSString *currencyRatesSQL = @"";
    
    for (CurrencyRate *currencyRate in currencyRates) {
        NSString *sql = [NSString stringWithFormat:@"('%@', %f, '%@')", currencyRate.name, currencyRate.rate, currencyRate.ts];
        
        if (![currencyRatesSQL isEqualToString:@""]) {
            sql = [@", " stringByAppendingString:sql];
        }
        
        currencyRatesSQL = [currencyRatesSQL stringByAppendingString:sql];
    }
    
    NSString *query = [NSString stringWithFormat:@"INSERT OR REPLACE INTO currencyrate (name, rate, ts) VALUES %@;", currencyRatesSQL];
    
    return [database executeUpdate:query];
}

+ (NSDate *)parseDateWithString:(NSString *)string {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssz"];
    
    return [dateFormat dateFromString:string];
}

+ (NSURLSessionDataTask *)fetchCurrencyRatesFromAPIWithBlock:(void (^)(BOOL success, NSError *error))block {
    NSDictionary *parameters = @{@"format":@"json"};
    
    return [[APIClient sharedClient] GET:@"webservice/v1/symbols/allcurrencies/quote" parameters:parameters progress:nil success:^(NSURLSessionDataTask * __unused task, id response) {
        NSArray *rawCurrencyRates = [response valueForKeyPath:@"list.resources"];
        NSMutableArray *currencyRates = [NSMutableArray array];
        
        for (NSDictionary *rawCurrencyRate in rawCurrencyRates) {
            if ([[rawCurrencyRate valueForKeyPath:@"resource.fields.name"] hasPrefix:@"USD"]) {
                NSString *name = [rawCurrencyRate valueForKeyPath:@"resource.fields.name"];
                
                if (![name isEqualToString:@"USD"]) {
                    name = [name substringFromIndex:4];
                }
                
                double rate = [[rawCurrencyRate valueForKeyPath:@"resource.fields.price"] doubleValue];
                NSDate *ts = [CurrencyRate parseDateWithString:[rawCurrencyRate valueForKeyPath:@"resource.fields.utctime"]];
                
                CurrencyRate *currencyRate = [CurrencyRate initWithName:name WithRate:rate WithTS:ts];
                [currencyRates addObject:currencyRate];
            }
        }
        
        BOOL success = [CurrencyRate addOrUpdateWithArray:[NSArray arrayWithArray:currencyRates]];
        
        if (block) {
            block(success, nil);
        }
        
        if (!success) {
            NSLog(@"Failure on saving to database");
        }
        
    } failure:^(NSURLSessionDataTask *__unused task, NSError *error) {
        if (block) {
            block(nil, error);
        }
        
        NSLog(@"Failure on feting from API");
    }];
}


+ (NSURLSessionDataTask *)fetchCurrencyRatesFromAPI {
    return [CurrencyRate fetchCurrencyRatesFromAPIWithBlock:nil];
}

@end
