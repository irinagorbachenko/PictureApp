//
//  FilterViewController.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 07.12.2021.
//

import UIKit
import NetworkLayer

protocol FilterViewControllerDelegate : AnyObject {
    
    func filterViewController (_ controller: FilterViewController, didSelectCategory selectedCategory : [String])
    
}

class FilterViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var selectedCategory = [String]()
    weak var delegate: FilterViewControllerDelegate?
    
    var categories = [Category(name: "music"),Category(name: "nature"),Category(name: "science"),Category(name: "backgrounds"),Category(name: "fashion"),Category(name: "education"),Category(name: "feelings"),Category(name: "health"),Category(name: "people"),Category(name: "religion"),Category(name: "places"),Category(name: "animals"),Category(name: "industry"),Category(name: "computer"),Category(name: "food"),Category(name: "sports"),Category(name: "travel"),Category(name: "buildings"),Category(name: "business")]

    
    
    @IBAction func doneCategoriesButton(_ sender: UIButton) {
        
        delegate?.filterViewController(self, didSelectCategory: selectedCategory)
       
      }
    
    
}

extension FilterViewController: UITableViewDataSource {

      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CheckTableViewCell
        cell.delegate = self
        let category = categories[indexPath.row]
        cell.set(name: category.name, checked: category.isComplete)
        
        return cell
      }
      
}
  

extension FilterViewController: CheckTableViewCellDelegate {

        func checkTableViewCell(_ cell: CheckTableViewCell, didChagneCheckedState checked: Bool) {

            guard let indexPath = tableView.indexPath(for: cell) else {
                  return
                }
            let category = categories[indexPath.row]
               let newCategory = Category(name: category.name, isComplete: checked)
                
                categories[indexPath.row] = newCategory
            
            selectedCategory.append(newCategory.name)

      }

}




