//
//  CSVViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 25/11/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class CSVViewController: UIViewController { // Trim Characters Extension
    
    var paintData: String?
    
    var paintCanData: String?
    
    var csvPaintFileArray: [String]?
    
    var csvPaintCanFileArray: [String]?
    
    var coloursArray: [Colour]?
    
    var paintCansArray: [Paint]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.brown
    
        //MARK: Paint Data
        
        do {
            
            let csvPath = Bundle.main.path(forResource: "Cloverdale Paint", ofType: ".csv")
            
            let csvPaintString = try NSString.init(contentsOfFile: csvPath!, encoding: String.Encoding.macOSRoman.rawValue)
//            print(csvPaintString)
            paintData = csvPaintString as String
        }
        catch {
            print(error.localizedDescription)
        }
        
        csvPaintFileArray = []
        
        csvPaintFileArray = paintData?.components(separatedBy: ",")
        
        print(csvPaintFileArray?.count ?? nil ?? 0)
        
        let numberOfColours = (csvPaintFileArray?.count)!/4
        
        print(numberOfColours)
        
        coloursArray = []
        
        var i = 0
        
        var revisedColours = numberOfColours
        
        while i < (numberOfColours) {
            
            i += 1
            
            // [manufactuer code, product code, product name, hex code]
            
            var manufacturerID = csvPaintFileArray?[0]
            
            var productCode = csvPaintFileArray?[1]
            
            var productName = csvPaintFileArray?[2]
            
            var hexCode = csvPaintFileArray?[3]
            
            var manufacturer: String
            
            
            // manufacturer id check
            
            if (manufacturerID?.isEmpty)! {
                print("row \(i), manufacturerID is empty")
            }
            
            // fix manufacturer id
            
            if (manufacturerID?.contains("\r"))! {
                manufacturerID = manufacturerID?.replacingOccurrences(of: "\r", with: "")
            }
            
            if (manufacturerID?.contains("\n"))! {
                manufacturerID = manufacturerID?.replacingOccurrences(of: "\n", with: "")
            }
            
            // product code check
            
            if (productCode?.isEmpty)! {
                print("row \(i), product code is empty")
            }
            
            let firstProductCodeChar = productCode?.characters.first
            
            let lastProductCodeChar = productCode?.characters.last
            
            if (firstProductCodeChar == " ") {
                productCode?.characters.removeFirst()
            }
            if (lastProductCodeChar == " ") {
                productCode?.characters.removeLast()
            }
            
            if (productCode?.contains("+"))! || (productCode?.contains("E-"))! {
                print("row \(i), product code is invalid")
            }
            
            // product name check
            
            if (productName?.isEmpty)! {
                print("row \(i), product name is empty")
            }
            
            let firstChar = productName?.characters.first
            
            let lastChar = productName?.characters.last
            
            if (firstChar == " ") {
                productName?.characters.removeFirst()
            }
            
            if (lastChar == " ") {
                productName?.characters.removeLast()
            }
            
            if (productName?.contains(productCode!))! {
                
            }
            
            if (productName?.contains(";"))! || (productCode?.contains("&"))! {
                print("row \(i), product name is invalid")
                csvPaintFileArray?.removeFirst(4)
                revisedColours -= 1
                continue
            }
            
            if (productName?.contains("*"))! {
                productName = productName?.replacingOccurrences(of: "*", with: "")
            }
            
            if (productName?.contains("\n"))! {
                productName = productName?.replacingOccurrences(of: "\n", with: "")
            }
            
            // hex code check
            
            // fix hex code syntax
            
            if (hexCode?.contains("\r"))! {
                hexCode = hexCode?.replacingOccurrences(of: "\r", with: "")
            }
            
            if (hexCode?.contains("#"))! {
                hexCode = hexCode?.replacingOccurrences(of: "#", with: "")
            }
            
            if (hexCode?.contains("."))! || (hexCode?.contains("+"))! {
                print("row \(i), hex code is invalid")
                csvPaintFileArray?.removeFirst(4)
                revisedColours -= 1
                continue
            }
            
            if (hexCode?.characters.count)! < 6 {
                print("row \(i), hex code is less than 6")
            }
            
            if (hexCode?.contains("\n"))! {
                hexCode = hexCode?.replacingOccurrences(of: "\n", with: "")
            }
            
            // set manufacturer
            manufacturer = "Cloverdale Paint"
            
            let colour = Colour(manufacturerID: manufacturerID!, productCode: productCode!, colourName: productName!, colourHexCode: hexCode!, manufacturer: manufacturer)
            
            coloursArray?.append(colour)
            
            csvPaintFileArray?.removeFirst(4)
            
        }
        
        if coloursArray?.count == revisedColours {
            print("complete colours")
        }
        else {
            print("error")
        }
        
        
        // add paint data to firebase
        
        for colour in coloursArray! {
         
//            DataService.instance.savePaintData(manufacturerID: colour.manufacturerID, productCode: colour.productCode, colourName: colour.colourName, colourHexCode: colour.colourHexCode, manufacturer: colour.manufacturer)
         
        }
  
        print("done")
