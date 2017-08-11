//
//  settings.swift
//  BrewChecker
//
//  Created by Marco on 11/08/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Foundation

class Settings {
	private static var PATH = "/usr/local/bin/"
	private static var CHECKTIME = 0 // 0 = Every Day, 1 = Every Week, 2 = Every Month
	private static var CHECKONLOAD = true
	static var brewCommand: String {
		get{
			return PATH + "brew"
		}
	}
	
	static var brewPath: String {
		get {
			return PATH
		}
		set(path) {
			PATH = path
			UserDefaults.standard.set(path, forKey: "BrewPath")
		}
	}
	static var checkTime: Int {
		get {
			return CHECKTIME
		}
		set(checktime){
			CHECKTIME = checktime
			UserDefaults.standard.set(checktime, forKey: "CheckTime")
		}
	}
	static var checkOnLoad: Bool {
		get{
			return CHECKONLOAD
		}
		set(checkonload) {
			CHECKONLOAD = checkonload
			UserDefaults.standard.set(checkonload, forKey: "CheckOnLoad")
		}
	}
	
	static func initSettings() {
		if let path = UserDefaults.standard.object(forKey: "BrewPath") as? String { PATH = path
		print(path)}
		if let checktime = UserDefaults.standard.object(forKey: "CheckTime") as? Int { CHECKTIME = checktime }
		if let checkonload = UserDefaults.standard.object(forKey: "CheckOnLoad") as? Bool { CHECKONLOAD = checkonload }
	}
	
	static func brewExists() -> Bool{
		let fileManager = FileManager.default
		var isDir : ObjCBool = false
		
		if fileManager.fileExists(atPath: brewCommand, isDirectory:&isDir) {
			if !isDir.boolValue {
				return true
			}
		}
		return false
    }
	
	static func reset(){
		brewPath = "/usr/local/bin/"
		checkOnLoad = true
		checkTime = 0
	}
}
