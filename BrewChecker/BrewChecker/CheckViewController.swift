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
    var outdatedFormulae: [Any]?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
		self.formulaeView.delegate = self
		self.formulaeView.dataSource = self
        
    }
	
    override func awakeFromNib() {
        DispatchQueue.global(qos: .userInitiated).async {
            if let dict = self.parser.checkOutdated(){
                self.outdatedFormulae = dict
            }
            else{
                print("An error occured")
            }
        }
    }
    
	func numberOfRows(in tableView: NSTableView) -> Int {
        if outdatedFormulae != nil{
            return outdatedFormulae!.count
        }else{
            return 0
        }
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let cell = formulaeView.make(withIdentifier: "formulaeCell", owner: nil) as? OutdatedCellView{
            if let formula = outdatedFormulae![row] as? [String: Any]{
                let name = formula["name"] as! String
                let version = formula["current_version"] as! String
                cell.formulaeName.stringValue = name + " " + version
                return cell
            }
        }
		return nil
	}
}
