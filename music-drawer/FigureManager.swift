//
//  FigureManager.swift
//  music-drawer
//
//  Created by Lucy Zhang on 1/16/18.
//  Copyright © 2018 Lucy Zhang. All rights reserved.
//

import Cocoa
import SceneKit
class FigureManager: NSObject {
    
    class func createRibbon() -> SCNShape{
        let path = NSBezierPath()
        path.move(to: .zero)
        path.appendArc(withCenter: CGPoint(x: 50, y: 200), radius: 20, startAngle: 0, endAngle: 45)
        path.line(to: CGPoint(x: 99, y: 0))
        path.appendArc(withCenter: CGPoint(x: 50, y: 198), radius: 20, startAngle: 45, endAngle: 90)
        let shape = SCNShape(path: path, extrusionDepth: 10)
        shape.firstMaterial?.diffuse.contents = NSColor.blue
        return shape
    }
    
    class func nodeFromShape(shape: SCNShape) -> SCNNode{
        let shapeNode = SCNNode(geometry: shape)
        shapeNode.pivot = SCNMatrix4MakeTranslation(50, 0, 0)
        shapeNode.eulerAngles.y = CGFloat(Float(-Double.pi / 4))
        return shapeNode
    }
    
    func animateRibbon(shape: SCNShape){
        let modifier = "uniform float progress;\n #pragma transparent\n vec4 mPos = u_inverseModelViewTransform * vec4(_surface.position, 1.0);\n _surface.transparent.a = clamp(1.0 - ((mPos.x + 50.0) - progress * 200.0) / 50.0, 0.0, 1.0);"
        shape.shaderModifiers = [ SCNShaderModifierEntryPoint.surface: modifier ]
        shape.setValue(0.0, forKey: "progress")
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 10
        shape.setValue(1.0, forKey: "progress")
        SCNTransaction.commit()
    }

}
