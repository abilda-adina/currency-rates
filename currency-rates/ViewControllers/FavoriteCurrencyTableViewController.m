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
@property (nonatomic, strong) NSArray *filteredCurrencies;
@property (strong, nonatomic) IBOutlet UITableView *currenciesTable;

@end

@implementation FavoriteCurrencyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currencies = [CurrencyRate getAllCurrencyRates];
    self.filteredCurrencies = self.currencies;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"favoriteCurrencyCell";
    CurrencyRate *currencyRate = [self.filteredCurrencies objectAtIndex:indexPath.row];
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
    CurrencyRate *currencyRate = self.filteredCurrencies[[indexPath row]];
    
    if ([currencyRate toggleFavorite]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (NSArray *)filterCurrenciesWithText:(NSString *)filterText {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", filterText];
    return [self.currencies filteredArrayUsingPredicate:predicate];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        self.filteredCurrencies = self.currencies;
    } else {
        self.filteredCurrencies = [self filterCurrenciesWithText:searchText];
    }
    [self.currenciesTable reloadData];
}

@end
