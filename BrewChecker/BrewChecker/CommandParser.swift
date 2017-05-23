//
//  CommandParser.swift
//  BrewChecker
//
//  Created by Marco on 23/05/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Foundation

class CommandParser{
    
    static func checkOutdated() -> [Any]?{
        //let command = "[{\"name\":\"git\",\"current_version\":\"2.7.0\",\"installed_versions\":[\"2.6.3\",\"2.6.4\"]},{\"name\":\"mercurial\",\"current_version\":\"3.6.3\",\"installed_versions\":[\"3.5.2\",\"3.6.1\",\"3.6.2\"]},{\"name\":\"qemu\",\"current_version\":\"2.5.0\",\"installed_versions\":[\"2.4.0.1\"]}]"
        let command = "[]"

        let json = try? JSONSerialization.jsonObject(with: command.data(using: String.Encoding.utf8)!, options: [])
        return json as? [Any]
    }

    static func update(){

    }

    static func upgrade(formulae: [String]){

    }

    static func executeCommand(){
    }
}
