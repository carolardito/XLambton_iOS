//
//  UpdateAgentViewController.swift
//  XLambton
//
//  Created by user143339 on 8/15/18.
//  Copyright © 2018 user143339. All rights reserved.
//

import UIKit

class UpdateAgentViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var agent: Agent?
    var delegate: AgentsDelegate? = nil
    var missionsDs = ["I", "R", "P"]
    var countryDs: [String] = []//["Brazil", "Canada", "Denwark", "England", "France", "Japan"]
    var countries: [Country] = []
    var db: DBManager?
    
    @IBOutlet weak var lblname: UITextField!
    @IBOutlet weak var lblemail: UITextField!
    //@IBOutlet weak var lblcountry: UITextField!
    @IBOutlet weak var pickerCountry: UIPickerView!
    @IBOutlet weak var pickerMission: UIPickerView!
    @IBOutlet weak var pickerDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //db = DBManager()
        if let db = db {
            countries = db.readCountry()
        }
        
        pickerMission.delegate = self
        pickerMission.dataSource = self
        pickerCountry.delegate = self
        pickerCountry.dataSource = self
        lblname.delegate = self
        lblemail.delegate = self
        //lblcountry.delegate = self
                
        if let agent = agent {
            var newAgent = decrypt(agent: agent)
            lblname.text = newAgent.name
            lblemail.text = newAgent.email
            //lblcountry.text = newAgent.country
            var i = 0
            /*for ds in countryDs {
                if ds.uppercased() == newAgent.country {
                    pickerCountry.selectRow(i, inComponent: 0, animated: true)
                }
                i += 1
            }*/
            for ds in countries {
                if ds.id == Int(newAgent.country) {
                    pickerCountry.selectRow(i, inComponent: 0, animated: true)
                }
                i += 1
            }
            
            i = 0
            for ds in missionsDs {
                if ds.uppercased() == newAgent.mission[0].mission {
                    pickerMission.selectRow(i, inComponent: 0, animated: true)
                }
                i += 1
            }
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMdd"
            guard let dateToPicker = dateFormatter.date(from: newAgent.mission[0].date) else {
                fatalError("ERROR: Date conversion failed due to mismatched format.")
            }
            pickerDate.date = dateToPicker
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            return missionsDs.count
        }
        //return countryDs.count
        return countries.count
    }
    
    // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int)-> String? {
        if pickerView.tag == 1{
            return missionsDs[row]
        }
        //return countryDs[row]
        return countries[row].name
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //txtRestName.resignFirstResponder()
        textField.resignFirstResponder() // resign the text that called the function (parameter)
        return true
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        let rowMission = pickerMission.selectedRow(inComponent: 0)
        let rowCountry = pickerCountry.selectedRow(inComponent: 0)
        var result = false
        
        guard let name = lblname.text,
            !name.isEmpty else{
                let alert = UIAlertController(title: "Error", message: "Name mandatory", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }
        guard let email = lblemail.text,
            !email.isEmpty else{
                let alert = UIAlertController(title: "Error", message: "Email mandatory", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
        /*guard let country = lblcountry.text,
            !country.isEmpty else{
                let alert = UIAlertController(title: "Error", message: "Country mandatory", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
        }*/
        let country = countries[rowCountry].id
        let missionChosen = missionsDs[rowMission]
        let dateChosen = pickerDate.date
        
        /*FORMAT DATE*/
        let formatter = DateFormatter()
        // initially set the format based on your datepicker date / server String
        //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        //let myString = formatter.string(from: Date()) // string purpose I add here
        // convert your string to date
        //let yourDate = formatter.date(from: myString)
        //then again set the date format whhich type of output you need
        formatter.dateFormat = "yyyyMMdd"
        // again convert your date to string
        let myStringafd = formatter.string(from: dateChosen)
        /*FORMAT DATE*/        
        
        if let delegate = delegate{
            if !(agent == nil) {
                agent?.name = name
                agent?.email = email
                agent?.country = String(country)
                agent?.mission[0].date = myStringafd
                agent?.mission[0].mission = missionChosen
                //var mission = Mission(id: 0, idAgent: (agent?.id)!, date: myStringafd, mission: missionChosen)
                //agent?.mission.append(mission)
                result = delegate.save(agent!)
            }else{
                agent = Agent(id: 0, name: name, country: String(country), email: email, mission: [Mission(id: 0, idAgent: 0, date: myStringafd, mission: missionChosen)])
                result = delegate.save(agent!)
            }
        }
        
        if result {
            let alert = UIAlertController(title: "Saved", message: "Agent saved", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { _ in
                if let delegate = self.delegate {
                    DispatchQueue.main.async { [unowned self] in
                        delegate.reload()
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "Error", message: "Agent not saved. ERROR", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
