//
//  MovieDetailViewController.swift
//  TMDbDemo
//
//  Created by Pavel Belevtsev on 4/3/19.
//  Copyright © 2019 Pavel Belevtsev. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    public static let reuseIdentifier = "MovieDetailViewController"
    
    let model = MovieDetailVM()
    var movie: Movie? {
        didSet {
            if movie != nil {
                model.update(with: movie!) { (success) in
                    if self.isViewLoaded && (self.view.window != nil) {
                        self.tableViewDetail.reloadData()
                    }
                }
            }
        }
    }
    
    @IBOutlet weak var tableViewDetail: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = LS("Movie Detail")
        
        setupTableView()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupTableView() {
        
        var cellNib = UINib(nibName: DetailHeaderTableViewCell.reuseIdentifier, bundle: Bundle.main)
        tableViewDetail.register(cellNib, forCellReuseIdentifier: DetailHeaderTableViewCell.reuseIdentifier)
        cellNib = UINib(nibName: DetailInfoTableViewCell.reuseIdentifier, bundle: Bundle.main)
        tableViewDetail.register(cellNib, forCellReuseIdentifier: DetailInfoTableViewCell.reuseIdentifier)
        
    }
    
}

extension MovieDetailViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellInfo = model.cellData(model.cells[indexPath.row])
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellInfo.identifier, for: indexPath) as! DetailTableViewCell
        
        cell.update(with: movie!, data: cellInfo.data)
        
        return cell
    }
    
}

