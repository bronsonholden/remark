namespace :photos do
  desc "Photo recognition"
  task recognition: :environment do
    Photo.where(recognition: nil).each do |photo|
      Photos::RecognitionJob.perform_later(photo)
    end
  end
end
