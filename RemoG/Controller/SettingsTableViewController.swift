//
//  SettingsTableViewController.swift
//  RemoG
//
//  Created by Jakob Hain on 12/31/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    var settingsController: SettingsController! {
        didSet {
            tableView.reloadData()
            settingsController.changeHandlers[self] = tableView.reloadData
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsController?.sections.count ?? 0
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingsController.sections[section].label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsController.sections[section].fields.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settingsController.settingAtIndexPath(indexPath)
        
        switch setting {
        case let toggleNumberSetting as ToggleNumberSettingField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ToggleNumberSettingCell", for: indexPath) as! ToggleNumberSettingCell
            cell.toggleSetting = toggleNumberSetting
            return cell
        case let numberSetting as NumberSettingField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "NumberSettingCell", for: indexPath) as! NumberSettingCell
            cell.setting = numberSetting
            return cell
        case let optionSetting as OptionSettingField:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionSettingCell", for: indexPath) as! OptionSettingCell
            cell.setting = optionSetting
            return cell
        default:
            fatalError("Invalid setting not a number or option: '\(setting)'")
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
