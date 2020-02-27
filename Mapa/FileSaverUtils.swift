//
//  FileSaverUtils.swift
//  Mapa
//
//  Created by  on 21/02/2020.
//  Copyright © 2020 LocalArea. All rights reserved.
//

import Foundation

//esto (se supone) mira cual es nuestra carpeta por defecto y pone la ruta del fichero de caminos en el parametro
let POINTS_FILE = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("paths.txt")
let TIMESTAMP_FORMAT = "yyyy-MM-dd HH:mm:ss:SSS"

class Point{
    let x_coord : Double
    let y_coord : Double
    
    init(x : Double, y : Double) {
        self.x_coord = x
        self.y_coord = y
    }
    
    func toString() -> String {
        return "{\(x_coord),\(y_coord)}"
    }
}


/*
 Si el archivo de puntos no existe, lo crea.
 */
func exNhilPointsFile() {
    if(!FileManager.default.fileExists(atPath: POINTS_FILE.path)) {
        FileManager.default.createFile(atPath: POINTS_FILE.path, contents: nil)
    }
}

/*
 Aniade una serie de puntos al archivo de puntos con una timestamp
 */
func addPointsToFile(path : [Point]) {
    exNhilPointsFile()
    do {
        let fileHandle = try FileHandle(forWritingTo: POINTS_FILE)
        fileHandle.seekToEndOfFile()
        if !path.isEmpty {
            fileHandle.write("\(getCurrentTimestamp())=".data(using: .utf8)!)
            fileHandle.write(path[0].toString().data(using: .utf8)!)
            for i in stride(from: 1, to: (path.count - 1) , by: 1) {
                fileHandle.write(("," + path[i].toString()).data(using: .utf8)!)
            }
            fileHandle.write("\n".data(using: .utf8)!)
        }
        try fileHandle.close()
    } catch {
        print(error)
    }
}

func getCurrentTimestamp() -> String {
    let date = Date()
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = TIMESTAMP_FORMAT
    return dateFormat.string(from: date)
}

func getAllPaths() -> [String] {
    var paths:[String] = []
    do {
        let allStrings = try String(contentsOfFile: POINTS_FILE.path, encoding: .utf8)
        paths = allStrings.components(separatedBy: .newlines)
    } catch {
        print(error)
    }
    
    return paths
}
