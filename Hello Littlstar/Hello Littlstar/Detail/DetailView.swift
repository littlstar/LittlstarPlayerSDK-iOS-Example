//
//  DetailView.swift
//  Littlstar
//
//  Created by Huy Dao on 1/30/17.
//  Copyright © 2017 Littlstar. All rights reserved.

import UIKit
import LittlstarPlayerSDK

class LSLabel: UILabel {
  var userTag: Int = 0
}

@objc protocol DetailViewDelegate {
  func detailviewGetItemsCount() -> Int
  func detailview(getLSItem index: IndexPath) -> Any
  func detailview(selectRow index: IndexPath)
}

class DetailView: UIView {
  var blurView: UIVisualEffectView!
  var delegate: DetailViewDelegate!
  var brandPanel: UIView!
  var mainScroll: UITableView!
  var backgroundImage: UIImageView!
  var logoImage: UIImageView!
  let margin: CGFloat = 16
  let posterHeight: CGFloat
  var panelHeight: CGFloat = 0
  var masthead: UIImageView!
  var selectRow: Int?
  var extraXHeight: CGFloat = 0

  enum cellTag: Int {
    case poster = 1
    case play
    case watch
    case details
    case divider
    case title
    case runtime
    case description
    case topContainer
    case bottomContainer
    case cellStack
  }

  
  init(frame: CGRect, navBarHeight: CGFloat) {
    posterHeight = frame.width/1.78
    super.init(frame: frame)
    let navBarHeight = navBarHeight + 20
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    panelHeight = statusBarHeight + navBarHeight
    
    // Masthead
    masthead = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.width, height: posterHeight))
    masthead.image = #imageLiteral(resourceName: "masthead")
    masthead.contentMode = .scaleAspectFill
    masthead.clipsToBounds = true
    self.addSubview(masthead)
    
    // Blur effect
    blurView = UIVisualEffectView(frame: CGRect(x: 0, y: 0, width: frame.width, height: posterHeight))
    blurView.effect = UIBlurEffect(style: .dark)
    blurView.alpha = 0
    masthead.addSubview(blurView)

    // Brand panel
    brandPanel = UIView(frame: CGRect(x: 12, y: 0, width: frame.width, height: panelHeight))
    let brand = UIImageView(image: #imageLiteral(resourceName: "logo"))
    brand.frame.size = CGSize(width: 50, height: 50)
    brand.contentMode = .scaleAspectFit
    brand.layer.cornerRadius = 8
    brand.center.y = statusBarHeight + navBarHeight/2
    brand.clipsToBounds = true
    brandPanel.addSubview(brand)
    self.addSubview(brandPanel)

    // Background
    backgroundImage = UIImageView(frame: CGRect(x: 0, y: masthead.frame.maxY, width: frame.width , height: frame.height))
    backgroundImage.contentMode = .scaleAspectFill
    backgroundImage.clipsToBounds = true
    backgroundImage.image = #imageLiteral(resourceName: "background.png")
    let shadow = UIView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height))
    shadow.backgroundColor = UIColor(white: 0, alpha: 0.1)
    backgroundImage.addSubview(shadow)
    self.addSubview(backgroundImage)

    // Content
    mainScroll = UITableView(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 50))
    mainScroll.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    mainScroll.separatorStyle = .none
    mainScroll.backgroundColor = UIColor.clear
    mainScroll.contentInset = UIEdgeInsets(top: posterHeight, left: 0, bottom: 0, right: 0)
    mainScroll.delegate = self
    mainScroll.dataSource = self
    mainScroll.rowHeight = UITableViewAutomaticDimension
    mainScroll.estimatedRowHeight = 500
    self.addSubview(mainScroll)

    let brandView = UIImageView(image: #imageLiteral(resourceName: "brand").withRenderingMode(.alwaysTemplate))
    brandView.tintColor = .white
    brandView.frame.size = CGSize(width: 230, height: 50)
    brandView.contentMode = .scaleAspectFit
    brandView.frame.origin = CGPoint(x: frame.width - 248, y: frame.height - 50)
    self.addSubview(brandView)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension DetailView: UITableViewDataSource, UITableViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let offset = scrollView.contentOffset.y + posterHeight
    let scrollPercentage = -scrollView.contentOffset.y/posterHeight
  
    // Table offset is at or below posterHeight
    if offset <= 0 {
      backgroundImage.frame.origin.y = posterHeight + extraXHeight
      brandPanel.frame.origin.y = 0
      masthead.frame.origin.y = extraXHeight
      blurView.alpha = 0
    } else if offset <= (posterHeight - extraXHeight) {
      // Table offset is between above posterHeight and below topScreen
      backgroundImage.frame.origin.y = -scrollView.contentOffset.y
      brandPanel.frame.origin.y = scrollPercentage * panelHeight - panelHeight
      masthead.frame.origin.y = -offset/3 + extraXHeight
      blurView.alpha = 1 - scrollPercentage
    } else if offset > posterHeight {
      // Table offset is off screen
      backgroundImage.frame.origin.y = 0
      blurView.alpha = 0
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if delegate == nil {
      return 0
    } else {
      return delegate!.detailviewGetItemsCount()
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    var title: String = ""
    var desc: String = ""
    let lsItem = delegate.detailview(getLSItem: indexPath)
    if let video = lsItem as? LSVideo {
      title = video.title
      desc = video["desc"] as! String
    } else if let image = lsItem as? LSImage {
      title = image.title
      desc = image["desc"] as! String
    }

    var titleComparision: UILabel? = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width - (margin * 2) - 90, height: 0))
    titleComparision?.numberOfLines = 0
    titleComparision?.text = title.trimmingCharacters(in: .whitespacesAndNewlines)
    titleComparision?.sizeToFit()
    
    var descriptionComparision: UILabel? = UILabel(frame: CGRect(x: 0, y: 0, width: frame.width - (margin * 2), height: 0))
    descriptionComparision!.numberOfLines = 0
    descriptionComparision!.text = desc.trimmingCharacters(in: .whitespacesAndNewlines)
    descriptionComparision!.sizeToFit()
    
    let posterSize: CGFloat = ((frame.width - (margin * 2))/1.78) + margin
    let controlSize: CGFloat = 60
    let detailSize: CGFloat = titleComparision!.frame.height + descriptionComparision!.frame.height + margin * 2
    titleComparision = nil
    descriptionComparision = nil
    let smallHeight = posterSize + controlSize
    let expandedHeight = smallHeight + detailSize
    if selectRow != nil {
      if indexPath.row == selectRow! {
        return expandedHeight
      } else {
        return smallHeight
      }
    } else {
      return smallHeight
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    cell.backgroundColor = UIColor.clear
    cell.selectionStyle = .none
    cell.clipsToBounds = true
    
    let imageWidth = frame.width - (margin * 2)

    // Super view of all UI Elements that should always show in the table view
    var topContainer = cell.contentView.viewWithTag(cellTag.topContainer.rawValue)
    if topContainer == nil {
      topContainer = UIView()
      topContainer!.heightAnchor.constraint(equalToConstant: imageWidth/1.78 + 60).isActive = true
      topContainer!.widthAnchor.constraint(equalToConstant: cell.contentView.frame.width).isActive = true
      topContainer!.tag = cellTag.topContainer.rawValue
    }

    // Super view of all UI Elements that would only show when a user taps the + Detail button
    var bottomContainer = cell.contentView.viewWithTag(cellTag.bottomContainer.rawValue)
    if bottomContainer == nil {
      bottomContainer = UIView()
      bottomContainer!.heightAnchor.constraint(equalToConstant: cell.contentView.frame.height - topContainer!.frame.height).isActive = true
      bottomContainer!.widthAnchor.constraint(equalToConstant: cell.contentView.frame.width).isActive = true
      bottomContainer!.tag = cellTag.bottomContainer.rawValue
    }

    var stackView = cell.contentView.viewWithTag(cellTag.cellStack.rawValue) as? UIStackView
    if stackView == nil {
      stackView = UIStackView()
      stackView!.axis = .vertical
      stackView!.distribution = .fillProportionally
      stackView!.alignment = .center
      stackView!.spacing = 0
      stackView!.addArrangedSubview(topContainer!)
      stackView!.addArrangedSubview(bottomContainer!)
      stackView!.translatesAutoresizingMaskIntoConstraints = false
      cell.contentView.addSubview(stackView!)
    }

    var divider = cell.contentView.viewWithTag(cellTag.divider.rawValue)
    if divider == nil {
      divider = UIView(frame: CGRect(x: margin, y: 0, width: imageWidth, height: 1))
      divider?.backgroundColor = UIColor(white: 1, alpha: 0.5)
      divider?.tag = cellTag.divider.rawValue
      topContainer!.addSubview(divider!)
    }
    
    var showImage = cell.contentView.viewWithTag(cellTag.poster.rawValue) as? UIImageView
    if showImage == nil {
      showImage = UIImageView(frame: CGRect(x: margin, y: margin, width: imageWidth, height: imageWidth/1.78))
      showImage?.contentMode = .scaleAspectFill
      showImage?.alpha = 0.8
      showImage?.clipsToBounds = true
      showImage?.tag = cellTag.poster.rawValue
      topContainer!.addSubview(showImage!)
    }
    
    var playImage = cell.contentView.viewWithTag(cellTag.play.rawValue) as? UIImageView
    if playImage == nil {
      playImage = UIImageView(frame: CGRect(x: margin, y: showImage!.frame.maxY + 18, width: 24, height: 24))
      playImage?.image = #imageLiteral(resourceName: "play").withRenderingMode(.alwaysTemplate)
      playImage?.tintColor = UIColor.white
      playImage?.contentMode = .scaleAspectFill
      playImage?.clipsToBounds = true
      playImage?.tag = cellTag.play.rawValue
      topContainer!.addSubview(playImage!)
    }
    
    var watchLabel = cell.contentView.viewWithTag(cellTag.watch.rawValue) as? UILabel
    if watchLabel == nil {
      watchLabel = UILabel (frame: CGRect(x: playImage!.frame.maxX + margin, y: showImage!.frame.maxY, width: 100, height: 60))
      watchLabel?.text = "Watch Now"
      watchLabel?.textColor = .white
      watchLabel?.tag = cellTag.watch.rawValue
      topContainer!.addSubview(watchLabel!)
    }
    
    var detail = cell.contentView.viewWithTag(cellTag.details.rawValue) as? LSLabel
    if detail == nil {
      detail = LSLabel(frame: CGRect(x: showImage!.frame.maxX - 100, y: 0, width: 100, height: 50))
      detail?.isUserInteractionEnabled = true
      detail?.text = "\u{FF0B}  Details"
      detail?.textColor = .white
      detail?.textAlignment = .right
      detail?.center.y = watchLabel!.center.y
      detail?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleCellExpansion(gesture:))))
      detail?.tag = cellTag.details.rawValue
      topContainer!.addSubview(detail!)
    }
    detail?.userTag = indexPath.row
    
    var titleLabel = cell.contentView.viewWithTag(cellTag.title.rawValue) as? UILabel
    if titleLabel == nil {
      titleLabel = UILabel(frame: CGRect(x: margin, y: 13, width: imageWidth - margin, height: 0))
      titleLabel?.numberOfLines = 0
      titleLabel?.textColor = .white
      titleLabel?.tag = cellTag.title.rawValue
      bottomContainer!.addSubview(titleLabel!)
    }
    
    var description = cell.contentView.viewWithTag(cellTag.description.rawValue) as? UILabel
    if description == nil {
      description = UILabel(frame: CGRect(x: margin, y: 0, width: imageWidth, height: 0))
      description?.alpha = 0.65
      description?.numberOfLines = 0
      description?.textColor = .white
      description?.tag = cellTag.description.rawValue
      bottomContainer!.addSubview(description!)
    }
    
    return cell
  }
  
  @objc func toggleCellExpansion(gesture: UIGestureRecognizer){
    let button = gesture.view as! LSLabel
    let index = IndexPath(row: button.userTag, section: 0)
    let cell = self.mainScroll.cellForRow(at: index)
    let currentContainer = cell?.contentView.viewWithTag(cellTag.bottomContainer.rawValue)
    let currentDetailsLabel = cell?.viewWithTag(cellTag.details.rawValue) as? UILabel

    // Make sure to call beginUpdates and endUpdates when animating the cells
    // This will ensure the tableView notices the change of cellHeights
    if selectRow == button.userTag {
      selectRow = nil
      mainScroll.beginUpdates()
      currentContainer?.isHidden = true
      currentDetailsLabel?.text = "\u{FF0B}  Details"
      mainScroll.endUpdates()
    } else if selectRow != nil {
      let previousIndex = IndexPath(row: selectRow!, section: 0)
      selectRow = button.userTag
      let previousCell = self.mainScroll.cellForRow(at: previousIndex)
      let previousContainer = previousCell?.contentView.viewWithTag(cellTag.bottomContainer.rawValue)
      let previousDetailLabel = previousCell?.viewWithTag(cellTag.details.rawValue) as? UILabel
      mainScroll.beginUpdates()
      previousContainer?.isHidden = true
      previousDetailLabel?.text = "\u{FF0B}  Details"
      currentContainer?.isHidden = false
      currentDetailsLabel?.text = "\u{FF0D}  Details"
      mainScroll.endUpdates()
    } else {
      selectRow = button.userTag
      mainScroll.beginUpdates()
      currentContainer?.isHidden = false
      currentDetailsLabel?.text = "\u{FF0D}  Details"
      mainScroll.endUpdates()
    }
  }
  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    let lsItem = delegate.detailview(getLSItem: indexPath)
    let titleLabel = cell.viewWithTag(cellTag.title.rawValue) as! UILabel
    let showImage = cell.viewWithTag(cellTag.poster.rawValue) as! UIImageView
    let description = cell.viewWithTag(cellTag.description.rawValue) as! UILabel
    let divider = cell.viewWithTag(cellTag.divider.rawValue)
    let details = cell.viewWithTag(cellTag.details.rawValue) as! UILabel
    let watchLabel = cell.viewWithTag(cellTag.watch.rawValue) as! UILabel

    watchLabel.text = "Watch Now"
    details.isHidden = false

    if let video = lsItem as? LSVideo {
      showImage.image = video["poster"] as? UIImage
      titleLabel.text = video.title
      description.text = (video["desc"] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    } else if let image = lsItem as? LSImage {
      showImage.image = image["poster"] as? UIImage
      titleLabel.text = image.title
      description.text = (image["desc"] as! String).trimmingCharacters(in: .whitespacesAndNewlines)
    } else if lsItem is LSSideload {
      showImage.image = #imageLiteral(resourceName: "DImage")
      watchLabel.text = "Sideload"
      details.isHidden = true
    }

    if indexPath.row == selectRow {
      details.text = "\u{FF0D}  Details"
    } else {
      details.text = "\u{FF0B}  Details"
    }

    titleLabel.frame.size = CGSize(width: frame.width - (margin * 2) - 90, height: 0)
    titleLabel.sizeToFit()

    description.frame.size = CGSize(width: frame.width - (margin * 2), height: CGFloat(0))
    description.frame.origin.y = titleLabel.frame.maxY + 8
    description.sizeToFit()

    if indexPath.row == 0 {
      divider?.alpha = 0
    } else {
      divider?.alpha = 1
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.detailview(selectRow: indexPath)
  }
  
}
