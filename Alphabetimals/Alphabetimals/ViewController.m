//
//  ViewController.m
//  Alphabetimals
//
//  Created by Mona Zhang on 2/23/15.
//  Copyright (c) 2015 Mona Zhang. All rights reserved.
//

#import "Alphabetimal.h"
#import "AATableViewCell.h"
#import "AATextField.h"


#import "SolutionViewController.h"

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

// Views
@property (nonatomic) UIBarButtonItem *rightBarButtonItem;
@property (nonatomic) UIButton *footerButton;
@property (nonatomic) AATableViewCell *textFieldTableViewCell; // Table view cell that displays selected alphabetimal name
// and accepts user input
@property (nonatomic) UITableView *tableView;
@property (nonatomic) AATextField *textField;                  // User can type into textfield to get an autocomplete
// list of animal names.

// Data Source
@property (nonatomic) NSArray *alphabetimalArray;              // Array of all Alphabetimals
@property (nonatomic) NSMutableArray *autocompleteAnimalArray; // Array of Alphabetimal display names from autocomplete
@property (nonatomic) Alphabetimal *selectedAlphabetimal;      // Current Alphabetimal selection from autocomplete table view

@end

@implementation ViewController

NSString * const CELL_IDENTIFER = @"ANIMAL_CELL";
NSString * const WILL_RELOAD = @"will reloadData";
NSString * const WILL_NOT_RESIGN = @"textfield won't resign";
NSString * const CLICK_TO_RELOAD = @"click to reload";
NSString * const CLICK_TO_KEEP_TYPING = @"click to keep typing";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    self.title = WILL_RELOAD;
    
    // Add tableview and register tableviewcell class
    [self.view addSubview:self.tableView];
    self.tableView.frame = self.view.frame;
    self.tableView.tableFooterView = self.footerButton;
    [self.tableView registerClass:[AATableViewCell class] forCellReuseIdentifier:CELL_IDENTIFER];
    
    // Load alphabetimal name to data source arrays
    [self loadData];
}

- (void)loadData {
    // Loads alphabetimal names and emojis from plist into a dictionary of alphabetimal names to alphabetimals
    // and an array of all animal names, to be used for autocomplete.
    
    NSString *animalsPlist = [[NSBundle mainBundle] pathForResource:@"alphabetimal" ofType:@"plist"];
    NSArray *plistArray = [[NSArray alloc] initWithContentsOfFile:animalsPlist];
    
    NSMutableArray *alphabetimalArray = [[NSMutableArray alloc] initWithCapacity:[plistArray count]];
    
    for (NSDictionary *animalDictionary in plistArray) {
        Alphabetimal *alphabetimal = [Alphabetimal alphabetimalWithDictionary:animalDictionary];
        [alphabetimalArray addObject:alphabetimal];
    }
    
    self.alphabetimalArray = alphabetimalArray;
}

#pragma mark - Properties

