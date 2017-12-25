//
//  GaugeView.swift
//  RemoG
//
//  Created by Jakob Hain on 12/19/17.
//  Copyright © 2017 Resc. All rights reserved.
//

import UIKit
import CoreGraphics

class GaugeView: UIView {
    private static let backgroundColor: CGColor = #colorLiteral(red: 0.7952535152, green: 0.7952535152, blue: 0.7952535152, alpha: 1)
    private static let displayColor: CGColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1)
    private static let valueMarkerColorLight: CGColor = #colorLiteral(red: 1, green: 0, blue: 0, alpha: 1)
    private static let valueMarkerColorDark: CGColor = #colorLiteral(red: 0.75, green: 0, blue: 0, alpha: 1)
    
    private static let arcSpanAngleRad: CGFloat = 270 * (CGFloat.pi / 180)
    private static let arcRightAngle: CGFloat = (CGFloat.pi * -1 / 2) + (arcSpanAngleRad / 2)
    private static let arcLeftAngle: CGFloat = (CGFloat.pi * 3 / 2) - (arcSpanAngleRad / 2)
    
    private static let majorTickSize: CGFloat = 12
    private static let minorTickSize: CGFloat = 6

    private static let arcThickness: CGFloat = 4
    private static let majorTickThickness: CGFloat = 2
    private static let minorTickThickness: CGFloat = 1
    
    private static let arcPadding: CGFloat = 4
    private static let arcInset: CGFloat = fontPadding + fontSize + arcPadding
    
    private static let fontSize: CGFloat = 16
    private static let fontMaxWidth: CGFloat = fontSize * 4
    private static let font: CGFont = CGFont("Helvetica" as CFString)!
    private static let fontPadding: CGFloat = 2
    private static let fontInset: CGFloat = fontPadding + (fontSize / 2)
    
    private static let valueMarkerBaseRadius: CGFloat = 12
    private static let valueMarkerInnerCircleRadius: CGFloat = 8
    
    private static let valueMarkerMaxOutOfRangeRatio: CGFloat = 0.0625
    
    var gaugeValue: Float = Float.nan {
        didSet {
            if gaugeValue.isNaN {
                valueMarker.isHidden = true
            } else {
                updateValueMarkerImage()
                valueMarker.isHidden = false
            }
        }
    }
    @IBInspectable var minGaugeValue: Float = Float.nan
    @IBInspectable var maxGaugeValue: Float = Float.nan
    @IBInspectable var numMajorTicks: Int = 0 {
        didSet {
            updateMajorTicks()
            updateMajorTickLabels()
        }
    }
    @IBInspectable var numMinorTicks: Int = 0 {
        didSet {
            updateMinorTicks()
        }
    }
    
    override var frame: CGRect {
        didSet {
            backgroundLayer.path = CGPath(ellipseIn: bounds, transform: nil)
            arcLayer.path = UIBezierPath(
                arcCenter: bounds.center,
                radius: arcRadius,
                startAngle: GaugeView.arcRightAngle,
                endAngle: GaugeView.arcLeftAngle,
                clockwise: false
            ).cgPath
            updateMajorTicks()
            updateMinorTicks()
            updateMajorTickLabels()
            valueMarker.position = bounds.center
            if !valueMarker.isHidden {
                updateValueMarkerImage()
            }
        }
    }
    
    private let backgroundLayer: CAShapeLayer
    private let arcLayer: CAShapeLayer
    private let majorTicks: CAShapeLayer
    private let minorTicks: CAShapeLayer
    private var majorTickLabels: [CATextLayer]
    private let valueMarker: CALayer
    private let valueMarkerLeftSide: CAShapeLayer
    private let valueMarkerRightSide: CAShapeLayer
    
    private var radius: CGFloat {
        return bounds.width / 2 //width should be the same as height
    }
    private var arcRadius: CGFloat {
        return radius - GaugeView.arcInset
    }
    
    required init?(coder aDecoder: NSCoder) {
        backgroundLayer = CAShapeLayer()
        backgroundLayer.fillColor = GaugeView.backgroundColor
        
        arcLayer = CAShapeLayer()
        arcLayer.strokeColor = GaugeView.displayColor
        arcLayer.lineWidth = GaugeView.arcThickness
        arcLayer.lineCap = kCALineCapRound
        arcLayer.fillColor = nil
        
        majorTicks = CAShapeLayer()
        majorTicks.strokeColor = GaugeView.displayColor
        majorTicks.lineWidth = GaugeView.majorTickThickness
        
        minorTicks = CAShapeLayer()
        minorTicks.strokeColor = GaugeView.displayColor
        minorTicks.lineWidth = GaugeView.minorTickThickness
        
        majorTickLabels = []
        
        valueMarker = CALayer()
        valueMarker.isHidden = true
        
        valueMarkerLeftSide = CAShapeLayer()
        valueMarkerLeftSide.fillColor = GaugeView.valueMarkerColorDark

        valueMarkerRightSide = CAShapeLayer()
        valueMarkerRightSide.fillColor = GaugeView.valueMarkerColorLight
        
        super.init(coder: aDecoder)
        
        layer.addSublayer(backgroundLayer)
        layer.addSublayer(arcLayer)
        layer.addSublayer(majorTicks)
        layer.addSublayer(minorTicks)
        layer.addSublayer(valueMarker)
        
        valueMarker.addSublayer(valueMarkerLeftSide)
        valueMarker.addSublayer(valueMarkerRightSide)
    }
    
    ///Regenerates the major ticks' path.
    private func updateMajorTicks() {
        majorTicks.path = ticksPath(
            numTicks: numMajorTicks,
            tickSize: GaugeView.majorTickSize
        )
    }
    
    ///Regenerates the minor ticks' path.
    private func updateMinorTicks() {
        minorTicks.path = ticksPath(
            numTicks: numMinorTicks,
            tickSize: GaugeView.minorTickSize
        )
    }
    
    private func ticksPath(numTicks: Int, tickSize: CGFloat) -> CGPath {
        let path = CGMutablePath()
        forEachTick(numTicks: numTicks) { _, tickAngle in
            let tickStartPos = bounds.center + CGSize(radius: arcRadius, angle: tickAngle)
            let tickEndPos = bounds.center + CGSize(radius: arcRadius - tickSize, angle: tickAngle)
            path.move(to: tickStartPos)
            path.addLine(to: tickEndPos)
        }
        return path
    }
    
    //Regenerates the major tick labels.
    func updateMajorTickLabels() {
        majorTickLabels.forEach { $0.removeFromSuperlayer() }
        majorTickLabels.removeAll()
        forEachTick(numTicks: numMajorTicks) { tickIdx, tickAngle in
            let tickValue = Int(round(((Float(tickIdx) / Float(numMajorTicks - 1)) * (maxGaugeValue - minGaugeValue)) + minGaugeValue))
            
            let tickLabelPos = bounds.center + CGSize(radius: radius - GaugeView.fontInset, angle: tickAngle)
            let tickLabelRotation = CGFloat.pi - tickAngle
            
            let majorTickLabel = CATextLayer()
            majorTickLabel.alignmentMode = kCAAlignmentCenter
            majorTickLabel.font = GaugeView.font
            majorTickLabel.fontSize = GaugeView.fontSize
            majorTickLabel.foregroundColor = GaugeView.displayColor
            majorTickLabel.position = tickLabelPos
            majorTickLabel.bounds = CGRect(
                x: 0,
                y: 0,
                width: GaugeView.fontMaxWidth,
                height: GaugeView.fontSize
            )
            majorTickLabel.transform = CATransform3DMakeRotation(tickLabelRotation, 0, 0, 1)
            
            majorTickLabel.string = String(tickValue)
            
            layer.addSublayer(majorTickLabel)
            majorTickLabels.append(majorTickLabel)
        }
    }
    
    ///Performs an action for each tick, and gives it the index and the tick's angle.
    ///Used to render ticks or tick labels.
    private func forEachTick(numTicks: Int, _ action: (Int, CGFloat) -> Void) {
        if numTicks > 1 {
            let tickAngleDelta = -GaugeView.arcSpanAngleRad / CGFloat(numTicks - 1)
            for tickIdx in 0..<numTicks {
                let tickAngle = CGFloat.pi + GaugeView.arcLeftAngle + (CGFloat(tickIdx) * tickAngleDelta)
                action(tickIdx, tickAngle)
            }
        }
    }
    
    ///Regenerates the image of the value marker --
    ///specifically, regenerates the paths in the left and right sides.
    private func updateValueMarkerImage() {
        valueMarkerLeftSide.path = valueMarkerSidePath(side: .left)
        valueMarkerRightSide.path = valueMarkerSidePath(side: .right)
    }
    
    private func valueMarkerSidePath(side: Side) -> CGPath {
        let gaugeFractionUnclamped = (CGFloat(gaugeValue) - CGFloat(minGaugeValue)) / (CGFloat(maxGaugeValue) - CGFloat(minGaugeValue))
        NSLog("%f", gaugeFractionUnclamped)
        let gaugeFraction = max(min(gaugeFractionUnclamped, 1 + GaugeView.valueMarkerMaxOutOfRangeRatio), -GaugeView.valueMarkerMaxOutOfRangeRatio)
        let valueMarkerAngle = (GaugeView.arcLeftAngle + CGFloat.pi) - (gaugeFraction * GaugeView.arcSpanAngleRad)
        
        let innerArcDelta = CGFloat.pi * side.multiplier
        let valueMarkerSideAngle = valueMarkerAngle + (innerArcDelta / 2)
        let valueMarkerBackAngle = valueMarkerAngle + innerArcDelta
        
        let valueMarkerPointPos = CGSize(radius: arcRadius, angle: valueMarkerAngle).toPoint
        
        let path = CGMutablePath()
        path.move(to: valueMarkerPointPos)
        path.addLine(to: CGSize(radius: GaugeView.valueMarkerInnerCircleRadius, angle: valueMarkerAngle).toPoint)
        path.addQuadCurve(
            to: CGSize(radius: GaugeView.valueMarkerInnerCircleRadius, angle: valueMarkerSideAngle).toPoint,
            control: CGSize(
                radius: GaugeView.valueMarkerInnerCircleRadius * sqrt(2),
                angle: valueMarkerAngle + (innerArcDelta / 4)
            ).toPoint
        )
        path.addQuadCurve(
            to: CGSize(radius: GaugeView.valueMarkerInnerCircleRadius, angle: valueMarkerBackAngle).toPoint,
            control: CGSize(
                radius: GaugeView.valueMarkerInnerCircleRadius * sqrt(2),
                angle: valueMarkerSideAngle + (innerArcDelta / 4)
            ).toPoint
        )
        path.addLine(to: CGSize(radius: GaugeView.valueMarkerBaseRadius, angle: valueMarkerBackAngle).toPoint)
        path.addQuadCurve(
            to: CGSize(radius: GaugeView.valueMarkerBaseRadius, angle: valueMarkerSideAngle).toPoint,
            control: CGSize(
                radius: GaugeView.valueMarkerBaseRadius * sqrt(2),
                angle: valueMarkerBackAngle - (innerArcDelta / 4)
            ).toPoint
        )
        path.addLine(to: valueMarkerPointPos)
        return path
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

enum Side {
    case left
    case right
    
    ///-1 for left, 1 for right
    var multiplier: CGFloat {
        switch self {
        case .left:
            return -1
        case .right:
            return 1
        }
    }
}
