//
//  RefreshableScrollView.swift
//  stock
//
//  Created by Po-Chu Chen on 5/27/24.
//

import SwiftUI
import UIKit

struct RefreshableScrollView<Content: View>: UIViewRepresentable {
    var content: () -> Content
    var onRefresh: () -> Void

    func makeUIView(context: Context) -> UIScrollView {
        let scrollView = UIScrollView()
        let refreshControl = UIRefreshControl()
        
        // 设置较短的下拉刷新距离
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.bounds = CGRect(x: 0, y: -20, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        
        refreshControl.addTarget(context.coordinator, action: #selector(Coordinator.handleRefresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        let hostingController = UIHostingController(rootView: content())
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(hostingController.view)
        
        NSLayoutConstraint.activate([
            hostingController.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            hostingController.view.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            hostingController.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        return scrollView
    }

    func updateUIView(_ uiView: UIScrollView, context: Context) {
        if let hostingController = uiView.subviews.first(where: { $0 is UIHostingController<Content> }) as? UIHostingController<Content> {
            hostingController.rootView = content()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onRefresh: onRefresh)
    }

    class Coordinator: NSObject {
        var onRefresh: () -> Void

        init(onRefresh: @escaping () -> Void) {
            self.onRefresh = onRefresh
        }

        @objc func handleRefresh(_ sender: UIRefreshControl) {
            onRefresh()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                sender.endRefreshing()
            }
        }
    }
}
