//
//  CSVViewController.swift
//  ColourBook
//
//  Created by Anthony Ma on 25/11/2016.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class CSVViewController: UIViewController {
    
    var paintData: String?
    
    var paintCanData: String?
    
    var csvPaintFileArray: [String]?
    
    var csvPaintCanFileArray: [String]?
    
    var coloursArray: [Colour]?
    
    var paintCansArray: [Paint]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.brown
    
/*
        //MARK: Paint Data
        
        do {
            let csvPaintString = try NSString.init(contentsOfFile: "/Users/Anthony/Documents/iOS/ColourBook/ColourBook/Benjamin Moore Paint Data.csv", encoding: String.Encoding.macOSRoman.rawValue)
//            print(csvPaintString)
            paintData = csvPaintString as String
        }
        catch {
            print(error.localizedDescription)
        }
        
        DataService.instance.mainRef.child("test")
        
        csvPaintFileArray = []
        
        csvPaintFileArray = paintData?.components(separatedBy: ",")
        
        print(csvPaintFileArray?.count ?? nil ?? 0)
        
        let numberOfColours = (csvPaintFileArray?.count)!/4
        
        print(numberOfColours)
        
        coloursArray = []
        
        var i = 0
        
        while i < (numberOfColours) {
            
            i += 1
            
            // [manufactuer code, product code, product name, hex code]
            
            var manufactuerID = csvPaintFileArray?[0]
            
            let productCode = csvPaintFileArray?[1]
            
            let productName = csvPaintFileArray?[2]
            
            var hexCode = csvPaintFileArray?[3]
            
            // fix hex code syntax
            
            if (hexCode?.contains("\r"))! {
                hexCode = hexCode?.replacingOccurrences(of: "\r", with: "")
            }
            
            // manufacturer id check
            
            if (manufactuerID?.isEmpty)! {
                print("row \(i), manufactuerID is empty")
            }
            
            // fix manufacturer id
            
            if (manufactuerID?.contains("\r"))! {
                manufactuerID = manufactuerID?.replacingOccurrences(of: "\r", with: "")
            }
            
            // product code check
            
            if (productCode?.isEmpty)! {
                print("row \(i), product code is empty")
            }
            
            if (productCode?.contains("+"))! || (productCode?.contains("E-"))! {
                print("row \(i), product code is invalid")
            }
            
            // product name check
            
            if (productName?.isEmpty)! {
                print("row \(i), product name is empty")
            }
            
            if (productName?.contains(";"))! || (productCode?.contains("&"))! {
                print("row \(i), product name is invalid")
            }
            
            // hex code check
            
            if (hexCode?.contains("."))! || (hexCode?.contains("+"))! {
                print("row \(i), hex code is invalid")
            }
            
            if (hexCode?.characters.count)! < 6 {
                print("row \(i), hex code is less than 6")
            }
             
            else {
//                print("nothing found")
            }
            
            let colour = Colour(manufactuerID: manufactuerID!, productCode: productCode!, colourName: productName!, colourHexCode: hexCode!)
            
            coloursArray?.append(colour)
            
            csvPaintFileArray?.removeFirst(4)
            
        }
        
        if coloursArray?.count == numberOfColours {
            print("complete colours")
        }
        else {
            print("error")
        }
        
        
        // add paint data to firebase
        
        for colour in coloursArray! {
         
            DataService.instance.savePaintData(manufactuerID: colour.manufactuerID, productCode: colour.productCode, colourName: colour.colourName, colourHexCode: colour.colourHexCode)
         
        }
  
        //MARK: Paint Cans
        
        do {
            let csvPaintString = try NSString.init(contentsOfFile: "/Users/Anthony/Documents/iOS/ColourBook/ColourBook/benjamin moore product list - edited.csv", encoding: String.Encoding.macOSRoman.rawValue)
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
         
//            Manufacteur, Product Name, Category, Code, Product UPC, Image
         
            let manufactuerCode = csvPaintCanFileArray?[0]
         
            let productName = csvPaintCanFileArray?[1]
         
            let category = csvPaintCanFileArray?[2]
         
            let code = csvPaintCanFileArray?[3]
         
            let upcCode = csvPaintCanFileArray?[4]
         
            let paintCanImage = csvPaintCanFileArray?[5]
         
         
            // manufactuer code check
         
            if (manufactuerCode?.isEmpty)! {
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
         
         
            let paintCan = PaintCan(manufactuer: manufactuerCode!, productName: productName!, category: category!, code: code!, upcCode: upcCode!, image: paintCanImage!)
         
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
         
                let manufactuer = paintCan.manufactuer
         
                let productName = paintCan.productName
         
                let category = paintCan.category
         
                let code = paintCan.code
         
                let upcCode = paintCan.upcCode
         
                let image = paintCan.image
         
                DataService.instance.savePaintCanData(manufactuer: manufactuer, productName: productName, category: category, code: code, upcCode: upcCode, image: image)
         
            }
         
        }
*/
    }

}
