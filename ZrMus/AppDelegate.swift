//
//  AppDelegate.swift
//  ZrMus
//
//  Created by Zr埋 on 2020/1/21.
//  Copyright © 2020 Zr埋. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var tabs = ["音乐", "我的", "账号"]
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white

        //音乐页面
        let player = Player()
        let PlayerNC = UINavigationController.init(rootViewController: player)
        let playerImg = UIImage(systemName: "music.note")?.withRenderingMode(.alwaysTemplate)

        //我的页面
        let mine = Mine()
        let MineNC = UINavigationController.init(rootViewController: mine)
        let mineImg = UIImage(systemName: "list.dash")?.withRenderingMode(.alwaysTemplate)

        //账号页面
        let actr = Accounter()
        let ActrNC = UINavigationController.init(rootViewController: actr)
        let actrImg = UIImage(systemName: "person")?.withRenderingMode(.alwaysTemplate)

        let navArray = [PlayerNC, MineNC, ActrNC]
        let imgArray = [playerImg, mineImg, actrImg]
        for i in 0...2 {
            navArray[i].tabBarItem = UITabBarItem(title: tabs[i], image: imgArray[i], selectedImage: nil)
        }
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = navArray

        UITabBar.appearance().tintColor = .red

        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        
//        注册后台播放
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(true)
            try session.setCategory(AVAudioSession.Category.playback)
        } catch {
            print(error)
        }
        
        return true
    }
    

}

