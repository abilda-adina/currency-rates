//
//  FavoriteCurrencyTableViewController.m
//  currency-rates
//
//  Created by Adina Abilda on 09.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import "FavoriteCurrencyTableViewController.h"
#import "CurrencyRate.h"
#import "FavoriteCurrenciesTableViewCell.h"

@interface FavoriteCurrencyTableViewController ()

@property (nonatomic, strong) NSArray *currencies;

@end

@implementation FavoriteCurrencyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currencies = [CurrencyRate getAllCurrencyRates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"favoriteCurrencyCell";
    CurrencyRate *currencyRate = [self.currencies objectAtIndex:indexPath.row];
    FavoriteCurrenciesTableViewCell *cell = (FavoriteCurrenciesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    
    cell.name.text = currencyRate.name;
    cell.accessoryType = currencyRate.favorite ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    FavoriteCurrenciesTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CurrencyRate *currencyRate = self.currencies[[indexPath row]];
    
    if ([currencyRate toggleFavorite]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

@end
