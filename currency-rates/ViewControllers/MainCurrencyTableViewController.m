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

@end

@implementation MainCurrencyTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currencies = [CurrencyRate getAllCurrencyRates];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.currencies count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"MainCurrencyListCell";
    CurrencyRate *currencyRate = [self.currencies objectAtIndex:indexPath.row];
    MainCurrencyTableViewCell *cell = (MainCurrencyTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil][0];
    }
    
    cell.mainCurrencyName.text = currencyRate.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [CurrencyRate setMainCurrencyRate:self.currencies[[indexPath row]]];
}

@end
