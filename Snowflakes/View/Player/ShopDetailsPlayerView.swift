import SwiftUI
import PhotosUI
import Mantis

struct ShopDetailsPlayerView: View {
    
    @EnvironmentObject var navigationManager: NavigationManager
    @EnvironmentObject var cartManager: CartManager
    @StateObject private var getTeamDetailVM = GetTeamDetailByRoomCode()
    @StateObject private var getShopVM = GetShopByRoomCodeViewModel()
    @StateObject private var addToCartVM = AddToCartViewModel()
    @StateObject private var uploadImageVM = UploadImageViewModel()
    
    @State private var team: Team? = nil
    @State private var availableItemsFromShop: ShopMessageResponse? = nil
    @State private var teamNumber: Int = 0
    
    @State private var selectedItem: String?
    @State private var selectedStock: Int?
    @State private var selectedPrice: Int?
    @State private var showAlert = false
    @State private var quantity = ""
    
    @State private var selectedImage: UIImage?
    @State private var croppedImage: UIImage?
    @State private var showImagePicker = false
    @State private var showImageCropper = false
    @State private var selectedImages: [UIImage] = []
    @State private var showAddToCartAlert: Bool = false
    let playerRoomCode: String
    var roundNumber: Int
    
    @State private var notifications: [NotificationItem] = [
        NotificationItem(message: "You purchased Pen (x2) and Paper (x3)", amount: 10, color: Color.white, isChecked: false),
        NotificationItem(message: "You purchased Pen (x1) and Paper (x1)", amount: 5, color: Color.white, isChecked: false),
        NotificationItem(message: "You have received 5 Dollars by selling snowflake.", amount: 5, color: Color.white, isChecked: false)
    ]
    
