//
//  SentMemesTableViewController.swift
//  memeME
//
//  Created by Mohamed Ezzat on 29/11/2021.
//

import UIKit

class SentMemesTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tbl: UITableView!
    
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
        self.tbl.reloadData()
    }

    @IBAction func addMemeBtn(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tblCell", for: indexPath) as! UITableViewCell
        cell.imageView?.image = memes[indexPath.row].memedImage
        cell.textLabel?.text  = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
        return cell
    }

}
