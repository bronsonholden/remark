class Photos::RecognitionJob < ApplicationJob
  queue_as :photos

  def perform(photo)
    return unless photo.image(:converted).present?
    credentials = Aws::Credentials.new(
      Rails.application.secrets.aws_access_key_id,
      Rails.application.secrets.aws_secret_access_key
    )
    rekognition = Aws::Rekognition::Client.new(
      region: "us-east-1",
      credentials: credentials
    )
    key = "#{photo.image(:converted_png).storage.prefix}/#{photo.image(:converted_png).id}"
    res = rekognition.detect_labels({
      image: {
        s3_object: {
          bucket: Rails.application.secrets.aws_s3_bucket,
          name: key,
        },
      },
      max_labels: 50,
      min_confidence: 70,
    })
    photo.update!(recognition: res.to_h)
  end
end
