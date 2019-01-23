//
//  TableViewController.swift
//  XLambton
//
//  Created by user143339 on 8/14/18.
//  Copyright © 2018 user143339. All rights reserved.
//

import UIKit

protocol AgentsDelegate {
    func save(_ agent: Agent) -> Bool
    func reload()
    func updateMissions(_ agent: Agent)
}

class TableViewController: UITableViewController {

    var data: [Agent] = []
    var db: DBManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        db = DBManager()
        data.removeAll()
        if let db = db {
            data = db.readValues()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let db = db {
            data.removeAll()
            data = db.readValues()
            tableView.reloadData()
        }
        
        let userLoggedIn = UserDefaults.standard.value(forKey: "userLoggedIn") as? Bool
        
        if (userLoggedIn != true) {
            self.performSegue(withIdentifier: "loginView", sender: self)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButton(_ sender: UIBarButtonItem) {
        UserDefaults.standard.set(false, forKey: "userLoggedIn")
        UserDefaults.standard.synchronize()
        self.performSegue(withIdentifier: "loginView", sender: self)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "agentsCell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row].name
        // Configure the cell...

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let db = db {
                let agent = data[indexPath.row]
                db.delete(agent)
                data.remove(at: indexPath.row)
            }
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let viewcontroller = segue.destination as? UpdateAgentViewController{
            viewcontroller.delegate = self
            viewcontroller.db = db
            if segue.identifier == "updateAgent" {
                if let index = tableView.indexPathForSelectedRow?.row,
                    index < data.count{
                    viewcontroller.agent = data[index]
                }
            }
        }else if let controllerMapZone = segue.destination as? MapZoneViewController {
            controllerMapZone.db = db
            controllerMapZone.agents = data
        }
    }
}

extension TableViewController: AgentsDelegate {
    func updateMissions(_ agent: Agent) {
        if let db = db {
            db.delete(agent.id)
            db.save(agent.mission, idAgent: Int32(agent.id))
        }
    }
    
    func save(_ agent: Agent) -> Bool {
        if let db = db {
            return db.save(agent)
        }
        return false
    }
    
    func reload() {
        self.tableView.reloadData()
    }
}
