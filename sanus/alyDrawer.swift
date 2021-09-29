//
//  viewFun.swift
//  sideDrawerTemplate
//
//  Created by aly hassan on 24/03/2021.
//

import Foundation
import UIKit

class alyDrawer: UIView {
    var isShown = false
    var myBlur = UIVisualEffectView()
    func addBlur(sender: UIViewController)-> UIVisualEffectView{
        let blurEffect = UIBlurEffect(style: .dark)
        let blurredEffectView = UIVisualEffectView(effect: blurEffect)
        var myRect = sender.view.bounds
        myRect.origin.y += 150
        blurredEffectView.frame = myRect
        //sender.view.addSubview(blurredEffectView)
        return blurredEffectView
    }
    func createDrawerVw(sender: UIViewController, widthToScreen: CGFloat, btnsDic: KeyValuePairs<String,String>, backgroundColor: UIColor){
        myBlur = addBlur(sender: sender)
        sender.view.addSubview(myBlur)
        myBlur.alpha = 0
        let screenHeight = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width * widthToScreen
        let startX = width * -1
        let drawerHeight = CGFloat(btnsDic.count * 50 + 40)
        let yValue = screenHeight/2 - drawerHeight/2
        self.frame = CGRect(x: startX, y: yValue, width: width, height: drawerHeight)
        self.layer.cornerRadius = 15
        self.backgroundColor = backgroundColor
        var i = 0
        for btn in btnsDic{
            
            let btn1 = UIButton(frame: CGRect(x: 5, y: CGFloat(50 * i + 20 ), width: width - 10, height: 40))
            btn1.setTitle(btn.key, for: .normal)
            btn1.addAction {
                print(btn.value)
                sender.performSegue(withIdentifier: btn.value, sender: sender)
            }
            btn1.restorationIdentifier = btn.value
            self.addSubview(btn1)
            i += 1
        }
        sender.view.addSubview(self)
    }
    func slideInDrawer(drawer: alyDrawer){
        if !drawer.isShown{
            UIView.animate(withDuration: 0.7, animations: {
                drawer.frame.origin.x = -10
                drawer.myBlur.alpha = 0.7
            })
            drawer.isShown = true
        }
       
    }
    func slideOutDrawer(drawer: alyDrawer){
        let width = drawer.frame.size.width
        let startX = width * -1
        UIView.animate(withDuration: 0.7, animations: {
            drawer.frame.origin.x = startX
        })
    }
}

class CustomTapGestureRecognizer: UITapGestureRecognizer {
    var drawer: alyDrawer?
    var test: String?
}

extension UIControl {
    func addAction(for controlEvents: UIControl.Event = .touchUpInside, _ closure: @escaping()->()) {
        addAction(UIAction { (action: UIAction) in closure() }, for: controlEvents)
    }
}

extension UIViewController {
    func hideDrawerWhenTappedAround(drawer: alyDrawer) {
        let tap: CustomTapGestureRecognizer = CustomTapGestureRecognizer(target: self, action: #selector(UIViewController.dismissDrawer(_:)))
        tap.drawer = drawer
        tap.test = "fffff"
        tap.cancelsTouchesInView = false
        tap.drawer?.myBlur.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissDrawer(_ sender: CustomTapGestureRecognizer) {
        if let drawer = sender.drawer{
        if drawer.isShown{
            let width = drawer.frame.size.width
            let startX = width * -1
            UIView.animate(withDuration: 0.7, animations: {
                drawer.frame.origin.x = startX
                drawer.myBlur.alpha = 0
            })
            sender.drawer!.isShown = false
            print("shown and dismissed")
        }
            print("not shown and appeared")
        }
    }
    func dismissDrawerDromBtn(drawer: alyDrawer){
        let width = drawer.frame.size.width
        let startX = width * -1
        UIView.animate(withDuration: 0.7, animations: {
            drawer.frame.origin.x = startX
            drawer.myBlur.alpha = 0
        })
        drawer.isShown = false
    }
}


