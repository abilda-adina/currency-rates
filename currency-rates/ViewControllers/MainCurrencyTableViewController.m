//
//  MainCurrencyTableViewController.m
//  currency-rates
//
//  Created by Adina Abilda on 09.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import "MainCurrencyTableViewController.h"
#import "CurrencyRate.h"
#import "MainCurrencyTableViewCell.h"

@interface MainCurrencyTableViewController ()

@property (nonatomic, strong) NSArray *currencies;
@property (nonatomic, strong) NSArray *filteredCurrencies;
@property (nonatomic, strong) CurrencyRate *mainCurrency;
@property (strong, nonatomic) IBOutlet UITableView *currenciesTable;

@end

@implementation MainCurrencyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currencies = [CurrencyRate getAllCurrencyRates];
    self.filteredCurrencies = self.currencies;
    self.mainCurrency = [CurrencyRate getMainCurrencyRate];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.filteredCurrencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"MainCurrencyListCell";
    CurrencyRate *currencyRate = [self.filteredCurrencies objectAtIndex:indexPath.row];
    MainCurrencyTableViewCell *cell = (MainCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    
    cell.mainCurrencyName.text = currencyRate.name;
    cell.accessoryType = self.mainCurrency.name == currencyRate.name ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MainCurrencyTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    CurrencyRate *selectedCurrencyRate = self.filteredCurrencies[[indexPath row]];
    NSInteger oldMainCurrencyIndex = [CurrencyRate indexOfCurrencyRate:self.mainCurrency InArray:self.filteredCurrencies];
    
    [CurrencyRate setMainCurrencyRate:selectedCurrencyRate];
    self.mainCurrency = selectedCurrencyRate;
    
    if (oldMainCurrencyIndex != -1) {
        MainCurrencyTableViewCell *oldCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:oldMainCurrencyIndex inSection:[indexPath section]]];
        
        oldCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
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
