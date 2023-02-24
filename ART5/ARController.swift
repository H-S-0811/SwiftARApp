//
//  ARController.swift
//  ART5
//
//  Created by 堀　壮吾 on 2020/07/05.
//  Copyright © 2020 堀　壮吾. All rights reserved.
//
import UIKit
import  QuickLook
import SafariServices

final class ARController: UIViewController {
    

    @IBOutlet var contentsCollectionView: UICollectionView!

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
            self.contentsCollectionView.delegate = self
            self.contentsCollectionView.dataSource = self
            let cellNib = UINib(nibName: "ContentsCollectionViewCell", bundle: nil)
            self.contentsCollectionView.register(cellNib, forCellWithReuseIdentifier: "ContentsCell")
        }

        private func previewARContents() {
            let previewController = QLPreviewController()
            previewController.dataSource = self
            self.present(previewController, animated: true, completion: nil)
        }
    }

    // MARK: - UICollectionViewDelegate

    extension ARController: UICollectionViewDelegate {

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            switch indexPath.section {
                
            default:
                // CollectionViewのセルをタップしたindex値を保持しておく
                self.selectedItemIndex = indexPath.row
                // QLPreviewControllerを開く
                self.previewARContents()
            }
        }
    }

    // MARK: - UICollectionViewDataSource

    extension ARController: UICollectionViewDataSource {

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
                cell.contentsImageView.image = UIImage(named: self.contentsArray[indexPath.row])
            }
            return cell
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout

    extension ARController: UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let width: CGFloat = UIScreen.main.bounds.width / 2 - 7.5
            let height = width
            return CGSize(width: width, height: height)
        }
    }

    // MARK:- QLPreviewController DataSource

    extension ARController: QLPreviewControllerDataSource {

        /// Quick Look で表示するアイテム数
        ///
        /// - Parameter controller: controller
        /// - Returns: Quick Look で表示するアイテム数
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }

        /// Quick Look で表示するアイテムを返す
        ///
        /// - Parameters:
        ///   - controller: controller
        ///   - index: アイテムのindex値
        /// - Returns: Quick Look で表示するアイテム
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            // Return the file URL to the .usdz file
            let fileUrl = (self.selectedItemIndex < 0) ?
                Bundle.main.url(forResource: "cupandsaucer", withExtension: "usdz")! :
                Bundle.main.url(forResource: self.contentsArray[self.selectedItemIndex], withExtension: "usdz")!
            return fileUrl as QLPreviewItem
        }
    }
