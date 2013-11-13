class FeatureFinder
  PHOTOS_EXIF_0ROW_TOP_0COL_LEFT          = 1 #   1  =  0th row is at the top, and 0th column is on the left (THE DEFAULT).
  PHOTOS_EXIF_0ROW_TOP_0COL_RIGHT         = 2 #   2  =  0th row is at the top, and 0th column is on the right.
  PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT      = 3 #   3  =  0th row is at the bottom, and 0th column is on the right.
  PHOTOS_EXIF_0ROW_BOTTOM_0COL_LEFT       = 4 #   4  =  0th row is at the bottom, and 0th column is on the left.
  PHOTOS_EXIF_0ROW_LEFT_0COL_TOP          = 5 #   5  =  0th row is on the left, and 0th column is the top.
  PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP         = 6 #   6  =  0th row is on the right, and 0th column is the top.
  PHOTOS_EXIF_0ROW_RIGHT_0COL_BOTTOM      = 7 #   7  =  0th row is on the right, and 0th column is the bottom.
  PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM       = 8 #   8  =  0th row is on the left, and 0th column is the bottom.

  def self.find_features(image)
      options = NSDictionary.dictionaryWithObject(CIDetectorAccuracyHigh, forKey:CIDetectorAccuracy)
      detector = CIDetector.detectorOfType(CIDetectorTypeFace, context:nil, options:options)

      NSLog("About to scale image")
      #image = image.scale_to [600, 600]

      NSLog("New size of image width: #{image.size.width} y: #{image.size.height}")

      current_device_orientation = UIDevice.currentDevice.orientation
      NSLog("#{current_device_orientation}")

      case current_device_orientation
      when UIDeviceOrientationPortraitUpsideDown  # Device oriented vertically, home button on the top
        NSLog("Upside down")
        exif_orientation = PHOTOS_EXIF_0ROW_LEFT_0COL_BOTTOM;
      when UIDeviceOrientationLandscapeLeft       # Device oriented horizontally, home button on the right
        NSLog("Landscape left")
        exif_orientation  = PHOTOS_EXIF_0ROW_BOTTOM_0COL_RIGHT;
      when UIDeviceOrientationLandscapeRight      # Device oriented horizontally, home button on the left
        NSLog("Landscape right")
        exif_orientation = PHOTOS_EXIF_0ROW_TOP_0COL_LEFT;
      else
        NSLog("Default")
        exif_orientation = PHOTOS_EXIF_0ROW_RIGHT_0COL_TOP;
      end

      image_options = NSDictionary.dictionaryWithObject(NSNumber.numberWithInt(exif_orientation), forKey:CIDetectorImageOrientation)
      ci_image = CIImage.alloc.initWithImage(image)

      features = detector.featuresInImage(ci_image, options: image_options)

      features.map do |feature|
        result = {}
        if feature.hasLeftEyePosition
          result[:left_eye_x] = feature.leftEyePosition.x
          result[:left_eye_y] = feature.leftEyePosition.y
        end
        if feature.hasRightEyePosition
          result[:right_eye_x] = feature.rightEyePosition.x
          result[:right_eye_y] = feature.rightEyePosition.y
        end
        if feature.hasMouthPosition
          result[:mouth_x] = feature.mouthPosition.x
          result[:mouth_y] = feature.mouthPosition.y
        end
        result
      end
  end
end
