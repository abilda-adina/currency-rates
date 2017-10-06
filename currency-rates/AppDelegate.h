//
//  AppDelegate.h
//  currency-rates
//
//  Created by Adina Abilda on 06.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

