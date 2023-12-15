//
//  ContentView.swift
//  Acne Aid
//
//  Created by Gana on 12/6/23.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        GeometryReader{ geometry in
            ZStack (alignment: .leading){
                
                let geo_width = geometry.size.width
                
                Image("LaunchImage")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .offset(x: -100, y:0)
                
                CutoutShape()
                    .foregroundColor(Color(UIColor(named: "Color1_500")!))
                    .opacity(0.85)
                
                VStack{
                    ZStack{
                        Ellipse()
                            .frame(width: geo_width/4 + 15, height: geo_width/4 + 15)
                            .foregroundColor(.white)
                        Ellipse()
                            .foregroundColor(Color(UIColor(named: "Color3_500")!))
                            .frame(width: geo_width/4, height: geo_width/4)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: geo_width/4, height: geo_width/4)
                            .background(
                                Image("Icon").resizable()
                            )
                    }
                    .frame(width: geo_width/4 + 20, height: geo_width/4 + 20)
                    .offset(x: -70, y: 0)
                    
                    Rectangle()
                        .frame(width: geo_width/4 + 20, height: geo_width/8)
                        .foregroundColor(.clear)
                    VStack(alignment: .leading){
                        Text("Find the Skincare")
                            .font(.custom("Helvetica", size: 36)).fontWeight(.bold)
                            .foregroundColor(Color(UIColor(named: "Color0_000")!))
                        Rectangle()
                            .frame(width: 3, height: 1)
                            .foregroundColor(.clear)
                        Text("Routine that Works")
                            .font(.custom("Helvetica", size: 36)).fontWeight(.bold)
                            .foregroundColor(Color(UIColor(named: "Color0_000")!))
                        Rectangle()
                            .frame(width: 3, height: 1)
                            .foregroundColor(.clear)
                        Text("Best for You!")
                            .foregroundColor(Color(UIColor(named: "Color0_000")!))
                            .font(.custom("Helvetica", size: 36)).fontWeight(.bold)
                        
                    }
                    .offset(x: 30, y:0)
                }
                .offset(x:0, y: +geo_width/3)
                
            }
            
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct CutoutShape: Shape {
    func path(in rect: CGRect) -> Path {
        // The path of the main rectangle that fills the entire view
        let path = Path { path in
            path.addRect(rect)
        }
        
        // The path of the ellipse that will be cut out from the rectangle
        let ellipseSize = CGSize(width: rect.height * 0.7, height: rect.height * 0.9) // Adjust the size as needed
        let ellipseOrigin = CGPoint(x: 0 - ellipseSize.width/4, y: 0 - ellipseSize.height/6) // Positioned at the top right corner
        var cutout = Path { path in
            path.addEllipse(in: CGRect(origin: ellipseOrigin, size: ellipseSize))
        }
        
        let rotation = CGAffineTransform(rotationAngle: -CGFloat.pi/4)
            .translatedBy(x: 0, y: 0) // Adjust translation as needed
        cutout = cutout.applying(rotation)
        
        // Subtract the ellipse from the rectangle
        return path.symmetricDifference(cutout)
    }
}



#Preview {
    LaunchView()
}
