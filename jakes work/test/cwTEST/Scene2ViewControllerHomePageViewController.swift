//
//  Scene2ViewControllerHomePageViewController.swift
//  cwTEST
//
//  Created by user137042 on 12/5/18.
//  Copyright © 2018 Powell J (FCES). All rights reserved.
//

import UIKit

class Scene2ViewControllerHomePageViewController: UIViewController {
      
    
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var leaderboardButton: UIButton!

    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {

        if (segue.identifier == "playButton") {
            let destination = segue.destination as!
            ViewController
            destination.isPlay = true
        }
        if (segue.identifier == "continueButton") {
            let destination = segue.destination as!
            ViewController
            destination.isPlay = false
        }
        if(segue.identifier == "leaderboardButton"){
            let leaderBoardDest = segue.destination as!
            LeaderBoardController
            leaderBoardDest.isPlay = false
        }

    }
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
