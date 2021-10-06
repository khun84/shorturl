class ShortUrlClickStats < ApplicationQuery
  attr_reader :user_id, :since, :untill

  # @param [Integer] user_id
  def initialize(user_id: nil, **args)
    @user_id = user_id
    @since = args[:since] || 1.day.ago
    @untill = args[:until] || 1.day.ago
  end

  # should containt [short_url, original_url, original_url_title]
  def results
    Url.find_by_sql(sql.to_sql)
  end

  def sql
    click_tbl.join(
      url_tbl
    ).on(
      click_tbl[:original_url_id].eq(url_tbl[:id]).and(
        user_filter
      )
    ).where(
      click_tbl[:created_at].gteq(since).and(
        click_tbl[:created_at].lt(untill)
      )
    ).group(
      click_tbl[:url_hash],
      url_tbl[:original_url],
      url_tbl[:title]
    ).project(
      click_tbl[:url_hash],
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

  def user_filter
    user_id.present? ? url_tbl[:user_id].eq(user_id) : Arel.sql('true')
  end
end
