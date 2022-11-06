module HasRemarkSearch
  extend ActiveSupport::Concern
  extend Pagy::Backend

  included do
    def remark_search(params)
      item_count = 10
      @page = params.fetch(:page, 1)
      @search = params[:search]
      @search_id = params[:search_id]
      @similar = params[:similar]
      @similar_remark = Remark.find(@similar) if @similar.present?
      @user_id = params[:user_id]
      where = {
        user_id: @user_id,
        id: ({ not: @similar } if @similar.present?)
      }.compact_blank
      scope = if @search.present? || @similar.present?
        if @similar_remark&.similarity_input&.blank?
          Remark.none
        else
          results = Remark.search(
            @search,
            where: where,
            similar: @similar_remark&.similarity_input,
            page: @page,
            per_page: item_count,
            operator: "or",
            boost_where: {
              sentiment: @similar_remark&.nlp&.fetch("sentiment", nil)
            }.compact_blank,
            fields: [
              {author: :word},
              {conversions: :word},
              {content: :word_start},
              {key_phrases: :word_start},
              {"photo_recognition.label": :word},
              "reactions.user.name"
            ].compact_blank,
            track: @page == 1 && @similar.blank?,
            misspellings: {
              fields: [
                "conversions",
                "content"
              ]
            },
            debug: false
          )
          @search_id ||= results.search.id if @similar.blank?
          @debug = results
          results
        end
      else
        _, scope = pagy_countless(
          Remark.includes(:user).where({
            user_id: @user_id
          }.compact_blank).order(created_at: :desc),
          items: item_count
        )
        scope
      end
      @remarks = scope.take(item_count)
      @next_page = @page.to_i + 1
      @next_params = {
        user_id: @user_id,
        page: @next_page,
        search: @search,
        search_id: @search_id,
        similar: @similar
      }.compact
      @has_more = @next_page.present? && @remarks.count == item_count
    end
  end
end
