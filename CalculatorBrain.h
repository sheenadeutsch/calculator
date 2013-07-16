//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Sheena Deutsch on 7/11/13.
//  Copyright (c) 2013 Sheena Deutsch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

//this is the getter and setter
-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;

-(void)emptyStack;

@end
