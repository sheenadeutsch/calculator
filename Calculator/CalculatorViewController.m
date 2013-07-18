//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Sheena Deutsch on 7/10/13.
//  Copyright (c) 2013 Sheena Deutsch. All rights reserved.
//

//include the calculator.h file and calculatorBrain.h file
#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

//@interface is a declaration of what your class can do, visalble to other classes, so other classes can call on methods and access properties of this class?  things defined in @interface of .m file are private. @interface says here comes a class.  Declare instance variables and declare methods under @interface

@interface CalculatorViewController()

//@property auto setter and getter
// nonatomic means not thread safe
@property (nonatomic) BOOL UserIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (weak, nonatomic) IBOutlet UILabel *history;
@property (nonatomic) BOOL userIsTypingFloatPointNumber;

@end

//definitions of methods after @implementation
@implementation CalculatorViewController

//@synthesize implements properties for us that we dont set in setter and getter.  
//You don't want to name property and vaiables the same = bugs.
@synthesize UserIsInTheMiddleOfEnteringANumber = _UserIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;
@synthesize history = _history;
@synthesize display = _display;
@synthesize userIsTypingFloatPointNumber = _userIsTypingFloatPointNumber;

-(CalculatorBrain *)brain;
{
    //alloc (allocation): heap allocation for a new object is done by the NSObject class method + (id)alloc.  It allocates enough space for all the instance variables.  init(initializing) classes can have multiple, different initalizers in addition to plain init.  both alloc and init must happen one right after the other.
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}
//instance methods start with "-"
- (IBAction)digitPressed:(UIButton *)sender
{
    //declaring a variable called "digit" and sending to sender??
    NSString *digit = sender.currentTitle;
    NSLog(@"Digit pressed %@", digit);
    //check if there is a . already in the number inside display label
    NSRange isNumberDecimal = [self.display.text rangeOfString:@"."];
    if (self.UserIsInTheMiddleOfEnteringANumber){
        //if user pressed . button
        if([digit isEqualToString:@"."]){
            if (isNumberDecimal.location == NSNotFound) {
                self.display.text=[self.display.text stringByAppendingString:digit];
            }
       }else{//user did not press . button
           self.display.text =[self.display.text stringByAppendingString:digit];
        }
    }else {
        //if user start with . assume the number starts with 0.
        if ([digit isEqualToString:@"."]) {digit=@"0.";}
        self.display.text=digit;
        self.UserIsInTheMiddleOfEnteringANumber=YES;
    }
//the following code produces 2 of each digit pressed to be displayed in "display"
//    if (self.UserIsInTheMiddleOfEnteringANumber) {
//    self.display.text = [self.display.text stringByAppendingString:digit];
//    }else{
//        self.display.text = digit;
//        self.UserIsInTheMiddleOfEnteringANumber = YES;
//    }
    self.history.text = self.history.text = [self.history.text stringByAppendingString:digit];
}
- (IBAction)operationPressed:(UIButton *)sender
{
    if (self.UserIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}
- (IBAction)enterPressed
{
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.UserIsInTheMiddleOfEnteringANumber = NO;
    }

- (IBAction)clearPressed:(UIButton *)sender
{
   self.history.text = @"";
    self.display.text = @"0";
    _UserIsInTheMiddleOfEnteringANumber = NO;
    [self.brain emptyStack];
}
- (IBAction)backspacePressed:(UIButton *)sender
{
    self.display.text = [self.display.text substringToIndex:[self.display.text length] -1];
    self.history.text = [self.history.text substringToIndex:[self.history.text length] -1];
}

@end
