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
    private static let arcRightAngle: CGFloat = (CGFloat.pi * 1 / 2) - (CGFloat.pi - (arcSpanAngleRad / 2))
    private static let arcLeftAngle: CGFloat = (CGFloat.pi * 1 / 2) + (CGFloat.pi - (arcSpanAngleRad / 2))
    
    private static let majorTickSize: CGFloat = 12
    private static let minorTickSize: CGFloat = 6

    private static let arcThickness: CGFloat = 4
    private static let majorTickThickness: CGFloat = 2
    private static let minorTickThickness: CGFloat = 1
    
    private static let arcPadding: CGFloat = 4
    private static let arcInset: CGFloat = tickFontMargin + tickFontSize + arcPadding
    
    private static let tickFontSize: CGFloat = 16
    private static let tickFontMaxWidth: CGFloat = tickFontSize * 4
    private static let tickFontMargin: CGFloat = 2
    private static let tickFontInset: CGFloat = tickFontMargin + (tickFontSize / 2)
    
    private static let valueFontSize: CGFloat = 32
    private static let valueFontMaxWidth: CGFloat = valueFontSize * 5
    private static let valueLabelMargin: CGFloat = 4
    private static let valueLabelCenterOffset: CGFloat = valueMarkerBaseRadius + valueLabelMargin + (valueFontSize / 2)
    
    private static let font: CGFont = CGFont("Helvetica" as CFString)!
    
    private static let valueMarkerBaseRadius: CGFloat = 12
    private static let valueMarkerInnerCircleRadius: CGFloat = 8
    
    private static let valueMarkerMaxAngleOutOfRange: CGFloat = 11.25 * (CGFloat.pi / 180)
    private static let valueMarkerMinAngle: CGFloat = arcRightAngle - valueMarkerMaxAngleOutOfRange - CGFloat.pi
    private static let valueMarkerMaxAngle: CGFloat = arcLeftAngle + valueMarkerMaxAngleOutOfRange
    
    var gaugeValue: Float = Float.nan {
        didSet {
            if gaugeValue.isNaN {
                valueMarker.isHidden = true
                valueLabel.isHidden = true
            } else {
                updateValueMarkerImage()
                updateValueLabel()
                valueMarker.isHidden = false
                valueLabel.isHidden = false
            }
        }
    }
    @IBInspectable var minGaugeValue: Float = Float.nan
    @IBInspectable var maxGaugeValue: Float = Float.nan
    @IBInspectable var majorStep: Float = Float.nan {
        didSet {
            updateMajorTicks()
            updateMajorTickLabels()
        }
    }
    @IBInspectable var minorStep: Float = Float.nan {
        didSet {
            updateMinorTicks()
        }
    }
    @IBInspectable var unitLabel: String? = nil {
        didSet {
            updateValueLabel()
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
            if !gaugeValue.isNaN {
                updateValueMarkerImage()
                updateValueLabel()
            }
        }
    }
    
    private let backgroundLayer: CAShapeLayer
    private let arcLayer: CAShapeLayer
    private let majorTicks: CAShapeLayer
    private let minorTicks: CAShapeLayer
    private var majorTickLabels: [CATextLayer]
    private let valueLabel: CATextLayer
    private let valueMarker: CALayer
    private let valueMarkerLeftSide: CAShapeLayer
    private let valueMarkerRightSide: CAShapeLayer
    
    private var radius: CGFloat {
        return bounds.width / 2 //width should be the same as height
    }
    private var arcRadius: CGFloat {
        return radius - GaugeView.arcInset
    }
    private var valueMarkerAngle: CGFloat {
        let unclampedGaugeAngle = angleOfValue(gaugeValue)
        let gaugeAngle = max(min(unclampedGaugeAngle, GaugeView.valueMarkerMaxAngle), GaugeView.valueMarkerMinAngle)
        return gaugeAngle
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
        
        valueLabel = CATextLayer()
        valueLabel.alignmentMode = kCAAlignmentCenter
        valueLabel.font = GaugeView.font
        valueLabel.fontSize = GaugeView.valueFontSize
        valueLabel.foregroundColor = GaugeView.displayColor
        valueLabel.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        valueLabel.bounds = CGRect(
            x: 0,
            y: 0,
            width: GaugeView.valueFontMaxWidth,
            height: GaugeView.valueFontSize
        )
        valueLabel.contentsScale = UIScreen.main.scale
        valueLabel.isHidden = true
        
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
        layer.addSublayer(valueLabel)
        layer.addSublayer(valueMarker)
        
        valueMarker.addSublayer(valueMarkerLeftSide)
        valueMarker.addSublayer(valueMarkerRightSide)
    }
    
    ///Regenerates the major ticks' path.
    private func updateMajorTicks() {
        majorTicks.path = ticksPath(
            step: majorStep,
            tickSize: GaugeView.majorTickSize
        )
    }
    
    ///Regenerates the minor ticks' path.
    private func updateMinorTicks() {
        minorTicks.path = ticksPath(
            step: minorStep,
            tickSize: GaugeView.minorTickSize
        )
    }
    
    private func ticksPath(step: Float, tickSize: CGFloat) -> CGPath {
        let path = CGMutablePath()
        forEachTick(step: step) { _, tickAngle in
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
        forEachTick(step: majorStep) { tickValue, tickAngle in
            let tickLabelPos = bounds.center + CGSize(radius: radius - GaugeView.tickFontInset, angle: tickAngle)
            let tickLabelRotation = -tickAngle
            
            let majorTickLabel = CATextLayer()
            majorTickLabel.alignmentMode = kCAAlignmentCenter
            majorTickLabel.font = GaugeView.font
            majorTickLabel.fontSize = GaugeView.tickFontSize
            majorTickLabel.foregroundColor = GaugeView.displayColor
            majorTickLabel.position = tickLabelPos
            majorTickLabel.bounds = CGRect(
                x: 0,
                y: 0,
                width: GaugeView.tickFontMaxWidth,
                height: GaugeView.tickFontSize
            )
            majorTickLabel.transform = CATransform3DMakeRotation(tickLabelRotation, 0, 0, 1)
            majorTickLabel.contentsScale = UIScreen.main.scale
            
            majorTickLabel.string = String(Int(tickValue))
            
            layer.addSublayer(majorTickLabel)
            majorTickLabels.append(majorTickLabel)
        }
    }
    
    ///Enumerates each tick, calling a function with its value and angle.
    ///Starts with the tick with the minimum value,
    ///at the left-most angle on the arc.
    ///Increments the tick value by the given step.
    ///Ends at the last tick at or before the maximum value.
    ///Used to render ticks or tick labels.
    private func forEachTick(step: Float, _ action: (Float, CGFloat) -> Void) {
        if !step.isNaN {
            let angleStep = angleDeltaOfValue(step)
            
            var tickValue = minGaugeValue
            var tickAngle = GaugeView.arcLeftAngle
            //Don't want floating point errors.
            //Floating point should only be off a little.
            while tickValue <= maxGaugeValue + 0.1 {
                action(tickValue, tickAngle)
                
                tickValue += step
                tickAngle += angleStep
            }
        }
    }
    
    ///How much the corresponding change in the gauge value
    ///would change the angle on the gauge.
    private func angleDeltaOfValue(_ value: Float) -> CGFloat {
        let fraction = CGFloat(value) / (CGFloat(maxGaugeValue) - CGFloat(minGaugeValue))
        return fraction * -GaugeView.arcSpanAngleRad
    }
    
    ///The angle for the corresponding gauge value
    private func angleOfValue(_ value: Float) -> CGFloat {
        let fraction = (CGFloat(value) - CGFloat(minGaugeValue)) / (CGFloat(maxGaugeValue) - CGFloat(minGaugeValue))
        return GaugeView.arcLeftAngle - (fraction * GaugeView.arcSpanAngleRad)
    }
    
    ///Regenerates the image of the value marker --
    ///specifically, regenerates the paths in the left and right sides.
    private func updateValueMarkerImage() {
        valueMarkerLeftSide.path = valueMarkerSidePath(side: .left)
        valueMarkerRightSide.path = valueMarkerSidePath(side: .right)
    }
    
    ///Updates the text in the value label (to the current value),
    ///and moves it to prevent collision with the value marker.
    func updateValueLabel() {
        //Renders 1 decimal point of gauge value
        if let unitLabel = unitLabel {
            valueLabel.string = String(format: "%.1f %@", gaugeValue, unitLabel)
        } else {
            valueLabel.string = String(format: "%.1f", gaugeValue)
        }
        
        let valueMarkerOnTopHalf = valueMarkerAngle > (-CGFloat.pi / 2) && valueMarkerAngle < (CGFloat.pi / 2)
        let valueLabelOnTopHalf = !valueMarkerOnTopHalf
        let valueLabelCenter = bounds.center + CGSize(
            width: 0,
            height: valueLabelOnTopHalf ? -GaugeView.valueLabelCenterOffset : GaugeView.valueLabelCenterOffset
        )
        valueLabel.position = valueLabelCenter
    }
    
    private func valueMarkerSidePath(side: Side) -> CGPath {
        let valueMarkerAngle = self.valueMarkerAngle
        
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
