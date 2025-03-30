import SwiftUI
import MetalKit

struct CustomizableShaderBackground: View {
    @State private var time: Float = 0
    @State private var timer: Timer? = nil
    
    // Customizable properties
    var color1: Color
    var color2: Color
    var color3: Color
    var spinSpeed: Float
    var moveSpeed: Float
    var contrast: Float
    var lighting: Float
    var spinAmount: Float
    var pixelFilter: Float
    var isRotating: Bool
    var offset: CGPoint
    
    init(
        color1: Color = .red,
        color2: Color = .blue,
        color3: Color = Color(red: 0.086, green: 0.137, blue: 0.145),
        spinSpeed: Float = 2.0,
        moveSpeed: Float = 4.0,
        contrast: Float = 3.5,
        lighting: Float = 0.4,
        spinAmount: Float = 0.35,
        pixelFilter: Float = 740.0,
        isRotating: Bool = true,
        offset: CGPoint = CGPoint(x: 0, y: 0)
    ) {
        self.color1 = color1
        self.color2 = color2
        self.color3 = color3
        self.spinSpeed = spinSpeed
        self.moveSpeed = moveSpeed
        self.contrast = contrast
        self.lighting = lighting
        self.spinAmount = spinAmount
        self.pixelFilter = pixelFilter
        self.isRotating = isRotating
        self.offset = offset
    }
    
    var body: some View {
        MetalShaderView(
            time: $time,
            color1: colorToVector(color1),
            color2: colorToVector(color2),
            color3: colorToVector(color3),
            spinSpeed: spinSpeed,
            moveSpeed: moveSpeed,
            contrast: contrast,
            lighting: lighting,
            spinAmount: spinAmount,
            pixelFilter: pixelFilter,
            isRotating: isRotating,
            offset: SIMD2<Float>(Float(offset.x), Float(offset.y))
        )
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Start the animation timer
            timer = Timer.scheduledTimer(withTimeInterval: 1.0/25.0, repeats: true) { _ in
                time += 1.0/25.0
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
    
    // Convert SwiftUI Color to SIMD4<Float>
    private func colorToVector(_ color: Color) -> SIMD4<Float> {
        let uiColor = UIColor(color)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        return SIMD4<Float>(Float(red), Float(green), Float(blue), Float(alpha))
    }
}

struct BalatroBackgroundView: View {
    @State private var time: Float = 0
    @State private var timer: Timer? = nil
    
    var body: some View {
        MetalShaderView(
            time: $time,
            color1: SIMD4<Float>(0.871, 0.267, 0.231, 1.0),  // Red
            color2: SIMD4<Float>(0.0, 0.42, 0.706, 1.0),     // Blue
            color3: SIMD4<Float>(0.086, 0.137, 0.145, 1.0),  // Dark
            spinSpeed: 2.0,
            moveSpeed: 4.0,
            contrast: 3.5,
            lighting: 0.4,
            spinAmount: 0.35,
            pixelFilter: 740.0,
            isRotating: true,
            offset: SIMD2<Float>(0, 0)
        )
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            // Start the animation timer
            timer = Timer.scheduledTimer(withTimeInterval: 1.0/60.0, repeats: true) { _ in
                time += 1.0/60.0
            }
        }
        .onDisappear {
            timer?.invalidate()
            timer = nil
        }
    }
}

// Preview provider
struct BalatroBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        BalatroBackgroundView()
    }
}

struct MetalShaderView: UIViewRepresentable {
    @Binding var time: Float
    var color1: SIMD4<Float>
    var color2: SIMD4<Float>
    var color3: SIMD4<Float>
    var spinSpeed: Float
    var moveSpeed: Float
    var contrast: Float
    var lighting: Float
    var spinAmount: Float
    var pixelFilter: Float
    var isRotating: Bool
    var offset: SIMD2<Float>
    
    func makeUIView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.delegate = context.coordinator
        mtkView.enableSetNeedsDisplay = true
        mtkView.device = context.coordinator.device
        mtkView.framebufferOnly = false
        mtkView.clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
        mtkView.drawableSize = mtkView.frame.size
        mtkView.isPaused = false
        mtkView.preferredFramesPerSecond = 15
        
