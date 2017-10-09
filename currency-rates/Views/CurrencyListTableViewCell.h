//
//  CurrencyListTableViewCell.h
//  currency-rates
//
//  Created by Adina Abilda on 08.10.17.
//  Copyright © 2017 Kenzhebekova. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CurrencyListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *currencyName;
@property (weak, nonatomic) IBOutlet UILabel *currencyRate;
@property (weak, nonatomic) IBOutlet UILabel *mainCurrencySymbol;

@end
