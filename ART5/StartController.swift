//
//  StartController.swift
//  ART5
//
//  Created by 堀　壮吾 on 2020/07/06.
//  Copyright © 2020 堀　壮吾. All rights reserved.
//

import UIKit

class StartController: UIViewController {
    @IBOutlet var StartButton: UIButton!
    
    @IBAction func returnTop(segue: UIStoryboardSegue){
    }
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func StartButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextView = storyboard.instantiateViewController(identifier: "View2" )
        nextView.modalPresentationStyle = .fullScreen
        present(nextView,animated: true,completion: nil)
        
        appDelegate.Main = -1
        
    }
    @IBAction func StartButton2(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let nextView = storyboard.instantiateViewController(identifier: "View4" )
        nextView.modalPresentationStyle = .fullScreen
        present(nextView,animated: true,completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
