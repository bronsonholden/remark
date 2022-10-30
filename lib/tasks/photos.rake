namespace :photos do
  desc "Photo recognition"
  task recognition: :environment do
    Photo.where(recognition: nil).each do |photo|
      Photos::RecognitionJob.perform_later(photo)
    end
  end

  desc "Regenerate all photo derivatives"
  task regenerate_derivatives: :environment do
    Photo.all.in_batches do |photos|
      photos.each { |photo| Photos::CreateDerivativesJob.perform_now(photo, force: true) }
    end
  end
end