        return mtkView
    }
    
    func updateUIView(_ uiView: MTKView, context: Context) {
        context.coordinator.time = time
        context.coordinator.color1 = color1
        context.coordinator.color2 = color2
        context.coordinator.color3 = color3
        context.coordinator.spinSpeed = spinSpeed
        context.coordinator.moveSpeed = moveSpeed
        context.coordinator.contrast = contrast
        context.coordinator.lighting = lighting
        context.coordinator.spinAmount = spinAmount
        context.coordinator.pixelFilter = pixelFilter
        context.coordinator.isRotating = isRotating
        context.coordinator.offset = offset
        uiView.setNeedsDisplay()
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        let parent: MetalShaderView
        let device: MTLDevice
        let commandQueue: MTLCommandQueue
        let pipelineState: MTLRenderPipelineState
        let vertexBuffer: MTLBuffer
        
        var time: Float = 0
        var color1: SIMD4<Float>
        var color2: SIMD4<Float>
        var color3: SIMD4<Float>
        var spinSpeed: Float
        var moveSpeed: Float
        var contrast: Float
        var lighting: Float
        var spinAmount: Float
        var pixelFilter: Float
        var isRotating: Bool
        var offset: SIMD2<Float>
        
        init(_ parent: MetalShaderView) {
            self.parent = parent
            self.color1 = parent.color1
            self.color2 = parent.color2
            self.color3 = parent.color3
            self.spinSpeed = parent.spinSpeed
            self.moveSpeed = parent.moveSpeed
            self.contrast = parent.contrast
            self.lighting = parent.lighting
            self.spinAmount = parent.spinAmount
            self.pixelFilter = parent.pixelFilter
            self.isRotating = parent.isRotating
            self.offset = parent.offset
            
            guard let device = MTLCreateSystemDefaultDevice() else {
                fatalError("Metal is not supported on this device")
            }
            self.device = device
            
            guard let commandQueue = device.makeCommandQueue() else {
                fatalError("Cannot create Metal command queue")
            }
            self.commandQueue = commandQueue
            
            // Create quad vertices (two triangles)
            let quadVertices: [Float] = [
                -1.0, -1.0, 0.0, 1.0,  0.0, 0.0,
                 1.0, -1.0, 0.0, 1.0,  1.0, 0.0,
                -1.0,  1.0, 0.0, 1.0,  0.0, 1.0,
                 1.0,  1.0, 0.0, 1.0,  1.0, 1.0
            ]
            
            guard let vertexBuffer = device.makeBuffer(bytes: quadVertices,
                                                      length: quadVertices.count * MemoryLayout<Float>.size,
                                                      options: .storageModeShared) else {
                fatalError("Failed to create vertex buffer")
            }
            self.vertexBuffer = vertexBuffer
            
            // Load shader
            let library = try! device.makeDefaultLibrary(bundle: Bundle.main)
            let vertexFunction = library.makeFunction(name: "vertexShader") ??
            Coordinator.createDefaultVertexFunction(device: device)
            let fragmentFunction = library.makeFunction(name: "balatroFragment")!
            
            // Create pipeline state
            let pipelineDescriptor = MTLRenderPipelineDescriptor()
            pipelineDescriptor.vertexFunction = vertexFunction
            pipelineDescriptor.fragmentFunction = fragmentFunction
            pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
            
            self.pipelineState = try! device.makeRenderPipelineState(descriptor: pipelineDescriptor)
            
            super.init()
        }
        
        static func createDefaultVertexFunction(device: MTLDevice) -> MTLFunction {
            // Create a simple vertex shader if one isn't available in the library
            let source = """
            #include <metal_stdlib>
            using namespace metal;
            
            struct VertexOut {
                float4 position [[position]];
                float2 uv;
            };
            
            vertex VertexOut vertexShader(uint vertexID [[vertex_id]],
                                          constant float *vertices [[buffer(0)]]) {
                VertexOut out;
                float2 position = float2(vertices[vertexID * 6], vertices[vertexID * 6 + 1]);
                out.position = float4(position, 0, 1);
                out.uv = float2(vertices[vertexID * 6 + 4], vertices[vertexID * 6 + 5]);
                return out;
            }
            """
            let library = try! device.makeLibrary(source: source, options: nil)
            return library.makeFunction(name: "vertexShader")!
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            // Handle resize
        }
        
        func draw(in view: MTKView) {
            guard let drawable = view.currentDrawable else { return }
            
            let commandBuffer = commandQueue.makeCommandBuffer()!
            
            let renderPassDescriptor = MTLRenderPassDescriptor()
            renderPassDescriptor.colorAttachments[0].texture = drawable.texture
            renderPassDescriptor.colorAttachments[0].loadAction = .clear
            renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
            
            let encoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!
            encoder.setRenderPipelineState(pipelineState)
            encoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            
            // Set uniform data
            var resolution = SIMD2<Float>(Float(view.drawableSize.width), Float(view.drawableSize.height))
            
            var params = ShaderParameters(
                time: time,
                resolution: resolution,
                offset: offset,
                colour_1: color1,
                colour_2: color2,
                colour_3: color3,
                spin_rotation_speed: spinSpeed,
                move_speed: moveSpeed,
                contrast: contrast,
                lighting: lighting,
                spin_amount: spinAmount,
                pixel_filter: pixelFilter,
                is_rotating: isRotating ? 1 : 0
            )
            
            encoder.setFragmentBytes(&params, length: MemoryLayout<ShaderParameters>.stride, index: 0)
            encoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
            encoder.endEncoding()
            
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
    
    struct ShaderParameters {
        var time: Float
        var resolution: SIMD2<Float>
        var offset: SIMD2<Float>
        var colour_1: SIMD4<Float>
        var colour_2: SIMD4<Float>
        var colour_3: SIMD4<Float>
        var spin_rotation_speed: Float
        var move_speed: Float
        var contrast: Float
        var lighting: Float
        var spin_amount: Float
        var pixel_filter: Float
        var is_rotating: UInt32  // Using UInt32 to match uint in Metal
        
        // Print the size to debug
        static func sizeInfo() {
            print("ShaderParameters size: \(MemoryLayout<ShaderParameters>.size) bytes")
            print("ShaderParameters stride: \(MemoryLayout<ShaderParameters>.stride) bytes")
            print("ShaderParameters alignment: \(MemoryLayout<ShaderParameters>.alignment) bytes")
        }
    }
}
