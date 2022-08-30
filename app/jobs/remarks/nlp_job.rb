# Natural language processing (NLP) for remarks using AWS Comprehend
class Remarks::NlpJob < ApplicationJob
  queue_as :remarks

  def perform(remark)
    return if remark.content.blank?

    credentials = Aws::Credentials.new(
      Rails.application.secrets.aws_access_key_id,
      Rails.application.secrets.aws_secret_access_key
    )
    comprehend = Aws::Comprehend::Client.new(
      region: "us-east-1",
      credentials: credentials
    )
    content = remark.content
    input = {
      text: remark.content,
      language_code: "en"
    }
    results = Hash.new.merge(
      comprehend.detect_sentiment(input).to_h,
      comprehend.detect_key_phrases(input).to_h,
      comprehend.detect_entities(input).to_h,
      comprehend.detect_syntax(input).to_h
    )
    remark.update(nlp: results)
  end
end
