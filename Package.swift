// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
//  AMClockView, https://github.com/adventam10/AMClockView
//
//  Created by am10 on 2019/10/14.
//  Copyright © 2019年 am10. All rights reserved.
//

import PackageDescription

let package = Package(name: "AMClockView",
                      platforms: [.iOS(.v9)],
                      products: [.library(name: "AMClockView",
                                          targets: ["AMClockView"])],
                      targets: [.target(name: "AMClockView",
                                        path: "Source")],
                      swiftLanguageVersions: [.v5])
