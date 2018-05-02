//
//  DetailController.swift
//  Littlstar0
//
//  Created by Huy Dao on 1/30/17.
//  Copyright © 2017 Littlstar. All rights reserved.
//

import UIKit
import LittlstarPlayerSDK

class DetailController: NSObject {
  weak var detailView: DetailView?
  var detailModel = DetailModel()
  var navController: UINavigationController

  init(detailView: DetailView, controller: DetailViewController) {
    self.detailView = detailView
    self.navController = controller.navigationController!
    super.init()
    self.detailView?.delegate = self

    detailView.mainScroll.reloadData()
  }
}

extension DetailController: DetailViewDelegate, LSSideloaderDelegate{
  func detailviewGetItemsCount() -> Int {
    return detailModel.trailerList.count
  }


  func detailviewClose() {
    navController.popViewController(animated: true)
  }

  func detailview(getLSItem index: IndexPath) -> Any {
    return detailModel.trailerList[index.row]
  }

  func detailview(selectRow index: IndexPath) {
    let item = detailModel.trailerList[index.row]
    if item is LSSideload {
      let sideloadView = LSSideloader()
      sideloadView.delegate = self
      navController.present(sideloadView, animated: false, completion: nil)
    } else {
      let vc = PlayerViewController(with: item)
      navController.pushViewController(vc, animated: true)
    }
  }

  func lsSideloader(didFinishGettingURL url: URL) {
    let urlString = url.absoluteString.lowercased()
    var lsItem: Any!
    if urlString.contains("png") || urlString.contains("jpeg") {
      let image = LSImage()
      image.imageURL = url
      lsItem = image
    } else if url.absoluteString.lowercased().contains("mov") {
      let video = LSVideo()
      video.videoURL = url
      lsItem = video
    }
    let vc = PlayerViewController(with: lsItem)
    navController.pushViewController(vc, animated: true)
  }
}
