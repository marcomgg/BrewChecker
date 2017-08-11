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
	
	var outdatedFormulae: [Any]?
	var manager: BrewManager!
	var updated = false
	@IBOutlet var settings: NSWindow!
	var settingsController: NSWindowController!
	
	@IBOutlet weak var pathTextField: NSTextField!
	@IBOutlet weak var statusIndicator: NSBox!

	@IBAction func close(_ sender: Any) {
		NSApplication.shared().terminate(nil)
	}
	
	@IBAction func settings(_ sender: NSButton) {
		pathTextField.placeholderString = Settings.brewPath
		statusIndicator.fillColor = Settings.brewExists() ? #colorLiteral(red: 0, green: 1, blue: 0.2129835188, alpha: 1) : #colorLiteral(red: 0.8101208806, green: 0, blue: 0, alpha: 1)
		settingsController.showWindow(self)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.formulaeView.delegate = self
		self.formulaeView.dataSource = self
		settings.close()
    }
	
	override func viewDidAppear() {
		super.viewDidAppear()
	}
	
    override func awakeFromNib() {
		settingsController = NSWindowController(window: settings)
		if Settings.brewExists() {
			manager = BrewManager(brewPath: Settings.brewCommand )
			if !updated && Settings.checkOnLoad {
				updated = true
				dispatchCheck()
			}
		}
	}
	
	func dispatchCheck() {
		DispatchQueue.global(qos: .userInitiated).async {
			if let dict = self.manager.checkOutdated() {
				self.outdatedFormulae = dict
				
				DispatchQueue.main.async {
					if self.formulaeView != nil {
						self.formulaeView.reloadData()
					}
				}
			}
		}
	}
	func numberOfRows(in tableView: NSTableView) -> Int {
        if outdatedFormulae != nil {
            return outdatedFormulae!.count
        } else {
            return 0
        }
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let cell = formulaeView.make(withIdentifier: "formulaeCell", owner: nil) as? OutdatedCellView {
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
