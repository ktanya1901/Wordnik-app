//
//  MainViewController.swift
//  Wordnik
//
//  Created by Tatyana Korotkova on 13.02.2021.
//

import UIKit
import Moya
import AVFoundation

class MainViewController: UIViewController {
    
    var cardView = CardView()
    let provider = MoyaProvider<APIService>()
    private var initialCenter: CGPoint = .zero
    private var current = 0
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        return searchBar
    }()
    
    lazy var synonymButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = .blue
        button.isSelected = true
        return button
    }()
    
    lazy var antonymButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = .gray
        button.isSelected = false
        return button
    }()
    
    lazy var totalLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 5
        button.backgroundColor = .blue
        return button
    }()
    
    lazy var playerQueue : AVQueuePlayer = {
        return AVQueuePlayer()
    }()

    // MARK: - View did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        searchBar.delegate = self
        setupViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        UserDefaults.standard.setValue([], forKey: "response")
    }
    
    private func setupViews(){
        [searchBar, synonymButton, antonymButton, cardView, totalLabel, playButton].forEach {
            self.view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // add constraints
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        synonymButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30).isActive = true
        synonymButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        synonymButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        synonymButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        synonymButton.setTitle("Synonym", for: .normal)
        
        antonymButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 30).isActive = true
        antonymButton.leadingAnchor.constraint(equalTo: synonymButton.trailingAnchor, constant: 30).isActive = true
        antonymButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        antonymButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        antonymButton.setTitle("Antonym", for: .normal)
        
        cardView.topAnchor.constraint(equalTo: synonymButton.bottomAnchor, constant: 30).isActive = true
        cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40).isActive = true
        cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        totalLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 30).isActive = true
        totalLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        totalLabel.text = "0 words"
        
        playButton.topAnchor.constraint(equalTo: totalLabel.bottomAnchor, constant: 30).isActive = true
        playButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        playButton.setTitle("Play the word", for: .normal)
        playButton.widthAnchor.constraint(equalToConstant: 150).isActive = true
        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        synonymButton.addTarget(self, action: #selector(synonymButtonPressed), for: .touchUpInside)
        antonymButton.addTarget(self, action: #selector(antonymButtonPressed), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(playButtonPressed), for: .touchUpInside)
        
        // add gesture recognizer for card view
        let leftRecognizer = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeMade(_:)))
        leftRecognizer.direction = .left
        let rightRecognizer = UISwipeGestureRecognizer(target: self, action:
        #selector(swipeMade(_:)))
        rightRecognizer.direction = .right
        cardView.addGestureRecognizer(leftRecognizer)
        cardView.addGestureRecognizer(rightRecognizer)
        
    }
    
    // MARK: - Requests
    private func getSynonym(_ text: String){
        provider.request(.getSynonym(text: text)) { result in
            switch result{
            case .success(let response):
                do{
                    let wordnikResponse = try JSONDecoder().decode([WordnikResponse].self,from: response.data )
                    guard let synonyms = wordnikResponse.first else{
                        return
                    }
                    self.cardView.setText(synonyms.words[0])
                    UserDefaults.standard.setValue(synonyms.words, forKey: "response")
                    self.current = 0
                    if synonyms.words.count == 1{
                        self.totalLabel.text = "1 word"
                    }
                    else{
                        self.totalLabel.text = "\(synonyms.words.count) words"
                    }
                } catch {
                    self.totalLabel.text = "0 words"
                    let alert = UIAlertController(title: "Word", message: "Select another word", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    self.cardView.setText("Select another word")
                }
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            
            }
        }
    }
    private func getAntonym(_ text: String){
        provider.request(.getAntonym(text: text)) { result in
            switch result{
            case .success(let response):
                do{
                    let wordnikResponse = try JSONDecoder().decode([WordnikResponse].self,from: response.data )
                    guard let antonyms = wordnikResponse.first else{
                        return
                    }
                    self.cardView.setText(antonyms.words[0])
                    UserDefaults.standard.setValue(antonyms.words, forKey: "response")
                    self.current = 0
                    if antonyms.words.count == 1{
                        self.totalLabel.text = "1 word"
                    }
                    else{
                        self.totalLabel.text = "\(antonyms.words.count) words"
                    }
                } catch {
                    self.cardView.setText("Select another word")
                    self.totalLabel.text = "0 words"
                    let alert = UIAlertController(title: "Word", message: "Select another word", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            
            }
        }
    }
    
    private func playAudio(url: String){
        let link = URL(string: url)
        let playerItem = AVPlayerItem.init(url: link!)
        self.playerQueue.insert(playerItem, after: nil)
        self.playerQueue.play()
    }
    
    // MARK: - Actions
    
    // synonym mode
    @objc func synonymButtonPressed(){
        self.antonymButton.isSelected = false
        self.antonymButton.backgroundColor = .gray
        self.synonymButton.isSelected = true
        self.synonymButton.backgroundColor = .blue
        let text = self.searchBar.text ?? ""
        if text.count > 0{
            self.getSynonym(text)
        }
        else{
            self.cardView.setText("")
            UserDefaults.standard.setValue([], forKey: "response")
            self.totalLabel.text = "0 words"
        }
    }
    
    // antonym mode
    @objc func antonymButtonPressed(){
        self.synonymButton.isSelected = false
        self.synonymButton.backgroundColor = .gray
        self.antonymButton.isSelected = true
        self.antonymButton.backgroundColor = .blue
        let text = self.searchBar.text ?? ""
        if text.count > 0{
            self.getAntonym(text)
        }
        else{
            self.cardView.setText("")
            UserDefaults.standard.setValue([], forKey: "response")
            self.totalLabel.text = "0 words"
        }
    }
    
    // get the response with url for audio
    @objc func playButtonPressed(){
        guard let text = self.searchBar.text else {return}
        provider.request(.getAudio(text: text)) { result in
            switch result{
            case .success(let response):
                do{
                    let audioResponse = try JSONDecoder().decode([AudioResponse].self,from: response.data )
                    let url = audioResponse.first?.fileUrl ?? ""
                    if url.count > 0{
                        self.playAudio(url: url)
                    }
                } catch {
                    
                    // show alert when did not get the response
                    let alert = UIAlertController(title: "Audio", message: "Cannot play this word", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            case .failure(let error):
                print("Request error: \(error.localizedDescription)")
            
            }
        }
    }
    
    @IBAction func swipeMade(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .left {
            // this is a next word
            guard let responseList = UserDefaults.standard.stringArray(forKey: "response") else {return}
            if (self.current + 1) < responseList.count{
                self.current += 1
                self.cardView.setText(responseList[self.current])
            }
            
        }
        if sender.direction == .right {
            // this is a previous word
            guard let responseList = UserDefaults.standard.stringArray(forKey: "response") else {return}
            if (self.current - 1) >= 0 && responseList.count > 0{
                self.current -= 1
                self.cardView.setText(responseList[self.current])
            }
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

// search bar 
extension MainViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {return}
        view.endEditing(true)
        if self.synonymButton.isSelected{
            self.getSynonym(searchText)
        }
        else if self.antonymButton.isSelected{
            self.getAntonym(searchText)
        }
    }
}

