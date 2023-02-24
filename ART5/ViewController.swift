//
//  ViewController.swift
//  ART5
//
//  Created by 堀　壮吾 on 2020/06/26.
//  Copyright © 2020 堀　壮吾. All rights reserved.
//

import UIKit
import RealityKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate, UIGestureRecognizerDelegate{
    
    @IBOutlet var direct: UIButton! 
    @IBOutlet var plus: UIButton!
    @IBOutlet var minus: UIButton!
    @IBOutlet weak var arView: ARSCNView!
    @IBOutlet var label: UILabel!
    @IBOutlet var dimenion: UISegmentedControl!
    
     @IBAction func returnAR(segue:UIStoryboardSegue) {
        
    }
   
    
    
    
    var appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let configuration = ARWorldTrackingConfiguration()
    var sign  = "+"
    var selectedItem: String?
    var configunode: SCNNode?
    var movepoint: ARHitTestResult!
    var condition = 1
    var dimenS = "横"
    var dimen = 0
    var point = SCNNode()
    var st    = 1
    var count = 0
    
       private let contentsArray: [String] = ["tunnel","crode","road","cross","building","eki","car","car2"]
       private let arconfiguration: [String] = ["トンネル","カーブ","直線","交差点","ビル","駅","レクサス","ポルシェ"]
    
        override func viewDidLoad() {
            super.viewDidLoad()
            
            
            label.text = "設定を行ってください "
            label.textAlignment = NSTextAlignment.center
            label.textColor = .black
            arView.delegate = self
            arView.scene = SCNScene()
            
            configuration.frameSemantics = .personSegmentationWithDepth
            arView.session.run(configuration)
                
                let coachingOverlay = ARCoachingOverlayView()
                coachingOverlay.session = arView.session
                coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
                coachingOverlay.activatesAutomatically = true
                coachingOverlay.goal = .horizontalPlane
                arView.addSubview(coachingOverlay)
                
                //画面の中心に表示させる為に入れています。
                NSLayoutConstraint.activate([
                    coachingOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    coachingOverlay.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                    coachingOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
                    coachingOverlay.heightAnchor.constraint(equalTo: view.heightAnchor)
                ])
                
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = [.horizontal]
                arView.session.run(configuration)
                
                initialize()
                registerGestureRecognizers()
               // Configuration()
                high()
            
            }
    
    override func viewWillAppear(_ animated: Bool) {
        
        Label()
        print("appear")
    }
  
    func high (){
    
        if condition == 1{
            plus.isEnabled = false
            minus.isEnabled = false
            dimenion.isEnabled = false
            plus.isHidden = true
            minus.isHidden = true
            dimenion.isHidden = true
            
        }
    }
    func Label(){
        if condition == 1{
        if appDelegate.Main != -1{
            label.text = "\(arconfiguration[appDelegate.Main])が選択されています "
            label.textAlignment = NSTextAlignment.center
        }
            }
    }
    
    func initialize (){

       
           self.configuration.planeDetection = .horizontal
           self.arView.session.run(configuration)
           self.arView.autoenablesDefaultLighting = true
       }
    
    func registerGestureRecognizers() {
       /* let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubletap(_:)))
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 2
        arView.addGestureRecognizer(tapRecognizer)*/
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressView))
            self.arView.addGestureRecognizer(longPressGesture)
        longPressGesture.minimumPressDuration = 0.1
        
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
            tapGestureRecognizer.numberOfTapsRequired = 1
            self.arView.addGestureRecognizer(tapGestureRecognizer)
        
            /*arView.addGestureRecognizer(UIPanGestureRecognizer(
                    target: self, action: #selector(self.dragView(sender:))))*/
           /* let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubletap))
            tapRecognizer.numberOfTapsRequired = 2
            self.arView.addGestureRecognizer(tapRecognizer)
            
            
            
              tapGestureRecognizer.require(toFail: tapRecognizer)*/
            
                       
        
        
       }
    
    func Configuration(){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubletap))
        tapRecognizer.delegate = self
        tapRecognizer.numberOfTapsRequired = 2
        arView.addGestureRecognizer(tapRecognizer)
    }
    //遅延処理
    public func delay(bySeconds seconds: Double, dispatchLevel: DispatchLevel = .main, closure: @escaping () -> Void) {
       let dispatchTime = DispatchTime.now() + seconds
       dispatchLevel.dispatchQueue.asyncAfter(deadline: dispatchTime, execute: closure)
   }
    
    public enum DispatchLevel {
        case main, userInteractive, userInitiated, utility, background
        var dispatchQueue: DispatchQueue {
            switch self {
            case .main:                 return DispatchQueue.main
            case .userInteractive:      return DispatchQueue.global(qos: .userInteractive)
            case .userInitiated:        return DispatchQueue.global(qos: .userInitiated)
            case .utility:              return DispatchQueue.global(qos: .utility)
            case .background:           return DispatchQueue.global(qos: .background)
            }
        }
    }
    
