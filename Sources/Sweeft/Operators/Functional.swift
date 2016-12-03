//
//  Functional.swift
//
//  Created by Mathias Quintero on 11/20/16.
//  Copyright © 2016 Mathias Quintero. All rights reserved.
//

import Foundation

/**
 Pipe. Will pass the value to a function. Like in Bash
 
 - Parameters:
 - value: Item you want to pass
 - function: Function you want to pass it to
 */
public func |<T, V>(_ value: T?, function: ((T) -> V)?) -> V? {
    guard let value = value else {
        return nil
    }
    return function?(value)
}

/**
 Pipe. Will pass the value to a function. Like in Bash
 
 - Parameters:
 - value: Item you want to pass
 - function: Function you want to pass it to
 */
public func |<T, V>(_ value: T, function: ((T) -> V)) -> V {
    return function(value)
}

/**
 Pipe. Will pass the value to a function. Like in Bash
 
 - Parameters:
 - value: Item you want to pass
 - function: Function you want to pass it to
 */
public func |<T, V>(_ value: T?, function: ((T) -> V)) -> V? {
    guard let value = value else {
        return nil
    }
    return function(value)
}

/**
 nil-check Handler?
 
 - Parameters:
 - handler: Closure you want to evaluate
 
 - Returns: a function that will return whether or not the handler evaluates an input to a value or nil
 */
public prefix func ??<T, V>(_ handler: @escaping ((T) -> V?)) -> (T) -> Bool {
    return { ??($0 | handler) }
}

infix operator =>

/**
 Map
 
 - Parameters:
 - items: array
 - handler: mapping function
 
 - Returns: result of mapping the array with the function
 */
public func =><T, V>(_ items: [T], _ handler: (T) -> (V)) -> [V] {
    return items.map(handler)
}

/**
 Map With Index
 
 - Parameters:
 - items: array
 - handler: mapping function
 
 - Returns: result of mapping the array with the function
 */
public func =><T, V>(_ items: [T], _ handler: (T, Int) -> (V)) -> [V] {
    return items.map(handler)
}

/**
 For each. Will call the handler with every element in the array
 
 - Parameters:
 - items: array
 - handler: mapping function
 */
public func =><T>(_ items: [T], _ handler: (T) -> ()) {
    items.forEach(handler)
}

/**
 For each with index. Will call the handler with every element in the array
 
 - Parameters:
 - items: array
 - handler: mapping function
 */
public func =><T>(_ items: [T], _ handler: (T, Int) -> ()) {
    items.forEach(handler)
}

infix operator ==>

/**
 FlatMap
 
 - Parameters:
 - items: array
 - handler: mapping function
 
 - Returns: result of flatMapping the array with the function
 */
public func ==><T, V>(_ items: [T], _ handler: (T) -> (V?)) -> [V] {
    return items.flatMap(handler)
}

infix operator |>

/**
 Filter
 
 - Parameters:
 - items: array
 - handler: includes function
 
 - Returns: filtered array
 */
public func |><V>(_ items: [V], _ handler: (V) -> Bool) -> [V] {
    return items.filter(handler)
}

/**
 Filter with index
 
 - Parameters:
 - items: array
 - handler: includes function
 
 - Returns: filtered array
 */
public func |><V>(_ items: [V], _ handler: (V, Int) -> Bool) -> [V] {
    return items.filter(handler)
}

/**
 Filter
 
 - Parameters:
 - items: array
 - handler: includes function
 
 - Returns: filtered array
 */
public func |><V>(_ items: [V], _ handler: @escaping (V) -> Bool?) -> [V] {
    return items |> handler.?
}

/**
 Filter with index
 
 - Parameters:
 - items: array
 - handler: includes function
 
 - Returns: filtered array
 */
public func |><V>(_ items: [V], _ handler: @escaping (V, Int) -> Bool?) -> [V] {
    return items |> handler.?
}

prefix operator **

/**
 Ignore input
 
 - Parameters:
 - handler: function without input
 
 - Returns: function that can take an input and drop it to call the handler.
 */
public prefix func **<T, V>(_ handler: @escaping () -> (V)) -> (T) -> (V) {
    return { _ in
        return handler()
    }
}

postfix operator **

/**
 Ignore ouput
 
 - Parameters:
 - handler: function with output
 
 - Returns: function that will evaluate the handler but won't return its value
 */
public postfix func **<T, V>(_ handler: @escaping (T) -> (V)) -> (T) -> () {
    return { input in
        _ = handler(input)
    }
}

/**
 Defaultable output Handler
 
 - Parameters:
 - handler: Closure you want to evaluate
 
 - Returns: a function that will return the handlers return value or the default value of the return type on nil
 */
public postfix func .?<T, V: Defaultable>(_ handler: @escaping ((T) -> V?)) -> (T) -> V {
    return { ($0 | handler).? }
}

prefix operator .?

/**
 Defaultable input Handler
 
 - Parameters:
 - handler: Closure you want to evaluate
 
 - Returns: a function that will feed the handler the input or the default of the type in case of nil
 */
public prefix func .?<T: Defaultable, V>(_ handler: @escaping (T) -> (V)) -> (T?) -> V {
    return { $0.? | handler }
}

/**
 Optionalize
 
 - Parameters:
 - handler: function that requires non-optionals
 
 - Returns: function that can take an optioanl and will return nil in case the input is nil
 */
public prefix func !<T, V>(_ handler: @escaping (T) -> (V)) -> (T?) -> (V?) {
    return { $0 | handler }
}

postfix operator .!

/**
 Force Unwrap function result
 
 - Parameters:
 - handler: function that return an optional
 
 - Returns: function that will unwrap the result of the first function
 */
public postfix func .!<T, V>(_ handler: @escaping (T) -> (V?)) -> (T) -> (V) {
    return { ($0 | handler)! }
}