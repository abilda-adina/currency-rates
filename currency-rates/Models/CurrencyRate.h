//
//  CurrencyRate.h
//  currency-rates
//
//  Created by Adina Abilda on 07.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrencyRate : NSObject

@property (nonatomic, strong) NSString *name;
@property double rate;
@property (nonatomic, strong) NSDate *ts;

+ (NSArray *)getAllCurrencyRates;
+ (NSURLSessionDataTask *)fetchCurrencyRatesFromAPIWithBlock:(void (^)(BOOL success, NSError *error))block;
+ (NSURLSessionDataTask *)fetchCurrencyRatesFromAPI;

@end
