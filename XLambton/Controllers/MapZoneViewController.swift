//
//  MapZoneViewController.swift
//  XLambton
//
//  Created by user143339 on 8/17/18.
//  Copyright © 2018 user143339. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ColorPointAnnotation: MKPointAnnotation {
    var pinColor: UIColor
    
    init(pinColor: UIColor) {
        self.pinColor = pinColor
        super.init()
    }
}

class MapZoneViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapObj: MKMapView!
    @IBOutlet weak var imgSliders: UIImageView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var mapManager = CLLocationManager()
    var annotations : [MKPointAnnotation] = []
    var annotationsPinPoint : [DetailsPinPoint] = []
    var userLocation = CLLocation()
    var db: DBManager?
    var images: [[String]] = []
    var countries: [Country] = []
    var agents: [Agent] = []
    var distance: [[Double]] = []
    var agentDecrypt: [Agent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        activity.stopAnimating()
        
        if let db = db {
            countries = db.readCountry()
        }
        
        images = loadImages()
        
        for agent in agents {
            var newAgent = decrypt(agent: agent)
            agentDecrypt.append(newAgent)
        }
        
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
        mapObj.showsUserLocation = false
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
        for agent in agentDecrypt {
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
    
    // Those methods just call the updateImage method
    @IBAction func sliderRed(_ sender: UISlider) {
        /*https://www.youtube.com/watch?v=l8NhGOeUOvs*/
        var currentValue = Int(sender.value)
        var valueCountries: [[String]] = []
        var nboAgents = 0
        var help = 0
        
        for agent in agentDecrypt{
            if agent.mission[0].mission == "I"{
                    for img in images {
                        for ct in countries{
                            if ct.id == Int(agent.country){
                                if img[0] == ct.name.lowercased(){
                                    valueCountries.append([ct.name, img[1]])
                                }
                            }
                        }
                    }
                nboAgents += 1
            }
        }
        
        sender.maximumValue = Float(valueCountries.count)
        activity.startAnimating()
        if currentValue > valueCountries.count{
            currentValue = valueCountries.count
        }else if currentValue == 0{
            currentValue = 1
        }
        var url = URL(string: valueCountries[currentValue-1][1])
        
        
        // creating the background thread
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            let fetch = NSData(contentsOf: url! as URL)
            
            //creating the main thread, that will update the user interface
            DispatchQueue.main.async {
                if let imageData = fetch {
                    self.imgSliders.image = UIImage(data: imageData as Data)
                }
                
                // stops the download indicator
                self.activity.stopAnimating()
            }
        }
        
    }
    
    @IBAction func sliderGreen(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        var valueCountries: [[String]] = []
        var nboAgents = 0
        var help = 0
        
        for agent in agentDecrypt{
            if agent.mission[0].mission == "R"{
                for img in images {
                    for ct in countries{
                        if ct.id == Int(agent.country){
                            if img[0] == ct.name.lowercased(){
                                valueCountries.append([ct.name, img[1]])
                            }
                        }
                    }
                }
                nboAgents += 1
            }
        }
        
        sender.maximumValue = Float(valueCountries.count)
        activity.startAnimating()
        if currentValue > valueCountries.count{
            currentValue = valueCountries.count
        }else if currentValue == 0{
            currentValue = 1
        }
        var url = URL(string: valueCountries[currentValue-1][1])
        
        
        // creating the background thread
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            let fetch = NSData(contentsOf: url! as URL)
            
            //creating the main thread, that will update the user interface
            DispatchQueue.main.async {
                if let imageData = fetch {
                    self.imgSliders.image = UIImage(data: imageData as Data)
                }
                
                // stops the download indicator
                self.activity.stopAnimating()
            }
        }
    }
    
    @IBAction func sliderBlue(_ sender: UISlider) {
        var currentValue = Int(sender.value)
        var valueCountries: [[String]] = []
        var nboAgents = 0
        var help = 0
        
        for agent in agentDecrypt{
            if agent.mission[0].mission == "P"{
                for img in images {
                    for ct in countries{
                        if ct.id == Int(agent.country){
                            if img[0] == ct.name.lowercased(){
                                valueCountries.append([ct.name, img[1]])
                            }
                        }
                    }
                }
                nboAgents += 1
            }
        }
        
        sender.maximumValue = Float(valueCountries.count)
        activity.startAnimating()
        if currentValue > valueCountries.count{
            currentValue = valueCountries.count
        }else if currentValue == 0{
            currentValue = 1
        }
        var url = URL(string: valueCountries[currentValue-1][1])
        
        
        // creating the background thread
        DispatchQueue.global(qos: DispatchQoS.userInitiated.qosClass).async {
            let fetch = NSData(contentsOf: url! as URL)
            
            //creating the main thread, that will update the user interface
            DispatchQueue.main.async {
                if let imageData = fetch {
                    self.imgSliders.image = UIImage(data: imageData as Data)
                }
                
                // stops the download indicator
                self.activity.stopAnimating()
            }
        }
    }
    
    // MARK: Private method
    func updateImage(_ button: Int){
        // starts the download indicator
        /*activity.startAnimating()
        
        // getting the image's url
        var url = URL(string: "")
        switch button {
        case 1:
            url = URL(string: "http://wallpaper-gallery.net/images/high-quality-wallpaper-download/high-quality-wallpaper-download-1.jpg")
        case 2:
            url = URL(string: "http://wallpaper-gallery.net/images/flowers-hd-wallpaper/flowers-hd-wallpaper-14.jpg")
        case 3:
            url = URL(string: "http://wallpaper-gallery.net/blog/best-photos-taken-during-traveling-trips-in-2015/best-photos-taken-during-traveling-trips-in-2015-22.jpg")
        default:
            break
        }
        
        // Image data capture
        let fetch = NSData(contentsOf: url! as URL)
        
        // Image Show
        if let imageData = fetch {
            self.image.image = UIImage(data: imageData as Data)
        }
        
        
        // stops the download indicator
        activity.stopAnimating()*/
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? MissionUpdateViewController{
            viewController.db = db
            viewController.agents = agentDecrypt
            viewController.countries = countries
            viewController.distance = distance
        }
    }
 

}
