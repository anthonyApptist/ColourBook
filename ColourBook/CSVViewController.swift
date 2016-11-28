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
    
    var paintCansArray: [PaintCan]?

    override func viewDidLoad() {
        super.viewDidLoad()

        
        //MARK: Paint Data
        
        do {
            let csvPaintString = try NSString.init(contentsOfFile: "/Users/Anthony/Documents/iOS/ColourBook/ColourBook/Paint Data.csv", encoding: String.Encoding.macOSRoman.rawValue)
//            print(csvPaintString)
            paintData = csvPaintString as String
        }
        catch {
            print(error.localizedDescription)
        }
        
        DataService.instance.mainRef.child("test")
        
        csvPaintFileArray = []
        
        csvPaintFileArray = paintData?.components(separatedBy: ",")
        
//        print(csvFileArray?.count ?? nil ?? 0)
        
        csvPaintFileArray?.removeFirst(5)
        
        print(csvPaintFileArray?.count ?? nil ?? 0)
        
        let numberOfColours = (csvPaintFileArray?.count)!/4
        
        print(numberOfColours)
        
//        print(csvPaintFileArray?.first ?? nil ?? "error")
        
        coloursArray = []
        
        var i = 1
        
        while i < (numberOfColours + 1) {
            
            // [manufactuer code, product code, product name, product image, hex code]
            
            let manufactuerID = csvPaintFileArray?[0]
            
            let productCode = csvPaintFileArray?[1]
            
            let productName = csvPaintFileArray?[2]
            
            let productImage = csvPaintFileArray?[3]
            
            var hexCode = csvPaintFileArray?[4]
            
            let charsSet = NSCharacterSet.alphanumerics
            
            
            if (productCode?.isEmpty)! {
                print(productName ?? "")
            }
            
            if (productImage?.isEmpty)! {
                print(i)
            }
            
            if (hexCode?.contains("\r"))! {
                hexCode = hexCode?.replacingOccurrences(of: "\r", with: "")
            }
            if hexCode?.characters.count == 6 {
//                print("true")
                if (hexCode?.contains("+"))! {
                    print(i)
                }
                else {
                    
                }
            }
            
            if (hexCode?.characters.count)! < 6 {
                print("row \(i) less than 6")
            }
                
            else {
//                print("nothing found")
            }
            
            let colour = Colour(manufactuerID: manufactuerID!, productCode: productCode!, colourName: productName!, colourImage: productImage!, colourHexCode: hexCode!)
            
//            print(colour.colourName)

            coloursArray?.append(colour)
            
//            print(coloursArray?.count ?? 0)
            
            csvPaintFileArray?.removeFirst(5)
            
            i += 1
            
        }
        /*
        
        if coloursArray?.count == numberOfColours {
            print("complete colours")
        }
        else {
            print("error")
        }
        
        
        // add paint data to firebase
        
        for colour in coloursArray! {
         
            DataService.instance.savePaintData(manufactuerID: colour.manufactuerID, productCode: colour.productCode, colourName: colour.colourName, colourImage: colour.colourImage, colourHexCode: colour.colourHexCode)
         
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
        
        //        print(csvPaintCanFileArray?.count ?? nil ?? 0)
        
        csvPaintCanFileArray?.removeFirst(8)
        
//        print(csvPaintCanFileArray?.count ?? nil ?? 0)
        
        let numberOfCans = Float((csvPaintCanFileArray?.count)!/7)
        
        print(numberOfCans)
        
        print(csvPaintCanFileArray?.first ?? nil ?? "error")
        
        paintCansArray = []
        
        var y = 0
        
        while y < Int(numberOfCans) {
            
//            Manufacteur, Product Name, Category, Code, Product UPC, Image
            
            let manufactuerCode = csvPaintCanFileArray?[0]
            
            let productName = csvPaintCanFileArray?[1]
            
            let category = csvPaintCanFileArray?[2]
            
            let code = csvPaintCanFileArray?[3]
            
            let upcCode = csvPaintCanFileArray?[4]
            
            let paintCanImage = csvPaintCanFileArray?[5]
            
            let paintCan = PaintCan(manufactuer: manufactuerCode!, productName: productName!, category: category!, code: code!, upcCode: upcCode!, image: paintCanImage!)
            
//            print(paintCan.productName ?? "")
            
            paintCansArray?.append(paintCan)
            
//            print(paintCansArray?.count ?? 0)
            
            csvPaintCanFileArray?.removeFirst(7)
            
            y += 1
            
        }

        if paintCansArray?.count == Int(numberOfCans) {
            print("complete number of paint cans")
        }
        else {
            print("error")
        }

        
        // add paint cans to firebase
        
        for paintCan in paintCansArray! {
            
            DataService.instance.savePaintCanData(manufactuer: paintCan.manufactuer, productName: paintCan.productName, category: paintCan.category, code: paintCan.code, upcCode: paintCan.upcCode, image: paintCan.image)
            
        }
 */
        
        view.backgroundColor = UIColor.darkGray
        
    }

}
