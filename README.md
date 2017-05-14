# InstantMock
## Create mocks easily in Swift 3

## Introduction
*InstantMock* aims at creating mocks easily in Swift 3. It provides a simple way to mock, stub and verify expectations.
This project is in beta for now. Suggestions and issue reports are welcome.

## Usage

*InstantMock* works in two parts:
* **Mock creation**: this part aims at creating mocks implementing a protocol, or using inheritance.
* **Settings expectations and stubs**: this part is where mocks are used in your actual tests.

### Mocking

### Using delegation
Mocks can be created by just implementing the protocol `MockDelegate`. It aims at providing a delegate instance that actually does all the work of registering and handling calls.

The example below assumes we want to mock this protocol:
```
protocol Foo {
    func bar(arg1: String, arg2: Int) -> Bool
}
```

In your test project, create a new class `FooMock` that adopts the `Foo` and `MockDelegate` protocols. In the `Foo` implementation, just call the `call` function on the delegate instance and provides the arguments received. 

```
class FooMock: MockDelegate {

    // create delegate instance
    private let delegate = Mock()
    
    // only getter to be implemented
    var it: Mock {
        return delegate
    }
}

// Extension for the `Foo` protocol
extension FooMock: Foo {

    // implement `bar` function, by calling `call` to the delegate
    // and provides the args
    func bar(arg1: String, arg2: Int) -> Bool {
        return delegate.call(arg1, arg2)!
    }
    
}
```

#### Using inheritance

When possible, mocks can also be created by inheriting the `Mock` class.

The example below uses the same `Foo` protocol as above. In your test project, create a new class `FooMock` that adopts the `Foo` protocol, and inherits from `Mock`:

```
class FooMock: Mock, Foo {

    // implement `bar` function, by calling `call` to `super`
    // and provides the args
    func bar(arg1: String, arg2: Int) -> Bool {
        return super.call(arg1, arg2)!
    }
    
}
```

#### Pre-requisites

Using `call` on `Mock` instances requires to follow certain rules for handling non-optional return values:
* use `!` after the call
* make sure the return type follows the `MockUsable` protocol (see [below](FIXME)).

### Expectations

Expectations aim at verifying that a call is done with some arguments.

They are set using the syntax like in the following example:
```
let mock = FooMock()
mock.expect().call(mock.bar(arg1: Arg.eq("hello"), arg2: Arg.eq(42)))
```
Here, we expect `bar` to be called with "hello" and 42 as arguments.

##### Number of calls
In addition, expectations can be set on the number of calls:
```
mock.expect().call(mock.bar(arg1: Arg.eq("hello"), arg2: Arg.eq(42)), numberOfTimes: 2)
```
Here, we expect `bar` to be called twice with "hello" and 42 as arguments.

##### Verifications
Verifying expectations is done this way:
```
mock.verify()
```

### Stubs

Stubs aim at performing some actions when a function is called with some arguments. For example, they return a certain value or call other functions.

They are set using a syntax like in the following example:

```
// set stub with return value
mock.stub().call(mock.bar(arg1: Arg.eq("hello"), arg2: Arg.eq(42))).andReturn(true)
````
Here, we stub `bar` to return `true` when called with "hello" and 42 as arguments.

#### Returning values
This is done with `andReturn(…)` on a stub instance.

#### Computing a return value
This is done with `andReturn(closure: { _ in return …})` on a stub instance. That enables to return different values on the same stub, depending on some conditions.

#### Calling a function
This is done with `andDo( { _ in … } )` on a stub instance.

### Chaining
Chaining several actions on the same stub is possible, given they don't confict. For example, it is possible to return a value and call another function, like `andReturn(true).andDo({ _ in print("something") })`.

Rules:
* the last closure registered by `andDo` is called first
* the last return value registered by `andReturn` is returned
* otherwise the last return value computation method, registered by `andReturn(closure:)` is called

### Argument Matching

Registering expectations and stubs is based on arguments matching. They are executed only if arguments match what was configured.

#### Matching value
This is done with `Arg.eq(…)`.

#### Matching any value of a given type
This is done with a syntax like `Arg<String>.any`.
**Note:** only `MockUsable` types can match any values, see [here]().

#### Matching a certain condition
This is done with a syntax like `Arg.verify({ _  in return …})`.

#### Matching a closure
Matching a closure is a special case. Use the following syntax:
`Arg<Closure>.any.cast as (…) -> …`

### Argument Capturing

Arguments can be captured for later use using the `ArgumentCaptor` class.

For example:
```
let captor = ArgumentCaptor<String>()
mock.stub().call(mock.bar(arg1: captor.capture(), arg2: Arg.eq(42))).andReturn(true)
…
let value = captor.value
let values = captor.allValues
```
Here, we create an argument captor for type `String`. When call in done values are registered, and can be accessible for later use using the `value` or `allValues` properties.

#### Capturing a closure

Capturing a closure is a special case. Use the following syntax:

```
let captor = ArgumentCaptor<(Int) -> Bool>(Closure.cast())
…
let ret = captor.value!(42)
````
Here, we create an argument captor of type `(Int) -> Bool`. After having captured the argument, closure can be called.

### MockUsable

`MockUsable` is a protocol dedicated to facilitating the use of a given type in mocks.
For a given type, it enables returning non-null values in mocks and catching any values.

Adding `MockUsable` to an existing type, just create an extension that adopts the protocol like in the following example:

```
extension SomeClass: MockUsable {
    
    static any = SomeClass() // any value
    
    // return any value
    static var anyValue: MockUsable {
        return SomeClass.any
    }

    // returns true if an object is equal to another `MockUsable` object
    func equal(to value: MockUsable) -> Bool {
        guard let value = value as? SomeClass else { return false }
        return self == value
    }

}
```

#### MockUsable types

For now, the following type are `MockUsable`:
* Bool
* Int
* Double
* String
* Set
* Array
* Dictionary

## Changelog
List of changes can be found [here](CHANGELOG.md).

## Requirements
Todo

## Installation
Todo

## Inspiration
Todo

## Author
Todo

## License
Todo
