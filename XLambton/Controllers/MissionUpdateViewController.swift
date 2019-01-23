//
//  MissionUpdateViewController.swift
//  XLambton
//
//  Created by user143339 on 8/17/18.
//  Copyright © 2018 user143339. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import CoreLocation
import MobileCoreServices

class MissionUpdateViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapObj: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    
    var mapManager = CLLocationManager()
    var annotations : [MKPointAnnotation] = []
    var annotationsPinPoint : [DetailsPinPoint] = []
    var userLocation = CLLocation()
    var db: DBManager?
    var countries: [Country] = []
    var agents: [Agent] = []
    var distance: [[Double]] = []
    //var agentDecrypt: [Agent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()

        // Setup Map
        mapManager.delegate = self                            // ViewController is the "owner" of the map.
        mapManager.desiredAccuracy = kCLLocationAccuracyBest  // Define the best location possible to be used in app.
        mapManager.requestWhenInUseAuthorization()            // The feature will not run in background
        mapManager.startUpdatingLocation()                    // Continuously geo-position update
        mapObj.delegate = self
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let row = filter.selectedRow(inComponent: 0) //carol
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MissionUpdateTableViewCell", for: indexPath) as? MissionUpdateTableViewCell{
            
            switch agents[indexPath.row].mission[0].mission {
            case "I":
                cell.imgMan.image = UIImage(named: "red")
                cell.btnCam.setImage(UIImage(named: "red_P"), for: .normal)
                cell.btnMail.setImage(UIImage(named: "red_M"), for: .normal)
                //cell.imgCam.image = UIImage(named: "red_P")
                //cell.imgMail.image = UIImage(named: "red_M")
           
            case "R":
                cell.imgMan.image = UIImage(named: "green")
                cell.btnCam.setImage(UIImage(named: "green_P"), for: .normal)
                cell.btnMail.setImage(UIImage(named: "green_M"), for: .normal)
                //cell.imgCam.image = UIImage(named: "green_P")
                //cell.imgMail.image = UIImage(named: "green_M")
                
            default:
                cell.imgMan.image = UIImage(named: "blue")
                cell.btnCam.setImage(UIImage(named: "blue_P"), for: .normal)
                cell.btnMail.setImage(UIImage(named: "blue_M"), for: .normal)
                //cell.imgCam.image = UIImage(named: "blue_P")
                //cell.imgMail.image = UIImage(named: "blue_M")
            }
            
            // Configure the cell...
            let distancePerCell = distance[indexPath.row][1]
            cell.lblDistance.text = "\(distancePerCell)Km"
            cell.btnCam.tag = agents[indexPath.row].id
            cell.btnMail.tag = agents[indexPath.row].id
            
            return cell
        }else{
            fatalError("the dequeued cell is not an instance of MissionUpdateTableViewCell.")
        }
    }
    
    @IBAction func takePicture(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.mediaTypes = [kUTTypeImage as String]
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    // MARK: Photo Controller
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        self.dismiss(animated: true, completion: nil)
        print("-------> imagePickerController antes do if")
        if mediaType.isEqual(to: kUTTypeImage as String) {
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            print("associando imagem")
            //photo.image = image
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
    }
    
    @IBAction func sendEmail(_ sender: UIButton) {
        if MFMailComposeViewController.canSendMail() {
            var index = -1
            var counter = 0
            for agent in agents {
                if sender.tag == agent.id{
                    index = counter
                    break
                }
                counter += 1
            }
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([agents[index].email])
            mail.setSubject("TEST iOS")
            mail.setMessageBody("<p>You're photo!</p>", isHTML: true)
            
            /*https://stackoverflow.com/questions/42715256/send-mail-with-file-attachment
             https://gist.github.com/kellyegan/49e3e11fe68b5e6b5360*/
            
            //if let filePath = Bundle.main.path(forResource: "swifts", ofType: "wav") {
                //if let fileData = NSData(contentsOfFile: filePath) {
                    
                    let imageData: NSData = UIImagePNGRepresentation(UIImage(named: "red")!)! as NSData
                    mail.addAttachmentData(imageData as Data, mimeType: "image/png", fileName: "imageName.png")
                    
                    //mail.addAttachmentData(fileData as Data, mimeType: "audio/wav", fileName: "swifts")
                //}
            //}
            present(mail, animated: true)
            
        } else {
            // show failure alert
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    
    //show information box when pin is tapped
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }
        
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            
            let colorPointAnnotation = annotation as! ColorPointAnnotation
            pinView?.pinTintColor = colorPointAnnotation.pinColor
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // The array locations stores all the user's positions, and the position 0 is the most recent one
        let location = locations[0]
        
        /********************* CAROL */
        userLocation = location
        
        /***********************/
        // Here we define the map's zoom. The value 0.01 is a pattern
        let zoom:MKCoordinateSpan = MKCoordinateSpanMake(150, 150)
        
        // Store latitude and longitude received from smartphone
        let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        /*********************/
        /*********************
         let zoom:MKCoordinateSpan = MKCoordinateSpanMake(0.3, 0.3)
         let myLocation:CLLocationCoordinate2D = CLLocationCoordinate2DMake(43.7733, -79.3364)
         userLocation = CLLocation(latitude: 43.7733, longitude: -79.3364)
         *********************/
        
        // Based on myLocation and zoom define the region to be shown on the screen
        let region:MKCoordinateRegion = MKCoordinateRegionMake(myLocation, zoom)
        
        // Setting the map itself based previous set-up
        mapObj.setRegion(region, animated: true)
        
        // Showing the blue dot in a map
        mapObj.showsUserLocation = true
    }
    
    func printAnnotations(obj: [Agent]) {
        mapObj.removeAnnotations(annotationsPinPoint)
        
        //Agents List
        for agent in obj {
            let index = Int(agent.country)!-1
            // show dsPinPoint on map
            /*let dsPinPoint = DetailsPinPoint(title: agent.name,
             locationName: countries[index].name,
             coordinate: CLLocationCoordinate2D(latitude: countries[index].latitude, longitude: countries[index].longitude))*/
            let annotation = ColorPointAnnotation(pinColor: UIColor.blue)
            annotation.coordinate = CLLocationCoordinate2DMake(countries[index].latitude, countries[index].longitude)
            mapObj.addAnnotation(annotation)
            //annotationsPinPoint.append(dsPinPoint)
            annotations.append(annotation)
        }
    }
    
    // Drawing a red circle to pin on map
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circleRenderer = MKCircleRenderer(overlay: overlay)
        circleRenderer.strokeColor = UIColor.red
        circleRenderer.lineWidth = 1.0
        return circleRenderer
    }
    
    func loadData(){
        mapObj.removeAnnotations(annotations)
        
        //Agents List
        for agent in agents {
            let index = Int(agent.country)!-1
            //set distance
            let location = CLLocation(latitude: countries[index].latitude, longitude: countries[index].longitude)
            let distanceCalc = round((userLocation.distance(from: location)/1000) * 10)/10
            let help = [Double(agent.id), distanceCalc]
            
            distance.append(help)
            
            var color = UIColor.black
            if agent.mission[0].mission == "I"{
                color = UIColor.red
            }else if agent.mission[0].mission == "R"{
                color = UIColor.green
            }else{
                color = UIColor.blue
            }
            let annotation = ColorPointAnnotation(pinColor: color)
            annotation.coordinate = CLLocationCoordinate2DMake(countries[index].latitude, countries[index].longitude)
            mapObj.addAnnotation(annotation)
            annotations.append(annotation)
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
