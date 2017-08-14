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
	@IBOutlet weak var selected: SelectFormulaButton!
	
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }
    
}

class SelectFormulaButton: NSButton {
	var index:Int = -1
}
