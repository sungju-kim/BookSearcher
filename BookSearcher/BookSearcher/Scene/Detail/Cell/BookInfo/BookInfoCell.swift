//
//  BookInfoCell.swift
//  BookSearcher
//
//  Created by dale on 2022/10/31.
//

import UIKit

final class BookInfoCell: UICollectionViewCell {
    static var identifier: String {
        return "\(self)"
    }

    private let textLabel: UILabel = {
        let label = CustomLabel(fontColor: .Custom.textGray,
                                fontSize: 12,
                                fontWeight: .regular)
        label.numberOfLines = 3
        label.text = """
특수부대 헌터 한건우. 정부에게 배신당하고 15년 전으로 회귀했다. 그가 죽인 100명의 특성을 모두 흡수한 채로. \"이건 너무 사기인데?\" 이제부터 내가 판을 짜겠다. 특수부대 헌터 한건우. 정부에게 배신당하고 15년 전으로 회귀했다. 그가 죽인 100명의 특성을 모두 흡수한 채로. \"이건 너무 사기인데?\" 이제부터 내가 판을 짜겠다.
"""
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutTextLabel()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        layoutTextLabel()
    }
}

// MARK: - Configure
extension BookInfoCell {
    func configure(with viewModel: BookInfoCellViewModel) {

    }
}

// MARK: - Layout Section

private extension BookInfoCell {
    func layoutTextLabel() {
        contentView.addSubview(textLabel)

        textLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(Constraint.regular)
        }
    }
}
