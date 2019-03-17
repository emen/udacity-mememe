//
//  SentMemesTableViewController.swift
//  mememe
//
//  Created by Emen Zhao on 3/17/19.
//  Copyright © 2019 Emen Zhao. All rights reserved.
//

import UIKit

// MARK: - SentMemesTableViewController

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takeMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    // MARK: Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentMemesTableViewCell")!
        let meme = memes[indexPath.row]
        cell.imageView?.image = meme.memedImage
        cell.textLabel?.text = meme.topText + "..." + meme.bottomText
        return cell
    }
    
    // MARK: Table view action
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let detailView = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! DetailMemeViewController
        detailView.meme = meme
        navigationController?.pushViewController(detailView, animated: true)
        
    }
    
    // MARK: Private
    
    @objc func takeMeme() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditViewController") as! MemeEditViewController
        present(controller, animated: true, completion: nil)
    }

}
