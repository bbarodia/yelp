//
//  FilterViewController.m
//  Yelp
//
//  Created by Biren Barodia on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "FilterViewController.h"
#import "SwitchCell.h"
#import "SortTableViewCell.h"

@interface FilterViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SortCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *filtersTableView;
@property (nonatomic, strong) NSDictionary *filters;
@property (nonatomic, strong) NSMutableSet *selectedFilters;
@property (nonatomic, strong) NSArray *filtersDictionary;

- (void)initCategories;
- (void) removeObjectsWithNameKeyFromSelectedFilters: (NSString *) key ;
@end

@implementation FilterViewController

- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nil];
    
    if (self) {
        self.selectedFilters = [NSMutableSet set];
        [self initCategories];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *applyButton = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStyleBordered target:self action:@selector(onApply)];
    self.navigationItem.leftBarButtonItem = applyButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(onCancel)];
    self.navigationItem.leftBarButtonItem = applyButton;
    self.navigationItem.rightBarButtonItem = cancelButton;
    self.filtersTableView.dataSource = self;
    self.filtersTableView.delegate = self;
    [self.filtersTableView registerNib:[UINib nibWithNibName:@"SortTableViewCell" bundle:nil] forCellReuseIdentifier:@"sortByCell"];

    [self.filtersTableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    // Do any additional setup after loading the view from its nib.
}


     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *typeSection =  self.filtersDictionary[section][@"value"];
    return typeSection.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.filtersDictionary.count;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.filtersDictionary[section][@"name"];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *returnCell = [[UITableViewCell alloc] init];
    NSString *sectionName = [NSString stringWithFormat:@"%@",self.filtersDictionary[indexPath.section][@"name"]];
    NSLog(@"%ld", (long)indexPath.section);
    if ([sectionName isEqualToString:@"Sort"] || [sectionName isEqualToString:@"Proximity"] ) {
        SortTableViewCell *sortBy = [self.filtersTableView dequeueReusableCellWithIdentifier:@"sortByCell"];
        sortBy.delegate = self;
        NSDictionary *section =self.filtersDictionary[indexPath.section];
        [sortBy setSortByDictionary:section[@"value"] :NO animated:NO];
        returnCell = sortBy;

    } else
    {
        SwitchCell *switchCell = [self.filtersTableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        switchCell.delegate = self;
        switchCell.filterLabel.text = self.filtersDictionary[indexPath.section][@"value"][indexPath.row][@"name"];
        switchCell.on = [self.selectedFilters containsObject:self.filtersDictionary[indexPath.section][@"value"][indexPath.row]];
        returnCell = switchCell;
    }
    return returnCell;
    
}

- (void) sortTableViewCell:(SortTableViewCell *)cell didChangeSelection:(NSString *)value {
    NSIndexPath *indexPAth = [self.filtersTableView indexPathForCell:cell];
    NSLog(@" got %@", value);
    [self removeObjectsWithNameKeyFromSelectedFilters:self.filtersDictionary[indexPAth.section][@"name"]];
    if (value) {
        [self.selectedFilters addObject:@{@"name" : self.filtersDictionary[indexPAth.section][@"name"], @"value" : value}];
    }
    NSLog(@" dictionary %@", self.selectedFilters);

}

- (void) switchCell:(SwitchCell *)cell didUpdateSwitch:(BOOL)value {
    NSIndexPath *indexPAth = [self.filtersTableView indexPathForCell:cell];
    if (value) {
        [self.selectedFilters addObject:@{@"name" : self.filtersDictionary[indexPAth.section][@"name"], @"value" : self.filtersDictionary[indexPAth.section][@"value"][indexPAth.row]}];
    } else {
        [self.selectedFilters removeObject:@{@"name" : self.filtersDictionary[indexPAth.section][@"name"], @"value" : self.filtersDictionary[indexPAth.section][@"value"][indexPAth.row]}];
    }
}

