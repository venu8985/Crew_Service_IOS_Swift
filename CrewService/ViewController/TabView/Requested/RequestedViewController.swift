//
//  RequestedViewController.swift
//  TasmemcomUser
//
//  Created by Gaurav Gudaliya R on 30/06/20.
//  Copyright © 2020 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class RequestedViewController: BaseViewController {

    @IBOutlet weak var segmentedView: JXSegmentedView!
    @IBOutlet weak var segmentedContainerView: UIView!
    var listContainerView: JXSegmentedListContainerView!
    var segmentedDataSource: JXSegmentedBaseDataSource!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let titles = [Language.get("New_Top_Tab"),Language.get("Ongoing_Top_Tab"),Language.get("Complated_Top_Tab")]
        let dataSource = JXSegmentedTitleDataSource()
        dataSource.isItemSpacingAverageEnabled = true
        dataSource.titles = titles
        dataSource.itemWidth = ((self.segmentedView.frame.width)/3)-20
        dataSource.titleNormalFont = UIFont.init(name: "AvenirLTStd-Roman", size: 14.0) ?? UIFont.boldSystemFont(ofSize: 12)
        dataSource.titleSelectedFont = UIFont.init(name: "AvenirLTStd-Roman", size: 14.0) ?? UIFont.boldSystemFont(ofSize: 12)
        dataSource.titleSelectedColor = .appRed
        dataSource.titleNormalColor = .appBlack
        self.segmentedDataSource = dataSource

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 34
        indicator.indicatorColor = .white
        indicator.indicatorCornerRadius = 10

        //indicator.indicatorWidth = (segmentedView.frame.width-30)/3
        segmentedView.indicators = [indicator]
        segmentedView.backgroundColor = UIColor(hex: 0xF4F4F8)
        segmentedView.layer.cornerRadius = 10
        segmentedView.dataSource = segmentedDataSource
        segmentedView.delegate = self
    
        listContainerView = JXSegmentedListContainerView(dataSource: self)
        segmentedView.listContainer = listContainerView
        segmentedContainerView.addSubview(listContainerView)
        listContainerView.translatesAutoresizingMaskIntoConstraints = false
        listContainerView.topAnchor.constraint(equalTo: segmentedContainerView.topAnchor).isActive = true
        listContainerView.bottomAnchor.constraint(equalTo: segmentedContainerView.bottomAnchor).isActive = true
        listContainerView.leadingAnchor.constraint(equalTo: segmentedContainerView.leadingAnchor).isActive = true
        listContainerView.trailingAnchor.constraint(equalTo: segmentedContainerView.trailingAnchor).isActive = true
       // segmentedView.defaultSelectedIndex = 0
        self.navigationItem.titleView = UIImageView(image: UIImage(named: "navigation_logo"))

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.navigationController?.setupWhiteTintColor()
    }
}

extension RequestedViewController: JXSegmentedViewDelegate {
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        if let dotDataSource = segmentedDataSource as? JXSegmentedDotDataSource {
            dotDataSource.dotStates[index] = false
            segmentedView.reloadItem(at: index)
        }
        navigationController?.interactivePopGestureRecognizer?.isEnabled = (segmentedView.selectedIndex == 0)
    }
}

extension RequestedViewController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        if index == 0 {
            let vc = UIStoryboard.instantiateViewController(withViewClass: NewRequestViewController.self)
            return vc
        }else if index == 1{
            let vc = UIStoryboard.instantiateViewController(withViewClass: ReceviedQuoteViewController.self)
            return vc
        }else {
            let vc = UIStoryboard.instantiateViewController(withViewClass: CloseRequestViewController.self)
            return vc
        }
    }
}
