//
//  SentMemesCollectionViewController.swift
//  mememe
//
//  Created by Emen Zhao on 3/17/19.
//  Copyright © 2019 Emen Zhao. All rights reserved.
//

import UIKit

// MARK: - SentMemesCollectionViewController

class SentMemesCollectionViewController: UICollectionViewController {

    var memes: [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    // MARK: Outlets
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    // MARK: Lifecycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(takeMeme))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.reloadData()
        print(memes)
    }
    
    // MARK: Collection view data source
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SentMemeCollectionViewCell", for: indexPath) as! SentMemeCollectionViewCell
        let meme = memes[indexPath.row]
        cell.image.image = meme.memedImage
        return cell
    }
    
    // MARK: Collection view action
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meme = memes[indexPath.row]
        let detailView = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! DetailMemeViewController
        detailView.meme = meme
        navigationController?.pushViewController(detailView, animated: true)
    }
    
    // MARK: Privates
    
    private func setLayout() {
        let space:CGFloat = 3.0
        let wDimension = (view.frame.size.width - 2*space) / 3.0
        let hDimension = (view.frame.size.width - 2*space) / 3.0
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: wDimension, height: hDimension)
    }
    
    @objc func takeMeme() {
        let controller = storyboard?.instantiateViewController(withIdentifier: "MemeEditViewController") as! MemeEditViewController
        present(controller, animated: true, completion: nil)
    }

}
