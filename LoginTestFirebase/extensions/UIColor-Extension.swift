//
//  UIColor-Extension.swift
//  LoginTestFirebase
//
//  Created by IwasakIYuta on 2021/09/08.
//https://qiita.com/KeitaMoromizato/items/9afe1d75b4a1455c2fa4

import UIKit
extension UIColor{//UIColorの拡張//16進数color 機能拡張
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return self.init(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
    }
}
