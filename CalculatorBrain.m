//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Sheena Deutsch on 7/11/13.
//  Copyright (c) 2013 Sheena Deutsch. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain;
@synthesize operandStack = _operandStack;

-(NSMutableArray *)operandStack{
    if(!_operandStack){
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

-(void)emptyStack{
    _operandStack = nil;
}

-(void)pushOperand:(double)operand{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

-(double)popOperand{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

-(double)performOperation:(NSString *)operation{
    double result = 0;
    
    if ([operation isEqualToString:@"+"]) {
        result = [self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]){
        result = [self popOperand] * [self popOperand];
    } else if ([operation isEqualToString:@"-"]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([operation isEqualToString:@"/"]) {
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if ([operation isEqualToString:@"sin"]){
        result = sin([self popOperand]);
    } else if ([operation isEqualToString:@"cos"]){
        result = cos([self popOperand]);
    } else if ([operation isEqualToString:@"sqrt"]){
        result = sqrt([self popOperand]);
    } else if ([operation isEqualToString:@"π"]){
        result = [self popOperand] * M_PI;
    } else if ([operation isEqualToString:@"+/-"]){
        result = [self popOperand] * -1;
    }
    
    [self pushOperand:result];
    return result;
}



@end






//#import "CalculatorBrain.h"
//
//@interface CalculatorBrain()
//@property (nonatomic, strong) NSMutableArray *programStack;
//@end
//
//@implementation CalculatorBrain
//@synthesize programStack = _programStack;
//
//-(NSMutableArray *) programStack;
//{
//    if (!_programStack) {
//        _programStack = [[NSMutableArray alloc] init];
//    }
//    return _programStack;
//}
//
//-(void)emptyStack
//{
//    _programStack = nil;
//}
//
//
//-(void)pushOperand:(double)operand
//{
//    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
//    [self.programStack addObject:operandObject];
//}
//
//-(double)performOperation:(NSString *)operation
//{
//    [self.programStack addObject:operation];
//    return[CalculatorBrain runProgram:self.program];
//}
//
//-(id)program
//{
//    return [self.programStack copy];
//}
//
//+(NSString *)descriptionOfProgram:(id)program
//{
//    return @"Implement in assignment two @";
//}
//
//+(double)popOperandOffStack: (NSMutableArray *)stack
//{
//    double result = 0;
//    
//    id topOfStack = [stack lastObject];
//    if (topOfStack) [stack removeLastObject];
//    
//    if ([topOfStack isKindOfClass:[NSNumber class]]) {
//        result = [topOfStack doubleValue];
//    }else if ([topOfStack isKindOfClass:[NSString class]]) {
//        NSString *operation = topOfStack;
//        if ([operation isEqualToString:@"+"]) {
//            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
//        } else if ([@"*" isEqualToString:operation]){
//            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
//        } else if ([operation isEqualToString:@"-"]){
//            double subtrahend = [self popOperandOffStack:stack];
//            result = [self popOperandOffStack:stack] - subtrahend;
//        } else if ([operation isEqualToString:@"/"]) {
//            double divisor = [self popOperandOffStack:stack];
//            if (divisor) result = [self popOperandOffStack:stack] / divisor;
//        } else if ([operation isEqualToString:@"sin"]){
//            result = sin([self popOperandOffStack:stack]);
//        } else if ([operation isEqualToString:@"cos"]){
//            result = cos([self popOperandOffStack:stack]);
//        } else if ([operation isEqualToString:@"sqrt"]){
//            result = sqrt([self popOperandOffStack:stack]);
//        } else if ([operation isEqualToString:@"π"]){
//            result = [self popOperandOffStack:stack] * M_PI;
//        } else if ([operation isEqualToString:@"+/="]){
//            result = [self popOperandOffStack:stack] * -1;
//        }
//    }
//    
//    return result;
//}
//
//+(double)runProgram:(id)program
//{
//    NSMutableArray *stack;
//    if ([program isKindOfClass:[NSMutableArray class]]){
//        stack = [program mutableCopy];
//    }
//    return[self popOperandOffStack:stack];
//}
//

