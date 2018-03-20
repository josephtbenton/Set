//
//  ConcentrationThemeChooserViewController.swift
//  Set
//
//  Created by Joseph Benton on 3/19/18.
//  Copyright © 2018 josephtbenton. All rights reserved.
//

import UIKit

class ConcentrationThemeChooserViewController: UIViewController, UISplitViewControllerDelegate{
    
    private var splitViewDetailConcentrationViewController: ConcentrationViewController? {
        return splitViewController?.viewControllers.last as? ConcentrationViewController
    }
    
    private var lastSeguedToConcentrationViewController: ConcentrationViewController?

    let themes = [
        "Professions":["🤡", "🤠", "👩‍💻", "👩‍🚒", "👨‍✈️", "👨‍🎨", "🕺", "👩‍🏫"],
        "Letters":["A", "B", "C", "D", "E", "F", "G", "H"],
        "Digits":["1", "2", "3", "4", "5", "6", "7", "8"],
        "Animals":["🐘", "🐲", "🐇", "🐄", "🦐", "🐍", "🦀", "🕷"],
        "Weather":["🌪", "🌊", "💦", "⛄️", "🌈", "🔥", "☁️", "☀️"],
        "Fruit":["🍎", "🍌", "🍇", "🌶", "🥕", "🍒", "🥑", "🍓"]
    ]
    
    override func awakeFromNib() {
        splitViewController?.delegate = self
    }
    
    func splitViewController(
        _ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController
    ) -> Bool {
        if let cvc = secondaryViewController as? ConcentrationViewController {
            if cvc.theme == nil {
                return true
            }
        }
        return false
    }
    
    @IBAction func changeTheme(_ sender: Any) {
        if let cvc = splitViewDetailConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
        } else if let cvc = lastSeguedToConcentrationViewController {
            if let themeName = (sender as? UIButton)?.currentTitle, let theme = themes[themeName] {
                cvc.theme = theme
            }
            navigationController?.pushViewController(cvc, animated: true)
        } else {
            performSegue(withIdentifier: "Choose Theme", sender: sender)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Choose Theme" {
            if let button = sender as? UIButton {
                if let themeName = button.currentTitle, let theme = themes[themeName] {
                    if let cvc = segue.destination as? ConcentrationViewController {
                        cvc.theme = theme
                        lastSeguedToConcentrationViewController = cvc
                    }
                }
            }
        }
    }
}
