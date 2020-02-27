//
//  ViewController.swift
//  Mapa
//
//  Created by  on 05/02/2020.
//  Copyright © 2020 LocalArea. All rights reserved.
//

import MapKit
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destino = segue.destination as! ViewControllerMapa
        if(segue.identifier == "mapaCaminar") {
            destino.regionInMeters = 150
        } else if(segue.identifier == "mapaCorrer") {
            destino.regionInMeters = 300
        } else if(segue.identifier == "mapaBici") {
            destino.regionInMeters = 500
        }
    }
    
}

