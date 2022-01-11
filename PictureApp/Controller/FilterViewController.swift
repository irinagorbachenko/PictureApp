//
//  FilterViewController.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 07.12.2021.
//
import UIKit
import NetworkLayer

protocol FilterViewControllerDelegate : AnyObject {
    func filterViewController (didSelectCategory selectedCategory: [Category])
}

class FilterViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var selectedCategory = [Category]()
    weak var delegate: FilterViewControllerDelegate?
    
    
    @IBAction func doneCategoriesButton(_ sender: UIButton) {
        delegate?.filterViewController(didSelectCategory: selectedCategory)
    }
}

extension FilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Category.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checked cell", for: indexPath) as! CheckTableViewCell
        cell.delegate = self
        let category = Category.allCases[indexPath.row]
        cell.set(name: category.rawValue, checked: selectedCategory.contains(category))
        return cell
    }
}

extension FilterViewController: CheckTableViewCellDelegate {
    func checkTableViewCell(_ cell: CheckTableViewCell, didChangeCheckedState checked: Bool) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let category = Category.allCases[indexPath.row]
        if checked {
            selectedCategory.append(category)
        } else {
            if let indexForDelete = selectedCategory.firstIndex(of: category){
                selectedCategory.remove(at: indexForDelete)
            }
        }
    }
}




