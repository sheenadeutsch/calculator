//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sheena Deutsch on 7/10/13.
//  Copyright (c) 2013 Sheena Deutsch. All rights reserved.
//

//include the cal .h file and calbrain .h file
#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

//@interface is a private property? 
@interface CalculatorViewController()

//@property auto setter and getter
// nonatomic means thread safe
@property (nonatomic) BOOL UserIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (weak, nonatomic) IBOutlet UILabel *display;

@end

//definitions of methods after @implementation
@implementation CalculatorViewController

//@synthesize implements properties for us that we dont set in setter and getter.  
//You don't want to name property and vaiable the same = bugs.
@synthesize display = _display;
@synthesize UserIsInTheMiddleOfEnteringANumber = _UserIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize history = _history;

-(CalculatorBrain *)brain;
{
    //alloc (allocation): heap allocation for a new object is done by the NSObject class method + (id)alloc.  It allocates enough space for all the instance variables.  init(initializing) classes can have multiple, different initalizers in addition to plain init.  both alloc and init must ahppen on right after the other.
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}
//instance methods start with "-"
- (IBAction)digitPressed:(UIButton *)sender
{
    //declaring a variable called "digit" and sending to sender??
    NSString *digit = sender.currentTitle;
    if (self.UserIsInTheMiddleOfEnteringANumber) {
    self.display.text = [self.display.text stringByAppendingString:digit];
    }else{
        self.display.text = digit;
        self.UserIsInTheMiddleOfEnteringANumber = YES;
    }
    self.history.text = self.history.text = [self.history.text stringByAppendingString:digit];
}
- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.UserIsInTheMiddleOfEnteringANumber) [self enterPressed];
    double result = [self.brain performOperation:sender.currentTitle];
                                                  NSString *resultString = [NSString stringWithFormat:@"%g", result];
                                                  self.display.text = resultString;
}
- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.UserIsInTheMiddleOfEnteringANumber = NO;
    self.history.text = [self.history.text stringByAppendingString:@" "];
    self.history.text = [self.history.text stringByAppendingString:self.display.text];
    
}

- (IBAction)clearPressed:(UIButton *)sender
{
    self.display.text = @"0";
    self.history.text = @"0";
    self.UserIsInTheMiddleOfEnteringANumber = NO;
    [self.brain emptyStack];
}
- (IBAction)backspacePressed:(UIButton *)sender
{
    self.display.text = [self.display.text substringToIndex:[self.display.text length] -1];
    self.history.text = [self.history.text substringToIndex:[self.history.text length] -1];
}

@end
