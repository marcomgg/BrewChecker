//
//  PopoverController.swift
//  BrewChecker
//
//  Created by Marco on 20/05/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Cocoa

class PopoverController: NSObject {

	@IBOutlet weak var popover: NSPopover!
	
	let statusItem = NSStatusBar.system().statusItem(withLength: NSVariableStatusItemLength)

	
	override func awakeFromNib() {
		if let button = statusItem.button {
    		button.image = NSImage(named: "statusIcon")
			button.target = self
    		button.action = #selector(self.togglePopover)
  		}
    }
	
	func showPopover(sender: AnyObject?) {
		if let button = statusItem.button {
			popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
		}
	}

	func closePopover(sender: AnyObject?) {
  		popover.performClose(sender)
	}

	func togglePopover(sender: AnyObject?) {
		if popover.isShown {
			closePopover(sender: sender)
		} else {
			showPopover(sender: sender)
		}
	}

}
