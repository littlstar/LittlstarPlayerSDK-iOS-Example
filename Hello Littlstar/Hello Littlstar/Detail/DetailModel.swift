//
//  DetailModel.swift
//  Hello Littlstar
//
//  Created by Huy Dao on 4/30/18.
//  Copyright © 2018 Huy Dao. All rights reserved.
//

import Foundation
import LittlstarPlayerSDK

class LSSideload {}

struct DetailModel {
  var trailerList: [Any] = []

  init() {
    let videoA = LSVideo()
    videoA.title = "Thailand: Find Your Journey"
    videoA["poster"] = #imageLiteral(resourceName: "AImage")
    videoA["desc"] = "This VR brand film follows a young man as he takes the journey of a lifetime through the incredible landscape and rich culture of Thailand. Along the way the film explores the idea of travel and how fundamental it is to the human experience. Produced by Perception Squared for Curate Directive and the Tourism Authority of Thailand."
    videoA.videoURL = URL(string: "https://360.littlstar.com/production/a04e794d-e137-493a-b5fe-ffe3e6a78b5d/mobile_hls.m3u8")!
    trailerList.append(videoA)

    let videoB = LSVideo()
    videoB.title = "Anywhere That Is Wild: Zion National Park"
    videoB["poster"] = #imageLiteral(resourceName: "BImage")
    videoB["desc"] = "Content presents a celebration of the National Parks at 100, Anywhere That Is Wild: Zion. Get a full 360° view by looking up, down, and all around. Best viewed on mobile in the YouTube app, or with a VR device like Google Cardboard, Oculus Rift or HTC Vive."
    videoB.videoURL = URL(string: "https://360.littlstar.com/production/6997273b-e1be-4d96-ac86-3cc040b13c0a/mobile_hls.m3u8")!
    trailerList.append(videoB)

    let imageC = LSImage()
    imageC.title = "Rocket Launch: Delta IV Heavy NROL-37"
    imageC["poster"] = #imageLiteral(resourceName: "CImage")
    imageC["desc"] = "Step onto the launch pad as ULA's Delta IV Heavy blasts off with the NROL-37 mission for the National Reconnaissance Office. The Delta IV Heavy is nearly as tall as the U.S. Capitol and generates more than 2.1 million pounds of thrust off the launch pad."
    imageC.imageURL = URL(string: "https://360.littlstar.com/production/6e2a70c4-7903-44b2-b093-402fba7d6750/mobile_hls.m3u8")!
    trailerList.append(imageC)

    let sideload = LSSideload()
    trailerList.append(sideload)
  }
}
