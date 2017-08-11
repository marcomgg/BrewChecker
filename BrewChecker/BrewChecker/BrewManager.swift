//
//  CommandParser.swift
//  BrewChecker
//
//  Created by Marco on 23/05/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Foundation

class BrewManager{
    
    var brewPath: String
    let commands = [ "update" : ["update"],
					 "outdated" : ["outdated", "--json=v1"],
					 "upgrade" : ["upgrade"] ]
	
    init(brewPath: String){
        self.brewPath = brewPath
    }
	
	func setBrewPath(path: String) {
		brewPath = path
	}
	
    func checkOutdated() -> [Any]?{
        update()
        if let output = executeCommand(command: brewPath, arguments: commands["outdated"]!){
			let json = try? JSONSerialization.jsonObject(with: output.data(using: String.Encoding.utf8)!, options: [])
			return json as? [Any]
		}
		return nil
    }

    func update(){
        _ = executeCommand(command: brewPath, arguments: commands["update"]!)
    }

    func upgrade(formulae: [String]? = nil) -> String?{
		var arguments  = commands["upgrade"]!
		
		if formulae != nil {
			arguments.append(contentsOf: formulae!)
        }
		return executeCommand(command: brewPath, arguments: arguments)
    }

    func executeCommand(command: String, arguments: [String]) -> String? {
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