    var body: some View {
        
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                teamLabel
                
                items
                
                //                    notificationList
                
                uploadImageSection
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .top)
        }
        .refreshable {
            if let teamNumber = UserDefaults.standard.value(forKey: "TeamDetail-\(playerRoomCode)") as? Int {
                getTeamDetailVM.fetchTeams(playerRoomCode: playerRoomCode, teamNumber: teamNumber)
                self.teamNumber = teamNumber
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    navigationManager.pop()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    navigationManager.navigateTo(Destination.addToCartView(playerRoomCode: playerRoomCode, teamNumber: teamNumber, roundNumber: roundNumber, hostRoomCode: team?.hostRoomCode ?? ""))
                }) {
                    Image(systemName: "cart.badge.plus")
                        .foregroundColor(.primary)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if let teamNumber = UserDefaults.standard.value(forKey: "TeamDetail-\(playerRoomCode)") as? Int {
                getTeamDetailVM.fetchTeams(playerRoomCode: playerRoomCode, teamNumber: teamNumber)
                self.teamNumber = teamNumber
            }
        }
        .onReceive(getTeamDetailVM.$team) { team in
            self.team = team
            if let hostRoomCode = team?.hostRoomCode {
                getShopVM.fetchShop(hostRoomCode: hostRoomCode)
            }
        }
        .onReceive(getShopVM.$shopMessageResponse) { shopItems in
            self.availableItemsFromShop = shopItems
        }
        .onReceive(addToCartVM.$isSuccess) { success in
            if success {
                showAddToCartAlert = true
            }
        }
    }
    
    // MARK: - Team Label (Private Function)
    private var teamLabel: some View {
        HStack {
            VStack(alignment: .leading) {
                if let teamNumber = team?.teamNumber {
                    Text("Team: \(teamNumber)")
                        .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                        .foregroundStyle(Color.primary)
                } else {
                    Text("No Team Found")
                        .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .body).pointSize))
                        .foregroundColor(.primary)
                }
                HStack {
                    Text("Balance: ")
                        .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                        .foregroundColor(.primary)
                    Image("tokenCoin")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                    if let tokens = team?.tokens {
                        Text("\(String(describing: tokens)) tokens")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                            .foregroundColor(.primary)
                    } else {
                        Text("No tokens found")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                            .foregroundColor(.primary)
                    }
                }
            }
            Spacer()
            if let teamStocks = team?.teamStocks {
                ForEach(teamStocks, id: \.self) { item in
                    VStack {
                        Image(item.productName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                        Text("\(item.remainingStock)x")
                            .font(.custom("Lato-Regular", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                            .foregroundStyle(Color.gray)
                    }
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Items List
    private var items: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Buy")
                    .font(.custom("Lato", size: UIFont.preferredFont(forTextStyle: .body).pointSize).weight(.medium))
                Spacer()
            }
            .padding(.horizontal, 10)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    if let shopItems = availableItemsFromShop?.shopStocks {
                        ForEach(shopItems, id: \.self) { item in
                            PlayerShopItemView(
                                imageName: item.productName,
                                title: "\(item.remainingStock) x \(item.productName) left",
                                onTap: {
                                    selectedItem = item.productName
                                    selectedStock = item.remainingStock
                                    selectedPrice = item.price
                                    showAlert = true
                                    quantity = ""
                                }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, 5)
        }
        .alert("How many \(selectedItem ?? "Item cannot be found!") do you want to add to cart?", isPresented: $showAlert) {
            VStack {
                TextField("Enter quantity", text: $quantity)
                    .keyboardType(.numberPad)
            }
            Button("Add", action: {
                if let item = selectedItem, let price = selectedPrice, let quantityInt = Int(quantity) {
                    //                    cartManager.addItem(name: item, price: price, quantity: quantityInt)
                    addToCartVM.productName = item
                    addToCartVM.price = price
                    addToCartVM.quantity = quantityInt
                    addToCartVM.playerRoomCode = playerRoomCode
                    addToCartVM.teamNumber = teamNumber
                    addToCartVM.addToCart()
                }
                showAlert = false
            })
            .disabled(isBuyButtonDisabled)
            
            Button("Cancel", role: .cancel) {}
        }
        .alert("Added to cart successfully.", isPresented: $showAddToCartAlert) {
            Button("OK", action: {
                showAddToCartAlert = false
            })
            Button("Cancel", role: .cancel) {}
        }
    }
    
    private var isBuyButtonDisabled: Bool {
        guard let stock = selectedStock, let quantityInt = Int(quantity) else {
            return true
        }
        return quantityInt <= 0 || quantityInt > stock
    }
    
    // MARK: - Notification List
    private var notificationList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Notifications")
                .font(Font.custom("Lato", size: UIFont.preferredFont(forTextStyle: .body).pointSize).weight(.medium))
                .foregroundColor(.black)
                .padding(.bottom, 10)
            
            ScrollView {
                ForEach(notifications.indices, id: \.self) { index in
                    let notification = notifications[index]
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(notification.message)
                                .font(Font.custom("Poppins", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                                .foregroundColor(.black)
                                .lineLimit(2)
                            
                            Text("Total amount: \(notification.amount) tokens")
                                .font(Font.custom("Poppins", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                                .tracking(1.5)
                                .foregroundColor(.black)
                                .opacity(0.65)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            notifications[index].isChecked.toggle()
                            notifications[index].color = notifications[index].isChecked ? AppColors.frostBlue : Color.white
                        }) {
                            Image(systemName: notifications[index].isChecked ? "checkmark.circle.fill" : "checkmark.circle")
                                .resizable()
                                .frame(width: 25, height: 25)
                                .foregroundColor(notifications[index].isChecked ? Color.green : Color.gray)
                                .padding(5)
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 10)
                    .background(notification.color)
                    .cornerRadius(12)
                    .shadow(radius: 5, x: 0, y: 2)
                    .frame(height: 55)
                }
            }
        }
        .padding(.horizontal, 10)
    }
    
    // MARK: - Upload Image Section
    private var uploadImageSection: some View {
        VStack(alignment: .leading) {
            Text("Sell your Snowflake")
                .font(Font.custom("Lato", size: UIFont.preferredFont(forTextStyle: .body).pointSize).weight(.medium))
                .foregroundColor(.primary)
            
            ZStack {
                Rectangle()
                    .foregroundColor(.clear)
                    .background(Color.white.opacity(0.50))
                    .cornerRadius(20)
                    .frame(maxWidth: .infinity)
                    .frame(height: 238)
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.black, lineWidth: 0.25)
                    )
                
                if let image = croppedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .cornerRadius(20)
                } else if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .cornerRadius(20)
                } else {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 199, height: 30)
                        .foregroundColor(.gray)
                }
            }
            .onTapGesture {
                showImagePicker = true
            }
            
            HStack {
                Button(action: {
                    if let image = croppedImage {
                        if let teamId = team?.id {
                            uploadImageVM.uploadImage(image, teamId: teamId)
                        }
                    }
                }) {
                    Text(uploadImageVM.isUploading ? "Uploading..." : "Send Snowflake to Shop")
                        .font(.custom("Lato-Bold", size: UIFont.preferredFont(forTextStyle: .callout).pointSize))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(uploadImageVM.uploadSuccess ? Color.green : AppColors.frostBlue)
                        .cornerRadius(10)
                }
                .padding(.top, 10)
                .disabled(uploadImageVM.isUploading)
            }
            
            // Show Upload Result
            if let errorMessage = uploadImageVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            if uploadImageVM.uploadSuccess {
                Text("Upload Successful!")
                    .foregroundColor(.green)
                    .font(.caption)
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(selectedImage: $selectedImage, showImagePicker: $showImagePicker, showImageCropper: $showImageCropper)
        }
        .fullScreenCover(isPresented: $showImageCropper) {
            if let imageToCrop = selectedImage {
                ImageCropper(image: imageToCrop, croppedImage: $croppedImage, isPresented: $showImageCropper)
            }
        }
        .padding(.horizontal, 10)
    }
}

