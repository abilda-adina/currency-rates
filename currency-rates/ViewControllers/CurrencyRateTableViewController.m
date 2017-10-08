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

@end

@implementation CurrencyRateTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.currencies = [CurrencyRate getAllCurrencyRates];
    
    [CurrencyRate fetchCurrencyRatesFromAPIWithBlock:^(BOOL success, NSError *error) {
        if (!error && success) {
            self.currencies = [CurrencyRate getAllCurrencyRates];
            
            [self.tableView reloadData];
        }
    }];
    //[self setNavBarRightButton];
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
    cell.currencyRate.text = [NSString stringWithFormat:@"%.2f", currencyRate.rate];

    return cell;
}

//- (void)setNavBarRightButton {
//    UIBarButtonItem* settingsBarButtonItem = [[UIBarButtonItem alloc]
//                                              initWithTitle:@"Settings"
//                                              style:UIBarButtonItemStylePlain
//                                              target:self
//                                              action:@selector(openSettings:)];
//    self.navigationItem.rightBarButtonItem = settingsBarButtonItem;
//}
//- (void)openSettings:(id)sender {
//    SettingsViewController *settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
//    [self presentViewController:settingsViewController animated:YES completion:nil];
//}

@end
