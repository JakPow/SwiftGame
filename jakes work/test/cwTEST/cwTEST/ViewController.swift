//
//  ViewController.swift
//  cwTEST
//
//  Created by Powell J (FCES) on 12/11/2018.
//  Copyright © 2018 Powell J (FCES). All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //all game variables
    var activePlayer = 1
    var gameState = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    let winningCombinations = [[0,1,2,3],[4,5,6,7], [8,9,10,11], [12,13,14,15],[0,4,8,12],[1,5,9,13], [2,6,10,14],[3,7,11,15],[0,5,10,15],[3,6,9,12]]
    var gameActive = true
    var firstPlayer = "X"
    var secondPlayer = "Y"
    var totalGameTime = Timer()
    var totalGameCounter = 0
    var timeLeftQuiz = 7
    var countdownTimer: Timer!
    //properties for questions array
    var correctAnswer = String()
    var randomQuestionArray:[Int] = Array(1...24)
    var winner = ""
    var totalTime = 0
    
    var isPlay = true
    
    //add winner and time completed variables for database
    
    
    
    //outlet for text of the question
    @IBOutlet weak var questionName: UILabel!
    //outlets for question answers
    @IBOutlet weak var buttonAnswer1: UIButton!
    @IBOutlet weak var buttonAnswer2: UIButton!
    @IBOutlet weak var buttonAnswer3: UIButton!
    @IBOutlet weak var buttonAnswer4: UIButton!
    //outlet for the current player of the game
    @IBOutlet weak var currentPlayer: UILabel!
    //outlet for time left of quiz turn
    @IBOutlet weak var turnTimeQuiz: UILabel!
    //outlet for the save game button
    @IBOutlet weak var saveGameButton: UIButton!
    
    
    
    
    
    //function to call save game values - persistant data
    @IBAction func saveAndExit(_ sender: UIButton) {
        saveCurrentGameSettings()
    
    }
    
    func postWinner(winner: String, totalTime: Int){ //needs to be added to hasWonAlert
        
        //Post to database
         let kPathURL = URL(string:"http://localhost/postgame.php")
         var request = URLRequest(url: kPathURL!)
         
         request.httpMethod = "POST"
         
         let kwinner = "winner="
         let ktotalTime = "&totalTime="

         let pMessage = kwinner + winner + ktotalTime + String(totalTime)
        print(pMessage)
         
         request.httpBody = pMessage.data(using: String.Encoding.utf8)
         print(request)
         
         let task = URLSession.shared.dataTask(with: request){data, response, error in
         
         if error != nil{
         //gone wrong
         }
         }
         task.resume()
         self.view.endEditing(true)
        
    }
    
    
    @IBAction func action(_ sender: UIButton) {
        
        //generate new question and reset timer
        randomQuestions()
        endTurnTimer()
        startTurnTimer()
        
        //disbale game grid
        for i in 1...16{
            let button = view.viewWithTag(i) as! UIButton
            button.isEnabled = false
        }
        
      
     
        
        if (gameState[sender.tag-1] == 0) {
            gameState[sender.tag-1] = activePlayer
            
            
            if (activePlayer == 1){
                //assign chosen spot for palyer 1 turn then switch to player 2
                sender.setImage(UIImage(named:"Cross.jpeg"), for: UIControlState())
                activePlayer = 2
                currentPlayer.text = secondPlayer + "'s turn!"
            
            } else{
                //assign chosen spot for palyer 2 turn then switch to player 1
                sender.setImage(UIImage(named:"Nought.jpeg"), for: UIControlState())
                activePlayer = 1
                currentPlayer.text = firstPlayer + "'s turn!"
            }
            
            
            for combination in winningCombinations
            {
                //checks all game combinations
                if gameState[combination[0]] != 0 && gameState[combination[0]] ==
                    gameState[combination[1]] && gameState[combination[1]] ==
                    gameState[combination[2]] && gameState[combination[2]] == gameState[combination[3]]
                {
                    gameActive  = false
                    
                    //set player 1 as winner
                    if gameState[combination[0]] == 1
                    {
                        
                        hasWonAlert(title: firstPlayer + " has won in " + String(totalGameCounter) + " seconds!" , message: "Play again?")
                        

                        print(winner + " " + String(totalTime))
                        
                        postWinner(winner: firstPlayer, totalTime: totalGameCounter)
                        //Cross has won
                    }
                    else
                    //set player 2 as winner
                    {
                        //call has won alert function add pass through parameters
                        hasWonAlert(title: secondPlayer + " has won in " + String(totalGameCounter) + " seconds!", message: "Play again?")
                        //assign winner to player 1 and total time to post to DB
                        postWinner(winner: secondPlayer, totalTime: totalGameCounter)

                        //Nought has won
                    }
                }
                
                //if game is a draw call has won function with labels
                gameActive = false
                for i in gameState
                {
                    if i == 0
                    {
                        gameActive = true
                        break
                    }
                }
                
                if gameActive == false
                {
                    hasWonAlert(title: "It's a draw!", message: "Play again?")                }
                
            }
        }
    }
    
    //function to show the game winner with input parameters
    func hasWonAlert (title: String, message: String)
    {
        //ends quiz timer
        endTurnTimer()
        
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        //yes option to play game again and call play again function
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler:{action in self.playAgain()
        alert.dismiss(animated: true, completion: nil)
        }))
        
        //don't play again and go to home page
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler:{(action) -> Void in
            self.performSegue(withIdentifier: "homePage", sender: self)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //function to reset all values to play game again
    func playAgain(){
        
        //reset key game variables to enable game restart
        gameState = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        totalGameCounter = 0
        gameActive = true
        activePlayer = 1
        currentPlayer.text = firstPlayer + " to start!"
        endTurnTimer()
        startTurnTimer()
        for i in 1...16{
            //removes all grid values
            let button = view.viewWithTag(i) as! UIButton
            button.setImage(nil, for: UIControlState())
            
        }
        
    }
    
    //function to open alert for players to add player names
    func showPlayerNameInputs(){
        
        //set title and message for the alert
        let alertController = UIAlertController(title: "Who's playing?", message: "Enter names for player one and two", preferredStyle: UIAlertControllerStyle.alert)
        
        //action to save names and play game
        let confirmAction = UIAlertAction(title: "Enter", style: UIAlertActionStyle.default){(_) in
            
            //set variables for palyer one and player two
            let playerOne = alertController.textFields?[0].text
            let playerTwo = alertController.textFields?[1].text
            
            //change game text to begin game
            self.currentPlayer.text = playerOne! + " to start!"
            
            //assign player variables to player names to add to DB
            self.firstPlayer = playerOne!
            self.secondPlayer = playerTwo!
            
            //set total game timer with 1 second margin
            self.totalGameTime = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.totalGameTimer), userInfo: nil, repeats: true)
            
            //start the timer
            self.startTurnTimer()
        }
        
        //set player 1 and player 2 input fields on alerts
        alertController.addTextField{(textField) in
            textField.placeholder = "Player One"
        }
        
        alertController.addTextField{(textField) in
            textField.placeholder = "Player Two"
        }
        
        //calls confirm action function
        alertController.addAction(confirmAction)
       
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    //counts overall game time to aff to leaderboard
   @objc func totalGameTimer(){
        
        totalGameCounter = totalGameCounter + 1
    
    }
    
    //starts the quiz timer
    func startTurnTimer(){
    //set time to 7 seconds and set margin to 1 second
        timeLeftQuiz = 7
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTurnTimer), userInfo: nil, repeats: true)
    
    }
    
    //updates quz timer
    @objc func updateTurnTimer(){
        
        turnTimeQuiz.text = "\(timeLeftQuiz)"
        //if timer different from 0 then minus 1
        if timeLeftQuiz != 0{
            timeLeftQuiz -= 1
        }
        else{
        //ends timer, call player change function, generate new questions and restart timer
            endTurnTimer()
            changeCurrentPlayer(changeReason: "Time's up! ")
            randomQuestions()
            endTurnTimer()
            startTurnTimer()
        }
    }
    
    //ends the quiz timer
    func endTurnTimer(){
        
        countdownTimer.invalidate()
        
    }
    
    func randomQuestions () {
        

        //randomise a questions to display
        let randomIndex = Int(arc4random_uniform(UInt32(randomQuestionArray.count)))
        
        if randomQuestionArray.count > 0 {
            
            switch (randomQuestionArray[randomIndex]) {
                
            case 1:
                //assign questions and answers to labels and buttons
                questionName.text = "How many true born Stark children are there?"
                buttonAnswer1.setTitle ("5", for: UIControlState.normal)
                buttonAnswer2.setTitle ("7", for: UIControlState.normal)
                buttonAnswer3.setTitle ("6", for: UIControlState.normal)
                buttonAnswer4.setTitle ("4", for: UIControlState.normal)
                correctAnswer = "1"
                break
                
            case 2:
                questionName.text = "Friends has six main characters, Joey, Monica, Ross, Rachel, Chandler and _____?"
                buttonAnswer1.setTitle ("Gunther", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Phoebe", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Thomas", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Judy", for: UIControlState.normal)
                correctAnswer = "2"
                break
                
            case 3:
                questionName.text = "Which TV show ended in 2015?"
                buttonAnswer1.setTitle ("Modern Family", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Big Bang Theory", for: UIControlState.normal)
                buttonAnswer3.setTitle ("The Office", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Parks and Rec", for: UIControlState.normal)
                correctAnswer = "4"
                break
                
            case 4:
                questionName.text = "Which city is 'The Office' (US) located?"
                buttonAnswer1.setTitle ("Dallas", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Chicago", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Scranton", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Boston", for: UIControlState.normal)
                correctAnswer = "3"
                break
                
            case 5:
                questionName.text = "Who played Chandlers father in Friends?"
                buttonAnswer1.setTitle ("Elliot Gould", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Kathleen Turner", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Michael Douglas", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Nathan Lane", for: UIControlState.normal)
                correctAnswer = "2"
                break
                
                
            case 6:
                questionName.text = "In Betwitched, what part of her body does Samantha practive magic?"
                buttonAnswer1.setTitle ("Hair", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Forehead", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Ears", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Nose", for: UIControlState.normal)
                correctAnswer = "4"
                break
            
            
            case 7:
                questionName.text = "What superhero gets referenced in every episode of Seinfeld?"
                buttonAnswer1.setTitle ("Superman", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Batman", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Antman", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Ironman", for: UIControlState.normal)
                correctAnswer = "1"
                break
            
            case 8:
                questionName.text = "Which TV showed the first interracial kiss on American TV?"
                buttonAnswer1.setTitle ("Friends", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Family Feud", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Star Trek", for: UIControlState.normal)
                buttonAnswer4.setTitle ("All in the Family", for: UIControlState.normal)
                correctAnswer = "3"
                break
            
            
            case 9:
                questionName.text = "What sitcom follows the life of Liz Lemon?"
                buttonAnswer1.setTitle ("Stacked", for: UIControlState.normal)
                buttonAnswer2.setTitle ("30 Rock", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Just Shoot Me!", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Sister, Sister", for: UIControlState.normal)
                correctAnswer = "2"
                break
            
            
            case 10:
                questionName.text = "Who was the youngest ever SNL host?"
                buttonAnswer1.setTitle ("Donald Glover", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Miley Cyrus", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Fred Savage", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Drew Barrymore", for: UIControlState.normal)
                correctAnswer = "4"
                break
                
                
            case 11:
                questionName.text = "How does Charlie Harper die in Two and a Half Men?"
                buttonAnswer1.setTitle ("Piano falls on him", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Hit by train", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Heart attack", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Car crash", for: UIControlState.normal)
                correctAnswer = "1"
                break
                
                
            case 12:
                questionName.text = "What is the name of Data's daughter on Star Trek: The Next Generation?"
                buttonAnswer1.setTitle ("LLia", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Ava", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Lal", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Maria", for: UIControlState.normal)
                correctAnswer = "3"
                break
                
            case 13:
                questionName.text = "Who plays Andy Dwyer on Parks and Rec?"
                buttonAnswer1.setTitle ("Andy Samberg", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Chris Pratt", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Jason Bateman", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Michael Sheen", for: UIControlState.normal)
                correctAnswer = "2"
                break
                
                
            case 14:
                questionName.text = "Which Welshman plays bastard Ramsey Bolton in Game of Thrones?"
                buttonAnswer1.setTitle ("Taron Egerton", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Michael Sheen", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Iwan Rheon", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Ioan Gruffurd", for: UIControlState.normal)
                correctAnswer = "3"
                break
                
                
            case 15:
                questionName.text = "Which of the below is a Netflix original series?"
                buttonAnswer1.setTitle ("Peaky Blinders", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Prison Break", for: UIControlState.normal)
                buttonAnswer3.setTitle ("The Walking Dead", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Stranger Things", for: UIControlState.normal)
                correctAnswer = "4"
                break
                
                
            case 16:
                questionName.text = "What is the Peaky Blinders local pub called?"
                buttonAnswer1.setTitle ("The Garrison", for: UIControlState.normal)
                buttonAnswer2.setTitle ("The Barracks", for: UIControlState.normal)
                buttonAnswer3.setTitle ("The Cannon", for: UIControlState.normal)
                buttonAnswer4.setTitle ("The Stronghold", for: UIControlState.normal)
                correctAnswer = "1"
                break
                
            case 17:
                questionName.text = "What is the name of the Hactivist group in Mr Robot?"
                buttonAnswer1.setTitle ("Teamp0isoN", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Anonymous", for: UIControlState.normal)
                buttonAnswer3.setTitle ("fsociey", for: UIControlState.normal)
                buttonAnswer4.setTitle ("NullCrew", for: UIControlState.normal)
                correctAnswer = "3"
                break
                
                
            case 18:
                questionName.text = "Daredevil, Jessica Jones, Iron Fist and Luke Cage are members of this super group"
                buttonAnswer1.setTitle ("The Suspenders", for: UIControlState.normal)
                buttonAnswer2.setTitle ("The Genders", for: UIControlState.normal)
                buttonAnswer3.setTitle ("The Defenders", for: UIControlState.normal)
                buttonAnswer4.setTitle ("The Contenders", for: UIControlState.normal)
                correctAnswer = "3"
                break
                
                
            case 19:
                questionName.text = "Which Town is 'The Office' (UK) located?"
                buttonAnswer1.setTitle ("Slough", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Portmeiron", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Rye", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Whitby", for: UIControlState.normal)
                correctAnswer = "1"
                break
                
                
            case 20:
                questionName.text = "Bryan Cranston plays meth chef king pin in this crime drama."
                buttonAnswer1.setTitle ("Ozark", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Brooklyn Nine Nine", for: UIControlState.normal)
                buttonAnswer3.setTitle ("NCIS", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Breaking Bad", for: UIControlState.normal)
                correctAnswer = "4"
                break
                
                
            case 21:
                questionName.text = "Jake Peralta plays quirky detective in this series"
                buttonAnswer1.setTitle ("Brooklyn Nine Nine", for: UIControlState.normal)
                buttonAnswer2.setTitle ("NCIS", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Cops", for: UIControlState.normal)
                buttonAnswer4.setTitle ("On the Run", for: UIControlState.normal)
                correctAnswer = "1"
                break
                
                
            case 22:
                questionName.text = "What town is the home of Nessa, Stacey and Bryn?"
                buttonAnswer1.setTitle ("Conwy", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Barry", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Newport", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Tenby", for: UIControlState.normal)
                correctAnswer = "2"
                break
                
            case 23:
                questionName.text = "Which Hotel does Manual the waiter work at?"
                buttonAnswer1.setTitle ("The Furchester Hotel", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Hotel Babylon", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Bates Motel", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Fawlty Towers", for: UIControlState.normal)
                correctAnswer = "4"
                break
                
            default:
                questionName.text = "Who killed Robb Stark?"
                buttonAnswer1.setTitle ("Walder Frey", for: UIControlState.normal)
                buttonAnswer2.setTitle ("Roose Bolton", for: UIControlState.normal)
                buttonAnswer3.setTitle ("Tywin Lannister", for: UIControlState.normal)
                buttonAnswer4.setTitle ("Petyr Balish", for: UIControlState.normal)
                correctAnswer = "2"
                break
            }
            //remove question from the array
            randomQuestionArray.remove(at: randomIndex)
            buttonAnswer1.backgroundColor = UIColor.white
            buttonAnswer2.backgroundColor = UIColor.white
            buttonAnswer3.backgroundColor = UIColor.white
            buttonAnswer4.backgroundColor = UIColor.white
            
        }
        
    }

    //answer button 1
    @IBAction func buttonAnswerAction1(_ sender: Any) {
        //if correct answer set button to green, change test and enable play grid
        if(correctAnswer == "1"){
            buttonAnswer1.backgroundColor = UIColor.green
            currentPlayer.text =  "Correct, Make your move!"
            for i in 1...16{
                let button = view.viewWithTag(i) as! UIButton
                button.isEnabled = true
            }
        }
        //if incorrect, set button to red, change label and call random q function and timer functions.
        else{
            buttonAnswer1.backgroundColor = UIColor.red
            changeCurrentPlayer(changeReason: "Wrong!, ")
            randomQuestions()
            endTurnTimer()
            startTurnTimer()
        }
    }
    
    //answer button 2
    @IBAction func buttonAnswerAction2(_ sender: Any) {
        if(correctAnswer == "2"){
            buttonAnswer2.backgroundColor = UIColor.green
            currentPlayer.text =  "Correct, Make your move!"
            for i in 1...16{
                let button = view.viewWithTag(i) as! UIButton
                button.isEnabled = true
            }
        }
        else{
            buttonAnswer2.backgroundColor = UIColor.red
            changeCurrentPlayer(changeReason: "Wrong!, ")
            randomQuestions()
            endTurnTimer()
            startTurnTimer()
        }
    }
    
    //answer button 3
    @IBAction func buttonAnswerAction3(_ sender: Any) {
        if(correctAnswer == "3"){
            buttonAnswer3.backgroundColor = UIColor.green
            currentPlayer.text = "Correct, Make your move!"
            for i in 1...16{
                let button = view.viewWithTag(i) as! UIButton
                button.isEnabled = true
            }
        }
        else{
            buttonAnswer3.backgroundColor = UIColor.red
            changeCurrentPlayer(changeReason: "Wrong!, ")
            randomQuestions()
            endTurnTimer()
            startTurnTimer()
        }
    }
    
    //answer button 4
    @IBAction func buttonAnswerAction4(_ sender: Any) {
        if(correctAnswer == "4"){
            buttonAnswer4.backgroundColor = UIColor.green
            currentPlayer.text = "Correct, Make your move!"
            for i in 1...16{
                let button = view.viewWithTag(i) as! UIButton
                button.isEnabled = true
            }
        }
        else{
            buttonAnswer4.backgroundColor = UIColor.red
            changeCurrentPlayer(changeReason: "Wrong!, ")
            randomQuestions()
            endTurnTimer()
            startTurnTimer()
        }
    }
    
    //function to change the current player
    func changeCurrentPlayer(changeReason: String){
        
        //if player 1 change to player 2
        if activePlayer == 1{
            activePlayer = 2
            currentPlayer.text = changeReason + secondPlayer + "'s turn"
        }
        //if player 2 change to player 1
        else{
            activePlayer = 1
            currentPlayer.text = changeReason + firstPlayer + "'s turn!"
        }
        for i in 1...16{
            let button = view.viewWithTag(i) as! UIButton
            button.isEnabled = false
        }
    }
    
    //function to save current game values for continue
    func saveCurrentGameSettings(){
        
        UserDefaults.standard.set(activePlayer, forKey: "ActivePlayer")
        UserDefaults.standard.set(gameState, forKey: "GameState")
        UserDefaults.standard.set(gameActive, forKey: "GameActive")
        UserDefaults.standard.set(firstPlayer, forKey: "FirstPlayer")
        UserDefaults.standard.set(secondPlayer, forKey: "SecondPlayer")
        UserDefaults.standard.set(totalGameCounter,forKey:"TotalGameCounter")
        
        
    }
    
    //function to retrieve the persistant data values
    func retrieveGameSettings(){
        
        //retrieve saved game values
        activePlayer = UserDefaults.standard.integer(forKey: "ActivePlayer")
        gameState = UserDefaults.standard.array(forKey: "GameState") as! [Int]
        gameActive = UserDefaults.standard.bool(forKey: "GameActive")
        firstPlayer = UserDefaults.standard.string(forKey: "FirstPlayer")!
        secondPlayer = UserDefaults.standard.string(forKey: "SecondPlayer")!
        totalGameCounter = UserDefaults.standard.integer(forKey: "TotalGameCounter")

        //reset the player name labels depending on the turn
        if activePlayer == 1{
            currentPlayer.text = firstPlayer + "'s turn"
        }
        else{
            currentPlayer.text = secondPlayer + "'s turn!"
        }
        
        //place the saved game values into the grid
        for i in 1...16{
            
            let buttonXO = view.viewWithTag(i) as! UIButton
            if gameState[i - 1] == 1{
                buttonXO.setImage(UIImage(named:"Cross.jpeg"), for: UIControlState())
            }
            else if gameState[i - 1] == 2{
                buttonXO.setImage(UIImage(named:"Nought.jpeg"), for: UIControlState())
            }
            else{
                buttonXO.setImage(nil, for: UIControlState())
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if isPlay == false{
            
            //if game is saved game then retrieve saved data and start timer and generate question
            retrieveGameSettings()
            startTurnTimer()
            randomQuestions()
            
        }
        else if isPlay == true{
            
            //remove all saved values if new game
            if let appDomain = Bundle.main.bundleIdentifier{
                UserDefaults.standard.removePersistentDomain(forName: appDomain)
            }
            //sets palyer one to start and generate random question
            activePlayer = 1
            randomQuestions()
            
            //disable game grid
            for i in 1...16{
                let button = view.viewWithTag(i) as! UIButton
                button.isEnabled = false
            }
            }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //if the game is a new game and not a saved game, then display input names pop up
        if isPlay == true{
        showPlayerNameInputs()
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
