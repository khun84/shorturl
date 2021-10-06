class ShortUrlClickStats < ApplicationQuery
  attr_reader :user_id, :since, :untill, :include_zero

  # @param [Integer] user_id
  # @param [Hash] args
  #   @option [Time] since Default is 1 day ago
  #   @option [Time] until Default is current time
  #   @option [Boolean] include_zero Default TRUE. Will not return zero count click if FALSE
  def initialize(user_id: nil, **args)
    @user_id = user_id
    @since = args[:since] || 1.day.ago
    @untill = args[:until] || Time.current
    @include_zero = args[:include_zero].nil? ? true : args[:include_zero]
  end

  def results
    Url.find_by_sql(sql.to_sql)
  end

  def sql
    short_url_tbl.join(
      url_tbl
    ).on(
      short_url_tbl[:url_id].eq(url_tbl[:id])
    ).join(
      click_tbl, include_zero ? Arel::Nodes::OuterJoin : Arel::Nodes::InnerJoin
    ).on(
      click_tbl[:original_url_id].eq(url_tbl[:id]).and(
        click_tbl[:created_at].gteq(since).and(
          click_tbl[:created_at].lt(untill)
        )
      )
    ).where(user_filter).group(
      short_url_tbl[:url_hash],
      url_tbl[:original_url],
      url_tbl[:title]
    ).project(
      short_url_tbl[:url_hash],
      url_tbl[:original_url],
      url_tbl[:title],
      click_tbl[:id].count.as('click_count')
    )
  end

  private

  def url_tbl
    @url_tbl ||= Url.arel_table
  end

  def click_tbl
    @click_tbl ||= UrlClick.arel_table
  end

  def short_url_tbl
    @short_url_tbl ||= ShortUrl.arel_table
  end

  def user_filter
    user_id.present? ? url_tbl[:user_id].eq(user_id) : Arel.sql('true')
  end
end
