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
@property BOOL favorite;

+ (NSArray *)getCurrencyRatesWithFilter:(NSString *)filter;
+ (NSArray *)getAllCurrencyRates;
+ (NSArray *)getFavoriteCurrencyRates;
+ (NSURLSessionDataTask *)fetchCurrencyRatesFromAPIWithBlock:(void (^)(BOOL success, NSError *error))block;
+ (NSURLSessionDataTask *)fetchCurrencyRatesFromAPI;
+ (CurrencyRate *)getMainCurrencyRate;
+ (void)setMainCurrencyRate:(CurrencyRate *)currencyRate;
+ (NSInteger)indexOfCurrencyRate:(CurrencyRate *)currencyRate InArray:(NSArray *)currencyRates;
- (BOOL)toggleFavorite;
- (BOOL)isEqual:(CurrencyRate *)another;

@end
