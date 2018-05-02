//
//  PlayerViewController.swift
//  Hello Littlstar
//
//  Created by Huy Dao on 4/30/18.
//  Copyright © 2018 Huy Dao. All rights reserved.
//

import UIKit
import LittlstarPlayerSDK

class PlayerViewController: UIViewController {
  var player: LSPlayer!
  var selectedItem: Any

  init(with item: Any) {
    self.selectedItem = item
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    super.loadView()
    self.navigationController?.navigationBar.isHidden = true
    self.view.backgroundColor = .black
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    player = LSPlayer(frame: view.frame, withMenu: true)
    player.thumbColor = .red
    player.delegate = self
    view.addSubview(player)

    if let video = selectedItem as? LSVideo {
      player.initLSVideo(video, shouldLoop: false, hasAnimation: true)
    } else if let image = selectedItem as? LSImage {
      player.initLSImage(image, hasAnimation: true)
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    player.stop(completion: nil)
  }

  override var prefersStatusBarHidden: Bool {
    return true
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
}

extension PlayerViewController: LSPlayerDelegate {
  func lsPlayerReadyWith(image: LSImage, error: String?) {
    if error == nil {
      player.play()
    } else {
      print(error!)
    }
  }

  func lsPlayerReadyWith(video: LSVideo, error: String?) {
    if error == nil {
      player.play()
    } else {
      print(error!)
    }
  }

  func lsPlayer(isBuffering: Bool) {
    // Do something when the player starts to buffer
  }

  func lsPlayerHasUpdated(currentTime: Double, bufferedTime: Double) {
    // Do something with the currentTime and bufferedTime here
  }

  func lsPlayerHasEnded() {
    player.stop {
      self.navigationController?.popViewController(animated: true)
    }
  }

  func lsPlayerDidTap() {
    print("did tap player")
  }

  func lsPlayerDidGet(headphoneEvent: LSEarpodEvent) {
    print("did receive headphone event")
  }
}
