//
//  PBDetailVC.swift
//  PiggyBanks
//
//  Created by Adam Wayland on 3/12/15.
//  Copyright (c) 2015 Adam Wayland. All rights reserved.
//

import UIKit

class PBDetailVC: UIViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var date: UILabel!
    
    var outlets = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.text = outlets[0]
        amount.text = outlets[1]
        date.text = outlets[2]
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setOutlets(name nameLocal: String, amount amountLocal: String, date dateLocal: String) {
        outlets = [nameLocal, amountLocal, dateLocal]
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
