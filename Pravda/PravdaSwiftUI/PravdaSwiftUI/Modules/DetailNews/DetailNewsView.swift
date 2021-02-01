//
//  DetailNewsView.swift
//  PravdaSwiftUI
//
//  Created by Дмитрий Матвеенко on 31.01.2021.
//

import Models
import Constants
import SwiftUI

struct DetailNewsView: View {
	let newsItem: NewsItem
	@State var isNewsFavorite = false

	var body: some View {
		ScrollView {
			VStack(alignment: .leading) {
				Image(uiImage: Assets.getImage(named: newsItem.image))
					.resizable()
					.aspectRatio(4/3, contentMode: .fit)
				Group {
					Text(newsItem.title)
						.font(.system(size: 26))
						.fontWeight(.heavy)
						.padding(.top, 26)
					Text(newsItem.timePublication)
						.font(.system(size: 12))
						.fontWeight(.semibold)
						.foregroundColor(Color(UIColor.systemGray2))
						.padding(.top, 2)
					Text(newsItem.text ?? "")
						.padding(.top, 26)
				}
				.padding(.horizontal, 19)
			}
		}
		.navigationBarTitle(newsItem.source, displayMode: .inline)
		.navigationBarItems(trailing:
			Button(action: {
				isNewsFavorite.toggle()
			}) {
				Image(systemName: isNewsFavorite ? Assets.bookmarkFill.rawValue : Assets.bookmark.rawValue)
			}
		)
	}
}

struct DetailNewsView_Previews: PreviewProvider {
	static var previews: some View {
		let newsItem = NewsItem.makeTopStoriesMock(isOnlyOneItem: true)[0]
		NavigationView {
			DetailNewsView(newsItem: newsItem)
		}
	}
}