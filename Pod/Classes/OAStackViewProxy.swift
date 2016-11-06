//
//  OAStackViewProxy.swift
//  Masilotti.com
//
//  Created by Joe Masilotti on 5/4/16.
//  Copyright © 2016 Masilotti.com. All rights reserved.
//

import UIKit

@objc public class OAStackViewProxy: UIView {
    public init() {
        super.init(frame: CGRect.zero)
        if #available(iOS 9, *) {
            installFullScreenView(nativeStackView)
        } else {
            installFullScreenView(backwardsCompatibleStackView)
        }
    }

    public init(arrangedSubviews: [UIView]) {
        super.init(frame: CGRect.zero)
        if #available(iOS 9, *) {
            installFullScreenView(nativeStackView)
            arrangedSubviews.forEach({ (view) in nativeStackView.addArrangedSubview(view) })
        } else {
            installFullScreenView(backwardsCompatibleStackView)
            arrangedSubviews.forEach({ (view) in backwardsCompatibleStackView.addArrangedSubview(view) })
        }
    }

    public required init?(coder aDecoder: NSCoder) { fatalError("Unimplemented.") }

    public var arrangedSubviews: [UIView] {
        if #available(iOS 9, *) {
            return nativeStackView.arrangedSubviews
        } else {
            return backwardsCompatibleStackView.arrangedSubviews
        }
    }

    public func addArrangedSubview(view: UIView) {
        if #available(iOS 9, *) {
            nativeStackView.addArrangedSubview(view)
        } else {
            backwardsCompatibleStackView.addArrangedSubview(view)
        }
    }

    public func removeArrangedSubview(view: UIView) {
        if #available(iOS 9, *) {
            nativeStackView.removeArrangedSubview(view)
        } else {
            backwardsCompatibleStackView.removeArrangedSubview(view)
        }
    }

    public var axis: UILayoutConstraintAxis = .horizontal {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.axis = axis
            } else {
                backwardsCompatibleStackView.axis = axis
            }
        }
    }

    public var distribution: OAStackViewDistribution = .fill {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.distribution = UIStackViewDistribution(distribution: distribution)
            } else {
                backwardsCompatibleStackView.distribution = distribution
            }
        }
    }

    public var alignment: OAStackViewAlignment = .fill {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.alignment = UIStackViewAlignment(alignment: alignment)
            } else {
                backwardsCompatibleStackView.alignment = alignment
            }
        }
    }

    public var spacing: CGFloat = 0.0 {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.spacing = spacing
            } else {
                backwardsCompatibleStackView.spacing = spacing
            }
        }
    }

    public var baselineRelativeArrangement: Bool = false {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.isBaselineRelativeArrangement = baselineRelativeArrangement
            }
        }
    }

    public var layoutMarginsRelativeArrangement: Bool = false {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.isLayoutMarginsRelativeArrangement = layoutMarginsRelativeArrangement
            }
        }
    }

    @available(iOS 9.0, *)
    fileprivate lazy var nativeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    fileprivate lazy var backwardsCompatibleStackView: OAStackView = {
        let stackView = OAStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
}

@available(iOS 8, *)
public extension OAStackViewProxy {
    public override var layoutMargins: UIEdgeInsets {
        didSet {
            if #available(iOS 9, *) {
                nativeStackView.layoutMargins = layoutMargins
            } else {
                backwardsCompatibleStackView.layoutMargins = layoutMargins
            }
        }
    }
}

@available(iOS 9, *)
private extension UIStackViewAlignment {
    init(alignment: OAStackViewAlignment) {
        switch alignment {
        case .fill:
            self = .fill
        case .leading:
            self = .leading
        case .firstBaseline:
            self = .firstBaseline
        case .center:
            self = .center
        case .trailing:
            self = .trailing
        case .baseline:
            self = .firstBaseline
        }
    }
}

@available(iOS 9, *)
private extension UIStackViewDistribution {
    init(distribution: OAStackViewDistribution) {
        switch distribution {
        case .fill:
            self = .fill
        case .fillEqually:
            self = .fillEqually
        case .fillProportionally:
            self = .fillProportionally
        case .equalSpacing:
            self = .equalSpacing
        case .equalCentering:
            self = .equalCentering
        }
    }
}

private extension UIView {
    func installFullScreenView(_ view: UIView) {
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false

        let views = ["view": view]
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: [], metrics: nil, views: views))
    }
}
