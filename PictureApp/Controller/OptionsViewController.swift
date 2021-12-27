//
//  OptionsViewController.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 26.11.2021.
//

import UIKit
import NetworkLayer

protocol OptionsViewControllerDelegate : AnyObject {
    func optionsViewController (_ controller: OptionsViewController, didSelectOrderStrategy order: Order)
    func didFilterSelected()
    
}
 
enum Order :String{

  case popular = "popular"
  case latest = "latest"

}

class OptionsViewController: UIViewController {
    
    @IBOutlet var sortButton: UIButton!
    var isTapped :Bool = true
    weak var delegate: PicturesViewController?
    
    
    @IBAction func sortPictures() {
        
        self.dismiss (animated: true, completion: nil)
        
        let order : Order?
        if (isTapped){
             order = Order(rawValue: "latest")
            isTapped = false
        } else {
             order = Order(rawValue: "popular")
            isTapped = true
        
        }
        delegate?.optionsViewController(self, didSelectOrderStrategy: order!)
       
        }
            
        
    @IBAction func filterPictures(_ sender: Any) {
        
        self.dismiss (animated: true, completion: nil)
        delegate?.didFilterSelected()
        
    }
    
    
    
}
