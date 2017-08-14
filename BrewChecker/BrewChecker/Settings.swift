//
//  settings.swift
//  BrewChecker
//
//  Created by Marco on 11/08/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Foundation

class Settings {
	static var brewPath = "/usr/local/bi/"
	static var brewName = "brew"
	static var brewCommand: String {
		get{
			return brewPath + brewName
		}
	}
	
	static func initSettings() {
		if let path = UserDefaults.standard.object(forKey: "BrewPath") as? String { brewPath = path }
	}
	
	static func brewExists() -> Bool{
		return fileExists(path: brewCommand)
    }
	
	static func brewExists(path: String) -> Bool{
		return fileExists(path: path + brewName)
	}
	
	static func fileExists(path: String) -> Bool{
		let fileManager = FileManager.default
		var isDir : ObjCBool = false
		
		if fileManager.fileExists(atPath: path, isDirectory:&isDir) {
			if !isDir.boolValue {
				return true
			}
		}
		return false
	}
	
	static func reset(){
		brewPath = "/usr/local/bin/"
		save()
	}
	
	static func save() {
		UserDefaults.standard.set(brewPath, forKey: "BrewPath")
	}
}