/*
 
        //MARK: Paint Cans
        
        do {
            
            let csvPath = Bundle.main.path(forResource: "productlist", ofType: ".csv")
            
            let csvPaintString = try NSString.init(contentsOfFile: csvPath!, encoding: String.Encoding.macOSRoman.rawValue)
            //            print(csvPaintString)
            paintCanData = csvPaintString as String
        }
        catch {
            print(error.localizedDescription)
        }
        
        csvPaintCanFileArray = []
        
        csvPaintCanFileArray = paintCanData?.components(separatedBy: ",")
        
        csvPaintCanFileArray?.removeFirst(8)
        
        let numberOfCans = Float((csvPaintCanFileArray?.count)!/7)
        
        print(numberOfCans)
        
        print(csvPaintCanFileArray?.first ?? nil ?? "error")
        
        paintCansArray = []
        
        var y = 1
        
        while y < (Int(numberOfCans)+1) {
         
            y += 1
         
//            Manufacturer, Product Name, Category, Code, Product UPC, Image
         
            let manufacturerCode = csvPaintCanFileArray?[0]
         
            let productName = csvPaintCanFileArray?[1]
         
            let category = csvPaintCanFileArray?[2]
         
            let code = csvPaintCanFileArray?[3]
         
            let upcCode = csvPaintCanFileArray?[4]
         
            let paintCanImage = csvPaintCanFileArray?[5]
         
         
            // manufactuer code check
         
            if (manufacturerCode?.isEmpty)! {
                print("row \(y), manufactuer code is empty")
            }
         
            // product name check
         
            if (productName?.isEmpty)! {
                print("row \(y), product name is empty")
            }
         
            // category check
         
            if (category?.isEmpty)! {
                print("row \(y), category is empty")
            }
         
            // code check
         
            if (code?.isEmpty)! {
                print("row \(y), code is empty")
            }
         
            if (code?.characters.count)! < 5 {
                print("row \(y), code is invalid")
            }
         
            // upc code check
         
            if (upcCode?.characters.count)! < 13 {
                print("row \(y), upc code is invalid")
            }
         
            else {
                // print("nothing found")
            }
         
         
            let paintCan = Paint(manufacturer: manufacturerCode!, productName: productName!, category: category!, code: code!, upcCode: upcCode!, image: paintCanImage!, colour: "")
         
//            print(paintCan.productName ?? "")
         
            paintCansArray?.append(paintCan)
         
//            print(paintCansArray?.count ?? 0)
         
            csvPaintCanFileArray?.removeFirst(7)
         
        }

        if paintCansArray?.count == Int(numberOfCans) {
            print("complete number of paint cans")
        }
        else {
            print("error")
        }

        // add paint cans to firebase
        
        for paintCan in paintCansArray! {
         
            if paintCan.upcCode.characters.count < 13 {
                print("upc code invalid skipped")
            }
         
            else {
         
                let manufactuer = paintCan.manufacturer
         
                let productName = paintCan.productName
         
                let category = paintCan.category
         
                let code = paintCan.code
         
                let upcCode = paintCan.upcCode
         
                let image = paintCan.image
                
                let colour = paintCan.colour
         
                DataService.instance.savePaintCanData(manufacturer: manufactuer, productName: productName, category: category, code: code, upcCode: upcCode, image: image, colour: colour)
         
            }
         
        }
        
         */

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss(animated: true, completion: nil)
    }
 

}
