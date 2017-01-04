//
//  Other.swift
//  Pods
//
//  Created by Mathias Quintero on 12/9/16.
//
//

import Foundation

/**
 Will return whatever you give it. Useful to replace '{ $0 }' and make the code more approachable and friendly ;)
 
 - Parameter value: value
 
 - Returns: value
 */
public func id<T>(_ value: T) -> T {
    return value
}

/**
 Will return the first argument you give it. Let type inference do what you need it to do. 
 (Be careful with type inference)
 
 - Parameter argOne: value
 - Parameter argTwo: value you want to ignore
 
 - Returns: argOne
 */
public func firstArgument<T, V>(_ argOne: T, _ argTwo: V) -> T {
    return argOne
}

/**
 Will return the last argument you give it. Let type inference do what you need it to do.
 (Be careful with type inference)
 
 - Parameter argOne: value you want to ignore
 - Parameter argTwo: value
 
 - Returns: argTwo
 */
public func lastArgument<T, V>(_ argOne: T, _ argTwo: V) -> V {
    return argTwo
}

/**
 Will return the middle argument you give it. Let type inference do what you need it to do.
 (Be careful with type inference. Really careful with this one!!!)
 
 - Parameter argOne: value you want to ignore
 - Parameter argTwo: value
 - Parameter argThree: value you want to ignore
 
 - Returns: argTwo
 */
public func middleArgument<T, V, Z>(_ argOne: T, _ argTwo: V, _ argThree: Z) -> V {
    return argTwo
}

/**
 Will map any input into by adding more input to it
 
 - Parameter argument: value you want to append to the input
 
 - Returns: function that passes the input through with the extra argument at the end
 */
public func add<V, T>(trailing argument: T) -> (V) -> (V, T) {
    return { ($0, argument) }
}

/**
 Will map any input into by adding more input to it
 
 - Parameter argument: value you want to append to the input
 
 - Returns: function that passes the input through with the extra argument at the start
 */
public func add<V, T>(starting argument: T) -> (V) -> (T, V) {
    return { (argument, $0) }
}

/**
 Will map a partial part of the input and compile it again into an output
 
 - Parameter partial: gives the part of the input that should be mapped
 - Parameter map: Maps the part to another value
 - Parameter cleanup: compiles the original value with the new output to a new value
 
 - Returns: mapping function
 */
public func partialMap<V, T, O, R>(partial: @escaping (V) -> (T), map: @escaping (T) -> (O), cleanup: @escaping (V, O) -> R) -> (V) -> (R) {
    return { $0 | partial >>> map >>> add(starting: $0) >>> cleanup }
}

/**
 Will map the first argument and leave the rest intact
 
 - Parameter map: Maps the part to another value
 
 - Returns: mapping function
 */
public func mapFirst<V, T, R>(_ map: @escaping (V) -> (R)) -> (V, T) -> (R, T) {
    return flipArguments >>> mapLast(map) >>> flipArguments
}

/**
 Will map the last argument and leave the rest intact
 
 - Parameter map: Maps the part to another value
 
 - Returns: mapping function
 */
public func mapLast<V, T, R>(_ map: @escaping (T) -> (R)) -> (V, T) -> (V, R) {
    return partialMap(partial: lastArgument, map: map) { ($0.0, $1)}
}

/**
 Will create a function that will get a function and apply the value to it
 
 - Parameter value: Value that should be applied to inputed function
 
 - Returns: function that takes a function and returns the result
 */
public func apply<T, V>(value: V) -> ((V) -> (T)) -> T {
    return { value | $0 }
}

/**
 Will drop any arguments given to it. Who knows? Might be useful.
 
 - Parameter value: value
 */
public func dropArguments<V>(_ input: V) {  }

/**
 Fill filp the order of the arguments
 
 - Parameter argOne: value
 - Parameter argTwo: value
 
 - Returns: argTwo, argOne
 */
public func flipArguments<T, V>(_ argOne: T, _ argTwo: V) -> (V, T) {
    return (argTwo, argOne)
}

/**
 Will increase the input by one. Can also be written as (+) ** 1
 
 - Parameter number: n
 
 - Returns: n + 1
 */
public func inc(_ number: Int) -> Int {
    return number + 1
}

/**
 Will deliver the negative of a number
 
 - Parameter number: n
 
 - Returns: n * (-1)
 */
public func negative(_ number: Int) -> Int {
    return -number
}

/**
 Will return the description of any input
 
 - Parameter input: String convertible item
 
 - Returns: String representation
 */
public func describe<T: CustomStringConvertible>(of input: T) -> String {
    return input.description
}
