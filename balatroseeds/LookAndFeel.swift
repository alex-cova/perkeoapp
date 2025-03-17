//
//  Untitled.swift
//  balatroseeds
//
//  Created by Alex on 16/03/25.
//

import SwiftUI

class LookAndFeel {
    public static func configure(){
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white,
                                                            .font : UIFont(name: "m6x11plus", size: 20)!]
        UINavigationBar.appearance().backgroundColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        UINavigationBar.appearance().barTintColor = UIColor(red: 30/255.0, green: 30/255.0, blue: 30/255.0, alpha: 1.0)
        UIStepper.appearance().setDecrementImage(UIImage(systemName: "minus"), for: .normal)
        UIStepper.appearance().setIncrementImage(UIImage(systemName: "plus"), for: .normal)
        UITabBar.appearance().unselectedItemTintColor = UIColor.white
        UILabel.appearance().font = UIFont(name: "m6x11plus", size: 12)
        UITableView.appearance().separatorColor = UIColor.systemRed
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.init(name: "m6x11plus", size: 15)! ], for: .normal)
    }
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
