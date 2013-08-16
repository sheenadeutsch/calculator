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
-(void)pushOperation:(NSString *)operation;
-(void)pushVariable:(NSString *)variable;
-(id)performOperation:(NSString *)operation;


//readonly makes it so you can only get the program, not set the program
@property (readonly) id program;

//takes a program and runs it, returns a double(pop the top thing off the stack and give it to me, and if the top thing on the stack is an operand, I just get the number)
+(id)runProgram:(id)program;
+(id)runProgram:(id)program usingVariableValues:(NSDictionary *)variableValues;
//going to return a human readable description of the program.(id comes from calling the getter of the program)
+(NSString *)descriptionOfProgram:(id)program;
+(NSSet *)variablesUsedInProgram:(id)program;
-(void)emptyStack;
-(void)clearTopOfStack;
-(void)removeLastItem;

@end