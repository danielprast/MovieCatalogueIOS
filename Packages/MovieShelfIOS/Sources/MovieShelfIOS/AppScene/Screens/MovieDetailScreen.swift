//
//  MovieDetailScreen.swift
//  MovieShelfIOS
//
//  Created by Daniel Prastiwa on 25/08/25.
//

import Foundation
import SwiftUI
import MovieShelfKit


public struct MovieDetailScreen: View {

  @Bindable var movieViewModel: MovieViewModel
  @Environment(\.dismiss) private var dismiss

  public init(movieViewModel: Bindable<MovieViewModel>) {
    self._movieViewModel = movieViewModel
  }

  public var body: some View {
    contentBody()
      .toolbar(.hidden)
      .task {
        movieViewModel.getMovieDetail()
      }
  }

  @ViewBuilder
  private func contentBody() -> some View {
    if let movieDetail = movieViewModel.movieDetail {
      MovieDetailContent(movieDetail: movieDetail) {
        dismiss()
      }
    } else {
      ProgressView()
    }
  }
}


struct MovieDetailContent: View {

  let movieDetail: (any MovieDetailEntity)
  let backButton: () -> Void

  var body: some View {
    let originalImageUrl = "https://image.tmdb.org/t/p/original"
    let resizedImageUrl = "https://image.tmdb.org/t/p/w500"
    let height: CGFloat = 180
    let aspectRatio = 0.667

    GeometryReader { geo in
      let bannerHeight: CGFloat = geo.size.width * aspectRatio

      ScrollView {
        VStack {

          ZStack {

            VStack {

              Color.clear
                .frame(height: bannerHeight)

              VStack {
                VStack {
                  Text("Overview:")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)

                  Text(movieDetail.overview)
                    .font(.body)
                    .foregroundStyle(Color.gray)
                }
                .padding(.top, (height / 2) + 20)

                Spacer()
              }
              .padding()
              .background(Color.white)
            }

            VStack {

              HStack(alignment: .bottom, spacing: 20) {

                PosterImageView(imageUrl: resizedImageUrl + movieDetail.posterImage)

                VStack(alignment: .leading, spacing: 8) {

                  Text(movieDetail.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .lineLimit(3)

                  Text(movieDetail.releaseDate)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray)
                }
                .padding(
                  EdgeInsets.init(
                    top: 0,
                    leading: 0,
                    bottom: 16,
                    trailing: 16
                  )
                )
                .frame(
                  maxWidth: .infinity,
                  alignment: .leading
                )
              }
              .background(Color.clear)
              .frame(height: height, alignment: .top)
              .padding(.top, bannerHeight - 70)
              .padding(.leading, 20)

              Spacer()
            }

            VStack {
              HStack() {
                Button {
                  backButton()
                } label: {
                  Image(systemName: "chevron.backward.circle.fill")
                    .resizable()
                    .frame(width: 33, height: 33)
                    .shadow(radius: 7)
                    .foregroundStyle(Color.white)
                }
                Spacer()
              }
              Spacer()
            }
            .padding(
              EdgeInsets.init(
                top: geo.safeAreaInsets.top + 20,
                leading: 20,
                bottom: geo.safeAreaInsets.bottom,
                trailing: 20
              )
            )
          }
        }
      }
      .ignoresSafeArea()
      .background(
        VStack {
          AsyncImage(url: URL(string: originalImageUrl + movieDetail.backdropImage)!) { phase in
            if let _ = phase.error {
              Image(systemName: "exclamationmark.icloud.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: bannerHeight)
            } else if let image = phase.image {
              image
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: bannerHeight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
              ZStack {
                ProgressView()
              }
              .frame(maxWidth: .infinity, maxHeight: bannerHeight + geo.safeAreaInsets.top)
              .background(RoundedRectangle(cornerRadius: 0).fill(Color.gray.opacity(0.5)))
            }
          }
          .clipped()

          Spacer()
        }.ignoresSafeArea()
      )
    }
  }
}


struct PosterImageView: View {

  let imageUrl: String
  let height: CGFloat = 180
  let width: CGFloat = 180 * 0.667

  var body: some View {
    contentBody
  }

  var contentBody: some View {
    AsyncImage(url: URL(string: imageUrl)!) { phase in
      if let _ = phase.error {
        Image(systemName: "exclamationmark.icloud.fill")
          .resizable()
          .scaledToFit()
          .frame(width: width, height: height)
      } else if let image = phase.image {
        image
          .resizable()
          .scaledToFit()
          .frame(width: width, height: height)
          .clipShape(RoundedRectangle(cornerRadius: 8))
      } else {
        ZStack {
          ProgressView()
        }
        .frame(width: width, height: height)
      }
    }
    .clipped()
    .shadow(radius: 15, x: 0, y: 8)
    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.8)))
  }

  var placeholder: some View {
    ZStack {
      ProgressView()
    }
    .frame(width: width, height: height)
    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray))
  }
}


struct MovieDetailScreenPreview: View {

  var body: some View {
    MovieDetailContent(movieDetail: MovieDetailEntityModel.samples) {}
      .toolbar(.hidden)
  }
}


#Preview {
  MovieDetailScreenPreview()
}
