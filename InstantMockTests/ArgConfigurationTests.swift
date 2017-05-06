//
//  ArgConfigurationTests.swift
//  InstantMock
//
//  Created by Patrick on 06/05/2017.
//  Copyright © 2017 pirishd. All rights reserved.
//

import XCTest
@testable import InstantMock


class DummyArgConfiguration {}


class ArgConfigurationTests: XCTestCase {


    func toArgConfigurations_empty() {
        let list = [Any]()
        let ret = list.toArgConfigurations()
        XCTAssertEqual(ret.count, 0)
    }


    func toArgConfigurations_basicNonAny() {
        var list = [Any]()
        list.append(12)
        let ret = list.toArgConfigurations()
        XCTAssertEqual(ret.count, 0)
    }


    func toArgConfigurations_basicIsAny() {
        var list = [Any]()
        list.append(Int.any)
        let ret = list.toArgConfigurations()
        XCTAssertEqual(ret.count, 1)
    }


    func toArgConfigurations_wrongType() {
        var list = [Any]()
        list.append(DummyArgConfiguration())
        let ret = list.toArgConfigurations()
        XCTAssertEqual(ret.count, 0)
    }

}
