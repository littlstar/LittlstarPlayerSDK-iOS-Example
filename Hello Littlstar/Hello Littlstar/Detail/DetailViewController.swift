//
//  DetailViewController.swift
//  Littlstar
//
//  Created by Huy Dao on 1/30/17.
//  Copyright © 2017 Littlstar. All rights reserved.
//
//
import UIKit

@objc class DetailViewController: UIViewController {
  var controller: DetailController?
  var detailView: DetailView!

  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return .portrait
  }

  override func loadView() {
    super.loadView()
    self.view.backgroundColor = UIColor.black
    self.navigationController?.setNavigationBarHidden(true, animated: false)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    detailView = DetailView(frame: CGRect(x: 0, y: 0,
                                          width: view.frame.width,
                                          height: view.frame.height),
                            navBarHeight: self.navigationController!.navigationBar.frame.height)
    self.view.addSubview(detailView)
    controller = DetailController(detailView: detailView, controller: self)
  }

  override var prefersStatusBarHidden: Bool {
    return false
  }


}


