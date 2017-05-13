//
//  Arg.swift
//  InstantMock
//
//  Created by Patrick on 12/05/2017.
//  Copyright © 2017 pirishd. All rights reserved.
//


/** This class represents a generic Argument being registered */
class Arg<T> {


    /** Register a value */
    static func eq(_ val: T) ->T {
        let factory = ArgumentFactoryImpl<T>()
        return Arg.eq(val, argFactory: factory)
    }


    /** Register a value with factory (for dependency injection) */
    static func eq<F>(_ val: T, argFactory: F) ->T where F: ArgumentFactory, F.Value == T {
        let arg = argFactory.argument(value: val)
        ArgStorage.instance.store(arg)
        return val
    }


    /** Register a closure to be verified */
    static func verify(_ closure: @escaping (T) -> Bool) -> T {

        // store instance
        let arg = ArgVerify<T>(closure)
        ArgStorage.instance.store(arg)

        // return default value
        guard let ret = DefaultValueHandler<T>().it else {
            fatalError("Unexpected type, only `MockUsable` types can be used with `verify`")
        }
        return ret
    }


    /** Register any value */
    static var any: T {
        let factory = ArgumentFactoryImpl<T>()
        return Arg.any(argFactory: factory)
    }


    /** Register any value (for dependency injection) */
    static func any<F>(argFactory: F) ->T where F: ArgumentFactory, F.Value == T {

        // create and store instance
        let typeDescription = "\(T.self)"
        let arg = argFactory.argumentAny(typeDescription)
        ArgStorage.instance.store(arg)

        // return default value
        guard let ret = DefaultValueHandler<T>().it else {
            fatalError("Unexpected type, only `MockUsable` types can be used with `any`")
        }
        return ret
    }

}
