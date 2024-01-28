import SwiftUI
import SceneKit
import CoreMotion

struct SceneKitView: UIViewRepresentable {
    class Coordinator: NSObject, SCNSceneRendererDelegate {
        var cubeNode: SCNNode?
        var motionManager = CMMotionManager()
        
        override init() {
            super.init()
            
            if motionManager.isGyroAvailable {
                motionManager.gyroUpdateInterval = 0.1
                motionManager.startGyroUpdates(to: .main) { [weak self] (gyroData, error) in
                    guard let gyroData = gyroData else { return }
                    self?.handleGyroscopeData(gyroData)
                }
            } else {
                print("Gyroscope is not available")
            }
        }
        
        deinit {
            motionManager.stopGyroUpdates()
        }
        
        func handleGyroscopeData(_ gyroData: CMGyroData) {
            // Adjust the rotation speed as needed
            let rotationSpeed: Float = 0.1
            
            // Use rotation around the x-axis
            let rotationX = Float(gyroData.rotationRate.x) * rotationSpeed
            let rotationY = Float(gyroData.rotationRate.y) * rotationSpeed
            
            // Apply rotation around the x-axis while maintaining the current orientation
            let currentRotation = self.cubeNode?.rotation
            _ = currentRotation!.x + rotationX
            let updatedRotationY = currentRotation!.y + rotationY
            
            // Use SCNAction for smooth rotation
            let rotateAction = SCNAction.rotateTo(
                x: CGFloat(currentRotation!.x),
                y: CGFloat(updatedRotationY),
                z: CGFloat(currentRotation!.z),
                duration: 0.1
            )
            
            self.cubeNode?.runAction(rotateAction)
        }
        
        
        
        
        
        
        // ... rest of the Coordinator class
    }
    
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
   
    
    
    
    func makeUIView(context: Context) -> SCNView {
        let sceneView = SCNView()
        sceneView.scene = SCNScene()
        sceneView.scene = SCNScene(named: "caravan.scn")!
      

        // Create and add a camera to the scene
        let cameraNode = createCamera()
        sceneView.scene?.rootNode.addChildNode(cameraNode)

        // Create a representation for the camera
        let cameraRepresentation = createCameraRepresentation(for: cameraNode)
        cameraNode.addChildNode(cameraRepresentation)

        // Create and add a cube to the scene
        let cubeNode = createCube()
        sceneView.scene?.rootNode.addChildNode(cubeNode)

        context.coordinator.cubeNode = cubeNode
        sceneView.delegate = context.coordinator

        // Set the camera as the point of view
        sceneView.pointOfView = cameraNode

        sceneView.autoenablesDefaultLighting = true
        sceneView.allowsCameraControl = true

        return sceneView
    }

    // Function to create and return a camera node
    func createCamera() -> SCNNode {
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: -3)
        return cameraNode
    }

    // Function to create and return a representation for the camera
    func createCameraRepresentation(for cameraNode: SCNNode) -> SCNNode {
        let cameraGeometry = SCNSphere(radius: 0.1)
        let cameraRepresentation = SCNNode(geometry: cameraGeometry)
        cameraRepresentation.geometry?.firstMaterial?.diffuse.contents = UIColor.green
        return cameraRepresentation
    }

    // Function to create and return a cube node
    func createCube() -> SCNNode {
        let cubeNode = SCNNode(geometry: SCNBox(width: 1.0, height: 1.5, length: 2.0, chamferRadius: 0.0))
      //  cubeNode.geometry?.firstMaterial?.diffuse.contents = UIColor.red
        cubeNode.pivot = SCNMatrix4MakeTranslation(0, 0.1, 0)
        let CobeNoderotation: SCNVector4 = SCNVector4(x: 0, y: 0, z: 0, w: .pi)
        cubeNode.rotation = CobeNoderotation
        cubeNode.position = SCNVector3(0, 0, -5)
        let redMaterial = SCNMaterial()
        redMaterial.diffuse.contents = UIColor.red
        let blueMaterial = SCNMaterial()
        blueMaterial.diffuse.contents = UIColor.blue
        cubeNode.geometry?.materials = [redMaterial, blueMaterial, blueMaterial, blueMaterial, blueMaterial, blueMaterial]
        return cubeNode
    }



    
    func updateUIView(_ uiView: SCNView, context: Context) {
        // Update the view if needed
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            SceneKitView()
                .frame(width: 300, height: 600)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
