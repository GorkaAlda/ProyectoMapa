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
    @IBOutlet weak var table: UITableView!
    var items: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //cargar el array de caminos
        items = cargarRecorridos()
        
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "mapaCaminar") {
            let destino = segue.destination as! ViewControllerMapa
            destino.regionInMeters = 150
        } else if(segue.identifier == "mapaCorrer") {
            let destino = segue.destination as! ViewControllerMapa
            destino.regionInMeters = 300
        } else if(segue.identifier == "mapaBici") {
            let destino = segue.destination as! ViewControllerMapa
            destino.regionInMeters = 500
        }
    }
    
    func cargarRecorridos() -> [String] {
        var arr = getAllPaths()
        for i in 0...(arr.count - 1) {
            let index = arr[i].index(arr[i].startIndex, offsetBy: 23)
            arr[i] = String(arr[i][..<index])
        }
        return arr
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.table.dequeueReusableCell(withIdentifier: "cell")!

        cell.textLabel?.text = self.items[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
}

