//
//  ViewControllerMapa.swift
//  Mapa
//
//  Created by  on 06/02/2020.
//  Copyright © 2020 LocalArea. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewControllerMapa: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    
    let locationManager:CLLocationManager = CLLocationManager()
    var regionInMeters: Double = 500 //el zoom del mapa por defecto, cambiara con el modo de desplazamiento
    var lastLocation:CLLocation = CLLocation()
    var locationArray:[Point] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLocationServices()
    }
    
    @IBAction func endOfPath(_ sender: UIButton) {
        //parar el recording de la travesia y guardar el recorrido con la fecha en el fichero
        addPointsToFile(path: locationArray)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            //actuar normal
            setupLocationManager()
            checkLocationAuthorization()
            let location = locationManager.location
            if location != nil {
                lastLocation = location!
            }
        } else {
            //no hay permisos
            print("Servicios de localizacion no autorizados")
        }
    }
    
    //iniciar el locationManager
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        let location : CLLocation? = locationManager.location
        if location != nil{
            focusToUser(location: location!)
        }
    }
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .denied:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        }
    }
    
    func focusToUser(location:CLLocation) {
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: regionInMeters, longitudinalMeters: regionInMeters)
        mapView.setRegion(region, animated: true)
    }
    
    func drawPoint(location:CLLocation) {
        mapView.addOverlay(MKPolyline(coordinates: [lastLocation.coordinate, location.coordinate], count: 2))
    }
    

}

//se implementan los metodos de CLLocationManagerDelegate
extension ViewControllerMapa: CLLocationManagerDelegate {
    //cuando se cambia la localizacion
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last!
        if location.distance(from: lastLocation) > regionInMeters/20 {
            focusToUser(location: location)
            drawPoint(location: location)
            locationArray.append(Point(x:lastLocation.coordinate.latitude, y:lastLocation.coordinate.longitude))
            lastLocation = location
        }
    }
    
    //Cuando se cambian los permisos de la aplicacion
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
}

extension ViewControllerMapa: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay : MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3
        return renderer
    }
}
