//
//  WMCityViewController.m
//  WeiMi
//
//  Created by Sin on 2018/4/14.
//  Copyright © 2018年 Sin. All rights reserved.
//

#import "WMCityViewController.h"
#import "WMCommonDefine.h"
#import "WMUIUtility.h"

@interface WMCityViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSDictionary *originData;
@property (nonatomic,strong) NSArray *keys;
@property (nonatomic,strong) NSMutableArray *searchData;
@end

@implementation WMCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    self.title = @"城市列表";
    self.searchData = [NSMutableArray new];
    [self loadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.searchData.count > 0) {
        return 1;
    }
    return self.originData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.searchData.count > 0) {
        return self.searchData.count;
    }
    NSString *key = self.keys[section];
    NSArray *arr = [self.originData valueForKey:key];
    return arr.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(self.searchData.count > 0) {
        return @"";
    }
    return self.keys[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(self.searchData.count > 0) {
        return 1;
    }
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    NSString *text = nil;
    if(self.searchData.count > 0) {
        text = self.searchData[indexPath.row];
    }else {
        NSString *key = self.keys[indexPath.section];
        NSArray *arr = [self.originData valueForKey:key];
        text = arr[indexPath.row];
    }
    cell.textLabel.text = text;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%s",__func__);
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self.searchData removeAllObjects];
    for(NSString *key in self.originData.allKeys) {
        NSArray *arr = [self.originData valueForKey:key];
        for(NSString *address in arr) {
            if([address containsString:searchText]) {
                [self.searchData addObject:address];
            }
        }
    }
    [self.tableView reloadData];
}

- (void)loadData {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"citydict.plist" ofType:nil];
    self.originData = [[NSDictionary alloc] initWithContentsOfFile:path];
    self.keys = [self sortKeys:self.originData.allKeys];
}

- (NSArray *)sortKeys:(NSArray *)keys {
    NSMutableArray *result = [keys mutableCopy];
    for(int i=0;i<result.count;i++) {
        for (int j=0; j<result.count-1-i; j++) {
            if(result[j] > result[j+1]) {
                NSString *tmp = result[j];
                result[j] = result[j+1];
                result[j+1] = tmp;
            }
        }
    }
    return [result copy];
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView  = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.searchBar;
    }
    return _tableView;
}

- (UISearchBar *)searchBar {
    if(!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:WM_CGRectMake(0, 0, Screen_Width, 44)];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索";
        _searchBar.backgroundImage = [UIImage new];
    }
    return _searchBar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
