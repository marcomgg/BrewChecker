//
//  CheckViewController.swift
//  BrewChecker
//
//  Created by Marco on 20/05/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Cocoa

class CheckViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

	@IBOutlet weak var formulaeView: NSTableView!
	let parser = CommandParser()
    override func viewDidLoad() {
        
        super.viewDidLoad()
		self.formulaeView.delegate = self
		self.formulaeView.dataSource = self
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let dict = self.parser.checkOutdated(){
                print(dict)
            }
            else{
                print("An error occured")
            }
        }
    }
	
	func numberOfRows(in tableView: NSTableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let cell = formulaeView.make(withIdentifier: "formulaeCell", owner: nil) as? OutdatedCellView{
			  cell.formulaeName.stringValue = "prova"
			  return cell
			}
		return nil
	}
}