- (AATableViewCell *)textFieldTableViewCell {
    if (!_textFieldTableViewCell) {
        _textFieldTableViewCell = [[AATableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        [_textFieldTableViewCell addSubview:self.textField];
        [_textFieldTableViewCell addConstraint:[NSLayoutConstraint constraintWithItem:self.textField
                                                                                attribute:NSLayoutAttributeCenterX
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_textFieldTableViewCell
                                                                                attribute:NSLayoutAttributeCenterX
                                                                               multiplier:1.0
                                                                                 constant:0]];
        
        [_textFieldTableViewCell addConstraint:[NSLayoutConstraint constraintWithItem:self.textField
                                                                                attribute:NSLayoutAttributeCenterY
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_textFieldTableViewCell
                                                                                attribute:NSLayoutAttributeCenterY
                                                                               multiplier:1.0
                                                                                 constant:0]];
        [_textFieldTableViewCell addConstraint:[NSLayoutConstraint constraintWithItem:self.textField
                                                                                attribute:NSLayoutAttributeWidth
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_textFieldTableViewCell
                                                                                attribute:NSLayoutAttributeWidth
                                                                               multiplier:1.0
                                                                                 constant:-30]];
        [_textFieldTableViewCell addConstraint:[NSLayoutConstraint constraintWithItem:self.textField
                                                                                attribute:NSLayoutAttributeHeight
                                                                                relatedBy:NSLayoutRelationEqual
                                                                                   toItem:_textFieldTableViewCell
                                                                                attribute:NSLayoutAttributeHeight
                                                                               multiplier:1.0
                                                                                 constant:0]];
        [_textFieldTableViewCell setNeedsUpdateConstraints];

    }
    return _textFieldTableViewCell;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (UIButton *)footerButton {
    if (!_footerButton) {
        _footerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        [_footerButton setTitle:@"CLICK TO TYPE" forState:UIControlStateNormal];
        _footerButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:16];
        [_footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_footerButton setBackgroundColor:[UIColor colorWithRed:135/255.0 green:206/255.0 blue:255/255.0 alpha:1.0]];
        [_footerButton addTarget:self action:@selector(toggle:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerButton;
}

- (AATextField *)textField {
    if (!_textField) {
        _textField = [[AATextField alloc] init];
        _textFieldTableViewCell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0];
        _textFieldTableViewCell.layer.borderColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0].CGColor;
        _textFieldTableViewCell.layer.borderWidth = 1.0;
        _textFieldTableViewCell.layer.cornerRadius = 3.0;
        _textField.translatesAutoresizingMaskIntoConstraints = NO; // will be aligned to tableviewcell using autolayout constraints
        _textField.callSuperResignFirstResponder = YES;
        _textField.textAlignment = NSTextAlignmentCenter;
        _textField.delegate = self;
        _textField.font = [UIFont fontWithName:@"Avenir-Light" size:16];
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _textField;
}

- (NSMutableArray *)autocompleteAnimalArray {
    // Lazy initialize the autocomplete array so that messages are not sent to nil!
    if (!_autocompleteAnimalArray) {
        _autocompleteAnimalArray = [[NSMutableArray alloc] init];
    }
    return _autocompleteAnimalArray;
}

- (UIBarButtonItem *)rightBarButtonItem {
    if (!_rightBarButtonItem) {
        _rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Solution" style:UIBarButtonItemStylePlain target:self action:@selector(presentSolution)];
    }
    return _rightBarButtonItem;
}

#pragma mark - Property setters

- (void)setSelectedAlphabetimal:(Alphabetimal *)selectedAlphabetimal {
    _selectedAlphabetimal = selectedAlphabetimal;
    
    // Clear autocomplete array
    [_autocompleteAnimalArray removeAllObjects];
    if (selectedAlphabetimal == nil) {
        self.textFieldTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        self.textField.text = selectedAlphabetimal.displayName;
        self.textFieldTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    // Reload tableview so that selected animal name and emoji are displayed
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        if ([self.autocompleteAnimalArray count] == 0) {
            // User is not currently typing; no autocomplete
            // Display cell with prompt to start typing
            return 1;
        }
        // Return number of autocompleted animal names
        return [self.autocompleteAnimalArray count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTIFER]; // if I use the indexPath method, the first row will break. Why?
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            // Cell with text field is always in first section and row
            return self.textFieldTableViewCell;
        }
    } else if (indexPath.section == 1) {
        if ([self.autocompleteAnimalArray count] > 0) {
            // Display name of autocomplete animal at this index path
            cell.textLabel.text = ((Alphabetimal *)self.autocompleteAnimalArray[indexPath.row]).displayName;
        } else {
            cell.textLabel.textColor = [UIColor colorWithRed:135/255.0 green:206/255.0 blue:255/255.0 alpha:1.0];
            if (self.selectedAlphabetimal) {
                cell.textLabel.text = [@"Find another Alphabetimal!" uppercaseString];
            } else {
                cell.textLabel.text = [@"Start typing!" uppercaseString];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.autocompleteAnimalArray count] > 0) {
        self.selectedAlphabetimal = self.autocompleteAnimalArray[indexPath.row];
    } else {
        // If there is no autocomplete array, selecting the first row of the second section
        // should prompt the user to enter text in the textfield.
        if (indexPath.row == 0 && indexPath.section == 1) {
            [self.textField becomeFirstResponder];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.textFieldTableViewCell.accessoryType = UITableViewCellAccessoryNone; // Remove checkmark while in editing mode
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *textFieldString = [self.textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Clear selected alphabetimal if one is selected
    if (self.selectedAlphabetimal != nil) {
        self.selectedAlphabetimal = nil;
    }
    
    if (string.length == 0 && textField.text.length == 1) {
        // Clear autocomplete animal array on deletion of last character
        [self.autocompleteAnimalArray removeAllObjects];
    } else {
        // Use new text field string to reload the autocomplete animal array
        [self reloadAutoCompleteAnimalArrayFromString:textFieldString];
    }
    
    // Reload data after autocompleteAnimalArray has been updated
    [self.tableView reloadData];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    // Clear selected alphabetimal and autocomplete array
    self.selectedAlphabetimal = nil;
    [self.autocompleteAnimalArray removeAllObjects];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    // Display checkmark if user did not deselect alphabetimal after beginning and ending textfield edits
    if (self.selectedAlphabetimal) {
        self.textFieldTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
}

- (void)reloadAutoCompleteAnimalArrayFromString:(NSString *)string {
    // Find all alphabetimals with a name that starts with the current string in text field
    [self.autocompleteAnimalArray removeAllObjects];
    for (Alphabetimal *alphabetimal in self.alphabetimalArray) {
        NSString *animalDisplayName = alphabetimal.displayName;
        NSRange substringRange = [[animalDisplayName lowercaseString] rangeOfString:string];
        if (substringRange.location == 0) {
            [self.autocompleteAnimalArray addObject:alphabetimal];
        }
    }
}

- (void)toggle:(id)sender {
    self.textField.callSuperResignFirstResponder = !self.textField.callSuperResignFirstResponder;
    if (self.textField.callSuperResignFirstResponder) {
        self.title = WILL_RELOAD;
        [_footerButton setTitle:CLICK_TO_KEEP_TYPING forState:UIControlStateNormal];
    } else {
        self.title = WILL_NOT_RESIGN;
        [_footerButton setTitle:CLICK_TO_RELOAD forState:UIControlStateNormal];
    }
}

- (void)presentSolution {
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:[[SolutionViewController alloc] init]];
    [self presentViewController:controller animated:YES completion:nil];
}

@end
