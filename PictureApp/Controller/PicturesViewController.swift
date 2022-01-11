//
//  ViewController.swift
//  PictureApp
//
//  Created by Irina Gorbachenko on 26.11.2021.
//
import UIKit
import NetworkLayer

class PicturesViewController: UIViewController, OptionsViewControllerDelegate, FilterViewControllerDelegate {
    var totalHits = 0
    var currentPage = 1
    var selectedCategoryForSort: [Category] = [.music]
    var orderForCategories : Order = .popular
    var collectionViewFlowLayout : UICollectionViewFlowLayout!
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    var hits = [Post](){
        didSet {
            DispatchQueue.main.async{
                self.collectionView.reloadData()
            }
        }
    }
    
    // MARK:Delegate for categories
    func filterViewController(didSelectCategory selectedCategory: [Category]) {
        resetPageAndHitsArray()
        fetchHits(order: orderForCategories, selectedCategory: selectedCategory, currentPage: currentPage)
        selectedCategoryForSort = selectedCategory
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:Delegate for order
    func optionsViewController(didSelectOrderStrategy order: Order) {
        resetPageAndHitsArray()
        fetchHits(order: order, selectedCategory: selectedCategoryForSort, currentPage: currentPage)
        orderForCategories = order
        navigationController?.popViewController(animated: true)
    }
    
    func fetchHits(order: Order, selectedCategory: [Category], currentPage: Int) {
        PictureService(with: URLHTTPClient(session: URLSession.shared))
            .fetch(order: order, selectedCategory: selectedCategory, currentPage: currentPage) { result in
                switch result{
                case .success((let post, let totalHits)):
                    self.currentPage += 1
                    self.hits.append(contentsOf: post)
                    self.totalHits = totalHits
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(.init(title: "OK", style: .default, handler: { _ in
                        self.fetchHits(order: order, selectedCategory: selectedCategory, currentPage: currentPage)
                    }))
                    DispatchQueue.main.async {
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
    }
    
    //MARK:Custom dropDownButton
    @IBAction func showOptions(_ sender: UIButton) {
        let  optionsVc = self.storyboard?.instantiateViewController(withIdentifier: "OptionsViewController") as! OptionsViewController
        optionsVc.modalPresentationStyle = .popover
        let popoverVc = optionsVc.popoverPresentationController!
        popoverVc.permittedArrowDirections = .up
        popoverVc.sourceRect = sender.convert(sender.frame, to: nil)
        optionsVc.delegate = self
        popoverVc.delegate = self
        popoverVc.sourceView = view
        optionsVc.order = orderForCategories
        present(optionsVc, animated: true, completion: nil)
    }
    
    //MARK:Delegate for filter
    func didFilterSelected() {
        let filterVc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController")  as! FilterViewController
        filterVc.delegate = self
        filterVc.title = "Select a Category"
        filterVc.selectedCategory = selectedCategoryForSort
        navigationController?.pushViewController(filterVc, animated: true)
    }
    
    func setupCollectionView() {
        collectionView.register(GalleryCollectionViewCell.self, forCellWithReuseIdentifier: GalleryCollectionViewCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        setupCollectionViewLayout()
        view.addSubview(collectionView)
        let margins = view.layoutMarginsGuide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let buttonOptions = UIButton(type: .contactAdd)
        buttonOptions.addTarget(self, action: #selector(showOptions(_:)), for: .touchUpInside)
        navigationItem.rightBarButtonItem = .init(customView: buttonOptions)
        setupCollectionView()
        fetchHits(order: orderForCategories, selectedCategory: selectedCategoryForSort, currentPage: currentPage)
    }
    func resetPageAndHitsArray() {
        currentPage = 1
        hits.removeAll()
    }
}

extension PicturesViewController : UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hits.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GalleryCollectionViewCell.identifier, for: indexPath) as! GalleryCollectionViewCell
        let tagText = hits[indexPath.item].tags
        let url = URL(string: hits[indexPath.row].image)!
        ImageLoader(with: URLHTTPClient(session: URLSession.shared)).load(from: url) { (image) in
            DispatchQueue.main.async {
                guard collectionView.indexPath(for: cell) == indexPath else { return }
                cell.imageView.image = image
                cell.tagsLabel.text = tagText
            }
        }
        return cell
    }
    
    //MARK:Pagination
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if hits.count < totalHits && indexPath.row == hits.count - 1 {
            fetchHits(order: orderForCategories, selectedCategory: selectedCategoryForSort, currentPage: currentPage)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController(withIdentifier: "PreviewViewController") as! PreviewViewController
        controller.title = "Preview"
        let selectedPicture = hits[indexPath.item]
        controller.configureUI(with: selectedPicture)
        navigationController?.pushViewController(controller, animated: true)
    }
}

extension PicturesViewController : UICollectionViewDelegateFlowLayout {
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if UIDevice.current.orientation.isLandscape {
            landscapeCollectionViewLayout()
        } else {
            portraitCollectionViewLayout()
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        self.dismiss(animated: false, completion: nil)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            coordinator.animate (alongsideTransition: { (_) in
                self.landscapeCollectionViewLayout()
            }, completion: nil )
        case .portrait, .portraitUpsideDown:
            coordinator.animate (alongsideTransition: { (_) in
                self.portraitCollectionViewLayout()
            }, completion: nil )
        default:
            print("error")
        }
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func setupCollectionViewLayout() {
        collectionViewFlowLayout = UICollectionViewFlowLayout()
        collectionView.setCollectionViewLayout(collectionViewFlowLayout, animated: true)
        portraitCollectionViewLayout()
    }
    
    func portraitCollectionViewLayout() {
        let numberOfItemsPerRow: CGFloat = 1
        let lineSpacing: CGFloat = 50
        let interItemSpacing: CGFloat = 10
        let width = (collectionView.frame.width - CGFloat((numberOfItemsPerRow)) * interItemSpacing) / numberOfItemsPerRow
        let height = width
        collectionViewFlowLayout.sectionInsetReference = .fromSafeArea
        collectionViewFlowLayout.itemSize = CGSize (width: width, height: height)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
    }
    
    func landscapeCollectionViewLayout() {
        let numberOfItemsPerRow : CGFloat = 2
        let lineSpacing: CGFloat = 50
        let interItemSpacing: CGFloat = 10
        let width = (collectionView.frame.width - CGFloat((numberOfItemsPerRow - 1)) * interItemSpacing) / numberOfItemsPerRow
        let height = width
        collectionViewFlowLayout.sectionInsetReference = .fromSafeArea
        collectionViewFlowLayout.itemSize = CGSize (width: width, height: height)
        collectionViewFlowLayout.sectionInset = UIEdgeInsets.zero
        collectionViewFlowLayout.scrollDirection = .vertical
        collectionViewFlowLayout.minimumLineSpacing = lineSpacing
        collectionViewFlowLayout.minimumInteritemSpacing = interItemSpacing
    }
}

extension UIBarButtonItem {
    var frame: CGRect? {
        guard let view = self.value(forKey: "view") as? UIView else {
            return nil
        }
        return view.frame
    }
}

extension PicturesViewController: UIPopoverPresentationControllerDelegate {
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) -> Bool {
        return true
    }
    
}

extension URLSession: NetworkSession {
    public func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> NetworkTask {
        let dataTask = dataTask(with: URLRequest(url: url), completionHandler: completionHandler)
        return dataTask
    }
}

extension URLSessionDataTask: NetworkTask {}


