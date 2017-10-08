//
//  APIClient.h
//  currency-rates
//
//  Created by Adina Abilda on 07.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface APIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
