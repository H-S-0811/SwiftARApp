//
//  settingController.swift
//  ART5
//
//  Created by 堀　壮吾 on 2020/06/28.
//  Copyright © 2020 堀　壮吾. All rights reserved.
//

import UIKit

class SettingController: UIViewController {
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet var contentsView: UICollectionView!
  private enum ContentType: Int, CaseIterable {
          case web
          case usdz
      }

      // Web Contents Tuple(Mac Pro & Pro Display XDR)
      
      // USDZファイル名のArray
      private let contentsArray: [String] = ["tunnel","crode","road","cross","building","eki","car","car2"]
      // セルを押した際のCollectionViewのindex値
      private var selectedItemIndex: Int = -1

      override func viewDidLoad() {
          super.viewDidLoad()
          self.setUpUI()
      }

      private func setUpUI() {
          self.navigationItem.title = "Simple AR Experience"
          self.contentsView.delegate = self
          self.contentsView.dataSource = self
          let cellNib = UINib(nibName: "ContentsCollectionViewCell", bundle: nil)
          self.contentsView.register(cellNib, forCellWithReuseIdentifier: "ContentsCell")
      }
}
     

  // MARK: - UICollectionViewDelegate

  extension SettingController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentsCell", for: indexPath) as! ContentsCollectionViewCell
          switch indexPath.section {
          default:
            
              // CollectionViewのセルをタップしたindex値を保持しておく
              appDelegate.Main = indexPath.row
              print(appDelegate.Main)
            cell.baseView.backgroundColor = .red
            
          }
        
      }
  
  }

  // MARK: - UICollectionViewDataSource

  extension SettingController: UICollectionViewDataSource {

      func numberOfSections(in collectionView: UICollectionView) -> Int {
          
          return 1
      }


      func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
          
          
          return contentsArray.count
          
      }

      func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
          let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentsCell", for: indexPath) as! ContentsCollectionViewCell
          switch indexPath.section {
          default:
           
            let selectedBGView = UIView(frame: cell.frame)
            selectedBGView.backgroundColor = .black
            cell.selectedBackgroundView = selectedBGView
              cell.contentsImageView.image = UIImage(named: self.contentsArray[indexPath.row])
          }
          return cell
      }
  
}
  // MARK: - UICollectionViewDelegateFlowLayout

  extension SettingController: UICollectionViewDelegateFlowLayout {

      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let width: CGFloat = UIScreen.main.bounds.width / 2 - 7.5
          let height = width
          return CGSize(width: width, height: height)
      }
  }

