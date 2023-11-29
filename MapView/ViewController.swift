//
//  ViewController.swift
//  MapView
//
//  Created by Yudiz-subhranshu on 25/04/23.
//
import CoreLocation
import UIKit
import MapKit

import MapKit

var titleOfCity = ""
var subTitleOfCity = ""
var coOrdinates = ""

//Custom AnnotationClass for Annotation
class CustomAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let image: UIImage?
    
    var imageName: String? {
        return "CustomAnnotationImage"
    }
    var annotationView: MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: self, reuseIdentifier: "CustomAnnotationImage")
        annotationView.canShowCallout = true
        annotationView.image = image
        return annotationView
    }
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, image: UIImage?) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.image = image
        super.init()
    }
    
}

//Second ViewController :
class secondVC : UIViewController {
    
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var subTitleLbl: UILabel!
    @IBOutlet var imageLbl: UIImageView!
    @IBOutlet var coordinatesLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presentation = self.presentationController as! UISheetPresentationController
        presentation.detents = [.medium(),.large()]
        imageLbl.layer.cornerRadius = 50
        imageLbl.image = UIImage(named: titleOfCity)
        titleLbl.text = titleOfCity
        subTitleLbl.text = subTitleOfCity
        coordinatesLbl.text = coOrdinates
    }
}


class ViewController: UIViewController {
    
    @IBOutlet var changeBtn: UIBarButtonItem!
    var isShowCount = 1
    let manager = CLLocationManager()
    @IBOutlet var MapView: MKMapView!
    @IBOutlet var slider: UISlider!
    @IBOutlet var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider.minimumValue = 0.1
        slider.maximumValue = 500.0
        segmentControl.backgroundColor = UIColor.gray
        segmentControl.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        segmentControl.addTarget(self, action: #selector(changeMapType(_:)), for: .valueChanged)
        addAnnotations(lattitude: 12.120000, longitude: 76.680000, title: "Nanjangud", subtitle:  "Mysore, Karnataka, India" ,image: "icon")
        addAnnotations(lattitude: 24.879999, longitude: 74.629997, title: "Chittorgarh", subtitle:  "Rajasthan, India" ,image: "icon")
        addAnnotations(lattitude: 16.994444, longitude: 73.300003, title: "Ratnagiri", subtitle:  "Maharashtra, India" ,image: "icon")
        addAnnotations(lattitude: 19.155001, longitude: 72.849998, title: "Goregaon", subtitle:  "Mumbai, Maharashtra, India" ,image: "icon")
        addAnnotations(lattitude: 24.794500, longitude: 73.055000, title: "Pindwara", subtitle:  "Rajasthan, India" ,image: "icon")
        addAnnotations(lattitude: 21.250000, longitude: 81.629997, title: "Raipur", subtitle:  "Chhattisgarh, India" ,image: "icon")
        addAnnotations(lattitude: 16.166700, longitude: 74.833298, title: "Gokak", subtitle:  "Karnataka, India" ,image: "icon")
        addAnnotations(lattitude: 26.850000, longitude: 80.949997, title: "Lucknow", subtitle:  "Uttar Pradesh, India" ,image: "icon")
        addAnnotations(lattitude: 28.679079, longitude: 77.069710, title: "Delhi", subtitle:  "India" ,image: "icon")
        addAnnotations(lattitude: 19.076090, longitude: 72.877426, title: "Mumbai", subtitle:  "Maharashtra, India" ,image: "icon")
    }
    
    //Button to switvh between View Types
    @IBAction func changeBnClick(_ sender: Any) {
        if isShowCount % 2 != 0 {
            changeBtn.title = "Done"
            isShowCount += 1
            segmentControl.isHidden = false
            print(isShowCount)
        } else if isShowCount % 2 == 0 {
            changeBtn.title = "Change View"
            segmentControl.isHidden = true
            isShowCount += 1
        }
    }
    //Method for adding Custum Annotation
    func addAnnotations(lattitude : Double , longitude : Double , title : String , subtitle : String, image : String){
        let coordinate = CLLocationCoordinate2D(latitude: lattitude, longitude: longitude)
        let annotation = CustomAnnotation(title: title, subtitle: subtitle, coordinate: coordinate, image: UIImage(named: image))
        MapView.addAnnotation(annotation)
    }
    
    // Switch between different map types
    @objc func changeMapType(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            MapView.mapType = .standard
        case 1:
            MapView.mapType = .satellite
        case 2:
            MapView.mapType = .hybrid
        default:
            break
        }
    }
    
    //Zoom to the Current Location Of User And Automatically Set the Slider bar
    func render(_ location : CLLocation){
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        MapView.setRegion(region, animated: true)
        
        let delta = max(region.span.latitudeDelta, region.span.longitudeDelta)
        let sliderValue = Float(delta * 100)
        slider.value = sliderValue
        let annotation = CustomAnnotation(title: "Yudiz Solutions", subtitle: "Time Square 1 , Ahemedabad", coordinate: coordinate, image: UIImage(named: "icon"))
        MapView.addAnnotation(annotation)
    }
    //Slider Action
    @IBAction func sliderAction(_ sender: UISlider) {
        let miles = Double(self.slider.value)
        let delta = miles / 100
        var currentregion = self.MapView.region
        currentregion.span = MKCoordinateSpan(latitudeDelta: delta, longitudeDelta: delta)
        self.MapView.region = currentregion
    }
}

extension ViewController : MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation {
            print("Selected Annotation : " + annotation.title!!)
            titleOfCity = annotation.title!!
            subTitleOfCity = (annotation.subtitle ?? "") ?? ""
            coOrdinates = "\(annotation.coordinate.latitude), \(annotation.coordinate.longitude)"
            performSegue(withIdentifier: "secondVC", sender: self)
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
        return customAnnotation.annotationView
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            render(location)
        }
    }
}