- (void) onCancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) removeObjectsWithNameKeyFromSelectedFilters: (NSString *) key {
    for (NSDictionary *category in self.selectedFilters) {
        if ([category[@"name"] isEqualToString:key]){
            [self.selectedFilters removeObject:category];
            break;
        }
    }
}

- (NSDictionary *) filters {
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    NSNumber *radius = [NSNumber numberWithInt:1000];
    NSNumber *sortCode = [NSNumber numberWithInt:0];
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    BOOL deals = NO;
    if (self.selectedFilters.count > 0 ) {
        NSMutableArray *categoryArray = [NSMutableArray array];
        
        for (NSDictionary *category in self.selectedFilters) {
            if ([category[@"name"] isEqualToString:@"Category"] ) {
              [categoryArray addObject:category[@"value"][@"code"]];
            } else if ([category[@"name"] isEqualToString:@"Sort"] ) {
              sortCode = category[@"value"];
            } else if ([category[@"name"] isEqualToString:@"Deals"]) {
              deals = YES;
            } else if ([category[@"name"] isEqualToString:@"Proximity"]) {
                radius = category[@"value"];
            }
        }
        
        NSString *filterString = [categoryArray componentsJoinedByString:@", "];
        [filters setValue:[NSNumber numberWithBool:deals] forKey:@"deals_filter"];
        [filters setValue:radius forKey:@"radius_filter"];
        [filters setValue:sortCode forKey:@"sort"];
        if (![filterString isEqual:nil]) {
        [filters setObject:filterString forKey:@"category_filter"];
        }
    }
    return filters;
}


