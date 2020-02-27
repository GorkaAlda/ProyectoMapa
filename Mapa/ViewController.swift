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
        
        //inicializa el archivo de puntos
        exNhilPointsFile()
        print("AM being loaded")
        print(POINTS_FILE)
    }

    
}

