//
//  MovieCatalogViewController.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit

class MovieCatalogViewController: UIViewController {

    let model = ConfigManager.shared.movieCatalogModel()
    
    @IBOutlet weak var tableViewCatalog: UITableView!
    @IBOutlet weak var constraintTableViewCatalog: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var viewContainer: UIView!
    var currentController : MovieDetailViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = LS("Movie Catalog")
        
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !RequestManager.shared.isInitialized {
            ResourcesManager.shared.loadGenres()
            RequestManager.shared.startReachability {
                self.reloadData()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        closeKeyboard()
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

    func reloadData() {
        model.loadCatalog(search: searchBar.text ?? "") { (success) in
            self.tableViewCatalog.reloadData()
        }
    }
    
    func setupTableView() {
        
        let cellNib = UINib(nibName: CatalogTableViewCell.reuseIdentifier, bundle: Bundle.main)
        tableViewCatalog.register(cellNib, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        
    }
    
    func showDetails(_ movie: Movie) {
        
        if self.viewContainer == nil {
            let movieDetailViewController = MovieDetailViewController(nibName: MovieDetailViewController.reuseIdentifier, bundle: nil)
            movieDetailViewController.movie = movie
            self.navigationController?.pushViewController(movieDetailViewController, animated: true)
        } else {
        
            if currentController == nil {
                let movieDetailViewController = MovieDetailViewController(nibName: MovieDetailViewController.reuseIdentifier, bundle: nil)
                self.add(asChildViewController: movieDetailViewController)
            }
            self.currentController?.movie = movie
            
        }
        
    }
    
    // MARK: - Keyboard
    
    @objc func closeKeyboard() {
        
        self.view.endEditing(true)
        
    }
    
    @objc func keyboardWillShow(_ notification : NSNotification) {
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        var height = targetFrame.size.height
        height = max(0.0, height - self.view.safeInsets.bottom)
        updateKeyboardHeight(height);
    }
    
    @objc func keyboardWillHide(_ notification : NSNotification) {
        updateKeyboardHeight(0.0);
    }
    
    func updateKeyboardHeight(_ height : CGFloat) {
        constraintTableViewCatalog.constant = height
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Content Container
    
    private func add(asChildViewController viewController: MovieDetailViewController) {
        
        if (self.currentController != nil) {
            self.remove(asChildViewController: self.currentController!)
        }
        
        // Add Child View Controller
        addChild(viewController)
        
        // Add Child View as Subview
        viewContainer.addSubview(viewController.view)
        
        // Configure Child View
        viewController.view.frame = viewContainer.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify Child View Controller
        viewController.didMove(toParent: self)
        
        self.currentController = viewController
        
    }
    
    private func remove(asChildViewController viewController: MovieDetailViewController) {
        // Notify Child View Controller
        viewController.willMove(toParent: nil)
        
        // Remove Child View From Superview
        viewController.view.removeFromSuperview()
        
        // Notify Child View Controller
        viewController.removeFromParent()
    }
    
    // MARK: -
    
}

extension MovieCatalogViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CatalogTableViewCell.reuseIdentifier, for: indexPath) as! CatalogTableViewCell
        cell.movie = model.movies[indexPath.row]
        
        return cell
    }
    
}

extension MovieCatalogViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.viewContainer == nil {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        showDetails(model.movies[indexPath.row])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height {
            model.loadNextPage { (success) in
                if success {
                    self.tableViewCatalog.reloadData()
                }
            }
        }
    }
    
}

extension MovieCatalogViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        reloadData()
    }
    
}
