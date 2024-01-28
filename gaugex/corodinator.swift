import SwiftUI
import SceneKit
import CoreMotion
import Combine

enum GyroscopeAxis {
    case x, y, z
}

class Coordinator: NSObject, SCNSceneRendererDelegate, ObservableObject {
    var objectWillChange = PassthroughSubject<Void, Never>()

    var rotationAngleX: Double = 0.0 {
        didSet {
            objectWillChange.send()
        }
    }

    var rotationAngleY: Double = 0.0 {
        didSet {
            objectWillChange.send()
        }
    }

    var rotationAngleZ: Double = 0.0 {
        didSet {
            objectWillChange.send()
        }
    }

    var motionManager = CMMotionManager()

    override init() {
        super.init()
        print (" init corodinator")
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
        let rotationSpeed: Float = 12.0
//print ("hande in coor  \(gyroData)")
        // Use rotation around the x-axis, y-axis, and z-axis
        self.rotationAngleX = Double(gyroData.rotationRate.x) * Double(rotationSpeed)
        self.rotationAngleY = Double(gyroData.rotationRate.y) * Double(rotationSpeed)
        self.rotationAngleZ = Double(gyroData.rotationRate.z) * Double(rotationSpeed)
    }
}
