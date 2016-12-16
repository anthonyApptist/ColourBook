//
//  ItemListSettingsVC.swift
//  ColourBook
//
//  Created by Mark Meritt on 2016-12-08.
//  Copyright © 2016 Apptist. All rights reserved.
//

import UIKit

class ItemListEditVC: CustomVC, UITableViewDelegate, UITableViewDataSource {

    let paintCan = Paint(manufacturer: "Home Depot", productName: "Dark Red Paint", category: "category", code: "990949209", upcCode: "9030499", image: "darkred")
    
     let paintCan2 = Paint(manufacturer: "Home Depot", productName: "Green Paint", category: "category", code: "990949209", upcCode: "9030499", image: "green")
    
     let paintCan3 = Paint(manufacturer: "Home Depot", productName: "Light Blue Paint", category: "category", code: "990949209", upcCode: "9030499", image: "lightblue")
    
    var user = User(uid: "Mark", email: "mark@theapptist.com", name: "Mark")
    
    var businessItem: Business?
    
    var addressItem: Address?
    
    @IBOutlet weak var tableView: UITableView?
    
    @IBOutlet var topView: UIView?
    
    @IBOutlet var bottomView: UIView?
    
    @IBOutlet var titleLbl: UILabel?
        
    @IBOutlet var subTitleLbl: UILabel?
    
    @IBAction func settingsBtnPressed(_ sender: AnyObject) {
        
        if screenState == ScreenState.personal {
            performSegue(withIdentifier: "ConnectToImageSettings", sender: self)
        } else if screenState == ScreenState.business || screenState == ScreenState.homes {
            performSegue(withIdentifier: "ConnectToMenuSettings", sender: self)
        } 
        
    }
    

    @IBAction func scanBtnPressed(_ sender: AnyObject) {
        
        let scanView = storyboard?.instantiateViewController(withIdentifier: "BarcodeVC")
        
        present(scanView!, animated: true, completion: nil)
        
    }
    
    override func backBtnPressed(_ sender: AnyObject) {
        
        
        self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {

        super.viewDidAppear(false)
        
        tableView?.delegate = self
        tableView?.dataSource = self
        

        
        if self.titleString == "personal" {
            screenState = ScreenState.personal
        } else if self.titleString == "business" {
            screenState = ScreenState.business
        } else if self.titleString == "my homes" {
            screenState = ScreenState.homes
        }

        
     
        
        if screenState == .personal {
            
            if user.items.count == 0 {
            user.addItem(item: paintCan)
            user.addItem(item: paintCan2)
            user.addItem(item: paintCan3)
            }
        
            titleLbl?.text = user.name
            
        } else if screenState == .business {
            
            if businessItem?.items.count == 0 {
            businessItem?.addItem(item: paintCan)
            businessItem?.addItem(item: paintCan2)
            businessItem?.addItem(item: paintCan3)
            }
            
            titleLbl?.text = businessItem?.name
            
        } else if screenState == .homes {
            
            if addressItem?.items.count == 0 {
            addressItem?.addItem(item: paintCan)
            addressItem?.addItem(item: paintCan2)
            addressItem?.addItem(item: paintCan3)
            }
            
            titleLbl?.text = addressItem?.name
        }
        
        tableView?.reloadData()


        

        
    }
    
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if screenState == .personal {
            
            return (user.items.count)
            
        } else if screenState == .business {
            
            return (businessItem?.items.count)!
            
        } else if screenState == .homes {
            
            return (addressItem?.items.count)!
        }

        else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        
        if screenState == .personal {
            
            cell.titleLbl?.text = self.user.items[indexPath.row].productName
            
        } else if screenState == .business {
            
            cell.titleLbl?.text = self.businessItem?.items[indexPath.row].productName
            
        } else if screenState == .homes {
            
            cell.titleLbl?.text = self.addressItem?.items[indexPath.row].productName
            
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let row = indexPath.row
        
            
        performSegue(withIdentifier: "ShowListDetail", sender: nil)
            
    
        
    }
    
    //DELETE ROWS
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if screenState == .personal {
                
                if user.items.count > 0 {
                    user.items.remove(at: (indexPath as NSIndexPath).row)
                }
                
            } else if screenState == .business {
                
                if (businessItem?.items.count)! > 0 {
                    businessItem?.items.remove(at: (indexPath as NSIndexPath).row)
                }

            } else if screenState == .homes {
            
            if (addressItem?.items.count)! > 0 {
                addressItem?.items.remove(at: (indexPath as NSIndexPath).row)
            }
            
         
        }
                
            //enter firebase logic here to delete data from list
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    //DELETE ROWS

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        if screenState == .personal {
            
            if user.items.count > 0 {
                if(indexPath as NSIndexPath).row >= user.items.count {
                    return .insert
                } else {
                    return .delete
                }
            }
            
        } else if screenState == .business {
            
            if (businessItem?.items.count)! > 0 {
                if(indexPath as NSIndexPath).row >= (businessItem?.items.count)! {
                    return .insert
                } else {
                    return .delete
                }
            }
            
        } else if screenState == .homes {
            
            if (addressItem?.items.count)! > 0 {
                if(indexPath as NSIndexPath).row >= (addressItem?.items.count)! {
                    return .insert
                } else {
                    return .delete
                
            }
 
    }
        }
            return .none
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: nil)
        
        if segue.identifier == "ShowListDetail" {
            
            var item: Paint?
            
            let row = tableView?.indexPathForSelectedRow?.row
            
            if screenState == .personal {
                
                item = user.items[row!]
                
            } else if screenState == .business {
                
                item = businessItem?.items[row!]
                
            } else if screenState == .homes {
                
                item = addressItem?.items[row!]
                
            }

            if let detail = segue.destination as? ItemListDetailVC {
                detail.detailItem = item
                detail.screenState = screenState
            }
        }
        
        if segue.identifier == "ConnectToMenuSettings" {
            
            
            if self.screenState == .business {
                
                
                if let detail = segue.destination as? SettingsVC {
                    
                    detail.businessItem = businessItem
                    detail.screenState = screenState
                }
            } else if self.screenState == .homes {
                
                
                if let detail = segue.destination as? SettingsVC {
                    
                    detail.addressItem = addressItem
                    detail.screenState = screenState
                }
            }
        }
        
        if segue.identifier == "ConnectToImageSettings" {
            
            
 
                if let detail = segue.destination as? AddEditImageVC {
                    
                    detail.userItem = user
                    detail.screenState = screenState
           
         
        
        
       
    }
 
        }
        
    }
    
    
    
            
    
        
    }


