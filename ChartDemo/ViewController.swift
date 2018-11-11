//
//  ViewController.swift
//  ChartDemo
//
//  Created by Bao Nguyen on 11/8/18.
//  Copyright © 2018 Bao Nguyen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slideControl: SliderControl!
    @IBOutlet weak var lineChart: LineChart!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func sliderValueChanged(_ sender: SliderControl) {
        print(sender.currentValue)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lineChart.datas = generateDataEntries()
    }

    func generateDataEntries() -> [BarEntry] {
        let colors = [#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1), #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1), #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1), #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1), #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1), #colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 1)]
        var result: [BarEntry] = []
        for i in 1...12 {
            let level = (arc4random() % 5) + 1
            let entry = BarEntry(month: i, level: Int(level), color: colors[i % colors.count])
            result.append(entry)
        }
        return result
    }

}