// MARK: - Image Picker (Select from Photo Library)
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Binding var showImagePicker: Bool
    @Binding var showImageCropper: Bool
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                print("Image picked: \(uiImage)") // Debugging log
                
                DispatchQueue.main.async {
                    self.parent.selectedImage = uiImage
                    self.parent.showImageCropper = true // Trigger cropper after selecting image
                }
            }
            parent.showImagePicker = false
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}

// MARK: - Image Cropper (Using Mantis)
struct ImageCropper: UIViewControllerRepresentable {
    var image: UIImage
    @Binding var croppedImage: UIImage?
    @Binding var isPresented: Bool
    
    class Coordinator: NSObject, CropViewControllerDelegate {
        var parent: ImageCropper
        
        init(parent: ImageCropper) {
            self.parent = parent
        }
        
        // Called when cropping succeeds
        func cropViewControllerDidCrop(
            _ cropViewController: Mantis.CropViewController,
            cropped: UIImage,
            transformation: Mantis.Transformation,
            cropInfo: Mantis.CropInfo
        ) {
            DispatchQueue.main.async {
                self.parent.croppedImage = cropped // Update the cropped image
                self.parent.isPresented = false // Dismiss cropper
                print("Image cropped successfully") // Debugging log
            }
        }
        
        // Called when cropping fails
        func cropViewControllerDidFailToCrop(
            _ cropViewController: Mantis.CropViewController,
            original: UIImage
        ) {
            DispatchQueue.main.async {
                self.parent.isPresented = false // Dismiss cropper if fail
                print("Failed to crop image") // Debugging log
            }
        }
        
        // Called when the user cancels cropping
        func cropViewControllerDidCancel(
            _ cropViewController: Mantis.CropViewController,
            original: UIImage
        ) {
            DispatchQueue.main.async {
                self.parent.isPresented = false // Dismiss cropper
                print("User canceled cropping") // Debugging log
            }
        }
        
        // Called when resizing starts
        func cropViewControllerDidBeginResize(_ cropViewController: Mantis.CropViewController) {
            print("User started resizing the crop area") // Debugging log
        }
        
        // Called when resizing ends
        func cropViewControllerDidEndResize(
            _ cropViewController: Mantis.CropViewController,
            original: UIImage,
            cropInfo: Mantis.CropInfo
        ) {
            print("User finished resizing the crop area") // Debugging log
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> Mantis.CropViewController {
        let cropViewController = Mantis.cropViewController(image: image)
        cropViewController.delegate = context.coordinator // Set the coordinator as delegate
        return cropViewController
    }
    
    func updateUIViewController(_ uiViewController: Mantis.CropViewController, context: Context) {}
}


#Preview {
    ShopDetailsPlayerView(playerRoomCode: "ABCDEF", roundNumber: 4)
}

