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
    currencyRate.favorite = NO;
    
    return currencyRate;
}

+ (NSArray *)getCurrencyRatesWithFilter:(NSString *)filter {
    NSMutableArray *result = [NSMutableArray array];
    FMDatabase *database = [DBManager getDatabase];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM currencyrate %@;", filter ? filter : @""];
    
    FMResultSet *resultSet = [database executeQuery:query];
    
    while ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"name"];
        double rate = [resultSet doubleForColumn:@"rate"];
        NSDate *ts = [resultSet dateForColumn:@"ts"];
        BOOL favorite = [resultSet boolForColumn:@"favorite"];
        
        CurrencyRate *currencyRate = [CurrencyRate initWithName:name WithRate:rate WithTS:ts];
        currencyRate.favorite = favorite;
        
        [result addObject:currencyRate];
    }
    
    return [NSArray arrayWithArray:result];
}

+ (NSArray *)getAllCurrencyRates {
    return [CurrencyRate getCurrencyRatesWithFilter:nil];
}

+ (NSArray *)getFavoriteCurrencyRates {
    return [CurrencyRate getCurrencyRatesWithFilter:@"WHERE favorite = 1"];
}

+(CurrencyRate *)getCurrencyRateWithName:(NSString *)name {
    FMDatabase *database = [DBManager getDatabase];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM currencyrate WHERE name = '%@';", name];
    
    FMResultSet *resultSet = [database executeQuery:query];
    
    if ([resultSet next]) {
        NSString *name = [resultSet stringForColumn:@"name"];
        double rate = [resultSet doubleForColumn:@"rate"];
        NSDate *ts = [resultSet dateForColumn:@"ts"];
        BOOL favorite = [resultSet boolForColumn:@"favorite"];
        
        CurrencyRate *currencyRate = [CurrencyRate initWithName:name WithRate:rate WithTS:ts];
        currencyRate.favorite = favorite;
        return currencyRate;
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

+ (CurrencyRate *)getMainCurrencyRate {
    NSString *mainCurrencyName = [[NSUserDefaults standardUserDefaults] stringForKey:@"mainCurrency"];
    
    if (!mainCurrencyName) {
        mainCurrencyName = @"USD";
    }
    
    return [CurrencyRate getCurrencyRateWithName:mainCurrencyName];
}

+ (void)setMainCurrencyRate:(CurrencyRate *)currencyRate {
    [[NSUserDefaults standardUserDefaults] setObject:currencyRate.name forKey:@"mainCurrency"];
}

- (BOOL)toggleFavorite {
    self.favorite = !self.favorite;
    FMDatabase *database = [DBManager getDatabase];
    
    NSString *query = [NSString stringWithFormat:@"UPDATE currencyrate SET favorite = %d WHERE name = '%@';", self.favorite, self.name];
    
    BOOL success = [database executeUpdate:query];
    
    if (!success) {
        self.favorite = !self.favorite;
    }
    
    return self.favorite;
}

@end
