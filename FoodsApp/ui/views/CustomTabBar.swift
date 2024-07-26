//
//  CustomTabBar.swift
//  FoodsApp
//
//  Created by Bozkurt on 23.07.2024.
//

import UIKit

class CustomTabBar {
    static func setupTabBarAppearance(tabBar: UITabBar) {
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = UIColor.systemIndigo
        
        changeColor(itemAppearance: appearance.stackedLayoutAppearance)
        changeColor(itemAppearance: appearance.compactInlineLayoutAppearance)
        changeColor(itemAppearance: appearance.inlineLayoutAppearance)
        
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
    }
    
    private static func changeColor(itemAppearance: UITabBarItemAppearance) {
        itemAppearance.selected.iconColor = UIColor.systemOrange
        itemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemOrange]
        itemAppearance.selected.badgeBackgroundColor = UIColor.systemMint
        
        itemAppearance.normal.iconColor = UIColor.white
        itemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]
        itemAppearance.normal.badgeBackgroundColor = UIColor.lightGray
    }
}
