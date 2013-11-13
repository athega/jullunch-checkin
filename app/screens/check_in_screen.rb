class CheckInScreen < PM::Screen
  attr_accessor :guest

  def on_present
    @view_setup ||= self.set_up_view
  end

  def set_up_view
    set_attributes self.view, {
      background_color: UIColor.whiteColor
    }
    true
  end

  def on_load
    self.title = @guest.name
    setup_image_picker
  end

  def setup_image_picker
    @image_picker = UIImagePickerController.alloc.init
    @image_picker.delegate = self
    @image_picker.sourceType = UIImagePickerControllerSourceTypeCamera
    @image_picker.cameraDevice = UIImagePickerControllerCameraDeviceFront
    @image_picker.cameraOverlayView = create_overlay_view
    @image_picker.showsCameraControls = false
    presentModalViewController(@image_picker, animated:false)
  end

  def create_overlay_view
    overlay = UIView.alloc.init
    overlay.frame = @image_picker.cameraOverlayView.frame
    toolbar = UIToolbar.alloc.initWithFrame([[0, Device.screen.height - 40], [Device.screen.width, 40]])

    space = create_toolbar_space
    check_in_button = create_toolbar_button("Checka in", :take_picture)
    switch_camera_button = create_toolbar_button("Switch camera", :switch_camera)

    toolbar.setItems([switch_camera_button, space, check_in_button], animated: false)
    toolbar.setBarStyle(UIBarStyleBlackOpaque)

    overlay.addSubview(toolbar)
    overlay
  end

  def create_toolbar_button(title, callback)
     UIBarButtonItem.alloc.init.initWithTitle(title,
                                              style:UIBarButtonItemStyleBordered,
                                              target: self, action: callback)
  end

  def create_toolbar_space
    space = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemFlexibleSpace, target: nil, action: nil)
  end

  def imagePickerController(picker, didFinishPickingMediaWithInfo:info)
    image = info[:UIImagePickerControllerOriginalImage]
    meta_data = info[:UIImagePickerControllerMediaMetadata]
    orientation = meta_data[:Orientation]
    Dispatch::Queue.concurrent.async do
      features = FeatureFinder.find_features(image)
      client = HttpClient.new
      client.upload_image(image, orientation, features)
    end
    check_in
    self.dismissModalViewControllerAnimated(false)
  end

  def take_picture
    @image_picker.takePicture
  end

  def switch_camera
    if @image_picker.cameraDevice == UIImagePickerControllerCameraDeviceFront
      @image_picker.cameraDevice = UIImagePickerControllerCameraDeviceRear
    else
      @image_picker.cameraDevice = UIImagePickerControllerCameraDeviceFront
    end
  end

  def save_to_camera_roll(savingImage)
    library = ALAssetsLibrary.alloc.init
    library.writeImageToSavedPhotosAlbum(savingImage.CGImage,
                                         orientation:ALAssetOrientationUp,
                                         completionBlock: lambda do |assetURL, error|
      if error
        alert = UIAlertView.alloc.init
        alert.title = "Error When Saving Picture"
        alert.message = error.localizedDescription
        alert.addButtonWithTitle('OK')
        alert.show
      end
    end)
  end

  def check_in
    client = HttpClient.new
    show_check
    client.check_in(@guest) do |response|
      open HomeScreen.new(nav_bar: true), close_all: true
    end
  end

  def show_check
    check_image = UIImage.imageNamed("check-icon.png")
    check_image_view = UIImageView.alloc.initWithImage(check_image)
    check_image_view.setCenter([Device.screen.width/2, Device.screen.height/2])
    self.view.addSubview(check_image_view)
  end
end
