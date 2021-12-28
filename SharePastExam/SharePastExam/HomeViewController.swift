//
//  HomeViewController.swift
//  SharePastExam
//
//  Created by Takashi Sakai on 2021/09/27.
//

import Foundation
import UIKit
import Firebase


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var histryCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    

    @IBOutlet weak var RecentlyTable: UITableView!
    @IBOutlet weak var RecentlyTableHeight: NSLayoutConstraint!
    @IBOutlet weak var RecentlyTableWidth: NSLayoutConstraint!
    
    private var images = UIImage(named: "IMG_6906")
    
    let cellID = "cellID"
    let width = UIScreen.main.bounds.width
    var RecentlySub = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
    let SliderCellId = "SliderCellId"
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        RecentlySub = UserDefaults.standard.array(forKey: "RecentlySub") as! [String]
        print(RecentlySub)
        RecentlyTable.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        RecentlyTableWidth.constant = width
        RecentlyTableHeight.constant = 15*30
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 330, height: 200)
        histryCollectionView.collectionViewLayout = layout
        setupViews()
        
        
        
        RecentlyTable.delegate = self
        RecentlyTable.dataSource = self
        RecentlyTable.register(RecentlyTableViewCell.self, forCellReuseIdentifier: "cellID")
        RecentlyTable.backgroundColor = .clear
        RecentlyTable.isScrollEnabled = true


    }
    private func setupViews(){
        histryCollectionView.delegate = self
        histryCollectionView.dataSource = self
        histryCollectionView.register(SliderCell.self, forCellWithReuseIdentifier: SliderCellId)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        confirmLoggedInUser()
    }
    
    private func confirmLoggedInUser() {
        if Auth.auth().currentUser?.uid == nil  {
            presentToMainViewController()
            print(Auth.auth().currentUser?.uid)
        }
    }
    
    private func presentToMainViewController() {
        let storyBoard = UIStoryboard(name: "SignUp", bundle: nil)
        let SignUp = storyBoard.instantiateViewController(identifier: "SignUp") as! SignUp
        
        let navController = UINavigationController(rootViewController: SignUp)
        
        navController.modalPresentationStyle = .fullScreen
        
        self.present(navController, animated: true, completion: nil)
    }
    
   
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) ->CGSize {
        let width = self.view.frame.width
        
            return.init(width: 330, height: 200)
        }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = histryCollectionView.dequeueReusableCell(withReuseIdentifier:SliderCellId, for: indexPath) as! SliderCell
        cell.images = self.images
            return cell
        }
    }


extension HomeViewController{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RecentlySub.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text  = RecentlySub[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Subtimes", bundle: nil)
        let jumpview = storyboard.instantiateViewController(withIdentifier: "Subtimes") as! SubTimesViewController
        
        jumpview.subTitle = RecentlySub[indexPath.row] as! String
        navigationController?.pushViewController(jumpview, animated: true)
    }
    
}