//ダブルタップした時の動作
    @objc func doubletap(sender: UITapGestureRecognizer) {
       
        if condition == 0{
          
            if sender.state == .began {
                print("doubletap")
                let location = sender.location(in: self.arView)
                let hitTest  = self.arView.hitTest(location)

                if let result = hitTest.first  {
                    // 3Dアニメーションモデルは、複数パーツで構成されるため、親ノードの名前で判定・削除する
                    if result.node.parent!.name != nil
                    {
                        result.node.parent!.removeFromParentNode();
                    }
                }
            }
        }
    }
    
//    タップされた平面を認識してオブジェクトを設置する。
    @objc func tapped(sender: UITapGestureRecognizer) {
        if condition == 1{
           // タップされた位置を取得する
           let sceneView = sender.view as! ARSCNView
           let tapLocation = sender.location(in: sceneView)

           // タップされた位置のARアンカーを探す
           let hitTest = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
           if !hitTest.isEmpty {
               // タップした箇所が取得できていればitemを追加
               self.addItem(hitTestResult: hitTest.first!)
            }
           }
        
        if condition == 0{
            
            let location = sender.location(in: self.arView)
            let hitTest  = self.arView.hitTest(location)
                    print("spin")
                  
                    
                   if let result = hitTest.first  {
                       // 3Dアニメーションモデルは、複数パーツで構成されるため、親ノードの名前で判定・削除する
                        if result.node.parent!.name != nil
                       {
                           let action = SCNAction.rotateBy(x: 0, y: CGFloat(45 * (Float.pi / 180)), z: 0, duration: 0.1)
                           result.node.parent!.runAction(action)
                           label.text = "\(result.node.parent!.name!)を回転させました。"
                       }
                   }
                
            
            }
                    }
//     長押しされた時の動作
    @objc func longPressView(sender: UILongPressGestureRecognizer) {
        //長押し
   if condition == 1{
        if sender.state == .began {
            let location = sender.location(in: self.arView)
            let hitTest  = self.arView.hitTest(location)

            if let result = hitTest.first  {
                // 3Dアニメーションモデルは、複数パーツで構成されるため、親ノードの名前で判定・削除する
                if result.node.parent!.name != nil
                {
                    result.node.parent!.removeFromParentNode();
                    label.text = "\(result.node.parent!.name!)を削除しました。"
                }
            }
        }
    }
     if condition == 0{
        //var sta = sender.state
         st = sender.state.rawValue
        print("編集")
        if sender.state == .began {
            let location = sender.location(in: self.arView)
            let hitTest  = self.arView.hitTest(location)

            if let result = hitTest.first  {
                point = result.node.parent!
                // 3Dアニメーションモデルは、複数パーツで構成されるため、親ノードの名前で判定・編集する
                if result.node.parent!.name != nil{
                                self.setting(result.node.parent!)
                                count = 0
                            }
                        }
            }
                        }
            }
        
        
    
        
    
   
