//
//  SpinningView.swift
//  CircleMaterialDesign
//
//  Created by Simon Mcneil on 2021-09-10.
//
import UIKit

class SpinningView: UIView {

	/// The initial gap between stroke start and end
	private let startOffset: Double = 0.07

	let circleLayer = CAShapeLayer()

	var rotationAnimation: CAAnimation{
		get{
			let radius = Double(bounds.width) / 2.0
			let perimeter = 2 * Double.pi * radius
			let theta = perimeter * startOffset / (2 * radius)
			let animation = CABasicAnimation(keyPath: "transform.rotation.z")
			animation.fromValue = 0
			animation.toValue = theta * 2 + Double.pi * 2
			animation.duration = 3.5 // increase this duration to slow down the circle animation effect
			animation.repeatCount = MAXFLOAT
			return animation
		}
	}
	
	
	
	
	override func awakeFromNib() {
		super.awakeFromNib()
		setup()
	}
	
	func setup() {
		circleLayer.lineWidth = 10.0
		circleLayer.fillColor = nil
		//circleLayer.strokeColor = UIColor(red: 0.8078, green: 0.2549, blue: 0.2392, alpha: 1.0).cgColor
		circleLayer.strokeColor = UIColor.systemBlue.cgColor
		circleLayer.lineCap = .round
		layer.addSublayer(circleLayer)
		updateAnimation()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
		/* We calculate the center position halfway between the width and height of the bounds.
		Because we want the circle to fit within the view, the radius can't be bigger than the view's width or height.
		
		We take the smaller of them and halve it. Finally we need to subtract half of the lineWidth because the stroke draws outward from the center of the path.
		*/
		let center = CGPoint(x: bounds.midX, y: bounds.midY)
		let radius = min(bounds.width, bounds.height) / 2 - circleLayer.lineWidth / 2
		
		let startAngle: CGFloat = -90.0
		let endAngle: CGFloat = startAngle + 360.0
		
		circleLayer.position = center
		circleLayer.path = createCircle(startAngle: startAngle, endAngle: endAngle, radius: radius).cgPath
	}
	
	private func updateAnimation() {
		//The strokeStartAnimation beginTime + duration value need to add up to the strokeAnimationGroup.duration value
		let strokeStartAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeStart")
		strokeStartAnimation.beginTime = 0.5
		strokeStartAnimation.fromValue = 0
		strokeStartAnimation.toValue = 1.0 - startOffset //change this to 0.93 for cool effect
		strokeStartAnimation.duration = 3.0
		strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		
		let strokeEndAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
		strokeEndAnimation.fromValue = startOffset
		strokeEndAnimation.toValue = 1.0
		strokeEndAnimation.duration = 2.0
		strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		
		let colorAnimation = CABasicAnimation(keyPath: "strokeColor")
		colorAnimation.fromValue = UIColor.systemBlue.cgColor
		colorAnimation.toValue = UIColor.systemRed.cgColor
		
		let strokeAnimationGroup: CAAnimationGroup = CAAnimationGroup()
		strokeAnimationGroup.duration = 3.5
		strokeAnimationGroup.repeatCount = Float.infinity
		strokeAnimationGroup.fillMode = .forwards
		strokeAnimationGroup.isRemovedOnCompletion = false
		strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation, colorAnimation]
		
		circleLayer.add(strokeAnimationGroup, forKey: nil)
		circleLayer.add(rotationAnimation, forKey: "rotation")
		
		/* Another fun animation
		
		let strokeStartAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeStart")
		//strokeStartAnimation.beginTime = CACurrentMediaTime() + 0.5
		strokeStartAnimation.beginTime = 2.5
		strokeStartAnimation.fromValue = 0
		strokeStartAnimation.toValue = 1
		strokeStartAnimation.duration = 1.0
		strokeStartAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		
		let strokeEndAnimation: CABasicAnimation = CABasicAnimation(keyPath: "strokeEnd")
		strokeEndAnimation.fromValue = 0
		strokeEndAnimation.toValue = 1
		strokeEndAnimation.duration = 2.5
		strokeEndAnimation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
		
		let strokeAnimationGroup: CAAnimationGroup = CAAnimationGroup()
		strokeAnimationGroup.duration = 3.5
		strokeAnimationGroup.repeatCount = MAXFLOAT
		strokeAnimationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
		
		circleLayer.add(strokeAnimationGroup, forKey: nil)
		circleLayer.add(rotationAnimation, forKey: "rotation")
		
		*/
	}
	
	private func createCircle(startAngle: CGFloat, endAngle: CGFloat, radius: CGFloat) -> UIBezierPath {
		return UIBezierPath(arcCenter: CGPoint.zero,
							radius: radius,
							startAngle: startAngle.toRadians(),
							endAngle: endAngle.toRadians(),
							clockwise: true)
	}
}

extension CGFloat {
	func toRadians() -> CGFloat {
		return self * CGFloat(Double.pi) / 180.0
	}
}
