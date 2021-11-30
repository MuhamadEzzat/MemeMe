//
//  SentMemesCollectionViewController.swift
//  memeME
//
//  Created by Mohamed Ezzat on 29/11/2021.
//

import UIKit

class SentMemesCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var collectionmeme: UICollectionView!
    
    var memes = [Meme]()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(navigationController?.isNavigationBarHidden == true, animated: true)
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        memes = appDelegate.memes
        self.collectionmeme.reloadData()
    }
    
    @IBAction func addMemeBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! CollectionCell
        cell.img.image = memes[indexPath.row].memedImage
        cell.labeltext.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        return cell
    }
    
}