//    オブジェクトを設置する。
    func addItem(hitTestResult: ARHitTestResult) {
        if   (appDelegate.Main > -1)
        {
            Label()
            // アセットのより、シーンを作成
            let scene = SCNScene(named: "Models.scnassets/\(contentsArray[appDelegate.Main]).scn")

            // ノード作成
            let node = (scene?.rootNode.childNode(withName:contentsArray[appDelegate.Main] , recursively: true))!

            // 現実世界の座標を取得
            let transform = hitTestResult.worldTransform
            let thirdColumn = transform.columns.3

            // アイテムの配置
            node.position = SCNVector3(thirdColumn.x, thirdColumn.y, thirdColumn.z)
            self.arView.scene.rootNode.addChildNode(node)
        }
    }
    
           func move(hitTestResult: ARHitTestResult){
             if condition == 0{
         
               }
            }
              
    @IBAction func arView(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        condition = 1
        let nextView = storyboard.instantiateViewController(identifier: "View3" )
        nextView.modalPresentationStyle = .fullScreen
        present(nextView,animated: true,completion: nil)
        plus.isEnabled = false
        minus.isEnabled = false
        dimenion.isEnabled = false
        plus.isHidden = true
        minus.isHidden = true
        dimenion.isHidden = true
        
    }
    
    @IBAction func direction(_ sender: Any) {
        condition = 0
       label.text = "編集するノードを選択してください"
       label.textAlignment = NSTextAlignment.center
        plus.isEnabled = true
        minus.isEnabled = true
        dimenion.isEnabled = true
        plus.isHidden = false
        minus.isHidden = false
        dimenion.isHidden = false
    }
    
    @IBAction func plus(_ sender: Any) {
        sign = "+"
        set()
    }
    
    @IBAction func minus(_ sender: Any) {
          sign = "-"
          set()
       }
    
    @IBAction func segment(_ sender: UISegmentedControl) {
        switch  sender.selectedSegmentIndex {
        case 0:
            dimenS = "横に"
            dimen = 0;
            
        case 1:
            dimenS = "奥行きを"
            dimen = 1;
        case 2:
            dimenS = "高さを"
            dimen = 2;
            
        default:
            
            print("エラー");
        }
        set()
    }
    
    func set() {
        label.text = "\(dimenS)\(sign)します。"
    }
    

  @objc func setting(_ sender :SCNNode){
    switch dimen {
    case 0:
        var pointed:SCNVector3
        pointed = SCNVector3(0,0,0)
               if sign == "+"{
                pointed = SCNVector3(point.position.x+0.1,point.position.y,point.position.z)
                      }
                          
               if sign == "-"{
                pointed = SCNVector3(point.position.x-0.1,point.position.y,point.position.z)
                      }
               point.position = pointed
               set()
    case 1:
        var pointed:SCNVector3
        pointed = SCNVector3(0,0,0)
                if sign == "+"{
                pointed = SCNVector3(point.position.x,point.position.y,point.position.z+0.1)
                                     }
                if sign == "-"{
                pointed = SCNVector3(point.position.x,point.position.y,point.position.z-0.1)
                                     }
                point.position = pointed
                set()
    case 2:
        var pointed:SCNVector3
        pointed = SCNVector3(0,0,0)
               if sign == "+"{
                        //  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                pointed = SCNVector3(point.position.x,point.position.y+0.1,point.position.z)
                          //}
                      }
                          
              if sign == "-"{
                          //  DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                pointed = SCNVector3(point.position.x,point.position.y-0.1,point.position.z)
                            //}
                      }
             point.position = pointed
             set()
    default:
        break
    }
    if st == 1 || st == 2{
        if  count < 3 {
            delay(bySeconds: 0.1){
            self.setting(self.point)
        }
            self.count += 1
        }
       
            if self.count >= 3 {
                self.delay(bySeconds: 0.1){
            self.setting(self.point)
        }
        }
        }
    
    
         
    
/*
    @objc func dragView(sender: UIGestureRecognizer) {
        if condition == 0{
            
            
            let location = sender.location(in: self.arView)
            let hitTest  = self.arView.hitTest(location)
            
            
            if let result = hitTest.first  {
              print (result.node.parent!.name!)
                // 3Dアニメーションモデルは、複数パーツで構成されるため、親ノードの名前で判定・削除する
                if result.node.parent!.name != nil
                {
                    if sender.state == .changed{
                        print("move")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        
                            let locationd = sender.location(in: self.arView)
                             let planehit = self.arView.hitTest(locationd, types:.estimatedHorizontalPlane)
                           // self.movepoint = planehit.first!
                            if let resultd = planehit.first{
                               let  trans = resultd.worldTransform
                               let movepoint = trans.columns.3
                                let cameraposition = SCNVector3(x:0,y:0,z:0)
                                let camera = self.arView.pointOfView
                                
                                let camaraangle = camera!.eulerAngles
                                let arctan = atan(Double(camaraangle.z)/Double(camaraangle.x))*100
                                print()
                               // print(arctan)
                                
                                let pointInWorld = camera!.convertPosition(cameraposition, to: nil)
                                
                             /*   var nodeWorld = result.node.parent!.convertPosition(result.node.parent!.position, to: nil)
                                print(nodeWorld)
                                nodeWorld = camera?.convertPosition(pointInWorld, to: result.node.parent!) as! SCNVector3
                                print(nodeWorld)
 */
                          let x = Double(location.x-locationd.x)*0.001
                          let z = Double(location.y-locationd.y)*0.001
                          let xpoint = Double(location.x-locationd.x)*cos(arctan)*0.001
                          let zpoint = Double(location.y-locationd.y)*cos(arctan)*0.001
                             //   print(x)
                             //   print(z)
                               
                              //  print(cos(arctan*Double.pi/180))
                               
                                result.node.parent
                             //   print(zpoint)
                            //    result.node.parent!.position = SCNVector3(xpoint,result.node.parent!.position.y,zpoint)
                            result.node.parent!.position = SCNVector3(result.node.parent!.position.x-Float(x),result.node.parent!.position.y,result.node.parent!.position.z-Float(z))
                          
                                }
                        }
            
                   
                }
                }
                }
            }
        }
      */
    
    
    }

    
    
    
    }
    
