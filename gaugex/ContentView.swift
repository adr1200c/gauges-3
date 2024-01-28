import SwiftUI
import CoreMotion
struct GyroscopeGauge: View {
    var axis: String
    var rotationAngle: Double
    var color: Color
    
    var body: some View {
        VStack {
            Text("\(axis)-Axis")
            Text(String(format: "%.2f", rotationAngle))
                .font(.system(size: 5))
                .padding(.bottom, 5)
               
            ZStack {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Rectangle()
                    .frame(width: 5, height: 50)
                    .foregroundColor(color)
                    .rotationEffect(Angle(degrees: rotationAngle), anchor: .bottom)

                Path { path in
                    for number in -5...5 {
                        let angle = Double(number) * .pi / 10
                        let x = 50 * sin(angle)
                        let y = -50 * cos(angle)
                        path.addEllipse(in: CGRect(x: x + 194, y: y + 48, width: 5, height: 5))
                    }
                }
                .fill(Color.white)
            }

        }
    }
}

struct TripleGaugeView: View {
    @ObservedObject var coordinator = Coordinator()
    
    init() {
        self.coordinator = Coordinator()
        // Start gyroscope updates for the X-axis when the view is initialized
        
    }
    
    @State private var rotationAngleX: Double = 0.0
    @State private var rotationAngleY: Double = 0.0
    @State private var rotationAngleZ: Double = 0.0
    
    let motionManager = CMMotionManager()
    
    var body: some View {
        VStack {
            Text("Gyroscope Triple Gauges")
                .font(.headline)
                .padding()
            
            Spacer()
            
            VStack() {
                Image("xyz.png") // Assuming "example.png" is in your project
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 200) // Adjust size as needed
                
                // Gauge for X-axis
                            GyroscopeGauge(axis: "X", rotationAngle: coordinator.rotationAngleX, color: .orange)
                                .onAppear {
                                    // startGyroscopeUpdates(forAxis: .x)
                                }
                                .onDisappear {
                                    // stopGyroscopeUpdates()
                                }

                
                // Gauge for Y-axis
              
                            GyroscopeGauge(axis: "Y", rotationAngle: coordinator.rotationAngleY, color: .blue)
                                .onAppear {
                                    // startGyroscopeUpdates(forAxis: .x)
                                }
                                .onDisappear {
                                    // stopGyroscopeUpdates()
                                }

                
                // Gauge for Z-axis
                            GyroscopeGauge(axis: "Z", rotationAngle: coordinator.rotationAngleZ, color: .green)
                                .onAppear {
                                    // startGyroscopeUpdates(forAxis: .x)
                                }
                                .onDisappear {
                                    // stopGyroscopeUpdates()
                                }

            }
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
        
    }
    
    func startGyroscopeUpdates(forAxis axis: Axis) {
        print("here")
        if motionManager.isGyroAvailable {
            motionManager.gyroUpdateInterval = 0.1
            motionManager.startGyroUpdates(to: .main) { gyroData, error in
                guard let gyroData = gyroData else { return }
                handleGyroscopeData(gyroData, forAxis: axis)
            }
        }
    }
    
    func stopGyroscopeUpdates() {
        motionManager.stopGyroUpdates()
    }
    
    func handleGyroscopeData(_ gyroData: CMGyroData, forAxis axis: Axis) {
        // Adjust the rotation angle based on gyroscope data
        let rotationSpeed: Double = 2.0
        
        switch axis {
        case .x:
            rotationAngleX += Double(gyroData.rotationRate.x) * rotationSpeed
            rotationAngleX = min(max(rotationAngleX, -45), 45)
            print("in cvie X: \(gyroData.rotationRate.x)")
            
            
        case .y:
            rotationAngleY += Double(gyroData.rotationRate.y) * rotationSpeed
            rotationAngleY = min(max(rotationAngleY, -45), 45)
            print("in cview Y: \(gyroData.rotationRate.y)")
            
            
        case .z:
            rotationAngleZ += Double(gyroData.rotationRate.z) * rotationSpeed
            rotationAngleZ = min(max(rotationAngleZ, -45), 45)
            print("in cview z: \(gyroData.rotationRate.z)")
            
        }
    }
    
    enum Axis {
        case x
        case y
        case z
    }
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            TripleGaugeView()
                .navigationBarTitle("Triple Gyroscope Gauges")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
