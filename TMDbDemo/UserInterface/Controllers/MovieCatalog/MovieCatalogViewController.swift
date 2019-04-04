//
//  MovieCatalogViewController.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/2/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit

class MovieCatalogViewController: UIViewController {

    let model = MovieCatalogVM()
    
    @IBOutlet weak var tableViewCatalog: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = LS("Movie Catalog")
        
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !RequestManager.shared.isInitialized {
            RequestManager.shared.startReachability {
                self.reloadData()
            }
        }
    }

    func reloadData() {
        model.loadCatalog { (success) in
            self.tableViewCatalog.reloadData()
        }
    }
    
    func setupTableView() {
        
        let cellNib = UINib(nibName: CatalogTableViewCell.reuseIdentifier, bundle: Bundle.main)
        tableViewCatalog.register(cellNib, forCellReuseIdentifier: CatalogTableViewCell.reuseIdentifier)
        
    }
    
    func showDetails(_ movie: Movie) {
        
        let movieDetailViewController = MovieDetailViewController(nibName: MovieDetailViewController.reuseIdentifier, bundle: nil)
        movieDetailViewController.movie = movie
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
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
        tableView.deselectRow(at: indexPath, animated: true)
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

