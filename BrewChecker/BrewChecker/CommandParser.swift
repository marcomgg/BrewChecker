//
//  CommandParser.swift
//  BrewChecker
//
//  Created by Marco on 23/05/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Foundation

class CommandParser{
    
    let brewPath = "/usr/local/bin/brew"
    
    func checkOutdated() -> [Any]?{
        let prova = "[{\"name\":\"git\",\"current_version\":\"2.7.0\",\"installed_versions\":[\"2.6.3\",\"2.6.4\"]},{\"name\":\"mercurial\",\"current_version\":\"3.6.3\",\"installed_versions\":[\"3.5.2\",\"3.6.1\",\"3.6.2\"]},{\"name\":\"qemu\",\"current_version\":\"2.5.0\",\"installed_versions\":[\"2.4.0.1\"]}]"
        update()
        let arguments = ["update"]
        let output = executeCommand(command: brewPath, arguments: arguments)
        print(output)
        
        let json = try? JSONSerialization.jsonObject(with: prova.data(using: String.Encoding.utf8)!, options: [])
        return json as? [Any]
    }

    func update(){
        let arguments = ["update"]
        _ = executeCommand(command: brewPath, arguments: arguments)
    }

    func upgrade(formulae: [String]? = nil){
        if formulae == nil{
            let arguments = ["upgrade"]
            _ = executeCommand(command: brewPath, arguments: arguments)
        }else{
            for formula in formulae!{
                let arguments = ["upgrade", formula]
                _ = executeCommand(command: brewPath, arguments: arguments)
            }
        }
    }

    func executeCommand(command: String, arguments: [String]) -> String{
        let process = Process()
        process.launchPath = command
        process.arguments = arguments
        
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        
        let output = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: String.Encoding.utf8)!
        
        
        if output.characters.count > 0 {
            let lastIndex = output.index(before: output.endIndex)
            return output[output.startIndex ..< lastIndex]
        }
        return output
    }
}
