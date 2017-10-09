//
//  ViewController.m
//  currency-rates
//
//  Created by Adina Abilda on 06.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import "CurrencyRateTableViewController.h"
#import "CurrencyRate.h"
#import "CurrencyListTableViewCell.h"
#import "SettingsViewController.h"

@interface CurrencyRateTableViewController ()

@property (nonatomic, strong) NSArray *currencies;
@property (nonatomic, strong) CurrencyRate *mainCurrency;

@end

@implementation CurrencyRateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [CurrencyRate fetchCurrencyRatesFromAPIWithBlock:^(BOOL success, NSError *error) {
        if (!error && success) {
            [self loadCurrencies];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadCurrencies];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CurrencyListCell";
    CurrencyRate *currencyRate = [self.currencies objectAtIndex:indexPath.row];
    CurrencyListTableViewCell *cell = (CurrencyListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    
    cell.currencyName.text = currencyRate.name;
    cell.currencyRate.text = [NSString stringWithFormat:@"%.2f", [self calculateCurrencyRate:currencyRate]];
    cell.mainCurrencySymbol.text = self.mainCurrency.name;

    return cell;
}

- (void)loadCurrencies {
    self.mainCurrency = [CurrencyRate getMainCurrencyRate];
    self.currencies = [CurrencyRate getFavoriteCurrencyRates];
    
    if ([self.currencies count] == 0) {
        self.currencies = [CurrencyRate getAllCurrencyRates];
    }
    
    [self.tableView reloadData];
}

- (double)calculateCurrencyRate:(CurrencyRate *)currencyRate {
    return self.mainCurrency.rate / currencyRate.rate;
}

@end
