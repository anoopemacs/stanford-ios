//
//  GraphViewController.swift
//  GraphingCalculator
//
//  Created by jrm on 4/5/15.
//  Copyright (c) 2015 Riesam LLC. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDataSource
{
    override func viewDidAppear(animated: Bool) {
        //println("entered GraphViewController.viewDidAppear() ")
        graphView.axesOrigin = graphView.viewCenter
        //graphView.scale = graphView.contentScaleFactor
        //println("contentScaleFactor  \(graphView.contentScaleFactor)")
        programLabel.text = brain.shortDescription
        
        //println("view bounds  \(graphView.bounds)")
        //println("view bounds.size.width  \(graphView.bounds.size.width)")
        
        super.viewDidAppear(animated)
    }
    
    // MARK: - GraphView data source
    func pointsForGraphView(sender: GraphView) -> [CGPoint] {
        var points = [CGPoint]()
        var min_x = graphView.range_min_x
        while min_x <= graphView.range_max_x {
            if let y = brain.y(Double(min_x)) {
                let xValue = (min_x * graphView.scale) + graphView.axesOrigin.x
                let yValue = graphView.axesOrigin.y - (CGFloat(y) * graphView.scale)
                points.append(CGPoint(x: xValue, y: yValue))
            }
            min_x += graphView.increment
        }
        return points
    }
    
    @IBOutlet weak var graphView: GraphView! {
        didSet {
            graphView.dataSource = self
            graphView.addGestureRecognizer(UIPinchGestureRecognizer(target: graphView, action: "processPinch:"))
            graphView.addGestureRecognizer(UIPanGestureRecognizer(target: graphView, action: "processPan:"))
            var tap = UITapGestureRecognizer(target: graphView, action: "processTap:")
            tap.numberOfTapsRequired = 2
            graphView.addGestureRecognizer(tap)
        
//            graphView.axesOrigin = origin
//       
//            graphView.scale = scale
//    
        }
    }
    
//    private let defaults = NSUserDefaults.standardUserDefaults()
//
//    var scale: CGFloat {
//        get { return defaults.objectForKey("GraphViewController.Scale") as? CGFloat ?? 50.0 }
//        set { defaults.setObject(newValue, forKey: "GraphViewController.Scale") }
//    }
//    
//    private var origin: CGPoint {
//        get {
//            var origin = CGPoint()
//            if let originArray = defaults.objectForKey("GraphViewController.Origin") as? [CGFloat] {
//                origin.x = originArray.first!
//                origin.y = originArray.last!
//            }
//            return origin
//        }
//        set {
//            defaults.setObject([newValue.x, newValue.y], forKey: "GraphViewController.Origin")
//        }
//    }
    
    @IBOutlet weak var programLabel: UILabel!
    
    private var brain = CalculatorBrain()
    
    var program: AnyObject { // guaranteed to be a PropertyList
        get {
            return brain.program
        }
        set {
            brain.program = newValue
            //println("GVC: brain.program \(brain.program) ")
        }
    }

}

