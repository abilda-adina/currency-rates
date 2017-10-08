//
//  SettingsViewController.m
//  currency-rates
//
//  Created by Adina Abilda on 08.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import "SettingsViewController.h"
#import "CurrencyRate.h"
#import "FavoriteCurrenciesTableViewCell.h"

@interface SettingsViewController ()

@property NSArray *favoriteCurrencies;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.favoriteCurrencies = [CurrencyRate getAllCurrencyRates];
}

- (void)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.favoriteCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"FavoriteCurrency";
    CurrencyRate *currencyRate = [self.favoriteCurrencies objectAtIndex:indexPath.row];
    FavoriteCurrenciesTableViewCell *cell = (FavoriteCurrenciesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    
    cell.name.text = currencyRate.name;
    
    return cell;
}

@end
