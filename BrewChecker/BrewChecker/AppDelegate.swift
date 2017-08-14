//
//  AppDelegate.swift
//  BrewChecker
//
//  Created by Marco on 20/05/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	func applicationDidFinishLaunching(_ aNotification: Notification) {
		Settings.initSettings()
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}
}

