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
    var parser: CommandParser?
    var outdatedFormulae: [Any]?
    let defaultBrewPath = "/usr/local/bin/brew"
    override func viewDidLoad() {
        
        super.viewDidLoad()
		self.formulaeView.delegate = self
		self.formulaeView.dataSource = self
        
    }
	
    override func awakeFromNib() {
        if exists(path: defaultBrewPath){
            parser = CommandParser(brewPath: defaultBrewPath)
            DispatchQueue.global(qos: .userInitiated).async {
                if let dict = self.parser!.checkOutdated(){
                    self.outdatedFormulae = dict
                }
                else{
                    print("An error occured")
                }
            }
        }
        else{
            print("Brew is not in /usr/local/bin/")
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
    
    func exists(path: String) -> Bool{
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory:&isDir) {
            if isDir.boolValue {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
    }
}
