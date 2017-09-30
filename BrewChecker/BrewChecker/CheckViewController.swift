//
//  CheckViewController.swift
//  BrewChecker
//
//  Created by Marco on 20/05/17.
//  Copyright © 2017 Marco. All rights reserved.
//

import Cocoa

class CheckViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource, NSTextFieldDelegate {

	var outdatedFormulae: [Any]?
	var manager: BrewManager!
	var updated = false
	var settingsController: NSWindowController!
	var summaryController: NSWindowController!
	var selectedFormulae: [String]! = []
	var upgradeOutput: String?
	
	// Main view outlets
	@IBOutlet weak var formulaeView: NSTableView!
	@IBOutlet weak var progressWheel: NSProgressIndicator!
	@IBOutlet weak var buttonCheck: NSButton!
	@IBOutlet weak var upgradeBar: NSProgressIndicator!
	
	// Settings outlets
	@IBOutlet var settings: NSWindow!
	@IBOutlet weak var pathTextField: NSTextField!
	@IBOutlet weak var statusIndicator: NSBox!
	@IBOutlet weak var buttonSave: NSButton!
	
	// Summary
	@IBOutlet var summary: NSWindow!
	@IBOutlet var summaryText: NSTextView!
	
	
	@IBAction func close(_ sender: Any) {
		NSApplication.shared.terminate(nil)
	}
	
	@IBAction func settings(_ sender: NSButton) {
		pathTextField.placeholderString = Settings.brewPath
		statusIndicator.fillColor = Settings.brewExists() ? #colorLiteral(red: 0, green: 1, blue: 0.2129835188, alpha: 1) : #colorLiteral(red: 0.8101208806, green: 0, blue: 0, alpha: 1)
		settingsController.showWindow(self)
	}
	
	@IBAction func selectFormula(_ sender: SelectFormulaButton) {
		if let formula = outdatedFormulae![sender.index] as? [String: Any]{
			let name = formula["name"] as! String
			if sender.state != 0 {
				selectedFormulae.append(name)
			} else {
				selectedFormulae.remove(at: sender.index)
			}
		}
	}
	
	@IBAction func save(_ sender: NSButton) {
		var path = pathTextField.stringValue
		if path.characters.last != "/" {
			path = path + "/"
		}
		Settings.brewPath = path
		Settings.save()
		settings.close()
	}
	
	@IBAction func check(_ sender: NSButton) {
		checkUpdates()
	}
	

	@IBAction func upgrade(_ sender: Any) {
		DispatchQueue.main.async {
			self.upgradeBar.isHidden = false
			self.upgradeBar.startAnimation(self)
		}
		DispatchQueue.global(qos: .userInitiated).async  {
			var formulae: [String]? = nil
			if self.selectedFormulae.count != 0 {
				formulae = self.selectedFormulae
			}
			if let output = self.manager.upgrade(formulae: formulae) {
				self.upgradeOutput = output
				DispatchQueue.main.async {
					self.upgradeBar.isHidden = true
					self.upgradeBar.stopAnimation(self)
					let attributes = [NSAttributedStringKey.foregroundColor: NSColor.white]
					let out = NSMutableAttributedString(string: output, attributes: attributes)
					self.summaryText.textStorage?.append(out)
					self.summaryController.showWindow(self)
				}
				self.checkUpdates()
			}
		}
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		self.formulaeView.delegate = self
		self.formulaeView.dataSource = self
		pathTextField.delegate = self
		settings.close()
		summary.close()
    }
	
	override func viewDidAppear() {
		super.viewDidAppear()
	}
	
    override func awakeFromNib() {
		settingsController = NSWindowController(window: settings)
		summaryController = NSWindowController(window: summary)
        manager = BrewManager()
		if Settings.brewExists() {
			if !updated {
				updated = true
				let dayInSeconds = 86400.0
				dispatchCheck(delay: dayInSeconds)
			}
		}
	}
	
	override func controlTextDidChange(_ obj: Notification) {
		var path = pathTextField.stringValue
		if path.characters.last != "/" {
			path = path + "/"
		}
		if Settings.brewExists(path: path) {
			statusIndicator.fillColor = #colorLiteral(red: 0, green: 1, blue: 0.2129835188, alpha: 1)
			buttonSave.isEnabled = true
		} else {
			statusIndicator.fillColor = #colorLiteral(red: 0.8101208806, green: 0, blue: 0, alpha: 1)
		}
	}
	
	func dispatchCheck(delay: Double) {
		checkUpdates()
		DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + delay) {
			self.dispatchCheck(delay: delay)
		}
	}
	
	func checkUpdates() {
		DispatchQueue.main.async {
			self.startWheel()
		}
		DispatchQueue.global(qos: .userInitiated).async  {
			if let dict = self.manager.checkOutdated() {
				self.outdatedFormulae = dict
				
				DispatchQueue.main.async {
					if self.formulaeView != nil {
						self.formulaeView.reloadData()
					}
					self.stopWheel()
				}
			}
		}
	}
	
	func startWheel() {
		self.buttonCheck.isHidden = true
		self.progressWheel.isHidden = false
		self.progressWheel.startAnimation(self)
	}
	
	func stopWheel() {
		self.buttonCheck.isHidden = false
		self.progressWheel.isHidden = true
		self.progressWheel.stopAnimation(self)
	}
	
	func numberOfRows(in tableView: NSTableView) -> Int {
        if outdatedFormulae != nil {
            return outdatedFormulae!.count
        } else {
            return 0
        }
	}
	
	func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
		if let cell = formulaeView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "formulaeCell"), owner: nil) as? OutdatedCellView {
			if let formula = outdatedFormulae![row] as? [String: Any]{
                let name = formula["name"] as! String
                let version = formula["current_version"] as! String
				self.selectedFormulae.append(name)
                cell.formulaeName.stringValue = name + " " + version
				cell.selected.state = NSControl.StateValue(rawValue: 1)
				cell.selected.action = #selector(self.selectFormula(_:))
				cell.selected.index = row
                return cell
            }
        }
		return nil
	}
}
