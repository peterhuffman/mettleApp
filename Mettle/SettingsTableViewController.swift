//
//  SettingsTableViewController.swift
//  Mettle
//
//  Created by Gordon Nickerson on 4/26/17.
//  Copyright © 2017 Peter Huffman. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //UserDefaults.standard.set(false, forKey: "requirePasscode")

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0 || section == 1 {
            return 2
        } else {
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "passcodeSwitchCell", for: indexPath) as! SwitchCell
                
                cell.switchElmt.isOn = UserDefaults.standard.bool(forKey: "requirePasscode")
                cell.switchElmt.tag = indexPath.section
                cell.switchElmt.addTarget(self, action: #selector(switchTriggered(sender:)), for: .valueChanged)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "changePasscodeCell", for: indexPath) as UITableViewCell
                
                return cell
            }
        } else if indexPath.section == 1 {
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "notificationSwitchCell", for: indexPath) as! SwitchCell
                
                cell.switchElmt.isOn = UserDefaults.standard.bool(forKey: "sendNotifications")
                cell.switchElmt.tag = indexPath.section
                cell.switchElmt.addTarget(self, action: #selector(switchTriggered(sender:)), for: .valueChanged)
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "changeNotificationDateCell", for: indexPath) as UITableViewCell
                
                return cell
            }
  
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "eraseAllDataCell", for: indexPath) as UITableViewCell
            
            return cell
        }

    }
   
    //used to hide the cells that aren't required at the moment
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if indexPath.section == 0 && indexPath.row == 1 && !UserDefaults.standard.bool(forKey: "requirePasscode") {
            return 0;
        } else if indexPath.section == 1 && indexPath.row == 1 && !UserDefaults.standard.bool(forKey: "sendNotifications") {
            return 0;
        } else {
            return tableView.rowHeight;
        }
    }
    
    func switchTriggered(sender: AnyObject) {
        let triggeredSwitch = sender as! UISwitch
        
        //passcode required section
        if triggeredSwitch.tag == 0 {
            UserDefaults.standard.set(triggeredSwitch.isOn, forKey: "requirePasscode")
        } else if triggeredSwitch.tag == 1 {
            UserDefaults.standard.set(triggeredSwitch.isOn, forKey: "sendNotifications")
        }
        
        UserDefaults.standard.synchronize()
        
        tableView.reloadData()
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
