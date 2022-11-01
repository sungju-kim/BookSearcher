//
//  CommonHeaderView.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class CommonHeaderView: UICollectionReusableView {
    static var identifier: String {
        return "\(self)"
    }

    private let headerLabel = CustomLabel(fontColor: .white, fontSize: 28, fontWeight: .semibold)

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutHeaderLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutHeaderLabel()
    }
}

// MARK: - Configure

extension CommonHeaderView {
    func configure(with text: String?) {
        headerLabel.text = text
    }
}

// MARK: - Layout Section

private extension CommonHeaderView {
    func layoutHeaderLabel() {
        addSubview(headerLabel)

        headerLabel.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview().inset(Constraint.regular)
            make.top.equalToSuperview().inset(Constraint.semiMax)
        }
    }
}
