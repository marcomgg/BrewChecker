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
	
	let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
	
	var popoverTransiencyMonitor: AnyObject?
	
	override func awakeFromNib() {
		if let button = statusItem.button {
    		button.image = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
			button.target = self
    		button.action = #selector(self.togglePopover)
  		}
    }

	func showPopover(sender: AnyObject?) {
  		if let button = statusItem.button {
    		popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
			if(popoverTransiencyMonitor == nil)
    		{
        		popoverTransiencyMonitor = NSEvent.addGlobalMonitorForEvents(matching: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown], handler: {(event: NSEvent!) in self.closePopover(sender: sender)}) as AnyObject
  			}
		}
	}

	func closePopover(sender: AnyObject?) {
  		popover.performClose(sender)
		if((popoverTransiencyMonitor) != nil){
			NSEvent.removeMonitor(popoverTransiencyMonitor!)
			popoverTransiencyMonitor = nil
		}
	}

	@objc func togglePopover(sender: AnyObject?) {
		if popover.isShown{
			closePopover(sender: sender)
		} else {
			showPopover(sender: sender)
		}
	}
}
