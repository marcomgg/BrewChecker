//
//  OutdatedCellView.swift
//  BrewChecker
//
//  Created by Marco on 21/05/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Cocoa

class OutdatedCellView: NSTableCellView {
	
	@IBOutlet weak var formulaeName: NSTextField!
	@IBOutlet weak var selected: NSButton!
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
}
