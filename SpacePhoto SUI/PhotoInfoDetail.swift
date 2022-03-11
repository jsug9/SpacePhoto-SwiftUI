//
//  PhotoInfoDetail.swift
//  SpacePhoto SUI
//
//  Created by Augusto Galindo Alí on 23/02/21.
//

import SwiftUI

//struct OrientationView: View
//    @State var isLoading = true
//
//    var body: some View {
//        Group {
//            Text("title").font(.title).padding([.horizontal, .top])
//
//            ZStack {
//                Image(uiImage: UIImage())
//                    .resizable()
//                if isLoading {
//                    ProgressView()
//                }
//            }
//            .aspectRatio(1, contentMode: .fit)
//            .padding()
//
//            Text("description")
//                .multilineTextAlignment(.leading)
//                .padding(.horizontal)
//
//            Text("copyright").font(.footnote).padding([.horizontal, .bottom])
//        }
//    }
//}

struct PhotoInfoDetail: View {
    
    var photoInfoController = PhotoInfoController()
    
    @State var title = ""
    @State var description = ""
    @State var copyright = ""
    @State var image: UIImage = UIImage()
    
    var date: Date
    
    @State private var isLoading = true
    
    var body: some View {
        GeometryReader { geometry in
            Group() {
                if geometry.size.height > geometry.size.width {
                    verticalView()
                } else {
                    horizontalView()
                }
            }
        }
        .navigationBarTitle(Text(dateFormatter.string(from: date)), displayMode: .inline)
        .onAppear(perform: {
            photoInfoController.fetchPhotoInfo(date: date) { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let photoInfo):
                        self.updateUI(with: photoInfo)
                    case .failure(let error):
                        self.updateUI(with: error)
                    }
                }
            }
        })
    }
    
    func verticalView() -> some View {
        ScrollView {
            VStack() {
                titleAndImage()
                descriptionAndCopyright()
            }
        }
    }
    
    func horizontalView() -> some View {
        HStack() {
            titleAndImage()
            ScrollView {
                descriptionAndCopyright().padding(.vertical)
            }
        }
    }
    
    func titleAndImage() -> some View {
        VStack {
            Text(title).font(.title).padding([.top])
        
            ZStack {
                Image(uiImage: image)
                    .resizable()
                if isLoading {
                    ProgressView()
                }
            }
            .aspectRatio(1.5, contentMode: .fit)
            .padding()
            Spacer()
        }
    }
    
    func descriptionAndCopyright() -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(description)
                .multilineTextAlignment(.leading)
                .padding(.horizontal)
                
            Text(copyright).font(.footnote).padding([.horizontal, .bottom])
        }
        
    }
    
    func updateUI(with photoInfo: PhotoInfo) {
        photoInfoController.fetchImage(from: photoInfo.url) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.title = photoInfo.title
                    self.image = image
                    self.description = photoInfo.description
                    self.copyright = photoInfo.copyright ?? "No Copyright"
                    self.isLoading = false
                case .failure(let error):
                    self.updateUI(with: error)
                }
            }
        }
    }
    
    func updateUI(with error: Error) {
        title = "No Photo Found"
        image = UIImage()
        description = ""
        copyright = ""
        self.isLoading = false
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoInfoDetail(date: Date())
    }
}