- (void) onApply {
    NSLog(@"Apply Button Clicked");
    [self.delegate filtersViewController:self didChangeFilters:self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void) initCategories {
    
    self.filtersDictionary =@[  @{@"name" : @"Proximity", @"value" : @{@"name" : @[@{@"name" : @"0.3 miles", @"code" : @"483"},
                                                                                   @{@"name" : @"1 mile", @"code" : @"1610"},
                                                                                   @{@"name" : @"5 miles", @"code" : @"8047"},
                                                                                   @{@"name" : @"15 miles", @"code" : @"24140"}]}},
                                @{@"name" : @"Deals",     @"value" : @[@{@"name" : @"Deals", @"code" : @"on"}] },
                                @{@"name" : @"Sort" ,     @"value" : @{@"name" : @[@{@"name" : @"Distance", @"code" : @"1"},
                                                                       @{@"name" : @"Best Match", @"code" : @"0"},
                                                                       @{@"name" : @"highest rated", @"code" : @"2"}]}},
                                @{@"name" : @"Category", @"value"  : @[@{@"name" : @"Afghan", @"code": @"afghani" },
                                                                       @{@"name" : @"American, New", @"code": @"newamerican" },
                                                                       @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                                                                       @{@"name" : @"Arabian", @"code": @"arabian" },
                                                                       @{@"name" : @"African", @"code": @"african" }]}];
  
                        /*  @[@{@"name" : @"Afghan", @"code": @"afghani" },
                            @{@"name" : @"African", @"code": @"african" },
                            @{@"name" : @"American, New", @"code": @"newamerican" },
                            @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                            @{@"name" : @"Arabian", @"code": @"arabian" },
                            @{@"name" : @"Argentine", @"code": @"argentine" },
                            @{@"name" : @"Armenian", @"code": @"armenian" },
                            @{@"name" : @"Asian Fusion", @"code": @"asianfusion" },
                            @{@"name" : @"Asturian", @"code": @"asturian" },
                            @{@"name" : @"Australian", @"code": @"australian" },
                            @{@"name" : @"Austrian", @"code": @"austrian" },
                            @{@"name" : @"Baguettes", @"code": @"baguettes" },
                            @{@"name" : @"Bangladeshi", @"code": @"bangladeshi" },
                            @{@"name" : @"Barbeque", @"code": @"bbq" },
                            @{@"name" : @"Basque", @"code": @"basque" },
                            @{@"name" : @"Bavarian", @"code": @"bavarian" },
                            @{@"name" : @"Beer Garden", @"code": @"beergarden" },
                            @{@"name" : @"Beer Hall", @"code": @"beerhall" },
                            @{@"name" : @"Beisl", @"code": @"beisl" },
                            @{@"name" : @"Belgian", @"code": @"belgian" },
                            @{@"name" : @"Bistros", @"code": @"bistros" },
                            @{@"name" : @"Black Sea", @"code": @"blacksea" },
                            @{@"name" : @"Brasseries", @"code": @"brasseries" },
                            @{@"name" : @"Brazilian", @"code": @"brazilian" },
                            @{@"name" : @"Breakfast & Brunch", @"code": @"breakfast_brunch" },
                            @{@"name" : @"British", @"code": @"british" },
                            @{@"name" : @"Buffets", @"code": @"buffets" },
                            @{@"name" : @"Bulgarian", @"code": @"bulgarian" },
                            @{@"name" : @"Burgers", @"code": @"burgers" },
                            @{@"name" : @"Burmese", @"code": @"burmese" },
                            @{@"name" : @"Cafes", @"code": @"cafes" },
                            @{@"name" : @"Cafeteria", @"code": @"cafeteria" },
                            @{@"name" : @"Cajun/Creole", @"code": @"cajun" },
                            @{@"name" : @"Cambodian", @"code": @"cambodian" },
                            @{@"name" : @"Canadian", @"code": @"New)" },
                            @{@"name" : @"Canteen", @"code": @"canteen" },
                            @{@"name" : @"Caribbean", @"code": @"caribbean" },
                            @{@"name" : @"Catalan", @"code": @"catalan" },
                            @{@"name" : @"Chech", @"code": @"chech" },
                            @{@"name" : @"Cheesesteaks", @"code": @"cheesesteaks" },
                            @{@"name" : @"Chicken Shop", @"code": @"chickenshop" },
                            @{@"name" : @"Chicken Wings", @"code": @"chicken_wings" },
                            @{@"name" : @"Chilean", @"code": @"chilean" },
                            @{@"name" : @"Chinese", @"code": @"chinese" },
                            @{@"name" : @"Comfort Food", @"code": @"comfortfood" },
                            @{@"name" : @"Corsican", @"code": @"corsican" },
                            @{@"name" : @"Creperies", @"code": @"creperies" },
                            @{@"name" : @"Cuban", @"code": @"cuban" },
                            @{@"name" : @"Curry Sausage", @"code": @"currysausage" },
                            @{@"name" : @"Cypriot", @"code": @"cypriot" },
                            @{@"name" : @"Czech", @"code": @"czech" },
                            @{@"name" : @"Czech/Slovakian", @"code": @"czechslovakian" },
                            @{@"name" : @"Danish", @"code": @"danish" },
                            @{@"name" : @"Delis", @"code": @"delis" },
                            @{@"name" : @"Diners", @"code": @"diners" },
                            @{@"name" : @"Dumplings", @"code": @"dumplings" },
                            @{@"name" : @"Eastern European", @"code": @"eastern_european" },
                            @{@"name" : @"Ethiopian", @"code": @"ethiopian" },
                            @{@"name" : @"Fast Food", @"code": @"hotdogs" },
                            @{@"name" : @"Filipino", @"code": @"filipino" },
                            @{@"name" : @"Fish & Chips", @"code": @"fishnchips" },
                            @{@"name" : @"Fondue", @"code": @"fondue" },
                            @{@"name" : @"Food Court", @"code": @"food_court" },
                            @{@"name" : @"Food Stands", @"code": @"foodstands" },
                            @{@"name" : @"French", @"code": @"french" },
                            @{@"name" : @"French Southwest", @"code": @"sud_ouest" },
                            @{@"name" : @"Galician", @"code": @"galician" },
                            @{@"name" : @"Gastropubs", @"code": @"gastropubs" },
                            @{@"name" : @"Georgian", @"code": @"georgian" },
                            @{@"name" : @"German", @"code": @"german" },
                            @{@"name" : @"Giblets", @"code": @"giblets" },
                            @{@"name" : @"Gluten-Free", @"code": @"gluten_free" },
                            @{@"name" : @"Greek", @"code": @"greek" },
                            @{@"name" : @"Halal", @"code": @"halal" },
                            @{@"name" : @"Hawaiian", @"code": @"hawaiian" },
                            @{@"name" : @"Heuriger", @"code": @"heuriger" },
                            @{@"name" : @"Himalayan/Nepalese", @"code": @"himalayan" },
                            @{@"name" : @"Hong Kong Style Cafe", @"code": @"hkcafe" },
                            @{@"name" : @"Hot Dogs", @"code": @"hotdog" },
                            @{@"name" : @"Hot Pot", @"code": @"hotpot" },
                            @{@"name" : @"Hungarian", @"code": @"hungarian" },
                            @{@"name" : @"Iberian", @"code": @"iberian" },
                            @{@"name" : @"Indian", @"code": @"indpak" },
                            @{@"name" : @"Indonesian", @"code": @"indonesian" },
                            @{@"name" : @"International", @"code": @"international" },
                            @{@"name" : @"Irish", @"code": @"irish" },
                            @{@"name" : @"Island Pub", @"code": @"island_pub" },
                            @{@"name" : @"Israeli", @"code": @"israeli" },
                            @{@"name" : @"Italian", @"code": @"italian" },
                            @{@"name" : @"Japanese", @"code": @"japanese" },
                            @{@"name" : @"Jewish", @"code": @"jewish" },
                            @{@"name" : @"Kebab", @"code": @"kebab" },
                            @{@"name" : @"Korean", @"code": @"korean" },
                            @{@"name" : @"Kosher", @"code": @"kosher" },
                            @{@"name" : @"Kurdish", @"code": @"kurdish" },
                            @{@"name" : @"Laos", @"code": @"laos" },
                            @{@"name" : @"Laotian", @"code": @"laotian" },
                            @{@"name" : @"Latin American", @"code": @"latin" },
                            @{@"name" : @"Live/Raw Food", @"code": @"raw_food" },
                            @{@"name" : @"Lyonnais", @"code": @"lyonnais" },
                            @{@"name" : @"Malaysian", @"code": @"malaysian" },
                            @{@"name" : @"Meatballs", @"code": @"meatballs" },
                            @{@"name" : @"Mediterranean", @"code": @"mediterranean" },
                            @{@"name" : @"Mexican", @"code": @"mexican" },
                            @{@"name" : @"Middle Eastern", @"code": @"mideastern" },
                            @{@"name" : @"Milk Bars", @"code": @"milkbars" },
                            @{@"name" : @"Modern Australian", @"code": @"modern_australian" },
                            @{@"name" : @"Modern European", @"code": @"modern_european" },
                            @{@"name" : @"Mongolian", @"code": @"mongolian" },
                            @{@"name" : @"Moroccan", @"code": @"moroccan" },
                            @{@"name" : @"New Zealand", @"code": @"newzealand" },
                            @{@"name" : @"Night Food", @"code": @"nightfood" },
                            @{@"name" : @"Norcinerie", @"code": @"norcinerie" },
                            @{@"name" : @"Open Sandwiches", @"code": @"opensandwiches" },
                            @{@"name" : @"Oriental", @"code": @"oriental" },
                            @{@"name" : @"Pakistani", @"code": @"pakistani" },
                            @{@"name" : @"Parent Cafes", @"code": @"eltern_cafes" },
                            @{@"name" : @"Parma", @"code": @"parma" },
                            @{@"name" : @"Persian/Iranian", @"code": @"persian" },
                            @{@"name" : @"Peruvian", @"code": @"peruvian" },
                            @{@"name" : @"Pita", @"code": @"pita" },
                            @{@"name" : @"Pizza", @"code": @"pizza" },
                            @{@"name" : @"Polish", @"code": @"polish" },
                            @{@"name" : @"Portuguese", @"code": @"portuguese" },
                            @{@"name" : @"Potatoes", @"code": @"potatoes" },
                            @{@"name" : @"Poutineries", @"code": @"poutineries" },
                            @{@"name" : @"Pub Food", @"code": @"pubfood" },
                            @{@"name" : @"Rice", @"code": @"riceshop" },
                            @{@"name" : @"Romanian", @"code": @"romanian" },
                            @{@"name" : @"Rotisserie Chicken", @"code": @"rotisserie_chicken" },
                            @{@"name" : @"Rumanian", @"code": @"rumanian" },
                            @{@"name" : @"Russian", @"code": @"russian" },
                            @{@"name" : @"Salad", @"code": @"salad" },
                            @{@"name" : @"Sandwiches", @"code": @"sandwiches" },
                            @{@"name" : @"Scandinavian", @"code": @"scandinavian" },
                            @{@"name" : @"Scottish", @"code": @"scottish" },
                            @{@"name" : @"Seafood", @"code": @"seafood" },
                            @{@"name" : @"Serbo Croatian", @"code": @"serbocroatian" },
                            @{@"name" : @"Signature Cuisine", @"code": @"signature_cuisine" },
                            @{@"name" : @"Singaporean", @"code": @"singaporean" },
                            @{@"name" : @"Slovakian", @"code": @"slovakian" },
                            @{@"name" : @"Soul Food", @"code": @"soulfood" },
                            @{@"name" : @"Soup", @"code": @"soup" },
                            @{@"name" : @"Southern", @"code": @"southern" },
                            @{@"name" : @"Spanish", @"code": @"spanish" },
                            @{@"name" : @"Steakhouses", @"code": @"steak" },
                            @{@"name" : @"Sushi Bars", @"code": @"sushi" },
                            @{@"name" : @"Swabian", @"code": @"swabian" },
                            @{@"name" : @"Swedish", @"code": @"swedish" },
                            @{@"name" : @"Swiss Food", @"code": @"swissfood" },
                            @{@"name" : @"Tabernas", @"code": @"tabernas" },
                            @{@"name" : @"Taiwanese", @"code": @"taiwanese" },
                            @{@"name" : @"Tapas Bars", @"code": @"tapas" },
                            @{@"name" : @"Tapas/Small Plates", @"code": @"tapasmallplates" },
                            @{@"name" : @"Tex-Mex", @"code": @"tex-mex" },
                            @{@"name" : @"Thai", @"code": @"thai" },
                            @{@"name" : @"Traditional Norwegian", @"code": @"norwegian" },
                            @{@"name" : @"Traditional Swedish", @"code": @"traditional_swedish" },
                            @{@"name" : @"Trattorie", @"code": @"trattorie" },
                            @{@"name" : @"Turkish", @"code": @"turkish" },
                            @{@"name" : @"Ukrainian", @"code": @"ukrainian" },
                            @{@"name" : @"Uzbek", @"code": @"uzbek" },
                            @{@"name" : @"Vegan", @"code": @"vegan" },
                            @{@"name" : @"Vegetarian", @"code": @"vegetarian" },
                            @{@"name" : @"Venison", @"code": @"venison" },
                            @{@"name" : @"Vietnamese", @"code": @"vietnamese" },
                            @{@"name" : @"Wok", @"code": @"wok" },
                            @{@"name" : @"Wraps", @"code": @"wraps" },
                            @{@"name" : @"Yugoslav", @"code": @"yugoslav" }];*/
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
