//  EyeNak
//
//  Created by Rajeev on 08/01/21.
//  Copyright © 2021 Sueb. All rights reserved.
//

import UIKit
import WebKit

class PaymentViewController: UIViewController,WKNavigationDelegate,WKUIDelegate{
    
    private let webView = WKWebView(frame: .zero)

    var paymentUrl : String!
    var completionHandler:((Bool,String)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        webView.frame = self.view.bounds
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.webView)
        paymentUrl = GGWebKey.domain+"provider/make-payment/\(UserDetails.shared.id)/\(UserDetails.shared.langauge)"
      
        self.view.setNeedsLayout()
        let request = URLRequest(url: URL.init(string: paymentUrl)!)
        self.webView.load(request)
        GGProgress.shared.showProgress()
        self.navigationItem.setRightBarButtonItems([UIBarButtonItem(image: UIImage(named: "close_FILL0"), style: .plain, target: self, action: #selector(btnBackAction))], animated: false)
       
        //self.navigationController?.navigationBar.isHidden = true
    }
    @objc func btnBackAction(){
        self.dismiss(animated: true)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
       // GGProgress.shared.showProgress()
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        GGProgress.shared.hideProgress()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        GGProgress.shared.hideProgress()
    }
    func webViewDidStartLoad(_ : WKWebView) {
     //   GGProgress.shared.showProgress()
    }

    func webViewDidFinishLoad(_ : WKWebView) {
        GGProgress.shared.hideProgress()
    }
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            //urlStr is what you want
            print("url ::\(urlStr)")
            
            if urlStr.lowercased().contains(GGWebKey.domain+"provider/failed-payment") {
                GGProgress.shared.hideProgress()
                if let mmesage = getQueryStringParameter(url: urlStr, param: "message"){
                    self.dismiss(animated: true)
                    self.completionHandler?(false, mmesage)
                }else{
                    self.dismiss(animated: true)
                    self.completionHandler?(false, "")
                }
            }else if urlStr.lowercased().contains(GGWebKey.domain+"provider/success-payment"){
                GGProgress.shared.hideProgress()
                self.dismiss(animated: true)
                self.completionHandler?(true, "")
            }
        }
        decisionHandler(.allow)
    }
    func getQueryStringParameter(url: String, param: String) -> String? {
      guard let url = URLComponents(string: url) else { return nil }
      return url.queryItems?.first(where: { $0.name == param })?.value
    }
}
