//
//  ViewController.swift
//  ARDemo
//
//  Created by zz go on 2018/1/7.
//  Copyright © 2018年 zenonhuang. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene,存放所有 3D 几何体的容器
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = scene
        
        /** 将10厘米的立方体放置在相机初始位置前20厘米处**/
        // 想要绘制的 3D 立方体
        let boxGeometry = SCNBox(width:0.1, height:0.1, length:0.1, chamferRadius:0)
        // 将几何体包装为 node 以便添加到 scene
        let cubeNode    = SCNNode(geometry:boxGeometry)
        
        cubeNode.position = SCNVector3(0,0, -0.2)
        // rootNode 是一个特殊的 node，它是所有 node 的起始点
        sceneView.scene.rootNode.addChildNode(cubeNode)
        
        sceneView.autoenablesDefaultLighting = true
        
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 创建 session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal
        
        // 运行视图 Session
        sceneView.session.run(configuration)
        

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        //1.使用场景加载scn文件（scn格式文件是一个基于3D建模的文件，使用3DMax软件可以创建，这里系统有一个默认的3D飞机）--------在右侧我添加了许多3D模型，只需要替换文件名即可
//        let scene = SCNScene(named:"art.scnassets/ship.scn")
        
        //2.获取飞机节点（一个场景会有多个节点，此处我们只写，飞机节点则默认是场景子节点的第一个）
        //所有的场景有且只有一个根节点，其他所有节点都是根节点的子节点
//        let shipNode = scene!.rootNode.childNodes[0]
//        shipNode.transform = SCNMatrix4MakeScale(0.3, 0.3, 0.3);
        //x/y/z/坐标相对于世界原点，也就是相机位置
//        shipNode.position = SCNVector3Make(-1, -1, -1);
        //3.将飞机节点添加到当前屏幕中
//        sceneView.scene.rootNode.addChildNode(shipNode)
        
    }
    //MARK: - ARSCNViewDelegate
    
    
    //可以使用ARAnchor类来跟踪现实世界的位置，例如，当启用平面检测时，ARKit会为每个检测到的平面添加并更新锚点。
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else {
            return 
        }
        
        let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
        
        let planeNode = SCNNode(geometry: plane)
        
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        node.addChildNode(planeNode)
     
    }
    
    // Override to create and configure nodes for anchors added to the view's session.
    /**
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     
     //        let node = SCNNode()
     
     return node
     }
     **/

    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
