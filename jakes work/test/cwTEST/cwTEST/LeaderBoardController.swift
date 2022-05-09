//
//  LeaderBoardController.swift
//  cwTEST
//
//  Created by user137042 on 1/14/19.
//  Copyright © 2019 Powell J (FCES). All rights reserved.
//

import UIKit

class LeaderBoardController: UIViewController {
    
    var isPlay = false
    
    //set up arrays for displaying data
    var idArray = Array<Any>()
    var winnerArray = Array<Any>()
    var totalTimeTookArray = Array<Any>()
    
    
    
   
    //outlets for UI
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var pageHeading: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        
        //reference to the php file to connect to the database
        
        let kPathURL = "http://localhost/getjson.php"
        let request = URL(string: kPathURL)!
        let task = URLSession.shared.dataTask(with: request) {(data, response, error) in
            
            if error != nil{
                print("error")
            }else
                
            {
                if let content = data
                {
            
            do{
                let jsonResult = try JSONSerialization.jsonObject(with: content, options: .mutableContainers) as AnyObject
                
                //assign databse values to the arrays
                
                self.idArray = jsonResult.value(forKey: "gameID") as!Array<Any>
                self.winnerArray = jsonResult.value(forKey: "winner") as! Array<Any>
                self.totalTimeTookArray = jsonResult.value(forKey: "totalTime") as! Array<Any>
                
                //print the results
                print(jsonResult)
                print(self.idArray)
                print(self.winnerArray)
                print(self.totalTimeTookArray)
            }
            catch{}
        }
        }
        }
        
        task.resume()

       
        // Do any additional setup after loading the view.
    }
    
    //set the winner array to be the count for the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (winnerArray.count)
    }
    
    //set each value to show one at a time
    func numberOfSections(in tableView: UITableView) -> Int {
        return(1)
    }

    //function for the table view
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewSubClass
        tableView.rowHeight = 50
        
        //assign the winner value to the winner label
        let dispid = winnerArray[indexPath.row] as! String
        cell.winnerLabel.text = dispid
        
        //assign timer value to the timer label
        let dispid1 = totalTimeTookArray[indexPath.row] as! String
        cell.totalTimeLabel.text = dispid1
        
        return(cell)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
        //reload the table view with the data
        super.viewDidAppear(animated)
        tableView.reloadData()

        //print values to debugger
        print(self.idArray)
        print(self.winnerArray)
        print(self.totalTimeTookArray)
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
