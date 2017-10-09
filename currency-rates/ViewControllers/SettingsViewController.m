//
//  SettingsViewController.m
//  currency-rates
//
//  Created by Adina Abilda on 08.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import "SettingsViewController.h"
#import "CurrencyRate.h"
#import "SettingsFavoriteTableViewCell.h"
@interface SettingsViewController ()

@property NSArray *favoriteCurrencies;

@end

@implementation SettingsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mainCurrencyLabel.text = [CurrencyRate getMainCurrencyRate].name;
    self.favoriteCurrencies = [CurrencyRate getFavoriteCurrencyRates];
    [self.favoriteCurrenciesTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.favoriteCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"settingsFavoriteCell";
    CurrencyRate *currencyRate = [self.favoriteCurrencies objectAtIndex:indexPath.row];
    SettingsFavoriteTableViewCell *cell = (SettingsFavoriteTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    
    cell.favoriteCurrencyName.text = currencyRate.name;
    
    return cell;
}

- (void)setNavBarBackButton {
    UIBarButtonItem* backBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithTitle:@"Back"
                                              style:UIBarButtonItemStylePlain
                                              target:self
                                              action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = backBarButtonItem;
}

- (void)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
