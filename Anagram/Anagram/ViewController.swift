//
//  ViewController.swift
//  Anagram
//
//  Created by Krzysztof Grobelny on 08/10/2018.
//  Copyright © 2018 Mobica. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    var model: DictionaryModel?

    @IBOutlet weak var activityIndicator: ActivityIndicatorView!
    @IBOutlet var searchInputView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var resultView: UIStackView!
    @IBOutlet var resultTextView: UITextView!
    @IBOutlet var fetchAgainButton: UIButton!

    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        fetchDictionary()
    }

    private func fetchDictionary()
    {
        self.activityIndicator.show(withText: "Fetching dictionary")
        JSONFetchService.fetchData { (result) in
            switch result {
            case .success(let entries):
                self.model = DictionaryModel(entries: entries)
                self.activityIndicator.hide {
                    self.searchInputView.isHidden = false
                }
            case .error(let errorMessage):
                self.activityIndicator.hide {
                    self.presentErrorAlert(withMessage: errorMessage) {
                        self.loadJSONFromBundle()
                    }
                }
                break;
            }
        }
    }

    private func loadJSONFromBundle()
    {
        self.presentInfoAlert(withMessage: "Dictionary from bundle is going to be loaded.") {
            self.activityIndicator.show(withText: "Loading dictionary")
            JSONFetchService.loadJSONFromBundle { (entries) in
                if let entries = entries {
                    self.model = DictionaryModel(entries: entries)
                    self.activityIndicator.hide {
                        self.searchInputView.isHidden = false
                    }
                }
                else {
                    self.activityIndicator.hide {
                        self.presentErrorAlert(withMessage: "Unable to load dictionary from bundle.")
                    }
                }
            }
        }
    }

    private func processResults(forWord word: String, anagrams: Set<String>?)
    {
        runOnMainThread {
            if let anagrams = anagrams {
                self.resultTextView.text = anagrams.joined(separator: ", ")
                self.resultView.isHidden = false
            }
            else {
                self.presentInfoAlert(withMessage: "No anagrams found for '\(word)'.")
            }
        }
    }

    @IBAction private func searchButtonTapped(_ sender: Any)
    {
        textField.resignFirstResponder()
        if let word = textField.text {
            resultView.isHidden = true
            activityIndicator.show(withText: "Analyzing dictionary")
            model?.anagramsFor(word: word) { (anagrams) in
                self.activityIndicator.hide()
                self.processResults(forWord: word, anagrams: anagrams)
            }
        }
    }

    @IBAction func fetchAgainButtonTapped(_ sender: Any)
    {
        fetchAgainButton.isHidden = true
        fetchDictionary()
    }
}

extension ViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let text = (textField.text ?? "") as NSString
        searchButton.isEnabled = text.replacingCharacters(in: range, with: string).count > 1
        return true
    }
}

extension ViewController
{
    fileprivate func presentErrorAlert(withMessage message: String, handler: VoidClosure? = nil)
    {
        let errorAlert = UIAlertController.errorAlert(withMessage: message, handler: handler)
        self.present(errorAlert, animated: true, completion: nil)
    }

    fileprivate func presentInfoAlert(withMessage message: String, handler: VoidClosure? = nil)
    {
        let infoAlert = UIAlertController.infoAlert(withMessage: message, handler: handler)
        self.present(infoAlert, animated: true, completion: nil)
    }
}
